unit uPSI_SvrHTTPIndy;
{
  in the end a rest machine
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
  TPSImport_SvrHTTPIndy = class(TPSPlugin)
  public
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TServerLog(CL: TPSPascalCompiler);
procedure SIRegister_TCustomWebServer(CL: TPSPascalCompiler);
procedure SIRegister_TWebServerResponse(CL: TPSPascalCompiler);
procedure SIRegister_TWebServerRequest(CL: TPSPascalCompiler);
procedure SIRegister_TRequestLogBuffer(CL: TPSPascalCompiler);
procedure SIRegister_TServerIntercept(CL: TPSPascalCompiler);
procedure SIRegister_TConnectionIntercept(CL: TPSPascalCompiler);
procedure SIRegister_EWebServerException(CL: TPSPascalCompiler);
procedure SIRegister_SvrHTTPIndy(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_SvrHTTPIndy_Routines(S: TPSExec);
procedure RIRegister_TServerLog(CL: TPSRuntimeClassImporter);
procedure RIRegister_TCustomWebServer(CL: TPSRuntimeClassImporter);
procedure RIRegister_TWebServerResponse(CL: TPSRuntimeClassImporter);
procedure RIRegister_TWebServerRequest(CL: TPSRuntimeClassImporter);
procedure RIRegister_TRequestLogBuffer(CL: TPSRuntimeClassImporter);
procedure RIRegister_TServerIntercept(CL: TPSRuntimeClassImporter);
procedure RIRegister_TConnectionIntercept(CL: TPSRuntimeClassImporter);
procedure RIRegister_EWebServerException(CL: TPSRuntimeClassImporter);
procedure RIRegister_SvrHTTPIndy(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   Windows
  ,Registry
  ,SyncObjs
  ,WebBroker
  ,HTTPApp
  ,SvrLog
  ,IdHTTPServer
  ,IdHTTP
  ,IdCustomHTTPServer
  ,IdTCPServer
  ,IdIntercept
  ,IdSocketHandle
  ,IniFiles
  ,SockAppNotify
  ,IdStackConsts
  ,IdGlobal
  ,SvrHTTPIndy, mshtml, ActiveX, COMObj, idURI, Forms, Variants
  ,JPEG, Graphics;
 
 
procedure Register;
begin
  //RegisterComponents('Pascal Script', [TPSImport_SvrHTTPIndy]);
end;

function DownloadJPGToBitmap(const URL : string; ABitmap: TBitmap): Boolean;
var
  idHttp: TIdHTTP;
  ImgStream: TMemoryStream;
  JpgImage: TJPEGImage;
begin
  Result := False;
  ImgStream := TMemoryStream.Create;
  try
    idHttp := TIdHTTP.Create(nil);
    try
      idHttp.Get(URL, ImgStream);
    finally
      idHttp.Free;
    end;
    ImgStream.Position := 0;
    JpgImage := TJPEGImage.Create;
    try
      JpgImage.LoadFromStream(ImgStream);
      ABitmap.Assign(JpgImage);
    finally
      Result := True;
      JpgImage.Free;
    end;
  finally
    ImgStream.Free;
  end;
end;

procedure GetImageLinks(AURL: string; AList: TStrings);
var
  IDoc: IHTMLDocument2;
  strHTML: string;
  v: Variant;
  x: Integer;
  ovLinks: OleVariant;
  DocURL: string;
  URI: TidURI;
  ImgURL: string;
  idHTTP: TidHTTP;
begin
  AList.Clear;
  URI := TidURI.Create(AURL);
  try
    DocURL := 'http://' + URI.Host;
    if URI.Path <> '/' then
      DocURL := DocURL + URI.Path;
  finally
    URI.Free;
  end;
  Idoc := CreateComObject(Class_HTMLDocument) as IHTMLDocument2;
  try
    IDoc.designMode := 'on';
    while IDoc.readyState <> 'complete' do
      Application.ProcessMessages;
    v      := VarArrayCreate([0, 0], VarVariant);
    idHTTP := TidHTTP.Create(nil);
    try
      strHTML := idHTTP.Get(AURL);
    finally
      idHTTP.Free;
    end;
    v[0] := strHTML;
    IDoc.Write(PSafeArray(System.TVarData(v).VArray));
    IDoc.designMode := 'off';
    while IDoc.readyState <> 'complete' do
      Application.ProcessMessages;
    ovLinks := IDoc.all.tags('IMG');
    if ovLinks.Length > 0 then
    begin
      for x := 0 to ovLinks.Length - 1 do
      begin
        ImgURL := ovLinks.Item(x).src;
        // The stuff below will probably need a little tweaking
        // Deteriming and turning realtive URLs into absolute URLs
        // is not that difficult but this is all I could come up with
        // in such a short notice.
        if (ImgURL[1] = '/') then
        begin
          // more than likely a relative URL so
          // append the DocURL
          ImgURL := DocURL + ImgUrl;
        end
        else
        begin
          if (Copy(ImgURL, 1, 11) = 'about:blank') then
          begin
            ImgURL := DocURL + Copy(ImgUrl, 12, Length(ImgURL));
          end;
        end;
        AList.Add(ImgURL);
      end;
    end;
  finally
    IDoc := nil;
  end;
end;




(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TServerLog(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TCustomServerLog', 'TServerLog') do
  with CL.AddClassN(CL.FindClass('TCustomServerLog'),'TServerLog') do
  begin
    RegisterMethod('Constructor Create( AServer : TCustomWebServer)');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TCustomWebServer(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TComponent', 'TCustomWebServer') do
  with CL.AddClassN(CL.FindClass('TComponent'),'TCustomWebServer') do begin
    RegisterMethod('Procedure GetOpenSockets( var Sockets : TSocketArray)');
    RegisterProperty('TranslatedDefaultURL', 'string', iptr);
    RegisterProperty('Active', 'Boolean', iptrw);
    RegisterProperty('URI', 'string', iptr);

    RegisterProperty('SearchPath', 'string', iptrw);
    RegisterProperty('DefaultURL', 'string', iptrw);
    RegisterProperty('Port', 'Integer', iptrw);
    RegisterProperty('OnLog', 'THTTPLogEvent', iptrw);
    RegisterProperty('RunningWebAppListener', 'TRunningWebAppListener', iptr);
    RegisterMethod('Constructor Create( AOwner : TComponent)');
        RegisterMethod('Procedure Free');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TWebServerResponse(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TWebResponse', 'TWebServerResponse') do
  with CL.AddClassN(CL.FindClass('TWebResponse'),'TWebServerResponse') do begin
    RegisterMethod('Procedure SendResponse');
    RegisterMethod('Procedure SendRedirect( const URI : string)');
    RegisterMethod('Procedure SendStream( AStream : TStream)');
    RegisterMethod('function Sent: Boolean; ');
    RegisterProperty('Request', 'TWebServerRequest', iptr);
    RegisterMethod('Procedure Free');
    RegisterMethod('Constructor Create( ARequest : TWebServerRequest; AResponseInfo : TIdHTTPResponseInfo; ALog : TServerLog)');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TWebServerRequest(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TWebRequest', 'TWebServerRequest') do
  with CL.AddClassN(CL.FindClass('TWebRequest'),'TWebServerRequest') do begin
    RegisterMethod('Constructor Create( APort : Integer; ARemoteAddress, ARemoteHost : string; ARequestInfo : TIdHTTPRequestInfo; AResponseInfo : TIdHTTPResponseInfo; AThread : TThread)');
    RegisterMethod('Function GetFieldByName( const Name : string) : string');
    RegisterMethod('Function ReadClient( var Buffer, Count : Integer) : Integer');
    RegisterMethod('Function ReadString( Count : Integer) : string');
    RegisterMethod('Function TranslateURI( const URI : string) : string');
    RegisterMethod('Function WriteClient( var Buffer, Count : Integer) : Integer');
    RegisterMethod('Function WriteString( const AString : string) : Boolean');
    RegisterMethod('Function WriteHeaders( StatusCode : Integer; const StatusString, Headers : string) : Boolean');
    RegisterProperty('RequestInfo', 'TIdHTTPRequestInfo', iptr);
    RegisterProperty('Thread', 'TThread', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TRequestLogBuffer(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TObject', 'TRequestLogBuffer') do
  with CL.AddClassN(CL.FindClass('TObject'),'TRequestLogBuffer') do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TServerIntercept(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TIdServerIntercept', 'TServerIntercept') do
  with CL.AddClassN(CL.FindClass('TIdServerIntercept'),'TServerIntercept') do
  begin
    RegisterMethod('Procedure Init');
    RegisterMethod('Function Accept( ABinding : TIdSocketHandle) : TIdConnectionIntercept');
    RegisterMethod('Function Accept( AConnection : TComponent) : TIdConnectionIntercept');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TConnectionIntercept(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TIdConnectionIntercept', 'TConnectionIntercept') do
  with CL.AddClassN(CL.FindClass('TIdConnectionIntercept'),'TConnectionIntercept') do begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
    RegisterMethod('Procedure Free');
    RegisterMethod('Procedure DataReceived( var ABuffer : string; const AByteCount : integer)');
    RegisterMethod('Procedure DataSent( var ABuffer : string; const AByteCount : integer)');
    RegisterMethod('Procedure Receive( ABuffer : TStream)');
    RegisterMethod('Procedure Send( ABuffer : TStream)');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_EWebServerException(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'Exception', 'EWebServerException') do
  with CL.AddClassN(CL.FindClass('Exception'),'EWebServerException') do
  begin
    RegisterMethod('Constructor Create( const Message : string; ARequest : TWebServerRequest)');
    RegisterProperty('Request', 'TWebServerRequest', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
  {SIRegister_HTTPProd(X);
  SIRegister_IndySockTransport(X);
  SIRegister_synacrypt(X);

 RIRegister_HTTPProd(X);
  RIRegister_HTTPProd_Routines(Exec);
  RIRegister_IndySockTransport(X);
  RIRegister_synacrypt(X);
  RIRegister_synacrypt_Routines(Exec);    }

procedure SIRegister_SvrHTTPIndy(CL: TPSPascalCompiler);
begin
  CL.AddClassN(CL.FindClass('TOBJECT'),'TCustomWebServer');
  CL.AddClassN(CL.FindClass('TOBJECT'),'TWebServerRequest');
  SIRegister_EWebServerException(CL);
  CL.AddClassN(CL.FindClass('TOBJECT'),'EFailedToRetreiveTimeZoneInfo');
  SIRegister_TConnectionIntercept(CL);
  SIRegister_TServerIntercept(CL);
  SIRegister_TRequestLogBuffer(CL);
  SIRegister_TWebServerRequest(CL);
  CL.AddClassN(CL.FindClass('TOBJECT'),'TServerLog');
  SIRegister_TWebServerResponse(CL);
  CL.AddTypeS('TSocketArray', 'array of TIdStackSocketHandle');
  CL.AddTypeS('TidErrorCode', '( ecTimeout, ecExecFail, ecTokenMismatch, ecOK )');
  SIRegister_TCustomWebServer(CL);
  SIRegister_TServerLog(CL);
 //CL.AddDelphiFunction('Procedure CloseOpenSockets( Sockets : array of TIdStackSocketHandle)');
 CL.AddDelphiFunction('function DownloadJPGToBitmap(const URL : string; ABitmap: TBitmap): Boolean;)');
 CL.AddDelphiFunction('procedure GetImageLinks(AURL: string; AList: TStrings);');

end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TCustomWebServerRunningWebAppListener_R(Self: TCustomWebServer; var T: TRunningWebAppListener);
begin T := Self.RunningWebAppListener; end;

(*----------------------------------------------------------------------------*)
procedure TCustomWebServerOnLog_W(Self: TCustomWebServer; const T: THTTPLogEvent);
begin Self.OnLog := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomWebServerOnLog_R(Self: TCustomWebServer; var T: THTTPLogEvent);
begin T := Self.OnLog; end;

(*----------------------------------------------------------------------------*)
procedure TCustomWebServerPort_W(Self: TCustomWebServer; const T: Integer);
begin Self.Port := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomWebServerPort_R(Self: TCustomWebServer; var T: Integer);
begin T := Self.Port; end;

(*----------------------------------------------------------------------------*)
procedure TCustomWebServerDefaultURL_W(Self: TCustomWebServer; const T: string);
begin Self.DefaultURL := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomWebServerDefaultURL_R(Self: TCustomWebServer; var T: string);
begin T := Self.DefaultURL; end;

(*----------------------------------------------------------------------------*)
procedure TCustomWebServerSearchPath_W(Self: TCustomWebServer; const T: string);
begin Self.SearchPath := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomWebServerSearchPath_R(Self: TCustomWebServer; var T: string);
begin T := Self.SearchPath; end;

(*----------------------------------------------------------------------------*)
procedure TCustomWebServerActive_W(Self: TCustomWebServer; const T: Boolean);
begin Self.Active := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomWebServerActive_R(Self: TCustomWebServer; var T: Boolean);
begin T := Self.Active; end;

(*----------------------------------------------------------------------------*)
procedure TCustomWebServerTranslatedDefaultURL_R(Self: TCustomWebServer; var T: string);
begin T := Self.TranslatedDefaultURL; end;

(*----------------------------------------------------------------------------*)
procedure TWebServerResponseRequest_R(Self: TWebServerResponse; var T: TWebServerRequest);
begin T := Self.Request; end;

(*----------------------------------------------------------------------------*)
procedure TWebServerRequestThread_R(Self: TWebServerRequest; var T: TThread);
begin T := Self.Thread; end;

(*----------------------------------------------------------------------------*)
procedure TWebServerRequestRequestInfo_R(Self: TWebServerRequest; var T: TIdHTTPRequestInfo);
begin T := Self.RequestInfo; end;

(*----------------------------------------------------------------------------*)
procedure EWebServerExceptionRequest_R(Self: EWebServerException; var T: TWebServerRequest);
begin T := Self.Request; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_SvrHTTPIndy_Routines(S: TPSExec);
begin
 //S.RegisterDelphiFunction(@CloseOpenSockets, 'CloseOpenSockets', cdRegister);
 S.RegisterDelphiFunction(@DownloadJPGToBitmap, 'DownloadJPGToBitmap', cdRegister);
 S.RegisterDelphiFunction(@GetImageLinks, 'GetImageLinks', cdRegister);
//procedure GetImageLinks(AURL: string; AList: TStrings);
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TServerLog(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TServerLog) do
  begin
    RegisterConstructor(@TServerLog.Create, 'Create');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TCustomWebServer(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TCustomWebServer) do begin
    //RegisterMethod(@TCustomWebServer.GetOpenSockets, 'GetOpenSockets');
    RegisterPropertyHelper(@TCustomWebServerTranslatedDefaultURL_R,nil,'TranslatedDefaultURL');
    RegisterPropertyHelper(@TCustomWebServerTranslatedDefaultURL_R,nil,'URI');

    RegisterPropertyHelper(@TCustomWebServerActive_R,@TCustomWebServerActive_W,'Active');
    RegisterPropertyHelper(@TCustomWebServerSearchPath_R,@TCustomWebServerSearchPath_W,'SearchPath');
    RegisterPropertyHelper(@TCustomWebServerDefaultURL_R,@TCustomWebServerDefaultURL_W,'DefaultURL');
    RegisterPropertyHelper(@TCustomWebServerPort_R,@TCustomWebServerPort_W,'Port');
    RegisterPropertyHelper(@TCustomWebServerOnLog_R,@TCustomWebServerOnLog_W,'OnLog');
    RegisterPropertyHelper(@TCustomWebServerRunningWebAppListener_R,nil,'RunningWebAppListener');
    RegisterConstructor(@TCustomWebServer.Create, 'Create');
    RegisterMethod(@TCustomWebServer.Destroy, 'Free');
    end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TWebServerResponse(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TWebServerResponse) do begin
    RegisterMethod(@TWebServerResponse.SendResponse, 'SendResponse');
    RegisterMethod(@TWebServerResponse.SendRedirect, 'SendRedirect');
    RegisterMethod(@TWebServerResponse.SendStream, 'SendStream');
    RegisterMethod(@TWebServerResponse.Sent, 'Sent');
    RegisterPropertyHelper(@TWebServerResponseRequest_R,nil,'Request');
    RegisterConstructor(@TWebServerResponse.Create, 'Create');
    RegisterMethod(@TWebServerResponse.Destroy, 'Free');

  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TWebServerRequest(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TWebServerRequest) do begin
    RegisterConstructor(@TWebServerRequest.Create, 'Create');
    RegisterMethod(@TWebServerRequest.GetFieldByName, 'GetFieldByName');
    RegisterMethod(@TWebServerRequest.ReadClient, 'ReadClient');
    RegisterMethod(@TWebServerRequest.ReadString, 'ReadString');
    RegisterMethod(@TWebServerRequest.TranslateURI, 'TranslateURI');
    RegisterMethod(@TWebServerRequest.WriteClient, 'WriteClient');
    RegisterMethod(@TWebServerRequest.WriteString, 'WriteString');
    RegisterMethod(@TWebServerRequest.WriteHeaders, 'WriteHeaders');
    RegisterPropertyHelper(@TWebServerRequestRequestInfo_R,nil,'RequestInfo');
    RegisterPropertyHelper(@TWebServerRequestThread_R,nil,'Thread');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TRequestLogBuffer(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TRequestLogBuffer) do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TServerIntercept(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TServerIntercept) do
  begin
    RegisterMethod(@TServerIntercept.Init, 'Init');
    RegisterMethod(@TServerIntercept.Accept, 'Accept');
    RegisterMethod(@TServerIntercept.Accept, 'Accept');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TConnectionIntercept(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TConnectionIntercept) do begin
    RegisterConstructor(@TConnectionIntercept.Create, 'Create');
     RegisterMethod(@TConnectionIntercept.Destroy, 'Free');
    //RegisterMethod(@TConnectionIntercept.DataReceived, 'DataReceived');
    //RegisterMethod(@TConnectionIntercept.DataSent, 'DataSent');
    RegisterMethod(@TConnectionIntercept.Receive, 'Receive');
    RegisterMethod(@TConnectionIntercept.Send, 'Send');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_EWebServerException(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(EWebServerException) do
  begin
    RegisterConstructor(@EWebServerException.Create, 'Create');
    RegisterPropertyHelper(@EWebServerExceptionRequest_R,nil,'Request');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_SvrHTTPIndy(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TCustomWebServer) do
  with CL.Add(TWebServerRequest) do
  RIRegister_EWebServerException(CL);
  with CL.Add(EFailedToRetreiveTimeZoneInfo) do
  RIRegister_TConnectionIntercept(CL);
  RIRegister_TServerIntercept(CL);
  RIRegister_TRequestLogBuffer(CL);
  RIRegister_TWebServerRequest(CL);
  with CL.Add(TServerLog) do
  RIRegister_TWebServerResponse(CL);
  RIRegister_TCustomWebServer(CL);
  RIRegister_TServerLog(CL);
end;

 
 
{ TPSImport_SvrHTTPIndy }
(*----------------------------------------------------------------------------*)
procedure TPSImport_SvrHTTPIndy.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_SvrHTTPIndy(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_SvrHTTPIndy.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_SvrHTTPIndy(ri);
  RIRegister_SvrHTTPIndy_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
