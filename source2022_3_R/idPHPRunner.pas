{*******************************************************}
{                                                       }
{  idPHPRunner component for Internet Direct (Indy)     }
{                   HTTP Server                         }
{                   version 4.0                         }
{            http://users.chello.be/ws36637             }
{                                                       }
{ Author:                                               }
{ Serhiy Perevoznyk                                     }
{ serge_perevoznyk@hotmail.com                          }
{                                                       }
{     Use, modification and distribution is allowed     }
{without limitation, warranty, or liability of any kind.}
{                                                       }
{*******************************************************}

{$I idRunner.inc}

unit idPHPRunner;

interface

uses
  Windows, SysUtils, ISAPI2, IdTCPServer, idStack,
  idGlobal,
  idBaseComponent,
  {$IFDEF INDY9}
  idCustomHTTPServer,
  idStackWindows,
  idWinSock2,
  {$ENDIF}
  idHeaderList,
  IdHTTPServer,
  Classes;
  //ZendAPI,
  //PHPAPI;


type
  TidPHPRunner = class(TComponent)
  private
    FINIPath : string;
    FModuleActive : boolean;
    FOnModuleStartup  : TNotifyEvent;
    FOnModuleShutdown : TNotifyEvent;
    FOnRequestStartup : TNotifyEvent;
    FOnRequestShutdown : TNotifyEvent;
    //delphi_sapi_module : sapi_module_struct;
    //php_delphi_module : Tzend_module_entry;
    FServer : TidHTTPServer;
    FServerAdmin : string;
    procedure SetServer(const AValue : TIdHTTPServer);
  protected
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    procedure PrepareModule; virtual;
    //procedure StartupModule; virtual;
    procedure ShutdownModule; virtual;
    procedure Loaded; override;
  public
    constructor Create(AOwner : TComponent); override;
    destructor  Destroy; override;
    //procedure   Execute(const PHPScriptName: String; AThread: TIdPeerThread;
      //            RequestInfo: TIdHTTPRequestInfo;
        //          ResponseInfo: TIdHTTPResponseInfo;
          //        const DocumentRoot:string; Action : string=''); virtual;

    property  OnModuleStartup : TNotifyEvent read FOnModuleStartup write FOnModuleStartup;
    property  OnModuleShutdown : TNotifyEvent read FOnModuleShutdown write FOnModuleShutdown;
    property  OnRequestStartup : TNotifyEvent read FOnRequestStartup write FOnRequestStartup;
    property  OnRequestShutdown : TNotifyEvent read FOnRequestShutdown write FOnRequestShutdown;
    property  ModuleActive : boolean read FModuleActive;
  published
     //Indy TidHTTPServer
     property Server : TidHTTPServer read FServer write SetServer;
     {Email address of Server Administator (optional, for compatibility
      with Apache) }
     property ServerAdmin : string read FServerAdmin write FServerAdmin;
     property  IniPath : string read FIniPath write FIniPath;
  end;


  TPHPControlBlock = class
  public
   Runner      : TidPHPRunner;
   RequestInfo  : TidHTTPRequestInfo;
   ResponseInfo : TidHTTPResponseInfo;
   AThread      : TidPeerThread;
   Server       : TidHTTPServer;
   DocumentRoot : string;
   PathInfo     : string;
   PathTranslated : string;
   ServerAdmin : string;
   data_avail : integer;
   constructor Create;
  end;


procedure Register;

implementation
procedure Register;
begin
  RegisterComponents('Indy Misc',[TidPHPRunner]);
end;


const
 v_AUTH_TYPE = 1;
 v_AUTH_NAME = 2;
 v_AUTH_PASS = 3;
 v_CONTENT_LENGTH = 4;
 v_CONTENT_TYPE = 5;
 v_GATEWAY_INTERFACE = 6;
 v_PATH_INFO = 7;
 v_PATH_TRANSLATED = 8;
 v_QUERY_STRING = 9;
 v_REMOTE_ADDR = 10;
 v_REMOTE_HOST = 11;
 v_REMOTE_USER = 12;
 v_REQUEST_METHOD = 13;
 v_SCRIPT_NAME = 14;
 v_SERVER_NAME = 15;
 v_SERVER_PORT = 16;
 v_SERVER_PROTOCOL = 17;
 v_SERVER_SOFTWARE = 18;
 v_HTTP_COOKIE = 19;
 v_HTTP_USER_AGENT = 20;
 v_URL = 21;
 v_HTTP_CACHE_CONTROL = 22;
 v_HTTP_DATE = 23;
 v_HTTP_ACCEPT = 24;
 v_HTTP_FROM = 25;
 v_HTTP_HOST = 26;
 v_HTTP_IF_MODIFIED_SINCE = 27;
 v_HTTP_REFERER = 28;
 v_HTTP_CONTENT_ENCODING = 29;
 v_HTTP_CONTENT_VERSION = 30;
 v_HTTP_DERIVED_FROM = 31;
 v_HTTP_EXPIRES = 32;
 v_HTTP_TITLE = 33;
 v_HTTP_CONNECTION = 34;
 v_HTTP_AUTHORIZATION = 35;
 v_DOCUMENT_ROOT = 36;
 v_SERVER_ADMIN = 37;
 v_SERVER_ADDR = 38;
 v_HTTP_ACCEPT_LANGUAGE = 39;
 v_HTTP_ACCEPT_ENCODING = 40;
 v_HTTP_CLIENT_IP = 41;
 v_REDIRECT_STATUS = 42;
 v_HTTP_REDIRECT_STATUS = 43;
 v_REDIRECT_URL = 44;
 v_HTTP_IDSESSION = 45;

const
  VarNames : array[1..45] of string = (
  'AUTH_TYPE',               //1
  'AUTH_NAME',               //2
  'AUTH_PASS',               //3
  'CONTENT_LENGTH',          //4
  'CONTENT_TYPE',            //5
  'GATEWAY_INTERFACE',       //6
  'PATH_INFO',               //7
  'PATH_TRANSLATED',         //8
  'QUERY_STRING',            //9
  'REMOTE_ADDR',             //10
  'REMOTE_HOST',             //11
  'REMOTE_USER',             //12
  'REQUEST_METHOD',          //13
  'SCRIPT_NAME',             //14
  'SERVER_NAME',             //15
  'SERVER_PORT',             //16
  'SERVER_PROTOCOL',         //17
  'SERVER_SOFTWARE',         //18
  'HTTP_COOKIE',             //19
  'HTTP_USER_AGENT',         //20
  'URL',                     //21
  'HTTP_CACHE_CONTROL',      //22
  'HTTP_DATE',               //23
  'HTTP_ACCEPT',             //24
  'HTTP_FROM',               //25
  'HTTP_HOST',               //26
  'HTTP_IF_MODIFIED_SINCE',  //27
  'HTTP_REFERER',            //28
  'HTTP_CONTENT_ENCODING',   //29
  'HTTP_CONTENT_VERSION',    //30
  'HTTP_DERIVED_FROM',       //31
  'HTTP_EXPIRES',            //32
  'HTTP_TITLE',              //33
  'HTTP_CONNECTION',         //34
  'HTTP_AUTHORIZATION',      //35
  'DOCUMENT_ROOT',           //36
  'SERVER_ADMIN',            //37
  'SERVER_ADDR',             //38
  'HTTP_ACCEPT_LANGUAGE',    //39
  'HTTP_ACCEPT_ENCODING',    //40
  'HTTP_CLIENT_IP',          //41
  'REDIRECT_STATUS',         //42
  'HTTP_REDIRECT_STATUS',    //43
  'REDIRECT_URL',            //44
  'HTTP_IDSESSION');         //45 Indy Server Session

function AdjustHTTP(const Name: string): string;
  const
    SHttp = 'HTTP_';     { do not localize }
begin
    if Pos(SHttp, Name) = 1 then
      Result := Copy(Name, 6, MaxInt)
        else
          Result := Name;
end;


function GetServerVariable(ControlBlock : TPHPControlBlock; variableName: string) : string;

var
  Thread       : TIdPeerThread;
  RequestInfo  : TIdHTTPRequestInfo;
  Server       : TidHTTPServer;
  VarNum : integer;
  VarFound : boolean;

function GetFieldByName(AFieldName : string) : string;
begin
  {$IFDEF INDY9}
   Result := RequestInfo.RawHeaders.Values[AFieldName];
  {$ELSE}
   Result := RequestInfo.Headers.Values[AFieldName];
  {$ENDIF}
end;

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

begin
  Result:= '';
  if not Assigned(ControlBlock) then
   Exit;

  Thread:= ControlBlock.AThread;
  RequestInfo := ControlBlock.RequestInfo;
  Server := ControlBlock.Server;

  if (thread=nil) then
    Exit;

  varFound := False;

  for VarNum := 1 to 45 do
    begin
      if CompareText(VariableName, VarNames[VarNum]) = 0 then
       begin
         VarFound := true;
         break;
       end;
    end;

  if not VarFound then
   begin
     Result := GetFieldByNameEx(VariableName);
     Exit;
   end;

  case VarNum of
  v_AUTH_TYPE:
    begin
      Result := 'Basic';
    end;

  v_AUTH_NAME:
     begin
       Result := RequestInfo.AuthUsername;
     end;

  v_AUTH_PASS:
     begin
       Result := RequestInfo.AuthPassword;
     end;

  v_CONTENT_LENGTH:
     begin
       {$IFDEF INDY9}
       if RequestInfo.RawHeaders.Values['content-length'] <> EmptyStr then
         Result :=RequestInfo.RawHeaders.Values['content-length'];
       {$ELSE}
       if RequestInfo.Headers.Values['content-length'] <> EmptyStr then
         Result :=RequestInfo.Headers.Values['content-length'];
       {$ENDIF}
     end;

  v_CONTENT_TYPE:
     begin
       {$IFDEF INDY9}
       if RequestInfo.RawHeaders.Values['content-type'] <> EmptyStr then
          Result := RequestInfo.RawHeaders.Values['content-type'];
       {$ELSE}
       if RequestInfo.Headers.Values['content-type'] <> EmptyStr then
          Result := RequestInfo.Headers.Values['content-type'];
       {$ENDIF}
     end;

  v_GATEWAY_INTERFACE:
     begin
       Result :='CGI/1.1';
     end;

  v_PATH_INFO:
     begin
       Result := ControlBlock.PathInfo;
     end;

  v_PATH_TRANSLATED:
     begin
       Result := ControlBlock.PathTranslated;
     end;

  v_QUERY_STRING:
     begin
       Result := RequestInfo.UnparsedParams;
     end;

 v_REMOTE_ADDR:
     begin
       Result := RequestInfo.RemoteIP;
     end;

 v_REMOTE_HOST:
     begin
       Result := GStack.WSGetHostByAddr(RequestInfo.RemoteIP);
     end;

 v_REMOTE_USER:
     begin
       Result := RequestInfo.AuthUsername;
     end;

 v_REQUEST_METHOD:
     begin
       Result := RequestInfo.Command;
     end;

 v_SCRIPT_NAME:
     begin
       if pos('.php', UpperCase(RequestInfo.Document)) > 0 then
         Result := Copy(RequestInfo.Document,1,Pos('.php', UpperCase(RequestInfo.Document))+ 3)
          else
            Result := RequestInfo.Document;
     end;

 v_SERVER_NAME:
     begin
       Result :=RequestInfo.Host;
     end;

 v_SERVER_PORT:
     begin
       {$IFDEF INDY9}
        Result := IntToStr(Thread.Connection.Socket.Binding.Port);
       {$ELSE}
        Result := IntToStr(Thread.Connection.Binding.Port);
       {$ENDIF}
     end;

 v_SERVER_PROTOCOL:
     begin
       Result := RequestInfo.Version;
     end;

 v_SERVER_SOFTWARE:
     begin
       if Assigned(Server) then
         Result := Server.ServerSoftware
          else
            Result := '';
     end;

 v_HTTP_COOKIE:
     begin
       {$IFDEF INDY9}
       Result:= RequestInfo.RawHeaders.Values['cookie'];
       {$ELSE}
       Result:= RequestInfo.Headers.Values['cookie'];
       {$ENDIF}
     end;

 v_HTTP_USER_AGENT:
    begin
      {$IFDEF INDY9}
      Result := RequestInfo.RawHeaders.Values['User-Agent'];
      {$ELSE}
      Result := RequestInfo.Headers.Values['User-Agent'];
      {$ENDIF}
    end;

 v_URL: begin
       if pos('.php', UpperCase(RequestInfo.Document)) > 0 then
         Result := Copy(RequestInfo.Document,1,Pos('.php',UpperCase(RequestInfo.Document))+ 3)
          else
           Result := RequestInfo.Document;
     end;

  v_HTTP_CACHE_CONTROL:
     begin
       Result := GetFieldByNameEx('CACHE_CONTROL');
     end;

 v_HTTP_DATE:
     begin
       Result:= GetFieldByName('DATE');
     end;

 v_HTTP_ACCEPT:
     begin
       Result := GetFieldByName('ACCEPT');
     end;

 v_HTTP_FROM:
     begin
       Result := GetFieldByName('FROM');
     end;

 v_HTTP_HOST:
     begin
       Result := GetFieldByName('HOST');
     end;

 v_HTTP_IF_MODIFIED_SINCE :
     begin
       Result := GetFieldByNameEx('IF-MODIFIED-SINCE');
     end;

 v_HTTP_REFERER:
     begin
       Result := GetFieldByName('REFERER');
     end;

 v_HTTP_CONTENT_ENCODING:
     begin
       Result := GetFieldByName('CONTENT-ENCODING');
     end;

 v_HTTP_CONTENT_VERSION:
     begin
       Result := GetFieldByName('CONTENT-VERSION');
     end;

 v_HTTP_DERIVED_FROM:
     begin
       Result := GetFieldByName('DERIVED-FROM');
     end;

 v_HTTP_EXPIRES:
     begin
       Result:= GetFieldByName('EXPIRES');
     end;

 v_HTTP_TITLE:
     begin
       Result := GetFieldByName('TITLE');
     end;

 v_HTTP_CONNECTION:
     begin
       Result := GetFieldByName('CONNECTION');
     end;

 v_HTTP_AUTHORIZATION:
     begin
       Result := GetFieldByName('AUTHORIZATION');
     end;

  V_DOCUMENT_ROOT:
     begin
       Result := ControlBlock.DocumentRoot;
     end;

  v_SERVER_ADMIN:
     begin
       Result := ControlBlock.ServerAdmin;
     end;

  v_SERVER_ADDR:
     begin
       Result := RequestInfo.RemoteIP;
     end;

  v_HTTP_ACCEPT_LANGUAGE :
  begin
    Result  := GetFieldByName('ACCEPT-LANGUAGE');
  end;

  v_HTTP_ACCEPT_ENCODING :
  begin
    Result := GetFieldByName('ACCEPT-ENCODING');
  end;

  v_HTTP_CLIENT_IP :
  begin
    Result := RequestInfo.RemoteIP;
  end;

  v_REDIRECT_STATUS :
  begin
    Result := '200';
  end;

  v_HTTP_REDIRECT_STATUS :
  begin
    Result := '200';
  end;

  v_REDIRECT_URL :
  begin
    Result := RequestInfo.Document;
  end;

 v_HTTP_IDSESSION :
 begin
   Result := '';
   if Assigned(RequestInfo.Session) then
    Result := RequestInfo.Session.Content.Text;
 end;

 else
   begin
     Result:= '';
   end;
 end;

end;

{
function  SG : Tsapi_globals_struct;
var
 gl : psapi_globals_struct;
 ts : pointer;
begin
  ts := ts_resource_ex(0, nil);
  gl := GetSAPIGlobals(ts);
  Result := gl^;
end;      }


(*procedure init_request_info(ControlBlock : TPHPControlBlock);
var
 sapi_globals : pSapi_globals_struct;
begin
  sapi_globals := GetSAPIGlobals(ts_resource_ex(0, nil));
  sapi_globals^.request_info.request_method  := PChar(ControlBlock.RequestInfo.Command);
  sapi_globals^.request_info.query_string    := PChar(ControlBlock.RequestInfo.UnparsedParams);
  sapi_globals^.request_info.path_translated :=PChar(ExpandFilename(IncludeTrailingBackslash(ControlBlock.DocumentRoot)+ ControlBlock.RequestInfo.Document));
  sapi_globals^.request_info.request_uri     :=  PChar(ControlBlock.RequestInfo.Document);

 {$IFDEF INDY9}
  sapi_globals^.request_info.content_type := PChar(ControlBlock.RequestInfo.ContentType);
 {$ELSE}
  sapi_globals^.request_info.content_type := PChar(ControlBlock.RequestInfo.Headers.Values['Content-Type']);
 {$ENDIF}

 sapi_globals^.request_info.content_length := ControlBlock.RequestInfo.ContentLength;
 sapi_globals^.sapi_headers.http_response_code := 200;
 sapi_globals^.request_info.auth_user := nil;
 sapi_globals^.request_info.auth_password := nil;
end;   *)

procedure php_info_delphi(zend_module : Pointer; TSRMLS_DC : pointer); cdecl;
var
  ControlBlock : TPHPControlBlock;
  i : integer;
begin
  //ControlBlock := TPHPControlBlock(SG.server_context);
  {php_info_print_table_start();
  php_info_print_table_row(2, PChar('SAPI module version'), PChar('idPHPRunner Nov 2003'));
  php_info_print_table_row(2, PChar('Home page'), PChar('http://users.chello.be/ws36637'));
  for i := 1 to 45 do
   begin
     php_info_print_table_row(2, PChar(VarNames[i]), PChar(GetServerVariable(ControlBlock, VarNames[i])));
   end;
  php_info_print_table_end();   }
end;

function php_delphi_startup(sapi_module : pointer) : integer; cdecl;
begin
  //result := php_module_startup(sapi_module, nil, 0);
end;

function php_delphi_deactivate(p : pointer) : integer; cdecl;
begin
  result := 0;
end;

(*
function php_delphi_read_post(buf : PChar; len : uint; p : pointer) : integer; cdecl;
var
 gl : psapi_globals_struct;
 ControlBlock : TPHPControlBlock;
begin
  gl := GetSAPIGlobals(p);
  ControlBlock := TPHPControlBlock(gl^.server_context);
  if ControlBlock.data_avail = 0 then
   begin
     Result := 0;
     Exit;
   end;

  if ControlBlock.RequestInfo.PostStream = nil then
   begin
     Result := 0;
     Exit;
   end;

  Result := ControlBlock.RequestInfo.PostStream.Read(buf^, len);
end;

function php_delphi_ub_write(str : pointer; len : uint; p : pointer) : integer; cdecl;
var
 gl : psapi_globals_struct;
 ControlBlock : TPHPControlBlock;
begin
  Result := 0;
  gl := GetSAPIGlobals(p);
  if Assigned(gl) then
   begin
     ControlBlock := TPHPControlBlock(gl^.server_context);
     if Assigned(ControlBlock) then
      begin
        ControlBlock.ResponseInfo.ContentStream.Write(Str^, len);
        result := len;
      end;
   end;
end;    *)

type

Pzvalue_value = ^zvalue_value;
  zvalue_value = record
    case longint of
      0: (lval: longint);
      1: (dval: double);
      2: (str: record
          val: PChar;
          len: longint;
        end);
     end;
 Pzval = ^zval;
  zval = record
    value: zvalue_value;
    _type: Byte;
    is_ref: Byte;
    refcount: Smallint;
  end;
  Tzval = zval;

var php_register_variable: procedure(_var : PChar; val: PChar; track_vars_array: pointer; TSRMLS_DC : pointer); cdecl;

procedure php_delphi_register_variables(val : pzval; p : pointer); cdecl;
var
 i : integer;
 ControlBlock : TPHPControlBlock;
begin
  //ControlBlock := TPHPControlBlock(SG.server_context);
  php_register_variable('PHP_SELF', PChar(ControlBlock.PathInfo), val, p);
  php_register_variable('SERVER_NAME','DELPHI', val, p);
  php_register_variable('SERVER_SOFTWARE', 'Delphi', val, p);
  for i := 1 to 45 do
   begin
     php_Register_Variable( PChar(Varnames[i]), PChar(GetServerVariable(ControlBlock, VarNames[i])), val, p);
   end;
end;

 (*
function php_delphi_header_handler(sapi_header : psapi_header_struct;  sapi_headers : psapi_headers_struct; TSRMLS_DC : pointer) : integer; cdecl;
begin
  Result := SAPI_HEADER_ADD;
end;


procedure php_delphi_send_header(AHeader : psapi_header_struct; p2, p3 : pointer); cdecl;
var
 sapi_globals : pSapi_globals_struct;
 header : string;
 ControlBlock : TPHPControlBlock;
begin
  sapi_globals := GetSAPIGlobals(ts_resource_ex(0, nil));
  if Assigned(AHeader) then
   begin
     header := aheader.header ;
     ControlBlock := TPHPControlBlock(sapi_globals^.server_context);
     ControlBlock.ResponseInfo.RawHeaders.Add(Header);
   end;
end;


function php_delphi_read_cookies(p1 : pointer) : pointer; cdecl;
var
 sapi_globals : pSapi_globals_struct;
 ControlBlock : TPHPControlBlock;
begin
  sapi_globals := GetSAPIGlobals(ts_resource_ex(0, nil));
  ControlBlock := TPHPControlBlock(sapi_globals^.server_context);
  Result := PChar(ControlBlock.RequestInfo.RawHeaders.Values['cookie']);
end;   *)

constructor TidPHPRunner.Create(AOwner: TComponent);
begin
  inherited;
  FServerAdmin := 'admin@server';
end;

destructor TidPHPRunner.Destroy;
begin
  if (not (csDesigning in ComponentState)) then
  ShutdownModule;
  inherited;
end;

 (*
procedure TidPHPRunner.StartupModule;
begin
   if not PHPLoaded then
      LoadPHP;

   if FModuleActive then
      raise Exception.Create('PHP engine already active');
  try
    //Start PHP thread safe resource manager
    tsrm_startup(128, 1, TSRM_ERROR_LEVEL_CORE , nil);
    sapi_startup(@delphi_sapi_module);
    php_module_startup(@delphi_sapi_module, @php_delphi_module, 1);

    if Assigned(FOnModuleStartup) then
      FOnModuleStartup(Self);
    FModuleActive := true;
  except
    FModuleActive := false;
  end;
end;  *)

function minit (_type : integer; module_number : integer; TSRMLS_DC : pointer) : integer; cdecl;
begin
  //RESULT := SUCCESS;
end;

procedure TidPHPRunner.PrepareModule;
begin
  {delphi_sapi_module.name := 'php4Indy';  (* name *)
  delphi_sapi_module.pretty_name := 'PHP for Indy';  (* pretty name *)
  delphi_sapi_module.startup := @php_delphi_startup;    (* startup *)
  delphi_sapi_module.shutdown := @php_module_shutdown_wrapper;   (* shutdown *)
  delphi_sapi_module.activate:= nil;  (* activate *)
  delphi_sapi_module.deactivate := @php_delphi_deactivate;  (* deactivate *)
  delphi_sapi_module.ub_write := @php_delphi_ub_write;      (* unbuffered write *)
  delphi_sapi_module.flush := nil;
  delphi_sapi_module.stat:= nil;
  delphi_sapi_module.getenv:= nil;
  delphi_sapi_module.sapi_error := @zend_error;  (* error handler *)
  delphi_sapi_module.header_handler := @php_delphi_header_handler;
  delphi_sapi_module.send_headers :=   nil;
  delphi_sapi_module.send_header :=    @php_delphi_send_header;
  delphi_sapi_module.read_post :=      @php_delphi_read_post;
  delphi_sapi_module.read_cookies :=   @php_delphi_read_cookies;
  delphi_sapi_module.register_server_variables := @php_delphi_register_variables;   (* register server variables *)
  delphi_sapi_module.log_message := nil; //log message
  if FIniPath <> '' then
  delphi_sapi_module.php_ini_path_override := PChar(FIniPath)
   else
     delphi_sapi_module.php_ini_path_override :=  nil;
  delphi_sapi_module.block_interruptions := nil;
  delphi_sapi_module.unblock_interruptions := nil;
  delphi_sapi_module.default_post_reader := nil;
  delphi_sapi_module.treat_data := 0;
  delphi_sapi_module.executable_location := nil;
  delphi_sapi_module.php_ini_ignore := 0;

  php_delphi_module.size := sizeOf(Tzend_module_entry);
  php_delphi_module.zend_api := ZEND_MODULE_API_NO;
  php_delphi_module.zend_debug := 0;
  php_delphi_module.zts := USING_ZTS;
  php_delphi_module.name := 'idPHPRunner';
  php_delphi_module.functions := nil;
  php_delphi_module.module_startup_func := @minit;
  php_delphi_module.module_shutdown_func := nil;
  php_delphi_module.info_func := @php_info_delphi;
  php_delphi_module.version := '5.0.3';
  php_delphi_module.global_startup_func := nil;
  php_delphi_module.request_shutdown_func := nil;
  php_delphi_module.global_id := 0;
  php_delphi_module.module_started := 0;
  php_delphi_module._type := 0;
  php_delphi_module.handle := nil;
  php_delphi_module.module_number := 0;   }
end;

procedure TidPHPRunner.ShutdownModule;
begin
  if not FModuleActive then
   Exit;
  {try
    delphi_sapi_module.shutdown(@delphi_sapi_module);
    sapi_shutdown;
     //Shutdown PHP thread safe resource manager
    tsrm_shutdown(nil);
     if Assigned(FOnModuleShutdown) then
       FOnModuleShutdown(Self);
   finally
     FModuleActive := false;
   end;   }
end;


procedure TidPHPRunner.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited;
  if (Operation = opRemove) and (AComponent = FServer) then
    FServer := nil;
end;


procedure TidPHPRunner.SetServer(const AValue: TIdHTTPServer);
begin
  if FServer <> AValue then
  begin
    if Avalue <> nil then AValue.FreeNotification(Self);
    FServer := AValue;
  end;
end;

(*

procedure TidPHPRunner.Execute(const PHPScriptName: String;
  AThread: TIdPeerThread; RequestInfo: TIdHTTPRequestInfo;
  ResponseInfo: TIdHTTPResponseInfo; const DocumentRoot: string; Action : string = '');

var
 ControlBlock : TPHPControlBlock;
 gl  : psapi_globals_struct;
 file_handle : zend_file_handle;
 tsrmls_d : pointer;
 cook : string;
 ind : integer;
begin

  if not Assigned(FServer) then
   Exit;

  if not Assigned(AThread) then
   Exit;

  if not Assigned(RequestInfo) then
   Exit;

  if not Assigned(ResponseInfo) then
   Exit;

   TSRMLS_D := ts_resource_ex(0, nil);

   ControlBlock := TPHPControlBlock.Create;
   ControlBlock.Runner := Self;
   ControlBlock.RequestInfo  := RequestInfo;
   ControlBlock.ResponseInfo := ResponseInfo;
   ControlBlock.Server := FServer;
   ControlBlock.DocumentRoot := DocumentRoot;
   ControlBlock.AThread  := AThread;
   ControlBlock.PathInfo := Action;
   ControlBlock.PathTranslated := ExpandFilename(IncludeTrailingBackslash(ControlBlock.DocumentRoot)+ ControlBlock.RequestInfo.Document);
   ControlBlock.ServerAdmin := ServerAdmin;

   try
    if Assigned(RequestInfo.PostStream) then
     begin
       ControlBlock.data_avail := RequestInfo.PostStream.Size;
       RequestInfo.PostStream.Position := 0;
     end
       else
         begin
           ControlBlock.data_avail := 0;
         end;

    gl := GetSAPIGlobals(TSRMLS_D);
    gl^.server_context := ControlBlock;

    init_request_info(ControlBlock);
    php_request_startup(TSRMLS_D);

    file_handle._type := ZEND_HANDLE_FILENAME;
    file_handle.filename := PChar(PHPScriptName);
    file_handle.opened_path := nil;
    file_handle.free_filename := 0;

    ResponseInfo.ContentStream := TMemoryStream.Create;
    php_execute_script(@file_handle, TSRMLS_D);

    php_request_shutdown(nil);

    for ind := 0 to ResponseInfo.RawHeaders.Count - 1 do
     begin
       if Pos('Set-Cookie: ', ResponseInfo.RawHeaders[ind]) =1 then
         begin
            cook := ResponseInfo.RawHeaders[ind];
            Delete(cook, 1 , 12);
            ResponseInfo.Cookies.AddSrcCookie(cook);
          end;
     end;

    {$IFDEF INDY9}
     ResponseInfo.Location := ResponseInfo.RawHeaders.Values['Location'];
     if ResponseInfo.Location <> '' then
       ResponseInfo.ResponseNo := 302;
     ResponseInfo.Pragma := ResponseInfo.RawHeaders.Values['Pragma'];
     if (ResponseInfo.RawHeaders.IndexOfName('Date') > 0) then
        ResponseInfo.Date := StrToDateTime(ResponseInfo.RawHeaders.Values['Date']);

     if (ResponseInfo.RawHeaders.IndexOfName('Expires') > 0) then
         ResponseInfo.Expires := GMTToLocalDateTime(ResponseInfo.RawHeaders.Values['Expires']);

       if (ResponseInfo.Rawheaders.IndexOfName('LastModified') > 0) then
         ResponseInfo.LastModified := StrToDateTime(ResponseInfo.RawHeaders.Values['LastModified']);
    {$ENDIF}
    ResponseInfo.CustomHeaders := ResponseInfo.RawHeaders;
   finally
    ControlBlock.Free;
   end;
end;   *)

{ TPHPControlBlock }

constructor TPHPControlBlock.Create;
begin
  inherited Create;
  AThread := nil;
  data_avail := 0;
  DocumentRoot := '';
  PathInfo := '';
  PathTranslated := '';
  RequestInfo := nil;
  ResponseInfo := nil;
  Runner := nil;
  Server := nil;
  ServerAdmin := '';
end;

procedure TidPHPRunner.Loaded;
begin
  inherited;
  if (not (csDesigning in ComponentState)) then
   begin
     //if not PHPLoaded then
      //LoadPHP;
     PrepareModule;
     //StartupModule;
   end;
end;

end.
