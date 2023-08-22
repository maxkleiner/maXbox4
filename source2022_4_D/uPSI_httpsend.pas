unit uPSI_httpsend;
{
   synapse tip of lazarus
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
  TPSImport_httpsend = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_THTTPSend(CL: TPSPascalCompiler);
procedure SIRegister_httpsend(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_httpsend_Routines(S: TPSExec);
procedure RIRegister_THTTPSend(CL: TPSRuntimeClassImporter);
procedure RIRegister_httpsend(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   blcksock
  ,synautil
  ,synaip
  ,synacode
  ,synsock
  ,httpsend
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_httpsend]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_THTTPSend(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TSynaClient', 'THTTPSend') do
  with CL.AddClassN(CL.FindClass('TSynaClient'),'THTTPSend') do begin
    RegisterMethod('Constructor Create');
    RegisterMethod('Procedure Clear');
        RegisterMethod('Procedure Free');
      RegisterMethod('Procedure DecodeStatus( const Value : string)');
    RegisterMethod('Function HTTPMethod( const Method, URL : string) : Boolean');
    RegisterMethod('Procedure Abort');
    RegisterProperty('Headers', 'TStringList', iptr);
    RegisterProperty('Cookies', 'TStringList', iptr);
    RegisterProperty('Document', 'TMemoryStream', iptr);
    RegisterProperty('RangeStart', 'integer', iptrw);
    RegisterProperty('RangeEnd', 'integer', iptrw);
    RegisterProperty('MimeType', 'string', iptrw);
    RegisterProperty('Protocol', 'string', iptrw);
    RegisterProperty('KeepAlive', 'Boolean', iptrw);
    RegisterProperty('KeepAliveTimeout', 'integer', iptrw);
    RegisterProperty('Status100', 'Boolean', iptrw);
    RegisterProperty('ProxyHost', 'string', iptrw);
    RegisterProperty('ProxyPort', 'string', iptrw);
    RegisterProperty('ProxyUser', 'string', iptrw);
    RegisterProperty('ProxyPass', 'string', iptrw);
    RegisterProperty('UserAgent', 'string', iptrw);
    RegisterProperty('ResultCode', 'Integer', iptr);
    RegisterProperty('ResultString', 'string', iptr);
    RegisterProperty('DownloadSize', 'integer', iptr);
    RegisterProperty('UploadSize', 'integer', iptr);
    RegisterProperty('Sock', 'TTCPBlockSocket', iptr);
    RegisterProperty('AddPortNumberToHost', 'Boolean', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_httpsend(CL: TPSPascalCompiler);
begin
 CL.AddConstantN('cHttpProtocol','String').SetString( '80');
  CL.AddTypeS('TTransferEncoding', '( TE_UNKNOWN, TE_IDENTITY, TE_CHUNKED )');
  SIRegister_THTTPSend(CL);
 CL.AddDelphiFunction('Function HttpGetText( const URL : string; const Response : TStrings) : Boolean');
 CL.AddDelphiFunction('Function HttpGetBinary( const URL : string; const Response : TStream) : Boolean');
 CL.AddDelphiFunction('Function HttpPostBinary( const URL : string; const Data : TStream) : Boolean');
 CL.AddDelphiFunction('Function HttpPostURL( const URL, URLData : string; const Data : TStream) : Boolean');
 CL.AddDelphiFunction('Function HttpPostFile( const URL, FieldName, FileName : string; const Data : TStream; const ResultData : TStrings) : Boolean');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure THTTPSendAddPortNumberToHost_W(Self: THTTPSend; const T: Boolean);
begin Self.AddPortNumberToHost := T; end;

(*----------------------------------------------------------------------------*)
procedure THTTPSendAddPortNumberToHost_R(Self: THTTPSend; var T: Boolean);
begin T := Self.AddPortNumberToHost; end;

(*----------------------------------------------------------------------------*)
procedure THTTPSendSock_R(Self: THTTPSend; var T: TTCPBlockSocket);
begin T := Self.Sock; end;

(*----------------------------------------------------------------------------*)
procedure THTTPSendUploadSize_R(Self: THTTPSend; var T: integer);
begin T := Self.UploadSize; end;

(*----------------------------------------------------------------------------*)
procedure THTTPSendDownloadSize_R(Self: THTTPSend; var T: integer);
begin T := Self.DownloadSize; end;

(*----------------------------------------------------------------------------*)
procedure THTTPSendResultString_R(Self: THTTPSend; var T: string);
begin T := Self.ResultString; end;

(*----------------------------------------------------------------------------*)
procedure THTTPSendResultCode_R(Self: THTTPSend; var T: Integer);
begin T := Self.ResultCode; end;

(*----------------------------------------------------------------------------*)
procedure THTTPSendUserAgent_W(Self: THTTPSend; const T: string);
begin Self.UserAgent := T; end;

(*----------------------------------------------------------------------------*)
procedure THTTPSendUserAgent_R(Self: THTTPSend; var T: string);
begin T := Self.UserAgent; end;

(*----------------------------------------------------------------------------*)
procedure THTTPSendProxyPass_W(Self: THTTPSend; const T: string);
begin Self.ProxyPass := T; end;

(*----------------------------------------------------------------------------*)
procedure THTTPSendProxyPass_R(Self: THTTPSend; var T: string);
begin T := Self.ProxyPass; end;

(*----------------------------------------------------------------------------*)
procedure THTTPSendProxyUser_W(Self: THTTPSend; const T: string);
begin Self.ProxyUser := T; end;

(*----------------------------------------------------------------------------*)
procedure THTTPSendProxyUser_R(Self: THTTPSend; var T: string);
begin T := Self.ProxyUser; end;

(*----------------------------------------------------------------------------*)
procedure THTTPSendProxyPort_W(Self: THTTPSend; const T: string);
begin Self.ProxyPort := T; end;

(*----------------------------------------------------------------------------*)
procedure THTTPSendProxyPort_R(Self: THTTPSend; var T: string);
begin T := Self.ProxyPort; end;

(*----------------------------------------------------------------------------*)
procedure THTTPSendProxyHost_W(Self: THTTPSend; const T: string);
begin Self.ProxyHost := T; end;

(*----------------------------------------------------------------------------*)
procedure THTTPSendProxyHost_R(Self: THTTPSend; var T: string);
begin T := Self.ProxyHost; end;

(*----------------------------------------------------------------------------*)
procedure THTTPSendStatus100_W(Self: THTTPSend; const T: Boolean);
begin Self.Status100 := T; end;

(*----------------------------------------------------------------------------*)
procedure THTTPSendStatus100_R(Self: THTTPSend; var T: Boolean);
begin T := Self.Status100; end;

(*----------------------------------------------------------------------------*)
procedure THTTPSendKeepAliveTimeout_W(Self: THTTPSend; const T: integer);
begin Self.KeepAliveTimeout := T; end;

(*----------------------------------------------------------------------------*)
procedure THTTPSendKeepAliveTimeout_R(Self: THTTPSend; var T: integer);
begin T := Self.KeepAliveTimeout; end;

(*----------------------------------------------------------------------------*)
procedure THTTPSendKeepAlive_W(Self: THTTPSend; const T: Boolean);
begin Self.KeepAlive := T; end;

(*----------------------------------------------------------------------------*)
procedure THTTPSendKeepAlive_R(Self: THTTPSend; var T: Boolean);
begin T := Self.KeepAlive; end;

(*----------------------------------------------------------------------------*)
procedure THTTPSendProtocol_W(Self: THTTPSend; const T: string);
begin Self.Protocol := T; end;

(*----------------------------------------------------------------------------*)
procedure THTTPSendProtocol_R(Self: THTTPSend; var T: string);
begin T := Self.Protocol; end;

(*----------------------------------------------------------------------------*)
procedure THTTPSendMimeType_W(Self: THTTPSend; const T: string);
begin Self.MimeType := T; end;

(*----------------------------------------------------------------------------*)
procedure THTTPSendMimeType_R(Self: THTTPSend; var T: string);
begin T := Self.MimeType; end;

(*----------------------------------------------------------------------------*)
procedure THTTPSendRangeEnd_W(Self: THTTPSend; const T: integer);
begin Self.RangeEnd := T; end;

(*----------------------------------------------------------------------------*)
procedure THTTPSendRangeEnd_R(Self: THTTPSend; var T: integer);
begin T := Self.RangeEnd; end;

(*----------------------------------------------------------------------------*)
procedure THTTPSendRangeStart_W(Self: THTTPSend; const T: integer);
begin Self.RangeStart := T; end;

(*----------------------------------------------------------------------------*)
procedure THTTPSendRangeStart_R(Self: THTTPSend; var T: integer);
begin T := Self.RangeStart; end;

(*----------------------------------------------------------------------------*)
procedure THTTPSendDocument_R(Self: THTTPSend; var T: TMemoryStream);
begin T := Self.Document; end;

(*----------------------------------------------------------------------------*)
procedure THTTPSendCookies_R(Self: THTTPSend; var T: TStringList);
begin T := Self.Cookies; end;

(*----------------------------------------------------------------------------*)
procedure THTTPSendHeaders_R(Self: THTTPSend; var T: TStringList);
begin T := Self.Headers; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_httpsend_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@HttpGetText, 'HttpGetText', cdRegister);
 S.RegisterDelphiFunction(@HttpGetBinary, 'HttpGetBinary', cdRegister);
 S.RegisterDelphiFunction(@HttpPostBinary, 'HttpPostBinary', cdRegister);
 S.RegisterDelphiFunction(@HttpPostURL, 'HttpPostURL', cdRegister);
 S.RegisterDelphiFunction(@HttpPostFile, 'HttpPostFile', cdRegister);
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_THTTPSend(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(THTTPSend) do begin
    RegisterConstructor(@THTTPSend.Create, 'Create');
      RegisterMethod(@THTTPSend.Destroy, 'Free');
      RegisterMethod(@THTTPSend.Clear, 'Clear');
    RegisterMethod(@THTTPSend.DecodeStatus, 'DecodeStatus');
    RegisterMethod(@THTTPSend.HTTPMethod, 'HTTPMethod');
    RegisterMethod(@THTTPSend.Abort, 'Abort');
    RegisterPropertyHelper(@THTTPSendHeaders_R,nil,'Headers');
    RegisterPropertyHelper(@THTTPSendCookies_R,nil,'Cookies');
    RegisterPropertyHelper(@THTTPSendDocument_R,nil,'Document');
    RegisterPropertyHelper(@THTTPSendRangeStart_R,@THTTPSendRangeStart_W,'RangeStart');
    RegisterPropertyHelper(@THTTPSendRangeEnd_R,@THTTPSendRangeEnd_W,'RangeEnd');
    RegisterPropertyHelper(@THTTPSendMimeType_R,@THTTPSendMimeType_W,'MimeType');
    RegisterPropertyHelper(@THTTPSendProtocol_R,@THTTPSendProtocol_W,'Protocol');
    RegisterPropertyHelper(@THTTPSendKeepAlive_R,@THTTPSendKeepAlive_W,'KeepAlive');
    RegisterPropertyHelper(@THTTPSendKeepAliveTimeout_R,@THTTPSendKeepAliveTimeout_W,'KeepAliveTimeout');
    RegisterPropertyHelper(@THTTPSendStatus100_R,@THTTPSendStatus100_W,'Status100');
    RegisterPropertyHelper(@THTTPSendProxyHost_R,@THTTPSendProxyHost_W,'ProxyHost');
    RegisterPropertyHelper(@THTTPSendProxyPort_R,@THTTPSendProxyPort_W,'ProxyPort');
    RegisterPropertyHelper(@THTTPSendProxyUser_R,@THTTPSendProxyUser_W,'ProxyUser');
    RegisterPropertyHelper(@THTTPSendProxyPass_R,@THTTPSendProxyPass_W,'ProxyPass');
    RegisterPropertyHelper(@THTTPSendUserAgent_R,@THTTPSendUserAgent_W,'UserAgent');
    RegisterPropertyHelper(@THTTPSendResultCode_R,nil,'ResultCode');
    RegisterPropertyHelper(@THTTPSendResultString_R,nil,'ResultString');
    RegisterPropertyHelper(@THTTPSendDownloadSize_R,nil,'DownloadSize');
    RegisterPropertyHelper(@THTTPSendUploadSize_R,nil,'UploadSize');
    RegisterPropertyHelper(@THTTPSendSock_R,nil,'Sock');
    RegisterPropertyHelper(@THTTPSendAddPortNumberToHost_R,@THTTPSendAddPortNumberToHost_W,'AddPortNumberToHost');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_httpsend(CL: TPSRuntimeClassImporter);
begin
  RIRegister_THTTPSend(CL);
end;

 
 
{ TPSImport_httpsend }
(*----------------------------------------------------------------------------*)
procedure TPSImport_httpsend.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_httpsend(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_httpsend.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_httpsend(ri);
  RIRegister_httpsend_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
