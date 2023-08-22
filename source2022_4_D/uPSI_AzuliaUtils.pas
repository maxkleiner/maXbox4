unit uPSI_AzuliaUtils;
{
the very last in the past  - as for reentering speed  - httpget enhancer  -

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
  TPSImport_AzuliaUtils = class(TPSPlugin)
  public
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TAzuliaHTML(CL: TPSPascalCompiler);
procedure SIRegister_TAzuliaDisk(CL: TPSPascalCompiler);
procedure SIRegister_TAzuliaSpeaker(CL: TPSPascalCompiler);
procedure SIRegister_TAzuliaFiles(CL: TPSPascalCompiler);
procedure SIRegister_TAzuliaStrings(CL: TPSPascalCompiler);
procedure SIRegister_TSystemRegistry(CL: TPSPascalCompiler);
procedure SIRegister_TBrowseForFolderDialog(CL: TPSPascalCompiler);
procedure SIRegister_IShellLink(CL: TPSPascalCompiler);
procedure SIRegister_AzuliaUtils(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_AzuliaUtils_Routines(S: TPSExec);
procedure RIRegister_TAzuliaHTML(CL: TPSRuntimeClassImporter);
procedure RIRegister_TAzuliaDisk(CL: TPSRuntimeClassImporter);
procedure RIRegister_TAzuliaSpeaker(CL: TPSRuntimeClassImporter);
procedure RIRegister_TAzuliaFiles(CL: TPSRuntimeClassImporter);
procedure RIRegister_TAzuliaStrings(CL: TPSRuntimeClassImporter);
procedure RIRegister_TSystemRegistry(CL: TPSRuntimeClassImporter);
procedure RIRegister_TBrowseForFolderDialog(CL: TPSRuntimeClassImporter);
procedure RIRegister_IShellLink(CL: TPSRuntimeClassImporter);
procedure RIRegister_AzuliaUtils(CL: TPSRuntimeClassImporter);

procedure Register;

function MakeValidIdent(const s: string): string;

implementation


uses
   Windows
  ,Forms
  ,ShlObj
  ,Registry
  ,Messages
  ,Graphics
  ,StdCtrls
  ,FileCtrl
  ,INIFiles
  ,ShellAPI
  ,Consts
  ,MMSystem
  ,Dialogs
  ,extctrls
  ,imagehlp
  ,comctrls
  ,grids
  ,JPEG
  ,Wininet, IdSNTP, strutils, DateUtils, DB, Controls
  ,AzuliaUtils, fmain
  ;


type

  EDataSetConverterException = class(Exception);

  TBooleanFieldType = (bfUnknown, bfBoolean, bfInteger);
  TDataSetFieldType = (dfUnknown, dfJSONObject, dfJSONArray);

 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_AzuliaUtils]);
end;

procedure RegisterProtocol(const Name, Describtion, ExecuteStr: string);
var
  reg: TRegistry;
begin
  reg := TRegistry.Create;
  try
    reg.RootKey := HKEY_CLASSES_ROOT;
    reg.OpenKey(Name, True);
    try
      reg.Writestring('', 'URL:' + Name +' (' + Describtion + ')');
      reg.WriteInteger('EditFlags', 2);
      reg.WriteString('Source Filter', '');
      reg.WriteString('URL Protocol', '');
      reg.OpenKey('shell', True);
      reg.OpenKey('open', True);
      reg.OpenKey('command', True);
      reg.Writestring('', ExecuteStr);
    finally
      reg.CloseKey;
    end;
  finally
    reg.Free;
  end;
end;

function HttpGetDirect(const Url: string): string;
var
  NetHandle: HINTERNET;
  UrlHandle: HINTERNET;
  Buffer: array[0..1024] of Char;
  BytesRead: dWord;
begin
  Result := '';
  //NetHandle := InternetOpen('Delphi 5.x', INTERNET_OPEN_TYPE_PRECONFIG, nil, nil, 0);
  NetHandle := InternetOpen('', INTERNET_OPEN_TYPE_PRECONFIG, nil, nil, 0);

  if Assigned(NetHandle) then begin
    UrlHandle := InternetOpenUrl(NetHandle, PChar(Url), nil, 0, INTERNET_FLAG_RELOAD, 0);

    if Assigned(UrlHandle) then  { UrlHandle valid? Proceed with download }
    begin
      FillChar(Buffer, SizeOf(Buffer), 0);
      repeat
        Result := Result + Buffer;
        FillChar(Buffer, SizeOf(Buffer), 0);
        InternetReadFile(UrlHandle, @Buffer, SizeOf(Buffer), BytesRead);
      until BytesRead = 0;
      InternetCloseHandle(UrlHandle);
    end
    else
      { UrlHandle is not valid. Raise an exception. }
      raise Exception.CreateFmt('Cannot open URL %s', [Url]);

    InternetCloseHandle(NetHandle);
  end else
    { NetHandle is not valid. Raise an exception }
    raise Exception.Create('Unable to initialize Wininet');
end;

function HttpGetDirect4(const Url, agent: string): string;
var
  NetHandle: HINTERNET;
  UrlHandle: HINTERNET;
  Buffer: array[0..1024] of Char;
  BytesRead: dWord;
begin
  Result := '';
  //NetHandle := InternetOpen('Delphi 5.x', INTERNET_OPEN_TYPE_PRECONFIG, nil, nil, 0);
  NetHandle := InternetOpen(pchar(agent), INTERNET_OPEN_TYPE_PRECONFIG, nil, nil, 0);

  if Assigned(NetHandle) then begin
    UrlHandle := InternetOpenUrl(NetHandle, PChar(Url), nil, 0, INTERNET_FLAG_RELOAD, 0);

    if Assigned(UrlHandle) then  { UrlHandle valid? Proceed with download }
    begin
      FillChar(Buffer, SizeOf(Buffer), 0);
      repeat
        Result := Result + Buffer;
        FillChar(Buffer, SizeOf(Buffer), 0);
        InternetReadFile(UrlHandle, @Buffer, SizeOf(Buffer), BytesRead);
      until BytesRead = 0;
      InternetCloseHandle(UrlHandle);
    end
    else
      { UrlHandle is not valid. Raise an exception. }
      raise Exception.CreateFmt('Cannot open URL %s', [Url]);

    InternetCloseHandle(NetHandle);
  end else
    { NetHandle is not valid. Raise an exception }
    raise Exception.Create('Unable to initialize Wininet');
end;

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

 //make a GET request using the WinInet functions
 //https://stackoverflow.com/questions/36586288/delphi-post-with-wininet-and-track-upload-progress

function GetWinInetError(ErrorCode:Cardinal): string;
const
   winetdll = 'wininet.dll';
var
  Len: Integer;
  Buffer: PChar;
