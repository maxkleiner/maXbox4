{*******************************************************}
{                                                       }
{       CodeGear Delphi Visual Component Library        }
{                                                       }
{  	    Copyright (c) 1995-2007 CodeGear	        }
{                                                       }
{*******************************************************}
unit HTTPUtil;

interface

uses Types, Classes;

type

  { Java-style StringTokenizer }
  IStringTokenizer = interface
  ['{8C216E9D-984E-4E38-893F-0A222AC547DA}']
    function getTokenCounts: integer;
    function hasMoreTokens: boolean;
    function nextToken: WideString;
    property countTokens: integer read getTokenCounts;
  end;

  IStreamLoader = interface
  ['{395CDFB2-1D10-4A37-AC16-393D569676F0}']
    procedure Load(const WSDLFileName: WideString; Stream: TMemoryStream);

    function  GetProxy: string;
    procedure SetProxy(const Proxy: string);
    function  GetUserName: string;
    procedure SetUserName(const UserName: string);
    function  GetPassword: string;
    procedure SetPassword(const Password: string);
    function  GetTimeout: Integer;
    procedure SetTimeout(ATimeOut: Integer);

    property  Proxy:    string read GetProxy    write SetProxy;
    property  UserName: string read GetUserName write SetUserName;
    property  Password: string read GetPassword write SetPassword;
    property  Timeout:  integer read GetTimeOut write SetTimeOut;
  end;

function StartsWith(const str: string; const sub: string): Boolean;
function FirstDelimiter(const delimiters: string; const Str: String): integer; overload;
function FirstDelimiter(const delimiters: WideString; const Str: WideString): integer; overload;
function StringTokenizer(const str: string; const delim: string): IStringTokenizer;
function StringToStringArray(const str: string; const delim: string): TStringDynArray;
function HTMLEscape(const Str: string): string;

function GetDefaultStreamLoader: IStreamLoader;

implementation

uses SysUtils, SOAPHTTPTrans;

type

  TStreamLoader = class(TInterfacedObject, IStreamLoader)
  private
    FHTTPReqResp: IHTTPReqResp;
    FProxy: string;
    FUserName: string;
    FPassword: string;
    FTimeOut: Integer;

  public
    procedure   Load(const WSDLFileName: WideString; Stream: TMemoryStream);
    constructor Create;
    destructor  Destroy; override;

    function    GetProxy: string;
    procedure   SetProxy(const Proxy: string);
    function    GetUserName: string;
    procedure   SetUserName(const UserName: string);
    function    GetPassword: string;
    procedure   SetPassword(const Password: string);
    function    GetTimeout: Integer;
    procedure   SetTimeout(ATimeOut: Integer);
  end;

constructor TStreamLoader.Create;
begin
  inherited Create;
  FHTTPReqResp := THTTPReqResp.Create(nil);
end;

destructor TStreamLoader.Destroy;
begin
  inherited Destroy;
end;

procedure TStreamLoader.Load(const WSDLFileName: WideString; Stream: TMemoryStream);
  procedure LoadFromURL(URL: string; Stream: TStream);
  begin
    { Load HTTPReqResp with parameters of request }
    FHTTPReqResp.GetHTTPReqResp.URL := URL;
    FHTTPReqResp.GetHTTPReqResp.UserName := FUserName;
    FHTTPReqResp.GetHTTPReqResp.Password := FPassword;
    FHTTPReqResp.GetHTTPReqResp.Proxy := FProxy;

    { Timeouts }
    if FTimeOut <> 0 then
    begin
      FHTTPReqResp.GetHTTPReqResp.ConnectTimeout := FTimeOut;
      FHTTPReqResp.GetHTTPReqResp.SendTimeout := FTimeOut;
      FHTTPReqResp.GetHTTPReqResp.ReceiveTimeout := FTimeOut;
    end;

    FHTTPReqResp.GetHTTPReqResp.Get(Stream);
  end;

  function isHTTP(const Name: WideString): boolean;
  const
    sHTTPPrefix = 'http://';
    sHTTPsPrefix= 'https://';
  begin
    Result := SameText(Copy(Name, 1, Length(sHTTPPrefix)), sHTTPPrefix) or
              SameText(Copy(Name, 1, Length(sHTTPsPrefix)),sHTTPsPrefix);
  end;

var
  FileName: string;
begin
  FileName := Trim(WSDLFileName);
  if isHTTP(FileName) then
    LoadFromURL(FileName, Stream)
  else
    Stream.LoadFromFile(FileName);
end;

function  TStreamLoader.GetProxy: string;
begin
  Result := FProxy;
end;

procedure TStreamLoader.SetProxy(const Proxy: string);
begin
  FProxy := Proxy;
end;

function  TStreamLoader.GetUserName: string;
begin
  Result := FUserName;
end;

procedure TStreamLoader.SetUserName(const UserName: string);
begin
  FUserName := UserName;
end;

function  TStreamLoader.GetPassword: string;
begin
  Result := FPassword;
end;

procedure TStreamLoader.SetPassword(const Password: string);
begin
  FPassword := Password;
end;

function GetDefaultStreamLoader: IStreamLoader;
begin
  Result := TStreamLoader.Create;
