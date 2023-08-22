{***************************************************************}
{                                                               }
{   Borland Delphi Visual Component Library                     }
{                                                               }
{   Copyright (c) 2000-2001 Borland Software Corporation        }
{                                                               }
{***************************************************************}
unit SvrLog;

interface

uses
{$IFDEF MSWINDOWS}
  Windows,
{$ENDIF}
  HTTPApp, Classes, SyncObjs, Messages,
  SvrConst;

const
  WM_LOGMESSAGE    = WM_USER + $100;

type

  TTransactionLogEntry = class;

  TWmLogMessage = record
    Msg: Cardinal;
    Unused0: Integer;
    Unused1: Longint;
    Result: Longint;
  end;

  TRequestTime = record
    ThreadID: Cardinal;
    StartTime: TDateTime;
  end;

  PRequestTime = ^TRequestTime;

  THTTPLogEvent =
    procedure (Sender: TObject; Transaction: TTransactionLogEntry;
      var Release: Boolean) of object;

  // jmt.!!! Where was this class
  TErrorEvent = class(TObject)
  end;

  TCustomServerLog = class(TObject)
  private
    FLock: TCriticalSection;
    FBuffer: TList;
    FHandle: HWND;
    FOnLog: THTTPLogEvent;
    FRequestTimes: array of TRequestTime;
    function GetLogEntry: TTransactionLogEntry;
    procedure LogTransaction(Transaction: TTransactionLogEntry);
    procedure WMLogMessage(var Msg: TWMLogMessage); message WM_LOGMESSAGE;
    procedure WndProc(var Message: TMessage);
    procedure SetRequestTime(AThreadID: Cardinal; AStartTime: TDateTime);
    function GetRequestTime(AThreadID: Cardinal): TDateTime;
    function FindRequestTime(AThreadID: Cardinal): PRequestTime;
    procedure WriteLog;
 protected
    procedure DoOnLog(Transaction: TTransactionLogEntry; var Release: Boolean); virtual;
  public
    constructor Create;
    destructor Destroy; override;
    procedure DefaultHandler(var Message); override;
    procedure LogError(AThread: TThread; AErrorEvent: TErrorEvent; AErrorCode: Integer;
      const AErrorMsg: string);
    procedure LogRequest(ARequest: TWebRequest; const ABuffer: string);
    procedure LogResponse(AResponse: TWebResponse; const Buffer: string);
    property RequestTime[AThreadID: Cardinal]: TDateTime read GetRequestTime write SetRequestTime;
  end;

  { TTransactionLogEntry }

  TLogColumn = (lcEvent, lcTime, lcDate, lcElapsed, lcPath, lcStatus, lcContentLength, lcContentType,
    lcThreadID);

  TTransactionLogEntry = class(TObject)
  private
  protected
    FEventName: string;
    FDateTime: TDateTime;
    FElapsedTime: TDateTime;
    FThreadID: Cardinal;
    function GetLogString: string; virtual; abstract;
    function GetColumn(I: TLogColumn): string; virtual;
  public
    constructor Create;
    property LogString: string read GetLogString;
    property ElapsedTime: TDateTime read FElapsedTime;
    property Columns[I: TLogColumn]: string read GetColumn;
  end;

  THTTPTransaction = class(TTransactionLogEntry)
  protected
    FContentLength: Integer;
    FContentType: string;
    FBuffer: string;
    function GetColumn(I: TLogColumn): string; override;
    function GetLogString: string; override;
  public
  end;

  { TRequestTransaction }
  TRequestTransaction = class(THTTPTransaction)
  private
    FPath: string;
  protected
    function GetColumn(I: TLogColumn): string; override;
  public
    constructor Create(ARequest: TWebRequest; const ABuffer: string);
  end;

  { TResponseTransaction }
  TResponseTransaction = class(THTTPTransaction)
  private
    FStatus: string;
    FFirstLine: string;
    procedure ParseBuffer(AParser: TObject);
  protected
    function GetColumn(I: TLogColumn): string; override;
  public
    constructor Create(const Buffer: string);
    destructor Destroy; override;
  end;

  { TErrorTransaction }

  TErrorTransaction = class(TTransactionLogEntry)
  private
    FErrorEvent: TErrorEvent;
    FErrorMsg: string;
    FErrorCode: Integer;
  public
    constructor Create(AErrorEvent: TErrorEvent; AErrorCode: Integer;
      const AErrorMsg: string);
    function GetLogString: string; override;
    property ErrorType: TErrorEvent read FErrorEvent;
    property ErrorMsg: string read FErrorMsg;
    property ErrorCode: Integer read FErrorCode;
  end;


implementation

uses SysUtils, Forms, SvrHTTPIndy, HTTPParse, IdHTTPServer;

{ TTransactionLogEntry }

constructor TTransactionLogEntry.Create;
begin
  inherited Create;
  FDateTime := Now;
{$IFDEF MSWINDOWS}
  FThreadID := GetCurrentThreadID;
{$ENDIF}
end;