begin
  Len := FormatMessage(
  FORMAT_MESSAGE_FROM_HMODULE or FORMAT_MESSAGE_FROM_SYSTEM or
  FORMAT_MESSAGE_ALLOCATE_BUFFER or FORMAT_MESSAGE_IGNORE_INSERTS or  FORMAT_MESSAGE_ARGUMENT_ARRAY,
  Pointer(GetModuleHandle(winetdll)), ErrorCode, 0, @Buffer, SizeOf(Buffer), nil);
  try
    while (Len > 0) and {$IFDEF UNICODE}(CharInSet(Buffer[Len - 1], [#0..#32, '.'])) {$ELSE}(Buffer[Len - 1] in [#0..#32, '.']) {$ENDIF} do Dec(Len);
    SetString(Result, Buffer, Len);
  finally
    LocalFree(HLOCAL(Buffer));
  end;
end;

function HttpGetDirect3(const ServerName, Resource, sUserAgent: string;Var Response:AnsiString): Integer;
const
  BufferSize=1024*64;
var
  hInet    : HINTERNET;
  hConnect : HINTERNET;
  hRequest : HINTERNET;
  ErrorCode : Integer;
  lpvBuffer : PAnsiChar;
  lpdwBufferLength: DWORD;
  lpdwReserved    : DWORD;
  dwBytesRead     : DWORD;
  lpdwNumberOfBytesAvailable: DWORD;
begin
  Result:=0;
  Response:='';
  hInet := InternetOpen(PChar(sUserAgent), INTERNET_OPEN_TYPE_PRECONFIG, nil, nil, 0);
 
  if hInet=nil then begin
    ErrorCode:=GetLastError;
    raise Exception.Create(Format('InternetOpen Error %d Description %s',
              //[ErrorCode,GetWinInetError(ErrorCode)]));
               [ErrorCode,GetWinInetError(ErrorCode)]));
  end;
 
  try
    hConnect := InternetConnect(hInet, PChar(ServerName), INTERNET_DEFAULT_HTTPS_PORT, nil, nil, INTERNET_SERVICE_HTTP, 0, 0);
    if hConnect=nil then begin
      ErrorCode:=GetLastError;
      raise Exception.Create(Format('InternetConnect Error %d Description %s',[ErrorCode,GetWinInetError(ErrorCode)]));
    end;
 
    try
      //make the request
      hRequest := HttpOpenRequest(hConnect, 'GET', PChar(Resource), HTTP_VERSION, '', nil, INTERNET_FLAG_SECURE, 0);
      if hRequest=nil then begin
        ErrorCode:=GetLastError;
        raise Exception.Create(Format('HttpOpenRequest Error %d Description %s',[ErrorCode,GetWinInetError(ErrorCode)]));
      end;
 
      try
        //send the GET request
        if not HttpSendRequest(hRequest, nil, 0, nil, 0) then begin
          ErrorCode:=GetLastError;
          raise Exception.Create(Format('HttpSendRequest Error %d Description %s',[ErrorCode,GetWinInetError(ErrorCode)]));
        end;
 
          lpdwBufferLength:=SizeOf(Result);
          lpdwReserved    :=0;
          //get the status code
          if not HttpQueryInfo(hRequest, HTTP_QUERY_STATUS_CODE or HTTP_QUERY_FLAG_NUMBER, @Result, lpdwBufferLength, lpdwReserved) then begin
            ErrorCode:=GetLastError;
            raise Exception.Create(Format('HttpQueryInfo Error %d Description %s',[ErrorCode,GetWinInetError(ErrorCode)]));
          end;
 
         if Result=200 then //read the body response in case which the status code is 200
          if InternetQueryDataAvailable(hRequest, lpdwNumberOfBytesAvailable, 0, 0) then begin
            GetMem(lpvBuffer,lpdwBufferLength);
            try
              SetLength(Response,lpdwNumberOfBytesAvailable);
              InternetReadFile(hRequest, @Response[1],lpdwNumberOfBytesAvailable,dwBytesRead);
            finally
              FreeMem(lpvBuffer);
            end;
          end
          else begin
            ErrorCode:=GetLastError;
            raise Exception.Create(Format('InternetQueryDataAvailable Error %d Description %s',[ErrorCode,GetWinInetError(ErrorCode)]));
          end;
      finally
        InternetCloseHandle(hRequest);
      end;
    finally
      InternetCloseHandle(hConnect);
    end;
  finally
    InternetCloseHandle(hInet);
  end;
end;

//encode a Url
function URLEncode3(const Url: string): string;
var
  i: Integer;
begin
  Result := '';
  for i := 1 to Length(Url) do
  begin
    case Url[i] of
      'A'..'Z', 'a'..'z', '0'..'9', '-', '_', '.':
        Result := Result + Url[i];
    else
        Result := Result + '%' + IntToHex(Ord(Url[i]), 2);
    end;
  end;
end;

{
function SockAddrToString(pAddr: LPSOCKADDR; AddrSize: DWORD): String;
var
  Buf: array[0..40] of Char;
  Len: DWORD;
begin
  Result := '';
  Len := Length(Buf);
  if WSAAddressToString(pAddr, AddrSize, nil, Buf, Len) = 0 then
    SetString(Result, Buf, Len-1);
end;   }

procedure WinInetCheck(Success: Boolean; aFunction: PChar);
var
  ErrorCode : Integer;
begin
  if not Success then
  begin
    ErrorCode := GetLastError;
    raise Exception.CreateFmt('%s Error %d: %s', [aFunction, ErrorCode, GetWinInetError(ErrorCode)]);
  end;
end;

procedure WebPostData(const UserAgent: string; const Server: string;
                                            const Resource: string; const Data: AnsiString); //overload;
var
  hInet: HINTERNET;
  hHTTP: HINTERNET;
  hReq: HINTERNET;
const
  accept: packed array[0..1] of LPWSTR = (('*/*'), nil);
  header: string = 'Content-Type: application/x-www-form-urlencoded';
begin
  hInet:= InternetOpen(PChar(UserAgent), INTERNET_OPEN_TYPE_PRECONFIG, nil, nil, 0);
  try
    hHTTP:= InternetConnect(hInet,PChar(Server),INTERNET_DEFAULT_HTTP_PORT, nil, nil, INTERNET_SERVICE_HTTP, 0, 1);
    try
      hReq:= HttpOpenRequest(hHTTP, PChar('POST'), 
        PChar(Resource), nil, nil, @accept, 0, 1);
      try
        if not HttpSendRequest(hReq, PChar(header), length(header), PChar(Data), 
        length(Data)) then
          raise Exception.Create('HttpOpenRequest failed. ' + 
          SysErrorMessage(GetLastError));
      finally
        InternetCloseHandle(hReq);
      end;
    finally
      InternetCloseHandle(hHTTP);
    end;
  finally
    InternetCloseHandle(hInet);
  end;
end;

function WebGetData(const UserAgent: string; const Server: string; const Resource: string): string;
var
  hInet: HINTERNET;
  hURL: HINTERNET;
  Buffer: array[0..1023] of AnsiChar;
  i, BufferLen: cardinal;
begin
  result := '';
  hInet := InternetOpen(PChar(UserAgent), INTERNET_OPEN_TYPE_PRECONFIG, nil, nil, 0);
  try
    hURL := InternetOpenUrl(hInet, PChar('http://' + Server + Resource), nil, 0, 0, 0);
    try
      repeat
        InternetReadFile(hURL, @Buffer, SizeOf(Buffer), BufferLen);
        if BufferLen = SizeOf(Buffer) then
          result := result + AnsiString(Buffer)
        else if BufferLen > 0 then
          for i := 0 to BufferLen - 1 do
            result := result + Buffer[i];
      until BufferLen = 0;
    finally
      InternetCloseHandle(hURL);
    end;
  finally
    InternetCloseHandle(hInet);
  end;
end;


{
+++ German: ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Diese Prozedur ermöglich das Löschen eines Protokolls.
Vorsicht: AUCH HTTP FTP HTTPS können gelöscht werden!!!
+++ English: +++++++++++++++++++++++++++++++++++++++++++++++++++++++++
This procedure allows you to delete a protocol again.
Attention: HTTP FTP HTTPS can also be deleted.
}

procedure UnregisterProtocol(const Name: string);
var 
  reg: TRegistry;
begin
  reg := TRegistry.Create;
  try
    reg.RootKey := HKEY_CLASSES_ROOT;
    reg.DeleteKey(Name);
  finally
    reg.Free;
  end;
end;

function GetNetworkConnections: string;
var
  i, dwResult: DWORD;
  hEnum: THandle;
  lpnrDrv: PNETRESOURCE;
  s: string;
var
  cbBuffer: DWORD; // = 16384;
  cEntries: DWORD; // = $FFFFFFFF;
begin
 cbBuffer:= 16384;
 cEntries:= $FFFFFFFF;
  dwResult := WNetOpenEnum(RESOURCE_CONNECTED,
    RESOURCETYPE_ANY,
    0,
    nil,
    hEnum);

  if (dwResult <> NO_ERROR) then begin
    result:= ('Cannot enumerate network drives.');
    Exit;
  end;
  s := '';
  repeat
    lpnrDrv  := PNETRESOURCE(GlobalAlloc(GPTR, cbBuffer));
    dwResult := WNetEnumResource(hEnum, cEntries, lpnrDrv, cbBuffer);
    if (dwResult = NO_ERROR) then begin
      s := 'Network drives:'#13#10;
      for i := 0 to cEntries - 1 do begin
        if lpnrDrv^.lpLocalName <> nil then
          s := s + lpnrDrv^.lpLocalName + #9 + lpnrDrv^.lpRemoteName+' -';
        Inc(lpnrDrv);
      end;
    end
    else if dwResult <> ERROR_NO_MORE_ITEMS then begin
      s := s + 'Cannot complete network drive enumeration';
      GlobalFree(HGLOBAL(lpnrDrv));
      break;
    end;
    GlobalFree(HGLOBAL(lpnrDrv));
  until (dwResult = ERROR_NO_MORE_ITEMS);
  WNetCloseEnum(hEnum);
  if s = '' then s := 'No network connections.';
  result:=  (s);
end;

procedure SetSynchroTime;
var mySTime: TIdSNTP;
begin
  mySTime:= TIdSNTP.create(nil);
  try
    //mySTime.host:='0.debian.pool.ntp.org'
    mySTime.host:='pool.ntp.org';
      //writeln('the internettime '+
    //datetimetoStr(mystime.datetime));
    if mySTime.Synctime then
      maxForm1.memo2.lines.Add('operating system sync now!');
  finally
    mySTime.free;
    maxForm1.memo2.lines.Add('System time is now sync with the internet time '+TimeToStr(time))
  end;
end;

procedure ParseString(s,sep: string; sl: TStrings);
var p,i,last: integer;
begin
  sl.Clear;
  last:=1;
  for i:=1 to length(s) do begin
    p:=Pos(s[i],sep);
    if p>0 then begin
      if i<>last then
        sl.add(copy(s,last,i-last));
      last:=i+1;
    end;
  end;
  if last<=length(s) then
    sl.add(copy(s,last,length(s)-last+1));
end;

procedure LoadGridFromfile(SG: TStringGrid; fname: string);
var SL: TStringList;
    i, icol, tabpos, ntp: integer;
    s, sub: string;
begin
  sub := #9;
  SL := TStringList.Create;
  try
    SL.LoadFromFile(fname);
    for i:=0 to SL.Count-1 do begin
      if i >= SG.RowCount then break;
      icol := 0;
      ntp := 1;
      tabpos := 1;
      while ntp <> 0 do begin
        ntp := PosEx(sub, SL.Strings[i], tabpos);
        if ntp = 0 then begin
          s := copy(SL.Strings[i], tabpos, length(SL.Strings[i]) - tabpos + 1);
        end else begin
          s := copy(SL.Strings[i], tabpos, ntp - tabpos);
        end;
        tabpos := ntp + 1;
        if icol >= SG.colCount then break;
        SG.Cells[icol, i] := trim(s);
        inc(icol);
      end;
    end;
  finally
    SL.Free;
  end;
end;

procedure SaveGridTofile(SG: TStringGrid; fname: string);
var SL: TStringList;
    i, icol: integer;
    s, sub: string;
begin
  sub := #9;
  SL := TStringList.Create;
  try
    for i:=0 to SG.RowCount-1 do begin
      s := SG.Cells[0, i];
      for iCol:=1 to SG.ColCount-1 do begin
        s := s + sub + SG.Cells[icol, i];
      end;
      SL.Add(s);
    end;
    SL.SaveToFile(fname);
  finally
    SL.Free;
  end;
end;

procedure WriteStringToGrid(SG: TStringGrid; vname: string; icol: longword; wval: string);
var i: integer;
begin
  if icol >= longword(SG.ColCount) then exit;
  for i := 0  to SG.RowCount-1 do begin
    if SG.Cells[0, i] = vname then begin
      SG.Cells[icol, i] := wval;
      exit;
    end;
  end;
end;


procedure WriteFloatToGrid(SG: TStringGrid; vname: string; icol: longword; wval: double);
begin
  WriteStringToGrid(SG, vname, icol, format('%.5g',[wval]));
end;

function DateTimeToISOTimeStamp(const dateTime: TDateTime): string;
var
  fs: TFormatSettings;
begin
  fs.TimeSeparator := ':';
  Result := FormatDateTime('yyyy-mm-dd hh:nn:ss', dateTime, fs);
end;

function DateToISODate(const date: TDateTime): string;
begin
  Result := FormatDateTime('YYYY-MM-DD', date);
end;

function TimeToISOTime(const time: TTime): string;
var
  fs: TFormatSettings;
begin
  fs.TimeSeparator := ':';
  Result := FormatDateTime('hh:nn:ss', time, fs);
end;

function ISOTimeStampToDateTime(const dateTime: string): TDateTime;
begin
  Result := EncodeDateTime(StrToInt(Copy(dateTime, 1, 4)), StrToInt(Copy(dateTime, 6, 2)), StrToInt(Copy(dateTime, 9, 2)),
    StrToInt(Copy(dateTime, 12, 2)), StrToInt(Copy(dateTime, 15, 2)), StrToInt(Copy(dateTime, 18, 2)), 0);
end;

function ISODateToDate(const date: string): TDate;
begin
  Result := EncodeDate(StrToInt(Copy(date, 1, 4)), StrToInt(Copy(date, 6, 2)), StrToInt(Copy(date, 9, 2)));
end;

function ISOTimeToTime(const time: string): TTime;
begin
  Result := EncodeTime(StrToInt(Copy(time, 1, 2)), StrToInt(Copy(time, 4, 2)), StrToInt(Copy(time, 7, 2)), 0);
end;

function NewDataSetField(dataSet: TDataSet; const fieldType: TFieldType; const fieldName: string;
  const size: Integer = 0; const origin: string = ''; const displaylabel: string = ''): TField;
begin
  Result := DefaultFieldClasses[fieldType].Create(dataSet);
  Result.FieldName := fieldName;

  if (Result.FieldName = '') then
    Result.FieldName := 'Field' + IntToStr(dataSet.FieldCount + 1);

  Result.FieldKind := fkData;
  Result.DataSet := dataSet;
  Result.Name := MakeValidIdent(dataSet.Name + Result.FieldName);
  Result.Size := size;
  Result.Origin := origin;
  //if not(displaylabel.IsEmpty) then
    Result.DisplayLabel := displaylabel;

  if (fieldType in [ftString, ftWideString]) and (size <= 0) then
    raise EDataSetConverterException.CreateFmt('Size not defined for field "%s".', [fieldName]);
end;

{function BooleanToJSON(const value: Boolean): TJSONValue;
begin
  if value then
    Result := TJSONTrue.Create
  else
    Result := TJSONFalse.Create;
end; }

function BooleanFieldToType(const booleanField: TBooleanField): TBooleanFieldType;
const
  DESC_BOOLEAN_FIELD_TYPE: array [TBooleanFieldType] of string = ('Unknown', 'Boolean', 'Integer');
var
  index: Integer;
  origin: string;
begin
  Result := bfUnknown;
  origin := Trim(booleanField.Origin);
  for index := Ord(Low(TBooleanFieldType)) to Ord(High(TBooleanFieldType)) do
    if (LowerCase(DESC_BOOLEAN_FIELD_TYPE[TBooleanFieldType(index)]) = LowerCase(origin)) then begin
      result:= TBooleanFieldType(index);
      Exit;
    end;

end;

function DataSetFieldToType(const dataSetField: TDataSetField): TDataSetFieldType;
const
  DESC_DATASET_FIELD_TYPE: array [TDataSetFieldType] of string = ('Unknown', 'JSONObject', 'JSONArray');
var
  index: Integer;
  origin: string;
begin
  Result := dfUnknown;
  origin := Trim(dataSetField.Origin);
  for index := Ord(Low(TDataSetFieldType)) to Ord(High(TDataSetFieldType)) do
    if (LowerCase(DESC_DATASET_FIELD_TYPE[TDataSetFieldType(index)]) = LowerCase(origin)) then begin
      result:= TDataSetFieldType(index);
      Exit;
    end;
end;

Function CharInSet4(C: AnsiChar; const CharSet: TSysCharSet):Bool;
begin
  Result:= C in CharSet;
end;

function MakeValidIdent(const s: string): string;
var
  x: Integer;
  c: Char;
begin
  SetLength(Result, Length(s));
  x := 0;

  for c in s do begin
    if CharInSet4(c, ['A'..'Z', 'a'..'z', '0'..'9', '_']) then begin
      Inc(x);
      Result[x] := c;
    end;
  end;

  SetLength(Result, x);

  if x = 0 then
    Result := '_'
  else if CharInSet4(Result[1], ['0'..'9']) then
    Result := '_' + Result;
end;

{procedure WriteVectorToGrid(SG: TStringGrid; vname: string; wval: TAffineVector);
var i: integer;
begin
  for i := 0  to SG.RowCount-1 do begin
    if SG.Cells[0, i] = vname then begin
      SG.Cells[1, i] := format('%.5g',[wval.v[0]]);
      SG.Cells[2, i] := format('%.5g',[wval.v[1]]);
      SG.Cells[3, i] := format('%.5g',[wval.v[2]]);
      exit;
    end;
  end;
end;  }

function FloatAsInteger(X: single): integer;
begin
  result := PInteger(@X)^;
end;

function IntegerAsFloat(X: integer): single;
begin
  result := PSingle(@X)^;
end;


(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TAzuliaHTML(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TComponent', 'TAzuliaHTML') do
  with CL.AddClassN(CL.FindClass('TComponent'),'TAzuliaHTML') do
  begin
    RegisterMethod('Function HeadTop(Title : string) : string');
    RegisterMethod('Function HeadClose : string');
    RegisterMethod('Function BodyTop(LeftMargin,RightMargin:Integer;TextColor,LinkColor,VisitedLinkColor,ActiveLinkColor,BackgroundColor,BackgroundImage:string;FixedBackground:bool;Extra:string):string');
    RegisterMethod('Function BodyClose: string');
    RegisterMethod('Function ConvertDOSPathToHTML( WindowsPath : string) : string');
    RegisterMethod('Function ConvertHTMLPathToDOS( WindowsPath : string) : string');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TAzuliaDisk(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TComponent', 'TAzuliaDisk') do
  with CL.AddClassN(CL.FindClass('TComponent'),'TAzuliaDisk') do
  begin
    RegisterMethod('Function GetDiskLabel( Drive : char) : string');
    RegisterMethod('Function GetDiskSerial( Drive : char) : string');
    RegisterMethod('Function GetDiskFileSystem( Drive : char) : string');
    RegisterMethod('Function GetDiskType( Drive : char) : integer');
    RegisterMethod('Function GetDiskFlags( Drive : char) : integer');
    RegisterMethod('Procedure ChangeDiskLabel( Drive : char; NewLabel : string)');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TAzuliaSpeaker(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TComponent', 'TAzuliaSpeaker') do
  with CL.AddClassN(CL.FindClass('TComponent'),'TAzuliaSpeaker') do
  begin
    RegisterMethod('Procedure Delay( MSecs : Integer)');
    RegisterMethod('Procedure Play( Freq : Word; MSecs : Integer)');
    RegisterMethod('Procedure Stop');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TAzuliaFiles(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOBJECT', 'TAzuliaFiles') do
  with CL.AddClassN(CL.FindClass('TOBJECT'),'TAzuliaFiles') do
  begin
    RegisterMethod('Procedure FindRecursive( const path : string; const mask : string; LogFunction : TLogFunct; Re_curse : Boolean)');
    RegisterMethod('Procedure SearchFileExt( const Dir, Ext : string; Files : TStrings)');
    RegisterMethod('Function GetFileSize( const FileName : string) : LongInt');
    RegisterMethod('Function GetKBFileSize( FileSize : integer) : string');
    RegisterMethod('Function LongToShortFilename( LongFilename : string) : string');
    RegisterMethod('Function ShortToLongFilename( LongFilename : string) : string');
    RegisterMethod('Procedure AppendDataToFilename( Filename, Data : string)');
    RegisterMethod('Procedure SaveDataToFilename( Filename, Data : string)');
    RegisterMethod('Procedure CopyFile( const FileName, DestName : string)');
    RegisterMethod('Procedure MoveFile( const FileName, DestName : string)');
    RegisterMethod('Function HasAttr( const FileName : string; Attr : Word) : Boolean');
    RegisterMethod('Function ExecuteFile( const FileName, Params, DefaultDir : string; ShowCmd : Integer) : THandle');
    RegisterMethod('Function GetWindowsDir : string');
    RegisterMethod('Function GetTempDir : string');
    RegisterMethod('Function GetINIString( Section, Ident, DefaultString, Filename : string) : string');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TAzuliaStrings(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOBJECT', 'TAzuliaStrings') do
  with CL.AddClassN(CL.FindClass('TOBJECT'),'TAzuliaStrings') do
  begin
    RegisterMethod('Function NPos(C : Char; S : string; N : Byte) : Byte');
    RegisterMethod('Function IntToRoman( Value : Longint) : string');
    RegisterMethod('Function RomanToInt( const S : string) : Longint');
    RegisterMethod('Function GetDirFromStr( DirectoryString : string; IndexFromRight : integer) : string');
    RegisterMethod('Function RemoveChars( InputString : string; CharToRemove : Char) : string');
    RegisterMethod('Function GetStringFromGarbage( InputString : string; Index : integer) : string');
    RegisterMethod('Function SplitupWithGarbage( InputString : string; CommonSplitter : char) : string');
    RegisterMethod('Function GetCount( Character : char; InputString : string) : integer');
    RegisterMethod('Function RemoveTrailingChars( StringToRemoveFrom : string; Trailer : char) : string');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TSystemRegistry(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOBJECT', 'TSystemRegistry') do
  with CL.AddClassN(CL.FindClass('TOBJECT'),'TSystemRegistry') do
  begin
    RegisterMethod('Function GetStringFromRegistry( Root : integer; Key, Value : string) : string');
    RegisterMethod('Function SaveStringToRegistry( Root : integer; Key, Value, Name : string) : bool');
    RegisterMethod('Procedure ToggleBinaryValue( RootKey : integer; Path, Key : string)');
    RegisterMethod('Procedure DeleteValueInRegistry( RootKey : integer; Path, Name : string)');
    RegisterMethod('Procedure RenameValueInRegistry( RootKey : integer; Path, OldName, NewName : string)');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TBrowseForFolderDialog(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOBJECT', 'TBrowseForFolderDialog') do
  with CL.AddClassN(CL.FindClass('TOBJECT'),'TBrowseForFolderDialog') do
  begin
    RegisterProperty('Title', 'string', iptrw);
    RegisterMethod('Function Execute : Boolean');
    RegisterProperty('Path', 'string', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_IShellLink(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOBJECT', 'IShellLink') do
  with CL.AddClassN(CL.FindClass('TOBJECT'),'IShellLink') do
  begin
    RegisterMethod('Function GetPath( pszFile : LPSTR; cchMaxPath : integer; var pfd : TWin32FindData; fFlags : DWORD) : HResult');
    RegisterMethod('Function GetIDList( var ppidl : PITEMIDLIST) : HResult');
    RegisterMethod('Function SetIDList( pidl : PITEMIDLIST) : HResult');
    RegisterMethod('Function GetDescription( pszName : LPSTR; cchMaxName : integer) : HResult');
    RegisterMethod('Function SetDescription( pszName : LPSTR) : HResult');
    RegisterMethod('Function GetWorkingDirectory( pszDir : LPSTR; cchMaxPath : integer) : HResult');
    RegisterMethod('Function SetWorkingDirectory( pszDir : LPSTR) : HResult');
    RegisterMethod('Function GetArguments( pszArgs : LPSTR; cchMaxPath : integer) : HResult');
    RegisterMethod('Function SetArguments( pszArgs : LPSTR) : HResult');
    RegisterMethod('Function GetHotkey( var pwHotkey : word) : HResult');
    RegisterMethod('Function SetHotkey( wHotkey : word) : HResult');
    RegisterMethod('Function GetShowCmd( var piShowCmd : integer) : HResult');
    RegisterMethod('Function SetShowCmd( iShowCmd : integer) : HResult');
    RegisterMethod('Function GetIconLocation( pszIconPath : LPSTR; cchIconPath : integer; var piIcon : integer) : HResult');
    RegisterMethod('Function SetIconLocation( pszIconPath : LPSTR; iIcon : integer) : HResult');
    RegisterMethod('Function SetRelativePath( pszPathRel : LPSTR; dwReserved : DWORD) : HResult');
    RegisterMethod('Function Resolve( Wnd : HWND; fFlags : DWORD) : HResult');
    RegisterMethod('Function SetPath( pszFile : LPSTR) : HResult');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_AzuliaUtils(CL: TPSPascalCompiler);
begin
  CL.AddTypeS('azucharSet', 'set of char');
  SIRegister_IShellLink(CL);
  SIRegister_TBrowseForFolderDialog(CL);
  SIRegister_TSystemRegistry(CL);
  SIRegister_TAzuliaStrings(CL);
  CL.AddTypeS('TLogFunct', 'Function ( const path : string; const SRec : TSearchRec) : Boolean');
  SIRegister_TAzuliaFiles(CL);
  SIRegister_TAzuliaSpeaker(CL);
  SIRegister_TAzuliaDisk(CL);
  SIRegister_TAzuliaHTML(CL);
  CL.AddTypeS('GrabType', '( GTSCREEN, GTWINDOW, GTCLIENT )');
  CL.AddTypeS('TBooleanFieldType', '( bftUnknown, bftBoolean, bftInteger )');
  CL.AddTypeS('TDataSetFieldType', '( dftUnknown, dftJSONObject, dftJSONArray )');
  //TBooleanFieldType = (bfUnknown, bfBoolean, bfInteger);
  //TDataSetFieldType = (dfUnknown, dfJSONObject, dfJSONArray);

  CL.AddClassN(CL.FindClass('TOBJECT'),'EInvalidDest');
  CL.AddClassN(CL.FindClass('TOBJECT'),'EFCantMove');
 CL.AddDelphiFunction('Function azuBoolToStr( value : boolean) : string');
 CL.AddDelphiFunction('Procedure azuChangeWallpaper( FName : string; IsTiled, IsStretch : Boolean)');
 CL.AddDelphiFunction('Function azuDoIExist( WndTitle : string) : Boolean');
 CL.AddDelphiFunction('Procedure azuAlert( Text : string)');
 CL.AddDelphiFunction('Procedure azuTileImage( SourceImage, DestImage : TImage)');
 CL.AddDelphiFunction('Function azuIncChar( iX : Char) : Char');
 CL.AddDelphiFunction('Function azuDecChar( iX : Char) : Char');
 CL.AddDelphiFunction('Procedure azuSaveForm( F : TForm; Filename : string)');
 CL.AddDelphiFunction('Procedure azuLoadForm( F : TForm; Filename : string)');
 CL.AddDelphiFunction('Function azuToggleBool( totoggle : bool) : bool');
 CL.AddDelphiFunction('Function azuremoveTrailingChars( const s : string; chars : azucharSet) : string');
 CL.AddDelphiFunction('Function azuremoveLeadChars( const s : string; chars : azucharSet) : string');
 CL.AddDelphiFunction('Function azuremoveChars( const s : string; chars : char) : string');
 CL.AddDelphiFunction('Procedure azuDelay( MSecs : Integer)');
 CL.AddDelphiFunction('Function azuSHBrowseDialog( title : string; Handle : integer) : string');
 CL.AddDelphiFunction('Procedure azuregisterfiletype( Extention, REGDesc, UserDesc, Icon, Appl : string)');
 CL.AddDelphiFunction('Procedure azuRemoveFileType( Extention, RegDesc : string)');
 CL.AddDelphiFunction('Procedure azuGetFunctionNamesFromDLL( DLLName : string; List : TStrings)');
 CL.AddDelphiFunction('Procedure azuSaveListViewToFile( AListView : TListView; sFileName : string)');
 CL.AddDelphiFunction('Procedure azuLoadListViewToFile( AListView : TListView; sFileName : string)');
 CL.AddDelphiFunction('Procedure azuLoadCSV( Filename : string; sg : TStringGrid)');
 CL.AddDelphiFunction('Function azuJPEGDimensions( Filename : string; var X, Y : Word) : boolean');
 CL.AddDelphiFunction('Procedure azuResizeImage( FileName : string; MaxWidth : Integer)');
 CL.AddDelphiFunction('Function azuSaveJPEGPictureFile( Bitmap : TBitmap; FilePath, FileName : string; Quality : Integer) : Boolean');
 CL.AddDelphiFunction('Function azuLoadJPEGPictureFile( Bitmap : TBitmap; FilePath, FileName : string) : Boolean');
 CL.AddDelphiFunction('Procedure azuSmoothResize( Src, Dst : TBitmap)');
 CL.AddDelphiFunction('Function azuMsecToStr( Milli : Cardinal) : string');
 CL.AddDelphiFunction('Procedure azuDirToStrings( APath : string; AStrings : TStrings; WithExt, WithPath : boolean)');
 CL.AddDelphiFunction('Procedure azuSetWallPaper( ImageFileName : string; IsTiled : boolean)');
 CL.AddDelphiFunction('Function azuGetFileSize( FileName : string) : int64');
 CL.AddDelphiFunction('Function azuGetExeByExtension( sExt : string) : string');
 CL.AddDelphiFunction('Function azuRefreshScreenIcons : Boolean');
 CL.AddDelphiFunction('Function azuIndexToColor( AIndex : integer) : TColor');
 CL.AddDelphiFunction('Function azuColorToIndex( AColor : TColor) : integer');
 CL.AddDelphiFunction('Function azuTitleCase( Text2 : string) : string');
 CL.AddDelphiFunction('Function azuToggleCase( Text2 : string) : string');
 CL.AddDelphiFunction('Function azuSentenceCase( Text2 : string) : string');
 CL.AddDelphiFunction('Procedure azuGrabScreen( bm : TBitMap; gt : GrabType)');
 CL.AddDelphiFunction('Procedure azuSaveStringGrid( StringGrid : TStringGrid; FileName : String)');
 CL.AddDelphiFunction('Procedure azuLoadStringGrid( StringGrid : TStringGrid; FileName : String)');
 CL.AddDelphiFunction('Function azuGetInetFile( const fileURL, FileName : String) : boolean');
 CL.AddDelphiFunction('Procedure azuRunOnStartup( sProgTitle, sCmdLine : string; bRunOnce : boolean)');
 CL.AddDelphiFunction('Procedure azuRemoveOnStartup( sProgTitle : string)');
 CL.AddDelphiFunction('procedure RegisterProtocol(const Name, Describtion, ExecuteStr: string)');
 CL.AddDelphiFunction('procedure UnregisterProtocol(const Name: string);');
 CL.AddDelphiFunction('function GetNetworkConnections: string;');
 CL.AddDelphiFunction('function GetNetworkDrives: string;');
  CL.AddDelphiFunction('procedure SetSynchroTime');
 CL.AddDelphiFunction('procedure letSynchroTime');
 CL.AddDelphiFunction('procedure TimeSync');

 CL.AddDelphiFunction('procedure ParseString4(s,sep: string; sl: TStrings);');
 CL.AddDelphiFunction('procedure LoadGridFromfile(SG: TStringGrid; fname: string);');
 CL.AddDelphiFunction('procedure SaveGridTofile(SG: TStringGrid; fname: string);');
 //CL.AddDelphiFunction('procedure WriteVectorToGrid(SG: TStringGrid; vname: string; wval: TAffineVector);
 CL.AddDelphiFunction('procedure WriteStringToGrid(SG: TStringGrid; vname: string; icol: longword; wval: string);');
 CL.AddDelphiFunction('procedure WriteFloatToGrid(SG: TStringGrid; vname: string; icol: longword; wval: double);');
 CL.AddDelphiFunction('function FloatAsInteger(X: single): integer;');
 CL.AddDelphiFunction('function IntegerAsFloat(X: integer): single;');
 CL.AddDelphiFunction('function HttpGetDirect(const Url: string): string;');
 CL.AddDelphiFunction('function HttpGetDirect2(const Url: string): string;');
 CL.AddDelphiFunction('function HttpGet_Direct(const Url: string): string;');
 CL.AddDelphiFunction('function wininet_HttpGetDirect(const Url: string): string;');
 CL.AddDelphiFunction('function HttpsGet_Direct(const Url: string): string;');
 CL.AddDelphiFunction('function HttpGetDirect4(const Url, agent: string): string;');
 CL.AddDelphiFunction('function HttpGetDirect3(const ServerName,Resource, sUserAgent:string;Var Response:AnsiString):Integer;');
 CL.AddDelphiFunction('function GetWinInetError(ErrorCode:Cardinal): string;');
 CL.AddDelphiFunction('procedure WinInetCheck(Success: Boolean; aFunction: PChar);');
 CL.AddDelphiFunction('procedure WebPostData(const UserAgent:string; const Server:string; const Resource:string; const Data: AnsiString);');
 CL.AddDelphiFunction('function WebGetData(const UserAgent: string; const Server: string; const Resource: string): string;');//overload;

 CL.AddDelphiFunction('Function DateTimeToISOTimeStamp( const dateTime : TDateTime) : string');
 CL.AddDelphiFunction('Function DateToISODate( const date : TDateTime) : string');
 CL.AddDelphiFunction('Function TimeToISOTime( const time : TTime) : string');
 CL.AddDelphiFunction('Function ISOTimeStampToDateTime( const dateTime : string) : TDateTime');
 CL.AddDelphiFunction('Function ISODateToDate( const date : string) : TDate');
 CL.AddDelphiFunction('Function ISOTimeToTime( const time : string) : TTime');
 CL.AddDelphiFunction('Function NewDataSetField( dataSet : TDataSet; const fieldType : TFieldType; const fieldName : string; const size : Integer; const origin : string; const displaylabel : string) : TField');
 //CL.AddDelphiFunction('Function BooleanToJSON( const value : Boolean) : TJSONValue');
 CL.AddDelphiFunction('Function BooleanFieldToType( const booleanField : TBooleanField) : TBooleanFieldType');
 CL.AddDelphiFunction('Function DataSetFieldToType( const dataSetField : TDataSetField) : TDataSetFieldType');
 CL.AddDelphiFunction('Function MakeValidIdent( const s : string) : string');
 CL.AddDelphiFunction('function URLEncode3(const Url: string): string;');


 CL.AddConstantN('SInvalidDest','String').SetString( 'Destination %s does not exist');
 CL.AddConstantN('SFCantMove','String').SetString( 'Cannot move file %s');
 CL.AddConstantN('AzuMsg1','String').SetString( 'File "%s" does not exist!');
 CL.AddConstantN('AzuMsg2','String').SetString( '"%s" is not a ListView file!');
 CL.AddConstantN('sr_WindowMetrics','String').SetString( 'Control Panel\Desktop\WindowMetrics\');
 CL.AddConstantN('sr_ShellIconSize','String').SetString( 'Shell Icon Size');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TBrowseForFolderDialogPath_R(Self: TBrowseForFolderDialog; var T: string);
begin T := Self.Path; end;

(*----------------------------------------------------------------------------*)
procedure TBrowseForFolderDialogTitle_W(Self: TBrowseForFolderDialog; const T: string);
begin Self.Title := T; end;

(*----------------------------------------------------------------------------*)
procedure TBrowseForFolderDialogTitle_R(Self: TBrowseForFolderDialog; var T: string);
begin T := Self.Title; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_AzuliaUtils_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@BoolToStr, 'azuBoolToStr', cdRegister);
 S.RegisterDelphiFunction(@ChangeWallpaper, 'azuChangeWallpaper', cdRegister);
 S.RegisterDelphiFunction(@DoIExist, 'azuDoIExist', cdRegister);
 S.RegisterDelphiFunction(@Alert, 'azuAlert', cdRegister);
 S.RegisterDelphiFunction(@TileImage, 'azuTileImage', cdRegister);
 S.RegisterDelphiFunction(@IncChar, 'azuIncChar', cdRegister);
 S.RegisterDelphiFunction(@DecChar, 'azuDecChar', cdRegister);
 S.RegisterDelphiFunction(@SaveForm, 'azuSaveForm', cdRegister);
 S.RegisterDelphiFunction(@LoadForm, 'azuLoadForm', cdRegister);
 S.RegisterDelphiFunction(@ToggleBool, 'azuToggleBool', cdRegister);
 S.RegisterDelphiFunction(@removeTrailingChars, 'azuremoveTrailingChars', cdRegister);
 S.RegisterDelphiFunction(@removeLeadChars, 'azuremoveLeadChars', cdRegister);
 S.RegisterDelphiFunction(@removeChars, 'azuremoveChars', cdRegister);
 S.RegisterDelphiFunction(@Delay, 'azuDelay', cdRegister);
 S.RegisterDelphiFunction(@SHBrowseDialog, 'azuSHBrowseDialog', cdRegister);
 S.RegisterDelphiFunction(@registerfiletype, 'azuregisterfiletype', cdRegister);
 S.RegisterDelphiFunction(@RemoveFileType, 'azuRemoveFileType', cdRegister);
 S.RegisterDelphiFunction(@GetFunctionNamesFromDLL, 'azuGetFunctionNamesFromDLL', cdRegister);
 S.RegisterDelphiFunction(@SaveListViewToFile, 'azuSaveListViewToFile', cdRegister);
 S.RegisterDelphiFunction(@LoadListViewToFile, 'azuLoadListViewToFile', cdRegister);
 S.RegisterDelphiFunction(@LoadCSV, 'azuLoadCSV', cdRegister);
 S.RegisterDelphiFunction(@JPEGDimensions, 'azuJPEGDimensions', cdRegister);
 S.RegisterDelphiFunction(@ResizeImage, 'azuResizeImage', cdRegister);
 S.RegisterDelphiFunction(@SaveJPEGPictureFile, 'azuSaveJPEGPictureFile', cdRegister);
 S.RegisterDelphiFunction(@LoadJPEGPictureFile, 'azuLoadJPEGPictureFile', cdRegister);
 S.RegisterDelphiFunction(@SmoothResize, 'azuSmoothResize', cdRegister);
 S.RegisterDelphiFunction(@MsecToStr, 'azuMsecToStr', cdRegister);
 S.RegisterDelphiFunction(@DirToStrings, 'azuDirToStrings', cdRegister);
 S.RegisterDelphiFunction(@SetWallPaper, 'azuSetWallPaper', cdRegister);
 S.RegisterDelphiFunction(@GetFileSize, 'azuGetFileSize', cdRegister);
 S.RegisterDelphiFunction(@GetExeByExtension, 'azuGetExeByExtension', cdRegister);
 S.RegisterDelphiFunction(@RefreshScreenIcons, 'azuRefreshScreenIcons', cdRegister);
 S.RegisterDelphiFunction(@IndexToColor, 'azuIndexToColor', cdRegister);
 S.RegisterDelphiFunction(@ColorToIndex, 'azuColorToIndex', cdRegister);
 S.RegisterDelphiFunction(@TitleCase, 'azuTitleCase', cdRegister);
 S.RegisterDelphiFunction(@ToggleCase, 'azuToggleCase', cdRegister);
 S.RegisterDelphiFunction(@SentenceCase, 'azuSentenceCase', cdRegister);
 S.RegisterDelphiFunction(@GrabScreen, 'azuGrabScreen', cdRegister);
 S.RegisterDelphiFunction(@SaveStringGrid, 'azuSaveStringGrid', cdRegister);
 S.RegisterDelphiFunction(@LoadStringGrid, 'azuLoadStringGrid', cdRegister);
 S.RegisterDelphiFunction(@GetInetFile, 'azuGetInetFile', cdRegister);
 S.RegisterDelphiFunction(@RunOnStartup, 'azuRunOnStartup', cdRegister);
 S.RegisterDelphiFunction(@RemoveOnStartup, 'azuRemoveOnStartup', cdRegister);
 S.RegisterDelphiFunction(@RegisterProtocol, 'RegisterProtocol', cdRegister);
 S.RegisterDelphiFunction(@UnRegisterProtocol, 'UnRegisterProtocol', cdRegister);
 S.RegisterDelphiFunction(@GetNetworkConnections, 'GetNetworkConnections', cdRegister);
 S.RegisterDelphiFunction(@GetNetworkConnections, 'GetNetworkDrives', cdRegister);
 S.RegisterDelphiFunction(@SetSynchroTime, 'SetSynchroTime', cdRegister);
 S.RegisterDelphiFunction(@SetSynchroTime, 'letSynchroTime', cdRegister);
 S.RegisterDelphiFunction(@SetSynchroTime, 'timesync', cdRegister);
 S.RegisterDelphiFunction(@ParseString, 'ParseString4', cdRegister);
 S.RegisterDelphiFunction(@LoadGridFromfile, 'LoadGridFromfile', cdRegister);
 S.RegisterDelphiFunction(@SaveGridTofile, 'SaveGridTofile', cdRegister);
 S.RegisterDelphiFunction(@WriteStringToGrid, 'WriteStringToGrid', cdRegister);
 S.RegisterDelphiFunction(@WriteFloatToGrid, 'WriteFloatToGrid', cdRegister);
 S.RegisterDelphiFunction(@FloatAsInteger, 'FloatAsInteger', cdRegister);
 S.RegisterDelphiFunction(@IntegerAsFloat, 'IntegerAsFloat', cdRegister);
 S.RegisterDelphiFunction(@HttpGetDirect, 'HttpGetDirect', cdRegister);
 S.RegisterDelphiFunction(@HttpGetDirect, 'HttpGet_Direct', cdRegister);
 S.RegisterDelphiFunction(@HttpGetDirect, 'wininet_HttpGetDirect', cdRegister);
 S.RegisterDelphiFunction(@HttpGetDirect, 'HttpsGet_Direct', cdRegister);
 S.RegisterDelphiFunction(@GetUrlContent, 'HttpGetDirect2', cdRegister);
 S.RegisterDelphiFunction(@HttpGetDirect4, 'HttpGetDirect4', cdRegister);
 S.RegisterDelphiFunction(@HttpGetDirect3, 'HttpGetDirect3', cdRegister);
 S.RegisterDelphiFunction(@GetWinInetError, 'GetWinInetError', cdRegister);
 S.RegisterDelphiFunction(@WinInetCheck, 'WinInetCheck', cdRegister);
 S.RegisterDelphiFunction(@WebPostData, 'WebPostData', cdRegister);
 S.RegisterDelphiFunction(@WebGetData, 'WebGetData', cdRegister);

 // CL.AddDelphiFunction('function HttpGetDirect(const Url: string): string;');
 // CL.AddDelphiFunction('function HttpGet_Direct(const Url: string): string;');
 S.RegisterDelphiFunction(@DateTimeToISOTimeStamp, 'DateTimeToISOTimeStamp', cdRegister);
 S.RegisterDelphiFunction(@DateToISODate, 'DateToISODate', cdRegister);
 S.RegisterDelphiFunction(@TimeToISOTime, 'TimeToISOTime', cdRegister);
 S.RegisterDelphiFunction(@ISOTimeStampToDateTime, 'ISOTimeStampToDateTime', cdRegister);
 S.RegisterDelphiFunction(@ISODateToDate, 'ISODateToDate', cdRegister);
 S.RegisterDelphiFunction(@ISOTimeToTime, 'ISOTimeToTime', cdRegister);
 S.RegisterDelphiFunction(@NewDataSetField, 'NewDataSetField', cdRegister);
 //S.RegisterDelphiFunction(@BooleanToJSON, 'BooleanToJSON', cdRegister);
 S.RegisterDelphiFunction(@BooleanFieldToType, 'BooleanFieldToType', cdRegister);
 S.RegisterDelphiFunction(@DataSetFieldToType, 'DataSetFieldToType', cdRegister);
 S.RegisterDelphiFunction(@MakeValidIdent, 'MakeValidIdent', cdRegister);
 S.RegisterDelphiFunction(@URLEncode3, 'URLEncode3', cdRegister);

 end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TAzuliaHTML(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TAzuliaHTML) do
  begin
    RegisterMethod(@TAzuliaHTML.HeadTop, 'HeadTop');
    RegisterMethod(@TAzuliaHTML.HeadClose, 'HeadClose');
    RegisterMethod(@TAzuliaHTML.BodyTop, 'BodyTop');
    RegisterMethod(@TAzuliaHTML.BodyClose, 'BodyClose');
    RegisterMethod(@TAzuliaHTML.ConvertDOSPathToHTML, 'ConvertDOSPathToHTML');
    RegisterMethod(@TAzuliaHTML.ConvertHTMLPathToDOS, 'ConvertHTMLPathToDOS');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TAzuliaDisk(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TAzuliaDisk) do
  begin
    RegisterMethod(@TAzuliaDisk.GetDiskLabel, 'GetDiskLabel');
    RegisterMethod(@TAzuliaDisk.GetDiskSerial, 'GetDiskSerial');
    RegisterMethod(@TAzuliaDisk.GetDiskFileSystem, 'GetDiskFileSystem');
    RegisterMethod(@TAzuliaDisk.GetDiskType, 'GetDiskType');
    RegisterMethod(@TAzuliaDisk.GetDiskFlags, 'GetDiskFlags');
    RegisterMethod(@TAzuliaDisk.ChangeDiskLabel, 'ChangeDiskLabel');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TAzuliaSpeaker(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TAzuliaSpeaker) do
  begin
    RegisterMethod(@TAzuliaSpeaker.Delay, 'Delay');
    RegisterMethod(@TAzuliaSpeaker.Play, 'Play');
    RegisterMethod(@TAzuliaSpeaker.Stop, 'Stop');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TAzuliaFiles(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TAzuliaFiles) do
  begin
    RegisterMethod(@TAzuliaFiles.FindRecursive, 'FindRecursive');
    RegisterMethod(@TAzuliaFiles.SearchFileExt, 'SearchFileExt');
    RegisterMethod(@TAzuliaFiles.GetFileSize, 'GetFileSize');
    RegisterMethod(@TAzuliaFiles.GetKBFileSize, 'GetKBFileSize');
    RegisterMethod(@TAzuliaFiles.LongToShortFilename, 'LongToShortFilename');
    RegisterMethod(@TAzuliaFiles.ShortToLongFilename, 'ShortToLongFilename');
    RegisterMethod(@TAzuliaFiles.AppendDataToFilename, 'AppendDataToFilename');
    RegisterMethod(@TAzuliaFiles.SaveDataToFilename, 'SaveDataToFilename');
    RegisterMethod(@TAzuliaFiles.CopyFile, 'CopyFile');
    RegisterMethod(@TAzuliaFiles.MoveFile, 'MoveFile');
    RegisterMethod(@TAzuliaFiles.HasAttr, 'HasAttr');
    RegisterMethod(@TAzuliaFiles.ExecuteFile, 'ExecuteFile');
    RegisterMethod(@TAzuliaFiles.GetWindowsDir, 'GetWindowsDir');
    RegisterMethod(@TAzuliaFiles.GetTempDir, 'GetTempDir');
    RegisterMethod(@TAzuliaFiles.GetINIString, 'GetINIString');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TAzuliaStrings(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TAzuliaStrings) do
  begin
    RegisterMethod(@TAzuliaStrings.NPos, 'NPos');
    RegisterMethod(@TAzuliaStrings.IntToRoman, 'IntToRoman');
    RegisterMethod(@TAzuliaStrings.RomanToInt, 'RomanToInt');
    RegisterMethod(@TAzuliaStrings.GetDirFromStr, 'GetDirFromStr');
    RegisterMethod(@TAzuliaStrings.RemoveChars, 'RemoveChars');
    RegisterMethod(@TAzuliaStrings.GetStringFromGarbage, 'GetStringFromGarbage');
    RegisterMethod(@TAzuliaStrings.SplitupWithGarbage, 'SplitupWithGarbage');
    RegisterMethod(@TAzuliaStrings.GetCount, 'GetCount');
    RegisterMethod(@TAzuliaStrings.RemoveTrailingChars, 'RemoveTrailingChars');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TSystemRegistry(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TSystemRegistry) do
  begin
    RegisterMethod(@TSystemRegistry.GetStringFromRegistry, 'GetStringFromRegistry');
    RegisterMethod(@TSystemRegistry.SaveStringToRegistry, 'SaveStringToRegistry');
    RegisterMethod(@TSystemRegistry.ToggleBinaryValue, 'ToggleBinaryValue');
    RegisterMethod(@TSystemRegistry.DeleteValueInRegistry, 'DeleteValueInRegistry');
    RegisterMethod(@TSystemRegistry.RenameValueInRegistry, 'RenameValueInRegistry');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TBrowseForFolderDialog(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TBrowseForFolderDialog) do
  begin
    RegisterPropertyHelper(@TBrowseForFolderDialogTitle_R,@TBrowseForFolderDialogTitle_W,'Title');
    RegisterMethod(@TBrowseForFolderDialog.Execute, 'Execute');
    RegisterPropertyHelper(@TBrowseForFolderDialogPath_R,nil,'Path');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_IShellLink(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(IShellLink) do
  begin
    RegisterVirtualMethod(@IShellLink.GetPath, 'GetPath');
    RegisterVirtualMethod(@IShellLink.GetIDList, 'GetIDList');
    RegisterVirtualMethod(@IShellLink.SetIDList, 'SetIDList');
    RegisterVirtualMethod(@IShellLink.GetDescription, 'GetDescription');
    RegisterVirtualMethod(@IShellLink.SetDescription, 'SetDescription');
    RegisterVirtualMethod(@IShellLink.GetWorkingDirectory, 'GetWorkingDirectory');
    RegisterVirtualMethod(@IShellLink.SetWorkingDirectory, 'SetWorkingDirectory');
    RegisterVirtualMethod(@IShellLink.GetArguments, 'GetArguments');
    RegisterVirtualMethod(@IShellLink.SetArguments, 'SetArguments');
    RegisterVirtualMethod(@IShellLink.GetHotkey, 'GetHotkey');
    RegisterVirtualMethod(@IShellLink.SetHotkey, 'SetHotkey');
    RegisterVirtualMethod(@IShellLink.GetShowCmd, 'GetShowCmd');
    RegisterVirtualMethod(@IShellLink.SetShowCmd, 'SetShowCmd');
    RegisterVirtualMethod(@IShellLink.GetIconLocation, 'GetIconLocation');
    RegisterVirtualMethod(@IShellLink.SetIconLocation, 'SetIconLocation');
    RegisterVirtualMethod(@IShellLink.SetRelativePath, 'SetRelativePath');
    RegisterVirtualMethod(@IShellLink.Resolve, 'Resolve');
    RegisterVirtualMethod(@IShellLink.SetPath, 'SetPath');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_AzuliaUtils(CL: TPSRuntimeClassImporter);
begin
  RIRegister_IShellLink(CL);
  RIRegister_TBrowseForFolderDialog(CL);
  RIRegister_TSystemRegistry(CL);
  RIRegister_TAzuliaStrings(CL);
  RIRegister_TAzuliaFiles(CL);
  RIRegister_TAzuliaSpeaker(CL);
  RIRegister_TAzuliaDisk(CL);
  RIRegister_TAzuliaHTML(CL);
  with CL.Add(EInvalidDest) do
  with CL.Add(EFCantMove) do
end;

 
 
{ TPSImport_AzuliaUtils }
(*----------------------------------------------------------------------------*)
procedure TPSImport_AzuliaUtils.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_AzuliaUtils(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_AzuliaUtils.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_AzuliaUtils(ri);
  RIRegister_AzuliaUtils_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
