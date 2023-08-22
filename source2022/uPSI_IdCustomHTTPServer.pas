unit uPSI_IdCustomHTTPServer;
{     add publish in httpserver
  also as addon for https server   , direct  RIRegister_TIdHTTPServer(CL);, more free methods and one abstract
    add URI as ûsername for workaraound}
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
  TPSImport_IdCustomHTTPServer = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TIdHTTPServer(CL: TPSPascalCompiler);
procedure SIRegister_TIdHTTPDefaultSessionList(CL: TPSPascalCompiler);
procedure SIRegister_TIdCustomHTTPServer(CL: TPSPascalCompiler);
procedure SIRegister_TIdHTTPCustomSessionList(CL: TPSPascalCompiler);
procedure SIRegister_TIdHTTPSession(CL: TPSPascalCompiler);
procedure SIRegister_TIdHTTPResponseInfo(CL: TPSPascalCompiler);
procedure SIRegister_TIdHTTPRequestInfo(CL: TPSPascalCompiler);
procedure SIRegister_IdCustomHTTPServer(CL: TPSPascalCompiler);


{ run-time registration functions }
procedure RIRegister_IdCustomHTTPServer_Routines(S: TPSExec);
procedure RIRegister_TIdHTTPServer(CL: TPSRuntimeClassImporter);
procedure RIRegister_TIdHTTPDefaultSessionList(CL: TPSRuntimeClassImporter);
procedure RIRegister_TIdCustomHTTPServer(CL: TPSRuntimeClassImporter);
procedure RIRegister_TIdHTTPCustomSessionList(CL: TPSRuntimeClassImporter);
procedure RIRegister_TIdHTTPSession(CL: TPSRuntimeClassImporter);
procedure RIRegister_TIdHTTPResponseInfo(CL: TPSRuntimeClassImporter);
procedure RIRegister_TIdHTTPRequestInfo(CL: TPSRuntimeClassImporter);
procedure RIRegister_IdCustomHTTPServer(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   IdAssignedNumbers
  ,IdException
  ,IdGlobal
  ,IdHeaderList
  ,IdTCPServer
  ,IdThread
  ,IdCookie
  ,IdHTTPHeaderInfo
  ,IdStackConsts
  ,IdStack
  ,SyncObjs
  ,IdIcmpclient
  ,IdCustomHTTPServer
  ,IdHTTPServer
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_IdCustomHTTPServer]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
Function BoolToStr(value : boolean) : string;
Begin If value then Result := 'TRUE' else Result := 'FALSE' End;


  // Calculate the number of MS between two TimeStamps
function TimeStampInterval(StartStamp, EndStamp: TDateTime): integer;
var
  days: Integer;
  hour, min, s, ms: Word;
begin
  days := Trunc(EndStamp - StartStamp); // whole days
  DecodeTime(EndStamp - StartStamp, hour, min, s, ms);
  result := (((days * 24 + hour) * 60 + min) * 60 + s) * 1000 + ms;
end;

function GetRandomString(NumChar: cardinal): string;
const
  CharMap='qwertzuiopasdfghjklyxcvbnmQWERTZUIOPASDFGHJKLYXCVBNM1234567890';    {Do not Localize}
var
  i: integer;
  MaxChar: cardinal;
begin
  randomize;
  MaxChar := length(CharMap) - 1;
  for i := 1 to NumChar do
  begin
    // Add one because CharMap is 1-based
    Result := result + CharMap[Random(maxChar) + 1];
  end;
end;

function CreateIDStack: TIdStack;
begin
  Result:= GStackClass.Create;
end;

function MPing(const AHost: string;const ATimes:integer; out AvgMS:Double):Boolean;
var
R : array of Cardinal;
i : integer;
AQuote: string;
begin
  Result := True;
  AvgMS := 0;
  if ATimes > 0 then
  with TIdIcmpClient.Create(NIL) do
  try
    Host:= AHost;
    SetLength(R, ATimes);
    {Pinguer le client}
    for i:= 0 to Pred(ATimes) do begin
      try
       Ping(AQuote,1);
       R[i]:= ReplyStatus.MsRoundTripTime;
      except
        Result := False;
        Exit;
      end;
    end;
  {Faire une moyenne}
    for i:= Low(R) to High(R) do
      AvgMS := AvgMS + R[i];
      AvgMS := AvgMS / i;
  finally
    Free;
  end;
end;



