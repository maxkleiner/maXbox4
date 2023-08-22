unit uPSI_ALWininetHttpClient;
{
    wininet net get set    add free
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
  TPSImport_ALWininetHttpClient = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TALWinInetHTTPClient(CL: TPSPascalCompiler);
procedure SIRegister_ALWininetHttpClient(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TALWinInetHTTPClient(CL: TPSRuntimeClassImporter);
procedure RIRegister_ALWininetHttpClient(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   Windows
  ,ALHttpCommon
  ,ALHttpClient
  ,WinInet
  ,ALWininetHttpClient
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_ALWininetHttpClient]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TALWinInetHTTPClient(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TALHTTPClient', 'TALWinInetHTTPClient') do
  with CL.AddClassN(CL.FindClass('TALHTTPClient'),'TALWinInetHTTPClient') do begin
    RegisterMethod('Constructor Create');
    RegisterMethod('Procedure Connect');
    RegisterMethod('Procedure Free;');
    RegisterMethod('Procedure Disconnect');
    RegisterMethod('Function Send( aRequestDataStream : TStream) : Integer');
    RegisterMethod('Procedure Receive( aContext : Dword; aResponseContentStream : TStream; aResponseContentHeader : TALHTTPResponseHeader)');
    RegisterProperty('AccessType', 'TALWinInetHttpInternetOpenAccessType', iptrw);
    RegisterProperty('InternetOptions', 'TAlWininetHTTPClientInternetOptionSet', iptrw);
    RegisterProperty('DisconnectOnError', 'Boolean', iptrw);
    RegisterProperty('OnStatusChange', 'TAlWinInetHTTPClientStatusChangeEvent', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_ALWininetHttpClient(CL: TPSPascalCompiler);
begin
  CL.AddTypeS('DWORD_PTR', 'DWORD');
 CL.AddConstantN('INTERNET_STATUS_COOKIE_SENT','LongInt').SetInt( 320);
 CL.AddConstantN('INTERNET_STATUS_COOKIE_RECEIVED','LongInt').SetInt( 321);
 CL.AddConstantN('INTERNET_STATUS_PRIVACY_IMPACTED','LongInt').SetInt( 324);
 CL.AddConstantN('INTERNET_STATUS_P3P_HEADER','LongInt').SetInt( 325);
 CL.AddConstantN('INTERNET_STATUS_P3P_POLICYREF','LongInt').SetInt( 326);
 CL.AddConstantN('INTERNET_STATUS_COOKIE_HISTORY','LongInt').SetInt( 327);
  {CL.AddTypeS('_URL_COMPONENTSA', 'record dwStructSize : DWORD; lpszScheme : LP'
   +'STR; dwSchemeLength : DWORD; nScheme : TInternetScheme; lpszHostName : LPS'
   +'TR; dwHostNameLength : DWORD; nPort : INTERNET_PORT; lpszUserName : LPSTR;'
   +' dwUserNameLength : DWORD; lpszPassword : LPSTR; dwPasswordLength : DWORD;'
   +' lpszUrlPath : LPSTR; dwUrlPathLength : DWORD; lpszExtraInfo : LPSTR; dwEx'
   +'traInfoLength : DWORD; end'); }
  //CL.AddTypeS('_TURLComponentsA', '_URL_COMPONENTSA');
 // CL.AddTypeS('_PInternetBuffersA', '^_INTERNET_BUFFERSA // will not work');
  {CL.AddTypeS('_INTERNET_BUFFERSA', 'record dwStructSize : DWORD; Next : _PInte'
   +'rnetBuffersA; lpcszHeader : PAnsiChar; dwHeadersLength : DWORD; dwHeadersT'
   +'otal : DWORD; lpvBuffer : Pointer; dwBufferLength : DWORD; dwBufferTotal :'
   +' DWORD; dwOffsetLow : DWORD; dwOffsetHigh : DWORD; end');}
  //CL.AddTypeS('_LP_INTERNET_BUFFERSA', '_PInternetBuffersA');
  CL.AddTypeS('TALWinInetHttpInternetOpenAccessType', '( wHttpAt_Direct, wHttpA'
   +'t_Preconfig, wHttpAt_Preconfig_with_no_autoproxy, wHttpAt_Proxy )');
  CL.AddTypeS('TAlWininetHttpClientInternetOption', '( wHttpIo_Async, wHttpIo_F'
   +'rom_Cache, wHttpIo_Offline, wHttpIo_Cache_if_net_fail, wHttpIo_Hyperlink, '
   +'wHttpIo_Ignore_cert_cn_invalid, wHttpIo_Ignore_cert_date_invalid, wHttpIo_'
   +'Ignore_redirect_to_http, wHttpIo_Ignore_redirect_to_https, wHttpIo_Keep_co'
   +'nnection, wHttpIo_Need_file, wHttpIo_No_auth, wHttpIo_No_auto_redirect, wH'
   +'ttpIo_No_cache_write, wHttpIo_No_cookies, wHttpIo_No_ui, wHttpIo_Pragma_no'
   +'cache, wHttpIo_Reload, wHttpIo_Resynchronize, wHttpIo_Secure )');
  CL.AddTypeS('TALWininetHttpClientInternetOptionSet', 'set of TAlWininetHttpClientInternetOption');
  //CL.AddTypeS('TAlWinInetHTTPClientStatusChangeEvent', 'Procedure ( sender : To'
   //+'bject; InternetStatus : DWord; StatusInformation : ___Pointer; StatusInformat'
   //+'ionLength : DWord)');
  SIRegister_TALWinInetHTTPClient(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TALWinInetHTTPClientOnStatusChange_W(Self: TALWinInetHTTPClient; const T: TAlWinInetHTTPClientStatusChangeEvent);
begin Self.OnStatusChange := T; end;

(*----------------------------------------------------------------------------*)
procedure TALWinInetHTTPClientOnStatusChange_R(Self: TALWinInetHTTPClient; var T: TAlWinInetHTTPClientStatusChangeEvent);
begin T := Self.OnStatusChange; end;

(*----------------------------------------------------------------------------*)
procedure TALWinInetHTTPClientDisconnectOnError_W(Self: TALWinInetHTTPClient; const T: Boolean);
begin Self.DisconnectOnError := T; end;

(*----------------------------------------------------------------------------*)
procedure TALWinInetHTTPClientDisconnectOnError_R(Self: TALWinInetHTTPClient; var T: Boolean);
begin T := Self.DisconnectOnError; end;

(*----------------------------------------------------------------------------*)
procedure TALWinInetHTTPClientInternetOptions_W(Self: TALWinInetHTTPClient; const T: TAlWininetHTTPClientInternetOptionSet);
begin Self.InternetOptions := T; end;

(*----------------------------------------------------------------------------*)
procedure TALWinInetHTTPClientInternetOptions_R(Self: TALWinInetHTTPClient; var T: TAlWininetHTTPClientInternetOptionSet);
begin T := Self.InternetOptions; end;

(*----------------------------------------------------------------------------*)
procedure TALWinInetHTTPClientAccessType_W(Self: TALWinInetHTTPClient; const T: TALWinInetHttpInternetOpenAccessType);
begin Self.AccessType := T; end;

(*----------------------------------------------------------------------------*)
procedure TALWinInetHTTPClientAccessType_R(Self: TALWinInetHTTPClient; var T: TALWinInetHttpInternetOpenAccessType);
begin T := Self.AccessType; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TALWinInetHTTPClient(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TALWinInetHTTPClient) do begin
    RegisterConstructor(@TALWinInetHTTPClient.Create, 'Create');
    RegisterMethod(@TALWinInetHTTPClient.Connect, 'Connect');
    RegisterMethod(@TALWinInetHTTPClient.Disconnect, 'Disconnect');
       RegisterMethod(@TALWinInetHTTPClient.Free, 'Free');
     RegisterVirtualMethod(@TALWinInetHTTPClient.Send, 'Send');
    RegisterVirtualMethod(@TALWinInetHTTPClient.Receive, 'Receive');
    RegisterPropertyHelper(@TALWinInetHTTPClientAccessType_R,@TALWinInetHTTPClientAccessType_W,'AccessType');
    RegisterPropertyHelper(@TALWinInetHTTPClientInternetOptions_R,@TALWinInetHTTPClientInternetOptions_W,'InternetOptions');
    RegisterPropertyHelper(@TALWinInetHTTPClientDisconnectOnError_R,@TALWinInetHTTPClientDisconnectOnError_W,'DisconnectOnError');
    RegisterPropertyHelper(@TALWinInetHTTPClientOnStatusChange_R,@TALWinInetHTTPClientOnStatusChange_W,'OnStatusChange');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_ALWininetHttpClient(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TALWinInetHTTPClient(CL);
end;

 
 
{ TPSImport_ALWininetHttpClient }
(*----------------------------------------------------------------------------*)
procedure TPSImport_ALWininetHttpClient.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_ALWininetHttpClient(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_ALWininetHttpClient.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_ALWininetHttpClient(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
