unit uPSI_RestUtils;
{
test the rest for EKON 26

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
  TPSImport_RestUtils = class(TPSPlugin)
  public
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TRestUtils(CL: TPSPascalCompiler);
procedure SIRegister_TStatusCode(CL: TPSPascalCompiler);
procedure SIRegister_RestUtils(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TRestUtils(CL: TPSRuntimeClassImporter);
procedure RIRegister_TStatusCode(CL: TPSRuntimeClassImporter);
procedure RIRegister_RestUtils(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   RestUtils
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_RestUtils]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TRestUtils(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOBJECT', 'TRestUtils') do
  with CL.AddClassN(CL.FindClass('TOBJECT'),'TRestUtils') do
  begin
    RegisterMethod('Function Base64Encode( const AValue : String) : String');
    RegisterMethod('Function Base64Decode( const AValue : String) : String');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TStatusCode(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOBJECT', 'TStatusCode') do
  with CL.AddClassN(CL.FindClass('TOBJECT'),'TStatusCode') do
  begin
    RegisterMethod('Function CONTINUE : TReponseCode');
    RegisterMethod('Function SWITCHING_PROTOCOLS : TReponseCode');
    RegisterMethod('Function OK : TReponseCode');
    RegisterMethod('Function CREATED : TReponseCode');
    RegisterMethod('Function ACCEPTED : TReponseCode');
    RegisterMethod('Function NON_AUTHORITATIVE_INFORMATION : TReponseCode');
    RegisterMethod('Function NO_CONTENT : TReponseCode');
    RegisterMethod('Function RESET_CONTENT : TReponseCode');
    RegisterMethod('Function PARTIAL_CONTENT : TReponseCode');
    RegisterMethod('Function MULTIPLE_CHOICES : TReponseCode');
    RegisterMethod('Function MOVED_PERMANENTLY : TReponseCode');
    RegisterMethod('Function FOUND : TReponseCode');
    RegisterMethod('Function SEE_OTHER : TReponseCode');
    RegisterMethod('Function NOT_MODIFIED : TReponseCode');
    RegisterMethod('Function USE_PROXY : TReponseCode');
    RegisterMethod('Function TEMPORARY_REDIRECT : TReponseCode');
    RegisterMethod('Function BAD_REQUEST : TReponseCode');
    RegisterMethod('Function UNAUTHORIZED : TReponseCode');
    RegisterMethod('Function PAYMENT_REQUIRED : TReponseCode');
    RegisterMethod('Function FORBIDDEN : TReponseCode');
    RegisterMethod('Function NOT_FOUND : TReponseCode');
    RegisterMethod('Function METHOD_NOT_ALLOWED : TReponseCode');
    RegisterMethod('Function NOT_ACCEPTABLE : TReponseCode');
    RegisterMethod('Function PROXY_AUTHENTICATION_REQUIRED : TReponseCode');
    RegisterMethod('Function REQUEST_TIMEOUT : TReponseCode');
    RegisterMethod('Function CONFLICT : TReponseCode');
    RegisterMethod('Function GONE : TReponseCode');
    RegisterMethod('Function LENGTH_REQUIRED : TReponseCode');
    RegisterMethod('Function PRECONDITION_FAILED : TReponseCode');
    RegisterMethod('Function REQUEST_ENTITY_TOO_LARGE : TReponseCode');
    RegisterMethod('Function REQUEST_URI_TOO_LONG : TReponseCode');
    RegisterMethod('Function UNSUPPORTED_MEDIA_TYPE : TReponseCode');
    RegisterMethod('Function REQUESTED_RANGE_NOT_SATISFIABLE : TReponseCode');
    RegisterMethod('Function EXPECTATION_FAILED : TReponseCode');
    RegisterMethod('Function UNPROCESSABLE_ENTITY : TReponseCode');
    RegisterMethod('Function INTERNAL_SERVER_ERROR : TReponseCode');
    RegisterMethod('Function NOT_IMPLEMENTED : TReponseCode');
    RegisterMethod('Function BAD_GATEWAY : TReponseCode');
    RegisterMethod('Function SERVICE_UNAVAILABLE : TReponseCode');
    RegisterMethod('Function GATEWAY_TIMEOUT : TReponseCode');
    RegisterMethod('Function HTTP_VERSION_NOT_SUPPORTED : TReponseCode');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_RestUtils(CL: TPSPascalCompiler);
begin
 CL.AddConstantN('MediaType_Json','String').SetString( 'application/json');
 CL.AddConstantN('MediaType_Xml','String').SetString( 'text/xml');
 CL.AddConstantN('LOCALE_PORTUGUESE_BRAZILIAN','String').SetString( 'pt-BR');
 CL.AddConstantN('LOCALE_US','String').SetString( 'en-US');
  CL.AddTypeS('TReponseCode', 'record StatusCode : Integer; Reason : string; end');
  SIRegister_TStatusCode(CL);
  SIRegister_TRestUtils(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure RIRegister_TRestUtils(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TRestUtils) do
  begin
    RegisterMethod(@TRestUtils.Base64Encode, 'Base64Encode');
    RegisterMethod(@TRestUtils.Base64Decode, 'Base64Decode');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TStatusCode(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TStatusCode) do
  begin
    RegisterMethod(@TStatusCode.CONTINUE, 'CONTINUE');
    RegisterMethod(@TStatusCode.SWITCHING_PROTOCOLS, 'SWITCHING_PROTOCOLS');
    RegisterMethod(@TStatusCode.OK, 'OK');
    RegisterMethod(@TStatusCode.CREATED, 'CREATED');
    RegisterMethod(@TStatusCode.ACCEPTED, 'ACCEPTED');
    RegisterMethod(@TStatusCode.NON_AUTHORITATIVE_INFORMATION, 'NON_AUTHORITATIVE_INFORMATION');
    RegisterMethod(@TStatusCode.NO_CONTENT, 'NO_CONTENT');
    RegisterMethod(@TStatusCode.RESET_CONTENT, 'RESET_CONTENT');
    RegisterMethod(@TStatusCode.PARTIAL_CONTENT, 'PARTIAL_CONTENT');
    RegisterMethod(@TStatusCode.MULTIPLE_CHOICES, 'MULTIPLE_CHOICES');
    RegisterMethod(@TStatusCode.MOVED_PERMANENTLY, 'MOVED_PERMANENTLY');
    RegisterMethod(@TStatusCode.FOUND, 'FOUND');
    RegisterMethod(@TStatusCode.SEE_OTHER, 'SEE_OTHER');
    RegisterMethod(@TStatusCode.NOT_MODIFIED, 'NOT_MODIFIED');
    RegisterMethod(@TStatusCode.USE_PROXY, 'USE_PROXY');
    RegisterMethod(@TStatusCode.TEMPORARY_REDIRECT, 'TEMPORARY_REDIRECT');
    RegisterMethod(@TStatusCode.BAD_REQUEST, 'BAD_REQUEST');
    RegisterMethod(@TStatusCode.UNAUTHORIZED, 'UNAUTHORIZED');
    RegisterMethod(@TStatusCode.PAYMENT_REQUIRED, 'PAYMENT_REQUIRED');
    RegisterMethod(@TStatusCode.FORBIDDEN, 'FORBIDDEN');
    RegisterMethod(@TStatusCode.NOT_FOUND, 'NOT_FOUND');
    RegisterMethod(@TStatusCode.METHOD_NOT_ALLOWED, 'METHOD_NOT_ALLOWED');
    RegisterMethod(@TStatusCode.NOT_ACCEPTABLE, 'NOT_ACCEPTABLE');
    RegisterMethod(@TStatusCode.PROXY_AUTHENTICATION_REQUIRED, 'PROXY_AUTHENTICATION_REQUIRED');
    RegisterMethod(@TStatusCode.REQUEST_TIMEOUT, 'REQUEST_TIMEOUT');
    RegisterMethod(@TStatusCode.CONFLICT, 'CONFLICT');
    RegisterMethod(@TStatusCode.GONE, 'GONE');
    RegisterMethod(@TStatusCode.LENGTH_REQUIRED, 'LENGTH_REQUIRED');
    RegisterMethod(@TStatusCode.PRECONDITION_FAILED, 'PRECONDITION_FAILED');
    RegisterMethod(@TStatusCode.REQUEST_ENTITY_TOO_LARGE, 'REQUEST_ENTITY_TOO_LARGE');
    RegisterMethod(@TStatusCode.REQUEST_URI_TOO_LONG, 'REQUEST_URI_TOO_LONG');
    RegisterMethod(@TStatusCode.UNSUPPORTED_MEDIA_TYPE, 'UNSUPPORTED_MEDIA_TYPE');
    RegisterMethod(@TStatusCode.REQUESTED_RANGE_NOT_SATISFIABLE, 'REQUESTED_RANGE_NOT_SATISFIABLE');
    RegisterMethod(@TStatusCode.EXPECTATION_FAILED, 'EXPECTATION_FAILED');
    RegisterMethod(@TStatusCode.UNPROCESSABLE_ENTITY, 'UNPROCESSABLE_ENTITY');
    RegisterMethod(@TStatusCode.INTERNAL_SERVER_ERROR, 'INTERNAL_SERVER_ERROR');
    RegisterMethod(@TStatusCode.NOT_IMPLEMENTED, 'NOT_IMPLEMENTED');
    RegisterMethod(@TStatusCode.BAD_GATEWAY, 'BAD_GATEWAY');
    RegisterMethod(@TStatusCode.SERVICE_UNAVAILABLE, 'SERVICE_UNAVAILABLE');
    RegisterMethod(@TStatusCode.GATEWAY_TIMEOUT, 'GATEWAY_TIMEOUT');
    RegisterMethod(@TStatusCode.HTTP_VERSION_NOT_SUPPORTED, 'HTTP_VERSION_NOT_SUPPORTED');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_RestUtils(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TStatusCode(CL);
  RIRegister_TRestUtils(CL);
end;

 
 
{ TPSImport_RestUtils }
(*----------------------------------------------------------------------------*)
procedure TPSImport_RestUtils.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_RestUtils(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_RestUtils.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_RestUtils(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