function TTransactionLogEntry.GetColumn(I: TLogColumn): string;
begin
  case I of
    lcEvent: Result := FEventName;
    lcTime: Result := FormatDateTime('hh:mm:ss:zzz', FDateTime); { do not localize }
    lcDate: Result := DateToStr(FDateTime);
    lcThreadID: Result := IntToStr(FThreadID);
  else
    Result := '';
  end;
end;

{ TErrorTransaction }

constructor TErrorTransaction.Create(AErrorEvent: TErrorEvent; AErrorCode: Integer;
  const AErrorMsg: string);
begin
  inherited Create;
  FEventName := sErrorEvent;
  FErrorEvent := AErrorEvent;
  FErrorMsg := AErrorMsg;
  FErrorCode := AErrorCode;
end;

function TErrorTransaction.GetLogString: string;
begin
{$IFDEF MSWINDOWS}
  // jmt.!!! case FErrorEvent of
  // jmt.!!!   eeSend:  Result := sSend;
  // jmt.!!!   eeReceive: Result := sReceive;
  // jmt.!!! end;
{$ENDIF}
  Result := Format(sLogStrTemplate, [
    FormatDateTime(DateFormat, FDateTime), Result, FErrorCode, FErrorMsg]);
end;

{ TCustomServerLog }

constructor TCustomServerLog.Create;
begin
  inherited Create;
  FHandle := Classes.AllocateHWnd(WndProc);
  FBuffer := TList.Create;
  FLock := TCriticalSection.Create;
end;

destructor TCustomServerLog.Destroy;
begin
//  ClearLog;
  FBuffer.Free;
  FLock.Free;
  if FHandle <> 0 then Classes.DeAllocateHWnd(FHandle);
  inherited Destroy;
end;

procedure TCustomServerLog.WriteLog;
var
  Transaction: TTransactionLogEntry;
  Release: Boolean;
begin
  FLock.Enter;
  try
  Transaction := GetLogEntry;
  while Transaction <> nil do
  begin
    try
      Release := True;
      DoOnLog(Transaction, Release);
    finally
      if Release then
        Transaction.Free;
    end;
    Transaction := GetLogEntry;
  end;
  finally
    FLock.Leave;
  end;
end;

procedure TCustomServerLog.LogTransaction(Transaction: TTransactionLogEntry);
var
  T: TDateTime;
begin
  FLock.Enter;
  try
    if Transaction is TRequestTransaction then
      RequestTime[Transaction.FThreadID] := Transaction.FDateTime
    else
    begin
      T := RequestTime[Transaction.FThreadID];
      if T <> 0 then
        Transaction.FElapsedTime := Transaction.FDateTime - T;
    end;
    FBuffer.Add(Transaction);
    PostMessage(FHandle, WM_LOGMESSAGE, 0, 0);
  finally
    FLock.Leave;
  end;
end;

procedure TCustomServerLog.LogError(AThread: TThread; AErrorEvent: TErrorEvent;
  AErrorCode: Integer; const AErrorMsg: string);
begin
  LogTransaction(TErrorTransaction.Create(AErrorEvent, AErrorCode, AErrorMsg));
end;


function TCustomServerLog.GetLogEntry: TTransactionLogEntry;
begin
  FLock.Enter;
  try
    if FBuffer.Count > 0 then
    begin
      Result := TTransactionLogEntry(FBuffer.First);
      FBuffer.Delete(0);
    end else Result := nil;
  finally
    FLock.Leave;
  end;
end;

procedure TCustomServerLog.WMLogMessage(var Msg: TWMLogMessage);
var
  Transaction: TTransactionLogEntry;
  Release: Boolean;
begin
  Transaction := GetLogEntry;
  while Transaction <> nil do
  begin
    try
      Release := True;
      DoOnLog(Transaction, Release);
    finally
      if Release then
        Transaction.Free;
    end;
    Transaction := GetLogEntry;
  end;
end;

procedure TCustomServerLog.DoOnLog(Transaction: TTransactionLogEntry;
  var Release: Boolean);
begin
  if Assigned(FOnLog) then FOnLog(Self, Transaction, Release);
end;

procedure TCustomServerLog.WndProc(var Message: TMessage);
begin
  try
    Dispatch(Message);
  except
    Application.HandleException(Self);
  end;
end;

procedure TCustomServerLog.DefaultHandler(var Message);
begin
  with TMessage(Message) do
    Result := DefWindowProc(FHandle, Msg, WParam, LParam);
end;

procedure TCustomServerLog.LogRequest(ARequest: TWebRequest; const ABuffer: string);
begin
  LogTransaction(TRequestTransaction.Create(ARequest, ABuffer));
end;

procedure TCustomServerLog.LogResponse(AResponse: TWebResponse; const Buffer: string);
begin
  LogTransaction(TResponseTransaction.Create(Buffer));
end;

function TCustomServerLog.GetRequestTime(AThreadID: Cardinal): TDateTime;
var
  P: PRequestTime;
begin
  P := FindRequestTime(AThreadID);
  if Assigned(P) then
    Result := P.StartTime
  else
    Result := 0;
end;

function TCustomServerLog.FindRequestTime(AThreadID: Cardinal): PRequestTime;
var
  I: Integer;
