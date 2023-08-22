{*******************************************************}
{                                                       }
{       Borland Delphi Test Server                      }
{                                                       }
{  Copyright (c) 2002-2005 Borland Software Corporation }
{                                                       }
{*******************************************************}

unit SvrHTTPIndy;

interface


uses
{$IFDEF MSWINDOWS}
  Windows, Registry,
{$ENDIF}
  SysUtils, Classes, SyncObjs,
  WebBroker, HTTPApp, SvrLog, IdHTTPServer, IdCustomHTTPServer, IdTCPServer, IdIntercept,
  IdSocketHandle, IniFiles, SockAppNotify, IdStackConsts, IdGlobal;


type
  TCustomWebServer = class;
  TWebServerRequest = class;

{ EWebServerException }

  EWebServerException = class(Exception)
  private
    FRequest: TWebServerRequest;
  public
    constructor Create(const Message: string; ARequest: TWebServerRequest);
    property Request: TWebServerRequest read FRequest;
  end;

{$IFDEF MSWINDOWS}
  EFailedToRetreiveTimeZoneInfo = class(Exception);
{$ENDIF}

{ TWebServerRequest }

  TConnectionIntercept = class(TIdConnectionIntercept)
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
{$IF gsIdVersion = '8.0.25'} // D6, K2 compatible
    procedure DataReceived(var ABuffer; const AByteCount: integer); override;
    procedure DataSent(var ABuffer; const AByteCount: integer); override;
{$ELSE}
    procedure Receive(ABuffer: TStream); override;
    procedure Send(ABuffer: TStream); override;
{$IFEND}
  end;

  TServerIntercept = class(TIdServerIntercept)
  public
    procedure Init; override;
{$IF gsIdVersion = '8.0.25'} // D6, K2 compatible
    function Accept(ABinding: TIdSocketHandle): TIdConnectionIntercept; override;
{$ELSE}
    function Accept(AConnection: TComponent): TIdConnectionIntercept; override;
{$IFEND}
  end;

  TRequestLogBuffer = class(TObject)
  private
    FLogBuffer: string;
  end;

  TWebServerRequest = class(TWebRequest)
  private
    FThread: TThread;
    FIdHTTPRequestInfo: TIdHTTPRequestInfo;
    FIdHTTPResponseInfo: TIdHTTPResponseInfo;
    FReadClientIndex: Integer;
    procedure SetStringVariable(Index: Integer; const Value: string);
    procedure SetIntegerVariable(Index: Integer; Value: Integer);
    procedure SetDateVariable(Index: Integer; Value: TDateTime);
  protected
    function GetStringVariable(Index: Integer): string; override;
    function GetDateVariable(Index: Integer): TDateTime; override;
    function GetIntegerVariable(Index: Integer): Integer; override;
  public
    constructor Create(APort: Integer;
      ARemoteAddress, ARemoteHost: string;
      ARequestInfo: TIdHTTPRequestInfo; AResponseInfo: TIdHTTPResponseInfo; AThread: TThread);
    function GetFieldByName(const Name: string): string; override;
    function ReadClient(var Buffer; Count: Integer): Integer; override;
    function ReadString(Count: Integer): string; override;
    function TranslateURI(const URI: string): string; override;
    function WriteClient(var Buffer; Count: Integer): Integer; override;
    function WriteString(const AString: string): Boolean; override;
    function WriteHeaders(StatusCode: Integer; const StatusString, Headers: string): Boolean; override;
    property RequestInfo: TIdHTTPRequestInfo read FIdHTTPRequestInfo;
    property Thread: TThread read FThread;
  end;

  TServerLog = class;

{ TWebServerResponse }

  TWebServerResponse = class(TWebResponse)
  private
    FIdHTTPResponseInfo: TIdHTTPResponseInfo;
    FRequest: TWebServerRequest;
    FLog: TServerLog;
    FLogBuffer: string;
    FSent: Boolean;
  protected
    procedure SetStatusCode(Value: Integer); override;
    procedure SetContent(const Value: string); override;
    procedure SetContentStream(Value: TStream); override;
    function GetStringVariable(Index: Integer): string;  override;
    procedure SetStringVariable(Index: Integer; const Value: string);  override;
    function GetDateVariable(Index: Integer): TDateTime;  override;
    procedure SetDateVariable(Index: Integer; const Value: TDateTime);  override;
    function GetIntegerVariable(Index: Integer): Integer;  override;
    procedure SetIntegerVariable(Index: Integer; Value: Integer);  override;
    function GetContent: string;  override;
    function GetStatusCode: Integer;  override;
    function GetLogMessage: string; override;
    procedure SetLogMessage(const Value: string); override;
  public
    procedure SendResponse;  override;
    procedure SendRedirect(const URI: string);  override;
    procedure SendStream(AStream: TStream);  override;
    function Sent: Boolean; override;
    property Request: TWebServerRequest read FRequest;
    constructor Create(ARequest: TWebServerRequest; AResponseInfo: TIdHTTPResponseInfo; ALog: TServerLog);
    destructor Destroy; override;
  end;

  TSocketArray = array of TIdStackSocketHandle;

