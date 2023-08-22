unit uPSI_FCGIApp;
{
   for web support // directives for config file support
{.$DEFINE HAS_CONFIG}
//{$IFDEF HAS_CONFIG}
  {.$DEFINE CONFIG_MUST_EXIST}  // directive to make config file becomes mandatory
//{$ENDIF}

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
  TPSImport_FCGIApp = class(TPSPlugin)
  public
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TFCGIApplication(CL: TPSPascalCompiler);
procedure SIRegister_TFCGIThread(CL: TPSPascalCompiler);
procedure SIRegister_FCGIApp(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TFCGIApplication(CL: TPSRuntimeClassImporter);
procedure RIRegister_TFCGIThread(CL: TPSRuntimeClassImporter);
procedure RIRegister_FCGIApp(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
 //  cthreads
  IniFiles
  ,BlockSocket
  ,SyncObjs
  ,ExtPascalUtils
  ,FCGIApp
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_FCGIApp]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TFCGIApplication(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOBJECT', 'TFCGIApplication') do
  with CL.AddClassN(CL.FindClass('TOBJECT'),'TFCGIApplication') do begin
    RegisterProperty('Terminated', 'boolean', iptrw);
    RegisterProperty('GarbageNow', 'boolean', iptrw);
    RegisterProperty('Shutdown', 'boolean', iptrw);
    RegisterProperty('Title', 'string', iptrw);
    RegisterProperty('Icon', 'string', iptrw);
    RegisterProperty('Password', 'string', iptrw);
    RegisterProperty('HasConfig', 'boolean', iptrw);
    RegisterProperty('Config', 'TIniFile', iptrw);
    RegisterMethod('Function ReadConfig : boolean');
    RegisterMethod('Procedure Reconfig( AReload : boolean)');
    RegisterProperty('ExeName', 'string', iptr);
    RegisterMethod('Procedure Run( OwnerThread : TThread)');
    RegisterMethod('Function CanConnect( Address : string) : boolean');
    RegisterMethod('Function GetThread( I : integer) : TFCGIThread');
    RegisterMethod('Function ThreadsCount : integer');
    RegisterMethod('Function ReachedMaxConns : boolean');
    RegisterMethod('Procedure OnPortInUseError');
       RegisterMethod('Procedure Free');
     RegisterMethod('Constructor Create( pTitle : string; pFCGIThreadClass : TFCGIThreadClass; pPort : word; pMaxIdleMinutes : word; pShutdownAfterLastThreadDown : boolean; pMaxConns : integer)');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TFCGIThread(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TThread', 'TFCGIThread') do
  with CL.AddClassN(CL.FindClass('TThread'),'TFCGIThread') do begin
    RegisterProperty('BrowserCache', 'boolean', iptrw);
    RegisterProperty('Response', 'string', iptrw);
    RegisterProperty('ContentType', 'string', iptrw);
    RegisterProperty('UploadPath', 'string', iptrw);
    RegisterProperty('MaxUploadSize', 'integer', iptrw);
    RegisterProperty('Role', 'TRole', iptr);
    RegisterProperty('Request', 'string', iptr);
    RegisterProperty('PathInfo', 'string', iptr);
    RegisterProperty('LastAccess', 'TDateTime', iptr);
    RegisterProperty('RequestMethod', 'TRequestMethod', iptr);
    RegisterProperty('RequestHeader', 'string string', iptr);
    RegisterProperty('Cookie', 'string string', iptr);
    RegisterProperty('Query', 'string string', iptr);
    RegisterProperty('QueryAsBoolean', 'boolean string', iptr);
    RegisterProperty('QueryAsInteger', 'integer string', iptr);
    RegisterProperty('QueryAsDouble', 'double string', iptr);
    RegisterProperty('QueryAsTDateTime', 'TDateTime string', iptr);
    RegisterProperty('Queries', 'TStringList', iptr);
    RegisterProperty('FileUploaded', 'AnsiString', iptr);
    RegisterProperty('FileUploadedFullName', 'AnsiString', iptr);
    RegisterProperty('IsAjax', 'boolean', iptr);
    RegisterProperty('IsUpload', 'boolean', iptr);
    RegisterProperty('IsDownload', 'boolean', iptr);
    RegisterProperty('ScriptName', 'AnsiString', iptr);
    RegisterProperty('Browser', 'TBrowser', iptr);
    RegisterProperty('WebServer', 'string', iptr);
    RegisterMethod('Constructor Create( NewSocket : integer)');
       RegisterMethod('Procedure Free');
     RegisterMethod('Procedure AddToGarbage( const Name : string; Obj : TObject)');
    RegisterMethod('Procedure DeleteFromGarbage( Obj : TObject)');
    RegisterMethod('Function FindObject( Name : string) : TObject');
    RegisterMethod('Function ExistsReference( Name : string) : boolean');
    RegisterMethod('Procedure SendResponse( S : AnsiString; pRecType : TRecType)');
    RegisterMethod('Procedure SendEndRequest( Status : TProtocolStatus)');
    RegisterMethod('Procedure SetResponseHeader( Header : AnsiString)');
    RegisterMethod('Procedure Alert( Msg : string)');
    RegisterMethod('Procedure SetCookie( Name, Value : string; Expires : TDateTime; Domain : string; Path : string; Secure : boolean)');
    RegisterMethod('Function MethodURI( MethodName : string) : string;');
    RegisterMethod('Function MethodURI1( Method : TExtProcedure) : string;');
    RegisterMethod('Procedure DownloadBuffer( Name, Buffer : AnsiString; pContentType : string)');
    RegisterMethod('Procedure Terminate');
    RegisterMethod('Procedure Home');
    RegisterMethod('Procedure Logout');
    RegisterMethod('Procedure Shutdown');
    RegisterMethod('Procedure Reconfig');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_FCGIApp(CL: TPSPascalCompiler);
begin
  CL.AddTypeS('TRecType', '( rtBeginRequest, rtAbortRequest, rtEndRequest, rtPa'
   +'rams, rtStdIn, rtStdOut, rtStdErr, rtData, rtGetValues, rtGetValuesResult, rtUnknown )');
  CL.AddTypeS('TRole', '( rResponder, rAuthorizer, rFilter )');
  CL.AddTypeS('TProtocolStatus', '( psRequestComplete, psCantMPXConn, psOverloaded, psUnknownRole, psBusy )');
  CL.AddTypeS('TRequestMethod', '( rmGet, rmPost, rmHead, rmPut, rmDelete )');
  SIRegister_TFCGIThread(CL);
  //CL.AddTypeS('TFCGIThreadClass', 'class of TFCGIThread');
  SIRegister_TFCGIApplication(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TFCGIApplicationExeName_R(Self: TFCGIApplication; var T: string);
begin T := Self.ExeName; end;

(*----------------------------------------------------------------------------*)
procedure TFCGIApplicationConfig_W(Self: TFCGIApplication; const T: TIniFile);
Begin //Self.Config := T;
end;

(*----------------------------------------------------------------------------*)
procedure TFCGIApplicationConfig_R(Self: TFCGIApplication; var T: TIniFile);
Begin //T := Self.Config;
end;

(*----------------------------------------------------------------------------*)
procedure TFCGIApplicationHasConfig_W(Self: TFCGIApplication; const T: boolean);
Begin Self.HasConfig := T; end;

(*----------------------------------------------------------------------------*)
procedure TFCGIApplicationHasConfig_R(Self: TFCGIApplication; var T: boolean);
Begin T := Self.HasConfig; end;

(*----------------------------------------------------------------------------*)
procedure TFCGIApplicationPassword_W(Self: TFCGIApplication; const T: string);
Begin Self.Password := T; end;

(*----------------------------------------------------------------------------*)
procedure TFCGIApplicationPassword_R(Self: TFCGIApplication; var T: string);
Begin T := Self.Password; end;

(*----------------------------------------------------------------------------*)
procedure TFCGIApplicationIcon_W(Self: TFCGIApplication; const T: string);
Begin Self.Icon := T; end;

(*----------------------------------------------------------------------------*)
procedure TFCGIApplicationIcon_R(Self: TFCGIApplication; var T: string);
Begin T := Self.Icon; end;

(*----------------------------------------------------------------------------*)
procedure TFCGIApplicationTitle_W(Self: TFCGIApplication; const T: string);
Begin Self.Title := T; end;

(*----------------------------------------------------------------------------*)
procedure TFCGIApplicationTitle_R(Self: TFCGIApplication; var T: string);
Begin T := Self.Title; end;

(*----------------------------------------------------------------------------*)
procedure TFCGIApplicationShutdown_W(Self: TFCGIApplication; const T: boolean);
Begin Self.Shutdown := T; end;

(*----------------------------------------------------------------------------*)
procedure TFCGIApplicationShutdown_R(Self: TFCGIApplication; var T: boolean);
Begin T := Self.Shutdown; end;

(*----------------------------------------------------------------------------*)
procedure TFCGIApplicationGarbageNow_W(Self: TFCGIApplication; const T: boolean);
Begin Self.GarbageNow := T; end;

(*----------------------------------------------------------------------------*)
procedure TFCGIApplicationGarbageNow_R(Self: TFCGIApplication; var T: boolean);
Begin T := Self.GarbageNow; end;

(*----------------------------------------------------------------------------*)
procedure TFCGIApplicationTerminated_W(Self: TFCGIApplication; const T: boolean);
Begin Self.Terminated := T; end;

(*----------------------------------------------------------------------------*)
procedure TFCGIApplicationTerminated_R(Self: TFCGIApplication; var T: boolean);
Begin T := Self.Terminated; end;

(*----------------------------------------------------------------------------*)
Function TFCGIThreadMethodURI1_P(Self: TFCGIThread;  Method : TExtProcedure) : string;
Begin Result := Self.MethodURI(Method); END;

(*----------------------------------------------------------------------------*)
Function TFCGIThreadMethodURI_P(Self: TFCGIThread;  MethodName : string) : string;
Begin Result := Self.MethodURI(MethodName); END;

(*----------------------------------------------------------------------------*)
procedure TFCGIThreadWebServer_R(Self: TFCGIThread; var T: string);
begin T := Self.WebServer; end;

(*----------------------------------------------------------------------------*)
procedure TFCGIThreadBrowser_R(Self: TFCGIThread; var T: TBrowser);
begin T := Self.Browser; end;

(*----------------------------------------------------------------------------*)
procedure TFCGIThreadScriptName_R(Self: TFCGIThread; var T: AnsiString);
begin T := Self.ScriptName; end;

(*----------------------------------------------------------------------------*)
procedure TFCGIThreadIsDownload_R(Self: TFCGIThread; var T: boolean);
begin T := Self.IsDownload; end;

(*----------------------------------------------------------------------------*)
procedure TFCGIThreadIsUpload_R(Self: TFCGIThread; var T: boolean);
begin T := Self.IsUpload; end;

(*----------------------------------------------------------------------------*)
procedure TFCGIThreadIsAjax_R(Self: TFCGIThread; var T: boolean);
begin T := Self.IsAjax; end;

(*----------------------------------------------------------------------------*)
procedure TFCGIThreadFileUploadedFullName_R(Self: TFCGIThread; var T: AnsiString);
begin T := Self.FileUploadedFullName; end;

(*----------------------------------------------------------------------------*)
procedure TFCGIThreadFileUploaded_R(Self: TFCGIThread; var T: AnsiString);
begin T := Self.FileUploaded; end;

(*----------------------------------------------------------------------------*)
procedure TFCGIThreadQueries_R(Self: TFCGIThread; var T: TStringList);
begin T := Self.Queries; end;

(*----------------------------------------------------------------------------*)
procedure TFCGIThreadQueryAsTDateTime_R(Self: TFCGIThread; var T: TDateTime; const t1: string);
begin T := Self.QueryAsTDateTime[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TFCGIThreadQueryAsDouble_R(Self: TFCGIThread; var T: double; const t1: string);
begin T := Self.QueryAsDouble[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TFCGIThreadQueryAsInteger_R(Self: TFCGIThread; var T: integer; const t1: string);
begin T := Self.QueryAsInteger[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TFCGIThreadQueryAsBoolean_R(Self: TFCGIThread; var T: boolean; const t1: string);
begin T := Self.QueryAsBoolean[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TFCGIThreadQuery_R(Self: TFCGIThread; var T: string; const t1: string);
begin T := Self.Query[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TFCGIThreadCookie_R(Self: TFCGIThread; var T: string; const t1: string);
begin T := Self.Cookie[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TFCGIThreadRequestHeader_R(Self: TFCGIThread; var T: string; const t1: string);
begin T := Self.RequestHeader[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TFCGIThreadRequestMethod_R(Self: TFCGIThread; var T: TRequestMethod);
begin T := Self.RequestMethod; end;

(*----------------------------------------------------------------------------*)
procedure TFCGIThreadLastAccess_R(Self: TFCGIThread; var T: TDateTime);
begin T := Self.LastAccess; end;

(*----------------------------------------------------------------------------*)
procedure TFCGIThreadPathInfo_R(Self: TFCGIThread; var T: string);
begin T := Self.PathInfo; end;

(*----------------------------------------------------------------------------*)
procedure TFCGIThreadRequest_R(Self: TFCGIThread; var T: string);
begin T := Self.Request; end;

(*----------------------------------------------------------------------------*)
procedure TFCGIThreadRole_R(Self: TFCGIThread; var T: TRole);
begin T := Self.Role; end;

(*----------------------------------------------------------------------------*)
procedure TFCGIThreadMaxUploadSize_W(Self: TFCGIThread; const T: integer);
Begin Self.MaxUploadSize := T; end;

(*----------------------------------------------------------------------------*)
procedure TFCGIThreadMaxUploadSize_R(Self: TFCGIThread; var T: integer);
Begin T := Self.MaxUploadSize; end;

(*----------------------------------------------------------------------------*)
procedure TFCGIThreadUploadPath_W(Self: TFCGIThread; const T: string);
Begin Self.UploadPath := T; end;

(*----------------------------------------------------------------------------*)
procedure TFCGIThreadUploadPath_R(Self: TFCGIThread; var T: string);
Begin T := Self.UploadPath; end;

(*----------------------------------------------------------------------------*)
procedure TFCGIThreadContentType_W(Self: TFCGIThread; const T: string);
Begin Self.ContentType := T; end;

(*----------------------------------------------------------------------------*)
procedure TFCGIThreadContentType_R(Self: TFCGIThread; var T: string);
Begin T := Self.ContentType; end;

(*----------------------------------------------------------------------------*)
procedure TFCGIThreadResponse_W(Self: TFCGIThread; const T: string);
Begin Self.Response := T; end;

(*----------------------------------------------------------------------------*)
procedure TFCGIThreadResponse_R(Self: TFCGIThread; var T: string);
Begin T := Self.Response; end;

(*----------------------------------------------------------------------------*)
procedure TFCGIThreadBrowserCache_W(Self: TFCGIThread; const T: boolean);
Begin Self.BrowserCache := T; end;

(*----------------------------------------------------------------------------*)
procedure TFCGIThreadBrowserCache_R(Self: TFCGIThread; var T: boolean);
Begin T := Self.BrowserCache; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TFCGIApplication(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TFCGIApplication) do begin
    RegisterPropertyHelper(@TFCGIApplicationTerminated_R,@TFCGIApplicationTerminated_W,'Terminated');
    RegisterPropertyHelper(@TFCGIApplicationGarbageNow_R,@TFCGIApplicationGarbageNow_W,'GarbageNow');
    RegisterPropertyHelper(@TFCGIApplicationShutdown_R,@TFCGIApplicationShutdown_W,'Shutdown');
    RegisterPropertyHelper(@TFCGIApplicationTitle_R,@TFCGIApplicationTitle_W,'Title');
    RegisterPropertyHelper(@TFCGIApplicationIcon_R,@TFCGIApplicationIcon_W,'Icon');
    RegisterPropertyHelper(@TFCGIApplicationPassword_R,@TFCGIApplicationPassword_W,'Password');
    RegisterPropertyHelper(@TFCGIApplicationHasConfig_R,@TFCGIApplicationHasConfig_W,'HasConfig');
    RegisterPropertyHelper(@TFCGIApplicationConfig_R,@TFCGIApplicationConfig_W,'Config');
    //RegisterMethod(@TFCGIApplication.ReadConfig, 'ReadConfig');
    //RegisterMethod(@TFCGIApplication.Reconfig, 'Reconfig');
    RegisterPropertyHelper(@TFCGIApplicationExeName_R,nil,'ExeName');
    RegisterMethod(@TFCGIApplication.Run, 'Run');
    RegisterMethod(@TFCGIApplication.CanConnect, 'CanConnect');
    RegisterMethod(@TFCGIApplication.GetThread, 'GetThread');
    RegisterMethod(@TFCGIApplication.ThreadsCount, 'ThreadsCount');
    RegisterMethod(@TFCGIApplication.ReachedMaxConns, 'ReachedMaxConns');
    RegisterVirtualMethod(@TFCGIApplication.OnPortInUseError, 'OnPortInUseError');
    RegisterConstructor(@TFCGIApplication.Create, 'Create');
       RegisterMethod(@TFCGIApplication.Destroy, 'Free');

  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TFCGIThread(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TFCGIThread) do begin
    RegisterPropertyHelper(@TFCGIThreadBrowserCache_R,@TFCGIThreadBrowserCache_W,'BrowserCache');
    RegisterPropertyHelper(@TFCGIThreadResponse_R,@TFCGIThreadResponse_W,'Response');
    RegisterPropertyHelper(@TFCGIThreadContentType_R,@TFCGIThreadContentType_W,'ContentType');
    RegisterPropertyHelper(@TFCGIThreadUploadPath_R,@TFCGIThreadUploadPath_W,'UploadPath');
    RegisterPropertyHelper(@TFCGIThreadMaxUploadSize_R,@TFCGIThreadMaxUploadSize_W,'MaxUploadSize');
    RegisterPropertyHelper(@TFCGIThreadRole_R,nil,'Role');
    RegisterPropertyHelper(@TFCGIThreadRequest_R,nil,'Request');
    RegisterPropertyHelper(@TFCGIThreadPathInfo_R,nil,'PathInfo');
    RegisterPropertyHelper(@TFCGIThreadLastAccess_R,nil,'LastAccess');
    RegisterPropertyHelper(@TFCGIThreadRequestMethod_R,nil,'RequestMethod');
    RegisterPropertyHelper(@TFCGIThreadRequestHeader_R,nil,'RequestHeader');
    RegisterPropertyHelper(@TFCGIThreadCookie_R,nil,'Cookie');
    RegisterPropertyHelper(@TFCGIThreadQuery_R,nil,'Query');
    RegisterPropertyHelper(@TFCGIThreadQueryAsBoolean_R,nil,'QueryAsBoolean');
    RegisterPropertyHelper(@TFCGIThreadQueryAsInteger_R,nil,'QueryAsInteger');
    RegisterPropertyHelper(@TFCGIThreadQueryAsDouble_R,nil,'QueryAsDouble');
    RegisterPropertyHelper(@TFCGIThreadQueryAsTDateTime_R,nil,'QueryAsTDateTime');
    RegisterPropertyHelper(@TFCGIThreadQueries_R,nil,'Queries');
    RegisterPropertyHelper(@TFCGIThreadFileUploaded_R,nil,'FileUploaded');
    RegisterPropertyHelper(@TFCGIThreadFileUploadedFullName_R,nil,'FileUploadedFullName');
    RegisterPropertyHelper(@TFCGIThreadIsAjax_R,nil,'IsAjax');
    RegisterPropertyHelper(@TFCGIThreadIsUpload_R,nil,'IsUpload');
    RegisterPropertyHelper(@TFCGIThreadIsDownload_R,nil,'IsDownload');
    RegisterPropertyHelper(@TFCGIThreadScriptName_R,nil,'ScriptName');
    RegisterPropertyHelper(@TFCGIThreadBrowser_R,nil,'Browser');
    RegisterPropertyHelper(@TFCGIThreadWebServer_R,nil,'WebServer');
    RegisterConstructor(@TFCGIThread.Create, 'Create');
       RegisterMethod(@TFCGIThread.Destroy, 'Free');

    RegisterMethod(@TFCGIThread.AddToGarbage, 'AddToGarbage');
    RegisterMethod(@TFCGIThread.DeleteFromGarbage, 'DeleteFromGarbage');
    RegisterMethod(@TFCGIThread.FindObject, 'FindObject');
    RegisterMethod(@TFCGIThread.ExistsReference, 'ExistsReference');
    RegisterMethod(@TFCGIThread.SendResponse, 'SendResponse');
    RegisterMethod(@TFCGIThread.SendEndRequest, 'SendEndRequest');
    RegisterMethod(@TFCGIThread.SetResponseHeader, 'SetResponseHeader');
    RegisterVirtualMethod(@TFCGIThread.Alert, 'Alert');
    RegisterMethod(@TFCGIThread.SetCookie, 'SetCookie');
    RegisterMethod(@TFCGIThreadMethodURI_P, 'MethodURI');
    RegisterMethod(@TFCGIThreadMethodURI1_P, 'MethodURI1');
    RegisterMethod(@TFCGIThread.DownloadBuffer, 'DownloadBuffer');
    RegisterMethod(@TFCGIThread.Terminate, 'Terminate');
    //RegisterVirtualAbstractMethod(@TFCGIThread, @!.Home, 'Home');
    RegisterVirtualMethod(@TFCGIThread.Logout, 'Logout');
    RegisterVirtualMethod(@TFCGIThread.Shutdown, 'Shutdown');
   // RegisterVirtualMethod(@TFCGIThread.Reconfig, 'Reconfig');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_FCGIApp(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TFCGIThread(CL);
  RIRegister_TFCGIApplication(CL);
end;

 
 
{ TPSImport_FCGIApp }
(*----------------------------------------------------------------------------*)
procedure TPSImport_FCGIApp.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_FCGIApp(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_FCGIApp.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_FCGIApp(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
