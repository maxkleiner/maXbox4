unit WinApiDownload;

interface
uses Windows, WinInet, SysUtils, Classes;

type
  TEventWorkStart = procedure (Sender : TObject; iFileSize : Int64) of object;
  TEventWork = procedure (Sender : TObject; iBytesTransfered : Int64) of object;
  TEventWorkEnd = procedure (Sender : TObject; iBytesTransfered : Int64;
                             ErrorCode : Integer) of object;
  TEventError = procedure (Sender : TObject; iErrorCode : Integer;
                           sURL : string) of object;

  TWinApiDownload = class(TObject)
    private
      fEventWorkStart : TEventWorkStart;
      fEventWork : TEventWork;
      fEventWorkEnd : TEventWorkEnd;
      fEventError : TEventError;
      fURL : string;
      fUserAgent : string;
      fStop : Boolean;
      fActive : Boolean;
      fCachingEnabled : Boolean;
      fProgressUpdateInterval : Cardinal;
      function GetIsActive : Boolean;
    public
      constructor Create;
      destructor Destroy; override;
      function CheckURL(aURL: string) : Integer;
      function Download(Stream : TStream) : Integer; overload;
      function Download(var res : string) : Integer; overload;
      function ErrorCodeToMessageString(aErrorCode : Integer) : string;
      procedure Stop;
      procedure Clear;
      property UserAgent : string read fUserAgent write fUserAgent;
      property URL : string read fURL write fURL;
      property DownloadActive : Boolean read GetIsActive;
      property CachingEnabled : Boolean read fCachingEnabled write fCachingEnabled;
      property UpdateInterval : Cardinal read fProgressUpdateInterval write fProgressUpdateInterval;
      property OnWorkStart : TEventWorkStart read fEventWorkStart write fEventWorkStart;
      property OnWork : TEventWork read fEventWork write fEventWork;
      property OnWorkEnd : TEventWorkEnd read fEventWorkEnd write fEventWorkEnd;
      property OnError : TEventError read fEventError write fEventError;
  end;

const
  DOWNLOAD_ERROR_UNKNOWN = -1;
  DOWNLOAD_ABORTED_BY_USER = -2;
  DOWNLOAD_ERROR_INCOMPLETE_READ = -3;
  DOWNLOAD_ERROR_DATA_READ = -4;
  DOWNLOAD_ERROR_EMPTY_URL = -5;
  DOWNLOAD_ERROR_DIR_NOT_EXISTS = -6;
  DOWNLOAD_ERROR_INCORRECT_DATA_SIZE = -7;

  function GetUrlContent(const Url: string): UTF8String;

implementation

function GetUrlContent(const Url: string): UTF8String;
var
  NetHandle: HINTERNET;
  UrlHandle: HINTERNET;
  Buffer: array[0..1023] of byte;
  BytesRead: dWord;
  StrBuffer: UTF8String;
begin
  Result := '';
  NetHandle := InternetOpen('Delphi 2009', INTERNET_OPEN_TYPE_PRECONFIG, nil, nil, 0);
  if Assigned(NetHandle) then
    try
      UrlHandle := InternetOpenUrl(NetHandle, PChar(Url), nil, 0, INTERNET_FLAG_RELOAD, 0);
      if Assigned(UrlHandle) then
        try
          repeat
            InternetReadFile(UrlHandle, @Buffer, SizeOf(Buffer), BytesRead);
            SetString(StrBuffer, PAnsiChar(@Buffer[0]), BytesRead);
            Result := Result + StrBuffer;
          until BytesRead = 0;
        finally
          InternetCloseHandle(UrlHandle);
        end
      else
        raise Exception.CreateFmt('Cannot open URL %s', [Url]);
    finally
      InternetCloseHandle(NetHandle);
    end
  else
    raise Exception.Create('Unable to initialize Wininet');
end;

constructor TWinApiDownload.Create;
begin
  inherited;
  fUserAgent := 'Mozilla/5.001 (windows; U; NT4.0; en-US; rv:1.0) Gecko/25250101';
  fProgressUpdateInterval := 100;
  fCachingEnabled := True;
  fStop := False;
  fActive := False;
end;

destructor TWinApiDownload.Destroy;
begin
  Stop;
  inherited;
end;

function TWinApiDownload.CheckURL(aURL: string) : Integer;
var
  hInet, hUrl : HINTERNET;
  dwBufferLen, dwIndex : DWORD;
  pErrorCode : array [0..255] of Char;