{ TCustomWebServer }
  TErrorCode = (ecTimeout, ecExecFail, ecTokenMismatch, ecOK);

  TCustomWebServer = class(TComponent)
  private
    FMimeTable: TIdMimeTable;
    FHTTPServer: TIdHTTPServer;
    FLog: TServerLog;
    FOnLog: THTTPLogEvent;
    FSearchPath: string;
    FDefaultURL: string;
    FExpandedSearchPath: string;
    FRunningWebAppListener: TRunningWebAppListener;
    function GetTranslatedDefaultURL: string;
    function GetExpandedSearchPath: string;
    procedure SetSearchPath(const Value: string);
    procedure HTTPServerCommandGet(AThread: TIdPeerThread;
      RequestInfo: TIdHTTPRequestInfo; ResponseInfo: TIdHTTPResponseInfo);
    procedure HTTPServerCommandOther(Thread: TIdPeerThread;
      const asCommand, asData, asVersion: string);
    procedure ExecuteHTTPRequest(Thread: TThread; RequestInfo: TIdHTTPRequestInfo;
      ResponseInfo: TIdHTTPResponseInfo);
    function DoFileAccess(Request: TWebServerRequest;
      IsHeadMethod: Boolean; ResponseInfo: TIdHTTPResponseInfo): Boolean;
    function GetMIMEType(const FileName: string): string;
    procedure URLNotFound(Request: TWebServerRequest; ResponseInfo: TIdHTTPResponseInfo);
    procedure HandleException(Request: TWebServerRequest; ResponseInfo: TIdHTTPResponseInfo);
    procedure ServerError(Request: TWebServerRequest;
      ResponseInfo: TIdHTTPResponseInfo; const ErrorMsg: string);
    procedure LogRequest(Request: TWebServerRequest);
    property ExpandedSearchPath: string read GetExpandedSearchPath;
    function GetPort: Integer;
    procedure SetPort(const Value: Integer);
    function GetActive: Boolean;
    procedure SetActive(const Value: Boolean);
    {$IFDEF LINUX}
    function ExecWaitForToken(const AFileName, AToken: string;
      AWaitSecs: Integer; out ErrorCode: TErrorCode): Boolean;
    {$ENDIF LINUX}
  public
{$IFDEF LINUX}
    procedure GetOpenSockets(var Sockets: TSocketArray);
{$ENDIF}
    property TranslatedDefaultURL: string read GetTranslatedDefaultURL;
    property Active: Boolean read GetActive write SetActive;
    property SearchPath: string read FSearchPath write SetSearchPath;
    property DefaultURL: string read FDefaultURL write FDefaultURL;
    property Port: Integer read GetPort write SetPort;
    property OnLog: THTTPLogEvent read FOnLog write FOnLog;
    property RunningWebAppListener: TRunningWebAppListener read FRunningWebAppListener;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  end;

  TServerLog = class(TCustomServerLog)
  private
    FWebServer: TCustomWebServer;
  protected
    procedure DoOnLog(Transaction: TTransactionLogEntry;
      var Release: Boolean); override;
  public
    constructor Create(AServer: TCustomWebServer);
  end;

{$IFDEF LINUX}
  procedure CloseOpenSockets(Sockets: array of TIdStackSocketHandle);
{$ENDIF}

implementation

uses BrkrConst, SvrConst,
  SockAppReg, SvrSockRequest, Math {$IFDEF LINUX} ,libc {$ENDIF};

threadvar ThreadRequestLogBuffer: TRequestLogBuffer;
threadvar ThreadResponse: TWebServerResponse;

function LocalTimeToUTCTime(DateTime: TDateTime): TDateTime; forward;

const
  viMethod = 0;
  viProtocolVersion = 1;
  viURL = 2;
  viQuery = 3;
  viPathInfo = 4;
  viPathTranslated = 5;
  viCacheControl = 6;
  viDate = 7;
  viAccept = 8;
  viFrom = 9;
  viHost = 10;
  viIfModified = 11;
  viReferer = 12;
  viUserAgent = 13;
  viContentEncoding = 14;
  viContentType = 15;
  viContentLength = 16;
  viContentVersion = 17;
  viDerivedFrom = 18;
  viExpires = 19;
  viTitle = 20;
  viRemoteAddr = 21;
  viRemoteHost = 22;
  viScriptName = 23;
  viServerPort = 24;
  viContent = 25;
  viConnection = 26;
  viCookie = 27;
  viAuthorization = 28;

  CGIServerVariables: array[viMethod..viAuthorization] of string = (
    'REQUEST_METHOD',                          { Do not localize }
    'SERVER_PROTOCOL',                         { Do not localize }
    'URL',                                     { Do not localize }
    'QUERY_STRING',                            { Do not localize }
    'PATH_INFO',                               { Do not localize }
    'PATH_TRANSLATED',                         { Do not localize }
    'HTTP_CACHE_CONTROL',                      { Do not localize }
    'HTTP_DATE',                               { Do not localize }
    'HTTP_ACCEPT',                             { Do not localize }
    'HTTP_FROM',                               { Do not localize }
    'HTTP_HOST',                               { Do not localize }
    'HTTP_IF_MODIFIED_SINCE',                  { Do not localize }
    'HTTP_REFERER',                            { Do not localize }
    'HTTP_USER_AGENT',                         { Do not localize }
    'HTTP_CONTENT_ENCODING',                   { Do not localize }
    'HTTP_CONTENT_TYPE',                       { Do not localize }
    'HTTP_CONTENT_LENGTH',                     { Do not localize }
    'HTTP_CONTENT_VERSION',                    { Do not localize }
    'HTTP_DERIVED_FROM',                       { Do not localize }
    'HTTP_EXPIRES',                            { Do not localize }
    'HTTP_TITLE',                              { Do not localize }
    'REMOTE_ADDR',                             { Do not localize }
    'REMOTE_HOST',                             { Do not localize }
    'SCRIPT_NAME',                             { Do not localize }
    'SERVER_PORT',                             { Do not localize }
    '',                                        { Do not localize }
    'HTTP_CONNECTION',                         { Do not localize }
    'HTTP_COOKIE',                             { Do not localize }
    'HTTP_AUTHORIZATION');
                         { Do not localize }
  HTTPHeaderNames: array[viMethod..viAuthorization] of string = (
    '',                          { Method }
    '',                          { Protocol }
    '',                          { URL }
    '',                          { Query String }
    '',                          { PathInfo }
    '',                          { PathTranslated }
    'Cache-Control',                      { Do not localize }
    'Date',                               { Do not localize }
    'Accept',                             { Do not localize }
    'From',                               { Do not localize }
    'Host',                               { Do not localize }
    'If-Modified-Since',                  { Do not localize }
    'Referer',                            { Do not localize }
    'User-Agent',                         { Do not localize }
    'Content-Encoding',                   { Do not localize }
    'Content-Type',                       { Do not localize }
    'Content-Length',                     { Do not localize }
    'Content-Version',                    { Do not localize }
    '',                          { DerivedFrom }
    'Expires',                   { Do not localize }
    '',                          { Title }
    '',                          { RemoteAddr }
    '',                          { RemoteHost }
    '',                          { ScriptName }
    '',                          { ServerPort }
    '',                                   { Do not localize }
    'Connection',                         { Do not localize }
    'Cookie',                             { Do not localize }
    'Authorization');                     { Do not localize }

{ EWebServerException }

constructor EWebServerException.Create(const Message: string;
  ARequest: TWebServerRequest);
