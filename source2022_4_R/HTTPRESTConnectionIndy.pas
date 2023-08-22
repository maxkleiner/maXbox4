unit HttpRESTConnectionIndy;

interface

uses IdHTTP, {HttpConnection,} Classes, {RestUtils, IdCompressorZLib,} SysUtils,
     IdSSLOpenSSL;


const
  MediaType_Json = 'application/json';
  MediaType_Xml = 'text/xml';

  LOCALE_PORTUGUESE_BRAZILIAN = 'pt-BR';
  LOCALE_US = 'en-US';


type
  TReponseCode = record
    StatusCode: Integer;
    Reason: string;
  end;

  THttpConnectionType = (hctUnknown, hctIndy, hctWinHttp, hctWinInet, hctCustom);

  TStatusCode = class
  public
    (* 200 OK, see {@link <a href="http://www.w3.org/Protocols/rfc2616/rfc2616-sec10.html#sec10.2.1">HTTP/1.1 documentation</a>}.*)
    class function OK(): TReponseCode;

    (* 201 Created, see {@link <a href="http://www.w3.org/Protocols/rfc2616/rfc2616-sec10.html#sec10.2.2">HTTP/1.1 documentation</a>}. *)
    class function CREATED(): TReponseCode;

    (* 202 Accepted, see {@l ink <a href="http://www.w3.org/Protocols/rfc2616/rfc2616-sec10.html#sec10.2.3">HTTP/1.1 documentation</a>}.*)
    class function ACCEPTED: TReponseCode;

    (* 204 No Content, see {@link <a href="http://www.w3.org/Protocols/rfc2616/rfc2616-sec10.html#sec10.2.5">HTTP/1.1 documentation</a>}. *)
    class function NO_CONTENT: TReponseCode;

    (* 404 Not Found, see {@link <a href="http://www.w3.org/Protocols/rfc2616/rfc2616-sec10.html#sec10.4.5">HTTP/1.1 documentation</a>}*)
    class function NOT_FOUND: TReponseCode;
  end;

       

type
  {TIdHTTP = class(idHTTP.TIdHTTP)
  public
    procedure Delete(AURL: string);
  end;}


  EHTTPError = class(Exception)
    private
      FErrorCode: integer;
      FErrorMessage: string;
    public
      constructor Create(const AMsg, AErrorMessage: string; const AErrorCode: integer); overload; virtual;
      property ErrorMessage: string read FErrorMessage;
      property ErrorCode: integer read FErrorCode;
  end;

  IHttpConnection = interface
  ['{B9611100-5243-4874-A777-D91448517116}']
    function SetAcceptTypes(AAcceptTypes: string): IHttpConnection;
    function SetContentTypes(AContentTypes: string): IHttpConnection;
    function SetAcceptedLanguages(AAcceptedLanguages: string): IHttpConnection;
    function SetHeaders(AHeaders: TStrings): IHttpConnection;

    procedure Get(AUrl: string; AResponse: TStream);
    procedure Post(AUrl: string; AContent, AResponse: TStream);
    procedure Put(AUrl: string; AContent, AResponse: TStream);
    procedure Delete(AUrl: string; AContent: TStream);

    function GetResponseCode: Integer;
    function GetEnabledCompression: Boolean;

    procedure SetEnabledCompression(const Value: Boolean);

    property ResponseCode: Integer read GetResponseCode;
    property EnabledCompression: Boolean read GetEnabledCompression write SetEnabledCompression;
  end;

  THttpConnectionIndy = class(TInterfacedObject, IHttpConnection)
  private
    FIdHttp: TIdHTTP;
    //FIdSSL: TIdSSLIOHandlerSocketOpenSSL;
    FIdSSL: TIdSSLIOHandlerSocket;
    //FIdSSL: TIdSSLOpenSSL;

    FEnabledCompression: Boolean;
  public
    constructor Create;
    destructor Destroy; override;

    function SetAcceptTypes(AAcceptTypes: string): IHttpConnection;
    function SetAcceptedLanguages(AAcceptedLanguages: string): IHttpConnection;
    function SetContentTypes(AContentTypes: string): IHttpConnection;
    function SetHeaders(AHeaders: TStrings): IHttpConnection;

    procedure Get(AUrl: string; AResponse: TStream);
    procedure Post(AUrl: string; AContent: TStream; AResponse: TStream);
    procedure Put(AUrl: string; AContent: TStream; AResponse: TStream);
    procedure Delete(AUrl: string; AContent: TStream);

    function GetResponseCode: Integer;

    function GetEnabledCompression: Boolean;
    procedure SetEnabledCompression(const Value: Boolean);
  end;

  procedure TIdHTTP_Delete(AURL: string; atid: TIdHTTP);


implementation

{ THttpConnectionIndy }

