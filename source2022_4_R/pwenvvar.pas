{ Helper unit for gaining access to the Cgi Environment variables easily

     Why not just make a general function to get any environment variable on
     the fly, such as GetCgiEnv('HTTP_REFERER') ?

     It is more elegant to use:

       outln( SERV.Referer() );

     Compared to :

       outln(GetCgiEnv('HTTP_REFERER'));
   
    You may also get single Cgi environment var's at a time by calling:
      GetCgiUserAgent
      GetCgiReferrer

  Feel free to write a class or old borland stack based object with properties, 
  for more syntactic sugar if you want. 

  Author: Lars (L505)
          Website: http://z505.com

  License: NRCOL
--------------------------------------------------------------------------------}

unit pwenvvar; {$IFDEF FPC} {$mode objfpc}{$H+} {$ENDIF}

interface

type
  // Store cgi environment variables, getting them only once.
  // Store them individually or all at once
  { 35 TOTAL }
  TCgiEnvVars = record
    Accept,
    AcceptEncod,
    AcceptLang,
    AuthType,
    ContentLength,
    ContentType,
    Cookie,
    DocName,
    DocRoot,
    DocUri,
    Forwarded,
    GateIntf,
    Host,
    IfModSince,
    PathInfo,
    PathTranslated,
    Pragma,
    QueryString,        // The URL variables
    Referer,            // The referer URL
    RemoteAddr,         // The IP address of the visitor
    RemoteHost,
    RemoteIdent,
    RemotePort,
    RemoteUser,
    RequestMethod,      // Method of request, usually returns GET
    RequestUri,
    ScriptFileName,
    ScriptName,         // current script name and path of the webpage (like SELF or paramstr(0))
    ScriptUri,          // script name with http://domain.com prefixed
    ServerAdmin,
    ServerName,
    ServerPort,         // Port of server, usually returns port 80
    ServerProtocol,     // Protocol used, usually returns HTTP
    ServerSig,
    ServerSoft,
    UserAgent: string;
  end;

  // Get single cgi environment variable on demand
  { 35 TOTAL }
  TCgiEnvVar = record
    Accept: function: string;     
    AcceptEncod: function: string;
    AcceptLang: function: string; 
    AuthType: function: string;
    ContentLength: function: string;
    ContentType: function: string;
    Cookie: function: string;   
    DocName: function: string;
    DocRoot: function: string;
    DocUri: function: string;
    Forwarded: function: string;
    GateIntf: function: string;
    Host: function: string;
    IfModSince: function: string;
    PathInfo: function: string;
    PathTranslated: function: string;
    Pragma: function: string;   
    QueryString: function: string;
    Referer: function: string;  
    RemoteAddr: function: string;
    RemoteHost: function: string;
    RemoteIdent: function: string;
    RemotePort: function: string;
    RemoteUser: function: string;
    RequestMethod: function: string;
    RequestUri: function: string;
    ScriptFileName: function: string;
    ScriptName: function: string;
    ScriptUri: function: string;
    ServerAdmin: function: string;
    ServerName: function: string;
    ServerPort: function: string;
    ServerProtocol: function: string;
    ServerSig: function: string;
    ServerSoft: function: string;
    UserAgent: function: string;
  end;

function GetEnvVar(const name: ansistring): ansistring;  
function GetCgiEnvVars: TCgiEnvVars;
function IsEnvVar(const name: string): boolean;

(* Obsolete or future feature
  function CountEnvVars: longword;
  function FetchEnvVarName(index: longword): string;
  function FetchEnvVarVal(index: longword): string;
  function SetEnvVar(const name, value: string): boolean; *)



