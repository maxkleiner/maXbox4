unit uPSI_ALWininetHttpClient2;
{
for the Opwn Open API

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
  TPSImport_ALWininetHttpClient2 = class(TPSPlugin)
  public
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TALWinInetHTTPClient2(CL: TPSPascalCompiler);
procedure SIRegister_ALWininetHttpClient2(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TALWinInetHTTPClient2(CL: TPSRuntimeClassImporter);
procedure RIRegister_ALWininetHttpClient2(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   Windows
  ,WinInet
  ,ALHttpClient2
  ,ALWininetHttpClient2
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_ALWininetHttpClient2]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TALWinInetHTTPClient2(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TALHTTPClient2', 'TALWinInetHTTPClient2') do
  with CL.AddClassN(CL.FindClass('TALHTTPClient2'),'TALWinInetHTTPClient2') do begin
    RegisterMethod('Constructor Create');
     RegisterMethod('Procedure Free');
    RegisterMethod('Procedure Connect');
    RegisterMethod('Procedure Disconnect');
    RegisterProperty('AccessType', 'TALWinInetHttpInternetOpenAccessType2', iptrw);
    RegisterProperty('InternetOptions', 'TAlWininetHTTPClientInternetOptionSet2', iptrw);
    RegisterProperty('OnStatus', 'TAlWinInetHTTPClientStatusEvent', iptrw);
    RegisterProperty('IgnoreSecurityErrors', 'Boolean', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_ALWininetHttpClient2(CL: TPSPascalCompiler);
begin
 CL.AddConstantN('INTERNET_STATUS_COOKIE_SENT','LongInt').SetInt( 320);
 CL.AddConstantN('INTERNET_STATUS_COOKIE_RECEIVED','LongInt').SetInt( 321);
 CL.AddConstantN('INTERNET_STATUS_PRIVACY_IMPACTED','LongInt').SetInt( 324);
 CL.AddConstantN('INTERNET_STATUS_P3P_HEADER','LongInt').SetInt( 325);
 CL.AddConstantN('INTERNET_STATUS_P3P_POLICYREF','LongInt').SetInt( 326);
 CL.AddConstantN('INTERNET_STATUS_COOKIE_HISTORY','LongInt').SetInt( 327);
  CL.AddTypeS('TALWinInetHttpInternetOpenAccessType2', '( wHttpAt_Direct, wHttp'
   +'At_Preconfig, wHttpAt_Preconfig_with_no_autoproxy, wHttpAt_Proxy )');
  CL.AddTypeS('TAlWininetHttpClientInternetOption2', '( wHttpIo_Async, wHttpIo_'
   +'From_Cache, wHttpIo_Offline, wHttpIo_Cache_if_net_fail, wHttpIo_Hyperlink,'
   +' wHttpIo_Ignore_cert_cn_invalid, wHttpIo_Ignore_cert_date_invalid, wHttpIo'
   +'_Ignore_redirect_to_http, wHttpIo_Ignore_redirect_to_https, wHttpIo_Keep_c'
   +'onnection, wHttpIo_Need_file, wHttpIo_No_auth, wHttpIo_No_auto_redirect, w'
   +'HttpIo_No_cache_write, wHttpIo_No_cookies, wHttpIo_No_ui, wHttpIo_Pragma_n'
   +'ocache, wHttpIo_Reload, wHttpIo_Resynchronize, wHttpIo_Secure )');
  CL.AddTypeS('TALWininetHttpClientInternetOptionSet2', 'set of TAlWininetHttpClientInternetOption2');
  CL.AddTypeS('TAlWinInetHTTPClientStatusEvent', 'Procedure ( sender : Tobject;'
   +' InternetStatus : DWord; StatusInformation : dword; StatusInformationLength : DWord)');
  SIRegister_TALWinInetHTTPClient2(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TALWinInetHTTPClient2IgnoreSecurityErrors_W(Self: TALWinInetHTTPClient2; const T: Boolean);
begin Self.IgnoreSecurityErrors := T; end;

(*----------------------------------------------------------------------------*)
procedure TALWinInetHTTPClient2IgnoreSecurityErrors_R(Self: TALWinInetHTTPClient2; var T: Boolean);
begin T := Self.IgnoreSecurityErrors; end;

(*----------------------------------------------------------------------------*)
procedure TALWinInetHTTPClient2OnStatus_W(Self: TALWinInetHTTPClient2; const T: TAlWinInetHTTPClientStatusEvent);
begin Self.OnStatus := T; end;

(*----------------------------------------------------------------------------*)
procedure TALWinInetHTTPClient2OnStatus_R(Self: TALWinInetHTTPClient2; var T: TAlWinInetHTTPClientStatusEvent);
begin T := Self.OnStatus; end;

(*----------------------------------------------------------------------------*)
procedure TALWinInetHTTPClient2InternetOptions_W(Self: TALWinInetHTTPClient2; const T: TAlWininetHTTPClientInternetOptionSet2);
begin Self.InternetOptions := T; end;

(*----------------------------------------------------------------------------*)
procedure TALWinInetHTTPClient2InternetOptions_R(Self: TALWinInetHTTPClient2; var T: TAlWininetHTTPClientInternetOptionSet2);
begin T := Self.InternetOptions; end;

(*----------------------------------------------------------------------------*)
procedure TALWinInetHTTPClient2AccessType_W(Self: TALWinInetHTTPClient2; const T: TALWinInetHttpInternetOpenAccessType2);
begin Self.AccessType := T; end;

(*----------------------------------------------------------------------------*)
procedure TALWinInetHTTPClient2AccessType_R(Self: TALWinInetHTTPClient2; var T: TALWinInetHttpInternetOpenAccessType2);
begin T := Self.AccessType; end;

(*----------------------------------------------------------------------------*)
Procedure TALWinInetHTTPClient2CheckError1_P(Self: TALWinInetHTTPClient2;  Error : Boolean);
Begin //Self.CheckError(Error);
END;

(*----------------------------------------------------------------------------*)
Procedure TALWinInetHTTPClient2CheckError_P(Self: TALWinInetHTTPClient2;  ErrCode : DWORD);
Begin //Self.CheckError(ErrCode);
END;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TALWinInetHTTPClient2(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TALWinInetHTTPClient2) do begin
    RegisterConstructor(@TALWinInetHTTPClient2.Create, 'Create');
    RegisterMethod(@TALWinInetHTTPClient2.Destroy, 'Free');
    RegisterMethod(@TALWinInetHTTPClient2.Connect, 'Connect');
    RegisterMethod(@TALWinInetHTTPClient2.Disconnect, 'Disconnect');
    RegisterPropertyHelper(@TALWinInetHTTPClient2AccessType_R,@TALWinInetHTTPClient2AccessType_W,'AccessType');
    RegisterPropertyHelper(@TALWinInetHTTPClient2InternetOptions_R,@TALWinInetHTTPClient2InternetOptions_W,'InternetOptions');
    RegisterPropertyHelper(@TALWinInetHTTPClient2OnStatus_R,@TALWinInetHTTPClient2OnStatus_W,'OnStatus');
    RegisterPropertyHelper(@TALWinInetHTTPClient2IgnoreSecurityErrors_R,@TALWinInetHTTPClient2IgnoreSecurityErrors_W,'IgnoreSecurityErrors');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_ALWininetHttpClient2(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TALWinInetHTTPClient2(CL);
end;

 
 
{ TPSImport_ALWininetHttpClient2 }
(*----------------------------------------------------------------------------*)
procedure TPSImport_ALWininetHttpClient2.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_ALWininetHttpClient2(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_ALWininetHttpClient2.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_ALWininetHttpClient2(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
