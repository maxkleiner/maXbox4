unit uPSI_HttpRESTConnectionIndy;
{
   frame for REST
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
  TPSImport_HttpRESTConnectionIndy = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_THttpConnectionIndy(CL: TPSPascalCompiler);
//procedure SIRegister_TIdHTTP(CL: TPSPascalCompiler);
procedure SIRegister_HttpRESTConnectionIndy(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_THttpConnectionIndy(CL: TPSRuntimeClassImporter);
//procedure RIRegister_TIdHTTP(CL: TPSRuntimeClassImporter);
procedure RIRegister_HttpRESTConnectionIndy(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   IdHTTP
  //,HttpConnection
  //,RestUtils
  //,IdCompressorZLib
  ,IdSSLOpenSSL
  ,HttpRESTConnectionIndy
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_HttpRESTConnectionIndy]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_THttpConnectionIndy(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TInterfacedObject', 'THttpConnectionIndy') do
  with CL.AddClassN(CL.FindClass('TInterfacedObject'),'THttpConnectionIndy') do begin
    RegisterMethod('Constructor Create');
    RegisterMethod('Procedure Free');
    RegisterMethod('Function SetAcceptTypes( AAcceptTypes : string) : IHttpConnection');
    RegisterMethod('Function SetAcceptedLanguages( AAcceptedLanguages : string) : IHttpConnection');
    RegisterMethod('Function SetContentTypes( AContentTypes : string) : IHttpConnection');
    RegisterMethod('Function SetHeaders( AHeaders : TStrings) : IHttpConnection');
    RegisterMethod('Procedure Get( AUrl : string; AResponse : TStream)');
    RegisterMethod('Procedure Post( AUrl : string; AContent : TStream; AResponse : TStream)');
    RegisterMethod('Procedure Put( AUrl : string; AContent : TStream; AResponse : TStream)');
    RegisterMethod('Procedure Delete( AUrl : string; AContent : TStream)');
    RegisterMethod('Function GetResponseCode : Integer');
    RegisterMethod('Function GetEnabledCompression : Boolean');
    RegisterMethod('Procedure SetEnabledCompression( const Value : Boolean)');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TIdHTTP(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TIdHTTP', 'TIdHTTP') do
  with CL.AddClassN(CL.FindClass('TIdHTTP'),'TIdHTTP') do begin
    RegisterMethod('Procedure Delete( AURL : string)');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_HttpRESTConnectionIndy(CL: TPSPascalCompiler);
begin
  //SIRegister_TIdHTTP(CL);
  CL.AddClassN(CL.FindClass('IInterface'),'IHttpConnection');

  SIRegister_THttpConnectionIndy(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure RIRegister_THttpConnectionIndy(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(THttpConnectionIndy) do begin
    RegisterConstructor(@THttpConnectionIndy.Create, 'Create');
    RegisterMethod(@THttpConnectionIndy.Destroy, 'Free');

    RegisterMethod(@THttpConnectionIndy.SetAcceptTypes, 'SetAcceptTypes');
    RegisterMethod(@THttpConnectionIndy.SetAcceptedLanguages, 'SetAcceptedLanguages');
    RegisterMethod(@THttpConnectionIndy.SetContentTypes, 'SetContentTypes');
    RegisterMethod(@THttpConnectionIndy.SetHeaders, 'SetHeaders');
    RegisterMethod(@THttpConnectionIndy.Get, 'Get');
    RegisterMethod(@THttpConnectionIndy.Post, 'Post');
    RegisterMethod(@THttpConnectionIndy.Put, 'Put');
    RegisterMethod(@THttpConnectionIndy.Delete, 'Delete');
    RegisterMethod(@THttpConnectionIndy.GetResponseCode, 'GetResponseCode');
    RegisterMethod(@THttpConnectionIndy.GetEnabledCompression, 'GetEnabledCompression');
    RegisterMethod(@THttpConnectionIndy.SetEnabledCompression, 'SetEnabledCompression');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TIdHTTP(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TIdHTTP) do begin
    //RegisterMethod(@TIdHTTP.Delete, 'Delete');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_HttpRESTConnectionIndy(CL: TPSRuntimeClassImporter);
begin
  //RIRegister_TIdHTTP(CL);
  RIRegister_THttpConnectionIndy(CL);
end;

 
 
{ TPSImport_HttpRESTConnectionIndy }
(*----------------------------------------------------------------------------*)
procedure TPSImport_HttpRESTConnectionIndy.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_HttpRESTConnectionIndy(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_HttpRESTConnectionIndy.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_HttpRESTConnectionIndy(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