begin
  inherited Create(Message);
  FRequest := ARequest;
end;

{ TWebServerRequest}

type
  TIdHTTPResponseInfoCracker = class(TIdHTTPResponseInfo)
  end;

constructor TWebServerRequest.Create(APort: Integer;
  ARemoteAddress, ARemoteHost: string;
  ARequestInfo: TIdHTTPRequestInfo; AResponseInfo: TIdHTTPResponseInfo; AThread: TThread);
begin
  FIdHTTPRequestInfo := ARequestInfo;
  FIdHTTPResponseInfo := AResponseInfo;
  FThread := AThread;
  inherited Create;
end;

function NameToIndex(const AName: string): Integer;
var
  I: Integer;
begin
  Result := -1;
  for I := Low(CGIServerVariables) to High(CGIServerVariables) do
  begin
    if CompareText(CGIServerVariables[I], AName) = 0 then
    begin
      Result := I;
      Exit;
    end;
  end;
end;

function StripHTTP(const Name: string): string;
begin
  if Pos('HTTP_', Name) = 1 then
    Result := Copy(Name, 6, MaxInt)
  else Result := Name;
end;

function TWebServerRequest.GetFieldByName(const Name: string): string;
var
  Index: Integer;
begin
  Index := NameToIndex(Name);
  if Index = -1 then
    Index := NameToIndex(StripHTTP(Name));
  if Index <> -1 then
    Result := GetStringVariable(Index)
  else
{$IF gsIdVersion = '8.0.25'} // D6, K2 compatible
    Result := FIdHTTPRequestInfo.Headers.Values[StripHTTP(Name)];
{$ELSE}
    Result := FIdHTTPRequestInfo.RawHeaders.Values[StripHTTP(Name)];
{$IFEND}
end;

function TWebServerRequest.GetStringVariable(Index: Integer): string;

  function HeaderValue(Index: Integer): string;
  begin
    Assert(HTTPHeaderNames[Index] <> '');
    {$IF gsIdVersion = '8.0.25'} // D6, K2 compatible
    Result := FIdHTTPRequestInfo.Headers.Values[HTTPHeaderNames[Index]];
    {$ELSE}
    Result := FIdHTTPRequestInfo.RawHeaders.Values[HTTPHeaderNames[Index]];
    {$IFEND}
  end;

  function GetScriptName: string;
  var
  	SlashPos: Integer;
  begin
  	Result := FIdHTTPRequestInfo.Document; 
    if Length(Result) > 0 then
    begin
      Delete(Result, 1, 1); // delete the first /
      SlashPos := Pos('/', Result);
      if SlashPos <> 0 then
        Delete(Result, SlashPos, MaxInt); // delete everything after the next /
      // Add back in the starting slash
	    Result := '/' + Result;
    end;  
  end;  
  
begin
  case Index of
    viMethod:          Result := FIdHTTPRequestInfo.Command;
    viProtocolVersion: Result := FIdHTTPRequestInfo.Version;
    viURL:             Result := '';  // jmt.!!! Not implemented
    viQuery:           if StrToIntDef(HeaderValue(viContentLength), 0) = 0 then
                         Result := FIdHTTPRequestInfo.UnparsedParams
                       else
                         Result := '';
    viPathInfo:        Result := FIdHTTPRequestInfo.Document;
    viPathTranslated:  Result := FIdHTTPRequestInfo.Document;  // jmt.!!! Not implemented
    viCacheControl:    Result := HeaderValue(Index);
    viDate:            Result := HeaderValue(Index);
    viAccept:          Result := HeaderValue(Index);
    viFrom:            Result := HeaderValue(Index);
    viHost:            Result := HeaderValue(Index);
    viIfModified:      Result := HeaderValue(Index);
    viReferer:         Result := HeaderValue(Index);
    viUserAgent:       Result := HeaderValue(Index);
    viContentEncoding: Result := HeaderValue(Index);
    viContentType:     Result := HeaderValue(Index);
    viContentLength:   Result := HeaderValue(Index);
    viContentVersion:  Result := HeaderValue(Index);
    viDerivedFrom:     Result := ''; // jmt.!!! Not implemented
    viExpires:         Result := HeaderValue(Index);
    viTitle:           Result := ''; // jmt.!!! Not implemented
    viRemoteAddr:      Result := FIdHTTPRequestInfo.RemoteIP;
    viRemoteHost:      Result := FIdHTTPRequestInfo.Host;
    viScriptName:      Result := GetScriptName;
    viServerPort:      Result := ''; // jmt.!!! Not implemented
    viContent:         Result := FIdHTTPRequestInfo.UnparsedParams;
    viConnection:      Result := HeaderValue(Index);
    viCookie:          Result := HeaderValue(Index);
    viAuthorization:   Result := HeaderValue(Index);
  else
    Result := '';
  end;
end;

function TWebServerRequest.GetDateVariable(Index: Integer): TDateTime;
var
  Value: string;
begin
  Value := GetStringVariable(Index);
  if Value <> '' then
    Result := ParseDate(Value)
  else Result := -1;
end;

function TWebServerRequest.GetIntegerVariable(Index: Integer): Integer;
var
  Value: string;
begin
  Value := GetStringVariable(Index);
  if Value <> '' then
    Result := StrToInt(Value)
  else Result := -1;
end;

function TWebServerRequest.ReadClient(var Buffer; Count: Integer): Integer;
begin
  Count := Max(Length(FIdHTTPRequestINfo.UnparsedParams) - FReadClientIndex, Count);
  if Count > 0 then
  begin
    Move(FIdHTTPRequestInfo.UnparsedParams[FReadClientIndex+1], Buffer, Count);
    Inc(FReadClientIndex, Count);
    Result := Count;
  end
  else
    Result := 0;
end;

function TWebServerRequest.ReadString(Count: Integer): string;
var
  Len: Integer;
begin
  SetLength(Result, Count);
  Len := ReadClient(Pointer(Result)^, Count);
  if Len > 0 then
    SetLength(Result, Len)
  else Result := '';
end;

function TWebServerRequest.TranslateURI(const URI: string): string;
begin
  // Not implemented
  Result := URI;
end;

function TWebServerRequest.WriteClient(var Buffer; Count: Integer): Integer;
var
  S: string;
