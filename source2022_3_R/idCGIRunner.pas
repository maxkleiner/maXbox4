{*******************************************************}
{                                                       }
{  idCGIRunner component for Internet Direct (Indy)     }
{                   HTTP Server                         }
{                   version 3.4                         }
{            http://users.chello.be/ws36637             }
{                                                       }
{ Author:                                               }
{ Serhiy Perevoznyk                                     }
{ serge_perevoznyk@hotmail.com                          }
{ Contributors:                                         }
{ Setec Astronomy <setec@freemail.it>                   }
{ Special thanks to                                     }
{ Peter Jukel <pjukel@triplehash.com>                   }
{                                                       }
{     Use, modification and distribution is allowed     }
{without limitation, warranty, or liability of any kind.}
{                                                       }
{*******************************************************}

{$I idRunner.inc}

unit idCGIRunner;

interface

uses
  Windows,
  SysUtils,
  Classes,
  idBaseComponent,
  idTCPServer,
  idStack,
  {$IFDEF INDY9}
  idCustomHTTPServer,
  idCookie,
  {$ENDIF}
  idHTTPServer;

type
  {TidCGIRunner component allows to execute CGI scripts using
   Indy TidHTTPServer component}
  TidCGIRunner = class(TidBaseComponent)
   private
     FPHPIniPath: String;  // Added PAJ 04.08.2002
     FBeforeExecute : TNotifyEvent;
     FAfterExecute : TNotifyEvent;
     FPHPSupport : boolean;
     FServer : TidHTTPServer;
     FTimeOut : integer;
     FTimeOutMsg : string;
     FErrorMsg : string;
     FServerAdmin : string;
     procedure SetServer(const AValue : TIdHTTPServer);
   protected
      //Forwards notification messages to all owned components.
      procedure Notification(AComponent: TComponent; Operation: TOperation); override;
   public
     //Allocates memory and constructs a safely initialized instance of a component.
     constructor Create(AOwner : TComponent); override;
     {Execute CGI executable and return result to WebServer
      LocalDoc - the full local path to executable file
      e.g. c:\inetpub\wwwroot\cgi-bin\cgi.exe

      RequestInfo - TIdHTTPRequestInfo publishes properties that provide 
      access to various information for a HTTP request. 
      The properties include the HTTP session, authentication parameters, 
      the remote computer addresses, HTTP headers, cookies, the HTTP command
      and version, and the document URL for the request.

      ResponseInfo - IdHTTPResponseInfo publishes properties that provide 
      access to various information for a HTTP response.
      These properties include the HTTP session, the authentication realm, 
      Cookies, Headers, and the response content, length, and type.
      
      DocumentRoot - Local path to virtual root of your WebServer

      Action - PathInfo of TWebActionItem of your CGI executable}
      function Execute(LocalDoc : string;
                      AThread: TIdPeerThread;
                      RequestInfo: TIdHTTPRequestInfo;
                      ResponseInfo: TIdHTTPResponseInfo;
                      DocumentRoot : string;
                      Action : string = '') : integer; virtual;
   published
     //Indy TidHTTPServer
     property Server : TidHTTPServer read FServer write SetServer;
     //Specifies the time-out interval, in milliseconds
     property TimeOut: integer read FTimeOut write FTimeOut default 5000;
     //Time-out error message text
     property TimeOutMsg : string read FTimeOutMsg write FTimeOutMsg;
     //General error message text
     property ErrorMsg : string read FErrorMsg write FErrorMsg;
     {Email address of Server Administator (optional, for compatibility
      with Apache) }
     property ServerAdmin : string read FServerAdmin write FServerAdmin;
     //Occurs before executing CGI script
     property BeforeExecute : TNotifyEvent read FBeforeExecute write FBeforeExecute;
     //Occurs after executing CGI script
     property AfterExecute : TNotifyEvent read FAfterExecute write FAfterExecute;
     //Perform special action to support PHP security
     property PHPSupport : boolean read FPHPSupport write FPHPSupport default true;
     // Path to PHP.ini file (added PAJ 04.08.2002)
     property PHPIniPath: String read FPHPIniPath write FPHPIniPath;
   end;

//register TidCGIRunner component
procedure Register;

implementation

type
  ThreadParams = record
    hReadPipe : THandle;
    s : String;
  end;
  PThreadParams = ^ThreadParams;

function AdjustHTTP(const Name: string): string;
  const
    SHttp = 'HTTP_';     { do not localize }
begin
    if Pos(SHttp, Name) = 1 then
      Result := Copy(Name, 6, MaxInt)
        else
          Result := Name;
end;



function ThreadRead(Params : Pointer):Dword; stdcall;
var
  Info : PThreadParams;
  Buffer :  array [0..4095] of Char;
  nb: DWord;
  i: Longint;
begin
  Result := 0;
  Info := PThreadParams(Params);
  while ReadFile( Info^.hReadPipe,  buffer,  SizeOf(buffer),  nb,  nil) do
     begin
       if nb = 0 then
         Break;
       for i:=0 to nb-1 do
         Info^.s := Info^.s + buffer[i];
      end;

end;


function GetEnv(const Name: string): string;
var
  Buffer: array[0..4095] of Char;
begin
  SetString(Result, Buffer, GetEnvironmentVariable(PChar(Name), Buffer, SizeOf(Buffer)));
end;


constructor TidCGIRunner.Create(AOwner: TComponent);
begin
  inherited;
  FErrorMsg := '<html><body><h1><center>Internal Server Error</body></html>';
  FTimeOutMsg := '<html><body><h1><center>Process was terminated.</body></html>';
  FServerAdmin := 'admin@server';
  FTimeOut := 5000;
  FPHPSupport := true;
end;

function TidCGIRunner.Execute(LocalDoc : string; AThread: TIdPeerThread;
                              RequestInfo: TIdHTTPRequestInfo;
                              ResponseInfo: TIdHTTPResponseInfo;
                              DocumentRoot : string;
                              Action : string = '') : integer;
const
  FEnv = '%s=%s'#0;

var
  i1 : dword;
  ParsLine : string;
  HeadLine : string;
  ParsList : TStringList;
  I        : integer;
  hInReadPipe,
  hInWritePipe,
  hNIWritePipe,
  hReadPipe,
  hNIReadPipe,
  hWritePipe: THandle;
  saPipe: TSecurityAttributes;
  sdPipe : TSecurityDescriptor;
  StartInfo: TStartupInfo;
  ProcInfo: TProcessInformation;
  Params : PThreadParams;
  ReaderID : Dword;
  ReaderHandle : THandle;
  cEnv : String;
  shell_cmd : string;
  tmpS : string;


function GetFieldByNameEx(AFieldName : string) : string;
var
 NewFieldName : string;
begin
  NewFieldName := AdjustHTTP(AFieldName);
  {$IFDEF INDY9}
   Result := RequestInfo.RawHeaders.Values[NewFieldName];
   if Result = '' then
    begin
      NewFieldName := StringReplace(NewFieldName,'_','-', [rfReplaceALL]);
      Result := RequestInfo.RawHeaders.Values[NewFieldName];
    end;
  {$ELSE}
   Result := RequestInfo.Headers.Values[NewFieldName];
   if Result = '' then
    begin
      NewFieldName := StringReplace(NewFieldName,'_','-', [rfReplaceALL]);
      Result := RequestInfo.Headers.Values[NewFieldName];
    end;
  {$ENDIF}
end;

function GetFieldByName(AFieldName : string) : string;
begin
  {$IFDEF INDY9}
   Result := RequestInfo.RawHeaders.Values[AFieldName];
  {$ELSE}
   Result := RequestInfo.Headers.Values[AFieldName];
  {$ENDIF}
  if Result = '' then
    Result := GetFieldByNameEx(AFieldName);
end;

begin
  if Assigned(FBeforeExecute) then
   FBeforeExecute(Self);
  cEnv := '';
  if Assigned(FServer) then
  cEnv := Format(FEnv,['SERVER_SOFTWARE', FServer.ServerSoftware ]);

  {$IFDEF INDY9}
  cEnv := cEnv + Format(FEnv,['HTTP_CONTENT_TYPE',RequestInfo.RawHeaders.Values['Content-Type']]);
  cEnv := cEnv + Format(FEnv,['CONTENT_TYPE',RequestInfo.RawHeaders.Values['Content-Type']]);
  {$ELSE}
  cEnv := cEnv + Format(FEnv,['HTTP_CONTENT_TYPE',RequestInfo.Headers.Values['Content-Type']]);
  cEnv := cEnv + Format(FEnv,['CONTENT_TYPE',RequestInfo.Headers.Values['Content-Type']]);
  {$ENDIF}


   if pos('.EXE', UpperCase(RequestInfo.Document)) > 0 then
     tmpS := Copy(RequestInfo.Document,1,Pos('.EXE',UpperCase(RequestInfo.Document))+ 3)
        else
         tmpS := RequestInfo.Document;
   cEnv := cEnv + Format(FEnv,['URL', tmpS]);


  //for php support
  if PHPSupport then
   begin
     cEnv := cEnv + Format(FEnv,['PHPRC',FPHPIniPath]);  // Added PAJ 22.05.2002.
     cEnv := cEnv + Format(FEnv,['REDIRECT_STATUS','200']);
     cEnv := cEnv + Format(FEnv,['HTTP_REDIRECT_STATUS','200']);
     cEnv := cEnv + Format(FEnv,['REDIRECT_URL',RequestInfo.Document]);
   end;

  {$IFDEF INDY9}
  cEnv := cEnv + Format(FEnv,['CONTENT_LENGTH', RequestInfo.RawHeaders.Values['Content-Length']]);
  cEnv := cEnv + Format(FEnv,['HTTP_CONTENT_LENGTH', RequestInfo.RawHeaders.Values['Content-Length']]);
  {$ELSE}
  cEnv := cEnv + Format(FEnv,['CONTENT_LENGTH', RequestInfo.Headers.Values['Content-Length']]);
  cEnv := cEnv + Format(FEnv,['HTTP_CONTENT_LENGTH', RequestInfo.Headers.Values['Content-Length']]);
  {$ENDIF}


  cEnv := cEnv + Format(FEnv,['SERVER_NAME',RequestInfo.Host]);;
  cEnv := cEnv + Format(FEnv,['SERVER_PROTOCOL',RequestInfo.Version]);
  {$IFDEF INDY9}
  cEnv := cEnv + Format(FEnv,['SERVER_PORT',IntToStr(AThread.Connection.Socket.Binding.Port)]);
  {$ELSE}
  cEnv := cEnv + Format(FEnv,['SERVER_PORT',IntToStr(AThread.Connection.Binding.Port)]);
  {$ENDIF}

  cEnv := cEnv + Format(FEnv,['GATEWAY_INTERFACE','CGI/1.1']);
  cEnv := cEnv + Format(FEnv,['REQUEST_METHOD',RequestInfo.Command]);
  if pos('.EXE', UpperCase(RequestInfo.Document)) > 0 then
   tmpS := Copy(RequestInfo.Document,1,Pos('.EXE', UpperCase(RequestInfo.Document))+ 3)
          else
           tmpS := RequestInfo.Document;

  cEnv := cEnv + Format(FEnv,['SCRIPT_NAME',tmpS]);

  if RequestInfo.Command <> 'POST' then
    cEnv := cEnv + Format(FEnv,['QUERY_STRING',RequestInfo.UnparsedParams]);

  cEnv := cEnv + Format(FEnv,['REMOTE_ADDR',RequestInfo.RemoteIP]);
  cEnv := cEnv + Format(FEnv,['REMOTE_HOST', GStack.WSGetHostByAddr(RequestInfo.RemoteIP)]);

  //Win32 fields
  cEnv := cEnv + Format(FEnv,['SystemRoot',getenv('SystemRoot')]);
  cEnv := cEnv + Format(FEnv,['COMSPEC',getenv('COMSPEC')]);
  cEnv := cEnv + Format(FEnv,['WINDIR',getenv('WINDIR')]);
  cEnv := cEnv + Format(FEnv,['PATH',getenv('PATH')]);
  if Action <> '' then
   cEnv := cEnv + Format(FEnv,['PATH_INFO', Action])
   else
    cEnv := cEnv + Format(FEnv,['PATH_INFO', RequestInfo.Document]);

  cEnv := cEnv + Format(FEnv,['REQUEST_URI', RequestInfo.Document]);
  cEnv := cEnv + Format(FEnv,['PATH_TRANSLATED',ExpandFileName(DocumentRoot + RequestInfo.Document)]);
  cEnv := cEnv + Format(FEnv,['SCRIPT_FILENAME',LocalDoc]);

  //Add HTTP_ fields
  cEnv := cEnv + Format(FEnv,['HTTP_DATE', GetFieldByName('DATE')]);
  cEnv := cEnv + Format(FEnv,['HTTP_CACHE_CONTROL', GetFieldByName('CACHE_CONTROL')]);
  cEnv := cEnv + Format(FEnv,['HTTP_ACCEPT',GetFieldByName('ACCEPT')]);
  cEnv := cEnv + Format(FEnv,['HTTP_FROM', GetFieldByName('FROM')]);
  cEnv := cEnv + Format(FEnv,['HTTP_HOST', GetFieldByName('HOST')]);
  cEnv := cEnv + Format(FEnv,['HTTP_IF_MODIFIED_SINCE', GetFieldByName('IF-MODIFIED-SINCE')]);
  cEnv := cEnv + Format(FEnv,['HTTP_REFERER',GetFieldByName('REFERER')]);
  cEnv := cEnv + Format(FEnv,['HTTP_CONTENT_ENCODING', GetFieldByName('CONTENT-ENCODING')]);
  cEnv := cEnv + Format(FEnv,['HTTP_CONTENT_VERSION', GetFieldByName('CONTENT-VERSION')]);
  cEnv := cEnv + Format(FEnv,['HTTP_DERIVED_FROM',GetFieldByName('DERIVED-FROM')]);
  cEnv := cEnv + Format(FEnv,['HTTP_EXPIRES',GetFieldByName('EXPIRES')]);
  cEnv := cEnv + Format(FEnv,['HTTP_TITLE',GetFieldByName('TITLE')]);
  cEnv := cEnv + Format(FEnv,['HTTP_CONNECTION',GetFieldByName('CONNECTION')]);
  cEnv := cEnv + Format(FEnv,['HTTP_AUTHORIZATION',GetFieldByName('AUTHORIZATION')]);
  cEnv := cEnv + Format(FEnv,['HTTP_ACCEPT_LANGUAGE', GetFieldByName('ACCEPT-LANGUAGE')]);
  cEnv := cEnv + Format(FEnv,['HTTP_ACCEPT_ENCODING', GetFieldByName('ACCEPT-ENCODING')]);

  {$IFDEF INDY9}
  cEnv := cEnv + Format(FEnv,['HTTP_USER_AGENT', RequestInfo.RawHeaders.Values['User-Agent']]);
  cEnv := cEnv + Format(FEnv,['HTTP_COOKIE', RequestInfo.RawHeaders.Values['cookie']]);
  {$ELSE}
  cEnv := cEnv + Format(FEnv,['HTTP_USER_AGENT', RequestInfo.Headers.Values['User-Agent']]);
  cEnv := cEnv + Format(FEnv,['HTTP_COOKIE', RequestInfo.Headers.Values['cookie']]);
  {$ENDIF}

  //Apache fields
  {$IFDEF INDY9}
  cEnv := cEnv + Format(FEnv,['SERVER_ADDR',AThread.Connection.Socket.Binding.IP]);
  {$ELSE}
  cEnv := cEnv + Format(FEnv,['SERVER_ADDR',AThread.Connection.Binding.IP]);
  {$ENDIF}

  cEnv := cEnv + Format(FEnv,['DOCUMENT_ROOT',DocumentRoot]);
  cEnv := cEnv + Format(FEnv,['SERVER_ADMIN',ServerAdmin]);

  cEnv := cEnv + #0;

  Params := nil;
  ReaderHandle := 0;
  InitializeSecurityDescriptor(@sdPipe,SECURITY_DESCRIPTOR_REVISION);
  SetSecurityDescriptorDacl(@sdPipe, true, nil, false);

  saPipe.bInheritHandle := True;
  saPipe.lpSecurityDescriptor := @sdPipe;
  saPipe.lpSecurityDescriptor := nil;
  saPipe.nLength := SizeOf(saPipe);

  if not CreatePipe(hReadPipe,hWritePipe,@saPipe,0) then
   {$IFDEF VER130}
    RaiseLastWin32Error;
   {$ELSE}
   RaiseLastOSError;
   {$ENDIF}

  if not CreatePipe(hinReadPipe,hinWritePipe,@saPipe,0) then
   {$IFDEF VER130}
    RaiseLastWin32Error;
   {$ELSE}
   RaiseLastOSError;
   {$ENDIF}



try

  FillChar(StartInfo,SizeOf(StartInfo),0);

  StartInfo.dwFlags:= STARTF_USESTDHANDLES  or
                      STARTF_USESHOWWINDOW;
  StartInfo.wShowWindow:=SW_HIDE;

  StartInfo.hStdOutput := hWritePipe;
  StartInfo.hStdError  := hWritePipe;
  StartInfo.hStdInput  := hinReadPipe;

  StartInfo.cb:=SizeOf(StartInfo);
  DuplicateHandle( GetCurrentProcess,
                          hinWritePipe,
                          GetCurrentProcess,
                          @hNIWritePipe,
                          0,
                          False,
                          DUPLICATE_SAME_ACCESS);

  if not DuplicateHandle( GetCurrentProcess,
                          hReadPipe,
                          GetCurrentProcess,
                          @hNIReadPipe,
                          0,
                          False,
                          DUPLICATE_SAME_ACCESS) then
       begin
        ResponseInfo.ContentText := FErrorMsg;
        ResponseInfo.ContentLength := Length(ResponseInfo.ContentText);
        ResponseInfo.ResponseNo := 500;
        Result :=  ResponseInfo.ContentLength;
        Exit;
       end;

  CloseHandle(hReadPipe);
  CloseHandle(hinWritePipe);

  New(Params);
  Params^.hReadPipe := hNIReadPipe;


  ReaderHandle := CreateThread( nil,
                                0,
                                @ThreadRead,
                                Params,
                                0,
                                ReaderId);
  if ReaderHandle = 0 then
   begin
     ResponseInfo.ContentText := FTimeOutMsg;
     ResponseInfo.ContentLength := Length(ResponseInfo.ContentText);
     ResponseInfo.ResponseNo := 500;
     Result :=  ResponseInfo.ContentLength;
     Exit;
   end;

  //Long FileName
  if Pos(' ',LocalDoc) <> 0 then
   LocalDoc := '"'+LocalDoc + '"';

  if Win32Platform = VER_PLATFORM_WIN32_NT then
   shell_cmd := 'CMD.EXE /C ' + LocalDoc else
     shell_cmd := 'COMMAND.COM /C ' + LocalDoc;

  if CreateProcess(nil,
                   PChar(shell_cmd),
                   nil,
                   nil,
                   True,
                   0,
                   PChar(cEnv),
                   nil,
                   StartInfo,
                   ProcInfo)
  then
    begin
      CloseHandle(ProcInfo.hThread);
      CloseHandle(hWritePipe);
    end
  else
   begin
     ResponseInfo.ContentText := FTimeOutMsg;
     ResponseInfo.ContentLength := Length(ResponseInfo.ContentText);
     ResponseInfo.ResponseNo := 500;
     Result :=  ResponseInfo.ContentLength;
     Exit;
   end;

  WriteFile(hNIWritePipe, RequestInfo.UnparsedParams[1], Length(RequestInfo.UnparsedParams), i1, nil);

  if WaitForSingleObject(ProcInfo.hProcess , FTimeOUT) = WAIT_TIMEOUT then
     begin
        TerminateThread(ReaderHandle,0);
        TerminateProcess(ProcInfo.hProcess, 1);
        ResponseInfo.ContentText := FTimeOutMsg;
        ResponseInfo.ContentLength := Length(ResponseInfo.ContentText);
        ResponseInfo.ResponseNo := 500;
        Result :=  ResponseInfo.ContentLength;
        Exit;
     end;


   ParsLine := Params^.s;
   I := Pos(#13#10#13#10,Params^.s);
   if i > 0 then
    begin
      ParsLine := Copy(ParsLine,1,I+3);
      HeadLine := Copy(ParsLine,1,Length(ParsLine)-2);
      ParsLine := StringReplace(ParsLine,': ','=',[rfReplaceAll]);
      ParsList := TStringList.Create;
      ParsList.Text := ParsLine;

      ResponseInfo.ContentType   := ParsList.Values['content-type'];
      ResponseInfo.ResponseNo    := StrToIntDef(Copy(ParsList.Values['status'],1,3),200);

      {$IFDEF INDY9}
      ResponseInfo.RawHeaders.Text := HeadLine;
      {$ELSE}
      ResponseInfo.Headers.Text := HeadLine;
      {$ENDIF}

      //redirect support

      {$IFDEF INDY9}
      if ResponseInfo.RawHeaders.Values['Location'] <> '' then
       ResponseInfo.ResponseNo := 302;
      {$ELSE}
      if ResponseInfo.Headers.Values['Location'] <> '' then
       ResponseInfo.ResponseNo := 302;
      {$ENDIF}

     //Begin Add by Setec Astronomy <setec@freemail.it>
     {$IFDEF INDY9}
       ResponseInfo.CustomHeaders.Text:=ResponseInfo.RawHeaders.Text;
     {$ENDIF}
     // End Add by Setec Astronomy setec@freemail.it


      ResponseInfo.WriteHeader;
      ResponseInfo.ContentText   := Copy(Params^.s,I+4, Length(Params^.s));
      ParsList.Free;
     end
       else
         begin
           ResponseInfo.ContentType := 'text/html';
         end;

   Result :=  ResponseInfo.ContentLength;

  finally
    if ReaderHandle > 0 then
       CloseHandle(ReaderHandle);
    if ProcInfo.hProcess > 0 then
       CloseHandle(ProcInfo.hProcess);
    if hReadPipe > 0 then
       CloseHandle(hNIReadPipe);
    if Assigned(Params) then
       Dispose(Params);
    if Assigned(FAfterExecute) then
     FAfterExecute(Self);
  end;

end;


procedure TidCGIRunner.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited;
  if (Operation = opRemove) and (AComponent = FServer) then
    FServer := nil;
end;

procedure TidCGIRunner.SetServer(const AValue: TIdHTTPServer);
begin
  if FServer <> AValue then
  begin
    if Avalue <> nil then AValue.FreeNotification(Self);
    FServer := AValue;
  end;
end;


procedure Register;
begin
  RegisterComponents('Indy Misc', [TidCGIRunner]);
end;

end.


