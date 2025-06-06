unit InetUtilsUnified;

//change in init settings cause of bug
// NetUtilsSetts.UserAgent:= ExtractFileName(ParamStr(0)) + '(D7mX4 InetUtils)';


interface

uses Windows, Classes, SysUtils, WinInet, Graphics, Stringutils;

type
  TNetUtilsSettings =  record
    UserAgent: String;
    ProxyURL: String;
    OpenURLFlags: DWord;
    TrafficCounter, UploadedCounter: PDWord;
    ReadBufferSize: DWord;
  end;

  TRawCharset = set of Char;
  TInetHeaders = array of String;

  EInet = class (Exception)
  end;

{ Download: }
type
  // return True to terminate the download. if TotalSize = 0 then total size is unknown.
  TInetDownloadCallback = function (Downloaded, TotalSize: DWord): Boolean of object;

function InetDownloadTo(const DestFile: WideString; const URL: String; Callback: TInetDownloadCallback = NIL): Boolean; overload;
  function InetDownloadTo(const DestFile: WideString; const URL: String; const Settings: TNetUtilsSettings;
      Callback: TInetDownloadCallback = NIL): Boolean; overload;
function InetDownload(const URL: String; Dest: TStream; Callback: TInetDownloadCallback = NIL): Boolean; overload;
  function InetDownload(const URL: String; Dest: TStream; const Settings: TNetUtilsSettings;
      Callback: TInetDownloadCallback = NIL): Boolean; overload;

function InetBufferedReadFrom(Handle: HInternet; Dest: TStream; const Settings: TNetUtilsSettings;

    Callback: TInetDownloadCallback = NIL): DWord; overload;
  function InetBufferedReadFrom(Handle: HInternet; const Settings: TNetUtilsSettings;

    Callback: TInetDownloadCallback = NIL): String; overload;

function IsResponseStatusOK(Handle: HInternet): Boolean;

{ Upload: }
type
  TMultipartItem = record
    Headers: TInetHeaders;
    Data: TStream;
  end;

    TMultipartItems = array of TMultipartItem;

  TUploadFile = record
    Name: String;  // name of form field (e.g. <input type="file" name="*ItemName*" />).
    SourceFileName: WideString;
    Data: TStream;
  end;

    TUploadFiles = array of TUploadFile;

function FindBoundaryFor(const Items: TMultipartItems): String;
  function RandomBoundary: String;
function GenerateMultipartFormFrom(const Items: TMultipartItems;
    out ExtraHeaders: TInetHeaders): String;

function InetUploadTo(const ToURL: String; const Headers: TInetHeaders;
    const Items: TMultipartItems; const Settings: TNetUtilsSettings): String; overload;
  function InetUploadTo(const ToURL: String; const Items: TMultipartItems;
      const Settings: TNetUtilsSettings): String; overload;
  function InetUploadTo(const ToURL: String; const Items: TMultipartItems): String; overload;

// Streams: ['ItemName', 'SourceFileName', TStream, 'SecondItem', 'File2', TStream_2, ...]
function InetUploadStreamsTo(const ToURL: String; const Settings: TNetUtilsSettings;
    Streams: TUploadFiles): String; overload;
  function InetUploadStreamsTo(const ToURL: String; const Streams: TUploadFiles): String; overload;
function InetUploadFileTo(const ToURL: String; const Settings: TNetUtilsSettings;
    const ItemName: String; const FilePath: WideString): String; overload;
  function InetUploadFileTo(const ToURL: String; const ItemName: String;
      const FilePath: WideString): String; overload;
// Files: ['ItemName', 'c:\FilePath', 'Item2', 'c:\second_file', ...]
function InetUploadFilesTo(const ToURL: String; const Settings: TNetUtilsSettings;
    const Files: array of const): String; overload;
  function InetUploadFilesTo(const ToURL: String; const Files: array of const): String; overload;

{ URL string juggling: }
function AppendQueryTo(const URL: String; const Arguments: array of const): String;
function HasQueryPart(const URL: String): Boolean;
function BuildQueryFrom(const Arguments: array of const): String;

// Protocol should include trailing ":" (for "http:" and such).
// Protocol, Port, Path and Script can be empty to use default values (http:, 80, '' & '' correspondingly).
// Script don't include path characters ('/', etc.) in script - it's not checked.
function BuildURL(Protocol, Host: String; Port: Word; Path, Script: String;
    const Arguments: array of const): String;

function CustomEncode(const Str: WideString; const RawChars: TRawCharset): String;
  function EncodeURI(const Str: WideString): String;
  function EncodeURIComponent(const Str: WideString): String;

procedure InetGetLastError(out ErrorCode: DWord; out ErrorMessage: String);
  function InetGetLastErrorCode: DWord;
  function InetGetLastErrorMsg: String;

// BaseURL should include protocol, host and port but not path.
// URL may be either full URL (with protocol and such), relative to BaseURL (thus absolute
//   in path) or relative to BaseURL + BasePath (in this case URL doesn't start with '/').
function AbsoluteURLFrom(URL, BaseURL, BasePath: String): String;

procedure SplitURL(const URL: String; out Domain, Path: String);
  function DomainOf(const URL: String): String;
  function PathFromURL(const URL: String): String;