// single calls...
{ 35 TOTAL }
function GetCgiAccept: string;
function GetCgiAcceptEncod: string;
function GetCgiAcceptLang: string;
function GetCgiAuthType: string;
function GetCgiContentLength: string;
function GetCgiContentType: string;
function GetCgiCookie: string;
function GetCgiDocRoot: string;
function GetCgiDocName: string;
function GetCgiDocUri: string;
function GetCgiForwarded: string;
function GetCgiGateIntf: string;
function GetCgiHost: string;
function GetCgiIfModSince: string;
function GetCgiPathInfo: string;
function GetCgiPathTranslated: string;
function GetCgiPragma: string;
function GetCgiQueryString: string;
function GetCgiReferer: string;
function GetCgiRemoteAddr: string;
function GetCgiRemoteHost: string;
function GetCgiRemoteIdent: string;
function GetCgiRemoteUser: string;
function GetCgiRequestMethod: string;
function GetCgiRequestUri: string;
function GetCgiScriptFileName: string;
function GetCgiScriptName: string;
function GetCgiScriptUri: string;
function GetCgiServerAdmin: string;
function GetCgiServerName: string;
function GetCgiServerPort: string;
function GetCgiServerProtocol: string;
function GetCgiServerSig: string;
function GetCgiRemotePort: string;
function GetCgiServerSoft: string;
function GetCgiUserAgent: string;


{ public variables so developer does not need to declare them in his program }
var
  // access to all variables initialized (placed) into the record in one shot
  CgiEnvVars: TCgiEnvVars;

  // access to all variables, individually placed into the record on demand. 
  { 35 TOTAL }
const
{$IFDEF FPC}
  CgiEnvVar: TCgiEnvVar = (
    Accept: @GetCgiAccept;
    AcceptEncod: @GetCgiAcceptEncod;
    AcceptLang: @GetCgiAcceptLang;
    AuthType: @GetCgiAuthType;
    ContentLength: @GetCgiContentLength;
    ContentType: @GetCgiContentType ;
    Cookie: @GetCgiCookie;
    DocName: @GetCgiDocName;
    DocRoot: @GetCgiDocRoot;
    DocUri: @GetCgiDocUri;
    Forwarded: @GetCgiForwarded;
    GateIntf: @GetCgiGateIntf;
    Host: @GetCgiHost;
    IfModSince: @GetCgiIfModSince;
    PathInfo: @GetCgiPathInfo;
    PathTranslated: @GetCgiPathTranslated;
    Pragma: @GetCgiPragma;
    QueryString: @GetCgiQueryString;
    Referer: @GetCgiReferer;
    RemoteAddr: @GetCgiRemoteAddr;
    RemoteHost: @GetCgiRemoteHost;
    RemoteIdent: @GetCgiRemoteIdent;
    RemotePort: @GetCgiRemotePort;
    RemoteUser: @GetCgiRemoteUser;
    RequestMethod: @GetCgiRequestMethod;
    RequestURI: @GetCgiRequestUri;
    ScriptFileName: @GetCgiScriptFileName;
    ScriptName: @GetCgiScriptName;
    ScriptUri: @GetCgiScriptUri;
    ServerAdmin: @GetCgiServerAdmin;
    ServerName: @GetCgiServerName;
    ServerPort: @GetCgiServerPort;
    ServerProtocol: @GetCgiServerProtocol;
    ServerSig: @GetCgiServerSig;
    ServerSoft: @GetCgiServerSoft;
    UserAgent: @GetCgiUserAgent;
  );
{$ENDIF}

{$IFNDEF FPC}
  CgiEnvVar: TCgiEnvVar = (
    Accept:         GetCgiAccept;
    AcceptEncod:    GetCgiAcceptEncod;
    AcceptLang:     GetCgiAcceptLang;
    AuthType:       GetCgiAuthType;
    ContentLength:  GetCgiContentLength;
    ContentType:    GetCgiContentType ;
    Cookie:         GetCgiCookie;
    DocName:        GetCgiDocName;
    DocRoot:        GetCgiDocRoot;
    DocUri:         GetCgiDocUri;
    Forwarded:      GetCgiForwarded;
    GateIntf:       GetCgiGateIntf;
    Host:           GetCgiHost;
    IfModSince:     GetCgiIfModSince;
    PathInfo:       GetCgiPathInfo;
    PathTranslated: GetCgiPathTranslated;
    Pragma:         GetCgiPragma;
    QueryString:    GetCgiQueryString;
    Referer:        GetCgiReferer;
    RemoteAddr:     GetCgiRemoteAddr;
    RemoteHost:     GetCgiRemoteHost;
    RemoteIdent:    GetCgiRemoteIdent;
    RemotePort:     GetCgiRemotePort;
    RemoteUser:     GetCgiRemoteUser;
    RequestMethod:  GetCgiRequestMethod;
    RequestURI:     GetCgiRequestUri;
    ScriptFileName: GetCgiScriptFileName;
    ScriptName:     GetCgiScriptName;
    ScriptUri:      GetCgiScriptUri;
    ServerAdmin:    GetCgiServerAdmin;
    ServerName:     GetCgiServerName;
    ServerPort:     GetCgiServerPort;
    ServerProtocol: GetCgiServerProtocol;
    ServerSig:      GetCgiServerSig;
    ServerSoft:     GetCgiServerSoft;
    UserAgent:      GetCgiUserAgent;
  );
{$ENDIF}