(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TIdHTTPServer(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TIdCustomHTTPServer', 'TIdHTTPServer') do
  with CL.AddClassN(CL.FindClass('TIdCustomHTTPServer'),'TIdHTTPServer') do begin
      RegisterPublishedProperties;
    RegisterProperty('OnCreatePostStream', 'TOnCreatePostStream', iptrw);
    RegisterProperty('OnCommandGet', 'TIdHTTPGetEvent', iptrw);
   //   property OnCreatePostStream;
   // property OnCommandGet;
  end;
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure RIRegister_TIdHTTPServer(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TIdHTTPServer) do begin
      //RegisterPublishedProperties;
  end;
end;



(*----------------------------------------------------------------------------*)
procedure SIRegister_TIdHTTPDefaultSessionList(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TIdHTTPCustomSessionList', 'TIdHTTPDefaultSessionList') do
  with CL.AddClassN(CL.FindClass('TIdHTTPCustomSessionList'),'TIdHTTPDefaultSessionList') do  begin
    RegisterPublishedProperties;
    RegisterMethod('Constructor Create( AOwner : TComponent)');
    RegisterMethod('Procedure Free');
    RegisterMethod('Procedure Clear');
    RegisterMethod('Procedure PurgeStaleSessions( PurgeAll : Boolean)');
    RegisterMethod('Function CreateUniqueSession( const RemoteIP : String) : TIdHTTPSession');
    RegisterMethod('Function CreateSession( const RemoteIP, SessionID : String) : TIdHTTPSession');
    RegisterMethod('Function GetSession( const SessionID, RemoteIP : string) : TIdHTTPSession');
    RegisterMethod('Procedure Add( ASession : TIdHTTPSession)');
    RegisterProperty('SessionTimeout', 'Integer', iptrw);
    RegisterProperty('OnSessionEnd', 'TOnSessionEndEvent', iptrw);
    RegisterProperty('OnSessionStart', 'TOnSessionStartEvent', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TIdCustomHTTPServer(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TIdTCPServer', 'TIdCustomHTTPServer') do
  with CL.AddClassN(CL.FindClass('TIdTCPServer'),'TIdCustomHTTPServer') do begin
    RegisterPublishedProperties;
    RegisterMethod('Constructor Create( AOwner : TComponent)');
   RegisterMethod('Procedure Free');
    RegisterMethod('Function CreateSession( AThread : TIdPeerThread; HTTPResponse : TIdHTTPResponseInfo; HTTPRequest : TIdHTTPRequestInfo) : TIdHTTPSession');
    RegisterMethod('Function EndSession( const SessionName : string) : boolean');
    RegisterMethod('Function ServeFile( AThread : TIdPeerThread; ResponseInfo : TIdHTTPResponseInfo; aFile : TFileName) : cardinal');
    RegisterProperty('MIMETable', 'TIdMimeTable', iptr);
    RegisterProperty('SessionList', 'TIdHTTPCustomSessionList', iptr);
    RegisterProperty('AutoStartSession', 'boolean', iptrw);
    RegisterProperty('OnInvalidSession', 'TIdHTTPInvalidSessionEvent', iptrw);
    RegisterProperty('OnSessionStart', 'TOnSessionStartEvent', iptrw);
    RegisterProperty('OnSessionEnd', 'TOnSessionEndEvent', iptrw);
    RegisterProperty('OnCreateSession', 'TOnCreateSession', iptrw);
    RegisterProperty('KeepAlive', 'Boolean', iptrw);
    RegisterProperty('ParseParams', 'boolean', iptrw);
    RegisterProperty('ServerSoftware', 'string', iptrw);
    RegisterProperty('SessionState', 'Boolean', iptrw);
    RegisterProperty('SessionTimeOut', 'Integer', iptrw);
    RegisterProperty('OnCommandOther', 'TIdHTTPOtherEvent', iptrw);
    RegisterProperty('OnCommandGet', 'TIdHTTPGetEvent', iptrw);
    RegisterProperty('OnCreatePostStream', 'TOnCreatePostStream', iptrw);

  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TIdHTTPCustomSessionList(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TComponent', 'TIdHTTPCustomSessionList') do
  with CL.AddClassN(CL.FindClass('TComponent'),'TIdHTTPCustomSessionList') do begin
   RegisterMethod('Constructor Create( AOwner : TComponent)');
    RegisterMethod('Procedure Free');
    RegisterMethod('Procedure Clear');
    RegisterMethod('Procedure PurgeStaleSessions( PurgeAll : Boolean)');
    RegisterMethod('Function CreateUniqueSession( const RemoteIP : String) : TIdHTTPSession');
    RegisterMethod('Function CreateSession( const RemoteIP, SessionID : String) : TIdHTTPSession');
    RegisterMethod('Function GetSession( const SessionID, RemoteIP : string) : TIdHTTPSession');
    RegisterMethod('Procedure Add( ASession : TIdHTTPSession)');
    RegisterProperty('SessionTimeout', 'Integer', iptrw);
    RegisterProperty('OnSessionEnd', 'TOnSessionEndEvent', iptrw);
    RegisterProperty('OnSessionStart', 'TOnSessionStartEvent', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TIdHTTPSession(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TObject', 'TIdHTTPSession') do
  with CL.AddClassN(CL.FindClass('TObject'),'TIdHTTPSession') do begin
    RegisterMethod('Constructor Create( AOwner : TIdHTTPCustomSessionList)');
   RegisterMethod('Procedure Free');
    RegisterMethod('Constructor CreateInitialized( AOwner : TIdHTTPCustomSessionList; const SessionID, RemoteIP : string)');
    RegisterMethod('Procedure Lock');
    RegisterMethod('Procedure Unlock');
    RegisterProperty('Content', 'TStrings', iptrw);
    RegisterProperty('LastTimeStamp', 'TDateTime', iptr);
    RegisterProperty('RemoteHost', 'string', iptr);
    RegisterProperty('SessionID', 'String', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TIdHTTPResponseInfo(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TIdResponseHeaderInfo', 'TIdHTTPResponseInfo') do
  with CL.AddClassN(CL.FindClass('TIdResponseHeaderInfo'),'TIdHTTPResponseInfo') do begin
    RegisterMethod('Procedure CloseSession');
    RegisterMethod('Constructor Create( AConnection : TIdTCPServerConnection)');
    RegisterMethod('Procedure Free');
    RegisterMethod('Procedure Redirect( const AURL : string)');
    RegisterMethod('Procedure WriteHeader');
    RegisterMethod('Procedure WriteContent');
    RegisterMethod('Function ServeFile( AThread : TIdPeerThread; aFile : TFileName) : cardinal');
    RegisterProperty('AuthRealm', 'string', iptrw);
    RegisterProperty('CloseConnection', 'Boolean', iptrw);
    RegisterProperty('ContentStream', 'TStream', iptrw);
    RegisterProperty('ContentText', 'string', iptrw);
    RegisterProperty('Cookies', 'TIdServerCookies', iptrw);
    RegisterProperty('FreeContentStream', 'Boolean', iptrw);
    RegisterProperty('HeaderHasBeenWritten', 'Boolean', iptrw);
    RegisterProperty('ResponseNo', 'Integer', iptrw);
    RegisterProperty('ResponseText', 'String', iptrw);
    RegisterProperty('ServerSoftware', 'string', iptrw);
    RegisterProperty('Session', 'TIdHTTPSession', iptr);

  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TIdHTTPRequestInfo(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TIdRequestHeaderInfo', 'TIdHTTPRequestInfo') do
  with CL.AddClassN(CL.FindClass('TIdRequestHeaderInfo'),'TIdHTTPRequestInfo') do begin
    RegisterMethod('Constructor Create');
   RegisterMethod('Procedure Free');
    RegisterProperty('Session', 'TIdHTTPSession', iptr);
    RegisterProperty('AuthExists', 'Boolean', iptr);
    RegisterProperty('AuthPassword', 'string', iptr);
    RegisterProperty('AuthUsername', 'string', iptr);
    RegisterProperty('Command', 'string', iptr);
    RegisterProperty('Cookies', 'TIdServerCookies', iptr);
    RegisterProperty('Document', 'string', iptrw);
    RegisterProperty('Params', 'TStrings', iptr);
    RegisterProperty('PostStream', 'TStream', iptrw);
    RegisterProperty('RawHTTPCommand', 'string', iptr);
    RegisterProperty('RemoteIP', 'String', iptr);
    RegisterProperty('UnparsedParams', 'string', iptrw);
    RegisterProperty('FormParams', 'string', iptrw);
    RegisterProperty('QueryParams', 'string', iptrw);
    RegisterProperty('Version', 'string', iptr);
    RegisterProperty('URI', 'string', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_IdCustomHTTPServer(CL: TPSPascalCompiler);
begin
 //CL.AddConstantN('Id_TId_HTTPServer_KeepAlive','Boolean')BoolToStr( false);
 //CL.AddConstantN('Id_TId_HTTPServer_ParseParams','Boolean')BoolToStr( false);
 //CL.AddConstantN('Id_TId_HTTPServer_SessionState','Boolean')BoolToStr( false);
 CL.AddConstantN('Id_TId_HTTPSessionTimeOut','LongInt').SetInt( 0);
 CL.AddConstantN('Id_TId_HTTPAutoStartSession','Boolean').SetInt( 0);
 CL.AddConstantN('GResponseNo','LongInt').SetInt( 200);
 CL.AddConstantN('GFContentLength','LongInt').SetInt( - 1);
 CL.AddConstantN('GContentType','String').SetString( 'text/html');
 CL.AddConstantN('GSessionIDCookie','String').SetString( 'IDHTTPSESSIONID');
  CL.AddClassN(CL.FindClass('TOBJECT'),'TIdHTTPSession');
  CL.AddClassN(CL.FindClass('TOBJECT'),'TIdHTTPCustomSessionList');
  CL.AddClassN(CL.FindClass('TOBJECT'),'TIdHTTPRequestInfo');
  CL.AddClassN(CL.FindClass('TOBJECT'),'TIdHTTPResponseInfo');
  CL.AddClassN(CL.FindClass('TOBJECT'),'TIdMimeTable');
    //CL.AddTypeS('TIdHTTPServer','IdCustomHTTPServer');
  CL.AddTypeS('TOnSessionEndEvent', 'Procedure ( Sender : TIdHTTPSession)');
  CL.AddTypeS('TOnSessionEndEvent', 'Procedure ( Sender : TIdHTTPSession)');
  CL.AddTypeS('TOnSessionStartEvent', 'Procedure ( Sender : TIdHTTPSession)');
  CL.AddTypeS('TOnCreateSession', 'Procedure ( ASender : TIdPeerThread; var VHT'
   +'TPSession : TIdHTTPSession)');
  CL.AddTypeS('TOnCreatePostStream', 'Procedure ( ASender : TIdPeerThread; var '
  +'VPostStream : TStream)');
  CL.AddTypeS('TIdHTTPGetEvent', 'Procedure ( AThread : TIdPeerThread; ARequest'
   +'Info : TIdHTTPRequestInfo; AResponseInfo : TIdHTTPResponseInfo)');
  CL.AddTypeS('TIdHTTPOtherEvent', 'Procedure ( Thread : TIdPeerThread; const a'
   +'sCommand, asData, asVersion : string)');
  CL.AddTypeS('TIdHTTPInvalidSessionEvent', 'Procedure ( Thread : TIdPeerThread'
   +'; ARequestInfo : TIdHTTPRequestInfo; AResponseInfo : TIdHTTPResponseInfo; '
   +'var VContinueProcessing : Boolean; const AInvalidSessionID : String)');
  CL.AddClassN(CL.FindClass('TOBJECT'),'EIdHTTPServerError');
  CL.AddClassN(CL.FindClass('TOBJECT'),'EIdHTTPHeaderAlreadyWritten');
  CL.AddClassN(CL.FindClass('TOBJECT'),'EIdHTTPErrorParsingCommand');
  CL.AddClassN(CL.FindClass('TOBJECT'),'EIdHTTPUnsupportedAuthorisationScheme');
  CL.AddClassN(CL.FindClass('TOBJECT'),'EIdHTTPCannotSwitchSessionStateWhenActive');
  SIRegister_TIdHTTPRequestInfo(CL);
  SIRegister_TIdHTTPResponseInfo(CL);
  SIRegister_TIdHTTPSession(CL);
  SIRegister_TIdHTTPCustomSessionList(CL);
  SIRegister_TIdCustomHTTPServer(CL);
  SIRegister_TIdHTTPDefaultSessionList(CL);
  SIRegister_TIdHTTPServer(CL);

 CL.AddDelphiFunction('Function TimeStampInterval( StartStamp, EndStamp : TDateTime) : integer');
 CL.AddDelphiFunction('Function GetRandomString( NumChar : cardinal) : string');
 CL.AddDelphiFunction('function CreateIDStack: TIdStack;');
 CL.AddDelphiFunction('function MPing(const AHost: string;const ATimes:integer; out AvgMS:Double):Boolean;');

end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TIdCustomHTTPServerOnCommandOther_W(Self: TIdCustomHTTPServer; const T: TIdHTTPOtherEvent);
begin Self.OnCommandOther := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdCustomHTTPServerOnCommandOther_R(Self: TIdCustomHTTPServer; var T: TIdHTTPOtherEvent);
begin T := Self.OnCommandOther; end;


procedure TIdCustomHTTPServerOnCommandGet_W(Self: TIdCustomHTTPServer; const T: TIdHTTPGetEvent);
begin Self.OnCommandGet1:= T; end;

(*----------------------------------------------------------------------------*)
procedure TIdCustomHTTPServerOnCommandGet_R(Self: TIdCustomHTTPServer; var T: TIdHTTPGetEvent);
begin T := Self.OnCommandGet1; end;


procedure TIdCustomHTTPServerOnCreatePostStream_W(Self: TIdCustomHTTPServer; const T: TOnCreatePostStream);
begin Self.onCreatePostStream1:= T; end;

(*----------------------------------------------------------------------------*)
procedure TIdCustomHTTPServerOnCreatePostStream_R(Self: TIdCustomHTTPServer; var T: TOnCreatePostStream);
begin T := Self.onCreatePostStream1; end;

(*----------------------------------------------------------------------------*)
procedure TIdCustomHTTPServerSessionTimeOut_W(Self: TIdCustomHTTPServer; const T: Integer);
begin Self.SessionTimeOut := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdCustomHTTPServerSessionTimeOut_R(Self: TIdCustomHTTPServer; var T: Integer);
begin T := Self.SessionTimeOut; end;

(*----------------------------------------------------------------------------*)
procedure TIdCustomHTTPServerSessionState_W(Self: TIdCustomHTTPServer; const T: Boolean);
begin Self.SessionState := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdCustomHTTPServerSessionState_R(Self: TIdCustomHTTPServer; var T: Boolean);
begin T := Self.SessionState; end;

(*----------------------------------------------------------------------------*)
procedure TIdCustomHTTPServerServerSoftware_W(Self: TIdCustomHTTPServer; const T: string);
begin Self.ServerSoftware := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdCustomHTTPServerServerSoftware_R(Self: TIdCustomHTTPServer; var T: string);
begin T := Self.ServerSoftware; end;

(*----------------------------------------------------------------------------*)
procedure TIdCustomHTTPServerParseParams_W(Self: TIdCustomHTTPServer; const T: boolean);
begin Self.ParseParams := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdCustomHTTPServerParseParams_R(Self: TIdCustomHTTPServer; var T: boolean);
begin T := Self.ParseParams; end;

(*----------------------------------------------------------------------------*)
procedure TIdCustomHTTPServerKeepAlive_W(Self: TIdCustomHTTPServer; const T: Boolean);
begin Self.KeepAlive := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdCustomHTTPServerKeepAlive_R(Self: TIdCustomHTTPServer; var T: Boolean);
begin T := Self.KeepAlive; end;

(*----------------------------------------------------------------------------*)
procedure TIdCustomHTTPServerOnCreateSession_W(Self: TIdCustomHTTPServer; const T: TOnCreateSession);
begin Self.OnCreateSession := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdCustomHTTPServerOnCreateSession_R(Self: TIdCustomHTTPServer; var T: TOnCreateSession);
begin T := Self.OnCreateSession; end;

(*----------------------------------------------------------------------------*)
procedure TIdCustomHTTPServerOnSessionEnd_W(Self: TIdCustomHTTPServer; const T: TOnSessionEndEvent);
begin Self.OnSessionEnd := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdCustomHTTPServerOnSessionEnd_R(Self: TIdCustomHTTPServer; var T: TOnSessionEndEvent);
begin T := Self.OnSessionEnd; end;

(*----------------------------------------------------------------------------*)
procedure TIdCustomHTTPServerOnSessionStart_W(Self: TIdCustomHTTPServer; const T: TOnSessionStartEvent);
begin Self.OnSessionStart := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdCustomHTTPServerOnSessionStart_R(Self: TIdCustomHTTPServer; var T: TOnSessionStartEvent);
begin T := Self.OnSessionStart; end;

(*----------------------------------------------------------------------------*)
procedure TIdCustomHTTPServerOnInvalidSession_W(Self: TIdCustomHTTPServer; const T: TIdHTTPInvalidSessionEvent);
begin Self.OnInvalidSession := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdCustomHTTPServerOnInvalidSession_R(Self: TIdCustomHTTPServer; var T: TIdHTTPInvalidSessionEvent);
begin T := Self.OnInvalidSession; end;

(*----------------------------------------------------------------------------*)
procedure TIdCustomHTTPServerAutoStartSession_W(Self: TIdCustomHTTPServer; const T: boolean);
begin Self.AutoStartSession := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdCustomHTTPServerAutoStartSession_R(Self: TIdCustomHTTPServer; var T: boolean);
begin T := Self.AutoStartSession; end;

(*----------------------------------------------------------------------------*)
procedure TIdCustomHTTPServerSessionList_R(Self: TIdCustomHTTPServer; var T: TIdHTTPCustomSessionList);
begin T := Self.SessionList; end;

(*----------------------------------------------------------------------------*)
procedure TIdCustomHTTPServerMIMETable_R(Self: TIdCustomHTTPServer; var T: TIdMimeTable);
begin T := Self.MIMETable; end;

(*----------------------------------------------------------------------------*)
procedure TIdHTTPCustomSessionListOnSessionStart_W(Self: TIdHTTPCustomSessionList; const T: TOnSessionStartEvent);
begin Self.OnSessionStart := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdHTTPCustomSessionListOnSessionStart_R(Self: TIdHTTPCustomSessionList; var T: TOnSessionStartEvent);
begin T := Self.OnSessionStart; end;

(*----------------------------------------------------------------------------*)
procedure TIdHTTPCustomSessionListOnSessionEnd_W(Self: TIdHTTPCustomSessionList; const T: TOnSessionEndEvent);
begin Self.OnSessionEnd := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdHTTPCustomSessionListOnSessionEnd_R(Self: TIdHTTPCustomSessionList; var T: TOnSessionEndEvent);
begin T := Self.OnSessionEnd; end;

(*----------------------------------------------------------------------------*)
procedure TIdHTTPCustomSessionListSessionTimeout_W(Self: TIdHTTPCustomSessionList; const T: Integer);
begin Self.SessionTimeout := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdHTTPCustomSessionListSessionTimeout_R(Self: TIdHTTPCustomSessionList; var T: Integer);
begin T := Self.SessionTimeout; end;

(*----------------------------------------------------------------------------*)
procedure TIdHTTPSessionSessionID_R(Self: TIdHTTPSession; var T: String);
begin T := Self.SessionID; end;

(*----------------------------------------------------------------------------*)
procedure TIdHTTPSessionRemoteHost_R(Self: TIdHTTPSession; var T: string);
begin T := Self.RemoteHost; end;

(*----------------------------------------------------------------------------*)
procedure TIdHTTPSessionLastTimeStamp_R(Self: TIdHTTPSession; var T: TDateTime);
begin T := Self.LastTimeStamp; end;

(*----------------------------------------------------------------------------*)
procedure TIdHTTPSessionContent_W(Self: TIdHTTPSession; const T: TStrings);
begin Self.Content := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdHTTPSessionContent_R(Self: TIdHTTPSession; var T: TStrings);
begin T := Self.Content; end;

(*----------------------------------------------------------------------------*)
procedure TIdHTTPResponseInfoSession_R(Self: TIdHTTPResponseInfo; var T: TIdHTTPSession);
begin T := Self.Session; end;

(*----------------------------------------------------------------------------*)
procedure TIdHTTPResponseInfoServerSoftware_W(Self: TIdHTTPResponseInfo; const T: string);
begin Self.ServerSoftware := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdHTTPResponseInfoServerSoftware_R(Self: TIdHTTPResponseInfo; var T: string);
begin T := Self.ServerSoftware; end;

(*----------------------------------------------------------------------------*)
procedure TIdHTTPResponseInfoResponseText_W(Self: TIdHTTPResponseInfo; const T: String);
begin Self.ResponseText := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdHTTPResponseInfoResponseText_R(Self: TIdHTTPResponseInfo; var T: String);
begin T := Self.ResponseText; end;

(*----------------------------------------------------------------------------*)
procedure TIdHTTPResponseInfoResponseNo_W(Self: TIdHTTPResponseInfo; const T: Integer);
begin Self.ResponseNo := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdHTTPResponseInfoResponseNo_R(Self: TIdHTTPResponseInfo; var T: Integer);
begin T := Self.ResponseNo; end;

(*----------------------------------------------------------------------------*)
procedure TIdHTTPResponseInfoHeaderHasBeenWritten_W(Self: TIdHTTPResponseInfo; const T: Boolean);
begin Self.HeaderHasBeenWritten := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdHTTPResponseInfoHeaderHasBeenWritten_R(Self: TIdHTTPResponseInfo; var T: Boolean);
begin T := Self.HeaderHasBeenWritten; end;

(*----------------------------------------------------------------------------*)
procedure TIdHTTPResponseInfoFreeContentStream_W(Self: TIdHTTPResponseInfo; const T: Boolean);
begin Self.FreeContentStream := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdHTTPResponseInfoFreeContentStream_R(Self: TIdHTTPResponseInfo; var T: Boolean);
begin T := Self.FreeContentStream; end;

(*----------------------------------------------------------------------------*)
procedure TIdHTTPResponseInfoCookies_W(Self: TIdHTTPResponseInfo; const T: TIdServerCookies);
begin Self.Cookies := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdHTTPResponseInfoCookies_R(Self: TIdHTTPResponseInfo; var T: TIdServerCookies);
begin T := Self.Cookies; end;

(*----------------------------------------------------------------------------*)
procedure TIdHTTPResponseInfoContentText_W(Self: TIdHTTPResponseInfo; const T: string);
begin Self.ContentText := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdHTTPResponseInfoContentText_R(Self: TIdHTTPResponseInfo; var T: string);
begin T := Self.ContentText; end;

(*----------------------------------------------------------------------------*)
procedure TIdHTTPResponseInfoContentStream_W(Self: TIdHTTPResponseInfo; const T: TStream);
begin Self.ContentStream := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdHTTPResponseInfoContentStream_R(Self: TIdHTTPResponseInfo; var T: TStream);
begin T := Self.ContentStream; end;

(*----------------------------------------------------------------------------*)
procedure TIdHTTPResponseInfoCloseConnection_W(Self: TIdHTTPResponseInfo; const T: Boolean);
begin Self.CloseConnection := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdHTTPResponseInfoCloseConnection_R(Self: TIdHTTPResponseInfo; var T: Boolean);
begin T := Self.CloseConnection; end;

(*----------------------------------------------------------------------------*)
procedure TIdHTTPResponseInfoAuthRealm_W(Self: TIdHTTPResponseInfo; const T: string);
begin Self.AuthRealm := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdHTTPResponseInfoAuthRealm_R(Self: TIdHTTPResponseInfo; var T: string);
begin T := Self.AuthRealm; end;

(*----------------------------------------------------------------------------*)
procedure TIdHTTPRequestInfoVersion_R(Self: TIdHTTPRequestInfo; var T: string);
begin T := Self.Version; end;

(*----------------------------------------------------------------------------*)
procedure TIdHTTPRequestInfoQueryParams_W(Self: TIdHTTPRequestInfo; const T: string);
begin Self.QueryParams := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdHTTPRequestInfoQueryParams_R(Self: TIdHTTPRequestInfo; var T: string);
begin T := Self.QueryParams; end;

(*----------------------------------------------------------------------------*)
procedure TIdHTTPRequestInfoFormParams_W(Self: TIdHTTPRequestInfo; const T: string);
begin Self.FormParams := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdHTTPRequestInfoFormParams_R(Self: TIdHTTPRequestInfo; var T: string);
begin T := Self.FormParams; end;

(*----------------------------------------------------------------------------*)
procedure TIdHTTPRequestInfoUnparsedParams_W(Self: TIdHTTPRequestInfo; const T: string);
begin Self.UnparsedParams := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdHTTPRequestInfoUnparsedParams_R(Self: TIdHTTPRequestInfo; var T: string);
begin T := Self.UnparsedParams; end;

(*----------------------------------------------------------------------------*)
procedure TIdHTTPRequestInfoRemoteIP_R(Self: TIdHTTPRequestInfo; var T: String);
begin T := Self.RemoteIP; end;

procedure TIdHTTPRequestInfoURI_R(Self: TIdHTTPRequestInfo; var T: String);
begin T := Self.Username; end;


(*----------------------------------------------------------------------------*)
procedure TIdHTTPRequestInfoRawHTTPCommand_R(Self: TIdHTTPRequestInfo; var T: string);
begin T := Self.RawHTTPCommand; end;

(*----------------------------------------------------------------------------*)
procedure TIdHTTPRequestInfoPostStream_W(Self: TIdHTTPRequestInfo; const T: TStream);
begin Self.PostStream := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdHTTPRequestInfoPostStream_R(Self: TIdHTTPRequestInfo; var T: TStream);
begin T := Self.PostStream; end;

(*----------------------------------------------------------------------------*)
procedure TIdHTTPRequestInfoParams_R(Self: TIdHTTPRequestInfo; var T: TStrings);
begin T := Self.Params; end;

(*----------------------------------------------------------------------------*)
procedure TIdHTTPRequestInfoDocument_W(Self: TIdHTTPRequestInfo; const T: string);
begin Self.Document := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdHTTPRequestInfoDocument_R(Self: TIdHTTPRequestInfo; var T: string);
begin T := Self.Document; end;

(*----------------------------------------------------------------------------*)
procedure TIdHTTPRequestInfoCookies_R(Self: TIdHTTPRequestInfo; var T: TIdServerCookies);
begin T := Self.Cookies; end;

(*----------------------------------------------------------------------------*)
procedure TIdHTTPRequestInfoCommand_R(Self: TIdHTTPRequestInfo; var T: string);
begin T := Self.Command; end;

(*----------------------------------------------------------------------------*)
procedure TIdHTTPRequestInfoAuthUsername_R(Self: TIdHTTPRequestInfo; var T: string);
begin T := Self.AuthUsername; end;

(*----------------------------------------------------------------------------*)
procedure TIdHTTPRequestInfoAuthPassword_R(Self: TIdHTTPRequestInfo; var T: string);
begin T := Self.AuthPassword; end;

(*----------------------------------------------------------------------------*)
procedure TIdHTTPRequestInfoAuthExists_R(Self: TIdHTTPRequestInfo; var T: Boolean);
begin T := Self.AuthExists; end;

(*----------------------------------------------------------------------------*)
procedure TIdHTTPRequestInfoSession_R(Self: TIdHTTPRequestInfo; var T: TIdHTTPSession);
begin T := Self.Session; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_IdCustomHTTPServer_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@TimeStampInterval, 'TimeStampInterval', cdRegister);
 S.RegisterDelphiFunction(@GetRandomString, 'GetRandomString', cdRegister);
 S.RegisterDelphiFunction(@CreateIDStack, 'CreateIDStack', cdRegister);
 S.RegisterDelphiFunction(@MPing, 'MPing', cdRegister);
 end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TIdHTTPDefaultSessionList(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TIdHTTPDefaultSessionList) do begin
    RegisterConstructor(@TIdHTTPDefaultSessionList.Create, 'Create');
    RegisterMethod(@TIdHTTPDefaultSessionList.Destroy, 'Free');
    RegisterMethod(@TIdHTTPDefaultSessionList.Clear, 'Clear');
    RegisterMethod(@TIdHTTPDefaultSessionList.PurgeStaleSessions, 'PurgeStaleSessions');
    RegisterMethod(@TIdHTTPDefaultSessionList.CreateUniqueSession, 'CreateUniqueSession');
    RegisterMethod(@TIdHTTPDefaultSessionList.CreateSession, 'CreateSession');
    RegisterMethod(@TIdHTTPDefaultSessionList.GetSession, 'GetSession');
    RegisterMethod(@TIdHTTPDefaultSessionList.Add, 'Add');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TIdCustomHTTPServer(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TIdCustomHTTPServer) do begin
    RegisterConstructor(@TIdCustomHTTPServer.Create, 'Create');
   RegisterMethod(@TIdCustomHTTPServer.Destroy, 'Free');
    RegisterMethod(@TIdCustomHTTPServer.CreateSession, 'CreateSession');
    RegisterMethod(@TIdCustomHTTPServer.EndSession, 'EndSession');
    RegisterVirtualMethod(@TIdCustomHTTPServer.ServeFile, 'ServeFile');
    RegisterPropertyHelper(@TIdCustomHTTPServerMIMETable_R,nil,'MIMETable');
    RegisterPropertyHelper(@TIdCustomHTTPServerSessionList_R,nil,'SessionList');
    RegisterPropertyHelper(@TIdCustomHTTPServerAutoStartSession_R,@TIdCustomHTTPServerAutoStartSession_W,'AutoStartSession');
    RegisterPropertyHelper(@TIdCustomHTTPServerOnInvalidSession_R,@TIdCustomHTTPServerOnInvalidSession_W,'OnInvalidSession');
    RegisterPropertyHelper(@TIdCustomHTTPServerOnSessionStart_R,@TIdCustomHTTPServerOnSessionStart_W,'OnSessionStart');
    RegisterPropertyHelper(@TIdCustomHTTPServerOnSessionEnd_R,@TIdCustomHTTPServerOnSessionEnd_W,'OnSessionEnd');
    RegisterPropertyHelper(@TIdCustomHTTPServerOnCreateSession_R,@TIdCustomHTTPServerOnCreateSession_W,'OnCreateSession');
    RegisterPropertyHelper(@TIdCustomHTTPServerKeepAlive_R,@TIdCustomHTTPServerKeepAlive_W,'KeepAlive');
    RegisterPropertyHelper(@TIdCustomHTTPServerParseParams_R,@TIdCustomHTTPServerParseParams_W,'ParseParams');
    RegisterPropertyHelper(@TIdCustomHTTPServerServerSoftware_R,@TIdCustomHTTPServerServerSoftware_W,'ServerSoftware');
    RegisterPropertyHelper(@TIdCustomHTTPServerSessionState_R,@TIdCustomHTTPServerSessionState_W,'SessionState');
    RegisterPropertyHelper(@TIdCustomHTTPServerSessionTimeOut_R,@TIdCustomHTTPServerSessionTimeOut_W,'SessionTimeOut');
    RegisterPropertyHelper(@TIdCustomHTTPServerOnCommandOther_R,@TIdCustomHTTPServerOnCommandOther_W,'OnCommandOther');
    RegisterPropertyHelper(@TIdCustomHTTPServerOnCommandGet_R,@TIdCustomHTTPServerOnCommandGet_W,'OnCommandGet');
    RegisterPropertyHelper(@TIdCustomHTTPServerOnCreatePostStream_R,@TIdCustomHTTPServerOnCreatePostStream_W,'OnCreatePostStream');
    //    property OnCreatePostStream1: TOnCreatePostStream read FOnCreatePostStream
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TIdHTTPCustomSessionList(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TIdHTTPCustomSessionList) do begin
    //RegisterVirtualAbstractMethod(@TIdHTTPCustomSessionList, @!.Clear, 'Clear');
    //RegisterVirtualAbstractMethod(@TIdHTTPCustomSessionList, @!.PurgeStaleSessions, 'PurgeStaleSessions');
    //RegisterVirtualAbstractMethod(@TIdHTTPCustomSessionList, @!.CreateUniqueSession, 'CreateUniqueSession');
    //RegisterVirtualAbstractMethod(@TIdHTTPCustomSessionList, @!.CreateSession, 'CreateSession');
    //RegisterVirtualAbstractMethod(@TIdHTTPCustomSessionList, @!.GetSession, 'GetSession');
    //RegisterVirtualAbstractMethod(@TIdHTTPCustomSessionList, @!.Add, 'Add');
    RegisterPropertyHelper(@TIdHTTPCustomSessionListSessionTimeout_R,@TIdHTTPCustomSessionListSessionTimeout_W,'SessionTimeout');
    RegisterPropertyHelper(@TIdHTTPCustomSessionListOnSessionEnd_R,@TIdHTTPCustomSessionListOnSessionEnd_W,'OnSessionEnd');
    RegisterPropertyHelper(@TIdHTTPCustomSessionListOnSessionStart_R,@TIdHTTPCustomSessionListOnSessionStart_W,'OnSessionStart');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TIdHTTPSession(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TIdHTTPSession) do begin
    RegisterVirtualConstructor(@TIdHTTPSession.Create, 'Create');
   RegisterMethod(@TIdHTTPSession.Destroy, 'Free');
    RegisterVirtualConstructor(@TIdHTTPSession.CreateInitialized, 'CreateInitialized');
    RegisterMethod(@TIdHTTPSession.Lock, 'Lock');
    RegisterMethod(@TIdHTTPSession.Unlock, 'Unlock');
    RegisterPropertyHelper(@TIdHTTPSessionContent_R,@TIdHTTPSessionContent_W,'Content');
    RegisterPropertyHelper(@TIdHTTPSessionLastTimeStamp_R,nil,'LastTimeStamp');
    RegisterPropertyHelper(@TIdHTTPSessionRemoteHost_R,nil,'RemoteHost');
    RegisterPropertyHelper(@TIdHTTPSessionSessionID_R,nil,'SessionID');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TIdHTTPResponseInfo(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TIdHTTPResponseInfo) do begin
    RegisterMethod(@TIdHTTPResponseInfo.CloseSession, 'CloseSession');
    RegisterConstructor(@TIdHTTPResponseInfo.Create, 'Create');
   RegisterMethod(@TIdHTTPResponseInfo.Destroy, 'Free');
    RegisterMethod(@TIdHTTPResponseInfo.Redirect, 'Redirect');
    RegisterMethod(@TIdHTTPResponseInfo.WriteHeader, 'WriteHeader');
    RegisterMethod(@TIdHTTPResponseInfo.WriteContent, 'WriteContent');
    //RegisterMethod(@TIdHTTPResponseInfo.ServeFile, 'ServeFile');
    RegisterPropertyHelper(@TIdHTTPResponseInfoAuthRealm_R,@TIdHTTPResponseInfoAuthRealm_W,'AuthRealm');
    RegisterPropertyHelper(@TIdHTTPResponseInfoCloseConnection_R,@TIdHTTPResponseInfoCloseConnection_W,'CloseConnection');
    RegisterPropertyHelper(@TIdHTTPResponseInfoContentStream_R,@TIdHTTPResponseInfoContentStream_W,'ContentStream');
    RegisterPropertyHelper(@TIdHTTPResponseInfoContentText_R,@TIdHTTPResponseInfoContentText_W,'ContentText');
    RegisterPropertyHelper(@TIdHTTPResponseInfoCookies_R,@TIdHTTPResponseInfoCookies_W,'Cookies');
    RegisterPropertyHelper(@TIdHTTPResponseInfoFreeContentStream_R,@TIdHTTPResponseInfoFreeContentStream_W,'FreeContentStream');
    RegisterPropertyHelper(@TIdHTTPResponseInfoHeaderHasBeenWritten_R,@TIdHTTPResponseInfoHeaderHasBeenWritten_W,'HeaderHasBeenWritten');
    RegisterPropertyHelper(@TIdHTTPResponseInfoResponseNo_R,@TIdHTTPResponseInfoResponseNo_W,'ResponseNo');
    RegisterPropertyHelper(@TIdHTTPResponseInfoResponseText_R,@TIdHTTPResponseInfoResponseText_W,'ResponseText');
    RegisterPropertyHelper(@TIdHTTPResponseInfoServerSoftware_R,@TIdHTTPResponseInfoServerSoftware_W,'ServerSoftware');
    RegisterPropertyHelper(@TIdHTTPResponseInfoSession_R,nil,'Session');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TIdHTTPRequestInfo(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TIdHTTPRequestInfo) do begin
    RegisterConstructor(@TIdHTTPRequestInfo.Create, 'Create');
   RegisterMethod(@TIdHTTPRequestInfo.Destroy, 'Free');
    RegisterPropertyHelper(@TIdHTTPRequestInfoSession_R,nil,'Session');
    RegisterPropertyHelper(@TIdHTTPRequestInfoAuthExists_R,nil,'AuthExists');
    RegisterPropertyHelper(@TIdHTTPRequestInfoAuthPassword_R,nil,'AuthPassword');
    RegisterPropertyHelper(@TIdHTTPRequestInfoAuthUsername_R,nil,'AuthUsername');
    RegisterPropertyHelper(@TIdHTTPRequestInfoCommand_R,nil,'Command');
    RegisterPropertyHelper(@TIdHTTPRequestInfoCookies_R,nil,'Cookies');
    RegisterPropertyHelper(@TIdHTTPRequestInfoDocument_R,@TIdHTTPRequestInfoDocument_W,'Document');
    RegisterPropertyHelper(@TIdHTTPRequestInfoParams_R,nil,'Params');
    RegisterPropertyHelper(@TIdHTTPRequestInfoURI_R,nil,'URI');

    RegisterPropertyHelper(@TIdHTTPRequestInfoPostStream_R,@TIdHTTPRequestInfoPostStream_W,'PostStream');
    RegisterPropertyHelper(@TIdHTTPRequestInfoRawHTTPCommand_R,nil,'RawHTTPCommand');
    RegisterPropertyHelper(@TIdHTTPRequestInfoRemoteIP_R,nil,'RemoteIP');
    RegisterPropertyHelper(@TIdHTTPRequestInfoUnparsedParams_R,@TIdHTTPRequestInfoUnparsedParams_W,'UnparsedParams');
    RegisterPropertyHelper(@TIdHTTPRequestInfoFormParams_R,@TIdHTTPRequestInfoFormParams_W,'FormParams');
    RegisterPropertyHelper(@TIdHTTPRequestInfoQueryParams_R,@TIdHTTPRequestInfoQueryParams_W,'QueryParams');
    RegisterPropertyHelper(@TIdHTTPRequestInfoVersion_R,nil,'Version');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_IdCustomHTTPServer(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TIdHTTPSession) do
  with CL.Add(TIdHTTPCustomSessionList) do
  with CL.Add(TIdHTTPRequestInfo) do
  with CL.Add(TIdHTTPResponseInfo) do
  with CL.Add(EIdHTTPServerError) do
  with CL.Add(EIdHTTPHeaderAlreadyWritten) do
  with CL.Add(EIdHTTPErrorParsingCommand) do
  with CL.Add(EIdHTTPUnsupportedAuthorisationScheme) do
  with CL.Add(EIdHTTPCannotSwitchSessionStateWhenActive) do
  RIRegister_TIdHTTPRequestInfo(CL);
  RIRegister_TIdHTTPResponseInfo(CL);
  RIRegister_TIdHTTPSession(CL);
  RIRegister_TIdHTTPCustomSessionList(CL);
  RIRegister_TIdCustomHTTPServer(CL);
  RIRegister_TIdHTTPDefaultSessionList(CL);
  RIRegister_TIdHTTPServer(CL);
end;

 
 
{ TPSImport_IdCustomHTTPServer }
(*----------------------------------------------------------------------------*)
procedure TPSImport_IdCustomHTTPServer.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_IdCustomHTTPServer(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_IdCustomHTTPServer.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_IdCustomHTTPServer(ri);
  RIRegister_IdCustomHTTPServer_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