begin
  fActive := True;
  if aURL = '' then
  begin
    Result := DOWNLOAD_ERROR_EMPTY_URL;
    fActive := False;
    Exit;
  end;

  fStop := False;
  hInet := InternetOpen(PChar(UserAgent), INTERNET_OPEN_TYPE_PRECONFIG,
                        nil, nil, 0);
  if Assigned(hInet) then
  begin
    hUrl := InternetOpenUrl(hInet, PChar(aURL), nil, 0,0,0);
    if Assigned(hUrl) then
    begin
      dwIndex := 0;
      dwBufferLen := 20;
      HttpQueryInfo(hUrl, HTTP_QUERY_STATUS_CODE, @pErrorCode, dwBufferLen, dwIndex);
      Result := StrToInt(pErrorCode);
      InternetCloseHandle(hUrl);
      InternetCloseHandle(hInet);
    end else
    InternetCloseHandle(hInet);
  end else
  Result := DOWNLOAD_ERROR_UNKNOWN;
  if fStop then
  Result := DOWNLOAD_ABORTED_BY_USER;
  fActive := False;
end;

function TWinApiDownload.Download(Stream : TStream) : Integer;
var
  hInet, hUrl : HINTERNET;
  buf : array [0..4095] of Byte;
  lpdwNumberOfBytesAvailable : DWORD;
  dwBufferLen, dwIndex : DWORD;
  pSize, pErrorCode : array [0..255] of Char;
  b, iter : Cardinal;
  transfered, TargetSize, l : Int64;
  ErrorDataReadIncomplete, ErrorIncorrectSize : boolean;
begin
  fActive := True;
  if URL = '' then
  begin
    Result := DOWNLOAD_ERROR_EMPTY_URL;
    fActive := False;
    Exit;
  end;
  if fStop then
  begin
    Result := DOWNLOAD_ABORTED_BY_USER;
    fActive := False;
    Exit;
  end;
  Result := DOWNLOAD_ERROR_UNKNOWN;

  hInet := InternetOpen(PChar(UserAgent), INTERNET_OPEN_TYPE_PRECONFIG,
                        nil, nil, 0);
  if Assigned(hInet) then
  begin
    if CachingEnabled then
    hUrl := InternetOpenUrl(hInet, PChar(URL), nil, 0, 0, 0) else
    hUrl := InternetOpenUrl(hInet, PChar(URL), nil, 0,
                                 INTERNET_FLAG_NO_CACHE_WRITE,0);
    if Assigned(hUrl) then
    begin
      dwIndex := 0;
      dwBufferLen := 20;
      HttpQueryInfo(hUrl, HTTP_QUERY_STATUS_CODE, @pErrorCode, dwBufferLen, dwIndex);
      Result := StrToInt(pErrorCode);
      if Result <> 200 then
      begin
        InternetCloseHandle(hUrl);
        InternetCloseHandle(hInet);
        Exit;
      end;
      dwIndex := 0;
      dwBufferLen := 20;
      if HttpQueryInfo(hUrl, HTTP_QUERY_CONTENT_LENGTH, @pSize,
                             dwBufferLen, dwIndex) then
      begin
        TargetSize := StrToInt(pSize);
        if Assigned(OnWorkStart) then
        OnWorkStart(Self, TargetSize);
      end else
      TargetSize := 0;
      transfered := 0;
      ErrorIncorrectSize := False;
      repeat
        if InternetQueryDataAvailable(hUrl,
                              lpdwNumberOfBytesAvailable, 0, 0) then
        begin
          if lpdwNumberOfBytesAvailable > 0 then
          begin
            ZeroMemory(@buf, SizeOf(buf));
            if InternetReadFile(hUrl, @buf, SizeOf(buf), b) then
            begin
              if b > 0 then
              begin
                l := Stream.Size;
                transfered := transfered + b;
                Stream.WriteBuffer(buf, b);
                if Stream.Size <> l + b then
                begin
                  ErrorIncorrectSize := True;
                  Break;
                end;
                if lpdwNumberOfBytesAvailable > SizeOf(buf) then
                ErrorDataReadIncomplete := b < SizeOf(buf) else
                ErrorDataReadIncomplete := b < lpdwNumberOfBytesAvailable;
                if ErrorDataReadIncomplete then
                begin
                  if Assigned(OnError) then
                  begin
                    OnError(Self, DOWNLOAD_ERROR_INCOMPLETE_READ, fURL);
                  end;
                end else
                begin
                  if Assigned(OnWork) then
                  begin
                    Inc(iter);
                    if iter > fProgressUpdateInterval then
                    begin
                      OnWork(Self, transfered);
                      iter := 0;
                    end;
                  end;
                end;
              end else
              begin
                ErrorDataReadIncomplete := True;
                Break;
              end;
            end else
            begin
              if Assigned(OnError) then
              begin
                OnError(Self, DOWNLOAD_ERROR_INCOMPLETE_READ, fURL);
              end;
              Result := DOWNLOAD_ERROR_DATA_READ;
              Break;
            end;
          end;
        end else
        begin
          Result := DOWNLOAD_ERROR_UNKNOWN;
          Break;
        end;
      until (lpdwNumberOfBytesAvailable = 0) or (b = 0) or
            (ErrorDataReadIncomplete) or (fStop);
      if fStop then
      Result := DOWNLOAD_ABORTED_BY_USER else
      if ErrorDataReadIncomplete then
      Result := DOWNLOAD_ERROR_INCOMPLETE_READ else
      if (transfered <> TargetSize) or (ErrorIncorrectSize) then
      Result := DOWNLOAD_ERROR_INCORRECT_DATA_SIZE;
      if Assigned(OnWorkEnd) then
      OnWorkEnd(Self, transfered, Result);
      InternetCloseHandle(hUrl);
    end;
    InternetCloseHandle(hInet);
  end;
  fActive := False;