// new syntax for 1.6.1
const
{$IFDEF FPC}
  SERV: TCgiEnvVar = (
    Accept: @GetCgiAccept;
    AcceptEncod: @GetCgiAcceptEncod;
    AcceptLang: @GetCgiAcceptLang;
    AuthType: @GetCgiAuthType;
    ContentLength: @GetCgiContentLength;
    ContentType: @GetCgiContentType ;
    Cookie: @GetCgiCookie;
    DocName: @GetCgiDocName;
    DocRoot: @GetCgiDocRoot;
    DocUri: @GetCgiDocUri;
    Forwarded: @GetCgiForwarded;
    GateIntf: @GetCgiGateIntf;
    Host: @GetCgiHost;
    IfModSince: @GetCgiIfModSince;
    PathInfo: @GetCgiPathInfo;
    PathTranslated: @GetCgiPathTranslated;
    Pragma: @GetCgiPragma;
    QueryString: @GetCgiQueryString;
    Referer: @GetCgiReferer;
    RemoteAddr: @GetCgiRemoteAddr;
    RemoteHost: @GetCgiRemoteHost;
    RemoteIdent: @GetCgiRemoteIdent;
    RemotePort: @GetCgiRemotePort;
    RemoteUser: @GetCgiRemoteUser;
    RequestMethod: @GetCgiRequestMethod;
    RequestURI: @GetCgiRequestUri;
    ScriptFileName: @GetCgiScriptFileName;
    ScriptName: @GetCgiScriptName;
    ScriptUri: @GetCgiScriptUri;
    ServerAdmin: @GetCgiServerAdmin;
    ServerName: @GetCgiServerName;
    ServerPort: @GetCgiServerPort;
    ServerProtocol: @GetCgiServerProtocol;
    ServerSig: @GetCgiServerSig;
    ServerSoft: @GetCgiServerSoft;
    UserAgent: @GetCgiUserAgent;
  );
{$ENDIF}

{$IFNDEF FPC}
  SERV: TCgiEnvVar = (
    Accept:         GetCgiAccept;
    AcceptEncod:    GetCgiAcceptEncod;
    AcceptLang:     GetCgiAcceptLang;
    AuthType:       GetCgiAuthType;
    ContentLength:  GetCgiContentLength;
    ContentType:    GetCgiContentType ;
    Cookie:         GetCgiCookie;
    DocName:        GetCgiDocName;
    DocRoot:        GetCgiDocRoot;
    DocUri:         GetCgiDocUri;
    Forwarded:      GetCgiForwarded;
    GateIntf:       GetCgiGateIntf;
    Host:           GetCgiHost;
    IfModSince:     GetCgiIfModSince;
    PathInfo:       GetCgiPathInfo;
    PathTranslated: GetCgiPathTranslated;
    Pragma:         GetCgiPragma;
    QueryString:    GetCgiQueryString;
    Referer:        GetCgiReferer;
    RemoteAddr:     GetCgiRemoteAddr;
    RemoteHost:     GetCgiRemoteHost;
    RemoteIdent:    GetCgiRemoteIdent;
    RemotePort:     GetCgiRemotePort;
    RemoteUser:     GetCgiRemoteUser;
    RequestMethod:  GetCgiRequestMethod;
    RequestURI:     GetCgiRequestUri;
    ScriptFileName: GetCgiScriptFileName;
    ScriptName:     GetCgiScriptName;
    ScriptUri:      GetCgiScriptUri;
    ServerAdmin:    GetCgiServerAdmin;
    ServerName:     GetCgiServerName;
    ServerPort:     GetCgiServerPort;
    ServerProtocol: GetCgiServerProtocol;
    ServerSig:      GetCgiServerSig;
    ServerSoft:     GetCgiServerSoft;
    UserAgent:      GetCgiUserAgent;
  );
{$ENDIF}