end;

function StartsWith(const str: string; const sub: string): Boolean;
begin
  Result := (Length(str) >= Length(sub)) and (Copy(str, 1, Length(sub)) = sub);
end;

type

  TStringTokenizer = class(TInterfacedObject, IStringTokenizer)
    FString: WideString;
    FDelim: WideString;
    FCurPos: integer;
  public
    constructor Create(const str: WideString; delim: WideString);
    function getTokenCounts: integer;
    function hasMoreTokens: boolean;
    function nextToken: WideString;
    property countTokens: integer read getTokenCounts;
  end;

function _IndexOf(const ch: Char; const Str: String): integer; overload;
var
  I: integer;
begin
  Result := 0;
  I := 1;
  while I <= Length(Str) do
  begin
    if Str[I] = ch then
    begin
      Result := I;
      Exit;
    end;
    Inc(I);
  end;
end;

function _IndexOf(const ch: WideChar; const Str: WideString): integer; overload;
var
  I: integer;
begin
  Result := 0;
  I := 1;
  while I <= Length(Str) do
  begin
    if Str[I] = ch then
    begin
      Result := I;
      Exit;
    end;
    Inc(I);
  end;
end;

function FirstDelimiter(const delimiters: string; const Str: String): integer;
var
  I: Integer;
begin
  Result := 0;
  I := 1;
  while I <= Length(Str) do
  begin
    if Str[I] in LeadBytes then
      Inc(I)
    else if _IndexOf(Str[I], delimiters) > 0 then
    begin
      Result := I;
      Exit;
    end;
    Inc(I);
  end;
end;

function FirstDelimiter(const delimiters: WideString; const Str: WideString): integer;
var
  I: Integer;
begin
  Result := 0;
  I := 1;
  while I <= Length(Str) do
  begin
    if _IndexOf(Str[I], delimiters) > 0 then
    begin
      Result := I;
      Exit;
    end;
    Inc(I);
  end;
end;

function StringTokenizer(const str: string; const delim: string): IStringTokenizer;
begin
  Result := TStringTokenizer.Create(str, delim);
end;

constructor TStringTokenizer.Create(const str: WideString; delim: WideString);
begin
  FString := str;
  FDelim  := delim;
  FCurPos := 1;
  { Point FCurPos to beginning of next Token }
  while (FCurPos <= Length(FString)) and (_IndexOf(FString[FCurPos], FDelim) > 0) do
    Inc(FCurPos);
end;

function TStringTokenizer.getTokenCounts: integer;
var
  I: integer;
  Cnt: integer;
begin
  Cnt := 0;
  I := 1;
  while I <= Length(FString) do
  begin
    while (I <= Length(FString)) and (_IndexOf(FString[I], FDelim) > 0) do
      Inc(I);
    if I <= Length(FString) then
      Inc(Cnt);
    while (I <= Length(FString)) and (_IndexOf(FString[I], FDelim) = 0) do
      Inc(I);
  end;
  Result := Cnt;
end;

function TStringTokenizer.hasMoreTokens: boolean;
begin
  Result := FCurPos < Length(FString);
end;


function TStringTokenizer.nextToken: WideString;
var
  endPos: integer;
begin
  if FCurPos > Length(FString) then
  begin
    Result := '';
    Exit;
  end;
  endPos := FCurPos;
  while (endPos <= Length(FString)) and (_IndexOf(FString[endPos], FDelim) = 0) do
    Inc(endPos);
  Result := Copy(FString, FCurPos, endPos-FCurPos);
  { Point FCurPos to beginning of next Token }
  FCurPos := endPos;
  while (FCurPos <= Length(FString)) and (_IndexOf(FString[FCurPos], FDelim) > 0) do
    Inc(FCurPos);
end;

function StringToStringArray(const str: string; const delim: string): TStringDynArray;
var
  StrTok: IStringTokenizer;
  Count, I: integer;
begin
  if str = '' then
  begin
    Result := nil;
    Exit;
  end;
  StrTok := StringTokenizer(str, delim);
  Count := StrTok.countTokens;
  SetLength(Result, Count);
  I := 0;
  while StrTok.hasMoreTokens do
  begin
    Result[I] := StrTok.nextToken;
    Inc(I);
  end;
end;

function HTMLEscape(const Str: string): string;
var
  i, l : integer;
begin
  l := Length(Str);
  Result := '';
  for i := 1 to l do
  begin
    case Str[i]  of
    '<' : Result := Result + '&lt;';    { Do not localize }
    '>' : Result := Result + '&gt;';    { Do not localize }
    '&' : Result := Result + '&amp;';   { Do not localize }
    '"' : Result := Result + '&quot;';  { Do not localize }
    #92, #160 .. #255 : Result := Result + '&#' + IntToStr(Ord(Str[ i ])) +';';  { Do not localize }
    else
      Result := Result + Str[i];
    end;
  end;
end;

function TStreamLoader.GetTimeout: Integer;
begin
  Result := FTimeOut;
end;

procedure TStreamLoader.SetTimeout(ATimeOut: Integer);
begin
  FTimeOut := ATimeOut;
end;

end.