end;

function TWinApiDownload.Download(var res : string) : Integer;
var
  hInet, hUrl : HINTERNET;
  buffer, buf : array [0..4095] of Byte;
  lpdwBufferLength: DWORD;
  lpdwReserved    : DWORD;
  dwBytesRead     : DWORD;
  lpdwNumberOfBytesAvailable : DWORD;
  dwBufferLen, dwIndex : DWORD;
  pSize, pErrorCode : array [0..255] of Char;
  b, _pos, iter, transfered : Cardinal;
  ResponseText : AnsiString;
begin
  fActive := True;
  res := '';
  if URL = '' then
  begin
    Result := DOWNLOAD_ERROR_EMPTY_URL;
    fActive := False;
    Exit;
  end;
  Result := DOWNLOAD_ERROR_UNKNOWN;

  hInet := InternetOpen(PChar(UserAgent), INTERNET_OPEN_TYPE_PRECONFIG,
                        nil, nil, 0);
  if Assigned(hInet) then
  begin
    if CachingEnabled then
    hUrl := InternetOpenUrl(hInet, PChar(URL), nil, 0, 0, 0) else
    hUrl := InternetOpenUrl(hInet, PChar(URL), nil, 0,
                                 INTERNET_FLAG_NO_CACHE_WRITE,0);
    if Assigned(hUrl) then
    begin
      dwIndex := 0;
      dwBufferLen := 20;
      HttpQueryInfo(hUrl, HTTP_QUERY_STATUS_CODE, @pErrorCode, dwBufferLen, dwIndex);
      Result := StrToInt(pErrorCode);
      if Result <> 200 then
      begin
        InternetCloseHandle(hUrl);
        InternetCloseHandle(hInet);
        Exit;
      end;
      dwIndex := 0;
      dwBufferLen := 20;
      if HttpQueryInfo(hUrl, HTTP_QUERY_CONTENT_LENGTH, @pSize,
                             dwBufferLen, dwIndex) then
//      begin
        if Assigned(OnWorkStart) then
        OnWorkStart(Self, StrToInt(pSize));
//      end;
      ResponseText := '';
      _Pos := 1;
      iter := 0;
      transfered := 0;
      repeat
        if InternetQueryDataAvailable(hUrl,
                              lpdwNumberOfBytesAvailable, 0, 0) then
        begin
          if lpdwNumberOfBytesAvailable > 0 then
          begin
            SetLength(ResponseText, Length(ResponseText) +
                                      lpdwNumberOfBytesAvailable);
            if InternetReadFile(hUrl, @responsetext[_pos],
                           lpdwNumberOfBytesAvailable, b) then
            begin
              inc(_pos, b);
              inc(transfered, b);
              if Assigned(OnWork) then
              begin
                inc(iter);
                if iter >= fProgressUpdateInterval then
                begin
                  OnWork(Self, transfered);
                  iter := 0;
                end;
              end;
            end;
          end;
        end;
      until (lpdwNumberOfBytesAvailable = 0) or (b = 0) or (fStop);
      if fStop then
      Result := DOWNLOAD_ABORTED_BY_USER;
      res := UTF8Decode(ResponseText);
      if Assigned(fEventWorkEnd) then
      OnWorkEnd(Self, transfered, Result);
      InternetCloseHandle(hUrl);
    end;
    InternetCloseHandle(hInet);
  end;
  fActive := False;
end;

procedure TWinApiDownload.Stop;
begin
  fStop := True;
end;

procedure TWinApiDownload.Clear;
begin
  fStop := False;
end;

function TWinApiDownload.GetIsActive;
begin
  Result := fActive;
end;

function TWinApiDownload.ErrorCodeToMessageString(aErrorCode: Integer) : string;
begin
  case aErrorCode of
    403:
    Result := 'Forbidden';
    404:
    Result := 'Not found';
    DOWNLOAD_ERROR_UNKNOWN:
    Result := 'Unknown error';
    DOWNLOAD_ERROR_EMPTY_URL:
    Result := 'Empty URL';
    DOWNLOAD_ABORTED_BY_USER:
    Result := 'Canceled by user';
    DOWNLOAD_ERROR_INCOMPLETE_READ:
    Result := 'Incomplete read';
    DOWNLOAD_ERROR_DATA_READ:
    Result := 'Data read error';
    DOWNLOAD_ERROR_INCORRECT_DATA_SIZE:
    Result := 'Incorrect data size';
  else
    Result := IntToStr(aErrorCode) + ': Unknown error';
  end;
end;

end.