{-----------------------------------------------------------------------------}
 implementation
{-----------------------------------------------------------------------------}

uses
 {$IFDEF WIN32}windows{$ENDIF}
 {$IFDEF UNIX}baseunix{$ENDIF} ;
  

{-- PUBLIC FUNCTIONS ----------------------------------------------------------}

{ Returns value of an environment variable
  todo: implement security levels. it is needed!
  i.e. say someone tries to pass a User Agent as <script java hack_up_Server>}
function GetEnvVar(const name: ansistring): ansistring;
{$IFDEF WIN32}var tmp: integer;{$ENDIF}
begin
 {$IFDEF UNIX}
  Result:= fpGetEnv(Name);
 {$ENDIF}
 {$IFDEF WIN32}
  SetLength(Result,8192);
  tmp:= windows.GetEnvironmentVariable(@Name[1], @Result[1], 8192);
  SetLength(Result, tmp);
 {$ENDIF}  
end;

{ Tells if an environment variable is assigned }
function IsEnvVar(const name: string): boolean;
var tmp : string;
begin
  tmp := GetEnvVar(name);
  result := not (tmp = '')
end;

{ These functions are one liners so I can count lines and easily  match to the record field count  }

{ 35 TOTAL }
function GetCgiDocName: string;         begin result:= GetEnvVar('DOCUMENT_NAME'); end;
function GetCgiIfModSince: string;      begin result:= GetEnvVar('HTTP_IF_MODIFIED_SINCE');end;
function GetCgiGateIntf: string;        begin result:= GetEnvVar('GATEWAY_INTERFACE'); end;
function GetCgiAcceptEncod: string;     begin result:= GetEnvVar('HTTP_ACCEPT_ENCODING'); end;
function GetCgiAcceptLang: string;      begin result:= GetEnvVar('HTTP_ACCEPT_LANGUAGE');end;
function GetCgiCookie: string;          begin result:= GetEnvVar('HTTP_COOKIE');end;
function GetCgiForwarded: string;       begin result:= GetEnvVar('HTTP_FORWARDED'); end;
function GetCgiRequestUri: string;      begin result:= GetEnvVar('REQUEST_URI'); end;
function GetCgiHost: string;            begin result:= GetEnvVar('HTTP_HOST'); end;
function GetCgiPragma: string;          begin result:= GetEnvVar('HTTP_PRAGMA'); end;
function GetCgiScriptFileName: string;  begin result:= GetEnvVar('SCRIPT_FILENAME');end;
function GetCgiServerAdmin: string;     begin result:= GetEnvVar('SERVER_ADMIN'); end;
function GetCgiServerName: string;      begin result:= GetEnvVar('SERVER_NAME'); end;
function GetCgiServerSig: string;       begin result:= GetEnvVar('SERVER_SIGNATURE'); end;
function GetCgiRemotePort: string;      begin result:= GetEnvVar('REMOTE_PORT'); end;
function GetCgiServerSoft: string;      begin result:= GetEnvVar('SERVER_SOFTWARE'); end;
function GetCgiAuthType: string;        begin result:= GetEnvVar('AUTH_TYPE'); end;
function GetCgiContentLength: string;   begin result:= GetEnvVar('CONTENT_LENGTH'); end;
function GetCgiContentType: string;     begin result:= GetEnvVar('CONTENT_TYPE'); end;
function GetCgiDocRoot: string;         begin result:= GetEnvVar('DOCUMENT_ROOT'); end;
function GetCgiAccept: string;          begin result:= GetEnvVar('HTTP_ACCEPT'); end;
function GetCgiPathInfo: string;        begin result:= GetEnvVar('PATH_INFO'); end;
function GetCgiPathTranslated: string;  begin result:= GetEnvVar('PATH_TRANSLATED'); end;
function GetCgiQueryString: string;     begin result:= GetEnvVar('QUERY_STRING'); end;
function GetCgiReferer: string;         begin result:= GetEnvVar('HTTP_REFERER'); end;
function GetCgiRemoteAddr: string;      begin result:= GetEnvVar('REMOTE_ADDR'); end;
function GetCgiRemoteHost: string;      begin result:= GetEnvVar('REMOTE_HOST');end;
function GetCgiRemoteIdent: string;     begin result:= GetEnvVar('REMOTE_IDENT'); end;
function GetCgiRemoteUser: string;      begin result:= GetEnvVar('REMOTE_USER'); end;
function GetCgiRequestMethod: string;   begin result:= GetEnvVar('REQUEST_METHOD'); end;
function GetCgiScriptName: string;      begin result:= GetEnvVar('SCRIPT_NAME'); end;
function GetCgiServerProtocol: string;  begin result:= GetEnvVar('SERVER_PROTOCOL'); end;
function GetCgiServerPort: string;      begin result:= GetEnvVar('SERVER_PORT'); end;
function GetCgiUserAgent: string;       begin result:= GetEnvVar('HTTP_USER_AGENT'); end;
function GetCgiDocUri: string;          begin result:= GetEnvVar('DOCUMENT_URI'); end;
function GetCgiScriptUri: string;       begin result:= GetEnvVar('SCRIPT_URI'); end;


