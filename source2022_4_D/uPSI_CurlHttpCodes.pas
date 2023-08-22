unit uPSI_CurlHttpCodes;
{
T  y     one the prepare problem

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
  TPSImport_CurlHttpCodes = class(TPSPlugin)
  public
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
 procedure SIRegister_CurlHttpCodes(CL: TPSPascalCompiler);


{ run-time registration functions }

procedure Register;

implementation


uses
   CurlHttpCodes
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_CurlHttpCodes]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_CurlHttpCodes(CL: TPSPascalCompiler);
begin
 CL.AddConstantN('HTTP_CONTINUE','LongInt').SetInt( 100);
 CL.AddConstantN('HTTP_SWITCHING_PROTOCOLS','LongInt').SetInt( 101);
 CL.AddConstantN('HTTP_PROCESSING','LongInt').SetInt( 102);
 CL.AddConstantN('HTTP_NAME_NOT_RESOLVED','LongInt').SetInt( 105);
 CL.AddConstantN('HTTP_OK','LongInt').SetInt( 200);
 CL.AddConstantN('HTTP_CREATED','LongInt').SetInt( 201);
 CL.AddConstantN('HTTP_ACCEPTED','LongInt').SetInt( 202);
 CL.AddConstantN('HTTP_NOT_AUTHORITATIVE_INFO','LongInt').SetInt( 203);
 CL.AddConstantN('HTTP_NO_CONTENT','LongInt').SetInt( 204);
 CL.AddConstantN('HTTP_RESET_CONTENT','LongInt').SetInt( 205);
 CL.AddConstantN('HTTP_PARTIAL_CONTENT','LongInt').SetInt( 206);
 CL.AddConstantN('HTTP_MULTI_STATUS','LongInt').SetInt( 207);
 CL.AddConstantN('HTTP_ALREADY_REPORTED','LongInt').SetInt( 208);
 CL.AddConstantN('HTTP_IM_USED','LongInt').SetInt( 226);
 CL.AddConstantN('HTTP_MULTIPLE_CHOICES','LongInt').SetInt( 300);
 CL.AddConstantN('HTTP_MOVED_PERMANENTLY','LongInt').SetInt( 301);
 CL.AddConstantN('HTTP_FOUND','LongInt').SetInt( 302);
 CL.AddConstantN('HTTP_SEE_OTHER','LongInt').SetInt( 303);
 CL.AddConstantN('HTTP_NOT_MODIFIED','LongInt').SetInt( 304);
 CL.AddConstantN('HTTP_USE_PROXY','LongInt').SetInt( 305);
 CL.AddConstantN('HTTP_SWITCH_PROXY','LongInt').SetInt( 306);
 CL.AddConstantN('HTTP_TEMPORARY_REDIRECT','LongInt').SetInt( 307);
 CL.AddConstantN('HTTP_PERMANENT_REDIRECT','LongInt').SetInt( 308);
 CL.AddConstantN('HTTP_BAD_REQUEST','LongInt').SetInt( 400);
 CL.AddConstantN('HTTP_UNAUTHORIZED','LongInt').SetInt( 401);
 CL.AddConstantN('HTTP_PAYMENT_REQUIRED','LongInt').SetInt( 402);
 CL.AddConstantN('HTTP_FORBIDDEN','LongInt').SetInt( 403);
 CL.AddConstantN('HTTP_NOT_FOUND','LongInt').SetInt( 404);
 CL.AddConstantN('HTTP_METHOD_NOT_ALLOWED','LongInt').SetInt( 405);
 CL.AddConstantN('HTTP_NOT_ACCEPTABLE','LongInt').SetInt( 406);
 CL.AddConstantN('HTTP_PROXY_AUTHENTICATION_REQUIRED','LongInt').SetInt( 407);
 CL.AddConstantN('HTTP_REQUEST_TIMEOUT','LongInt').SetInt( 408);
 CL.AddConstantN('HTTP_CONFLICT','LongInt').SetInt( 409);
 CL.AddConstantN('HTTP_GONE','LongInt').SetInt( 410);
 CL.AddConstantN('HTTP_LENGTH_REQUIRED','LongInt').SetInt( 411);
 CL.AddConstantN('HTTP_PRECONDITION_FAILED','LongInt').SetInt( 412);
 CL.AddConstantN('HTTP_REQUEST_ENTITY_TOO_LARGE','LongInt').SetInt( 413);
 CL.AddConstantN('HTTP_REQUEST_URI_TOO_LONG','LongInt').SetInt( 414);
 CL.AddConstantN('HTTP_UNSUPPORTED_MEDIA_TYPE','LongInt').SetInt( 415);
 CL.AddConstantN('HTTP_REQUEST_RANGE_NOT_SATISFIABLE','LongInt').SetInt( 416);
 CL.AddConstantN('HTTP_EXPECTATION_FAILED','LongInt').SetInt( 417);
 CL.AddConstantN('HTTP_IM_A_TEAPOT','LongInt').SetInt( 418);
 CL.AddConstantN('HTTP_AUTHENTICATION_TIMEOUT','LongInt').SetInt( 419);
 CL.AddConstantN('HTTP_UNPROCESSABLE_ENTITY','LongInt').SetInt( 422);
 CL.AddConstantN('HTTP_LOCKED','LongInt').SetInt( 423);
 CL.AddConstantN('HTTP_FAILED_DEPENDENCY','LongInt').SetInt( 424);
 CL.AddConstantN('HTTP_UPGRADE_REQUIRED','LongInt').SetInt( 426);
 CL.AddConstantN('HTTP_PRECONDITION_REQUIRED','LongInt').SetInt( 428);
 CL.AddConstantN('HTTP_TOO_MANY_REQUESTS','LongInt').SetInt( 429);
 CL.AddConstantN('HTTP_REQUEST_HEADER_FIELDS_TOO_LARGE','LongInt').SetInt( 431);
 CL.AddConstantN('HTTP_UNAVAILABLE_FOR_LEGAL_REASONS','LongInt').SetInt( 451);
 CL.AddConstantN('HTTP_INTERNAL_SERVER_ERROR','LongInt').SetInt( 500);
 CL.AddConstantN('HTTP_NOT_IMPLEMENTED','LongInt').SetInt( 501);
 CL.AddConstantN('HTTP_BAD_GATEWAY','LongInt').SetInt( 502);
 CL.AddConstantN('HTTP_SERVICE_UNAVAILABLE','LongInt').SetInt( 503);
 CL.AddConstantN('HTTP_GATEWAY_TIMEOUT','LongInt').SetInt( 504);
 CL.AddConstantN('HTTP_VERSION_NOT_SUPPORTED','LongInt').SetInt( 505);
 CL.AddConstantN('HTTP_VARIANT_ALSO_NEGOTIATES','LongInt').SetInt( 506);
 CL.AddConstantN('HTTP_INSUFFICIENT_STORAGE','LongInt').SetInt( 507);
 CL.AddConstantN('HTTP_LOOP_DETECTED','LongInt').SetInt( 508);
 CL.AddConstantN('HTTP_BANDWIDTH_LIMIT_EXCEEDED','LongInt').SetInt( 509);
 CL.AddConstantN('HTTP_NOT_EXTENDED','LongInt').SetInt( 510);
end;

(* === run-time registration functions === *)
 
 
{ TPSImport_CurlHttpCodes }
(*----------------------------------------------------------------------------*)
procedure TPSImport_CurlHttpCodes.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_CurlHttpCodes(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_CurlHttpCodes.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
end;
(*----------------------------------------------------------------------------*)
 
 
end.