constructor THttpConnectionIndy.Create;
begin
  FIdSSL := TIdSSLIOHandlerSocket.Create(nil);
  FIdHttp := TIdHTTP.Create(nil);
  FIdHttp.IOHandler := FIdSSL;
  FIdHttp.HandleRedirects := True;
  FIdHttp.Request.CustomHeaders.FoldLines := false;
end;

procedure THttpConnectionIndy.Delete(AUrl: string; AContent: TStream);
begin
  FIdHttp.Request.Source := AContent;

  //FIdHttp.Delete(AUrl);
  TIdHTTP_Delete(AUrl, FidHttp);
end;

destructor THttpConnectionIndy.Destroy;
begin
  FIdHttp.Free;
  FIdSSL.Free;
  inherited;
end;

procedure THttpConnectionIndy.Get(AUrl: string; AResponse: TStream);
begin
  try
    FIdHttp.Get(AUrl, AResponse);
  except
    on E: EIdHTTPProtocolException do
      raise EHTTPError.Create(e.Message, e.ErrorMessage, 4); //e.errorcode
  end;
end;

function THttpConnectionIndy.GetEnabledCompression: Boolean;
begin
  Result := FEnabledCompression;
end;

function THttpConnectionIndy.GetResponseCode: Integer;
begin
  Result := FIdHttp.ResponseCode;
end;

procedure THttpConnectionIndy.Post(AUrl: string; AContent, AResponse: TStream);
begin
  try
    FIdHttp.Post(AUrl, AContent, AResponse);
  except
    on E: EIdHTTPProtocolException do
      raise EHTTPError.Create(e.Message, e.ErrorMessage, 5);
  end;
end;

procedure THttpConnectionIndy.Put(AUrl: string; AContent, AResponse: TStream);
begin
  try
    FIdHttp.Put(AUrl, AContent, AResponse);
  except
    on E: EIdHTTPProtocolException do
      raise EHTTPError.Create(e.Message, e.ErrorMessage, 6);
  end;
end;

function THttpConnectionIndy.SetAcceptedLanguages(AAcceptedLanguages: string): IHttpConnection;
begin
  FIdHttp.Request.AcceptLanguage := AAcceptedLanguages;
  Result := Self;
end;

function THttpConnectionIndy.SetAcceptTypes(AAcceptTypes: string): IHttpConnection;
begin
  FIdHttp.Request.Accept := AAcceptTypes;
  Result := Self;
end;

function THttpConnectionIndy.SetContentTypes(AContentTypes: string): IHttpConnection;
begin
  FIdHttp.Request.ContentType := AContentTypes;
  Result := Self;
end;

procedure THttpConnectionIndy.SetEnabledCompression(const Value: Boolean);
begin
  if (FEnabledCompression <> Value) then begin
    FEnabledCompression := Value;

    if FEnabledCompression then begin
      {$IFDEF DELPHI_XE2}
        {$Message Warn 'TIdCompressorZLib does not work properly in Delphi XE2. Access violation occurs.'}
      {$ENDIF}
      //FIdHttp.Compressor := TIdCompressorZLib.Create(FIdHttp);
    end
    else
    begin
      //FIdHttp.Compressor.Free;
      //FIdHttp.Compressor := nil;
    end;
  end;
end;

function THttpConnectionIndy.SetHeaders(AHeaders: TStrings): IHttpConnection;
begin
  FIdHttp.Request.CustomHeaders.Clear;
  FIdHttp.Request.CustomHeaders.AddStrings(AHeaders);
  Result := Self;
end;

{ TIdHTTP }

procedure TIdHTTP_Delete(AURL: string; atid: TIdHTTP);
begin
  try
    //DoRequest(Id_HTTPMethodDelete, AURL, Request.Source, nil, []);
    atid.DoRequest(hmDelete, AURL, atid.Request.Source, nil);
  except
    on E: EIdHTTPProtocolException do
      raise EHTTPError.Create(e.Message, e.ErrorMessage, 7);
  end;
end;


{ THttpError }

constructor EHTTPError.Create(const AMsg, AErrorMessage: string; const AErrorCode: integer);
begin
  inherited Create(AMsg);
  FErrorMessage := AErrorMessage;
  FErrorCode := AErrorCode;
end;



{ TStatusCode }

class function TStatusCode.ACCEPTED: TReponseCode;
begin
  Result.StatusCode := 202;
  Result.Reason := 'Accepted';
end;

class function TStatusCode.Created: TReponseCode;
begin
  Result.StatusCode := 201;
  Result.Reason := 'Created';
end;

class function TStatusCode.NOT_FOUND: TReponseCode;
begin
  Result.StatusCode := 404;
  Result.Reason := 'Not Found';
end;

class function TStatusCode.NO_CONTENT: TReponseCode;
begin
  Result.StatusCode := 204;
  Result.Reason := 'No Content';
end;

class function TStatusCode.OK: TReponseCode;
begin
  Result.StatusCode := 200;
  Result.Reason := 'OK';
end;

end.

//----code_cleared_checked_clean----