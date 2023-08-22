
{*******************************************************}
{                                                       }
{       Borland Delphi Run-time Library                 }
{       Win32 Internet API Interface Unit               }
{                                                       }
{       Copyright (c) 1985-1999, Microsoft Corporation  }
{                                                       }
{       Translator: Borland Software Corporation        }
{                                                       }
{*******************************************************}

unit WinInet;

{$WEAKPACKAGEUNIT}

interface

uses Windows;

{ Contains manifests, functions, types and prototypes for 
  Microsoft Windows Internet Extensions }


{ internet types }

{$HPPEMIT '#include <wininet.h>'}

type
  HINTERNET = Pointer; 
  {$EXTERNALSYM HINTERNET}
  PHINTERNET = ^HINTERNET;
  LPHINTERNET = PHINTERNET; 
  {$EXTERNALSYM LPHINTERNET}

  INTERNET_PORT = Word; 
  {$EXTERNALSYM INTERNET_PORT}
  PINTERNET_PORT = ^INTERNET_PORT;
  LPINTERNET_PORT = PINTERNET_PORT; 
  {$EXTERNALSYM LPINTERNET_PORT}

{ Internet APIs }

{ manifests }

const
  INTERNET_INVALID_PORT_NUMBER = 0;                 { use the protocol-specific default }
  {$EXTERNALSYM INTERNET_INVALID_PORT_NUMBER}
  INTERNET_DEFAULT_FTP_PORT = 21;                   { default for FTP servers }
  {$EXTERNALSYM INTERNET_DEFAULT_FTP_PORT}
  INTERNET_DEFAULT_GOPHER_PORT = 70;                {    "     "  gopher " }
  {$EXTERNALSYM INTERNET_DEFAULT_GOPHER_PORT}
  INTERNET_DEFAULT_HTTP_PORT = 80;                  {    "     "  HTTP   " }
  {$EXTERNALSYM INTERNET_DEFAULT_HTTP_PORT}
  INTERNET_DEFAULT_HTTPS_PORT = 443;                {    "     "  HTTPS  " }
  {$EXTERNALSYM INTERNET_DEFAULT_HTTPS_PORT}
  INTERNET_DEFAULT_SOCKS_PORT = 1080;               { default for SOCKS firewall servers.}
  {$EXTERNALSYM INTERNET_DEFAULT_SOCKS_PORT}

  MAX_CACHE_ENTRY_INFO_SIZE = 4096;
  {$EXTERNALSYM MAX_CACHE_ENTRY_INFO_SIZE}


{ maximum field lengths (arbitrary) }

  INTERNET_MAX_HOST_NAME_LENGTH = 256;
  {$EXTERNALSYM INTERNET_MAX_HOST_NAME_LENGTH}
  INTERNET_MAX_USER_NAME_LENGTH = 128;
  {$EXTERNALSYM INTERNET_MAX_USER_NAME_LENGTH}
  INTERNET_MAX_PASSWORD_LENGTH = 128;
  {$EXTERNALSYM INTERNET_MAX_PASSWORD_LENGTH}
  INTERNET_MAX_PORT_NUMBER_LENGTH = 5;              { INTERNET_PORT is unsigned short }
  {$EXTERNALSYM INTERNET_MAX_PORT_NUMBER_LENGTH}
  INTERNET_MAX_PORT_NUMBER_VALUE = 65535;           { maximum unsigned short value }
  {$EXTERNALSYM INTERNET_MAX_PORT_NUMBER_VALUE}
  INTERNET_MAX_PATH_LENGTH = 2048;
  {$EXTERNALSYM INTERNET_MAX_PATH_LENGTH}
  INTERNET_MAX_SCHEME_LENGTH = 32;                   { longest protocol name length }
  {$EXTERNALSYM INTERNET_MAX_SCHEME_LENGTH}
  INTERNET_MAX_PROTOCOL_NAME = 'gopher';            { longest protocol name }
  {$EXTERNALSYM INTERNET_MAX_PROTOCOL_NAME}
  INTERNET_MAX_URL_LENGTH = ((SizeOf(INTERNET_MAX_PROTOCOL_NAME) - 1)
                            + SizeOf('://')
                            + INTERNET_MAX_PATH_LENGTH);
  {$EXTERNALSYM INTERNET_MAX_URL_LENGTH}

{ values returned by InternetQueryOption with INTERNET_OPTION_KEEP_CONNECTION: }

  INTERNET_KEEP_ALIVE_UNKNOWN = -1;
  {$EXTERNALSYM INTERNET_KEEP_ALIVE_UNKNOWN}
  INTERNET_KEEP_ALIVE_ENABLED = 1;
  {$EXTERNALSYM INTERNET_KEEP_ALIVE_ENABLED}
  INTERNET_KEEP_ALIVE_DISABLED = 0;
  {$EXTERNALSYM INTERNET_KEEP_ALIVE_DISABLED}

{ flags returned by InternetQueryOption with INTERNET_OPTION_REQUEST_FLAGS }

  INTERNET_REQFLAG_FROM_CACHE   = $00000001;
  {$EXTERNALSYM INTERNET_REQFLAG_FROM_CACHE}
  INTERNET_REQFLAG_ASYNC        = $00000002;
  {$EXTERNALSYM INTERNET_REQFLAG_ASYNC}
  INTERNET_REQFLAG_VIA_PROXY    = $00000004;  { request was made via a proxy }
  {$EXTERNALSYM INTERNET_REQFLAG_VIA_PROXY}
  INTERNET_REQFLAG_NO_HEADERS   = $00000008;  { orginal response contained no headers }
  {$EXTERNALSYM INTERNET_REQFLAG_NO_HEADERS}
  INTERNET_REQFLAG_PASSIVE      = $00000010;  { FTP: passive-mode connection }
  {$EXTERNALSYM INTERNET_REQFLAG_PASSIVE}
  INTERNET_REQFLAG_CACHE_WRITE_DISABLED = $00000040;  { HTTPS: this request not cacheable }
  {$EXTERNALSYM INTERNET_REQFLAG_CACHE_WRITE_DISABLED}

{ flags common to open functions (not InternetOpen): }

  INTERNET_FLAG_RELOAD = $80000000;                 { retrieve the original item }
  {$EXTERNALSYM INTERNET_FLAG_RELOAD}

{ flags for InternetOpenUrl: }

  INTERNET_FLAG_RAW_DATA = $40000000;               { receive the item as raw data }
  {$EXTERNALSYM INTERNET_FLAG_RAW_DATA}
  INTERNET_FLAG_EXISTING_CONNECT = $20000000;       { do not create new connection object }
  {$EXTERNALSYM INTERNET_FLAG_EXISTING_CONNECT}

{ flags for InternetOpen: }

  INTERNET_FLAG_ASYNC = $10000000;                  { this request is asynchronous (where supported) }
  {$EXTERNALSYM INTERNET_FLAG_ASYNC}

{ protocol-specific flags: }

  INTERNET_FLAG_PASSIVE = $08000000;                { used for FTP connections }
  {$EXTERNALSYM INTERNET_FLAG_PASSIVE}

{ additional cache flags }

  INTERNET_FLAG_NO_CACHE_WRITE        = $04000000;  { don't write this item to the cache }
  {$EXTERNALSYM INTERNET_FLAG_NO_CACHE_WRITE}
  INTERNET_FLAG_DONT_CACHE            = INTERNET_FLAG_NO_CACHE_WRITE;
  {$EXTERNALSYM INTERNET_FLAG_DONT_CACHE}
  INTERNET_FLAG_MAKE_PERSISTENT       = $02000000;  { make this item persistent in cache }
  {$EXTERNALSYM INTERNET_FLAG_MAKE_PERSISTENT}
  INTERNET_FLAG_FROM_CACHE            = $01000000;  { use offline semantics }
  {$EXTERNALSYM INTERNET_FLAG_FROM_CACHE}
  INTERNET_FLAG_OFFLINE               = $01000000;  { use offline semantics }
  {$EXTERNALSYM INTERNET_FLAG_OFFLINE}

{ additional flags }

  INTERNET_FLAG_SECURE                = $00800000;  { use PCT/SSL if applicable (HTTP) }
  {$EXTERNALSYM INTERNET_FLAG_SECURE}
  INTERNET_FLAG_KEEP_CONNECTION       = $00400000;  { use keep-alive semantics }
  {$EXTERNALSYM INTERNET_FLAG_KEEP_CONNECTION}
  INTERNET_FLAG_NO_AUTO_REDIRECT      = $00200000;  { don't handle redirections automatically }
  {$EXTERNALSYM INTERNET_FLAG_NO_AUTO_REDIRECT}
  INTERNET_FLAG_READ_PREFETCH         = $00100000;  { do background read prefetch }
  {$EXTERNALSYM INTERNET_FLAG_READ_PREFETCH}
  INTERNET_FLAG_NO_COOKIES            = $00080000;  { no automatic cookie handling }
  {$EXTERNALSYM INTERNET_FLAG_NO_COOKIES}
  INTERNET_FLAG_NO_AUTH               = $00040000;  { no automatic authentication handling }
  {$EXTERNALSYM INTERNET_FLAG_NO_AUTH}
  INTERNET_FLAG_CACHE_IF_NET_FAIL     = $00010000;  { return cache file if net request fails }
  {$EXTERNALSYM INTERNET_FLAG_CACHE_IF_NET_FAIL}

{ Security Ignore Flags, Allow HttpOpenRequest to overide
  Secure Channel (SSL/PCT) failures of the following types. }

  INTERNET_FLAG_IGNORE_CERT_CN_INVALID        = $00001000; { bad common name in X509 Cert. }
  {$EXTERNALSYM INTERNET_FLAG_IGNORE_CERT_CN_INVALID}
  INTERNET_FLAG_IGNORE_CERT_DATE_INVALID      = $00002000; { expired X509 Cert. }
  {$EXTERNALSYM INTERNET_FLAG_IGNORE_CERT_DATE_INVALID}
  INTERNET_FLAG_IGNORE_REDIRECT_TO_HTTPS      = $00004000; { ex: http:// to https:// }
  {$EXTERNALSYM INTERNET_FLAG_IGNORE_REDIRECT_TO_HTTPS}
  INTERNET_FLAG_IGNORE_REDIRECT_TO_HTTP       = $00008000; { ex: https:// to http:// }
  {$EXTERNALSYM INTERNET_FLAG_IGNORE_REDIRECT_TO_HTTP}

//
// more caching flags
//

  INTERNET_FLAG_RESYNCHRONIZE     = $00000800;  // asking wininet to update an item if it is newer
  {$EXTERNALSYM INTERNET_FLAG_RESYNCHRONIZE}
  INTERNET_FLAG_HYPERLINK         = $00000400;  // asking wininet to do hyperlinking semantic which works right for scripts
  {$EXTERNALSYM INTERNET_FLAG_HYPERLINK}
  INTERNET_FLAG_NO_UI             = $00000200;  // no cookie popup
  {$EXTERNALSYM INTERNET_FLAG_NO_UI}
  INTERNET_FLAG_PRAGMA_NOCACHE    = $00000100;  // asking wininet to add "pragma: no-cache"
  {$EXTERNALSYM INTERNET_FLAG_PRAGMA_NOCACHE}
  INTERNET_FLAG_CACHE_ASYNC       = $00000080;  // ok to perform lazy cache-write
  {$EXTERNALSYM INTERNET_FLAG_CACHE_ASYNC}
  INTERNET_FLAG_FORMS_SUBMIT      = $00000040;  // this is a forms submit
  {$EXTERNALSYM INTERNET_FLAG_FORMS_SUBMIT}
  INTERNET_FLAG_NEED_FILE         = $00000010;  // need a file for this request
  {$EXTERNALSYM INTERNET_FLAG_NEED_FILE}
  INTERNET_FLAG_MUST_CACHE_REQUEST = INTERNET_FLAG_NEED_FILE;
  {$EXTERNALSYM INTERNET_FLAG_MUST_CACHE_REQUEST}  

{ FTP }

{ manifests }
const
{ flags for FTP }
  FTP_TRANSFER_TYPE_UNKNOWN   = $00000000;
  {$EXTERNALSYM FTP_TRANSFER_TYPE_UNKNOWN}
  FTP_TRANSFER_TYPE_ASCII     = $00000001;
  {$EXTERNALSYM FTP_TRANSFER_TYPE_ASCII}
  FTP_TRANSFER_TYPE_BINARY    = $00000002;
  {$EXTERNALSYM FTP_TRANSFER_TYPE_BINARY}

  FTP_TRANSFER_TYPE_MASK      = FTP_TRANSFER_TYPE_ASCII or
                                FTP_TRANSFER_TYPE_BINARY;
  {$EXTERNALSYM FTP_TRANSFER_TYPE_MASK}

  INTERNET_FLAG_TRANSFER_ASCII        = FTP_TRANSFER_TYPE_ASCII;
  {$EXTERNALSYM INTERNET_FLAG_TRANSFER_ASCII}
  INTERNET_FLAG_TRANSFER_BINARY       = FTP_TRANSFER_TYPE_BINARY;
  {$EXTERNALSYM INTERNET_FLAG_TRANSFER_BINARY}

{ flags field masks }

  SECURITY_INTERNET_MASK      = INTERNET_FLAG_IGNORE_CERT_CN_INVALID or
                                INTERNET_FLAG_IGNORE_CERT_DATE_INVALID or
                                INTERNET_FLAG_IGNORE_REDIRECT_TO_HTTPS or
                                INTERNET_FLAG_IGNORE_REDIRECT_TO_HTTP;
  {$EXTERNALSYM SECURITY_INTERNET_MASK}

  SECURITY_SET_MASK           = SECURITY_INTERNET_MASK;
  {$EXTERNALSYM SECURITY_SET_MASK}

  INTERNET_FLAGS_MASK         = INTERNET_FLAG_RELOAD              or
                                INTERNET_FLAG_RAW_DATA            or
                                INTERNET_FLAG_EXISTING_CONNECT    or
                                INTERNET_FLAG_ASYNC               or
                                INTERNET_FLAG_PASSIVE             or
                                INTERNET_FLAG_NO_CACHE_WRITE      or
                                INTERNET_FLAG_MAKE_PERSISTENT     or
                                INTERNET_FLAG_FROM_CACHE          or
                                INTERNET_FLAG_SECURE              or
                                INTERNET_FLAG_KEEP_CONNECTION     or
                                INTERNET_FLAG_NO_AUTO_REDIRECT    or
                                INTERNET_FLAG_READ_PREFETCH       or
                                INTERNET_FLAG_NO_COOKIES          or
                                INTERNET_FLAG_NO_AUTH             or
                                INTERNET_FLAG_CACHE_IF_NET_FAIL   or
                                SECURITY_INTERNET_MASK            or
                                INTERNET_FLAG_RESYNCHRONIZE       or
                                INTERNET_FLAG_HYPERLINK           or
                                INTERNET_FLAG_NO_UI               or
                                INTERNET_FLAG_PRAGMA_NOCACHE      or
                                INTERNET_FLAG_CACHE_ASYNC         or
                                INTERNET_FLAG_FORMS_SUBMIT        or
                                INTERNET_FLAG_NEED_FILE           or
                                INTERNET_FLAG_TRANSFER_BINARY     or
                                INTERNET_FLAG_TRANSFER_ASCII;
  {$EXTERNALSYM INTERNET_FLAGS_MASK}

  INTERNET_ERROR_MASK_INSERT_CDROM = $1;
  {$EXTERNALSYM INTERNET_ERROR_MASK_INSERT_CDROM}

  INTERNET_OPTIONS_MASK       =  not INTERNET_FLAGS_MASK;
  {$EXTERNALSYM INTERNET_OPTIONS_MASK}

//
// common per-API flags (new APIs)
//

  WININET_API_FLAG_ASYNC          = $00000001;  // force async operation
  {$EXTERNALSYM WININET_API_FLAG_ASYNC}
  WININET_API_FLAG_SYNC           = $00000004;  // force sync operation
  {$EXTERNALSYM WININET_API_FLAG_SYNC}
  WININET_API_FLAG_USE_CONTEXT    = $00000008;  // use value supplied in dwContext (even if 0)
  {$EXTERNALSYM WININET_API_FLAG_USE_CONTEXT}

{ INTERNET_NO_CALLBACK - if this value is presented as the dwContext parameter }
{ then no call-backs will be made for that API }

  INTERNET_NO_CALLBACK = 0;
  {$EXTERNALSYM INTERNET_NO_CALLBACK}

{ structures/types }

type
  PInternetScheme = ^TInternetScheme;
  TInternetScheme = Integer;
const
  INTERNET_SCHEME_PARTIAL = -2;
  {$EXTERNALSYM INTERNET_SCHEME_PARTIAL}
  INTERNET_SCHEME_UNKNOWN = -1;
  {$EXTERNALSYM INTERNET_SCHEME_UNKNOWN}
  INTERNET_SCHEME_DEFAULT = 0;
  {$EXTERNALSYM INTERNET_SCHEME_DEFAULT}
  INTERNET_SCHEME_FTP = 1;
  {$EXTERNALSYM INTERNET_SCHEME_FTP}
  INTERNET_SCHEME_GOPHER = 2;
  {$EXTERNALSYM INTERNET_SCHEME_GOPHER}
  INTERNET_SCHEME_HTTP = 3;
  {$EXTERNALSYM INTERNET_SCHEME_HTTP}
  INTERNET_SCHEME_HTTPS = 4;
  {$EXTERNALSYM INTERNET_SCHEME_HTTPS}
  INTERNET_SCHEME_FILE = 5;
  {$EXTERNALSYM INTERNET_SCHEME_FILE}
  INTERNET_SCHEME_NEWS = 6;
  {$EXTERNALSYM INTERNET_SCHEME_NEWS}
  INTERNET_SCHEME_MAILTO = 7;
  {$EXTERNALSYM INTERNET_SCHEME_MAILTO}
  INTERNET_SCHEME_FIRST = INTERNET_SCHEME_FTP;
  {$EXTERNALSYM INTERNET_SCHEME_FIRST}
  INTERNET_SCHEME_LAST = INTERNET_SCHEME_MAILTO;
  {$EXTERNALSYM INTERNET_SCHEME_LAST}

{ TInternetAsyncResult - this structure is returned to the application via }
{ the callback with INTERNET_STATUS_REQUEST_COMPLETE. It is not sufficient to }
{ just return the result of the async operation. If the API failed then the }
{ app cannot call GetLastError because the thread context will be incorrect. }
{ Both the value returned by the async API and any resultant error code are }
{ made available. The app need not check dwError if dwResult indicates that }
{ the API succeeded (in this case dwError will be ERROR_SUCCESS) }

type
  PInternetAsyncResult = ^TInternetAsyncResult;
  TInternetAsyncResult = packed record
    dwResult: DWORD; { the HINTERNET, DWORD or BOOL return code from an async API }
    dwError: DWORD; { dwError - the error code if the API failed }
  end;

  PInternetPrefetchStatus = ^TInternetPrefetchStatus;
  TInternetPrefetchStatus = packed record
    dwStatus: DWORD;  { dwStatus - status of download. See INTERNET_PREFETCH_ flags }
    dwSize: DWORD;    { dwSize - size of file downloaded so far }
  end;

const
{ INTERNET_PREFETCH_STATUS - dwStatus values }
  INTERNET_PREFETCH_PROGRESS      = 0;
  {$EXTERNALSYM INTERNET_PREFETCH_PROGRESS}
  INTERNET_PREFETCH_COMPLETE      = 1;
  {$EXTERNALSYM INTERNET_PREFETCH_COMPLETE}
  INTERNET_PREFETCH_ABORTED       = 2;
  {$EXTERNALSYM INTERNET_PREFETCH_ABORTED}

type
{ TInternetProxyInfo - structure supplied with INTERNET_OPTION_PROXY to get/ }
{ set proxy information on a InternetOpen handle }
  PInternetProxyInfo = ^INTERNET_PROXY_INFO;
  INTERNET_PROXY_INFO = record
    dwAccessType: DWORD;       { dwAccessType - INTERNET_OPEN_TYPE_DIRECT, INTERNET_OPEN_TYPE_PROXY, or }
    lpszProxy: LPCSTR;        { lpszProxy - proxy server list }
    lpszProxyBypass: LPCSTR;  { lpszProxyBypass - proxy bypass list }
  end;
  {$EXTERNALSYM INTERNET_PROXY_INFO}
  TInternetProxyInfo = INTERNET_PROXY_INFO;
  LPINTERNET_PROXY_INFO = PInternetProxyInfo;
  {$EXTERNALSYM LPINTERNET_PROXY_INFO}

{ INTERNET_VERSION_INFO - version information returned via }
{ InternetQueryOption(..., INTERNET_OPTION_VERSION, ...) }

  PInternetVersionInfo = ^INTERNET_VERSION_INFO;
  INTERNET_VERSION_INFO = record
    dwMajorVersion: DWORD;
    dwMinorVersion: DWORD;
  end;
  {$EXTERNALSYM INTERNET_VERSION_INFO}
  TInternetVersionInfo = INTERNET_VERSION_INFO;
  LPINTERNET_VERSION_INFO = PInternetVersionInfo;
  {$EXTERNALSYM LPINTERNET_VERSION_INFO}

{ HTTP_VERSION_INFO - query or set global HTTP version (1.0 or 1.1) }
  PHttpVersionInfo = ^HTTP_VERSION_INFO;
  HTTP_VERSION_INFO = record
    dwMajorVersion: DWORD;
    dwMinorVersion: DWORD;
  end;
  {$EXTERNALSYM HTTP_VERSION_INFO}
  THttpVersionInfo = HTTP_VERSION_INFO;
  LPHTTP_VERSION_INFO = PHttpVersionInfo;
  {$EXTERNALSYM LPHTTP_VERSION_INFO}

{ INTERNET_CONNECTED_INFO - information used to set the global connected state }

  PInternetConnectedInfo = ^INTERNET_CONNECTED_INFO;
  INTERNET_CONNECTED_INFO = record
      dwConnectedState: DWORD;     {dwConnectedState - new connected/disconnected state.}
      dwFlags: DWORD;              {dwFlags - flags controlling connected->disconnected (or disconnected-> }
                                   {connected) transition. See below}
  end;
  {$EXTERNALSYM INTERNET_CONNECTED_INFO}
  TInternetConnectedInfo = INTERNET_CONNECTED_INFO;
  LPINTERNET_CONNECTED_INFO = PInternetConnectedInfo;
  {$EXTERNALSYM LPINTERNET_CONNECTED_INFO}

{ flags for INTERNET_CONNECTED_INFO dwFlags }

{ ISO_FORCE_DISCONNECTED - if set when putting Wininet into disconnected mode, }
{ all outstanding requests will be aborted with a cancelled error }

const
  ISO_FORCE_DISCONNECTED  = $00000001;
  {$EXTERNALSYM ISO_FORCE_DISCONNECTED}

{ URL_COMPONENTS - the constituent parts of an URL. Used in InternetCrackUrl }
{ and InternetCreateUrl }

{ For InternetCrackUrl, if a pointer field and its corresponding length field }
{ are both 0 then that component is not returned; If the pointer field is NULL }
{ but the length field is not zero, then both the pointer and length fields are }
{ returned; if both pointer and corresponding length fields are non-zero then }
{ the pointer field points to a buffer where the component is copied. The }
{ component may be un-escaped, depending on dwFlags }

{ For InternetCreateUrl, the pointer fields should be nil if the component }
{ is not required. If the corresponding length field is zero then the pointer }
{ field is the address of a zero-terminated string. If the length field is not }
{ zero then it is the string length of the corresponding pointer field }

type
  PURLComponents = ^URL_COMPONENTS;
  URL_COMPONENTS = record
    dwStructSize: DWORD;        { size of this structure. Used in version check }
    lpszScheme: LPSTR;         { pointer to scheme name }
    dwSchemeLength: DWORD;      { length of scheme name }
    nScheme: TInternetScheme;    { enumerated scheme type (if known) }
    lpszHostName: LPSTR;       { pointer to host name }
    dwHostNameLength: DWORD;    { length of host name }
    nPort: INTERNET_PORT;       { converted port number }
    pad: WORD;                  { force correct allignment regardless of comp. flags}
    lpszUserName: LPSTR;       { pointer to user name }
    dwUserNameLength: DWORD;    { length of user name }
    lpszPassword: LPSTR;       { pointer to password }
    dwPasswordLength: DWORD;    { length of password }
    lpszUrlPath: LPSTR;        { pointer to URL-path }
    dwUrlPathLength: DWORD;     { length of URL-path }
    lpszExtraInfo: LPSTR;      { pointer to extra information (e.g. ?foo or #foo) }
    dwExtraInfoLength: DWORD;   { length of extra information }
  end;
  {$EXTERNALSYM URL_COMPONENTS}
  TURLComponents = URL_COMPONENTS;
  LPURL_COMPONENTS = PURLComponents;
  {$EXTERNALSYM LPURL_COMPONENTS}
  
{ TInternetCertificateInfo lpBuffer - contains the certificate returned from
  the server }

  PInternetCertificateInfo = ^INTERNET_CERTIFICATE_INFO;
  INTERNET_CERTIFICATE_INFO = record
    ftExpiry: TFileTime;             { ftExpiry - date the certificate expires. }
    ftStart: TFileTime;              { ftStart - date the certificate becomes valid. }
    lpszSubjectInfo: LPSTR;        { lpszSubjectInfo - the name of organization, site, and server }
                                    {   the cert. was issued for. }
    lpszIssuerInfo: LPSTR;         { lpszIssuerInfo - the name of orgainzation, site, and server }
                                    {   the cert was issues by. }
    lpszProtocolName: LPSTR;       { lpszProtocolName - the name of the protocol used to provide the secure }
                                    {   connection. }
    lpszSignatureAlgName: LPSTR;   { lpszSignatureAlgName - the name of the algorithm used for signing }
                                    {  the certificate. }
    lpszEncryptionAlgName: LPSTR;  { lpszEncryptionAlgName - the name of the algorithm used for }
                                    {  doing encryption over the secure channel (SSL/PCT) connection. }
    dwKeySize: DWORD;               { dwKeySize - size of the key. }
  end;
  {$EXTERNALSYM INTERNET_CERTIFICATE_INFO}
  TInternetCertificateInfo = INTERNET_CERTIFICATE_INFO;
  LPINTERNET_CERTIFICATE_INFO = pInternetCertificateInfo;
  {$EXTERNALSYM LPINTERNET_CERTIFICATE_INFO}

{ INTERNET_BUFFERS - combines headers and data. May be chained for e.g. file }
{ upload or scatter/gather operations. For chunked read/write, lpcszHeader }
{ contains the chunked-ext }
  PInternetBuffersA = ^INTERNET_BUFFERSA;
  PInternetBuffersW = ^INTERNET_BUFFERSW;
  PInternetBuffers = PInternetBuffersA;
  INTERNET_BUFFERSA = record
    dwStructSize: DWORD;      { used for API versioning. Set to sizeof(INTERNET_BUFFERS) }
    Next: PInternetBuffers;   { chain of buffers }
    lpcszHeader: PAnsiChar;       { pointer to headers (may be NULL) }
    dwHeadersLength: DWORD;   { length of headers if not NULL }
    dwHeadersTotal: DWORD;    { size of headers if not enough buffer }
    lpvBuffer: Pointer;       { pointer to data buffer (may be NULL) }
    dwBufferLength: DWORD;    { length of data buffer if not NULL }
    dwBufferTotal: DWORD;     { total size of chunk, or content-length if not chunked }
    dwOffsetLow: DWORD;       { used for read-ranges (only used in HttpSendRequest2) }
    dwOffsetHigh: DWORD;
  end;
  {$EXTERNALSYM INTERNET_BUFFERSA}
  TInternetBuffersA = INTERNET_BUFFERSA;
  LPINTERNET_BUFFERSA = PInternetBuffersA;
  {$EXTERNALSYM LPINTERNET_BUFFERSA}
  INTERNET_BUFFERSW = record
    dwStructSize: DWORD;      { used for API versioning. Set to sizeof(INTERNET_BUFFERS) }
    Next: PInternetBuffers;   { chain of buffers }
    lpcszHeader: PAnsiChar;       { pointer to headers (may be NULL) }
    dwHeadersLength: DWORD;   { length of headers if not NULL }
    dwHeadersTotal: DWORD;    { size of headers if not enough buffer }
    lpvBuffer: Pointer;       { pointer to data buffer (may be NULL) }
    dwBufferLength: DWORD;    { length of data buffer if not NULL }
    dwBufferTotal: DWORD;     { total size of chunk, or content-length if not chunked }
    dwOffsetLow: DWORD;       { used for read-ranges (only used in HttpSendRequest2) }
    dwOffsetHigh: DWORD;
  end;
  {$EXTERNALSYM INTERNET_BUFFERSW}
  TInternetBuffersW = INTERNET_BUFFERSW;
  LPINTERNET_BUFFERSW = PInternetBuffersW;
  {$EXTERNALSYM LPINTERNET_BUFFERSW}
  INTERNET_BUFFERS = INTERNET_BUFFERSA;
  
{ prototypes }

function InternetTimeFromSystemTime(const pst: TSystemTime;
  dwRFC: DWORD; lpszTime: LPSTR; cbTime: DWORD): BOOL; stdcall;
  {$EXTERNALSYM InternetTimeFromSystemTime}

const
{ constants for InternetTimeFromSystemTime }
  INTERNET_RFC1123_FORMAT         = 0;
  {$EXTERNALSYM INTERNET_RFC1123_FORMAT}
  INTERNET_RFC1123_BUFSIZE        = 30;
  {$EXTERNALSYM INTERNET_RFC1123_BUFSIZE}

function InternetCrackUrl(lpszUrl: PChar; dwUrlLength, dwFlags: DWORD;
  var lpUrlComponents: TURLComponents): BOOL; stdcall;
  {$EXTERNALSYM InternetCrackUrl}
function InternetCrackUrlA(lpszUrl: PAnsiChar; dwUrlLength, dwFlags: DWORD;
  var lpUrlComponents: TURLComponents): BOOL; stdcall;
  {$EXTERNALSYM InternetCrackUrlA}
function InternetCrackUrlW(lpszUrl: PWideChar; dwUrlLength, dwFlags: DWORD;
  var lpUrlComponents: TURLComponents): BOOL; stdcall;
  {$EXTERNALSYM InternetCrackUrlW}

function InternetCreateUrl(var lpUrlComponents: TURLComponents;
  dwFlags: DWORD; lpszUrl: PChar; var dwUrlLength: DWORD): BOOL; stdcall;
  {$EXTERNALSYM InternetCreateUrl}
function InternetCreateUrlA(var lpUrlComponents: TURLComponents;
  dwFlags: DWORD; lpszUrl: PAnsiChar; var dwUrlLength: DWORD): BOOL; stdcall;
  {$EXTERNALSYM InternetCreateUrlA}
function InternetCreateUrlW(var lpUrlComponents: TURLComponents;
  dwFlags: DWORD; lpszUrl: PWideChar; var dwUrlLength: DWORD): BOOL; stdcall;
  {$EXTERNALSYM InternetCreateUrlW}

function InternetCanonicalizeUrl(lpszUrl: PChar;
  lpszBuffer: PChar; var lpdwBufferLength: DWORD;
  dwFlags: DWORD): BOOL; stdcall;
  {$EXTERNALSYM InternetCanonicalizeUrl}
function InternetCanonicalizeUrlA(lpszUrl: PAnsiChar;
  lpszBuffer: PAnsiChar; var lpdwBufferLength: DWORD;
  dwFlags: DWORD): BOOL; stdcall;
  {$EXTERNALSYM InternetCanonicalizeUrlA}
function InternetCanonicalizeUrlW(lpszUrl: PWideChar;
  lpszBuffer: PWideChar; var lpdwBufferLength: DWORD;
  dwFlags: DWORD): BOOL; stdcall;
  {$EXTERNALSYM InternetCanonicalizeUrlW}

function InternetCombineUrl(lpszBaseUrl, lpszRelativeUrl: PChar;
  lpszBuffer: PChar; var lpdwBufferLength: DWORD;
  dwFlags: DWORD): BOOL; stdcall;
  {$EXTERNALSYM InternetCombineUrl}
function InternetCombineUrlA(lpszBaseUrl, lpszRelativeUrl: PAnsiChar;
  lpszBuffer: PAnsiChar; var lpdwBufferLength: DWORD;
  dwFlags: DWORD): BOOL; stdcall;
  {$EXTERNALSYM InternetCombineUrlA}
function InternetCombineUrlW(lpszBaseUrl, lpszRelativeUrl: PWideChar;
  lpszBuffer: PWideChar; var lpdwBufferLength: DWORD;
  dwFlags: DWORD): BOOL; stdcall;
  {$EXTERNALSYM InternetCombineUrlW}

const
{ flags for InternetCrackUrl and InternetCreateUrl }

  ICU_ESCAPE          = $80000000;  { (un)escape URL characters }
  {$EXTERNALSYM ICU_ESCAPE}
  ICU_USERNAME        = $40000000;  { use internal username & password }
  {$EXTERNALSYM ICU_USERNAME}

{ flags for InternetCanonicalizeUrl and InternetCombineUrl }

  ICU_NO_ENCODE       = $20000000;  { Don't convert unsafe characters to escape sequence }
  {$EXTERNALSYM ICU_NO_ENCODE}
  ICU_DECODE          = $10000000;  { Convert escape sequences to characters }
  {$EXTERNALSYM ICU_DECODE}
  ICU_NO_META         = $08000000;  { Don't convert .. etc. meta path sequences }
  {$EXTERNALSYM ICU_NO_META}
  ICU_ENCODE_SPACES_ONLY     = $04000000;  { Encode spaces only }
  {$EXTERNALSYM ICU_ENCODE_SPACES_ONLY}
  ICU_BROWSER_MODE    = $02000000;  { Special encode/decode rules for browser }
  {$EXTERNALSYM ICU_BROWSER_MODE}

function InternetOpen(lpszAgent: PChar; dwAccessType: DWORD; 
  lpszProxy, lpszProxyBypass: PChar; dwFlags: DWORD): HINTERNET; stdcall;
  {$EXTERNALSYM InternetOpen}
function InternetOpenA(lpszAgent: PAnsiChar; dwAccessType: DWORD; 
  lpszProxy, lpszProxyBypass: PAnsiChar; dwFlags: DWORD): HINTERNET; stdcall;
  {$EXTERNALSYM InternetOpenA}
function InternetOpenW(lpszAgent: PWideChar; dwAccessType: DWORD; 
  lpszProxy, lpszProxyBypass: PWideChar; dwFlags: DWORD): HINTERNET; stdcall;
  {$EXTERNALSYM InternetOpenW}

{ access types for InternetOpen }
const
  INTERNET_OPEN_TYPE_PRECONFIG        = 0;  { use registry configuration }
  {$EXTERNALSYM INTERNET_OPEN_TYPE_PRECONFIG}
  INTERNET_OPEN_TYPE_DIRECT           = 1;  { direct to net }
  {$EXTERNALSYM INTERNET_OPEN_TYPE_DIRECT}
  INTERNET_OPEN_TYPE_PROXY            = 3;  { via named proxy }
  {$EXTERNALSYM INTERNET_OPEN_TYPE_PROXY}
  INTERNET_OPEN_TYPE_PRECONFIG_WITH_NO_AUTOPROXY  = 4;   { prevent using java/script/INS }
  {$EXTERNALSYM INTERNET_OPEN_TYPE_PRECONFIG_WITH_NO_AUTOPROXY}

{ old names for access types }

  PRE_CONFIG_INTERNET_ACCESS      = INTERNET_OPEN_TYPE_PRECONFIG;
  {$EXTERNALSYM PRE_CONFIG_INTERNET_ACCESS}
  LOCAL_INTERNET_ACCESS           = INTERNET_OPEN_TYPE_DIRECT;
  {$EXTERNALSYM LOCAL_INTERNET_ACCESS}
  GATEWAY_INTERNET_ACCESS         = 2;  { Internet via gateway }
  {$EXTERNALSYM GATEWAY_INTERNET_ACCESS}
  CERN_PROXY_INTERNET_ACCESS      = INTERNET_OPEN_TYPE_PROXY;
  {$EXTERNALSYM CERN_PROXY_INTERNET_ACCESS}

function InternetCloseHandle(hInet: HINTERNET): BOOL; stdcall;
  {$EXTERNALSYM InternetCloseHandle}

function InternetConnect(hInet: HINTERNET; lpszServerName: PChar;
  nServerPort: INTERNET_PORT; lpszUsername: PChar; lpszPassword: PChar;
  dwService: DWORD; dwFlags: DWORD; dwContext: DWORD): HINTERNET; stdcall;
  {$EXTERNALSYM InternetConnect}
function InternetConnectA(hInet: HINTERNET; lpszServerName: PAnsiChar;
  nServerPort: INTERNET_PORT; lpszUsername: PAnsiChar; lpszPassword: PAnsiChar;
  dwService: DWORD; dwFlags: DWORD; dwContext: DWORD): HINTERNET; stdcall;
  {$EXTERNALSYM InternetConnectA}
function InternetConnectW(hInet: HINTERNET; lpszServerName: PWideChar;
  nServerPort: INTERNET_PORT; lpszUsername: PWideChar; lpszPassword: PWideChar;
  dwService: DWORD; dwFlags: DWORD; dwContext: DWORD): HINTERNET; stdcall;
  {$EXTERNALSYM InternetConnectW}

{ service types for InternetConnect }
const
  INTERNET_SERVICE_URL = 0;
  {$EXTERNALSYM INTERNET_SERVICE_URL}
  INTERNET_SERVICE_FTP = 1;
  {$EXTERNALSYM INTERNET_SERVICE_FTP}
  INTERNET_SERVICE_GOPHER = 2;
  {$EXTERNALSYM INTERNET_SERVICE_GOPHER}
  INTERNET_SERVICE_HTTP = 3;
  {$EXTERNALSYM INTERNET_SERVICE_HTTP}

function InternetOpenUrl(hInet: HINTERNET; lpszUrl: PChar;
  lpszHeaders: PChar; dwHeadersLength: DWORD; dwFlags: DWORD;
  dwContext: DWORD): HINTERNET; stdcall;
  {$EXTERNALSYM InternetOpenUrl}
function InternetOpenUrlA(hInet: HINTERNET; lpszUrl: PAnsiChar;
  lpszHeaders: PAnsiChar; dwHeadersLength: DWORD; dwFlags: DWORD;
  dwContext: DWORD): HINTERNET; stdcall;
  {$EXTERNALSYM InternetOpenUrlA}
function InternetOpenUrlW(hInet: HINTERNET; lpszUrl: PWideChar;
  lpszHeaders: PWideChar; dwHeadersLength: DWORD; dwFlags: DWORD;
  dwContext: DWORD): HINTERNET; stdcall;
  {$EXTERNALSYM InternetOpenUrlW}

function InternetReadFile(hFile: HINTERNET; lpBuffer: Pointer;
  dwNumberOfBytesToRead: DWORD; var lpdwNumberOfBytesRead: DWORD): BOOL; stdcall;
  {$EXTERNALSYM InternetReadFile}

function InternetReadFileEx(hFile: HINTERNET;  lpBuffersOut: Pointer;
  dwFlags: DWORD; dwContext: DWORD): BOOL; stdcall;
  {$EXTERNALSYM InternetReadFileEx}
function InternetReadFileExA(hFile: HINTERNET;  lpBuffersOut: Pointer;
  dwFlags: DWORD; dwContext: DWORD): BOOL; stdcall;
  {$EXTERNALSYM InternetReadFileExA}
function InternetReadFileExW(hFile: HINTERNET;  lpBuffersOut: Pointer;
  dwFlags: DWORD; dwContext: DWORD): BOOL; stdcall;
  {$EXTERNALSYM InternetReadFileExW}

{ flags for InternetReadFileEx() }
const
  IRF_ASYNC       = WININET_API_FLAG_ASYNC;
  {$EXTERNALSYM IRF_ASYNC}
  IRF_SYNC        = WININET_API_FLAG_SYNC;
  {$EXTERNALSYM IRF_SYNC}
  IRF_USE_CONTEXT = WININET_API_FLAG_USE_CONTEXT;
  {$EXTERNALSYM IRF_USE_CONTEXT}
  IRF_NO_WAIT     = $00000008;
  {$EXTERNALSYM IRF_NO_WAIT}

function InternetSetFilePointer(hFile: HINTERNET;
  lDistanceToMove: Longint; pReserved: Pointer;
  dwMoveMethod, dwContext: DWORD): DWORD; stdcall;
  {$EXTERNALSYM InternetSetFilePointer}

function InternetWriteFile(hFile: HINTERNET; lpBuffer: Pointer;
  dwNumberOfBytesToWrite: DWORD;
  var lpdwNumberOfBytesWritten: DWORD): BOOL; stdcall;
  {$EXTERNALSYM InternetWriteFile}

function InternetQueryDataAvailable(hFile: HINTERNET; var lpdwNumberOfBytesAvailable: DWORD;
  dwFlags, dwContext: DWORD): BOOL; stdcall;
  {$EXTERNALSYM InternetQueryDataAvailable}

function InternetFindNextFile(hFind: HINTERNET; lpvFindData: Pointer): BOOL; stdcall;
  {$EXTERNALSYM InternetFindNextFile}
function InternetFindNextFileA(hFind: HINTERNET; lpvFindData: Pointer): BOOL; stdcall;
  {$EXTERNALSYM InternetFindNextFileA}
function InternetFindNextFileW(hFind: HINTERNET; lpvFindData: Pointer): BOOL; stdcall;
  {$EXTERNALSYM InternetFindNextFileW}

function InternetQueryOption(hInet: HINTERNET; dwOption: DWORD;
  lpBuffer: Pointer; var lpdwBufferLength: DWORD): BOOL; stdcall;
  {$EXTERNALSYM InternetQueryOption}
function InternetQueryOptionA(hInet: HINTERNET; dwOption: DWORD;
  lpBuffer: Pointer; var lpdwBufferLength: DWORD): BOOL; stdcall;
  {$EXTERNALSYM InternetQueryOptionA}
function InternetQueryOptionW(hInet: HINTERNET; dwOption: DWORD;
  lpBuffer: Pointer; var lpdwBufferLength: DWORD): BOOL; stdcall;
  {$EXTERNALSYM InternetQueryOptionW}

function InternetSetOption(hInet: HINTERNET; dwOption: DWORD;
  lpBuffer: Pointer; dwBufferLength: DWORD): BOOL; stdcall;
  {$EXTERNALSYM InternetSetOption}
function InternetSetOptionA(hInet: HINTERNET; dwOption: DWORD;
  lpBuffer: Pointer; dwBufferLength: DWORD): BOOL; stdcall;
  {$EXTERNALSYM InternetSetOptionA}
function InternetSetOptionW(hInet: HINTERNET; dwOption: DWORD;
  lpBuffer: Pointer; dwBufferLength: DWORD): BOOL; stdcall;
  {$EXTERNALSYM InternetSetOptionW}

function InternetSetOptionEx(hInet: HINTERNET; dwOption: DWORD;
  lpBuffer: Pointer; dwBufferLength, dwFlags: DWORD): BOOL; stdcall;
  {$EXTERNALSYM InternetSetOptionEx}
function InternetSetOptionExA(hInet: HINTERNET; dwOption: DWORD;
  lpBuffer: Pointer; dwBufferLength, dwFlags: DWORD): BOOL; stdcall;
  {$EXTERNALSYM InternetSetOptionExA}
function InternetSetOptionExW(hInet: HINTERNET; dwOption: DWORD;
  lpBuffer: Pointer; dwBufferLength, dwFlags: DWORD): BOOL; stdcall;
  {$EXTERNALSYM InternetSetOptionExW}

function InternetLockRequestFile(hInternet: HINTERNET;
  lphLockRequestInfo: PHandle): BOOL; stdcall;
  {$EXTERNALSYM InternetLockRequestFile}

function InternetUnlockRequestFile(hLockRequestInfo: THANDLE): BOOL; stdcall;
  {$EXTERNALSYM InternetUnlockRequestFile}

{ flags for InternetSetOptionEx() }
const
  ISO_GLOBAL      = $00000001;  { modify option globally }
  {$EXTERNALSYM ISO_GLOBAL}
  ISO_REGISTRY    = $00000002;  { write option to registry (where applicable) }
  {$EXTERNALSYM ISO_REGISTRY}
  ISO_VALID_FLAGS = ISO_GLOBAL or ISO_REGISTRY;
  {$EXTERNALSYM ISO_VALID_FLAGS}

{ options manifests for Internet(Query or Set)Option }
const
  INTERNET_OPTION_CALLBACK = 1;
  {$EXTERNALSYM INTERNET_OPTION_CALLBACK}
  INTERNET_OPTION_CONNECT_TIMEOUT = 2;
  {$EXTERNALSYM INTERNET_OPTION_CONNECT_TIMEOUT}
  INTERNET_OPTION_CONNECT_RETRIES = 3;
  {$EXTERNALSYM INTERNET_OPTION_CONNECT_RETRIES}
  INTERNET_OPTION_CONNECT_BACKOFF = 4;
  {$EXTERNALSYM INTERNET_OPTION_CONNECT_BACKOFF}
  INTERNET_OPTION_SEND_TIMEOUT = 5;
  {$EXTERNALSYM INTERNET_OPTION_SEND_TIMEOUT}
  INTERNET_OPTION_CONTROL_SEND_TIMEOUT       = INTERNET_OPTION_SEND_TIMEOUT;
  {$EXTERNALSYM INTERNET_OPTION_CONTROL_SEND_TIMEOUT}
  INTERNET_OPTION_RECEIVE_TIMEOUT = 6;
  {$EXTERNALSYM INTERNET_OPTION_RECEIVE_TIMEOUT}
  INTERNET_OPTION_CONTROL_RECEIVE_TIMEOUT    = INTERNET_OPTION_RECEIVE_TIMEOUT;
  {$EXTERNALSYM INTERNET_OPTION_CONTROL_RECEIVE_TIMEOUT}
  INTERNET_OPTION_DATA_SEND_TIMEOUT = 7;
  {$EXTERNALSYM INTERNET_OPTION_DATA_SEND_TIMEOUT}
  INTERNET_OPTION_DATA_RECEIVE_TIMEOUT = 8;
  {$EXTERNALSYM INTERNET_OPTION_DATA_RECEIVE_TIMEOUT}
  INTERNET_OPTION_HANDLE_TYPE = 9;
  {$EXTERNALSYM INTERNET_OPTION_HANDLE_TYPE}
  INTERNET_OPTION_READ_BUFFER_SIZE = 12;
  {$EXTERNALSYM INTERNET_OPTION_READ_BUFFER_SIZE}
  INTERNET_OPTION_WRITE_BUFFER_SIZE = 13;
  {$EXTERNALSYM INTERNET_OPTION_WRITE_BUFFER_SIZE}
  INTERNET_OPTION_ASYNC_ID = 15;
  {$EXTERNALSYM INTERNET_OPTION_ASYNC_ID}
  INTERNET_OPTION_ASYNC_PRIORITY = 16;
  {$EXTERNALSYM INTERNET_OPTION_ASYNC_PRIORITY}
  INTERNET_OPTION_PARENT_HANDLE               = 21;
  {$EXTERNALSYM INTERNET_OPTION_PARENT_HANDLE}
  INTERNET_OPTION_KEEP_CONNECTION             = 22;
  {$EXTERNALSYM INTERNET_OPTION_KEEP_CONNECTION}
  INTERNET_OPTION_REQUEST_FLAGS               = 23;
  {$EXTERNALSYM INTERNET_OPTION_REQUEST_FLAGS}
  INTERNET_OPTION_EXTENDED_ERROR              = 24;
  {$EXTERNALSYM INTERNET_OPTION_EXTENDED_ERROR}
  INTERNET_OPTION_OFFLINE_MODE                = 26;
  {$EXTERNALSYM INTERNET_OPTION_OFFLINE_MODE}
  INTERNET_OPTION_CACHE_STREAM_HANDLE         = 27;
  {$EXTERNALSYM INTERNET_OPTION_CACHE_STREAM_HANDLE}
  INTERNET_OPTION_USERNAME                    = 28;
  {$EXTERNALSYM INTERNET_OPTION_USERNAME}
  INTERNET_OPTION_PASSWORD                    = 29;
  {$EXTERNALSYM INTERNET_OPTION_PASSWORD}
  INTERNET_OPTION_ASYNC                       = 30;
  {$EXTERNALSYM INTERNET_OPTION_ASYNC}
  INTERNET_OPTION_SECURITY_FLAGS              = 31;
  {$EXTERNALSYM INTERNET_OPTION_SECURITY_FLAGS}
  INTERNET_OPTION_SECURITY_CERTIFICATE_STRUCT = 32;
  {$EXTERNALSYM INTERNET_OPTION_SECURITY_CERTIFICATE_STRUCT}
  INTERNET_OPTION_DATAFILE_NAME               = 33;
  {$EXTERNALSYM INTERNET_OPTION_DATAFILE_NAME}
  INTERNET_OPTION_URL                         = 34;
  {$EXTERNALSYM INTERNET_OPTION_URL}
  INTERNET_OPTION_SECURITY_CERTIFICATE        = 35;
  {$EXTERNALSYM INTERNET_OPTION_SECURITY_CERTIFICATE}
  INTERNET_OPTION_SECURITY_KEY_BITNESS        = 36;
  {$EXTERNALSYM INTERNET_OPTION_SECURITY_KEY_BITNESS}
  INTERNET_OPTION_REFRESH                     = 37;
  {$EXTERNALSYM INTERNET_OPTION_REFRESH}
  INTERNET_OPTION_PROXY                       = 38;
  {$EXTERNALSYM INTERNET_OPTION_PROXY}
  INTERNET_OPTION_SETTINGS_CHANGED            = 39;
  {$EXTERNALSYM INTERNET_OPTION_SETTINGS_CHANGED}
  INTERNET_OPTION_VERSION                     = 40;
  {$EXTERNALSYM INTERNET_OPTION_VERSION}
  INTERNET_OPTION_USER_AGENT                  = 41;
  {$EXTERNALSYM INTERNET_OPTION_USER_AGENT}
  INTERNET_OPTION_END_BROWSER_SESSION         = 42;
  {$EXTERNALSYM INTERNET_OPTION_END_BROWSER_SESSION}
  INTERNET_OPTION_PROXY_USERNAME              = 43;
  {$EXTERNALSYM INTERNET_OPTION_PROXY_USERNAME}
  INTERNET_OPTION_PROXY_PASSWORD              = 44;
  {$EXTERNALSYM INTERNET_OPTION_PROXY_PASSWORD}
  INTERNET_OPTION_CONTEXT_VALUE               = 45;
  {$EXTERNALSYM INTERNET_OPTION_CONTEXT_VALUE}
  INTERNET_OPTION_CONNECT_LIMIT               = 46;
  {$EXTERNALSYM INTERNET_OPTION_CONNECT_LIMIT}
  INTERNET_OPTION_SECURITY_SELECT_CLIENT_CERT = 47;
  {$EXTERNALSYM INTERNET_OPTION_SECURITY_SELECT_CLIENT_CERT}
  INTERNET_OPTION_POLICY                      = 48;
  {$EXTERNALSYM INTERNET_OPTION_POLICY}
  INTERNET_OPTION_DISCONNECTED_TIMEOUT        = 49;
  {$EXTERNALSYM INTERNET_OPTION_DISCONNECTED_TIMEOUT}
  INTERNET_OPTION_CONNECTED_STATE             = 50;
  {$EXTERNALSYM INTERNET_OPTION_CONNECTED_STATE}
  INTERNET_OPTION_IDLE_STATE                  = 51;
  {$EXTERNALSYM INTERNET_OPTION_IDLE_STATE}
  INTERNET_OPTION_OFFLINE_SEMANTICS           = 52;
  {$EXTERNALSYM INTERNET_OPTION_OFFLINE_SEMANTICS}
  INTERNET_OPTION_SECONDARY_CACHE_KEY         = 53;
  {$EXTERNALSYM INTERNET_OPTION_SECONDARY_CACHE_KEY}
  INTERNET_OPTION_CALLBACK_FILTER             = 54;
  {$EXTERNALSYM INTERNET_OPTION_CALLBACK_FILTER}
  INTERNET_OPTION_CONNECT_TIME                = 55;
  {$EXTERNALSYM INTERNET_OPTION_CONNECT_TIME}
  INTERNET_OPTION_SEND_THROUGHPUT             = 56;
  {$EXTERNALSYM INTERNET_OPTION_SEND_THROUGHPUT}
  INTERNET_OPTION_RECEIVE_THROUGHPUT          = 57;
  {$EXTERNALSYM INTERNET_OPTION_RECEIVE_THROUGHPUT}
  INTERNET_OPTION_REQUEST_PRIORITY            = 58;
  {$EXTERNALSYM INTERNET_OPTION_REQUEST_PRIORITY}
  INTERNET_OPTION_HTTP_VERSION                = 59;
  {$EXTERNALSYM INTERNET_OPTION_HTTP_VERSION}
  INTERNET_OPTION_RESET_URLCACHE_SESSION      = 60;
  {$EXTERNALSYM INTERNET_OPTION_RESET_URLCACHE_SESSION}
  INTERNET_OPTION_ERROR_MASK                  = 62;
  {$EXTERNALSYM INTERNET_OPTION_ERROR_MASK}
  INTERNET_FIRST_OPTION                      = INTERNET_OPTION_CALLBACK;
  {$EXTERNALSYM INTERNET_FIRST_OPTION}
  INTERNET_LAST_OPTION                       = INTERNET_OPTION_PROXY;
  {$EXTERNALSYM INTERNET_LAST_OPTION}

{ values for INTERNET_OPTION_PRIORITY }

  INTERNET_PRIORITY_FOREGROUND = 1000;
  {$EXTERNALSYM INTERNET_PRIORITY_FOREGROUND}

{ handle types }

  INTERNET_HANDLE_TYPE_INTERNET = 1;
  {$EXTERNALSYM INTERNET_HANDLE_TYPE_INTERNET}
  INTERNET_HANDLE_TYPE_CONNECT_FTP = 2;
  {$EXTERNALSYM INTERNET_HANDLE_TYPE_CONNECT_FTP}
  INTERNET_HANDLE_TYPE_CONNECT_GOPHER = 3;
  {$EXTERNALSYM INTERNET_HANDLE_TYPE_CONNECT_GOPHER}
  INTERNET_HANDLE_TYPE_CONNECT_HTTP = 4;
  {$EXTERNALSYM INTERNET_HANDLE_TYPE_CONNECT_HTTP}
  INTERNET_HANDLE_TYPE_FTP_FIND = 5;
  {$EXTERNALSYM INTERNET_HANDLE_TYPE_FTP_FIND}
  INTERNET_HANDLE_TYPE_FTP_FIND_HTML = 6;
  {$EXTERNALSYM INTERNET_HANDLE_TYPE_FTP_FIND_HTML}
  INTERNET_HANDLE_TYPE_FTP_FILE = 7;
  {$EXTERNALSYM INTERNET_HANDLE_TYPE_FTP_FILE}
  INTERNET_HANDLE_TYPE_FTP_FILE_HTML = 8;
  {$EXTERNALSYM INTERNET_HANDLE_TYPE_FTP_FILE_HTML}
  INTERNET_HANDLE_TYPE_GOPHER_FIND = 9;
  {$EXTERNALSYM INTERNET_HANDLE_TYPE_GOPHER_FIND}
  INTERNET_HANDLE_TYPE_GOPHER_FIND_HTML = 10;
  {$EXTERNALSYM INTERNET_HANDLE_TYPE_GOPHER_FIND_HTML}
  INTERNET_HANDLE_TYPE_GOPHER_FILE = 11;
  {$EXTERNALSYM INTERNET_HANDLE_TYPE_GOPHER_FILE}
  INTERNET_HANDLE_TYPE_GOPHER_FILE_HTML = 12;
  {$EXTERNALSYM INTERNET_HANDLE_TYPE_GOPHER_FILE_HTML}
  INTERNET_HANDLE_TYPE_HTTP_REQUEST = 13;
  {$EXTERNALSYM INTERNET_HANDLE_TYPE_HTTP_REQUEST}

{ values for INTERNET_OPTION_SECURITY_FLAGS }

  SECURITY_FLAG_SECURE                        = $00000001; { can query only }
  {$EXTERNALSYM SECURITY_FLAG_SECURE}
  SECURITY_FLAG_SSL                           = $00000002;
  {$EXTERNALSYM SECURITY_FLAG_SSL}
  SECURITY_FLAG_SSL3                          = $00000004;
  {$EXTERNALSYM SECURITY_FLAG_SSL3}
  SECURITY_FLAG_PCT                           = $00000008;
  {$EXTERNALSYM SECURITY_FLAG_PCT}
  SECURITY_FLAG_PCT4                          = $00000010;
  {$EXTERNALSYM SECURITY_FLAG_PCT4}
  SECURITY_FLAG_IETFSSL4                      = $00000020;
  {$EXTERNALSYM SECURITY_FLAG_IETFSSL4}
  SECURITY_FLAG_STRENGTH_WEAK                 = $10000000;
  {$EXTERNALSYM SECURITY_FLAG_STRENGTH_WEAK}
  SECURITY_FLAG_STRENGTH_MEDIUM               = $40000000;
  {$EXTERNALSYM SECURITY_FLAG_STRENGTH_MEDIUM}
  SECURITY_FLAG_STRENGTH_STRONG               = $20000000;
  {$EXTERNALSYM SECURITY_FLAG_STRENGTH_STRONG}
  SECURITY_FLAG_40BIT                         = SECURITY_FLAG_STRENGTH_WEAK;
  {$EXTERNALSYM SECURITY_FLAG_40BIT}
  SECURITY_FLAG_128BIT                        = SECURITY_FLAG_STRENGTH_STRONG;
  {$EXTERNALSYM SECURITY_FLAG_128BIT}
  SECURITY_FLAG_56BIT                         = SECURITY_FLAG_STRENGTH_MEDIUM;
  {$EXTERNALSYM SECURITY_FLAG_56BIT}
  SECURITY_FLAG_UNKNOWNBIT                    = $80000000;
  {$EXTERNALSYM SECURITY_FLAG_UNKNOWNBIT}
  SECURITY_FLAG_NORMALBITNESS                 = SECURITY_FLAG_40BIT;
  {$EXTERNALSYM SECURITY_FLAG_NORMALBITNESS}
  SECURITY_FLAG_IGNORE_REVOCATION             = $00000080;
  {$EXTERNALSYM SECURITY_FLAG_IGNORE_REVOCATION}
  SECURITY_FLAG_IGNORE_UNKNOWN_CA             = $00000100;
  {$EXTERNALSYM SECURITY_FLAG_IGNORE_UNKNOWN_CA}
  SECURITY_FLAG_IGNORE_WRONG_USAGE            = $00000200;
  {$EXTERNALSYM SECURITY_FLAG_IGNORE_WRONG_USAGE}
  SECURITY_FLAG_IGNORE_CERT_CN_INVALID        = INTERNET_FLAG_IGNORE_CERT_CN_INVALID;
  {$EXTERNALSYM SECURITY_FLAG_IGNORE_CERT_CN_INVALID}
  SECURITY_FLAG_IGNORE_CERT_DATE_INVALID      = INTERNET_FLAG_IGNORE_CERT_DATE_INVALID;
  {$EXTERNALSYM SECURITY_FLAG_IGNORE_CERT_DATE_INVALID}
  SECURITY_FLAG_IGNORE_REDIRECT_TO_HTTPS      = INTERNET_FLAG_IGNORE_REDIRECT_TO_HTTPS;
  {$EXTERNALSYM SECURITY_FLAG_IGNORE_REDIRECT_TO_HTTPS}
  SECURITY_FLAG_IGNORE_REDIRECT_TO_HTTP       = INTERNET_FLAG_IGNORE_REDIRECT_TO_HTTP;
  {$EXTERNALSYM SECURITY_FLAG_IGNORE_REDIRECT_TO_HTTP}

function InternetGetLastResponseInfo(var lpdwError: DWORD; lpszBuffer: PChar;
  var lpdwBufferLength: DWORD): BOOL; stdcall;
  {$EXTERNALSYM InternetGetLastResponseInfo}
function InternetGetLastResponseInfoA(var lpdwError: DWORD; lpszBuffer: PAnsiChar;
  var lpdwBufferLength: DWORD): BOOL; stdcall;
  {$EXTERNALSYM InternetGetLastResponseInfoA}
function InternetGetLastResponseInfoW(var lpdwError: DWORD; lpszBuffer: PWideChar;
  var lpdwBufferLength: DWORD): BOOL; stdcall;
  {$EXTERNALSYM InternetGetLastResponseInfoW}

{ callback function for InternetSetStatusCallback }
type





  INTERNET_STATUS_CALLBACK = TFarProc;

  {$EXTERNALSYM INTERNET_STATUS_CALLBACK}
  TFNInternetStatusCallback = INTERNET_STATUS_CALLBACK;
  PFNInternetStatusCallback = ^TFNInternetStatusCallback;
  LPINTERNET_STATUS_CALLBACK = PFNInternetStatusCallback;
  {$EXTERNALSYM LPINTERNET_STATUS_CALLBACK}

function InternetSetStatusCallback(hInet: HINTERNET;
  lpfnInternetCallback: PFNInternetStatusCallback): PFNInternetStatusCallback; stdcall;
  {$EXTERNALSYM InternetSetStatusCallback}

{ status manifests for Internet status callback }
const
  INTERNET_STATUS_RESOLVING_NAME              = 10;
  {$EXTERNALSYM INTERNET_STATUS_RESOLVING_NAME}
  INTERNET_STATUS_NAME_RESOLVED               = 11;
  {$EXTERNALSYM INTERNET_STATUS_NAME_RESOLVED}
  INTERNET_STATUS_CONNECTING_TO_SERVER        = 20;
  {$EXTERNALSYM INTERNET_STATUS_CONNECTING_TO_SERVER}
  INTERNET_STATUS_CONNECTED_TO_SERVER         = 21;
  {$EXTERNALSYM INTERNET_STATUS_CONNECTED_TO_SERVER}
  INTERNET_STATUS_SENDING_REQUEST             = 30;
  {$EXTERNALSYM INTERNET_STATUS_SENDING_REQUEST}
  INTERNET_STATUS_REQUEST_SENT                = 31;
  {$EXTERNALSYM INTERNET_STATUS_REQUEST_SENT}
  INTERNET_STATUS_RECEIVING_RESPONSE          = 40;
  {$EXTERNALSYM INTERNET_STATUS_RECEIVING_RESPONSE}
  INTERNET_STATUS_RESPONSE_RECEIVED           = 41;
  {$EXTERNALSYM INTERNET_STATUS_RESPONSE_RECEIVED}
  INTERNET_STATUS_CTL_RESPONSE_RECEIVED       = 42;
  {$EXTERNALSYM INTERNET_STATUS_CTL_RESPONSE_RECEIVED}
  INTERNET_STATUS_PREFETCH                    = 43;
  {$EXTERNALSYM INTERNET_STATUS_PREFETCH}
  INTERNET_STATUS_CLOSING_CONNECTION          = 50;
  {$EXTERNALSYM INTERNET_STATUS_CLOSING_CONNECTION}
  INTERNET_STATUS_CONNECTION_CLOSED           = 51;
  {$EXTERNALSYM INTERNET_STATUS_CONNECTION_CLOSED}
  INTERNET_STATUS_HANDLE_CREATED              = 60;
  {$EXTERNALSYM INTERNET_STATUS_HANDLE_CREATED}
  INTERNET_STATUS_HANDLE_CLOSING              = 70;
  {$EXTERNALSYM INTERNET_STATUS_HANDLE_CLOSING}
  INTERNET_STATUS_REQUEST_COMPLETE            = 100;
  {$EXTERNALSYM INTERNET_STATUS_REQUEST_COMPLETE}
  INTERNET_STATUS_REDIRECT                    = 110;
  {$EXTERNALSYM INTERNET_STATUS_REDIRECT}
  INTERNET_STATUS_INTERMEDIATE_RESPONSE       = 120;
  {$EXTERNALSYM INTERNET_STATUS_INTERMEDIATE_RESPONSE}
  INTERNET_STATUS_STATE_CHANGE                = 200;
  {$EXTERNALSYM INTERNET_STATUS_STATE_CHANGE}

{ the following can be indicated in a state change notification: }
  INTERNET_STATE_CONNECTED                    = $00000001;  { connected state (mutually exclusive with disconnected) }
  {$EXTERNALSYM INTERNET_STATE_CONNECTED}
  INTERNET_STATE_DISCONNECTED                 = $00000002;  { disconnected from network }
  {$EXTERNALSYM INTERNET_STATE_DISCONNECTED}
  INTERNET_STATE_DISCONNECTED_BY_USER         = $00000010;  { disconnected by user request }
  {$EXTERNALSYM INTERNET_STATE_DISCONNECTED_BY_USER}
  INTERNET_STATE_IDLE                         = $00000100;  { no network requests being made (by Wininet) }
  {$EXTERNALSYM INTERNET_STATE_IDLE}
  INTERNET_STATE_BUSY                         = $00000200;  { network requests being made (by Wininet) }
  {$EXTERNALSYM INTERNET_STATE_BUSY}

{ if the following value is returned by InternetSetStatusCallback, then }
{ probably an invalid (non-code) address was supplied for the callback }

  INTERNET_INVALID_STATUS_CALLBACK = (-1);
  {$EXTERNALSYM INTERNET_INVALID_STATUS_CALLBACK}

{ prototypes }

function FtpFindFirstFile(hConnect: HINTERNET; lpszSearchFile: PChar;
  var lpFindFileData: TWin32FindData; dwFlags: DWORD;
  dwContext: DWORD): HINTERNET; stdcall;
  {$EXTERNALSYM FtpFindFirstFile}
function FtpFindFirstFileA(hConnect: HINTERNET; lpszSearchFile: PAnsiChar;
  var lpFindFileData: TWin32FindDataA; dwFlags: DWORD;
  dwContext: DWORD): HINTERNET; stdcall;
  {$EXTERNALSYM FtpFindFirstFileA}
function FtpFindFirstFileW(hConnect: HINTERNET; lpszSearchFile: PWideChar;
  var lpFindFileData: TWin32FindDataW; dwFlags: DWORD;
  dwContext: DWORD): HINTERNET; stdcall;
  {$EXTERNALSYM FtpFindFirstFileW}

function FtpGetFile(hConnect: HINTERNET; lpszRemoteFile: PChar;
  lpszNewFile: PChar; fFailIfExists: BOOL; dwFlagsAndAttributes: DWORD;
  dwFlags: DWORD; dwContext: DWORD): BOOL stdcall;
  {$EXTERNALSYM FtpGetFile}
function FtpGetFileA(hConnect: HINTERNET; lpszRemoteFile: PAnsiChar;
  lpszNewFile: PAnsiChar; fFailIfExists: BOOL; dwFlagsAndAttributes: DWORD;
  dwFlags: DWORD; dwContext: DWORD): BOOL stdcall;
  {$EXTERNALSYM FtpGetFileA}
function FtpGetFileW(hConnect: HINTERNET; lpszRemoteFile: PWideChar;
  lpszNewFile: PWideChar; fFailIfExists: BOOL; dwFlagsAndAttributes: DWORD;
  dwFlags: DWORD; dwContext: DWORD): BOOL stdcall;
  {$EXTERNALSYM FtpGetFileW}

function FtpPutFile(hConnect: HINTERNET; lpszLocalFile: PChar;
  lpszNewRemoteFile: PChar; dwFlags: DWORD; dwContext: DWORD): BOOL; stdcall;
  {$EXTERNALSYM FtpPutFile}
function FtpPutFileA(hConnect: HINTERNET; lpszLocalFile: PAnsiChar;
  lpszNewRemoteFile: PAnsiChar; dwFlags: DWORD; dwContext: DWORD): BOOL; stdcall;
  {$EXTERNALSYM FtpPutFileA}
function FtpPutFileW(hConnect: HINTERNET; lpszLocalFile: PWideChar;
  lpszNewRemoteFile: PWideChar; dwFlags: DWORD; dwContext: DWORD): BOOL; stdcall;
  {$EXTERNALSYM FtpPutFileW}

function FtpDeleteFile(hConnect: HINTERNET; lpszFileName: PChar): BOOL; stdcall;
  {$EXTERNALSYM FtpDeleteFile}
function FtpDeleteFileA(hConnect: HINTERNET; lpszFileName: PAnsiChar): BOOL; stdcall;
  {$EXTERNALSYM FtpDeleteFileA}
function FtpDeleteFileW(hConnect: HINTERNET; lpszFileName: PWideChar): BOOL; stdcall;
  {$EXTERNALSYM FtpDeleteFileW}

function FtpRenameFile(hConnect: HINTERNET; lpszExisting: PChar;
  lpszNew: PChar): BOOL; stdcall;
  {$EXTERNALSYM FtpRenameFile}
function FtpRenameFileA(hConnect: HINTERNET; lpszExisting: PAnsiChar;
  lpszNew: PAnsiChar): BOOL; stdcall;
  {$EXTERNALSYM FtpRenameFileA}
function FtpRenameFileW(hConnect: HINTERNET; lpszExisting: PWideChar;
  lpszNew: PWideChar): BOOL; stdcall;
  {$EXTERNALSYM FtpRenameFileW}

function FtpOpenFile(hConnect: HINTERNET; lpszFileName: PChar;
  dwAccess: DWORD; dwFlags: DWORD; dwContext: DWORD): HINTERNET; stdcall;
  {$EXTERNALSYM FtpOpenFile}
function FtpOpenFileA(hConnect: HINTERNET; lpszFileName: PAnsiChar;
  dwAccess: DWORD; dwFlags: DWORD; dwContext: DWORD): HINTERNET; stdcall;
  {$EXTERNALSYM FtpOpenFileA}
function FtpOpenFileW(hConnect: HINTERNET; lpszFileName: PWideChar;
  dwAccess: DWORD; dwFlags: DWORD; dwContext: DWORD): HINTERNET; stdcall;
  {$EXTERNALSYM FtpOpenFileW}

function FtpCreateDirectory(hConnect: HINTERNET; lpszDirectory: PChar): BOOL; stdcall;
  {$EXTERNALSYM FtpCreateDirectory}
function FtpCreateDirectoryA(hConnect: HINTERNET; lpszDirectory: PAnsiChar): BOOL; stdcall;
  {$EXTERNALSYM FtpCreateDirectoryA}
function FtpCreateDirectoryW(hConnect: HINTERNET; lpszDirectory: PWideChar): BOOL; stdcall;
  {$EXTERNALSYM FtpCreateDirectoryW}

function FtpRemoveDirectory(hConnect: HINTERNET; lpszDirectory: PChar): BOOL; stdcall;
  {$EXTERNALSYM FtpRemoveDirectory}
function FtpRemoveDirectoryA(hConnect: HINTERNET; lpszDirectory: PAnsiChar): BOOL; stdcall;
  {$EXTERNALSYM FtpRemoveDirectoryA}
function FtpRemoveDirectoryW(hConnect: HINTERNET; lpszDirectory: PWideChar): BOOL; stdcall;
  {$EXTERNALSYM FtpRemoveDirectoryW}

function FtpSetCurrentDirectory(hConnect: HINTERNET; lpszDirectory: PChar): BOOL; stdcall;
  {$EXTERNALSYM FtpSetCurrentDirectory}
function FtpSetCurrentDirectoryA(hConnect: HINTERNET; lpszDirectory: PAnsiChar): BOOL; stdcall;
  {$EXTERNALSYM FtpSetCurrentDirectoryA}
function FtpSetCurrentDirectoryW(hConnect: HINTERNET; lpszDirectory: PWideChar): BOOL; stdcall;
  {$EXTERNALSYM FtpSetCurrentDirectoryW}

function FtpGetCurrentDirectory(hConnect: HINTERNET;
  lpszCurrentDirectory: PChar; var lpdwCurrentDirectory: DWORD): BOOL; stdcall;
  {$EXTERNALSYM FtpGetCurrentDirectory}
function FtpGetCurrentDirectoryA(hConnect: HINTERNET;
  lpszCurrentDirectory: PAnsiChar; var lpdwCurrentDirectory: DWORD): BOOL; stdcall;
  {$EXTERNALSYM FtpGetCurrentDirectoryA}
function FtpGetCurrentDirectoryW(hConnect: HINTERNET;
  lpszCurrentDirectory: PWideChar; var lpdwCurrentDirectory: DWORD): BOOL; stdcall;
  {$EXTERNALSYM FtpGetCurrentDirectoryW}

function FtpCommand(hConnect: HINTERNET; fExpectResponse: BOOL;
  dwFlags: DWORD; lpszCommand: PChar; dwContext: DWORD): BOOL; stdcall;
  {$EXTERNALSYM FtpCommand}
function FtpCommandA(hConnect: HINTERNET; fExpectResponse: BOOL;
  dwFlags: DWORD; lpszCommand: PAnsiChar; dwContext: DWORD): BOOL; stdcall;
  {$EXTERNALSYM FtpCommandA}
function FtpCommandW(hConnect: HINTERNET; fExpectResponse: BOOL;
  dwFlags: DWORD; lpszCommand: PWideChar; dwContext: DWORD): BOOL; stdcall;
  {$EXTERNALSYM FtpCommandW}

function FtpGetFileSize(hFile: HINTERNET; lpdwFileSizeHigh: LPDWORD): DWORD; stdcall;
  {$EXTERNALSYM FtpGetFileSize}

{ Gopher }

{ manifests }

{ string field lengths (in characters, not bytes) }
const
  MAX_GOPHER_DISPLAY_TEXT   = 128;
  {$EXTERNALSYM MAX_GOPHER_DISPLAY_TEXT}
  MAX_GOPHER_SELECTOR_TEXT  = 256;
  {$EXTERNALSYM MAX_GOPHER_SELECTOR_TEXT}
  MAX_GOPHER_HOST_NAME      = INTERNET_MAX_HOST_NAME_LENGTH;
  {$EXTERNALSYM MAX_GOPHER_HOST_NAME}
  MAX_GOPHER_LOCATOR_LENGTH = 1
                              + MAX_GOPHER_DISPLAY_TEXT
                              + 1
                              + MAX_GOPHER_SELECTOR_TEXT
                              + 1
                              + MAX_GOPHER_HOST_NAME
                              + 1
                              + INTERNET_MAX_PORT_NUMBER_LENGTH
                              + 1
                              + 1
                              + 2;
  {$EXTERNALSYM MAX_GOPHER_LOCATOR_LENGTH}

{ structures/types }

{ GOPHER_FIND_DATA - returns the results of a GopherFindFirstFile/ }
{ InternetFindNextFile request }

type
  PGopherFindDataA = ^GOPHER_FIND_DATAA;
  PGopherFindDataW = ^GOPHER_FIND_DATAW;
  PGopherFindData = PGopherFindDataA;
  GOPHER_FIND_DATAA = record
    DisplayString: packed array[0..MAX_GOPHER_DISPLAY_TEXT-1] of AnsiChar;
    GopherType: DWORD;  { GopherType - if known }
    SizeLow: DWORD;
    SizeHigh: DWORD;
    LastModificationTime: TFileTime;
    Locator: packed array[0..MAX_GOPHER_LOCATOR_LENGTH-1] of AnsiChar;
  end;
  {$EXTERNALSYM GOPHER_FIND_DATAA}
  GOPHER_FIND_DATAW = record
    DisplayString: packed array[0..MAX_GOPHER_DISPLAY_TEXT-1] of WideChar;
    GopherType: DWORD;  { GopherType - if known }
    SizeLow: DWORD;
    SizeHigh: DWORD;
    LastModificationTime: TFileTime;
    Locator: packed array[0..MAX_GOPHER_LOCATOR_LENGTH-1] of WideChar;
  end;
  {$EXTERNALSYM GOPHER_FIND_DATAW}
  GOPHER_FIND_DATA = GOPHER_FIND_DATAA;
  TGopherFindDataA = GOPHER_FIND_DATAA;
  LPGOPHER_FIND_DATAA = PGopherFindDataA;
  {$EXTERNALSYM LPGOPHER_FIND_DATAA}
  TGopherFindDataW = GOPHER_FIND_DATAW;
  LPGOPHER_FIND_DATAW = PGopherFindDataW;
  {$EXTERNALSYM LPGOPHER_FIND_DATAW}
  TGopherFindData = TGopherFindDataA;

{ manifests for GopherType }
const
  GOPHER_TYPE_TEXT_FILE = $00000001;
  {$EXTERNALSYM GOPHER_TYPE_TEXT_FILE}
  GOPHER_TYPE_DIRECTORY = $00000002;
  {$EXTERNALSYM GOPHER_TYPE_DIRECTORY}
  GOPHER_TYPE_CSO = $00000004;
  {$EXTERNALSYM GOPHER_TYPE_CSO}
  GOPHER_TYPE_ERROR = $00000008;
  {$EXTERNALSYM GOPHER_TYPE_ERROR}
  GOPHER_TYPE_MAC_BINHEX = $00000010;
  {$EXTERNALSYM GOPHER_TYPE_MAC_BINHEX}
  GOPHER_TYPE_DOS_ARCHIVE = $00000020;
  {$EXTERNALSYM GOPHER_TYPE_DOS_ARCHIVE}
  GOPHER_TYPE_UNIX_UUENCODED = $00000040;
  {$EXTERNALSYM GOPHER_TYPE_UNIX_UUENCODED}
  GOPHER_TYPE_INDEX_SERVER = $00000080;
  {$EXTERNALSYM GOPHER_TYPE_INDEX_SERVER}
  GOPHER_TYPE_TELNET = $00000100;
  {$EXTERNALSYM GOPHER_TYPE_TELNET}
  GOPHER_TYPE_BINARY = $00000200;
  {$EXTERNALSYM GOPHER_TYPE_BINARY}
  GOPHER_TYPE_REDUNDANT = $00000400;
  {$EXTERNALSYM GOPHER_TYPE_REDUNDANT}
  GOPHER_TYPE_TN3270 = $00000800;
  {$EXTERNALSYM GOPHER_TYPE_TN3270}
  GOPHER_TYPE_GIF = $00001000;
  {$EXTERNALSYM GOPHER_TYPE_GIF}
  GOPHER_TYPE_IMAGE = $00002000;
  {$EXTERNALSYM GOPHER_TYPE_IMAGE}
  GOPHER_TYPE_BITMAP = $00004000;
  {$EXTERNALSYM GOPHER_TYPE_BITMAP}
  GOPHER_TYPE_MOVIE = $00008000;
  {$EXTERNALSYM GOPHER_TYPE_MOVIE}
  GOPHER_TYPE_SOUND = $00010000;
  {$EXTERNALSYM GOPHER_TYPE_SOUND}
  GOPHER_TYPE_HTML = $00020000;
  {$EXTERNALSYM GOPHER_TYPE_HTML}
  GOPHER_TYPE_PDF = $00040000;
  {$EXTERNALSYM GOPHER_TYPE_PDF}
  GOPHER_TYPE_CALENDAR = $00080000;
  {$EXTERNALSYM GOPHER_TYPE_CALENDAR}
  GOPHER_TYPE_INLINE = $00100000;
  {$EXTERNALSYM GOPHER_TYPE_INLINE}
  GOPHER_TYPE_UNKNOWN = $20000000;
  {$EXTERNALSYM GOPHER_TYPE_UNKNOWN}
  GOPHER_TYPE_ASK = $40000000;
  {$EXTERNALSYM GOPHER_TYPE_ASK}
  GOPHER_TYPE_GOPHER_PLUS = $80000000;
  {$EXTERNALSYM GOPHER_TYPE_GOPHER_PLUS}

{ Gopher Type functions }

function IS_GOPHER_FILE(GopherType: DWORD): BOOL;
  {$EXTERNALSYM IS_GOPHER_FILE}
function IS_GOPHER_DIRECTORY(GopherType: DWORD): BOOL;
  {$EXTERNALSYM IS_GOPHER_DIRECTORY}
function IS_GOPHER_PHONE_SERVER(GopherType: DWORD): BOOL;
  {$EXTERNALSYM IS_GOPHER_PHONE_SERVER}
function IS_GOPHER_ERROR(GopherType: DWORD): BOOL;
  {$EXTERNALSYM IS_GOPHER_ERROR}
function IS_GOPHER_INDEX_SERVER(GopherType: DWORD): BOOL;
  {$EXTERNALSYM IS_GOPHER_INDEX_SERVER}
function IS_GOPHER_TELNET_SESSION(GopherType: DWORD): BOOL;
  {$EXTERNALSYM IS_GOPHER_TELNET_SESSION}
function IS_GOPHER_BACKUP_SERVER(GopherType: DWORD): BOOL;
  {$EXTERNALSYM IS_GOPHER_BACKUP_SERVER}
function IS_GOPHER_TN3270_SESSION(GopherType: DWORD): BOOL;
  {$EXTERNALSYM IS_GOPHER_TN3270_SESSION}
function IS_GOPHER_ASK(GopherType: DWORD): BOOL;
  {$EXTERNALSYM IS_GOPHER_ASK}
function IS_GOPHER_PLUS(GopherType: DWORD): BOOL;
  {$EXTERNALSYM IS_GOPHER_PLUS}
function IS_GOPHER_TYPE_KNOWN(GopherType: DWORD): BOOL;
  {$EXTERNALSYM IS_GOPHER_TYPE_KNOWN}

{ GOPHER_TYPE_FILE_MASK - use this to determine if a locator identifies a }
{ (known) file type }
const
  GOPHER_TYPE_FILE_MASK = GOPHER_TYPE_TEXT_FILE
                          or GOPHER_TYPE_MAC_BINHEX
                          or GOPHER_TYPE_DOS_ARCHIVE
                          or GOPHER_TYPE_UNIX_UUENCODED
                          or GOPHER_TYPE_BINARY
                          or GOPHER_TYPE_GIF
                          or GOPHER_TYPE_IMAGE
                          or GOPHER_TYPE_BITMAP
                          or GOPHER_TYPE_MOVIE
                          or GOPHER_TYPE_SOUND
                          or GOPHER_TYPE_HTML
                          or GOPHER_TYPE_PDF
                          or GOPHER_TYPE_CALENDAR
                          or GOPHER_TYPE_INLINE;
  {$EXTERNALSYM GOPHER_TYPE_FILE_MASK}

{ structured gopher attributes (as defined in gopher+ protocol document) }
type
  PGopherAdminAttributeType = ^GOPHER_ADMIN_ATTRIBUTE_TYPE;
  GOPHER_ADMIN_ATTRIBUTE_TYPE = record
    Comment: LPCSTR;
    EmailAddress: LPCSTR;
  end;
  {$EXTERNALSYM GOPHER_ADMIN_ATTRIBUTE_TYPE}
  TGopherAdminAttributeType = GOPHER_ADMIN_ATTRIBUTE_TYPE;
  LPGOPHER_ADMIN_ATTRIBUTE_TYPE = PGopherAdminAttributeType;
  {$EXTERNALSYM LPGOPHER_ADMIN_ATTRIBUTE_TYPE}

  PGopherModDateAttributeType = ^GOPHER_MOD_DATE_ATTRIBUTE_TYPE;
  GOPHER_MOD_DATE_ATTRIBUTE_TYPE = record
    DateAndTime: TFileTime;
  end;
  {$EXTERNALSYM GOPHER_MOD_DATE_ATTRIBUTE_TYPE}
  TGopherModDateAttributeType = GOPHER_MOD_DATE_ATTRIBUTE_TYPE;
  LPGOPHER_MOD_DATE_ATTRIBUTE_TYPE = PGopherModDateAttributeType;
  {$EXTERNALSYM LPGOPHER_MOD_DATE_ATTRIBUTE_TYPE}

  PGopherTtlAttributeType = ^GOPHER_TTL_ATTRIBUTE_TYPE;
  GOPHER_TTL_ATTRIBUTE_TYPE = record
    Ttl: DWORD;
  end;
  {$EXTERNALSYM GOPHER_TTL_ATTRIBUTE_TYPE}
  TGopherTtlAttributeType = GOPHER_TTL_ATTRIBUTE_TYPE;
  LPGOPHER_TTL_ATTRIBUTE_TYPE = PGopherTtlAttributeType;
  {$EXTERNALSYM LPGOPHER_TTL_ATTRIBUTE_TYPE}

  PGopherScoreAttributeType = ^GOPHER_SCORE_ATTRIBUTE_TYPE;
  GOPHER_SCORE_ATTRIBUTE_TYPE = record
    Score: Integer;
  end;
  {$EXTERNALSYM GOPHER_SCORE_ATTRIBUTE_TYPE}
  TGopherScoreAttributeType = GOPHER_SCORE_ATTRIBUTE_TYPE;
  LPGOPHER_SCORE_ATTRIBUTE_TYPE = PGopherScoreAttributeType;
  {$EXTERNALSYM LPGOPHER_SCORE_ATTRIBUTE_TYPE}

  PGopherScoreRangeAttributeType = ^GOPHER_SCORE_RANGE_ATTRIBUTE_TYPE;
  GOPHER_SCORE_RANGE_ATTRIBUTE_TYPE = record
    LowerBound: Integer;
    UpperBound: Integer;
  end;
  {$EXTERNALSYM GOPHER_SCORE_RANGE_ATTRIBUTE_TYPE}
  TGopherScoreRangeAttributeType = GOPHER_SCORE_RANGE_ATTRIBUTE_TYPE;
  LPGOPHER_SCORE_RANGE_ATTRIBUTE_TYPE = PGopherScoreRangeAttributeType;
  {$EXTERNALSYM LPGOPHER_SCORE_RANGE_ATTRIBUTE_TYPE}

  PGopherSiteAttributeType = ^GOPHER_SITE_ATTRIBUTE_TYPE;
  GOPHER_SITE_ATTRIBUTE_TYPE = record
    Site: LPCSTR;
  end;
  {$EXTERNALSYM GOPHER_SITE_ATTRIBUTE_TYPE}
  TGopherSiteAttributeType = GOPHER_SITE_ATTRIBUTE_TYPE;
  LPGOPHER_SITE_ATTRIBUTE_TYPE = PGopherSiteAttributeType;
  {$EXTERNALSYM LPGOPHER_SITE_ATTRIBUTE_TYPE}

  PGopherOrganizationAttributeType = ^GOPHER_ORGANIZATION_ATTRIBUTE_TYPE;
  GOPHER_ORGANIZATION_ATTRIBUTE_TYPE = record
    Organization: LPCSTR;
  end;
  {$EXTERNALSYM GOPHER_ORGANIZATION_ATTRIBUTE_TYPE}
  TGopherOrganizationAttributeType = GOPHER_ORGANIZATION_ATTRIBUTE_TYPE;
  LPGOPHER_ORGANIZATION_ATTRIBUTE_TYPE = PGopherOrganizationAttributeType;
  {$EXTERNALSYM LPGOPHER_ORGANIZATION_ATTRIBUTE_TYPE}

  PGopherLocationAttributeType = ^GOPHER_LOCATION_ATTRIBUTE_TYPE;
  GOPHER_LOCATION_ATTRIBUTE_TYPE = record
    Location: LPCSTR;
  end;
  {$EXTERNALSYM GOPHER_LOCATION_ATTRIBUTE_TYPE}
  TGopherLocationAttributeType = GOPHER_LOCATION_ATTRIBUTE_TYPE;
  LPGOPHER_LOCATION_ATTRIBUTE_TYPE = PGopherLocationAttributeType;
  {$EXTERNALSYM LPGOPHER_LOCATION_ATTRIBUTE_TYPE}

  PGopherGeographicalLocationAttributeType = ^GOPHER_GEOGRAPHICAL_LOCATION_ATTRIBUTE_TYPE;
  GOPHER_GEOGRAPHICAL_LOCATION_ATTRIBUTE_TYPE = record
    DegreesNorth: Integer;
    MinutesNorth: Integer;
    SecondsNorth: Integer;
    DegreesEast: Integer;
    MinutesEast: Integer;
    SecondsEast: Integer;
  end;
  {$EXTERNALSYM GOPHER_GEOGRAPHICAL_LOCATION_ATTRIBUTE_TYPE}
  TGopherGeographicalLocationAttributeType = GOPHER_GEOGRAPHICAL_LOCATION_ATTRIBUTE_TYPE;
  LPGOPHER_GEOGRAPHICAL_LOCATION_ATTRIBUTE_TYPE = PGopherGeographicalLocationAttributeType;
  {$EXTERNALSYM LPGOPHER_GEOGRAPHICAL_LOCATION_ATTRIBUTE_TYPE}

  PGopherTimezoneAttributeType = ^TGopherTimezoneAttributeType;
  GOPHER_TIMEZONE_ATTRIBUTE_TYPE = record
    Zone: Integer;
  end;
  {$EXTERNALSYM GOPHER_TIMEZONE_ATTRIBUTE_TYPE}
  TGopherTimezoneAttributeType = GOPHER_TIMEZONE_ATTRIBUTE_TYPE;
  LPGOPHER_TIMEZONE_ATTRIBUTE_TYPE = PGopherTimezoneAttributeType;
  {$EXTERNALSYM LPGOPHER_TIMEZONE_ATTRIBUTE_TYPE}

  PGopherProviderAttributeType = ^GOPHER_PROVIDER_ATTRIBUTE_TYPE;
  GOPHER_PROVIDER_ATTRIBUTE_TYPE = record
    Provider: LPCSTR;
  end;
  {$EXTERNALSYM GOPHER_PROVIDER_ATTRIBUTE_TYPE}
  TGopherProviderAttributeType = GOPHER_PROVIDER_ATTRIBUTE_TYPE;
  LPGOPHER_PROVIDER_ATTRIBUTE_TYPE = PGopherProviderAttributeType;
  {$EXTERNALSYM LPGOPHER_PROVIDER_ATTRIBUTE_TYPE}

  PGopherVersionAttributeType = ^GOPHER_VERSION_ATTRIBUTE_TYPE;
  GOPHER_VERSION_ATTRIBUTE_TYPE = record
    Version: LPCSTR;
  end;
  {$EXTERNALSYM GOPHER_VERSION_ATTRIBUTE_TYPE}
  TGopherVersionAttributeType = GOPHER_VERSION_ATTRIBUTE_TYPE;
  LPGOPHER_VERSION_ATTRIBUTE_TYPE = PGopherVersionAttributeType;
  {$EXTERNALSYM LPGOPHER_VERSION_ATTRIBUTE_TYPE}

  PGopherAbstractAttributeType = ^GOPHER_ABSTRACT_ATTRIBUTE_TYPE;
  GOPHER_ABSTRACT_ATTRIBUTE_TYPE = record
    ShortAbstract: LPCSTR;
    AbstractFile: LPCSTR;
  end;
  {$EXTERNALSYM GOPHER_ABSTRACT_ATTRIBUTE_TYPE}
  TGopherAbstractAttributeType = GOPHER_ABSTRACT_ATTRIBUTE_TYPE;
  LPGOPHER_ABSTRACT_ATTRIBUTE_TYPE = PGopherAbstractAttributeType;
  {$EXTERNALSYM LPGOPHER_ABSTRACT_ATTRIBUTE_TYPE}

  PGopherViewAttributeType = ^GOPHER_VIEW_ATTRIBUTE_TYPE;
  GOPHER_VIEW_ATTRIBUTE_TYPE = record
    ContentType: LPCSTR;
    Language: LPCSTR;
    Size: DWORD;
  end;
  {$EXTERNALSYM GOPHER_VIEW_ATTRIBUTE_TYPE}
  TGopherViewAttributeType = GOPHER_VIEW_ATTRIBUTE_TYPE;
  LPGOPHER_VIEW_ATTRIBUTE_TYPE = PGopherViewAttributeType;
  {$EXTERNALSYM LPGOPHER_VIEW_ATTRIBUTE_TYPE}

  PGopherVeronicaAttributeType = ^GOPHER_VERONICA_ATTRIBUTE_TYPE;
  GOPHER_VERONICA_ATTRIBUTE_TYPE = record
    TreeWalk: BOOL;
  end;
  {$EXTERNALSYM GOPHER_VERONICA_ATTRIBUTE_TYPE}
  TGopherVeronicaAttributeType = GOPHER_VERONICA_ATTRIBUTE_TYPE;
  LPGOPHER_VERONICA_ATTRIBUTE_TYPE = PGopherVeronicaAttributeType;
  {$EXTERNALSYM LPGOPHER_VERONICA_ATTRIBUTE_TYPE}

  PGopherAskAttributeType = ^GOPHER_ASK_ATTRIBUTE_TYPE;
  GOPHER_ASK_ATTRIBUTE_TYPE = record
    QuestionType: LPCSTR;
    QuestionText: LPCSTR;
  end;
  {$EXTERNALSYM GOPHER_ASK_ATTRIBUTE_TYPE}
  TGopherAskAttributeType = GOPHER_ASK_ATTRIBUTE_TYPE;
  LPGOPHER_ASK_ATTRIBUTE_TYPE = PGopherAskAttributeType;
  {$EXTERNALSYM LPGOPHER_ASK_ATTRIBUTE_TYPE}

{ GOPHER_UNKNOWN_ATTRIBUTE_TYPE - this is returned if we retrieve an attribute }
{ that is not specified in the current gopher/gopher+ documentation. It is up }
{ to the application to parse the information }

  PGopherUnknownAttributeType = ^GOPHER_UNKNOWN_ATTRIBUTE_TYPE;
  GOPHER_UNKNOWN_ATTRIBUTE_TYPE = record
    Text: LPCSTR;
  end;
  {$EXTERNALSYM GOPHER_UNKNOWN_ATTRIBUTE_TYPE}
  TGopherUnknownAttributeType = GOPHER_UNKNOWN_ATTRIBUTE_TYPE;
  LPGOPHER_UNKNOWN_ATTRIBUTE_TYPE = PGopherUnknownAttributeType;
  {$EXTERNALSYM LPGOPHER_UNKNOWN_ATTRIBUTE_TYPE}

{ GOPHER_ATTRIBUTE_TYPE - returned in the user's buffer when an enumerated }
{ GopherGetAttribute call is made }

  PGopherAttributeType = ^GOPHER_ATTRIBUTE_TYPE;
  GOPHER_ATTRIBUTE_TYPE = record
    CategoryId: DWORD;  { e.g. GOPHER_CATEGORY_ID_ADMIN }
    AttributeId: DWORD; { e.g. GOPHER_ATTRIBUTE_ID_ADMIN }
    case Integer of
      0: (Admin: TGopherAdminAttributeType);
      1: (ModDate: TGopherModDateAttributeType);
      2: (Ttl: TGopherTtlAttributeType);
      3: (Score: TGopherScoreAttributeType);
      4: (ScoreRange: TGopherScoreRangeAttributeType);
      5: (Site: TGopherSiteAttributeType);
      6: (Organization: TGopherOrganizationAttributeType);
      7: (Location: TGopherLocationAttributeType);
      8: (GeographicalLocation: TGopherGeographicalLocationAttributeType);
      9: (TimeZone: TGopherTimezoneAttributeType);
      10: (Provider: TGopherProviderAttributeType);
      11: (Version: TGopherVersionAttributeType);
      12: (AbstractType: TGopherAbstractAttributeType);
      13: (View: TGopherViewAttributeType);
      14: (Veronica: TGopherVeronicaAttributeType);
      15: (Ask: TGopherAskAttributeType);
      16: (Unknown: TGopherUnknownAttributeType);
    end;
  {$EXTERNALSYM GOPHER_ATTRIBUTE_TYPE}
  TGopherAttributeType = GOPHER_ATTRIBUTE_TYPE;
  LPGOPHER_ATTRIBUTE_TYPE = PGopherAttributeType;
  {$EXTERNALSYM LPGOPHER_ATTRIBUTE_TYPE}

const
  MAX_GOPHER_CATEGORY_NAME = 128;           { arbitrary }
  {$EXTERNALSYM MAX_GOPHER_CATEGORY_NAME}
  MAX_GOPHER_ATTRIBUTE_NAME = 128;          {     " }
  {$EXTERNALSYM MAX_GOPHER_ATTRIBUTE_NAME}
  MIN_GOPHER_ATTRIBUTE_LENGTH = 256;        {     " }
  {$EXTERNALSYM MIN_GOPHER_ATTRIBUTE_LENGTH}

{ known gopher attribute categories. See below for ordinals }

  GOPHER_INFO_CATEGORY           = '+INFO';
  {$EXTERNALSYM GOPHER_INFO_CATEGORY}
  GOPHER_ADMIN_CATEGORY          = '+ADMIN';
  {$EXTERNALSYM GOPHER_ADMIN_CATEGORY}
  GOPHER_VIEWS_CATEGORY          = '+VIEWS';
  {$EXTERNALSYM GOPHER_VIEWS_CATEGORY}
  GOPHER_ABSTRACT_CATEGORY       = '+ABSTRACT';
  {$EXTERNALSYM GOPHER_ABSTRACT_CATEGORY}
  GOPHER_VERONICA_CATEGORY       = '+VERONICA';
  {$EXTERNALSYM GOPHER_VERONICA_CATEGORY}

{ known gopher attributes. These are the attribute names as defined in the }
{ gopher+ protocol document }

  GOPHER_ADMIN_ATTRIBUTE         = 'Admin';
  {$EXTERNALSYM GOPHER_ADMIN_ATTRIBUTE}
  GOPHER_MOD_DATE_ATTRIBUTE      = 'Mod-Date';
  {$EXTERNALSYM GOPHER_MOD_DATE_ATTRIBUTE}
  GOPHER_TTL_ATTRIBUTE           = 'TTL';
  {$EXTERNALSYM GOPHER_TTL_ATTRIBUTE}
  GOPHER_SCORE_ATTRIBUTE         = 'Score';
  {$EXTERNALSYM GOPHER_SCORE_ATTRIBUTE}
  GOPHER_RANGE_ATTRIBUTE         = 'Score-range';
  {$EXTERNALSYM GOPHER_RANGE_ATTRIBUTE}
  GOPHER_SITE_ATTRIBUTE          = 'Site';
  {$EXTERNALSYM GOPHER_SITE_ATTRIBUTE}
  GOPHER_ORG_ATTRIBUTE           = 'Org';
  {$EXTERNALSYM GOPHER_ORG_ATTRIBUTE}
  GOPHER_LOCATION_ATTRIBUTE      = 'Loc';
  {$EXTERNALSYM GOPHER_LOCATION_ATTRIBUTE}
  GOPHER_GEOG_ATTRIBUTE          = 'Geog';
  {$EXTERNALSYM GOPHER_GEOG_ATTRIBUTE}
  GOPHER_TIMEZONE_ATTRIBUTE      = 'TZ';
  {$EXTERNALSYM GOPHER_TIMEZONE_ATTRIBUTE}
  GOPHER_PROVIDER_ATTRIBUTE      = 'Provider';
  {$EXTERNALSYM GOPHER_PROVIDER_ATTRIBUTE}
  GOPHER_VERSION_ATTRIBUTE       = 'Version';
  {$EXTERNALSYM GOPHER_VERSION_ATTRIBUTE}
  GOPHER_ABSTRACT_ATTRIBUTE      = 'Abstract';
  {$EXTERNALSYM GOPHER_ABSTRACT_ATTRIBUTE}
  GOPHER_VIEW_ATTRIBUTE          = 'View';
  {$EXTERNALSYM GOPHER_VIEW_ATTRIBUTE}
  GOPHER_TREEWALK_ATTRIBUTE      = 'treewalk';
  {$EXTERNALSYM GOPHER_TREEWALK_ATTRIBUTE}

{ identifiers for attribute strings }

  GOPHER_ATTRIBUTE_ID_BASE = $abcccc00;
  {$EXTERNALSYM GOPHER_ATTRIBUTE_ID_BASE}
  GOPHER_CATEGORY_ID_ALL = GOPHER_ATTRIBUTE_ID_BASE + 1;
  {$EXTERNALSYM GOPHER_CATEGORY_ID_ALL}
  GOPHER_CATEGORY_ID_INFO = GOPHER_ATTRIBUTE_ID_BASE + 2;
  {$EXTERNALSYM GOPHER_CATEGORY_ID_INFO}
  GOPHER_CATEGORY_ID_ADMIN = GOPHER_ATTRIBUTE_ID_BASE + 3;
  {$EXTERNALSYM GOPHER_CATEGORY_ID_ADMIN}
  GOPHER_CATEGORY_ID_VIEWS = GOPHER_ATTRIBUTE_ID_BASE + 4;
  {$EXTERNALSYM GOPHER_CATEGORY_ID_VIEWS}
  GOPHER_CATEGORY_ID_ABSTRACT = GOPHER_ATTRIBUTE_ID_BASE + 5;
  {$EXTERNALSYM GOPHER_CATEGORY_ID_ABSTRACT}
  GOPHER_CATEGORY_ID_VERONICA = GOPHER_ATTRIBUTE_ID_BASE + 6;
  {$EXTERNALSYM GOPHER_CATEGORY_ID_VERONICA}
  GOPHER_CATEGORY_ID_ASK = GOPHER_ATTRIBUTE_ID_BASE + 7;
  {$EXTERNALSYM GOPHER_CATEGORY_ID_ASK}
  GOPHER_CATEGORY_ID_UNKNOWN = GOPHER_ATTRIBUTE_ID_BASE + 8;
  {$EXTERNALSYM GOPHER_CATEGORY_ID_UNKNOWN}
  GOPHER_ATTRIBUTE_ID_ALL = GOPHER_ATTRIBUTE_ID_BASE + 9;
  {$EXTERNALSYM GOPHER_ATTRIBUTE_ID_ALL}
  GOPHER_ATTRIBUTE_ID_ADMIN = GOPHER_ATTRIBUTE_ID_BASE + 10;
  {$EXTERNALSYM GOPHER_ATTRIBUTE_ID_ADMIN}
  GOPHER_ATTRIBUTE_ID_MOD_DATE = GOPHER_ATTRIBUTE_ID_BASE + 11;
  {$EXTERNALSYM GOPHER_ATTRIBUTE_ID_MOD_DATE}
  GOPHER_ATTRIBUTE_ID_TTL = GOPHER_ATTRIBUTE_ID_BASE + 12;
  {$EXTERNALSYM GOPHER_ATTRIBUTE_ID_TTL}
  GOPHER_ATTRIBUTE_ID_SCORE = GOPHER_ATTRIBUTE_ID_BASE + 13;
  {$EXTERNALSYM GOPHER_ATTRIBUTE_ID_SCORE}
  GOPHER_ATTRIBUTE_ID_RANGE = GOPHER_ATTRIBUTE_ID_BASE + 14;
  {$EXTERNALSYM GOPHER_ATTRIBUTE_ID_RANGE}
  GOPHER_ATTRIBUTE_ID_SITE = GOPHER_ATTRIBUTE_ID_BASE + 15;
  {$EXTERNALSYM GOPHER_ATTRIBUTE_ID_SITE}
  GOPHER_ATTRIBUTE_ID_ORG = GOPHER_ATTRIBUTE_ID_BASE + 16;
  {$EXTERNALSYM GOPHER_ATTRIBUTE_ID_ORG}
  GOPHER_ATTRIBUTE_ID_LOCATION = GOPHER_ATTRIBUTE_ID_BASE + 17;
  {$EXTERNALSYM GOPHER_ATTRIBUTE_ID_LOCATION}
  GOPHER_ATTRIBUTE_ID_GEOG = GOPHER_ATTRIBUTE_ID_BASE + 18;
  {$EXTERNALSYM GOPHER_ATTRIBUTE_ID_GEOG}
  GOPHER_ATTRIBUTE_ID_TIMEZONE = GOPHER_ATTRIBUTE_ID_BASE + 19;
  {$EXTERNALSYM GOPHER_ATTRIBUTE_ID_TIMEZONE}
  GOPHER_ATTRIBUTE_ID_PROVIDER = GOPHER_ATTRIBUTE_ID_BASE + 20;
  {$EXTERNALSYM GOPHER_ATTRIBUTE_ID_PROVIDER}
  GOPHER_ATTRIBUTE_ID_VERSION = GOPHER_ATTRIBUTE_ID_BASE + 21;
  {$EXTERNALSYM GOPHER_ATTRIBUTE_ID_VERSION}
  GOPHER_ATTRIBUTE_ID_ABSTRACT = GOPHER_ATTRIBUTE_ID_BASE + 22;
  {$EXTERNALSYM GOPHER_ATTRIBUTE_ID_ABSTRACT}
  GOPHER_ATTRIBUTE_ID_VIEW = GOPHER_ATTRIBUTE_ID_BASE + 23;
  {$EXTERNALSYM GOPHER_ATTRIBUTE_ID_VIEW}
  GOPHER_ATTRIBUTE_ID_TREEWALK = GOPHER_ATTRIBUTE_ID_BASE + 24;
  {$EXTERNALSYM GOPHER_ATTRIBUTE_ID_TREEWALK}
  GOPHER_ATTRIBUTE_ID_UNKNOWN = GOPHER_ATTRIBUTE_ID_BASE + 25;
  {$EXTERNALSYM GOPHER_ATTRIBUTE_ID_UNKNOWN}
  
{ prototypes }

function GopherCreateLocator(lpszHost: PChar; nServerPort: INTERNET_PORT;
  lpszDisplayString: PChar; lpszSelectorString: PChar; dwGopherType: DWORD;
  lpszLocator: PChar; var lpdwBufferLength: DWORD): BOOL; stdcall;
  {$EXTERNALSYM GopherCreateLocator}
function GopherCreateLocatorA(lpszHost: PAnsiChar; nServerPort: INTERNET_PORT;
  lpszDisplayString: PAnsiChar; lpszSelectorString: PAnsiChar; dwGopherType: DWORD;
  lpszLocator: PAnsiChar; var lpdwBufferLength: DWORD): BOOL; stdcall;
  {$EXTERNALSYM GopherCreateLocatorA}
function GopherCreateLocatorW(lpszHost: PWideChar; nServerPort: INTERNET_PORT;
  lpszDisplayString: PWideChar; lpszSelectorString: PWideChar; dwGopherType: DWORD;
  lpszLocator: PWideChar; var lpdwBufferLength: DWORD): BOOL; stdcall;
  {$EXTERNALSYM GopherCreateLocatorW}

function GopherGetLocatorType(lpszLocator: PChar;
  var lpdwGopherType: DWORD): BOOL; stdcall;
  {$EXTERNALSYM GopherGetLocatorType}
function GopherGetLocatorTypeA(lpszLocator: PAnsiChar;
  var lpdwGopherType: DWORD): BOOL; stdcall;
  {$EXTERNALSYM GopherGetLocatorTypeA}
function GopherGetLocatorTypeW(lpszLocator: PWideChar;
  var lpdwGopherType: DWORD): BOOL; stdcall;
  {$EXTERNALSYM GopherGetLocatorTypeW}

function GopherFindFirstFile(hConnect: HINTERNET; lpszLocator: PChar;
  lpszSearchString: PChar; var lpFindData: TGopherFindData; dwFlags: DWORD;
  dwContext: DWORD): HINTERNET; stdcall;
  {$EXTERNALSYM GopherFindFirstFile}
function GopherFindFirstFileA(hConnect: HINTERNET; lpszLocator: PAnsiChar;
  lpszSearchString: PAnsiChar; var lpFindData: TGopherFindDataA; dwFlags: DWORD;
  dwContext: DWORD): HINTERNET; stdcall;
  {$EXTERNALSYM GopherFindFirstFileA}
function GopherFindFirstFileW(hConnect: HINTERNET; lpszLocator: PWideChar;
  lpszSearchString: PWideChar; var lpFindData: TGopherFindDataW; dwFlags: DWORD;
  dwContext: DWORD): HINTERNET; stdcall;
  {$EXTERNALSYM GopherFindFirstFileW}

function GopherOpenFile(hConnect: HINTERNET; lpszLocator: PChar;
  lpszView: PChar; dwFlags: DWORD; dwContext: DWORD): HINTERNET; stdcall;
  {$EXTERNALSYM GopherOpenFile}
function GopherOpenFileA(hConnect: HINTERNET; lpszLocator: PAnsiChar;
  lpszView: PAnsiChar; dwFlags: DWORD; dwContext: DWORD): HINTERNET; stdcall;
  {$EXTERNALSYM GopherOpenFileA}
function GopherOpenFileW(hConnect: HINTERNET; lpszLocator: PWideChar;
  lpszView: PWideChar; dwFlags: DWORD; dwContext: DWORD): HINTERNET; stdcall;
  {$EXTERNALSYM GopherOpenFileW}

type




  GOPHER_ATTRIBUTE_ENUMERATOR = TFarProc;

  {$EXTERNALSYM GOPHER_ATTRIBUTE_ENUMERATOR}
  TFNGopherAttributeEnumerator = GOPHER_ATTRIBUTE_ENUMERATOR;
  PFNGopherAttributeEnumerator = ^TFNGopherAttributeEnumerator;

function GopherGetAttribute(hConnect: HINTERNET; lpszLocator: PChar;
  lpszAttributeName: PChar; lpBuffer: Pointer; dwBufferLength: DWORD;
  var lpdwCharactersReturned: DWORD; lpfnEnumerator: PFNGopherAttributeEnumerator;
  dwContext: DWORD): BOOL; stdcall;
  {$EXTERNALSYM GopherGetAttribute}
function GopherGetAttributeA(hConnect: HINTERNET; lpszLocator: PAnsiChar;
  lpszAttributeName: PAnsiChar; lpBuffer: Pointer; dwBufferLength: DWORD;
  var lpdwCharactersReturned: DWORD; lpfnEnumerator: PFNGopherAttributeEnumerator;
  dwContext: DWORD): BOOL; stdcall;
  {$EXTERNALSYM GopherGetAttributeA}
function GopherGetAttributeW(hConnect: HINTERNET; lpszLocator: PWideChar;
  lpszAttributeName: PWideChar; lpBuffer: Pointer; dwBufferLength: DWORD;
  var lpdwCharactersReturned: DWORD; lpfnEnumerator: PFNGopherAttributeEnumerator;
  dwContext: DWORD): BOOL; stdcall;
  {$EXTERNALSYM GopherGetAttributeW}

{ HTTP }

{ manifests }

const
{ the default major/minor HTTP version numbers }

  HTTP_MAJOR_VERSION = 1;
  {$EXTERNALSYM HTTP_MAJOR_VERSION}
  HTTP_MINOR_VERSION = 0;
  {$EXTERNALSYM HTTP_MINOR_VERSION}
  HTTP_VERSION       = 'HTTP/1.0';
  {$EXTERNALSYM HTTP_VERSION}

{ HttpQueryInfo info levels. Generally, there is one info level }
{ for each potential RFC822/HTTP/MIME header that an HTTP server }
{ may send as part of a request response. }

{ The HTTP_QUERY_RAW_HEADERS info level is provided for clients }
{ that choose to perform their own header parsing. }

  HTTP_QUERY_MIME_VERSION                     = 0;
  {$EXTERNALSYM HTTP_QUERY_MIME_VERSION}
  HTTP_QUERY_CONTENT_TYPE                     = 1;
  {$EXTERNALSYM HTTP_QUERY_CONTENT_TYPE}
  HTTP_QUERY_CONTENT_TRANSFER_ENCODING        = 2;
  {$EXTERNALSYM HTTP_QUERY_CONTENT_TRANSFER_ENCODING}
  HTTP_QUERY_CONTENT_ID                       = 3;
  {$EXTERNALSYM HTTP_QUERY_CONTENT_ID}
  HTTP_QUERY_CONTENT_DESCRIPTION              = 4;
  {$EXTERNALSYM HTTP_QUERY_CONTENT_DESCRIPTION}
  HTTP_QUERY_CONTENT_LENGTH                   = 5;
  {$EXTERNALSYM HTTP_QUERY_CONTENT_LENGTH}
  HTTP_QUERY_CONTENT_LANGUAGE                 = 6;
  {$EXTERNALSYM HTTP_QUERY_CONTENT_LANGUAGE}
  HTTP_QUERY_ALLOW                            = 7;
  {$EXTERNALSYM HTTP_QUERY_ALLOW}
  HTTP_QUERY_PUBLIC                           = 8;
  {$EXTERNALSYM HTTP_QUERY_PUBLIC}
  HTTP_QUERY_DATE                             = 9;
  {$EXTERNALSYM HTTP_QUERY_DATE}
  HTTP_QUERY_EXPIRES                          = 10;
  {$EXTERNALSYM HTTP_QUERY_EXPIRES}
  HTTP_QUERY_LAST_MODIFIED                    = 11;
  {$EXTERNALSYM HTTP_QUERY_LAST_MODIFIED}
  HTTP_QUERY_MESSAGE_ID                       = 12;
  {$EXTERNALSYM HTTP_QUERY_MESSAGE_ID}
  HTTP_QUERY_URI                              = 13;
  {$EXTERNALSYM HTTP_QUERY_URI}
  HTTP_QUERY_DERIVED_FROM                     = 14;
  {$EXTERNALSYM HTTP_QUERY_DERIVED_FROM}
  HTTP_QUERY_COST                             = 15;
  {$EXTERNALSYM HTTP_QUERY_COST}
  HTTP_QUERY_LINK                             = 16;
  {$EXTERNALSYM HTTP_QUERY_LINK}
  HTTP_QUERY_PRAGMA                           = 17;
  {$EXTERNALSYM HTTP_QUERY_PRAGMA}
  HTTP_QUERY_VERSION                          = 18; { special: part of status line }
  {$EXTERNALSYM HTTP_QUERY_VERSION}
  HTTP_QUERY_STATUS_CODE                      = 19; { special: part of status line }
  {$EXTERNALSYM HTTP_QUERY_STATUS_CODE}
  HTTP_QUERY_STATUS_TEXT                      = 20; { special: part of status line }
  {$EXTERNALSYM HTTP_QUERY_STATUS_TEXT}
  HTTP_QUERY_RAW_HEADERS                      = 21; { special: all headers as ASCIIZ }
  {$EXTERNALSYM HTTP_QUERY_RAW_HEADERS}
  HTTP_QUERY_RAW_HEADERS_CRLF                 = 22; { special: all headers }
  {$EXTERNALSYM HTTP_QUERY_RAW_HEADERS_CRLF}
  HTTP_QUERY_CONNECTION                       = 23;
  {$EXTERNALSYM HTTP_QUERY_CONNECTION}
  HTTP_QUERY_ACCEPT                           = 24;
  {$EXTERNALSYM HTTP_QUERY_ACCEPT}
  HTTP_QUERY_ACCEPT_CHARSET                   = 25;
  {$EXTERNALSYM HTTP_QUERY_ACCEPT_CHARSET}
  HTTP_QUERY_ACCEPT_ENCODING                  = 26;
  {$EXTERNALSYM HTTP_QUERY_ACCEPT_ENCODING}
  HTTP_QUERY_ACCEPT_LANGUAGE                  = 27;
  {$EXTERNALSYM HTTP_QUERY_ACCEPT_LANGUAGE}
  HTTP_QUERY_AUTHORIZATION                    = 28;
  {$EXTERNALSYM HTTP_QUERY_AUTHORIZATION}
  HTTP_QUERY_CONTENT_ENCODING                 = 29;
  {$EXTERNALSYM HTTP_QUERY_CONTENT_ENCODING}
  HTTP_QUERY_FORWARDED                        = 30;
  {$EXTERNALSYM HTTP_QUERY_FORWARDED}
  HTTP_QUERY_FROM                             = 31;
  {$EXTERNALSYM HTTP_QUERY_FROM}
  HTTP_QUERY_IF_MODIFIED_SINCE                = 32;
  {$EXTERNALSYM HTTP_QUERY_IF_MODIFIED_SINCE}
  HTTP_QUERY_LOCATION                         = 33;
  {$EXTERNALSYM HTTP_QUERY_LOCATION}
  HTTP_QUERY_ORIG_URI                         = 34;
  {$EXTERNALSYM HTTP_QUERY_ORIG_URI}
  HTTP_QUERY_REFERER                          = 35;
  {$EXTERNALSYM HTTP_QUERY_REFERER}
  HTTP_QUERY_RETRY_AFTER                      = 36;
  {$EXTERNALSYM HTTP_QUERY_RETRY_AFTER}
  HTTP_QUERY_SERVER                           = 37;
  {$EXTERNALSYM HTTP_QUERY_SERVER}
  HTTP_QUERY_TITLE                            = 38;
  {$EXTERNALSYM HTTP_QUERY_TITLE}
  HTTP_QUERY_USER_AGENT                       = 39;
  {$EXTERNALSYM HTTP_QUERY_USER_AGENT}
  HTTP_QUERY_WWW_AUTHENTICATE                 = 40;
  {$EXTERNALSYM HTTP_QUERY_WWW_AUTHENTICATE}
  HTTP_QUERY_PROXY_AUTHENTICATE               = 41;
  {$EXTERNALSYM HTTP_QUERY_PROXY_AUTHENTICATE}
  HTTP_QUERY_ACCEPT_RANGES                    = 42;
  {$EXTERNALSYM HTTP_QUERY_ACCEPT_RANGES}
  HTTP_QUERY_SET_COOKIE                       = 43;
  {$EXTERNALSYM HTTP_QUERY_SET_COOKIE}
  HTTP_QUERY_COOKIE                           = 44;
  {$EXTERNALSYM HTTP_QUERY_COOKIE}
  HTTP_QUERY_REQUEST_METHOD                   = 45;  { special: GET/POST etc. }
  {$EXTERNALSYM HTTP_QUERY_REQUEST_METHOD}
  HTTP_QUERY_REFRESH                          = 46;
  {$EXTERNALSYM HTTP_QUERY_REFRESH}
  HTTP_QUERY_CONTENT_DISPOSITION              = 47;
  {$EXTERNALSYM HTTP_QUERY_CONTENT_DISPOSITION}

{ HTTP 1.1 defined headers }

  HTTP_QUERY_AGE                              = 48;
  {$EXTERNALSYM HTTP_QUERY_AGE}
  HTTP_QUERY_CACHE_CONTROL                    = 49;
  {$EXTERNALSYM HTTP_QUERY_CACHE_CONTROL}
  HTTP_QUERY_CONTENT_BASE                     = 50;
  {$EXTERNALSYM HTTP_QUERY_CONTENT_BASE}
  HTTP_QUERY_CONTENT_LOCATION                 = 51;
  {$EXTERNALSYM HTTP_QUERY_CONTENT_LOCATION}
  HTTP_QUERY_CONTENT_MD5                      = 52;
  {$EXTERNALSYM HTTP_QUERY_CONTENT_MD5}
  HTTP_QUERY_CONTENT_RANGE                    = 53;
  {$EXTERNALSYM HTTP_QUERY_CONTENT_RANGE}
  HTTP_QUERY_ETAG                             = 54;
  {$EXTERNALSYM HTTP_QUERY_ETAG}
  HTTP_QUERY_HOST                             = 55;
  {$EXTERNALSYM HTTP_QUERY_HOST}
  HTTP_QUERY_IF_MATCH                         = 56;
  {$EXTERNALSYM HTTP_QUERY_IF_MATCH}
  HTTP_QUERY_IF_NONE_MATCH                    = 57;
  {$EXTERNALSYM HTTP_QUERY_IF_NONE_MATCH}
  HTTP_QUERY_IF_RANGE                         = 58;
  {$EXTERNALSYM HTTP_QUERY_IF_RANGE}
  HTTP_QUERY_IF_UNMODIFIED_SINCE              = 59;
  {$EXTERNALSYM HTTP_QUERY_IF_UNMODIFIED_SINCE}
  HTTP_QUERY_MAX_FORWARDS                     = 60;
  {$EXTERNALSYM HTTP_QUERY_MAX_FORWARDS}
  HTTP_QUERY_PROXY_AUTHORIZATION              = 61;
  {$EXTERNALSYM HTTP_QUERY_PROXY_AUTHORIZATION}
  HTTP_QUERY_RANGE                            = 62;
  {$EXTERNALSYM HTTP_QUERY_RANGE}
  HTTP_QUERY_TRANSFER_ENCODING                = 63;
  {$EXTERNALSYM HTTP_QUERY_TRANSFER_ENCODING}
  HTTP_QUERY_UPGRADE                          = 64;
  {$EXTERNALSYM HTTP_QUERY_UPGRADE}
  HTTP_QUERY_VARY                             = 65;
  {$EXTERNALSYM HTTP_QUERY_VARY}
  HTTP_QUERY_VIA                              = 66;
  {$EXTERNALSYM HTTP_QUERY_VIA}
  HTTP_QUERY_WARNING                          = 67;
  {$EXTERNALSYM HTTP_QUERY_WARNING}
  HTTP_QUERY_MAX                              = 67;
  {$EXTERNALSYM HTTP_QUERY_MAX}

{ HTTP_QUERY_CUSTOM - if this special value is supplied as the dwInfoLevel }
{ parameter of HttpQueryInfo then the lpBuffer parameter contains the name }
{ of the header we are to query }
  HTTP_QUERY_CUSTOM                           = 65535;
  {$EXTERNALSYM HTTP_QUERY_CUSTOM}

{ HTTP_QUERY_FLAG_REQUEST_HEADERS - if this bit is set in the dwInfoLevel }
{ parameter of HttpQueryInfo then the request headers will be queried for the }
{ request information }
  HTTP_QUERY_FLAG_REQUEST_HEADERS             = $80000000;
  {$EXTERNALSYM HTTP_QUERY_FLAG_REQUEST_HEADERS}

{ HTTP_QUERY_FLAG_SYSTEMTIME - if this bit is set in the dwInfoLevel parameter }
{ of HttpQueryInfo AND the header being queried contains date information, }
{ e.g. the "Expires:" header then lpBuffer will contain a SYSTEMTIME structure }
{ containing the date and time information converted from the header string }
  HTTP_QUERY_FLAG_SYSTEMTIME                  = $40000000;
  {$EXTERNALSYM HTTP_QUERY_FLAG_SYSTEMTIME}

{ HTTP_QUERY_FLAG_NUMBER - if this bit is set in the dwInfoLevel parameter of }
{ HttpQueryInfo, then the value of the header will be converted to a number }
{ before being returned to the caller, if applicable }
  HTTP_QUERY_FLAG_NUMBER                      = $20000000;
  {$EXTERNALSYM HTTP_QUERY_FLAG_NUMBER}

{ HTTP_QUERY_FLAG_COALESCE - combine the values from several headers of the }
{ same name into the output buffer }
  HTTP_QUERY_FLAG_COALESCE                    = $10000000;
  {$EXTERNALSYM HTTP_QUERY_FLAG_COALESCE}

  HTTP_QUERY_MODIFIER_FLAGS_MASK              = HTTP_QUERY_FLAG_REQUEST_HEADERS or
                                                HTTP_QUERY_FLAG_SYSTEMTIME or
                                                HTTP_QUERY_FLAG_NUMBER or
                                                HTTP_QUERY_FLAG_COALESCE;
  {$EXTERNALSYM HTTP_QUERY_MODIFIER_FLAGS_MASK}

  HTTP_QUERY_HEADER_MASK                      = not HTTP_QUERY_MODIFIER_FLAGS_MASK;
  {$EXTERNALSYM HTTP_QUERY_HEADER_MASK}

{  HTTP Response Status Codes: }
  HTTP_STATUS_CONTINUE            = 100;    { OK to continue with request }
  {$EXTERNALSYM HTTP_STATUS_CONTINUE}
  HTTP_STATUS_SWITCH_PROTOCOLS    = 101;    { server has switched protocols in upgrade header }
  {$EXTERNALSYM HTTP_STATUS_SWITCH_PROTOCOLS}
  HTTP_STATUS_OK                  = 200;    { request completed }
  {$EXTERNALSYM HTTP_STATUS_OK}
  HTTP_STATUS_CREATED             = 201;    { object created, reason = new URI }
  {$EXTERNALSYM HTTP_STATUS_CREATED}
  HTTP_STATUS_ACCEPTED            = 202;    { async completion (TBS) }
  {$EXTERNALSYM HTTP_STATUS_ACCEPTED}
  HTTP_STATUS_PARTIAL             = 203;    { partial completion }
  {$EXTERNALSYM HTTP_STATUS_PARTIAL}
  HTTP_STATUS_NO_CONTENT          = 204;    { no info to return }
  {$EXTERNALSYM HTTP_STATUS_NO_CONTENT}
  HTTP_STATUS_RESET_CONTENT       = 205;    { request completed, but clear form }
  {$EXTERNALSYM HTTP_STATUS_RESET_CONTENT}
  HTTP_STATUS_PARTIAL_CONTENT     = 206;    { partial GET furfilled }
  {$EXTERNALSYM HTTP_STATUS_PARTIAL_CONTENT}
  HTTP_STATUS_AMBIGUOUS           = 300;    { server couldn't decide what to return }
  {$EXTERNALSYM HTTP_STATUS_AMBIGUOUS}
  HTTP_STATUS_MOVED               = 301;    { object permanently moved }
  {$EXTERNALSYM HTTP_STATUS_MOVED}
  HTTP_STATUS_REDIRECT            = 302;    { object temporarily moved }
  {$EXTERNALSYM HTTP_STATUS_REDIRECT}
  HTTP_STATUS_REDIRECT_METHOD     = 303;    { redirection w/ new access method }
  {$EXTERNALSYM HTTP_STATUS_REDIRECT_METHOD}
  HTTP_STATUS_NOT_MODIFIED        = 304;    { if-modified-since was not modified }
  {$EXTERNALSYM HTTP_STATUS_NOT_MODIFIED}
  HTTP_STATUS_USE_PROXY           = 305;    { redirection to proxy, location header specifies proxy to use }
  {$EXTERNALSYM HTTP_STATUS_USE_PROXY}
  HTTP_STATUS_REDIRECT_KEEP_VERB  = 307;    { HTTP/1.1: keep same verb }
  {$EXTERNALSYM HTTP_STATUS_REDIRECT_KEEP_VERB}
  HTTP_STATUS_BAD_REQUEST         = 400;    { invalid syntax }
  {$EXTERNALSYM HTTP_STATUS_BAD_REQUEST}
  HTTP_STATUS_DENIED              = 401;    { access denied }
  {$EXTERNALSYM HTTP_STATUS_DENIED}
  HTTP_STATUS_PAYMENT_REQ         = 402;    { payment required }
  {$EXTERNALSYM HTTP_STATUS_PAYMENT_REQ}
  HTTP_STATUS_FORBIDDEN           = 403;    { request forbidden }
  {$EXTERNALSYM HTTP_STATUS_FORBIDDEN}
  HTTP_STATUS_NOT_FOUND           = 404;    { object not found }
  {$EXTERNALSYM HTTP_STATUS_NOT_FOUND}
  HTTP_STATUS_BAD_METHOD          = 405;    { method is not allowed }
  {$EXTERNALSYM HTTP_STATUS_BAD_METHOD}
  HTTP_STATUS_NONE_ACCEPTABLE     = 406;    { no response acceptable to client found }
  {$EXTERNALSYM HTTP_STATUS_NONE_ACCEPTABLE}
  HTTP_STATUS_PROXY_AUTH_REQ      = 407;    { proxy authentication required }
  {$EXTERNALSYM HTTP_STATUS_PROXY_AUTH_REQ}
  HTTP_STATUS_REQUEST_TIMEOUT     = 408;    { server timed out waiting for request }
  {$EXTERNALSYM HTTP_STATUS_REQUEST_TIMEOUT}
  HTTP_STATUS_CONFLICT            = 409;    { user should resubmit with more info }
  {$EXTERNALSYM HTTP_STATUS_CONFLICT}
  HTTP_STATUS_GONE                = 410;    { the resource is no longer available }
  {$EXTERNALSYM HTTP_STATUS_GONE}
  HTTP_STATUS_AUTH_REFUSED        = 411;    { couldn't authorize client }
  {$EXTERNALSYM HTTP_STATUS_AUTH_REFUSED}
  HTTP_STATUS_PRECOND_FAILED      = 412;    { precondition given in request failed }
  {$EXTERNALSYM HTTP_STATUS_PRECOND_FAILED}
  HTTP_STATUS_REQUEST_TOO_LARGE   = 413;    { request entity was too large }
  {$EXTERNALSYM HTTP_STATUS_REQUEST_TOO_LARGE}
  HTTP_STATUS_URI_TOO_LONG        = 414;    { request URI too long }
  {$EXTERNALSYM HTTP_STATUS_URI_TOO_LONG}
  HTTP_STATUS_UNSUPPORTED_MEDIA   = 415;    { unsupported media type }
  {$EXTERNALSYM HTTP_STATUS_UNSUPPORTED_MEDIA}
  HTTP_STATUS_SERVER_ERROR        = 500;    { internal server error }
  {$EXTERNALSYM HTTP_STATUS_SERVER_ERROR}
  HTTP_STATUS_NOT_SUPPORTED       = 501;    { required not supported }
  {$EXTERNALSYM HTTP_STATUS_NOT_SUPPORTED}
  HTTP_STATUS_BAD_GATEWAY         = 502;    { error response received from gateway }
  {$EXTERNALSYM HTTP_STATUS_BAD_GATEWAY}
  HTTP_STATUS_SERVICE_UNAVAIL     = 503;    { temporarily overloaded }
  {$EXTERNALSYM HTTP_STATUS_SERVICE_UNAVAIL}
  HTTP_STATUS_GATEWAY_TIMEOUT     = 504;    { timed out waiting for gateway }
  {$EXTERNALSYM HTTP_STATUS_GATEWAY_TIMEOUT}
  HTTP_STATUS_VERSION_NOT_SUP     = 505;    { HTTP version not supported }
  {$EXTERNALSYM HTTP_STATUS_VERSION_NOT_SUP}
  HTTP_STATUS_FIRST               = HTTP_STATUS_CONTINUE;
  {$EXTERNALSYM HTTP_STATUS_FIRST}
  HTTP_STATUS_LAST                = HTTP_STATUS_VERSION_NOT_SUP;
  {$EXTERNALSYM HTTP_STATUS_LAST}

{ prototypes }

function HttpOpenRequest(hConnect: HINTERNET; lpszVerb: PChar;
  lpszObjectName: PChar; lpszVersion: PChar; lpszReferrer: PChar;
  lplpszAcceptTypes: PLPSTR; dwFlags: DWORD;
  dwContext: DWORD): HINTERNET; stdcall;
  {$EXTERNALSYM HttpOpenRequest}
function HttpOpenRequestA(hConnect: HINTERNET; lpszVerb: PAnsiChar;
  lpszObjectName: PAnsiChar; lpszVersion: PAnsiChar; lpszReferrer: PAnsiChar;
  lplpszAcceptTypes: PLPSTR; dwFlags: DWORD;
  dwContext: DWORD): HINTERNET; stdcall;
  {$EXTERNALSYM HttpOpenRequestA}
function HttpOpenRequestW(hConnect: HINTERNET; lpszVerb: PWideChar;
  lpszObjectName: PWideChar; lpszVersion: PWideChar; lpszReferrer: PWideChar;
  lplpszAcceptTypes: PLPWSTR; dwFlags: DWORD;
  dwContext: DWORD): HINTERNET; stdcall;
  {$EXTERNALSYM HttpOpenRequestW}

function HttpAddRequestHeaders(hRequest: HINTERNET; lpszHeaders: PChar;
  dwHeadersLength: DWORD; dwModifiers: DWORD): BOOL; stdcall;
  {$EXTERNALSYM HttpAddRequestHeaders}
function HttpAddRequestHeadersA(hRequest: HINTERNET; lpszHeaders: PAnsiChar;
  dwHeadersLength: DWORD; dwModifiers: DWORD): BOOL; stdcall;
  {$EXTERNALSYM HttpAddRequestHeadersA}
function HttpAddRequestHeadersW(hRequest: HINTERNET; lpszHeaders: PWideChar;
  dwHeadersLength: DWORD; dwModifiers: DWORD): BOOL; stdcall;
  {$EXTERNALSYM HttpAddRequestHeadersW}

const
{ values for dwModifiers parameter of HttpAddRequestHeaders }

  HTTP_ADDREQ_INDEX_MASK          = $0000FFFF;
  {$EXTERNALSYM HTTP_ADDREQ_INDEX_MASK}
  HTTP_ADDREQ_FLAGS_MASK          = $FFFF0000;
  {$EXTERNALSYM HTTP_ADDREQ_FLAGS_MASK}

{ HTTP_ADDREQ_FLAG_ADD_IF_NEW - the header will only be added if it doesn't }
{ already exist }

  HTTP_ADDREQ_FLAG_ADD_IF_NEW     = $10000000;
  {$EXTERNALSYM HTTP_ADDREQ_FLAG_ADD_IF_NEW}

{ HTTP_ADDREQ_FLAG_ADD - if HTTP_ADDREQ_FLAG_REPLACE is set but the header is }
{ not found then if this flag is set, the header is added anyway, so long as }
{ there is a valid header-value }

  HTTP_ADDREQ_FLAG_ADD            = $20000000;
  {$EXTERNALSYM HTTP_ADDREQ_FLAG_ADD}

{ HTTP_ADDREQ_FLAG_COALESCE - coalesce headers with same name. e.g. }
{ "Accept: text/*" and "Accept: audio/*" with this flag results in a single }
{ header: "Accept: text/*, audio/*" }

  HTTP_ADDREQ_FLAG_COALESCE_WITH_COMMA           = $40000000;
  {$EXTERNALSYM HTTP_ADDREQ_FLAG_COALESCE_WITH_COMMA}
  HTTP_ADDREQ_FLAG_COALESCE_WITH_SEMICOLON       = $01000000;
  {$EXTERNALSYM HTTP_ADDREQ_FLAG_COALESCE_WITH_SEMICOLON}
  HTTP_ADDREQ_FLAG_COALESCE                      = HTTP_ADDREQ_FLAG_COALESCE_WITH_COMMA;
  {$EXTERNALSYM HTTP_ADDREQ_FLAG_COALESCE}

{ HTTP_ADDREQ_FLAG_REPLACE - replaces the specified header. Only one header can }
{ be supplied in the buffer. If the header to be replaced is not the first }
{ in a list of headers with the same name, then the relative index should be }
{ supplied in the low 8 bits of the dwModifiers parameter. If the header-value }
{ part is missing, then the header is removed }

  HTTP_ADDREQ_FLAG_REPLACE        = $80000000;
  {$EXTERNALSYM HTTP_ADDREQ_FLAG_REPLACE}

function HttpSendRequest(hRequest: HINTERNET; lpszHeaders: PChar; 
  dwHeadersLength: DWORD; lpOptional: Pointer; 
  dwOptionalLength: DWORD): BOOL; stdcall;
  {$EXTERNALSYM HttpSendRequest}
function HttpSendRequestA(hRequest: HINTERNET; lpszHeaders: PAnsiChar; 
  dwHeadersLength: DWORD; lpOptional: Pointer; 
  dwOptionalLength: DWORD): BOOL; stdcall;
  {$EXTERNALSYM HttpSendRequestA}
function HttpSendRequestW(hRequest: HINTERNET; lpszHeaders: PWideChar; 
  dwHeadersLength: DWORD; lpOptional: Pointer; 
  dwOptionalLength: DWORD): BOOL; stdcall;
  {$EXTERNALSYM HttpSendRequestW}

function HttpSendRequestEx(hRequest: HINTERNET; lpBuffersIn: PInternetBuffers;
    lpBuffersOut: PInternetBuffers;
    dwFlags: DWORD; dwContext: DWORD): BOOL; stdcall;
  {$EXTERNALSYM HttpSendRequestEx}
function HttpSendRequestExA(hRequest: HINTERNET; lpBuffersIn: PInternetBuffers;
    lpBuffersOut: PInternetBuffers;
    dwFlags: DWORD; dwContext: DWORD): BOOL; stdcall;
  {$EXTERNALSYM HttpSendRequestExA}
function HttpSendRequestExW(hRequest: HINTERNET; lpBuffersIn: PInternetBuffers;
    lpBuffersOut: PInternetBuffers;
    dwFlags: DWORD; dwContext: DWORD): BOOL; stdcall;
  {$EXTERNALSYM HttpSendRequestExW}

{ flags for HttpSendRequestEx(), HttpEndRequest() }
const
  HSR_ASYNC       = WININET_API_FLAG_ASYNC;          { force async }
  {$EXTERNALSYM HSR_ASYNC}
  HSR_SYNC        = WININET_API_FLAG_SYNC;           { force sync }
  {$EXTERNALSYM HSR_SYNC}
  HSR_USE_CONTEXT = WININET_API_FLAG_USE_CONTEXT;    { use dwContext value }
  {$EXTERNALSYM HSR_USE_CONTEXT}
  HSR_INITIATE    = $00000008;                       { iterative operation (completed by HttpEndRequest) }
  {$EXTERNALSYM HSR_INITIATE}
  HSR_DOWNLOAD    = $00000010;                       { download to file }
  {$EXTERNALSYM HSR_DOWNLOAD}
  HSR_CHUNKED     = $00000020;                       { operation is send of chunked data }
  {$EXTERNALSYM HSR_CHUNKED}

function HttpEndRequest(hRequest: HINTERNET;
  lpBuffersOut: PInternetBuffers; dwFlags: DWORD;
  dwContext: DWORD): BOOL; stdcall;
  {$EXTERNALSYM HttpEndRequest}
function HttpEndRequestA(hRequest: HINTERNET;
  lpBuffersOut: PInternetBuffers; dwFlags: DWORD;
  dwContext: DWORD): BOOL; stdcall;
  {$EXTERNALSYM HttpEndRequestA}
function HttpEndRequestW(hRequest: HINTERNET;
  lpBuffersOut: PInternetBuffers; dwFlags: DWORD;
  dwContext: DWORD): BOOL; stdcall;
  {$EXTERNALSYM HttpEndRequestW}

function HttpQueryInfo(hRequest: HINTERNET; dwInfoLevel: DWORD;
  lpvBuffer: Pointer; var lpdwBufferLength: DWORD;
  var lpdwReserved: DWORD): BOOL; stdcall;
  {$EXTERNALSYM HttpQueryInfo}
function HttpQueryInfoA(hRequest: HINTERNET; dwInfoLevel: DWORD;
  lpvBuffer: Pointer; var lpdwBufferLength: DWORD;
  var lpdwReserved: DWORD): BOOL; stdcall;
  {$EXTERNALSYM HttpQueryInfoA}
function HttpQueryInfoW(hRequest: HINTERNET; dwInfoLevel: DWORD;
  lpvBuffer: Pointer; var lpdwBufferLength: DWORD;
  var lpdwReserved: DWORD): BOOL; stdcall;
  {$EXTERNALSYM HttpQueryInfoW}

{ Cookie APIs }

function InternetSetCookie(lpszUrl, lpszCookieName,
  lpszCookieData: PChar): BOOL; stdcall;
  {$EXTERNALSYM InternetSetCookie}
function InternetSetCookieA(lpszUrl, lpszCookieName,
  lpszCookieData: PAnsiChar): BOOL; stdcall;
  {$EXTERNALSYM InternetSetCookieA}
function InternetSetCookieW(lpszUrl, lpszCookieName,
  lpszCookieData: PWideChar): BOOL; stdcall;
  {$EXTERNALSYM InternetSetCookieW}

function InternetGetCookie(lpszUrl, lpszCookieName,
  lpszCookieData: PChar; var lpdwSize: DWORD): BOOL; stdcall;
  {$EXTERNALSYM InternetGetCookie}
function InternetGetCookieA(lpszUrl, lpszCookieName,
  lpszCookieData: PAnsiChar; var lpdwSize: DWORD): BOOL; stdcall;
  {$EXTERNALSYM InternetGetCookieA}
function InternetGetCookieW(lpszUrl, lpszCookieName,
  lpszCookieData: PWideChar; var lpdwSize: DWORD): BOOL; stdcall;
  {$EXTERNALSYM InternetGetCookieW}

function InternetAttemptConnect(dwReserved: DWORD): DWORD; stdcall;
  {$EXTERNALSYM InternetAttemptConnect}

function InternetCheckConnection(lpszUrl: PAnsiChar; dwFlags: DWORD;
    dwReserved: DWORD): BOOL; stdcall;
  {$EXTERNALSYM InternetCheckConnection}
function InternetCheckConnectionA(lpszUrl: PAnsiChar; dwFlags: DWORD;
    dwReserved: DWORD): BOOL; stdcall;
  {$EXTERNALSYM InternetCheckConnectionA}
function InternetCheckConnectionW(lpszUrl: PAnsiChar; dwFlags: DWORD;
    dwReserved: DWORD): BOOL; stdcall;
  {$EXTERNALSYM InternetCheckConnectionW}

{ Internet UI }

{ InternetErrorDlg - Provides UI for certain Errors. }
const
  FLAGS_ERROR_UI_FILTER_FOR_ERRORS            = $01;
  {$EXTERNALSYM FLAGS_ERROR_UI_FILTER_FOR_ERRORS}
  FLAGS_ERROR_UI_FLAGS_CHANGE_OPTIONS         = $02;
  {$EXTERNALSYM FLAGS_ERROR_UI_FLAGS_CHANGE_OPTIONS}
  FLAGS_ERROR_UI_FLAGS_GENERATE_DATA          = $04;
  {$EXTERNALSYM FLAGS_ERROR_UI_FLAGS_GENERATE_DATA}
  FLAGS_ERROR_UI_FLAGS_NO_UI                  = $08;
  {$EXTERNALSYM FLAGS_ERROR_UI_FLAGS_NO_UI}
  FLAGS_ERROR_UI_SERIALIZE_DIALOGS            = $10;
  {$EXTERNALSYM FLAGS_ERROR_UI_SERIALIZE_DIALOGS}

function InternetAuthNotifyCallback(
    dwContext: DWORD;     { as passed to InternetErrorDlg }
    dwReturn: DWORD;      { error code: success, resend, or cancel }
    lpReserved: Pointer   { reserved: will be set to null }
): DWORD; stdcall;
  {$EXTERNALSYM InternetAuthNotifyCallback}

type
  PFN_AUTH_NOTIFY = function(dwContext:DWORD; dwReturn:DWORD;
    lpReserved:Pointer): DWORD;
  {$EXTERNALSYM PFN_AUTH_NOTIFY}

function InternetErrorDlg(hWnd: HWND; hRequest: HINTERNET;
  dwError, dwFlags: DWORD; var lppvData: Pointer): DWORD; stdcall;
  {$EXTERNALSYM InternetErrorDlg}

function InternetConfirmZoneCrossing(hWnd: HWND;
  szUrlPrev, szUrlNew: LPSTR; bPost: BOOL): DWORD; stdcall;
  {$EXTERNALSYM InternetConfirmZoneCrossing}

const
{ Internet API error returns }

  INTERNET_ERROR_BASE                         = 12000;
  {$EXTERNALSYM INTERNET_ERROR_BASE}
  ERROR_INTERNET_OUT_OF_HANDLES               = INTERNET_ERROR_BASE + 1;
  {$EXTERNALSYM ERROR_INTERNET_OUT_OF_HANDLES}
  ERROR_INTERNET_TIMEOUT                      = INTERNET_ERROR_BASE + 2;
  {$EXTERNALSYM ERROR_INTERNET_TIMEOUT}
  ERROR_INTERNET_EXTENDED_ERROR               = INTERNET_ERROR_BASE + 3;
  {$EXTERNALSYM ERROR_INTERNET_EXTENDED_ERROR}
  ERROR_INTERNET_INTERNAL_ERROR               = INTERNET_ERROR_BASE + 4;
  {$EXTERNALSYM ERROR_INTERNET_INTERNAL_ERROR}
  ERROR_INTERNET_INVALID_URL                  = INTERNET_ERROR_BASE + 5;
  {$EXTERNALSYM ERROR_INTERNET_INVALID_URL}
  ERROR_INTERNET_UNRECOGNIZED_SCHEME          = INTERNET_ERROR_BASE + 6;
  {$EXTERNALSYM ERROR_INTERNET_UNRECOGNIZED_SCHEME}
  ERROR_INTERNET_NAME_NOT_RESOLVED            = INTERNET_ERROR_BASE + 7;
  {$EXTERNALSYM ERROR_INTERNET_NAME_NOT_RESOLVED}
  ERROR_INTERNET_PROTOCOL_NOT_FOUND           = INTERNET_ERROR_BASE + 8;
  {$EXTERNALSYM ERROR_INTERNET_PROTOCOL_NOT_FOUND}
  ERROR_INTERNET_INVALID_OPTION               = INTERNET_ERROR_BASE + 9;
  {$EXTERNALSYM ERROR_INTERNET_INVALID_OPTION}
  ERROR_INTERNET_BAD_OPTION_LENGTH            = INTERNET_ERROR_BASE + 10;
  {$EXTERNALSYM ERROR_INTERNET_BAD_OPTION_LENGTH}
  ERROR_INTERNET_OPTION_NOT_SETTABLE          = INTERNET_ERROR_BASE + 11;
  {$EXTERNALSYM ERROR_INTERNET_OPTION_NOT_SETTABLE}
  ERROR_INTERNET_SHUTDOWN                     = INTERNET_ERROR_BASE + 12;
  {$EXTERNALSYM ERROR_INTERNET_SHUTDOWN}
  ERROR_INTERNET_INCORRECT_USER_NAME          = INTERNET_ERROR_BASE + 13;
  {$EXTERNALSYM ERROR_INTERNET_INCORRECT_USER_NAME}
  ERROR_INTERNET_INCORRECT_PASSWORD           = INTERNET_ERROR_BASE + 14;
  {$EXTERNALSYM ERROR_INTERNET_INCORRECT_PASSWORD}
  ERROR_INTERNET_LOGIN_FAILURE                = INTERNET_ERROR_BASE + 15;
  {$EXTERNALSYM ERROR_INTERNET_LOGIN_FAILURE}
  ERROR_INTERNET_INVALID_OPERATION            = INTERNET_ERROR_BASE + 16;
  {$EXTERNALSYM ERROR_INTERNET_INVALID_OPERATION}
  ERROR_INTERNET_OPERATION_CANCELLED          = INTERNET_ERROR_BASE + 17;
  {$EXTERNALSYM ERROR_INTERNET_OPERATION_CANCELLED}
  ERROR_INTERNET_INCORRECT_HANDLE_TYPE        = INTERNET_ERROR_BASE + 18;
  {$EXTERNALSYM ERROR_INTERNET_INCORRECT_HANDLE_TYPE}
  ERROR_INTERNET_INCORRECT_HANDLE_STATE       = INTERNET_ERROR_BASE + 19;
  {$EXTERNALSYM ERROR_INTERNET_INCORRECT_HANDLE_STATE}
  ERROR_INTERNET_NOT_PROXY_REQUEST            = INTERNET_ERROR_BASE + 20;
  {$EXTERNALSYM ERROR_INTERNET_NOT_PROXY_REQUEST}
  ERROR_INTERNET_REGISTRY_VALUE_NOT_FOUND     = INTERNET_ERROR_BASE + 21;
  {$EXTERNALSYM ERROR_INTERNET_REGISTRY_VALUE_NOT_FOUND}
  ERROR_INTERNET_BAD_REGISTRY_PARAMETER       = INTERNET_ERROR_BASE + 22;
  {$EXTERNALSYM ERROR_INTERNET_BAD_REGISTRY_PARAMETER}
  ERROR_INTERNET_NO_DIRECT_ACCESS             = INTERNET_ERROR_BASE + 23;
  {$EXTERNALSYM ERROR_INTERNET_NO_DIRECT_ACCESS}
  ERROR_INTERNET_NO_CONTEXT                   = INTERNET_ERROR_BASE + 24;
  {$EXTERNALSYM ERROR_INTERNET_NO_CONTEXT}
  ERROR_INTERNET_NO_CALLBACK                  = INTERNET_ERROR_BASE + 25;
  {$EXTERNALSYM ERROR_INTERNET_NO_CALLBACK}
  ERROR_INTERNET_REQUEST_PENDING              = INTERNET_ERROR_BASE + 26;
  {$EXTERNALSYM ERROR_INTERNET_REQUEST_PENDING}
  ERROR_INTERNET_INCORRECT_FORMAT             = INTERNET_ERROR_BASE + 27;
  {$EXTERNALSYM ERROR_INTERNET_INCORRECT_FORMAT}
  ERROR_INTERNET_ITEM_NOT_FOUND               = INTERNET_ERROR_BASE + 28;
  {$EXTERNALSYM ERROR_INTERNET_ITEM_NOT_FOUND}
  ERROR_INTERNET_CANNOT_CONNECT               = INTERNET_ERROR_BASE + 29;
  {$EXTERNALSYM ERROR_INTERNET_CANNOT_CONNECT}
  ERROR_INTERNET_CONNECTION_ABORTED           = INTERNET_ERROR_BASE + 30;
  {$EXTERNALSYM ERROR_INTERNET_CONNECTION_ABORTED}
  ERROR_INTERNET_CONNECTION_RESET             = INTERNET_ERROR_BASE + 31;
  {$EXTERNALSYM ERROR_INTERNET_CONNECTION_RESET}
  ERROR_INTERNET_FORCE_RETRY                  = INTERNET_ERROR_BASE + 32;
  {$EXTERNALSYM ERROR_INTERNET_FORCE_RETRY}
  ERROR_INTERNET_INVALID_PROXY_REQUEST        = INTERNET_ERROR_BASE + 33;
  {$EXTERNALSYM ERROR_INTERNET_INVALID_PROXY_REQUEST}
  ERROR_INTERNET_HANDLE_EXISTS                = INTERNET_ERROR_BASE + 36;
  {$EXTERNALSYM ERROR_INTERNET_HANDLE_EXISTS}
  ERROR_INTERNET_SEC_CERT_DATE_INVALID        = INTERNET_ERROR_BASE + 37;
  {$EXTERNALSYM ERROR_INTERNET_SEC_CERT_DATE_INVALID}
  ERROR_INTERNET_SEC_CERT_CN_INVALID          = INTERNET_ERROR_BASE + 38;
  {$EXTERNALSYM ERROR_INTERNET_SEC_CERT_CN_INVALID}
  ERROR_INTERNET_HTTP_TO_HTTPS_ON_REDIR       = INTERNET_ERROR_BASE + 39;
  {$EXTERNALSYM ERROR_INTERNET_HTTP_TO_HTTPS_ON_REDIR}
  ERROR_INTERNET_HTTPS_TO_HTTP_ON_REDIR       = INTERNET_ERROR_BASE + 40;
  {$EXTERNALSYM ERROR_INTERNET_HTTPS_TO_HTTP_ON_REDIR}
  ERROR_INTERNET_MIXED_SECURITY               = INTERNET_ERROR_BASE + 41;
  {$EXTERNALSYM ERROR_INTERNET_MIXED_SECURITY}
  ERROR_INTERNET_CHG_POST_IS_NON_SECURE       = INTERNET_ERROR_BASE + 42;
  {$EXTERNALSYM ERROR_INTERNET_CHG_POST_IS_NON_SECURE}
  ERROR_INTERNET_POST_IS_NON_SECURE           = INTERNET_ERROR_BASE + 43;
  {$EXTERNALSYM ERROR_INTERNET_POST_IS_NON_SECURE}
  ERROR_INTERNET_CLIENT_AUTH_CERT_NEEDED      = INTERNET_ERROR_BASE + 44;
  {$EXTERNALSYM ERROR_INTERNET_CLIENT_AUTH_CERT_NEEDED}
  ERROR_INTERNET_INVALID_CA                   = INTERNET_ERROR_BASE + 45;
  {$EXTERNALSYM ERROR_INTERNET_INVALID_CA}
  ERROR_INTERNET_CLIENT_AUTH_NOT_SETUP        = INTERNET_ERROR_BASE + 46;
  {$EXTERNALSYM ERROR_INTERNET_CLIENT_AUTH_NOT_SETUP}
  ERROR_INTERNET_ASYNC_THREAD_FAILED          = INTERNET_ERROR_BASE + 47;
  {$EXTERNALSYM ERROR_INTERNET_ASYNC_THREAD_FAILED}
  ERROR_INTERNET_REDIRECT_SCHEME_CHANGE       = INTERNET_ERROR_BASE + 48;
  {$EXTERNALSYM ERROR_INTERNET_REDIRECT_SCHEME_CHANGE}
  ERROR_INTERNET_DIALOG_PENDING               = INTERNET_ERROR_BASE + 49;
  {$EXTERNALSYM ERROR_INTERNET_DIALOG_PENDING}
  ERROR_INTERNET_RETRY_DIALOG                 = INTERNET_ERROR_BASE + 50;
  {$EXTERNALSYM ERROR_INTERNET_RETRY_DIALOG}
  ERROR_INTERNET_HTTPS_HTTP_SUBMIT_REDIR      = INTERNET_ERROR_BASE + 52;
  {$EXTERNALSYM ERROR_INTERNET_HTTPS_HTTP_SUBMIT_REDIR}
  ERROR_INTERNET_INSERT_CDROM                 = INTERNET_ERROR_BASE + 53;
  {$EXTERNALSYM ERROR_INTERNET_INSERT_CDROM}

{ FTP API errors }

  ERROR_FTP_TRANSFER_IN_PROGRESS              = INTERNET_ERROR_BASE + 110;
  {$EXTERNALSYM ERROR_FTP_TRANSFER_IN_PROGRESS}
  ERROR_FTP_DROPPED                           = INTERNET_ERROR_BASE + 111;
  {$EXTERNALSYM ERROR_FTP_DROPPED}
  ERROR_FTP_NO_PASSIVE_MODE                   = INTERNET_ERROR_BASE + 112;
  {$EXTERNALSYM ERROR_FTP_NO_PASSIVE_MODE}

{ gopher API errors }

  ERROR_GOPHER_PROTOCOL_ERROR                 = INTERNET_ERROR_BASE + 130;
  {$EXTERNALSYM ERROR_GOPHER_PROTOCOL_ERROR}
  ERROR_GOPHER_NOT_FILE                       = INTERNET_ERROR_BASE + 131;
  {$EXTERNALSYM ERROR_GOPHER_NOT_FILE}
  ERROR_GOPHER_DATA_ERROR                     = INTERNET_ERROR_BASE + 132;
  {$EXTERNALSYM ERROR_GOPHER_DATA_ERROR}
  ERROR_GOPHER_END_OF_DATA                    = INTERNET_ERROR_BASE + 133;
  {$EXTERNALSYM ERROR_GOPHER_END_OF_DATA}
  ERROR_GOPHER_INVALID_LOCATOR                = INTERNET_ERROR_BASE + 134;
  {$EXTERNALSYM ERROR_GOPHER_INVALID_LOCATOR}
  ERROR_GOPHER_INCORRECT_LOCATOR_TYPE         = INTERNET_ERROR_BASE + 135;
  {$EXTERNALSYM ERROR_GOPHER_INCORRECT_LOCATOR_TYPE}
  ERROR_GOPHER_NOT_GOPHER_PLUS                = INTERNET_ERROR_BASE + 136;
  {$EXTERNALSYM ERROR_GOPHER_NOT_GOPHER_PLUS}
  ERROR_GOPHER_ATTRIBUTE_NOT_FOUND            = INTERNET_ERROR_BASE + 137;
  {$EXTERNALSYM ERROR_GOPHER_ATTRIBUTE_NOT_FOUND}
  ERROR_GOPHER_UNKNOWN_LOCATOR                = INTERNET_ERROR_BASE + 138;
  {$EXTERNALSYM ERROR_GOPHER_UNKNOWN_LOCATOR}

{ HTTP API errors }

  ERROR_HTTP_HEADER_NOT_FOUND                 = INTERNET_ERROR_BASE + 150;
  {$EXTERNALSYM ERROR_HTTP_HEADER_NOT_FOUND}
  ERROR_HTTP_DOWNLEVEL_SERVER                 = INTERNET_ERROR_BASE + 151;
  {$EXTERNALSYM ERROR_HTTP_DOWNLEVEL_SERVER}
  ERROR_HTTP_INVALID_SERVER_RESPONSE          = INTERNET_ERROR_BASE + 152;
  {$EXTERNALSYM ERROR_HTTP_INVALID_SERVER_RESPONSE}
  ERROR_HTTP_INVALID_HEADER                   = INTERNET_ERROR_BASE + 153;
  {$EXTERNALSYM ERROR_HTTP_INVALID_HEADER}
  ERROR_HTTP_INVALID_QUERY_REQUEST            = INTERNET_ERROR_BASE + 154;
  {$EXTERNALSYM ERROR_HTTP_INVALID_QUERY_REQUEST}
  ERROR_HTTP_HEADER_ALREADY_EXISTS            = INTERNET_ERROR_BASE + 155;
  {$EXTERNALSYM ERROR_HTTP_HEADER_ALREADY_EXISTS}
  ERROR_HTTP_REDIRECT_FAILED                  = INTERNET_ERROR_BASE + 156;
  {$EXTERNALSYM ERROR_HTTP_REDIRECT_FAILED}
  ERROR_HTTP_NOT_REDIRECTED                   = INTERNET_ERROR_BASE + 160;
  {$EXTERNALSYM ERROR_HTTP_NOT_REDIRECTED}
  ERROR_HTTP_COOKIE_NEEDS_CONFIRMATION        = INTERNET_ERROR_BASE + 161;
  {$EXTERNALSYM ERROR_HTTP_COOKIE_NEEDS_CONFIRMATION}
  ERROR_HTTP_COOKIE_DECLINED                  = INTERNET_ERROR_BASE + 162;
  {$EXTERNALSYM ERROR_HTTP_COOKIE_DECLINED}
  ERROR_HTTP_REDIRECT_NEEDS_CONFIRMATION      = INTERNET_ERROR_BASE + 168;
  {$EXTERNALSYM ERROR_HTTP_REDIRECT_NEEDS_CONFIRMATION}

{ additional Internet API error codes }
  ERROR_INTERNET_SECURITY_CHANNEL_ERROR       = INTERNET_ERROR_BASE + 157;
  {$EXTERNALSYM ERROR_INTERNET_SECURITY_CHANNEL_ERROR}
  ERROR_INTERNET_UNABLE_TO_CACHE_FILE         = INTERNET_ERROR_BASE + 158;
  {$EXTERNALSYM ERROR_INTERNET_UNABLE_TO_CACHE_FILE}
  ERROR_INTERNET_TCPIP_NOT_INSTALLED          = INTERNET_ERROR_BASE + 159;
  {$EXTERNALSYM ERROR_INTERNET_TCPIP_NOT_INSTALLED}
  ERROR_INTERNET_DISCONNECTED                 = INTERNET_ERROR_BASE + 163;
  {$EXTERNALSYM ERROR_INTERNET_DISCONNECTED}
  ERROR_INTERNET_SERVER_UNREACHABLE           = INTERNET_ERROR_BASE + 164;
  {$EXTERNALSYM ERROR_INTERNET_SERVER_UNREACHABLE}
  ERROR_INTERNET_PROXY_SERVER_UNREACHABLE     = INTERNET_ERROR_BASE + 165;
  {$EXTERNALSYM ERROR_INTERNET_PROXY_SERVER_UNREACHABLE}
  ERROR_INTERNET_BAD_AUTO_PROXY_SCRIPT        = INTERNET_ERROR_BASE + 166;
  {$EXTERNALSYM ERROR_INTERNET_BAD_AUTO_PROXY_SCRIPT}
  ERROR_INTERNET_UNABLE_TO_DOWNLOAD_SCRIPT    = INTERNET_ERROR_BASE + 167;
  {$EXTERNALSYM ERROR_INTERNET_UNABLE_TO_DOWNLOAD_SCRIPT}
  ERROR_INTERNET_SEC_INVALID_CERT             = INTERNET_ERROR_BASE + 169;
  {$EXTERNALSYM ERROR_INTERNET_SEC_INVALID_CERT}
  ERROR_INTERNET_SEC_CERT_REVOKED             = INTERNET_ERROR_BASE + 170;
  {$EXTERNALSYM ERROR_INTERNET_SEC_CERT_REVOKED}

{ InternetAutodial specific errors }

  ERROR_INTERNET_FAILED_DUETOSECURITYCHECK    = INTERNET_ERROR_BASE + 171;
  {$EXTERNALSYM ERROR_INTERNET_FAILED_DUETOSECURITYCHECK}
  INTERNET_ERROR_LAST                         = ERROR_INTERNET_FAILED_DUETOSECURITYCHECK;
  {$EXTERNALSYM INTERNET_ERROR_LAST}

{ URLCACHE APIs }

{ datatype definitions. }

{ cache entry type flags. }

  NORMAL_CACHE_ENTRY          = $00000001;
  {$EXTERNALSYM NORMAL_CACHE_ENTRY}
  STABLE_CACHE_ENTRY          = $00000002;
  {$EXTERNALSYM STABLE_CACHE_ENTRY}
  STICKY_CACHE_ENTRY          = $00000004;
  {$EXTERNALSYM STICKY_CACHE_ENTRY}
  COOKIE_CACHE_ENTRY          = $00100000;
  {$EXTERNALSYM COOKIE_CACHE_ENTRY}
  URLHISTORY_CACHE_ENTRY      = $00200000;
  {$EXTERNALSYM URLHISTORY_CACHE_ENTRY}
  TRACK_OFFLINE_CACHE_ENTRY   = $00000010;
  {$EXTERNALSYM TRACK_OFFLINE_CACHE_ENTRY}
  TRACK_ONLINE_CACHE_ENTRY    = $00000020;
  {$EXTERNALSYM TRACK_ONLINE_CACHE_ENTRY}
  SPARSE_CACHE_ENTRY          = $00010000;
  {$EXTERNALSYM SPARSE_CACHE_ENTRY}
  OCX_CACHE_ENTRY             = $00020000;
  {$EXTERNALSYM OCX_CACHE_ENTRY}

  URLCACHE_FIND_DEFAULT_FILTER = NORMAL_CACHE_ENTRY or
                                 COOKIE_CACHE_ENTRY or
                                 URLHISTORY_CACHE_ENTRY or
                                 TRACK_OFFLINE_CACHE_ENTRY or
                                 TRACK_ONLINE_CACHE_ENTRY or
                                 STICKY_CACHE_ENTRY;
  {$EXTERNALSYM URLCACHE_FIND_DEFAULT_FILTER}

type
  PInternetCacheEntryInfoA = ^INTERNET_CACHE_ENTRY_INFOA;
  INTERNET_CACHE_ENTRY_INFOA = record
    dwStructSize: DWORD;         { version of cache system. ?? do we need this for all entries? }
    lpszSourceUrlName: PAnsiChar;    { embedded pointer to the URL name AnsiString. }
    lpszLocalFileName: PAnsiChar;   { embedded pointer to the local file name. }
    CacheEntryType: DWORD;       { cache type bit mask. }
    dwUseCount: DWORD;           { current users count of the cache entry. }
    dwHitRate: DWORD;            { num of times the cache entry was retrieved. }
    dwSizeLow: DWORD;            { low DWORD of the file size. }
    dwSizeHigh: DWORD;           { high DWORD of the file size. }
    LastModifiedTime: TFileTime; { last modified time of the file in GMT format. }
    ExpireTime: TFileTime;       { expire time of the file in GMT format }
    LastAccessTime: TFileTime;   { last accessed time in GMT format }
    LastSyncTime: TFileTime;     { last time the URL was synchronized }
                                 { with the source }
    lpHeaderInfo: PBYTE;         { embedded pointer to the header info. }
    dwHeaderInfoSize: DWORD;     { size of the above header. }
    lpszFileExtension: PAnsiChar;   { File extension used to retrive the urldata as a file. }
    dwReserved: DWORD;           { reserved for future use. }
  end;
  {$EXTERNALSYM INTERNET_CACHE_ENTRY_INFOA}
  PInternetCacheEntryInfoW = ^INTERNET_CACHE_ENTRY_INFOW;
  INTERNET_CACHE_ENTRY_INFOW = record
    dwStructSize: DWORD;         { version of cache system. ?? do we need this for all entries? }
    lpszSourceUrlName: PAnsiChar;    { embedded pointer to the URL name WideString. }
    lpszLocalFileName: PWideChar;   { embedded pointer to the local file name. }
    CacheEntryType: DWORD;       { cache type bit mask. }
    dwUseCount: DWORD;           { current users count of the cache entry. }
    dwHitRate: DWORD;            { num of times the cache entry was retrieved. }
    dwSizeLow: DWORD;            { low DWORD of the file size. }
    dwSizeHigh: DWORD;           { high DWORD of the file size. }
    LastModifiedTime: TFileTime; { last modified time of the file in GMT format. }
    ExpireTime: TFileTime;       { expire time of the file in GMT format }
    LastAccessTime: TFileTime;   { last accessed time in GMT format }
    LastSyncTime: TFileTime;     { last time the URL was synchronized }
                                 { with the source }
    lpHeaderInfo: PBYTE;         { embedded pointer to the header info. }
    dwHeaderInfoSize: DWORD;     { size of the above header. }
    lpszFileExtension: PWideChar;   { File extension used to retrive the urldata as a file. }
    dwReserved: DWORD;           { reserved for future use. }
  end;
  {$EXTERNALSYM INTERNET_CACHE_ENTRY_INFOW}
  PInternetCacheEntryInfo = PInternetCacheEntryInfoA;
  TInternetCacheEntryInfoA = INTERNET_CACHE_ENTRY_INFOA;
  LPINTERNET_CACHE_ENTRY_INFOA = PInternetCacheEntryInfoA;
  {$EXTERNALSYM LPINTERNET_CACHE_ENTRY_INFOA}
  TInternetCacheEntryInfoW = INTERNET_CACHE_ENTRY_INFOW;
  LPINTERNET_CACHE_ENTRY_INFOW = PInternetCacheEntryInfoW;
  {$EXTERNALSYM LPINTERNET_CACHE_ENTRY_INFOW}
  TInternetCacheEntryInfo = TInternetCacheEntryInfoA;

{ Cache APIs }

function CreateUrlCacheEntry(lpszUrlName: PAnsiChar;
  dwExpectedFileSize: DWORD; lpszFileExtension: PAnsiChar;
  lpszFileName: PChar; dwReserved: DWORD): BOOL; stdcall;
  {$EXTERNALSYM CreateUrlCacheEntry}
function CreateUrlCacheEntryA(lpszUrlName: PAnsiChar;
  dwExpectedFileSize: DWORD; lpszFileExtension: PAnsiChar;
  lpszFileName: PAnsiChar; dwReserved: DWORD): BOOL; stdcall;
  {$EXTERNALSYM CreateUrlCacheEntryA}
function CreateUrlCacheEntryW(lpszUrlName: PAnsiChar;
  dwExpectedFileSize: DWORD; lpszFileExtension: PAnsiChar;
  lpszFileName: PWideChar; dwReserved: DWORD): BOOL; stdcall;
  {$EXTERNALSYM CreateUrlCacheEntryW}

function CommitUrlCacheEntry(lpszUrlName, lpszLocalFileName: PAnsiChar;
  ExpireTime, LastModifiedTime: TFileTime;  CacheEntryType: DWORD;
  lpHeaderInfo: PBYTE; dwHeaderSize: DWORD; lpszFileExtension: PChar;
  dwReserved: DWORD): BOOL; stdcall;
  {$EXTERNALSYM CommitUrlCacheEntry}
function CommitUrlCacheEntryA(lpszUrlName, lpszLocalFileName: PAnsiChar;
  ExpireTime, LastModifiedTime: TFileTime;  CacheEntryType: DWORD;
  lpHeaderInfo: PBYTE; dwHeaderSize: DWORD; lpszFileExtension: PAnsiChar;
  dwReserved: DWORD): BOOL; stdcall;
  {$EXTERNALSYM CommitUrlCacheEntryA}
function CommitUrlCacheEntryW(lpszUrlName, lpszLocalFileName: PAnsiChar;
  ExpireTime, LastModifiedTime: TFileTime;  CacheEntryType: DWORD;
  lpHeaderInfo: PBYTE; dwHeaderSize: DWORD; lpszFileExtension: PWideChar;
  dwReserved: DWORD): BOOL; stdcall;
  {$EXTERNALSYM CommitUrlCacheEntryW}

function RetrieveUrlCacheEntryFile(lpszUrlName: PAnsiChar;
  var lpCacheEntryInfo: TInternetCacheEntryInfo;
  var lpdwCacheEntryInfoBufferSize: DWORD;
  dwReserved: DWORD): BOOL; stdcall;
  {$EXTERNALSYM RetrieveUrlCacheEntryFile}
function RetrieveUrlCacheEntryFileA(lpszUrlName: PAnsiChar;
  var lpCacheEntryInfo: TInternetCacheEntryInfo;
  var lpdwCacheEntryInfoBufferSize: DWORD;
  dwReserved: DWORD): BOOL; stdcall;
  {$EXTERNALSYM RetrieveUrlCacheEntryFileA}
function RetrieveUrlCacheEntryFileW(lpszUrlName: PAnsiChar;
  var lpCacheEntryInfo: TInternetCacheEntryInfo;
  var lpdwCacheEntryInfoBufferSize: DWORD;
  dwReserved: DWORD): BOOL; stdcall;
  {$EXTERNALSYM RetrieveUrlCacheEntryFileW}

function UnlockUrlCacheEntryFile(lpszUrlName: LPCSTR;
  dwReserved: DWORD): BOOL; stdcall;
  {$EXTERNALSYM UnlockUrlCacheEntryFile}

function RetrieveUrlCacheEntryStream(lpszUrlName: PAnsiChar;
  var lpCacheEntryInfo: TInternetCacheEntryInfo;
  var lpdwCacheEntryInfoBufferSize: DWORD; fRandomRead: BOOL;
  dwReserved: DWORD): THandle; stdcall;
  {$EXTERNALSYM RetrieveUrlCacheEntryStream}
function RetrieveUrlCacheEntryStreamA(lpszUrlName: PAnsiChar;
  var lpCacheEntryInfo: TInternetCacheEntryInfo;
  var lpdwCacheEntryInfoBufferSize: DWORD; fRandomRead: BOOL;
  dwReserved: DWORD): THandle; stdcall;
  {$EXTERNALSYM RetrieveUrlCacheEntryStreamA}
function RetrieveUrlCacheEntryStreamW(lpszUrlName: PAnsiChar;
  var lpCacheEntryInfo: TInternetCacheEntryInfo;
  var lpdwCacheEntryInfoBufferSize: DWORD; fRandomRead: BOOL;
  dwReserved: DWORD): THandle; stdcall;
  {$EXTERNALSYM RetrieveUrlCacheEntryStreamW}

function ReadUrlCacheEntryStream(hUrlCacheStream: THandle;
  dwLocation: DWORD; var lpBuffer: Pointer;
  var lpdwLen: DWORD; Reserved: DWORD): BOOL; stdcall;
  {$EXTERNALSYM ReadUrlCacheEntryStream}

function UnlockUrlCacheEntryStream(hUrlCacheStream: THandle;
  Reserved: DWORD): BOOL; stdcall;
  {$EXTERNALSYM UnlockUrlCacheEntryStream}

function GetUrlCacheEntryInfo(lpszUrlName: PAnsiChar;
  var lpCacheEntryInfo: TInternetCacheEntryInfo;
  var lpdwCacheEntryInfoBufferSize: DWORD): BOOL; stdcall;
  {$EXTERNALSYM GetUrlCacheEntryInfo}
function GetUrlCacheEntryInfoA(lpszUrlName: PAnsiChar;
  var lpCacheEntryInfo: TInternetCacheEntryInfo;
  var lpdwCacheEntryInfoBufferSize: DWORD): BOOL; stdcall;
  {$EXTERNALSYM GetUrlCacheEntryInfoA}
function GetUrlCacheEntryInfoW(lpszUrlName: PAnsiChar;
  var lpCacheEntryInfo: TInternetCacheEntryInfo;
  var lpdwCacheEntryInfoBufferSize: DWORD): BOOL; stdcall;
  {$EXTERNALSYM GetUrlCacheEntryInfoW}

function GetUrlCacheEntryInfoEx(
    lpszUrl: PAnsiChar;
    lpCacheEntryInfo: PInternetCacheEntryInfo;
    lpdwCacheEntryInfoBufSize: LPDWORD;
    lpszReserved: PAnsiChar; { must pass nil }
    lpdwReserved: LPDWORD; { must pass nil }
    lpReserved: Pointer; { must pass nil }
    dwFlags: DWORD { reserved }
    ): BOOL; stdcall;
  {$EXTERNALSYM GetUrlCacheEntryInfoEx}
function GetUrlCacheEntryInfoExA(
    lpszUrl: PAnsiChar;
    lpCacheEntryInfo: PInternetCacheEntryInfo;
    lpdwCacheEntryInfoBufSize: LPDWORD;
    lpszReserved: PAnsiChar; { must pass nil }
    lpdwReserved: LPDWORD; { must pass nil }
    lpReserved: Pointer; { must pass nil }
    dwFlags: DWORD { reserved }
    ): BOOL; stdcall;
  {$EXTERNALSYM GetUrlCacheEntryInfoExA}
function GetUrlCacheEntryInfoExW(
    lpszUrl: PAnsiChar;
    lpCacheEntryInfo: PInternetCacheEntryInfo;
    lpdwCacheEntryInfoBufSize: LPDWORD;
    lpszReserved: PAnsiChar; { must pass nil }
    lpdwReserved: LPDWORD; { must pass nil }
    lpReserved: Pointer; { must pass nil }
    dwFlags: DWORD { reserved }
    ): BOOL; stdcall;
  {$EXTERNALSYM GetUrlCacheEntryInfoExW}

const
  CACHE_ENTRY_ATTRIBUTE_FC        = $00000004;
  {$EXTERNALSYM CACHE_ENTRY_ATTRIBUTE_FC}
  CACHE_ENTRY_HITRATE_FC          = $00000010;
  {$EXTERNALSYM CACHE_ENTRY_HITRATE_FC}
  CACHE_ENTRY_MODTIME_FC          = $00000040;
  {$EXTERNALSYM CACHE_ENTRY_MODTIME_FC}
  CACHE_ENTRY_EXPTIME_FC          = $00000080;
  {$EXTERNALSYM CACHE_ENTRY_EXPTIME_FC}
  CACHE_ENTRY_ACCTIME_FC          = $00000100;
  {$EXTERNALSYM CACHE_ENTRY_ACCTIME_FC}
  CACHE_ENTRY_SYNCTIME_FC         = $00000200;
  {$EXTERNALSYM CACHE_ENTRY_SYNCTIME_FC}
  CACHE_ENTRY_HEADERINFO_FC       = $00000400;
  {$EXTERNALSYM CACHE_ENTRY_HEADERINFO_FC}
  CACHE_ENTRY_EXEMPT_DELTA_FC     = $00000800;
  {$EXTERNALSYM CACHE_ENTRY_EXEMPT_DELTA_FC}

function SetUrlCacheEntryInfo(lpszUrlName: PAnsiChar;
  var lpCacheEntryInfo: TInternetCacheEntryInfo;
  dwFieldControl: DWORD): BOOL; stdcall;
  {$EXTERNALSYM SetUrlCacheEntryInfo}
function SetUrlCacheEntryInfoA(lpszUrlName: PAnsiChar;
  var lpCacheEntryInfo: TInternetCacheEntryInfo;
  dwFieldControl: DWORD): BOOL; stdcall;
  {$EXTERNALSYM SetUrlCacheEntryInfoA}
function SetUrlCacheEntryInfoW(lpszUrlName: PAnsiChar;
  var lpCacheEntryInfo: TInternetCacheEntryInfo;
  dwFieldControl: DWORD): BOOL; stdcall;
  {$EXTERNALSYM SetUrlCacheEntryInfoW}

type
  GROUPID = Int64;
  {$EXTERNALSYM GROUPID}

function CreateUrlCacheGroup(dwFlags: DWORD;
  lpReserved: Pointer { must pass nill }
  ): Int64; stdcall;
  {$EXTERNALSYM CreateUrlCacheGroup}

function DeleteUrlCacheGroup(GroupId: Int64;
    dwFlags: DWORD;    { must pass 0 }
    lpReserved: Pointer { must pass nill }
    ): Bool; stdcall;
  {$EXTERNALSYM DeleteUrlCacheGroup}

{ Flags for SetUrlCacheEntryGroup }

const
  INTERNET_CACHE_GROUP_ADD      = 0;
  {$EXTERNALSYM INTERNET_CACHE_GROUP_ADD}
  INTERNET_CACHE_GROUP_REMOVE   = 1;
  {$EXTERNALSYM INTERNET_CACHE_GROUP_REMOVE}

function SetUrlCacheEntryGroup(lpszUrlName: LPCSTR; dwFlags: DWORD;
  GroupId: Int64;
  pbGroupAttributes: PChar; { must pass nil }
  cbGroupAttributes: DWORD;  { must pass 0 }
  lpReserved: Pointer        { must pass nil }
  ): Bool; stdcall;
  {$EXTERNALSYM SetUrlCacheEntryGroup}

function FindFirstUrlCacheEntryEx(lpszUrlSearchPattern: PAnsiChar;
    dwFlags: DWORD;
    dwFilter: DWORD;
    GroupId: GROUPID;
    lpFirstCacheEntryInfo: PInternetCacheEntryInfo;
    lpdwFirstCacheEntryInfoBufferSize: LPDWORD;
    lpGroupAttributes: Pointer;  { must pass nil }
    pcbGroupAttributes: LPDWORD;    { must pass nil }
    lpReserved: Pointer             { must pass nil }
    ): THandle; stdcall;
  {$EXTERNALSYM FindFirstUrlCacheEntryEx}
function FindFirstUrlCacheEntryExA(lpszUrlSearchPattern: PAnsiChar;
    dwFlags: DWORD;
    dwFilter: DWORD;
    GroupId: GROUPID;
    lpFirstCacheEntryInfo: PInternetCacheEntryInfo;
    lpdwFirstCacheEntryInfoBufferSize: LPDWORD;
    lpGroupAttributes: Pointer;  { must pass nil }
    pcbGroupAttributes: LPDWORD;    { must pass nil }
    lpReserved: Pointer             { must pass nil }
    ): THandle; stdcall;
  {$EXTERNALSYM FindFirstUrlCacheEntryExA}
function FindFirstUrlCacheEntryExW(lpszUrlSearchPattern: PAnsiChar;
    dwFlags: DWORD;
    dwFilter: DWORD;
    GroupId: GROUPID;
    lpFirstCacheEntryInfo: PInternetCacheEntryInfo;
    lpdwFirstCacheEntryInfoBufferSize: LPDWORD;
    lpGroupAttributes: Pointer;  { must pass nil }
    pcbGroupAttributes: LPDWORD;    { must pass nil }
    lpReserved: Pointer             { must pass nil }
    ): THandle; stdcall;
  {$EXTERNALSYM FindFirstUrlCacheEntryExW}

function FindNextUrlCacheEntryEx(hEnumHandle: THANDLE;
    lpFirstCacheEntryInfo: PInternetCacheEntryInfo;
    lpdwFirstCacheEntryInfoBufferSize: LPDWORD;
    lpGroupAttributes: Pointer;  { must pass nil }
    pcbGroupAttributes: LPDWORD;    { must pass nil }
    lpReserved: Pointer             { must pass nil }
    ): BOOL; stdcall;
  {$EXTERNALSYM FindNextUrlCacheEntryEx}
function FindNextUrlCacheEntryExA(hEnumHandle: THANDLE;
    lpFirstCacheEntryInfo: PInternetCacheEntryInfo;
    lpdwFirstCacheEntryInfoBufferSize: LPDWORD;
    lpGroupAttributes: Pointer;  { must pass nil }
    pcbGroupAttributes: LPDWORD;    { must pass nil }
    lpReserved: Pointer             { must pass nil }
    ): BOOL; stdcall;
  {$EXTERNALSYM FindNextUrlCacheEntryExA}
function FindNextUrlCacheEntryExW(hEnumHandle: THANDLE;
    lpFirstCacheEntryInfo: PInternetCacheEntryInfo;
    lpdwFirstCacheEntryInfoBufferSize: LPDWORD;
    lpGroupAttributes: Pointer;  { must pass nil }
    pcbGroupAttributes: LPDWORD;    { must pass nil }
    lpReserved: Pointer             { must pass nil }
    ): BOOL; stdcall;
  {$EXTERNALSYM FindNextUrlCacheEntryExW}

function FindFirstUrlCacheEntry(lpszUrlSearchPattern: PAnsiChar;
  var lpFirstCacheEntryInfo: TInternetCacheEntryInfo;
  var lpdwFirstCacheEntryInfoBufferSize: DWORD): THandle; stdcall;
  {$EXTERNALSYM FindFirstUrlCacheEntry}
function FindFirstUrlCacheEntryA(lpszUrlSearchPattern: PAnsiChar;
  var lpFirstCacheEntryInfo: TInternetCacheEntryInfo;
  var lpdwFirstCacheEntryInfoBufferSize: DWORD): THandle; stdcall;
  {$EXTERNALSYM FindFirstUrlCacheEntryA}
function FindFirstUrlCacheEntryW(lpszUrlSearchPattern: PAnsiChar;
  var lpFirstCacheEntryInfo: TInternetCacheEntryInfo;
  var lpdwFirstCacheEntryInfoBufferSize: DWORD): THandle; stdcall;
  {$EXTERNALSYM FindFirstUrlCacheEntryW}

function FindNextUrlCacheEntry(hEnumHandle: THandle;
  var lpNextCacheEntryInfo: TInternetCacheEntryInfo;
  var lpdwNextCacheEntryInfoBufferSize: DWORD): BOOL; stdcall;
  {$EXTERNALSYM FindNextUrlCacheEntry}
function FindNextUrlCacheEntryA(hEnumHandle: THandle;
  var lpNextCacheEntryInfo: TInternetCacheEntryInfo;
  var lpdwNextCacheEntryInfoBufferSize: DWORD): BOOL; stdcall;
  {$EXTERNALSYM FindNextUrlCacheEntryA}
function FindNextUrlCacheEntryW(hEnumHandle: THandle;
  var lpNextCacheEntryInfo: TInternetCacheEntryInfo;
  var lpdwNextCacheEntryInfoBufferSize: DWORD): BOOL; stdcall;
  {$EXTERNALSYM FindNextUrlCacheEntryW}

function FindCloseUrlCache(hEnumHandle: THandle): BOOL; stdcall;
  {$EXTERNALSYM FindCloseUrlCache}

function DeleteUrlCacheEntry(lpszUrlName: LPCSTR): BOOL; stdcall;
  {$EXTERNALSYM DeleteUrlCacheEntry}

function InternetDial(hwndParent: HWND; lpszConnectoid: LPTSTR; dwFlags: DWORD;
  lpdwConnection: LPDWORD; dwReserved: DWORD): DWORD; stdcall;
  {$EXTERNALSYM InternetDial}

{ Flags for InternetDial - must not conflict with InternetAutodial flags }
{                          as they are valid here also.                  }
const
  INTERNET_DIAL_UNATTENDED       = $8000;
  {$EXTERNALSYM INTERNET_DIAL_UNATTENDED}

function InternetHangUp(dwConnection: DWORD; dwReserved: DWORD): DWORD; stdcall;
  {$EXTERNALSYM InternetHangUp}

const
  INTERENT_GOONLINE_REFRESH = $00000001;
  {$EXTERNALSYM INTERENT_GOONLINE_REFRESH}
  INTERENT_GOONLINE_MASK    = $00000001;
  {$EXTERNALSYM INTERENT_GOONLINE_MASK}

function InternetGoOnline(lpszURL: LPTSTR; hwndParent: HWND;
  dwFlags: DWORD): BOOL; stdcall;
  {$EXTERNALSYM InternetGoOnline}

function InternetAutodial(dwFlags: DWORD; dwReserved: DWORD): BOOL; stdcall;
  {$EXTERNALSYM InternetAutodial}

{ Flags for InternetAutodial }
const
  INTERNET_AUTODIAL_FORCE_ONLINE          = 1;
  {$EXTERNALSYM INTERNET_AUTODIAL_FORCE_ONLINE}
  INTERNET_AUTODIAL_FORCE_UNATTENDED      = 2;
  {$EXTERNALSYM INTERNET_AUTODIAL_FORCE_UNATTENDED}
  INTERNET_AUTODIAL_FAILIFSECURITYCHECK   = 4;
  {$EXTERNALSYM INTERNET_AUTODIAL_FAILIFSECURITYCHECK}
  INTERNET_AUTODIAL_FLAGS_MASK  = INTERNET_AUTODIAL_FORCE_ONLINE or
                                  INTERNET_AUTODIAL_FORCE_UNATTENDED or
                                  INTERNET_AUTODIAL_FAILIFSECURITYCHECK;
  {$EXTERNALSYM INTERNET_AUTODIAL_FLAGS_MASK}

function InternetAutodialHangup(dwReserved: DWORD): BOOL; stdcall;
  {$EXTERNALSYM InternetAutodialHangup}

function InternetGetConnectedState(lpdwFlags: LPDWORD;
  dwReserved: DWORD): BOOL; stdcall;
  {$EXTERNALSYM InternetGetConnectedState}

{ Flags for InternetGetConnectedState }
const
  INTERNET_CONNECTION_MODEM           = 1;
  {$EXTERNALSYM INTERNET_CONNECTION_MODEM}
  INTERNET_CONNECTION_LAN             = 2;
  {$EXTERNALSYM INTERNET_CONNECTION_LAN}
  INTERNET_CONNECTION_PROXY           = 4;
  {$EXTERNALSYM INTERNET_CONNECTION_PROXY}
  INTERNET_CONNECTION_MODEM_BUSY      = 8;
  {$EXTERNALSYM INTERNET_CONNECTION_MODEM_BUSY}
  INTERNET_RAS_INSTALLED              = 16;
  {$EXTERNALSYM INTERNET_RAS_INSTALLED}
  INTERNET_CONNECTION_OFFLINE         = 32;
  {$EXTERNALSYM INTERNET_CONNECTION_OFFLINE}
  INTERNET_CONNECTION_CONFIGURED      = 64;
  {$EXTERNALSYM INTERNET_CONNECTION_CONFIGURED}

{ Custom dial handler functions }

{ Custom dial handler prototype }
type
  PFN_DIAL_HANDLER = function(A:HWND; B:LPCSTR; C:DWORD; D:LPDWORD): DWORD; stdcall;
  {$EXTERNALSYM PFN_DIAL_HANDLER}

{ Flags for custom dial handler }
const
  INTERNET_CUSTOMDIAL_CONNECT         = 0;
  {$EXTERNALSYM INTERNET_CUSTOMDIAL_CONNECT}
  INTERNET_CUSTOMDIAL_UNATTENDED      = 1;
  {$EXTERNALSYM INTERNET_CUSTOMDIAL_UNATTENDED}
  INTERNET_CUSTOMDIAL_DISCONNECT      = 2;
  {$EXTERNALSYM INTERNET_CUSTOMDIAL_DISCONNECT}
  INTERNET_CUSTOMDIAL_SHOWOFFLINE     = 4;
  {$EXTERNALSYM INTERNET_CUSTOMDIAL_SHOWOFFLINE}

{ Custom dial handler supported functionality flags }
  INTERNET_CUSTOMDIAL_SAFE_FOR_UNATTENDED = 1;
  {$EXTERNALSYM INTERNET_CUSTOMDIAL_SAFE_FOR_UNATTENDED}
  INTERNET_CUSTOMDIAL_WILL_SUPPLY_STATE   = 2;
  {$EXTERNALSYM INTERNET_CUSTOMDIAL_WILL_SUPPLY_STATE}
  INTERNET_CUSTOMDIAL_CAN_HANGUP          = 4;
  {$EXTERNALSYM INTERNET_CUSTOMDIAL_CAN_HANGUP}

function InternetSetDialState(lpszConnectoid: LPCTSTR; dwState: DWORD;
  dwReserved: DWORD): BOOL; stdcall;
  {$EXTERNALSYM InternetSetDialState}

implementation

const
{$IFDEF MSWINDOWS}
   winetdll = 'wininet.dll';
{$ENDIF}
{$IFDEF LINUX}
  winetdll = 'libwininet.borland.so';
{$ENDIF}


function CommitUrlCacheEntry;          external winetdll name 'CommitUrlCacheEntryA';
function CommitUrlCacheEntryA;          external winetdll name 'CommitUrlCacheEntryA';
function CommitUrlCacheEntryW;          external winetdll name 'CommitUrlCacheEntryW';
function CreateUrlCacheEntry;          external winetdll name 'CreateUrlCacheEntryA';
function CreateUrlCacheEntryA;          external winetdll name 'CreateUrlCacheEntryA';
function CreateUrlCacheEntryW;          external winetdll name 'CreateUrlCacheEntryW';
function DeleteUrlCacheEntry;             external winetdll name 'DeleteUrlCacheEntry';
function FindCloseUrlCache;               external winetdll name 'FindCloseUrlCache';
function FindFirstUrlCacheEntry;       external winetdll name 'FindFirstUrlCacheEntryA';
function FindFirstUrlCacheEntryA;       external winetdll name 'FindFirstUrlCacheEntryA';
function FindFirstUrlCacheEntryW;       external winetdll name 'FindFirstUrlCacheEntryW';
function FindNextUrlCacheEntry;        external winetdll name 'FindNextUrlCacheEntryA';
function FindNextUrlCacheEntryA;        external winetdll name 'FindNextUrlCacheEntryA';
function FindNextUrlCacheEntryW;        external winetdll name 'FindNextUrlCacheEntryW';
function FtpCommand;                   external winetdll name 'FtpCommandA';
function FtpCommandA;                   external winetdll name 'FtpCommandA';
function FtpCommandW;                   external winetdll name 'FtpCommandW';
function FtpCreateDirectory;           external winetdll name 'FtpCreateDirectoryA';
function FtpCreateDirectoryA;           external winetdll name 'FtpCreateDirectoryA';
function FtpCreateDirectoryW;           external winetdll name 'FtpCreateDirectoryW';
function FtpDeleteFile;                external winetdll name 'FtpDeleteFileA';
function FtpDeleteFileA;                external winetdll name 'FtpDeleteFileA';
function FtpDeleteFileW;                external winetdll name 'FtpDeleteFileW';
function FtpFindFirstFile;             external winetdll name 'FtpFindFirstFileA';
function FtpFindFirstFileA;             external winetdll name 'FtpFindFirstFileA';
function FtpFindFirstFileW;             external winetdll name 'FtpFindFirstFileW';
function FtpGetCurrentDirectory;       external winetdll name 'FtpGetCurrentDirectoryA';
function FtpGetCurrentDirectoryA;       external winetdll name 'FtpGetCurrentDirectoryA';
function FtpGetCurrentDirectoryW;       external winetdll name 'FtpGetCurrentDirectoryW';
function FtpGetFile;                   external winetdll name 'FtpGetFileA';
function FtpGetFileA;                   external winetdll name 'FtpGetFileA';
function FtpGetFileW;                   external winetdll name 'FtpGetFileW';
function FtpOpenFile;                  external winetdll name 'FtpOpenFileA';
function FtpOpenFileA;                  external winetdll name 'FtpOpenFileA';
function FtpOpenFileW;                  external winetdll name 'FtpOpenFileW';
function FtpPutFile;                   external winetdll name 'FtpPutFileA';
function FtpPutFileA;                   external winetdll name 'FtpPutFileA';
function FtpPutFileW;                   external winetdll name 'FtpPutFileW';
function FtpRemoveDirectory;           external winetdll name 'FtpRemoveDirectoryA';
function FtpRemoveDirectoryA;           external winetdll name 'FtpRemoveDirectoryA';
function FtpRemoveDirectoryW;           external winetdll name 'FtpRemoveDirectoryW';
function FtpRenameFile;                external winetdll name 'FtpRenameFileA';
function FtpRenameFileA;                external winetdll name 'FtpRenameFileA';
function FtpRenameFileW;                external winetdll name 'FtpRenameFileW';
function FtpSetCurrentDirectory;       external winetdll name 'FtpSetCurrentDirectoryA';
function FtpSetCurrentDirectoryA;       external winetdll name 'FtpSetCurrentDirectoryA';
function FtpSetCurrentDirectoryW;       external winetdll name 'FtpSetCurrentDirectoryW';
function FtpGetFileSize;                  external winetdll name 'FtpGetFileSize';
function GetUrlCacheEntryInfo;         external winetdll name 'GetUrlCacheEntryInfoA';
function GetUrlCacheEntryInfoA;         external winetdll name 'GetUrlCacheEntryInfoA';
function GetUrlCacheEntryInfoW;         external winetdll name 'GetUrlCacheEntryInfoW';
function GopherCreateLocator;          external winetdll name 'GopherCreateLocatorA';
function GopherCreateLocatorA;          external winetdll name 'GopherCreateLocatorA';
function GopherCreateLocatorW;          external winetdll name 'GopherCreateLocatorW';
function GopherFindFirstFile;          external winetdll name 'GopherFindFirstFileA';
function GopherFindFirstFileA;          external winetdll name 'GopherFindFirstFileA';
function GopherFindFirstFileW;          external winetdll name 'GopherFindFirstFileW';
function GopherGetAttribute;           external winetdll name 'GopherGetAttributeA';
function GopherGetAttributeA;           external winetdll name 'GopherGetAttributeA';
function GopherGetAttributeW;           external winetdll name 'GopherGetAttributeW';
function GopherGetLocatorType;         external winetdll name 'GopherGetLocatorTypeA';
function GopherGetLocatorTypeA;         external winetdll name 'GopherGetLocatorTypeA';
function GopherGetLocatorTypeW;         external winetdll name 'GopherGetLocatorTypeW';
function GopherOpenFile;               external winetdll name 'GopherOpenFileA';
function GopherOpenFileA;               external winetdll name 'GopherOpenFileA';
function GopherOpenFileW;               external winetdll name 'GopherOpenFileW';
function HttpAddRequestHeaders;        external winetdll name 'HttpAddRequestHeadersA';
function HttpAddRequestHeadersA;        external winetdll name 'HttpAddRequestHeadersA';
function HttpAddRequestHeadersW;        external winetdll name 'HttpAddRequestHeadersW';
function HttpOpenRequest;              external winetdll name 'HttpOpenRequestA';
function HttpOpenRequestA;              external winetdll name 'HttpOpenRequestA';
function HttpOpenRequestW;              external winetdll name 'HttpOpenRequestW';
function HttpQueryInfo;                external winetdll name 'HttpQueryInfoA';
function HttpQueryInfoA;                external winetdll name 'HttpQueryInfoA';
function HttpQueryInfoW;                external winetdll name 'HttpQueryInfoW';
function HttpSendRequest;              external winetdll name 'HttpSendRequestA';
function HttpSendRequestA;              external winetdll name 'HttpSendRequestA';
function HttpSendRequestW;              external winetdll name 'HttpSendRequestW';
function InternetCanonicalizeUrl;      external winetdll name 'InternetCanonicalizeUrlA';
function InternetCanonicalizeUrlA;      external winetdll name 'InternetCanonicalizeUrlA';
function InternetCanonicalizeUrlW;      external winetdll name 'InternetCanonicalizeUrlW';
function InternetCloseHandle;             external winetdll name 'InternetCloseHandle';
function InternetCombineUrl;           external winetdll name 'InternetCombineUrlA';
function InternetCombineUrlA;           external winetdll name 'InternetCombineUrlA';
function InternetCombineUrlW;           external winetdll name 'InternetCombineUrlW';
function InternetConfirmZoneCrossing;     external winetdll name 'InternetConfirmZoneCrossing';
function InternetConnect;              external winetdll name 'InternetConnectA';
function InternetConnectA;              external winetdll name 'InternetConnectA';
function InternetConnectW;              external winetdll name 'InternetConnectW';
function InternetCrackUrl;             external winetdll name 'InternetCrackUrlA';
function InternetCrackUrlA;             external winetdll name 'InternetCrackUrlA';
function InternetCrackUrlW;             external winetdll name 'InternetCrackUrlW';
function InternetCreateUrl;            external winetdll name 'InternetCreateUrlA';
function InternetCreateUrlA;            external winetdll name 'InternetCreateUrlA';
function InternetCreateUrlW;            external winetdll name 'InternetCreateUrlW';
function InternetErrorDlg;                external winetdll name 'InternetErrorDlg';
function InternetFindNextFile;         external winetdll name 'InternetFindNextFileA';
function InternetFindNextFileA;         external winetdll name 'InternetFindNextFileA';
function InternetFindNextFileW;         external winetdll name 'InternetFindNextFileW';
function InternetGetCookie;            external winetdll name 'InternetGetCookieA';
function InternetGetCookieA;            external winetdll name 'InternetGetCookieA';
function InternetGetCookieW;            external winetdll name 'InternetGetCookieW';
function InternetGetLastResponseInfo;  external winetdll name 'InternetGetLastResponseInfoA';
function InternetGetLastResponseInfoA;  external winetdll name 'InternetGetLastResponseInfoA';
function InternetGetLastResponseInfoW;  external winetdll name 'InternetGetLastResponseInfoW';
function InternetOpen;                 external winetdll name 'InternetOpenA';
function InternetOpenA;                 external winetdll name 'InternetOpenA';
function InternetOpenW;                 external winetdll name 'InternetOpenW';
function InternetOpenUrl;              external winetdll name 'InternetOpenUrlA';
function InternetOpenUrlA;              external winetdll name 'InternetOpenUrlA';
function InternetOpenUrlW;              external winetdll name 'InternetOpenUrlW';
function InternetQueryDataAvailable;      external winetdll name 'InternetQueryDataAvailable';
function InternetQueryOption;          external winetdll name 'InternetQueryOptionA';
function InternetQueryOptionA;          external winetdll name 'InternetQueryOptionA';
function InternetQueryOptionW;          external winetdll name 'InternetQueryOptionW';
function InternetReadFile;                external winetdll name 'InternetReadFile';
function InternetSetCookie;            external winetdll name 'InternetSetCookieA';
function InternetSetCookieA;            external winetdll name 'InternetSetCookieA';
function InternetSetCookieW;            external winetdll name 'InternetSetCookieW';
function InternetSetFilePointer;          external winetdll name 'InternetSetFilePointer';
function InternetSetOption;            external winetdll name 'InternetSetOptionA';
function InternetSetOptionA;            external winetdll name 'InternetSetOptionA';
function InternetSetOptionW;            external winetdll name 'InternetSetOptionW';
function InternetSetOptionEx;          external winetdll name 'InternetSetOptionExA';
function InternetSetOptionExA;          external winetdll name 'InternetSetOptionExA';
function InternetSetOptionExW;          external winetdll name 'InternetSetOptionExW';
function InternetSetStatusCallback;       external winetdll name 'InternetSetStatusCallback';
function InternetTimeFromSystemTime;      external winetdll name 'InternetTimeFromSystemTime';
function InternetWriteFile;               external winetdll name 'InternetWriteFile';
function ReadUrlCacheEntryStream;         external winetdll name 'ReadUrlCacheEntryStream';
function RetrieveUrlCacheEntryFile;    external winetdll name 'RetrieveUrlCacheEntryFileA';
function RetrieveUrlCacheEntryFileA;    external winetdll name 'RetrieveUrlCacheEntryFileA';
function RetrieveUrlCacheEntryFileW;    external winetdll name 'RetrieveUrlCacheEntryFileW';
function RetrieveUrlCacheEntryStream;  external winetdll name 'RetrieveUrlCacheEntryStreamA';
function RetrieveUrlCacheEntryStreamA;  external winetdll name 'RetrieveUrlCacheEntryStreamA';
function RetrieveUrlCacheEntryStreamW;  external winetdll name 'RetrieveUrlCacheEntryStreamW';
function SetUrlCacheEntryInfo;         external winetdll name 'SetUrlCacheEntryInfoA';
function SetUrlCacheEntryInfoA;         external winetdll name 'SetUrlCacheEntryInfoA';
function SetUrlCacheEntryInfoW;         external winetdll name 'SetUrlCacheEntryInfoW';
function UnlockUrlCacheEntryFile;         external winetdll name 'UnlockUrlCacheEntryFile';
function UnlockUrlCacheEntryStream;       external winetdll name 'UnlockUrlCacheEntryStream';

function CreateUrlCacheGroup;             external winetdll name 'CreateUrlCacheGroup';
function DeleteUrlCacheGroup;             external winetdll name 'DeleteUrlCacheGroup';
function FindFirstUrlCacheEntryEx;     external winetdll name 'FindFirstUrlCacheEntryExA';
function FindFirstUrlCacheEntryExA;     external winetdll name 'FindFirstUrlCacheEntryExA';
function FindFirstUrlCacheEntryExW;     external winetdll name 'FindFirstUrlCacheEntryExW';
function FindNextUrlCacheEntryEx;      external winetdll name 'FindNextUrlCacheEntryExA';
function FindNextUrlCacheEntryExA;      external winetdll name 'FindNextUrlCacheEntryExA';
function FindNextUrlCacheEntryExW;      external winetdll name 'FindNextUrlCacheEntryExW';
function GetUrlCacheEntryInfoEx;       external winetdll name 'GetUrlCacheEntryInfoExA';
function GetUrlCacheEntryInfoExA;       external winetdll name 'GetUrlCacheEntryInfoExA';
function GetUrlCacheEntryInfoExW;       external winetdll name 'GetUrlCacheEntryInfoExW';
function HttpEndRequest;               external winetdll name 'HttpEndRequestA';
function HttpEndRequestA;               external winetdll name 'HttpEndRequestA';
function HttpEndRequestW;               external winetdll name 'HttpEndRequestW';
function InternetAttemptConnect;          external winetdll name 'InternetAttemptConnect';
function InternetAuthNotifyCallback;      external winetdll name 'InternetAuthNotifyCallback';
function InternetAutodial;                external winetdll name 'InternetAutodial';
function InternetAutodialHangup;          external winetdll name 'InternetAutodialHangup';
function InternetCheckConnection;      external winetdll name 'InternetCheckConnectionA';
function InternetCheckConnectionA;      external winetdll name 'InternetCheckConnectionA';
function InternetCheckConnectionW;      external winetdll name 'InternetCheckConnectionW';
function InternetDial;                    external winetdll name 'InternetDial';
function InternetGetConnectedState;       external winetdll name 'InternetGetConnectedState';
function InternetGoOnline;                external winetdll name 'InternetGoOnline';
function InternetHangUp;                  external winetdll name 'InternetHangUp';
function InternetLockRequestFile;         external winetdll name 'InternetLockRequestFile';
function InternetReadFileEx;           external winetdll name 'InternetReadFileExA';
function InternetReadFileExA;           external winetdll name 'InternetReadFileExA';
function InternetReadFileExW;           external winetdll name 'InternetReadFileExW';
function InternetSetDialState;            external winetdll name 'InternetSetDialState';
function InternetUnlockRequestFile;       external winetdll name 'InternetUnlockRequestFile';
function SetUrlCacheEntryGroup;           external winetdll name 'SetUrlCacheEntryGroup';
function HttpSendRequestEx;            external winetdll name 'HttpSendRequestExA';
function HttpSendRequestExA;            external winetdll name 'HttpSendRequestExA';
function HttpSendRequestExW;            external winetdll name 'HttpSendRequestExW';



function IS_GOPHER_FILE(GopherType: DWORD): BOOL;
begin
  Result := GopherType and GOPHER_TYPE_FILE_MASK = 0;
end;

function IS_GOPHER_DIRECTORY(GopherType: DWORD): BOOL;
begin
  Result := GopherType and GOPHER_TYPE_DIRECTORY = 0;
end;

function IS_GOPHER_PHONE_SERVER(GopherType: DWORD): BOOL;
begin
  Result := GopherType and GOPHER_TYPE_CSO = 0;
end;

function IS_GOPHER_ERROR(GopherType: DWORD): BOOL;
begin
  Result := GopherType and GOPHER_TYPE_ERROR = 0;
end;

function IS_GOPHER_INDEX_SERVER(GopherType: DWORD): BOOL;
begin
  Result := GopherType and GOPHER_TYPE_INDEX_SERVER = 0;
end;

function IS_GOPHER_TELNET_SESSION(GopherType: DWORD): BOOL;
begin
  Result := GopherType and GOPHER_TYPE_TELNET = 0;
end;

function IS_GOPHER_BACKUP_SERVER(GopherType: DWORD): BOOL;
begin
  Result := GopherType and GOPHER_TYPE_REDUNDANT = 0;
end;

function IS_GOPHER_TN3270_SESSION(GopherType: DWORD): BOOL;
begin
  Result := GopherType and GOPHER_TYPE_TN3270 = 0;
end;

function IS_GOPHER_ASK(GopherType: DWORD): BOOL;
begin
  Result := GopherType and GOPHER_TYPE_ASK = 0;
end;

function IS_GOPHER_PLUS(GopherType: DWORD): BOOL;
begin
  Result := GopherType and GOPHER_TYPE_GOPHER_PLUS = 0;
end;

function IS_GOPHER_TYPE_KNOWN(GopherType: DWORD): BOOL;
begin
  Result := GopherType and GOPHER_TYPE_UNKNOWN = 0;
end;

end.