begin
  for I := Low(FRequestTimes) to High(FRequestTimes) do
  begin
    Result := @FRequestTimes[I];
    if Result.ThreadID = AThreadID then Exit;
  end;
  Result := nil;
end;

procedure TCustomServerLog.SetRequestTime(AThreadID: Cardinal;
  AStartTime: TDateTime);
var
  P: PRequestTime;
begin
  P := FindRequestTime(AThreadID);
  if Assigned(P) then
    P.StartTime := AStartTime
  else
  begin
    SetLength(FRequestTimes, Length(FRequestTimes) + 1);
    with FRequestTimes[High(FRequestTimes)] do
    begin
      StartTime := AStartTime;
      ThreadID := AThreadID;
    end;
  end;
end;

{ TRequestTransaction }

const
  CGIServerVariables: array[0..28] of string = (
    'REQUEST_METHOD',
    'SERVER_PROTOCOL',
    'URL',
    'QUERY_STRING',
    'PATH_INFO',
    'PATH_TRANSLATED',
    'HTTP_CACHE_CONTROL',
    'HTTP_DATE',
    'HTTP_ACCEPT',
    'HTTP_FROM',
    'HTTP_HOST',
    'HTTP_IF_MODIFIED_SINCE',
    'HTTP_REFERER',
    'HTTP_USER_AGENT',
    'HTTP_CONTENT_ENCODING',
    'HTTP_CONTENT_TYPE',
    'HTTP_CONTENT_LENGTH',
    'HTTP_CONTENT_VERSION',
    'HTTP_DERIVED_FROM',
    'HTTP_EXPIRES',
    'HTTP_TITLE',
    'REMOTE_ADDR',
    'REMOTE_HOST',
    'SCRIPT_NAME',
    'SERVER_PORT',
    '',
    'HTTP_CONNECTION',
    'HTTP_COOKIE',
    'HTTP_AUTHORIZATION');

constructor TRequestTransaction.Create(ARequest: TWebRequest; const ABuffer: string);
begin
  inherited Create;
  FDateTime := Now;
  FEventName := ARequest.Method;
  FPath := ARequest.PathInfo;
  FContentLength := ARequest.ContentLength;
  FContentType := ARequest.ContentType;
  FBuffer := ABuffer;;
end;

function TRequestTransaction.GetColumn(I: TLogColumn): string;
begin
  case I of
    lcPath: Result := FPath;
  else
    Result := inherited GetColumn(I);
  end;
end;

{ TResponseTransaction }

constructor TResponseTransaction.Create(const Buffer: string);
var
  S: TStream;
  HTTPParser: THTTPParser;
  P: Integer;
begin
  inherited Create;
  FEventName := sResponseEvent;
  FBuffer := Buffer;

  S := TStringStream.Create(FBuffer);
  try
    HTTPParser := THTTPParser.Create(S);
    try
      ParseBuffer(HTTPParser);
    finally
      HTTPParser.Free;
    end;
  finally
    S.Free;
  end;
  P := Pos(' ', FFirstLine);
  if P > 0 then
    FStatus := Copy(FFirstLine, P+1, MaxInt);
end;

destructor TResponseTransaction.Destroy;
begin
  inherited;
end;

procedure TResponseTransaction.ParseBuffer(AParser: TObject);
var
  Parser: THTTPParser;

  procedure SkipLine;
  begin
    Parser.CopyToEOL;
    Parser.SkipEOL;
  end;

  procedure ParseContentType;
  begin
    with Parser do
    begin
      NextToken;
      if Token = ':' then NextToken;
      if Self.FContentType = '' then
        Self.FContentType := TrimLeft(CopyToEOL)
      else CopyToEOL;
      NextToken;
    end;
  end;

  procedure ParseContentLen;
  begin
    with Parser do
    begin
      NextToken;
      if Token = ':' then NextToken;
      if Token = toInteger then Self.FContentLength := TokenInt;
      CopyToEol;
      NextToken;
    end;
  end;

begin
  Parser := AParser as THTTPParser;
  FFirstLine := Parser.CopyToEol;
  Parser.SkipEol;
  while Parser.Token <> toEOF do with Parser do
  begin
    case Token of
      toContentType: ParseContentType;
      toContentLength: ParseContentLen;
      toEOL: Break; // At content
    else
      SkipLine;
    end;
  end;
end;

function TResponseTransaction.GetColumn(I: TLogColumn): string;
begin
  case I of
    lcElapsed: DateTimeToString(Result, 'hh:mm:ss:zzz', FElapsedTime); { do not localize }
    lcStatus: Result := FStatus;
  else
    Result := inherited GetColumn(I);
  end;
end;

{ THTTPTransaction }

function THTTPTransaction.GetColumn(I: TLogColumn): string;
begin
  case I of
    lcContentLength: Result := IntToStr(FContentLength);
    lcContentType: Result := FContentType;
  else
    Result := inherited GetColumn(I);
  end;
end;

function THTTPTransaction.GetLogString: string;
begin
  Result := FBuffer;
end;

end.