{ Get all cgi environment variables into a record all at once
  Not as fast/effecient as single calls }
function GetCgiEnvVars: TCgiEnvVars;
begin
  with result do 
  begin 
    { 35 TOTAL }
    Accept        := GetEnvVar('HTTP_ACCEPT');
    AcceptEncod   := GetEnvVar('HTTP_ACCEPT_ENCODING');
    AcceptLang    := GetEnvVar('HTTP_ACCEPT_LANGUAGE');
    AuthType      := GetEnvVar('AUTH_TYPE');
    ContentLength := GetEnvVar('CONTENT_LENGTH');
    ContentType   := GetEnvVar('CONTENT_TYPE');
    Cookie        := GetEnvVar('HTTP_COOKIE');
    DocName       := GetEnvVar('DOCUMENT_NAME');
    DocRoot       := GetEnvVar('DOCUMENT_ROOT');
    DocUri        := GetEnvVar('DOCUMENT_URI');
    Forwarded     := GetEnvVar('HTTP_FORWARDED');
    GateIntf      := GetEnvVar('GATEWAY_INTERFACE');
    Host          := GetEnvVar('HTTP_HOST');
    IfModSince    := GetEnvVar('HTTP_IF_MODIFIED_SINCE');
    PathInfo      := GetEnvVar('PATH_INFO');
    PathTranslated:= GetEnvVar('PATH_TRANSLATED');
    Pragma        := GetEnvVar('HTTP_PRAGMA');
    QueryString   := GetEnvVar('QUERY_STRING');
    Referer       := GetEnvVar('HTTP_REFERER');
    RemoteAddr    := GetEnvVar('REMOTE_ADDR');
    RemoteHost    := GetEnvVar('REMOTE_HOST');
    RemoteIdent   := GetEnvVar('REMOTE_IDENT');
    RemotePort    := GetEnvVar('REMOTE_PORT');
    RemoteUser    := GetEnvVar('REMOTE_USER');
    RequestMethod := GetEnvVar('REQUEST_METHOD');
    RequestUri    := GetEnvVar('REQUEST_URI');
    ScriptFileName:= GetEnvVar('SCRIPT_FILENAME');
    ScriptName    := GetEnvVar('SCRIPT_NAME');
    ScriptUri     := GetEnvVar('SCRIPT_URI');
    ServerAdmin   := GetEnvVar('SERVER_ADMIN');
    ServerName    := GetEnvVar('SERVER_NAME');
    ServerPort    := GetEnvVar('SERVER_PORT');
    ServerProtocol:= GetEnvVar('SERVER_PROTOCOL');
    ServerSig     := GetEnvVar('SERVER_SIGNATURE');
    ServerSoft    := GetEnvVar('SERVER_SOFTWARE');
    UserAgent     := GetEnvVar('HTTP_USER_AGENT');
  end;
end;

// END OF PUBLIC FUNCTIONS
{------------------------------------------------------------------------------}


end.