begin
  Result := Count;
  try
    SetString(S, PChar(@Buffer), Count);
    FIdHTTPResponseInfo.ContentText := S;
    FIdHTTPResponseInfo.WriteContent;
  except
    Result := 0;
  end;
end;

function TWebServerRequest.WriteString(const AString: string): Boolean;
begin
  Result := WriteClient(Pointer(AString)^, Length(AString)) = Length(AString);
end;

function TWebServerRequest.WriteHeaders(StatusCode: Integer;
  const StatusString, Headers: string): Boolean;
begin
  // Prevent TIdHTTPServer from writing headers
  TIdHTTPResponseInfoCracker(FIdHTTPResponseInfo).FHeaderHasBeenWritten := True;
  { TODO -oJMT -cMUSTFIX : Redo this.  Parse headers and call Indy WriteHeader and WriteContent. }
  Result := WriteString(Format('HTTP/1.1 %s'#13#10'%s', [StatusString, Headers]));
end;

procedure TWebServerRequest.SetStringVariable(
  Index: Integer; const Value: string);
begin
{$IF gsIdVersion = '8.0.25'} // D6, K2 compatible
  if HTTPHeaderNames[Index] <> '' then
    FIdHTTPResponseInfo.Headers.Values[HTTPHeaderNames[Index]] := Value
  else
    FIdHTTPResponseINfo.Headers.Values[StripHTTP(CGIServerVariables[Index])];
{$ELSE}
  if HTTPHeaderNames[Index] <> '' then
    FIdHTTPResponseInfo.RawHeaders.Values[HTTPHeaderNames[Index]] := Value
  else
    FIdHTTPResponseINfo.RawHeaders.Values[StripHTTP(CGIServerVariables[Index])];
{$IFEND}
end;

procedure TWebServerRequest.SetDateVariable(Index: Integer;
  Value: TDateTime);
begin
  SetStringVariable(Index, 
   Format(FormatDateTime('"%s", dd "%s" yyyy hh:mm:ss "GMT"', Value),  { do not localize }
   [DayOfWeekStr(Value), MonthStr(Value)]));
end;

procedure TWebServerRequest.SetIntegerVariable(Index, Value: Integer);
begin
  SetStringVariable(Index, IntToStr(Value));
end;

{ TWebServerResponse }

constructor TWebServerResponse.Create(ARequest: TWebServerRequest;
  AResponseInfo: TIdHTTPResponseInfo; ALog: TServerLog);
begin
  ThreadResponse := Self;
  inherited Create(ARequest);
  FRequest := ARequest;
  FLog := ALog;
  FIdHTTPResponseInfo := AResponseInfo;
   FIdHTTPResponseInfo.ResponseNo := 200;
end;

destructor TWebServerResponse.Destroy;
begin
  FLog.LogResponse(Self, FLogBuffer);
  FIdHTTPResponseInfo.ContentStream.Free;
  FIdHTTPResponseInfo.ContentStream := nil;
  inherited Destroy;
end;

function TWebServerResponse.GetStringVariable(Index: Integer): string;
begin
  Result := FRequest.GetStringVariable(Index);
end;

procedure TWebServerResponse.SetStringVariable(Index: Integer; const Value: string);
begin
  FRequest.SetStringVariable(Index, Value);
end;

procedure TWebServerResponse.SetDateVariable(Index: Integer; const Value: TDateTime);
begin
  FRequest.SetDateVariable(Index, Value);
end;

procedure TWebServerResponse.SetIntegerVariable(Index: Integer; Value: Integer);
begin
  FRequest.SetIntegerVariable(Index, Value);
end;

function TWebServerResponse.GetContent: string;
begin
  Result := FIdHTTPResponseInfo.ContentText;
end;

function TWebServerResponse.GetDateVariable(Index: Integer): TDateTime;
begin
  Result := FRequest.GetDateVariable(Index);
end;

function TWebServerResponse.GetIntegerVariable(Index: Integer): Integer;
begin
  Result := FRequest.GetIntegerVariable(Index);
end;

function TWebServerResponse.GetStatusCode: Integer;
begin
  Result := FIdHTTPResponseInfo.ResponseNo;
end;

procedure TWebServerResponse.SetStatusCode(Value: Integer);
begin
  FIdHTTPResponseInfo.ResponseNo := Value;
end;

function TWebServerResponse.GetLogMessage: string;
begin
  { TODO -oJMT -cMUSTFIX : Implement this }
  // Service not available
  Result := '';
end;

procedure TWebServerResponse.SetLogMessage(const Value: string);
begin
  { TODO -oJMT -cMUSTFIX : Implement this }
  // Service not available
end;

procedure TWebServerResponse.SetContent(const Value: string);
begin
  FIdHTTPResponseInfo.ContentText := Value;
  FIdHTTPResponseInfo.ContentLength := Length(Value);
end;

procedure TWebServerResponse.SetContentStream(Value: TStream);
begin
  FIdHTTPResponseInfo.ContentStream := Value;
  FIdHTTPResponseInfo.ContentLength := Value.Size;
end;

procedure TWebServerResponse.SendResponse;
begin
  FIdHTTPResponseINfo.WriteHeader;
  FIdHTTPResponseInfo.WriteContent;
  FSent := True;
end;

procedure TWebServerResponse.SendStream(AStream: TStream);
begin
  FIdHTTPResponseInfo.ContentStream := AStream;
  try
    FIdHTTPResponseInfo.WriteContent;
  finally
    FIdHTTPResponseInfo.ContentStream := nil;
  end;
end;

procedure TWebServerResponse.SendRedirect(const URI: string);
begin
  FIdHTTPResponseINfo.Redirect(URI);
  SendResponse;
end;

function TWebServerResponse.Sent: Boolean;
begin
  Result := FSent;
end;

procedure InitializeRootDirVariable(const AMacro: string); forward;

{ TCustomWebServer }

constructor TCustomWebServer.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FMimeTable := TIdMimeTable.Create;
  FHTTPServer := TIdHTTPServer.Create(nil);
  FHTTPServer.ParseParams := False;  // Don't parse content fields or query fields
  FHTTPServer.OnCommandGet := HTTPServerCommandGet;
  FHTTPServer.OnCommandOther := HTTPServerCommandOther;
  FHTTPServer.Intercept := TServerIntercept.Create(nil);
  FLog := TServerLog.Create(Self);
  try
    FRunningWebAppListener := TRunningWebAppListener.Create;
  except
    FRunningWebAppListener := nil;
  end;
  InitializeRootDirVariable('BDS');
  InitializeRootDirVariable('BCB');
  InitializeRootDirVariable('DELPHI');
end;

destructor TCustomWebServer.Destroy;
begin
  inherited Destroy;
  FMimeTable.Free;
  FHTTPServer.Free;
  FLog.Free;
  FRunningWebAppListener.Free;
end;

procedure TCustomWebServer.LogRequest(Request: TWebServerRequest);
begin
  if ThreadRequestLogBuffer <> nil then
    FLog.LogRequest(Request, ThreadRequestLogBuffer.FLogBuffer)
  else
    FLog.LogRequest(Request, '');
end;

function TCustomWebServer.GetTranslatedDefaultURL: string;
var
  S: string;
begin
  S := FDefaultURL;
  Result := S;
  if S <> '' then
  begin
    if (CompareText(Copy(S, 1, 4), 'http') <> 0) and
      (CompareText(Copy(S, 1, 2), '//') <> 0) then
    begin
      Result := 'http:';
      if Copy(S, 1, 2) = '//' then
        Result := Result + S
      else
      begin
        Result := Result + '//';
        if S[1] = '/' then
          Delete(S, 1, 1);
        Result := Format('%slocalhost:%d/%s', [Result, Port, S])
      end;
    end;
  end;
end;

procedure TCustomWebServer.HTTPServerCommandGet(AThread: TIdPeerThread;
  RequestInfo: TIdHTTPRequestInfo; ResponseInfo: TIdHTTPResponseInfo);
begin
  ExecuteHTTPRequest(AThread, RequestInfo, ResponseInfo);
end;

procedure TCustomWebServer.HTTPServerCommandOther(Thread: TIdPeerThread;
  const asCommand, asData, asVersion: string);
begin
end;

function TCustomWebServer.GetMIMEType(const FileName: string): string;
var
  Ext: string;
begin
  Result := 'application/octet-stream';
  Ext := ExtractFileExt(FileName);
{$IFDEF MSWINDOWS}
  if (CompareText(Ext, '.exe') = 0) or (CompareText(Ext, '.dll') = 0) then
    Exit;
{$ENDIF}
  Result := FMimeTable.GetFileMIMEType(FileName);
end;

{$IFDEF LINUX}
procedure TCustomWebServer.GetOpenSockets(var Sockets: TSocketArray);

  procedure Add(Handle: TIdStackSocketHandle);
  begin
    SetLength(Sockets, Length(Sockets) + 1);
    Sockets[High(Sockets)] := Handle;
  end;
var
  I: Integer;
begin
  SetLength(Sockets, 0);
  for I := 0 to FHTTPServer.Bindings.Count do
    Add(FHTTPServer.Bindings.Items[0].Handle);
  if FRunningWebAppListener <> nil then
    for I := 0 to FRunningWebAppListener.Connection.Bindings.Count do
      Add(FRunningWebAppListener.Connection.Bindings.Items[0].Handle);
end;
{$ENDIF}

{$IFDEF LINUX}
procedure CloseOpenSockets(Sockets: array of TIdStackSocketHandle);
var
  I: Integer;
begin
  for I := 0 to Length(Sockets) - 1 do
    Libc.__close(Sockets[I]);
end;
{$ENDIF}

{$IFDEF LINUX}

function TCustomWebServer.ExecWaitForToken(const AFileName, AToken: string; AWaitSecs: Integer; out ErrorCode: TErrorCode): Boolean;
const
  FailToken = '!!Fail!!';
  MaxToken = 256;
var
  Argv: array of PChar;
  PID: Integer;
  Descr: TPipeDescriptors;
  { variables used when execing }
  fd, BytesRead: Integer;
  DescriptorSet: TFDSet;
  WaitTime: TTimeVal;
  { variables used to read from the socket }
  PipeStream : THandleStream;
  Buffer: string;
  Sockets: TSocketArray;
begin
  SetLength(Sockets, 0);
  GetOpenSockets(Sockets);
  pipe(Descr);
  SetLength(Argv, 4);
  Argv[0] := PChar(AFileName);
  Argv[1] := PChar(AToken);
  Argv[2] := PChar(IntToStr(Descr.WriteDes));
  Argv[3] := nil;
  PID := fork;
  if PID = 0 then
  begin
    CloseOpenSockets(Sockets);
    __close(Descr.ReadDes);
    if execv(PChar(Argv[0]), @Argv[0]) = -1 then
    begin
      PipeStream := THandleStream.Create(Descr.WriteDes);
      try
        PipeStream.Write(FailToken, Length(FailToken));
      finally
        PipeStream.Free;
      end;
    end;
    _exit(1);
  end
  else
  begin
    __close(Descr.WriteDes);
    { set up information about file descriptors }
    WaitTime.tv_sec := AWaitSecs;
    WaitTime.tv_usec := 0;

    { cast the descriptors to TSocket, because the pascal declaration
      of the function demands that --- but note that since TSocket is
      an integer, and the file descriptor is an integer, this is OK. }
    FD_ZERO(DescriptorSet);
    FD_SET(TSocket(Descr.ReadDes), DescriptorSet);

    { check and see which file descriptor has been written to. }
    fd := select(__FD_SETSIZE, @DescriptorSet, nil, nil, @WaitTime);
    if(fd = 0) then
      ErrorCode := ecTimeout
    else if FD_ISSET(TSocket(Descr.ReadDes), DescriptorSet) then
    begin
      fd := Descr.ReadDes;
      PipeStream := THandleStream.Create(fd);
      try
        Assert(Length(AToken) <= MaxToken);
        { read the input stream }
        SetLength(Buffer, MaxToken);
        try
          BytesRead := PipeStream.Read(Buffer[1], MaxToken);
          SetLength(Buffer, BytesRead);
        except
          SetLength(Buffer, 0);
          raise;
        end;
      finally
        PipeStream.Free;
      end;
      if CompareText(Buffer, AToken) = 0 then
        ErrorCode := ecOK
      else if CompareText(Buffer, FailToken) = 0 then
        ErrorCode := ecExecFail
      else
        ErrorCode := ecTokenMismatch;
    end
    else
      ErrorCode := ecTimeout;
  end;
  Result := ErrorCode = ecOK;
end;
{$ENDIF}

resourcestring
{$IFDEF MSWINDOWS}
  sErrorExec = 'Can''t execute %s %d';
resourcestring
  sFailedTimeZoneInfo = 'Failed attempting to retrieve time zone information.';
{$ENDIF}
{$IFDEF LINUX}
  sErrorExecTimeout = 'Timeout occurred waiting for %s to execute';
  sErrorExecFail = 'Unable to execute %s';
  sErrorExecUnexpected = 'Unexpected error occurred executing %s';
{$ENDIF}

function TCustomWebServer.DoFileAccess(Request: TWebServerRequest;
  IsHeadMethod: Boolean; ResponseInfo: TIdHTTPResponseInfo): Boolean;

  function CheckFileExists(const AFileName: string): Boolean;
  begin
    Result := FileExists(PChar(AFileName));
  end;

  function SearchForFile(ADirList: string): string;
  var
    I, P, L: Integer;
    FileName: string;
  begin
    FileName := Request.PathInfo;
    P := Pos('/', FileName);
    while P <> 0 do
    begin
      if P = Length(FileName) then
        Delete(FileName, P, 1)
      else
        Delete(FileName, 1, P);
      P := Pos('/', FileName);
    end;
    if (FileName <> '') then
    begin
      P := 1;
      L := Length(ADirList);
      while P <= L do
      begin
        I := P;
        while (P <= L) and (ADirList[P] <> ';') do Inc(P);
        Result := Copy(ADirList, I, P - I);
        if (Result <> '') and not IsDelimiter(DriveDelim + PathDelim, Result, Length(Result)) then
          Result := Result + PathDelim;
        Result := ExpandFileName(Result + FileName);
        if CheckFileExists(Result) then Exit;
        Inc(P);
      end;
    end;
    Result := '';
  end;

  function ExtractProgID(Request: TWebRequest; var ID: string): Boolean;
  var
    P: Integer;
  begin
    ID := Request.PathInfo;
    if (Length(ID) > 0) and (ID[1] = '/') then
      Delete(ID, 1, 1);
    P := Pos('/', ID);
    if P > 0 then
      Delete(ID, P, MaxInt);
    Result := False;
    if ID <> '' then
    begin
      if not Result and (ID[1] = '{') then
      begin
        Assert(False, 'Guids not supported');
      end;
      if not Result and (CompareText(ExtractFileExt(ID), '.js') <> 0) then
      begin
        Result := True;
      end;
    end;
  end;

  procedure StartWebApp(const AFileName: string);
{$IFDEF MSWINDOWS}
  var
    ProcessInfo: TProcessInformation;
    StartupInfo: TStartupInfo;
    TargetName: TFileName;
  begin
    begin
      FillChar(StartupInfo, SizeOf(StartupInfo), 0);
      StartupInfo.cb := SizeOf(StartupInfo);
      TargetName := AFileName;
      if not CreateProcess(nil, PChar(TargetName),
        nil, nil, False, 0, nil, nil, StartupInfo, ProcessInfo) then
        raise Exception.CreateFmt(sErrorExec, [TargetName, GetLastError])
      else
      try
        case WaitForInputIdle(ProcessInfo.hProcess, 2000) of
          0: ;
          WAIT_TIMEOUT:
            raise Exception.CreateFmt(sErrorExec, [TargetName, GetLastError]);
          WAIT_FAILED:
            raise Exception.CreateFmt(sErrorExec, [TargetName, GetLastError]);
        else
          Assert(False); // Unexpected value
        end
      finally
        { Always close the handles right away, since we don't use them }
        CloseHandle(ProcessInfo.hProcess);
        CloseHandle(ProcessInfo.hThread);
      end;
    end;
  end;
{$ENDIF}
{$IFDEF LINUX}
  const
    Token = sExecWaitToken;
    WaitSecs = 10;
  var
    ErrorCode: TErrorCode;
  begin
    if not ExecWaitForToken(AFileName, Token, WaitSecs, ErrorCode) then
      case ErrorCode of
        ecTimeout: raise Exception.CreateFmt(sErrorExecTimeout, [AFileName]);
        ecExecFail: raise Exception.CreateFmt(sErrorExecFail, [AFileName]);
        ecTokenMismatch: raise Exception.CreateFmt(sErrorExecUnexpected, [AFileName]);
      else
        Assert(False); // Unexpected value
      end;
  end;
{$ENDIF}

const
  MaxRetry = 1;
var
  FileDate: TDateTime;
  Response: TWebServerResponse;
  FileName: string;
  DefaultURL: string;
  ProgID: string;
  Port: Integer;
  ExeName: string;
  RetryCount: Integer;
  Connection: TRequestConnection;
begin
  Result := False;
  if (Request.PathInfo = '') or (Request.PathInfo = '/') then
  begin
    DefaultURL := GetTranslatedDefaultURL;
    if DefaultURL <> '' then
    begin
      Response := TWebServerResponse.Create(Request, ResponseInfo, FLog);
      with Response do
      try
        Response.SendRedirect(DefaultURL);
      finally
        Free;
      end;
      Result := True;
    end;
  end
  else
  begin
    Port := -1;
    if ExtractProgID(Request, ProgID) then
    begin
      ExeName := FindRegisteredWebApp(ProgID);
      Port := FRunningWebAppListener.GetPortOfFileName(ExeName);
      if (Port = -1) and FileExists(ExeName) then
      begin
        StartWebApp(ExeName);
        Port := FRunningWebAppListener.GetPortOfFileName(ExeName);
      end;
    end;
    RetryCount := 0;
    while Port > 0 do
    begin
      Connection := TRequestConnection.Create(Port);
      try
        if not Connection.Connect then
        begin
          FRunningWebAppListener.RemovePort(Port);
          if RetryCount < MaxRetry then
          begin
            Inc(RetryCount);
            if FileExists(ExeName) then
            begin
              StartWebApp(ExeName);
              Port := FRunningWebAppListener.GetPortOfFileName(ExeName);
              Continue;
            end;
          end;
        end
        else
        begin
          Response := TWebServerResponse.Create(Request, ResponseInfo, FLog);
          try
            Connection.Request(Request, Response, True);
            Result := True;
            break;
          finally
            Response.Free;
          end;
        end;
      finally
        Connection.Disconnect;
        Connection.Free;
      end;
    end;
    if Port <= 0 then
    begin
      FileName := SearchForFile(
        ExpandedSearchpath);
      if FileName <> '' then
      begin
        with TWebServerResponse.Create(Request, ResponseINfo, FLog) do
        try
          FileDate := LocalTimeToUTCTime(FileDateToDateTime(FileAge(FileName)));
          if (Request.IfModifiedSince > -1) and (FileDate <= Request.IfModifiedSince) then
          begin
            StatusCode := 304;
          end else
          begin
            LastModified := FileDate;
            ContentType := GetMIMEType(FileName);
            if not IsHeadMethod then
              ContentStream := TFileStream.Create(FileName, fmOpenRead or
                fmShareDenyWrite);
          end;
          SendResponse;
        finally
          Free;
        end;
        Result := True;
      end
    end;
  end;

  if not Result then URLNotFound(Request, ResponseInfo);
end;

procedure TCustomWebServer.URLNotFound(Request: TWebServerRequest; ResponseInfo: TIdHTTPResponseInfo );
var
  Response: TWebServerResponse;
begin
  Response := TWebServerResponse.Create(Request, ResponseInfo, FLog);
  with Response do
  try
    ContentType := 'text/html';
    StatusCode := 404;
    Content := sNotFound;
    SendResponse;
  finally
    Response.Free;
  end;
end;

procedure TCustomWebServer.HandleException(Request: TWebServerRequest; ResponseInfo: TIdHTTPResponseInfo);
var
  ExceptObj: Exception;
begin
  ExceptObj := Exception(ExceptObject);
  ServerError(Request, ResponseInfo, ExceptObj.Message);
end;

procedure TCustomWebServer.ExecuteHTTPRequest(Thread: TThread; RequestInfo: TIdHTTPRequestInfo; ResponseInfo: TIdHTTPResponseInfo);
var
  Request: TWebServerRequest;
begin
  Request :=
    TWebServerRequest.Create(FHTTPServer.Bindings[0].Port,
      // jmt.!!! ClientSocket.RemoteAddress,
      '',
      // jmt.!!! ClientSocket.RemoteHost
      '', RequestInfo, ResponseInfo, Thread);
  try
    try
      LogRequest(Request);
      FreeAndNil(ThreadRequestLogBuffer);
      DoFileAccess(Request, False{jmt.!!! ? IsHeader flag},  ResponseInfo);
    except
      HandleException(Request, ResponseInfo);
    end;
  finally
    Request.Free;
  end;
end;

procedure TCustomWebServer.ServerError(Request: TWebServerRequest; ResponseInfo: TIdHTTPResponseInfo;
  const ErrorMsg: string);
var
  Response: TWebServerResponse;
begin
  Response := TWebServerResponse.Create(Request, ResponseInfo, FLog);
  with Response do
  try
    ContentType := 'text/html';
    // StatusCode := 500;
    // 200 Let's browser display content
    StatusCode := 200;
    ReasonString := ErrorMsg;
    Content := Format(sInternalServerError, [ErrorMsg]);
    SendResponse;
  finally
    Response.Free;
  end;
end;

{ Utility functions }

function OffsetFromUTC: TDateTime;
{$IFDEF LINUX}
var
  T: TTime_T;
  TV: TTimeVal;
  UT: TUnixTime;
begin
  gettimeofday(TV, nil);
  T := TV.tv_sec;
  localtime_r(@T, UT);
  // __tm_gmtoff is the bias in seconds from the UTC to the current time.
  // so I multiply by -1 to compensate for this.
  Result := -1*(UT.__tm_gmtoff / 60 / 60 / 24);
end;
{$ENDIF}
{$IFDEF MSWINDOWS}
var
  iBias: Integer;
  tmez: TTimeZoneInformation;
begin
  // Copied from IdGlobal.pas
  case GetTimeZoneInformation(tmez) of
    TIME_ZONE_ID_INVALID:
      raise EFailedToRetreiveTimeZoneInfo.Create(sFailedTimeZoneInfo);
    TIME_ZONE_ID_UNKNOWN  :
       iBias := tmez.Bias;
    TIME_ZONE_ID_DAYLIGHT :
      iBias := tmez.Bias + tmez.DaylightBias;
    TIME_ZONE_ID_STANDARD :
      iBias := tmez.Bias + tmez.StandardBias;
    else
      raise EFailedToRetreiveTimeZoneInfo.Create(sFailedTimeZoneInfo);
  end;
  {We use ABS because EncodeTime will only accept positve values}
  Result := EncodeTime(Abs(iBias) div 60, Abs(iBias) mod 60, 0, 0);
end;
{$ENDIF}

function LocalTimeToUTCTime(DateTime: TDateTime): TDateTime;
begin
  Result := DateTime + OffsetFromUTC;
end;

function TCustomWebServer.GetPort: Integer;
begin
  Result := FHTTPServer.DefaultPort;
end;

procedure TCustomWebServer.SetPort(const Value: Integer);
begin
  FHTTPServer.DefaultPort := Value;
end;

function TCustomWebServer.GetActive: Boolean;
begin
  Result := FHTTPServer.Active;
end;

procedure TCustomWebServer.SetActive(const Value: Boolean);
begin
  try
    FHTTPServer.Active := Value;
    if Value = False then
      FHTTPServer.Bindings.Clear;
  except
    FHTTPServer.Active := False;
    FHTTPServer.Bindings.Clear;
    raise;
  end;
end;


{ TServerLog }

constructor TServerLog.Create(AServer: TCustomWebServer);
begin
  inherited Create;
  FWebServer := AServer;
end;

procedure TServerLog.DoOnLog(Transaction: TTransactionLogEntry; var Release: Boolean);
begin
  if Assigned(FWebServer.FOnLog) then FWebServer.FOnLog(Self, Transaction, Release);
end;

function ExpandEnvStrings(InString: string): string;
var
  DollarPos, EndEnvVarPos: Integer;
  OrigStr: string;
  Depth: Integer;  //depth is used to avoid infinite looping (only 1000 levels deep allowed)
{$IFDEF MSWINDOWS}
  P: array[0..4096] of char;
{$ENDIF}
{$IFDEF LINUX}
  ReplaceStr: string;
{$ENDIF}
begin
  Result := Instring;
  DollarPos := AnsiPos('$(', Result);
  EndEnvVarPos := AnsiPos(')', Result);
  Depth := 0;
  while (DollarPos <> 0) and (EndEnvVarPos > DollarPos) and (Depth < 1000) do
  begin
    if EndEnvVarPos > DollarPos then
    begin
      OrigStr := Copy(Result, DollarPos, EndEnvVarPos - DollarPos + 1);
{$IFDEF LINUX}
      ReplaceStr := Libc.getenv(PChar(Copy(Result, DollarPos + 2, EndEnvVarPos - DollarPos - 2)));
      Result := StringReplace(Result, OrigStr, ReplaceStr, [rfReplaceAll]);
{$ENDIF}
{$IFDEF MSWINDOWS}
      ExpandEnvironmentStrings(PChar('%' + Copy(Result, DollarPos + 2, EndEnvVarPos - DollarPos - 2) + '%'), P, SizeOf(P));
      Result := StringReplace(Result, OrigStr, P, [rfReplaceAll]);
{$ENDIF}
      DollarPos := AnsiPos('$(', Result);
      EndEnvVarPos := AnsiPos(')', Result);
      Inc(Depth);
    end;
  end;
end;

function TCustomWebServer.GetExpandedSearchPath: string;
begin
  if (FExpandedSearchPath = '') and (SearchPath <> '') then
    FExpandedSearchPath := ExpandEnvStrings(SearchPath);
  Result := FExpandedSearchPath;
end;

procedure TCustomWebServer.SetSearchPath(const Value: string);
begin
  FSearchPath := Value;
  FExpandedSearchPath := '';
end;

function GetBaseExePath: string;
var
  ModuleName: array[0..255] of Char;
begin
  GetModuleFileName(hInstance, ModuleName, sizeof(ModuleName));
  Result := ExtractFilePath(ModuleName);
end;

function GetRootDir: string;
var
  LongPath: string;
begin
  LongPath := GetBaseExePath;
  //---- remove trailing slash if present ----
  if IsPathDelimiter(LongPath, Length(LongPath)) then
    Delete(LongPath, Length(LongPath), 1);
  //---- remove last "bin" type dir to get product root dir ----
  Result := ExtractFilePath(LongPath);
  if Result = '' then Result := LongPath; // no subdir present (this is an outer dir)
  //---- remove trailing slash if present ----
  if IsPathDelimiter(Result, Length(Result)) then
    Delete(Result, Length(Result), 1);
end;

procedure InitializeRootDirVariable(const AMacro: string);
{$IFDEF MSWINDOWS}
var
  EnvVar: array[0..4096] of char;
begin
  if GetEnvironmentVariable(PChar(AMacro), EnvVar, Sizeof(EnvVar)) = 0 then
    SetEnvironmentVariable(PChar(AMacro), PChar(GetRootDir));
end;
{$ENDIF}
{$IFDEF LINUX}
begin
  if getenv('HOME') = nil then
    setenv('HOME', PChar(GetRootDir), True)
end;
{$ENDIF}

{ TServerIntercept }
{$IF gsIdVersion = '8.0.25'} // D6, K2 compatible
function TServerIntercept.Accept(
  ABinding: TIdSocketHandle): TIdConnectionIntercept;
begin
  Result := TConnectionIntercept.Create(nil);
end;
{$ELSE}
function TServerIntercept.Accept(
  AConnection: TComponent): TIdConnectionIntercept;
begin
  // jmt.!!! Free this later?
  Result := TConnectionIntercept.Create(nil);
end;
{$IFEND}

procedure TServerIntercept.Init;
begin
  // Do nothing.   Must implement (abstract).

end;

{ TConnectionIntercept }

constructor TConnectionIntercept.Create(AOwner: TComponent);
begin
  inherited;
{$IF gsIdVersion = '8.0.25'} // D6, K2 compatible
  FRecvHandling := False;
  FSendHandling := False;
{$IFEND}
end;

{$IF gsIdVersion = '8.0.25'} // D6, K2 compatible
procedure TConnectionIntercept.DataReceived(var ABuffer;
  const AByteCount: integer);
var
  I: Integer;
begin
  if ThreadRequestLogBuffer = nil then
    ThreadRequestLogBuffer := TRequestLogBuffer.Create;
  I := Length(ThreadRequestLogBuffer.FLogBuffer);
  SetLength(ThreadRequestLogBuffer.FLogBuffer, I + AByteCount);
  Move(ABuffer, ThreadRequestLogBuffer.FLogBuffer[I + 1], AByteCount);
end;
{$ELSE}
procedure TConnectionIntercept.Receive(ABuffer:
  TStream);
var
  I: Integer;
  Count: Integer;
begin
  Count := ABuffer.Size;
  if ThreadRequestLogBuffer = nil then
    ThreadRequestLogBuffer := TRequestLogBuffer.Create;
  I := Length(ThreadRequestLogBuffer.FLogBuffer);
  SetLength(ThreadRequestLogBuffer.FLogBuffer, I + Count);
  ABuffer.Read(ThreadRequestLogBuffer.FLogBuffer[I + 1], Count)
end;
{$IFEND}

{$IF gsIdVersion = '8.0.25'} // D6, K2 compatible
procedure TConnectionIntercept.DataSent(var ABuffer;
  const AByteCount: integer);
var
  I: Integer;
begin
  if ThreadResponse <> nil then
  begin
    I := Length(ThreadResponse.FLogBuffer);
    SetLength(ThreadResponse.FLogBuffer, I + AByteCount);
    Move(ABuffer, ThreadResponse.FLogBuffer[I + 1], AByteCount);
  end;
end;
{$ELSE}
procedure TConnectionIntercept.Send(ABuffer:
  TStream);
var
  I: Integer;
  Count: Integer;
begin
  if ThreadResponse <> nil then
  begin
    Count := ABuffer.Size;
    I := Length(ThreadResponse.FLogBuffer);
    SetLength(ThreadResponse.FLogBuffer, I + Count);
    ABuffer.Read(ThreadResponse.FLogBuffer[I + 1], Count);
  end;
end;
{$IFEND}

destructor TConnectionIntercept.Destroy;
begin
  // Testing
  inherited;
end;

end.