{ Misc: }
// Example: InetHeaders( ['Content-Type', 'text/plain; charset=utf-8'] )
function InetHeaders(const NameValues: array of const): TInetHeaders;
  function NoInetHeaders: TInetHeaders;
function JoinHeaders(const Headers: TInetHeaders): String;

const
  URIComponentRawChars = ['A'..'Z', 'a'..'z', '0'..'9', '-', '_', '.', '!', '(', ')', '*',
                          '''', '~'];
  FullURIRawChars = URIComponentRawChars + ['@', '#', '$', '&', '=', '+', ';', ':', ',',
                                            '?', '/'];
  InetHeaderEOLN = #13#10;

var
  NetUtilsSettings: TNetUtilsSettings;

procedure SetDefaultNetUtilsSettings;
procedure SetDefaultNetUtilsSettings2;
procedure SetDefaultNetUtilsSettings3;


function TotalDownTrafficThroughNetUtils: DWord;

//uses Windows, SysUtils, Classes, Graphics, StringUtils;
//Drawingutils


type
  TDBDraw = record
    DisplayDC, MemDC: HDC;
    MemBitmap, OldBitmap: HBITMAP;
    OldFont: HFONT;
    OldPen: HPEN;
  end;

  TPieceFormatData = record
    Position: TMaskMatchInfo;
    Color: TColor;
  end;
  TFormatData = array of TPieceFormatData;

  TDrawFormattedTextSettings = record
    Text: WideString;
    FormatData: TFormatData;
    Canvas: TCanvas;
    WrapText: Boolean;
    DestPos: TPoint;
    MaxWidth: Word;
    CharSpacing: Word;
  end;

  TWrapTextSettings = record
    DC: HDC;
    Str: WideString;
    Delimiter: WideString;
    MaxWidth: Word;     // pixels.
    LeftMargin: Word;
    CharSpacing: Word; // vertical spacing in pixels between the two chars.

    LastChar: TSize;   // is set by the function.
  end;

function TextSize(const DC: HDC; const Str: WideString): TSize;
function TextWidth(const DC: HDC; const Str: WideString): Integer;
function TextHeight(const DC: HDC; const Str: WideString): Integer;

function GetLineHeightOf(const Font: HFONT): Word;

function TextWidthEx(const DC: HDC; const Str: WideString; const CharSpacing: Word = 0): Integer;
function TextHeightEx(const DC: HDC; const Str: WideString; const CharSpacing: Word = 0): Integer;
function TextSizeEx(const DC: HDC; const Str: WideString; const CharSpacing: Word = 0): TSize; overload;
function TextWithBreaksSize(Settings: TWrapTextSettings): TSize; overload;

function DoubleBufferedDraw(const DisplaySurface: HDC; const BufferSize: TPoint): TDBDraw; overload;
function DoubleBufferedDraw(const Canvas: TCanvas; const BufferSize: TPoint): TDBDraw; overload;
procedure DrawFormattedText(const Settings: TDrawFormattedTextSettings);

function GetLastCharPos(const DC: HDC; const Str: WideString;
  const MaxWidth: Word; const CharSpacing: Word = 0): TSize;
// MaxWidth is in pixels.
function WrapNonMonospacedText(const DC: HDC; const Str: WideString;
  const Delimiter: WideString; const MaxWidth: Word; const CharSpacing: Word = 0): WideString; overload;
function WrapNonMonospacedText(var Settings: TWrapTextSettings): WideString; overload;


implementation

uses MMSystem, StrUtils, Math, FileStreamW;


var
  NetUtilsGlobalTrafficCounter:  DWord;
  NetUtilsGlobalUploadedCounter: DWord;

function Var2Str(const Variant: TVarRec): String; forward;
procedure UpdateNetUtilsCounter(Counter: PDWord; var NetUtilsGlobalCounter: DWord; ByAmount: Integer); forward;

{ Download: }

function InetDownloadTo(const DestFile: WideString; const URL: String; const Settings: TNetUtilsSettings;
  Callback: TInetDownloadCallback = NIL): Boolean;
var
  DestStream: TFileStreamW;
begin
  DestStream := TFileStreamW.Create(DestFile, fmCreate or fmShareExclusive);
  try
    Result := InetDownload(URL, DestStream, Settings, Callback);
  except
    Result := False;
  end;

  DestStream.Free;

  if not Result then
    DeleteFileW(PWideChar(DestFile));
end;

  function InetDownloadTo(const DestFile: WideString; const URL: String; Callback: TInetDownloadCallback = NIL): Boolean;
  begin
    Result := InetDownloadTo(DestFile, URL, NetUtilsSettings, Callback);
  end;

function InetDownload(const URL: String; Dest: TStream; const Settings: TNetUtilsSettings;
  Callback: TInetDownloadCallback = NIL): Boolean;
var
  InetHandle, URLHandle: HInternet;
begin
  InetHandle := InternetOpen(PChar(Settings.UserAgent), INTERNET_OPEN_TYPE_PRECONFIG,
                             PChar(Settings.ProxyURL), NIL, 0);

  try
    URLHandle := InternetOpenURL(InetHandle, PChar(URL), NIL, 0, INTERNET_FLAG_NO_UI or Settings.OpenURLFlags, 0);
    try
      Result := False;

      if IsResponseStatusOK(URLHandle) then
      begin
        InetBufferedReadFrom(URLHandle, Dest, Settings, Callback);
        Result := True;
      end;
    finally
      InternetCloseHandle(URLHandle);
    end;
  finally
    InternetCloseHandle(InetHandle);
  end;
end;

  function InetDownload(const URL: String; Dest: TStream; Callback: TInetDownloadCallback = NIL): Boolean;
  begin
    Result := InetDownload(URL, Dest, NetUtilsSettings, Callback);
  end;

function InetBufferedReadFrom(Handle: HInternet; Dest: TStream; const Settings: TNetUtilsSettings;
  Callback: TInetDownloadCallback = NIL): DWord;
var
  Buf: array of Byte;
  BytesRead: DWord;
begin
  if not IsResponseStatusOK(Handle) then
    raise EInet.Create('InetBufferedReadFrom: response status doesn''t indicate success.');

  Result := 0;
  SetLength(Buf, Settings.ReadBufferSize);

  repeat
    if not InternetReadFile(Handle, @Buf[0], SizeOf(Buf), BytesRead) then
      Result := 0;getlasterror;
    Dest.WriteBuffer(Buf[0], BytesRead);
    Inc(Result, BytesRead);

    if Assigned(Callback) then
      if Callback(Result, 0) then
        Break;
  until BytesRead = 0;

  UpdateNetUtilsCounter(Settings.TrafficCounter, NetUtilsGlobalTrafficCounter, Result);
end;

  function InetBufferedReadFrom(Handle: HInternet; const Settings: TNetUtilsSettings;
    Callback: TInetDownloadCallback = NIL): String;
  var
    Stream: TMemoryStream;
  begin
    Stream := TMemoryStream.Create;
    try
      InetBufferedReadFrom(Handle, Stream, Settings, Callback);

      SetLength(Result, Stream.Size);
        Stream.Position := 0;
        Stream.ReadBuffer(Result[1], Stream.Size);
    finally
      Stream.Free;
    end;
  end;

function IsResponseStatusOK(Handle: HInternet): Boolean;
var
  Status: String[254];
  StatusLength, HeaderIndex: DWord;
  Code: Integer;
begin
  StatusLength := SizeOf(Status);
  HeaderIndex := 0;

  if HttpQueryInfo(Handle, HTTP_QUERY_STATUS_CODE, @Status[1], StatusLength, HeaderIndex) then
  begin
    SetLength(Status, StatusLength);
    Result := TryStrToInt(Status, Code) and (Code < 300);
  end
    else
      Result := False;
end;

{ Upload: }

function FindBoundaryFor(const Items: TMultipartItems): String;
const
  MaxAttempts = 20;
var
  Attempts: Byte;
  Found: Boolean;
begin
  Attempts := 0;

  repeat
    Inc(Attempts);

      if Attempts > MaxAttempts then
        raise Exception.CreateFmt('FindBoundaryFor: max attempts (%d) reached.', [MaxAttempts]);

    Result := RandomBoundary;

    // todo: currently a stub for checking if Boundary is unique. Should Pos() inside every
    //       Files[] stream for CRLF + Boundary + CRLF.
    Found := True;
  until Found;
end;

  function RandomBoundary: String;
  const
    Prefix = '---------------------------';
    SaltLength = 15;
  var
    I: Byte;
  begin
    Result := Prefix;

      Randomize;

    for I := 1 to SaltLength do
      if I mod 2 = 0 then
        Result := Result + Chr( Ord('a') + Random(Ord('z') - Ord('a') + 1) )
        else
          Result := Result + Chr( Ord('0') + Random(Ord('9') - Ord('0') + 1) );
  end;

function GenerateMultipartFormFrom(const Items: TMultipartItems;
  out ExtraHeaders: TInetHeaders): String;
var
  Boundary: String;
  I: Integer;
  ThisFileOffset: DWord;
begin
  Boundary := FindBoundaryFor(Items);

    Result := '';

    { --boundary    (note thta it should be prefixed with two dashes, even if it begins with dashes)
      <Headers here (optional), then one empty line>

      <File contents>
      --boundary    (for second file, if any)
      ...
      --boundary--  (terminating; affixed with two dashes) }

  for I := 0 to Length(Items) - 1 do
    with Items[I] do
    begin
      Result := Result + '--' + Boundary + InetHeaderEOLN
                       + JoinHeaders(Headers) + InetHeaderEOLN;

        ThisFileOffset := Length(Result) + 1;
        SetLength(Result, Length(Result) + Data.Size + Length(InetHeaderEOLN));

      Data.Position := 0;
      Data.ReadBuffer( Result[ThisFileOffset], Data.Size );

        Move(InetHeaderEOLN[1], Result[ Length(Result) - Length(InetHeaderEOLN) + 1 ],
             Length(InetHeaderEOLN));

      if PosEx(Boundary, Result, ThisFileOffset) <> 0 then
        raise Exception.Create('GenerateMultipartFormFrom: Boundary was not unique.');
    end;

  Result := Result + '--' + Boundary + '--';
  ExtraHeaders := InetHeaders( ['Content-Type', 'multipart/form-data; boundary=' + Boundary] );
end;

function InetUploadTo(const ToURL: String; const Headers: TInetHeaders;
  const Items: TMultipartItems; const Settings: TNetUtilsSettings): String;
var
  InetHandle, ConnectHandle, RequestHandle: HInternet;
  RequestFlags: DWord;
  HeaderString, FormData: String;
  ExtraHeaders: TInetHeaders;
  SentOK: Boolean;
begin
  Result := '';

  InetHandle := InternetOpen(PChar(Settings.UserAgent), INTERNET_OPEN_TYPE_PRECONFIG,
                             PChar(Settings.ProxyURL), NIL, 0);
  try
    ConnectHandle := InternetConnect(InetHandle, PChar( DomainOf(ToURL) ), INTERNET_DEFAULT_HTTP_PORT,
                                     NIL, NIL, INTERNET_SERVICE_HTTP, 0, 0);
    try
        RequestFlags := INTERNET_FLAG_NO_UI or Settings.OpenURLFlags;
        if Copy(ToURL, 1, 8) = 'https://' then
          RequestFlags := RequestFlags or INTERNET_FLAG_SECURE;

      RequestHandle := HttpOpenRequest(ConnectHandle, 'POST', PChar( PathFromURL(ToURL) ), NIL,
                                       NIL, NIL, RequestFlags, 0);
      try
          SentOK := IsResponseStatusOK(RequestHandle);

        if SentOK then
        begin
          FormData := GenerateMultipartFormFrom(Items, ExtraHeaders);
          HeaderString := JoinHeaders(Headers) + JoinHeaders(ExtraHeaders);

          SentOK := HttpSendRequest(RequestHandle, @HeaderString[1], Length(HeaderString),
                                    @FormData[1], Length(FormData));
        end;

          SentOK := SentOK and IsResponseStatusOK(RequestHandle);

        if SentOK then
        begin
          Result := InetBufferedReadFrom(RequestHandle, Settings);

          UpdateNetUtilsCounter(Settings.UploadedCounter, NetUtilsGlobalUploadedCounter,
                                Length(HeaderString) + Length(FormData));
        end;
      finally
        InternetCloseHandle(RequestHandle);
      end;
    finally
      InternetCloseHandle(ConnectHandle);
    end;
  finally
    InternetCloseHandle(InetHandle);
  end;
end;

  function InetUploadTo(const ToURL: String; const Items: TMultipartItems;
    const Settings: TNetUtilsSettings): String;
  begin
    Result := InetUploadTo(ToURL, NoInetHeaders, Items, Settings);
  end;

  function InetUploadTo(const ToURL: String; const Items: TMultipartItems): String;
  begin
    Result := InetUploadTo(ToURL, NoInetHeaders, Items, NetUtilsSettings);
  end;

function InetUploadStreamsTo(const ToURL: String; const Settings: TNetUtilsSettings;
  Streams: TUploadFiles): String;
var
  Items: TMultipartItems;
  I: Integer;
  Disposition: WideString;
begin
  SetLength(Items, Length(Streams));

  for I := 0 to Length(Items) - 1 do
  begin
    Disposition := WideFormat('form-data; name="%s"; filename="%s"',
                              [Streams[I].Name, Streams[I].SourceFileName]);

    Items[I].Headers := InetHeaders(['Content-Disposition', Disposition,
                                     'Content-Type', 'application/octet-stream']);

    Items[I].Data := Streams[I].Data;
  end;

  Result := InetUploadTo(ToURL, NoInetHeaders, Items, Settings);
end;

  function InetUploadStreamsTo(const ToURL: String; const Streams: TUploadFiles): String;
  begin
    Result := InetUploadStreamsTo(ToURL, Streams);
  end;

function InetUploadFileTo(const ToURL: String; const Settings: TNetUtilsSettings;
  const ItemName: String; const FilePath: WideString): String;
var
  FileData: TFileStreamW;
  UploadFiles: TUploadFiles;
begin
  FileData := TFileStreamW.Create(FilePath, fmOpenRead or fmShareDenyWrite);
  try
    SetLength(UploadFiles, 1);
    UploadFiles[0].Name := ItemName;
    UploadFiles[0].SourceFileName := FilePath;
    UploadFiles[0].Data := FileData;

    Result := InetUploadStreamsTo(ToURL, Settings, UploadFiles);
  finally
    FileData.Free;
  end;
end;

  function InetUploadFileTo(const ToURL: String; const ItemName: String; const FilePath: WideString): String;
  begin
    Result := InetUploadFileTo(ToURL, NetUtilsSettings, ItemName, FilePath);
  end;

function InetUploadFilesTo(const ToURL: String; const Settings: TNetUtilsSettings;
  const Files: array of const): String;
var
  Items: TUploadFiles;
  I: Integer;
begin
  if Length(Files) mod 2 <> 0 then
    raise Exception.CreateFmt('InetUploadFilessTo: Files should be even to 2, %d passed.', [Length(Files)]);

  SetLength(Items, Length(Files) div 2);
  ZeroMemory(@Items[0], SizeOf(Items));

  try
    for I := 0 to Length(Items) - 1 do
      with Items[I] do
      begin
        Name := Var2Str(Files[I * 2]);

        if Files[I * 2 + 1].VType = vtWideString then
          SourceFileName := Files[I * 2 + 1].VPWideChar
          else
            SourceFileName := Var2Str(Files[I * 2 + 1]);

        Data := TFileStreamW.Create(SourceFileName, fmOpenRead or fmShareDenyWrite);
      end;

    Result := InetUploadStreamsTo(ToURL, Settings, Items);
  finally
    for I := 0 to Length(Items) - 1 do
      if Items[I].Data <> NIL then
        Items[I].Data.Free;
  end;
end;

  function InetUploadFilesTo(const ToURL: String; const Files: array of const): String;
  begin
    Result := InetUploadFilesTo(ToURL, NetUtilsSettings, Files);
  end;

{ URL strings juggling: }

function BuildURL(Protocol, Host: String; Port: Word; Path, Script: String;
  const Arguments: array of const): String;
begin
  if Protocol = '' then
    Protocol := 'http:'
    else if (Protocol[Length(Protocol)] <> ':') and
            (Protocol = 'http') or (Protocol = 'https') or (Protocol = 'ftp') then
      Insert(':', Protocol, $FFFF);  // missing ":"

  if Port = 0 then
    Port := 80;
  if (Path = '') or (Path[1] <> '/') then
    Insert('/', Path, 1);
  if (Path = '') or (Path[Length(Path)] <> '/') then
    Insert('/', Path, $FFFF);

  Result := Format('%s//%s:%d%s%s', [Protocol, Host, Port, EncodeURI(Path), EncodeURI(Script)]);
  Result := AppendQueryTo(Result, Arguments);
end;

function AppendQueryTo(const URL: String; const Arguments: array of const): String;
begin
  Result := URL;

  if Length(Arguments) <> 0 then
  begin
    if HasQueryPart(URL) then
      Result := Result + '&'
      else
        Result := Result + '?';
    Result := Result + BuildQueryFrom(Arguments);
  end;
end;

  function HasQueryPart(const URL: String): Boolean;
  const
    QueryChars = ['?', '&', '#'];
    PathChars  = ['/'];
  var
    I: Integer;
  begin
    for I := Length(URL) downto 1 do
      if Hi(Word(URL[I])) = 0 then
        if Char(Byte(URL[I])) in QueryChars then
        begin
          Result := True;
          Exit;
        end
        else if Char(Byte(URL[I])) in PathChars then
          Break;

    Result := False;
  end;

  function BuildQueryFrom(const Arguments: array of const): String;
    procedure Append(const Pair: String);
    begin
      Result := Result + '&' + Pair;
    end;

  var
    I: Integer;
  begin
    Result := '';

    I := 0;
    while I < Length(Arguments) -  Length(Arguments) mod 2 do
    begin
      Append(
        EncodeURIComponent( Var2Str(Arguments[I]) ) +
        '=' +
        EncodeURIComponent( Var2Str(Arguments[I + 1]) )
      );
      Inc(I, 2);
    end;

    if I < Length(Arguments) then
      // uneven number of arguments; treating last arg as bool, appending "1" as its value.
      Append( EncodeURIComponent( Var2Str(Arguments[I]) ) + '=1' );

    Delete(Result, 1, 1);
  end;

function CustomEncode(const Str: WideString; const RawChars: TRawCharset): String;
var
  UTF8: String;
  I, J: Integer;
begin
  Result := '';

  for I := 1 to Length(Str) do
    if (Hi(Word(Str[I])) = 0) and (Char(Byte(Str[I])) in RawChars) then
      Result := Result + Str[I]
      else
      begin
        UTF8 := UTF8Encode(Str[I]);

        for J := 1 to Length(UTF8) do
          Result := Result + '%' + UpperCase(IntToHex( Byte(UTF8[J]), 2 ));
      end;
end;

  function EncodeURI(const Str: WideString): String;
  begin
    Result := CustomEncode(Str, FullURIRawChars);
  end;

  function EncodeURIComponent(const Str: WideString): String;
  begin
    Result := CustomEncode(Str, URIComponentRawChars);
  end;

procedure InetGetLastError(out ErrorCode: DWord; out ErrorMessage: String);
var
  Length: DWord;
begin
  Length := 2000;
  SetLength(ErrorMessage, Length);
  if InternetGetLastResponseInfo(ErrorCode, @ErrorMessage[1], Length) then
    SetLength(ErrorMessage, Length)
    else
    begin
      ErrorCode := 0;
      ErrorMessage := '';
    end;
end;

  function InetGetLastErrorCode: DWord;
  var
    Message: String;
  begin
    InetGetLastError(Result, Message);
  end;

  function InetGetLastErrorMsg: String;
  var
    Code: DWord;
  begin
    InetGetLastError(Code, Result);
  end;

function AbsoluteURLFrom(URL, BaseURL, BasePath: String): String;
begin
  if Pos('//', URL) = 0 then                 // relative to BaseURL
  begin
    if (URL = '') or (URL[1] <> '/') then      // + relative to BasePath
    begin
      if BasePath = '/' then
        BasePath := '';
      if (URL <> '') and (BasePath <> '') and (BasePath[Length(BasePath)] <> '/') then
        Insert('/', BasePath, $FFFF);
      URL := '/' + BasePath + URL
    end;

    if (BaseURL <> '') and (BaseURL[Length(BaseURL)] = '/') then
      Delete(BaseURL, Length(BaseURL), 1);

    Result := BaseURL + URL;
  end
    else
      Result := URL;

  if URL[Length(URL)] <> '/' then
    Insert('/', URL, $FFFF);
end;

procedure SplitURL(const URL: String; out Domain, Path: String);
var
  SchemePos, PathPos: Integer;
begin
  SchemePos := Pos('//', URL) + 2;
  if SchemePos = 2 then
    SchemePos := 1;

  PathPos := PosEx('/', URL, SchemePos);
  if PathPos = 0 then
    PathPos := Length(URL) + SchemePos;

  Domain := Copy(URL, SchemePos, PathPos - SchemePos);
  Path := Copy(URL, PathPos + 1, $FFFF);
end;

  function DomainOf(const URL: String): String;
  var
    Path: String;
  begin
    SplitURL(URL, Result, Path);
  end;

  function PathFromURL(const URL: String): String;
  var
    Domain: String;
  begin
    SplitURL(URL, Domain, Result);
  end;

{ Misc: }

function Var2Str(const Variant: TVarRec): String;
  function FloatToStr(const Value: Extended): String;
  var
    FS: TFormatSettings;
  begin
    FS.DecimalSeparator := '.';
    Result := SysUtils.FloatToStr(Value, FS);
  end;

begin
  with Variant do
    case VType of
    vtInteger:    Result := IntToStr(VInteger);
    vtBoolean:    Result := IntToStr( Byte(VBoolean) );
    vtChar:       Result := VChar;
    vtExtended:   Result := FloatToStr( VExtended^ );
    vtString:     Result := VString^;

    vtAnsiString,
    vtPChar:      Result := VPChar;

    vtWideChar:   Result := Char(VWideChar);

    vtWideString,
    vtPWideChar:  Result := WideString(VPWideChar);

    vtCurrency:   Result := FloatToStr(VCurrency^);
    vtInt64:      Result := IntToStr(VInt64^);
    else
      raise EConvertError.CreateFmt('Cannot convert variant %d into string.', [Variant.VType]);
    end;
end;

procedure SetDefaultNetUtilsSettings;
begin
  ZeroMemory(@NetUtilsSettings, SizeOf(NetUtilsSettings));
  NetUtilsSettings.UserAgent := ExtractFileName(ParamStr(0)) + '(D7mX4 InetUtils)';
  NetUtilsSettings.TrafficCounter := @NetUtilsGlobalTrafficCounter;
  NetUtilsSettings.UploadedCounter := @NetUtilsGlobalUploadedCounter;
  NetUtilsSettings.ReadBufferSize := 4096;
end;

procedure SetDefaultNetUtilsSettings2;
begin
  //ZeroMemory(@NetUtilsSettings, SizeOf(NetUtilsSettings));
  NetUtilsSettings.UserAgent := ExtractFileName(ParamStr(0)) + '(D7mX4 InetUtils)';
  NetUtilsSettings.TrafficCounter := @NetUtilsGlobalTrafficCounter;
  NetUtilsSettings.UploadedCounter := @NetUtilsGlobalUploadedCounter;
  NetUtilsSettings.ReadBufferSize := 4096;
end;

procedure SetDefaultNetUtilsSettings3;
begin
  ZeroMemory(@NetUtilsSettings, SizeOf(NetUtilsSettings));
  NetUtilsSettings.UserAgent := ExtractFileName(ParamStr(0)) + '(D7mX4 InetUtils)';
  //NetUtilsSettings.TrafficCounter := @NetUtilsGlobalTrafficCounter;
  //NetUtilsSettings.UploadedCounter := @NetUtilsGlobalUploadedCounter;
  NetUtilsSettings.ReadBufferSize := 4096;
end;

function TotalDownTrafficThroughNetUtils: DWord;
begin
  Result := NetUtilsGlobalTrafficCounter;
end;

function TotalUpTrafficThroughNetUtils: DWord;
begin
  Result := NetUtilsGlobalUploadedCounter;
end;

procedure UpdateNetUtilsCounter(Counter: PDWord; var NetUtilsGlobalCounter: DWord; ByAmount: Integer);
begin
  if Counter <> NIL then
    try
      Inc(Counter^, ByAmount);
    except
      { Do nothing, ignore the error; maybe it's a wrong/lost pointer. }
    end;

  if Counter <> @NetUtilsGlobalCounter then
    Inc(NetUtilsGlobalCounter, ByAmount);
end;

function InetHeaders(const NameValues: array of const): TInetHeaders;
var
  I: Integer;
begin
  SetLength( Result, Ceil(Length(NameValues) / 2) );
  ZeroMemory(@Result[0], SizeOf(Result));

  for I := 0 to Length(NameValues) - 1 do
    if I mod 2 = 0 then
      Result[I div 2] := Var2Str(NameValues[I])
      else
        Result[I div 2] := Result[I div 2] + ': ' + Var2Str(NameValues[I]);
end;

  function NoInetHeaders: TInetHeaders;
  begin
    SetLength(Result, 0);
  end;

function JoinHeaders(const Headers: TInetHeaders): String;
const
  EOLN = #13#10;
var
  I: Integer;
begin
  Result := '';

  for I := 0 to Length(Headers) - 1 do
    Result := Result + Headers[I] + InetHeaderEOLN;
end;

//Drawingutils

function RemoveNonWordChars(const Str: WideString; DoNotRemove: WideString = ''): WideString;
var
  I: Word;
begin
  Result := Str;
  if Length(Result) <> 0 then
    for I := Length(Result) downto 1 do
      if not IsDelimiter(DoNotRemove, Result, I) and
         (((Word(Result[I]) <> Word(' ')) and (Word(Result[I]) <= Word('/'))) or
          ((Word(Result[I]) >= Word(':')) and (Word(Result[I]) <= Word('?'))) or
          ((Word(Result[I]) >= Word('[')) and (Word(Result[I]) <= Word('`'))) or
          ((Word(Result[I]) >= Word('{')) and (Word(Result[I]) <= Word('}')))) then
        Delete(Result, I, 1)
end;

function DoubleBufferedDraw(const DisplaySurface: HDC; const BufferSize: TPoint): TDBDraw;
begin
  ZeroMemory(@Result, SizeOf(Result));
  with Result do
  begin
    DisplayDC := DisplaySurface;
    MemBitmap := CreateCompatibleBitmap(DisplayDC, BufferSize.X, BufferSize.Y);
    MemDC := CreateCompatibleDC(DisplayDC);
    OldBitmap := SelectObject(MemDC, MemBitmap)
  end
end;

function DoubleBufferedDraw(const Canvas: TCanvas; const BufferSize: TPoint): TDBDraw;
begin
  Result := DoubleBufferedDraw(Canvas.Handle, BufferSize);

  with Result do
  begin
    OldFont := SelectObject(MemDC, Canvas.Font.Handle);
    OldPen := SelectObject(MemDC, Canvas.Pen.Handle);
    SetBkColor(MemDC, ColorToRGB(Canvas.Brush.Color))
  end
end;

procedure FinishDrawing(const Struct: TDBDraw; const DisplayPos, BufferPos: TPoint);
begin
  with Struct do
  begin
    BitBlt(DisplayDC, DisplayPos.X, DisplayPos.Y, BufferPos.X, BufferPos.Y, MemDC, 0, 0, SRCCOPY);

    if OldPen <> 0 then
      SelectObject(MemDC, OldPen);
    if OldFont <> 0 then
      SelectObject(MemDC, OldFont);

    SelectObject(MemDC, OldBitmap);
    DeleteDC(MemDC);
    DeleteObject(MemBitmap)
  end
end;

function TextSize(const DC: HDC; const Str: WideString): TSize;
var
  Rect: TRect;
begin
  DrawTextW(DC, PWideChar(Str), Length(Str), Rect, DT_CALCRECT);
  Result.cx := Rect.Right - Rect.Left;
  Result.cy := Rect.Bottom - Rect.Top;
end;

function TextWidth(const DC: HDC; const Str: WideString): Integer;
begin
  Result := TextSize(DC, Str).cx
end;

function TextHeight(const DC: HDC; const Str: WideString): Integer;
begin
  Result := TextSize(DC, Str).cy
end;

function TextSizeEx(const DC: HDC; const Str: WideString; const CharSpacing: Word = 0): TSize;
var
  Settings: TWrapTextSettings;
begin
  Settings.Str := Str;
  Settings.DC := DC;
  Settings.Delimiter := #10;
  Settings.LeftMargin := 0;
  Settings.CharSpacing := CharSpacing;
  Result := TextWithBreaksSize(Settings);
end;

function TextWidthEx(const DC: HDC; const Str: WideString; const CharSpacing: Word = 0): Integer;
begin
  Result := TextSizeEx(DC, Str, CharSpacing).cx
end;

function TextHeightEx(const DC: HDC; const Str: WideString; const CharSpacing: Word = 0): Integer;
begin
  Result := TextSizeEx(DC, Str, CharSpacing).cy
end;

function TextWithBreaksSize(Settings: TWrapTextSettings): TSize;
var
  Str: WideString;
  I, CurrentX: Word;
  Extent: TSize;
begin
  { Used fields of Settings are:
    DC, Str, LeftMargin, Delimiter, CharSpacing. }

  Str := Settings.Str;

  Result.cx := 0;
  Result.cy := TextHeight(Settings.DC, 'w');
  CurrentX := Settings.LeftMargin;

  for I := 1 to Length(Str) do
  begin
    GetTextExtentPoint32W(Settings.DC, @Str[I], 1, Extent);
    if Str[I] = Settings.Delimiter then
    begin
      Result.cx := Max(Result.cx, CurrentX);
      CurrentX := Settings.LeftMargin;;
      Inc(Result.cy, Extent.cy);
    end
      else
        Inc(Result.cx, Extent.cx + Settings.CharSpacing);
  end;
end;

function GetLineHeightOf(const Font: HFONT): Word;
var
  DC: HDC;
  OldFont: HFONT;
  Extent: TSize;
begin
  DC := CreateCompatibleDC(0);
  OldFont := SelectObject(DC, Font);
  try
    GetTextExtentPoint32(DC, 'w', 1, Extent);
    Result := Extent.cy
  finally
    SelectObject(DC, OldFont);
    DeleteDC(DC)
  end
end;

procedure DrawFormattedText(const Settings: TDrawFormattedTextSettings);
const
  NewLineChar  = #10;
  BufferHeight = 700;
var
  Canvas: TCanvas;
  MaxWidth: Word;
  DC: HDC;
  Drawing: TDBDraw;
  CurHighlight: TPieceFormatData;
  I, LastHighlight: Integer;
  WrappedText: WideString;
  Current: TPoint;
  Extent: TSize;
begin
  Canvas := Settings.Canvas;
  MaxWidth := Settings.MaxWidth;

  Drawing := DoubleBufferedDraw(Canvas, Point(MaxWidth, 700));
  DC := Drawing.MemDC;
  try
    FillRect(DC, Rect(0, 0, MaxWidth, BufferHeight), Canvas.Brush.Handle);

    if Settings.WrapText then
      WrappedText := wrapNonMonospacedText(Canvas.Handle, Settings.Text, NewLineChar, MaxWidth)
      else
        WrappedText := Settings.Text;

    ZeroMemory(@CurHighlight, SizeOf(CurHighlight));
    LastHighlight := -1;
    Current := Point(0, 0);

    for I := 1 to Length(WrappedText) do
    begin
      if CurHighlight.Position.StrPos + CurHighlight.Position.MatchLength <= I then
      begin
        if LastHighlight = Length(Settings.FormatData) - 1 then
        begin
          CurHighlight.Position.MatchLength := $FFFF;
          CurHighlight.Color := clBlack
        end
          else
          begin
            Inc(LastHighlight);
            CurHighlight := Settings.FormatData[LastHighlight]
          end;

        SetTextColor(DC, ColorToRGB(clBlack))
      end
        else if CurHighlight.Position.StrPos <= I then
          SetTextColor(DC, ColorToRGB(CurHighlight.Color));

      GetTextExtentPoint32W(DC, @WrappedText[I], 1, Extent);

      if WrappedText[I] = NewLineChar then
        Current := Point(4, Current.Y + Extent.cy)
        else
        begin
          TextOutW(DC, Current.X, Current.Y, @WrappedText[I], 1);
          Inc(Current.X, Extent.cx + Settings.CharSpacing)
        end
    end
  finally
    FinishDrawing(Drawing, Settings.DestPos, Point(MaxWidth, Current.Y + Extent.cy))
  end;
end;

function GetLastCharPos(const DC: HDC; const Str: WideString;
 const MaxWidth: Word; const CharSpacing: Word = 0): TSize;
var
  Settings: TWrapTextSettings;
begin
  Settings.DC := DC;
  Settings.Str := Str;
  Settings.Delimiter := #10;
  Settings.MaxWidth := MaxWidth;
  Settings.LeftMargin := 0;
  Settings.CharSpacing := CharSpacing;

  WrapNonMonospacedText(Settings);
  Result := Settings.LastChar;
end;

function WrapNonMonospacedText(const DC: HDC; const Str: WideString;
  const Delimiter: WideString; const MaxWidth: Word; const CharSpacing: Word = 0): WideString;
var
  Settings: TWrapTextSettings;
begin
  Settings.DC := DC;
  Settings.Str := Str;
  Settings.Delimiter := Delimiter;
  Settings.MaxWidth := MaxWidth;
  Settings.LeftMargin := 0;
  Settings.CharSpacing := CharSpacing;

  Result := WrapNonMonospacedText(Settings);
end;

function WrapNonMonospacedText(var Settings: TWrapTextSettings): WideString;
var
  Str, Line: WideString;
  I, LastWrap, Pos: Word;
  LastChar, Extent: TSize;
begin
  Str := Settings.Str;
  LastWrap := 1;
  Result := '';

  LastChar.cx := Settings.LeftMargin;
  LastChar.cy := 0;

  I := 1;
  while I <= Length(Str) do
  begin
    GetTextExtentPoint32W(Settings.DC, @Str[I], 1, Extent);
    Inc(LastChar.cx, Extent.cx + Settings.CharSpacing);
    if LastChar.cx > Settings.MaxWidth then
    begin
      Line := WrapText(Copy(Str, LastWrap, I - LastWrap), Settings.Delimiter, I - LastWrap - 1);
      Pos := PosW(Settings.Delimiter, Line) + Length(Settings.Delimiter) - 1;
      Dec(I, Length(Line) - Pos);
      Line := Copy(Line, 1, Pos);
      Result := Result + Line;
      LastWrap := I;
      Inc(LastChar.cy, Extent.cy);
      LastChar.cx := Settings.LeftMargin
    end
      else
        Inc(I);
  end;

  Settings.LastChar := LastChar;
  Result := Result + Copy(Str, LastWrap, $FFFF);
end;


initialization
  SetDefaultNetUtilsSettings;
end.