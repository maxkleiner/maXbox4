unit uPSI_RestRequest;
{
    all in one indy REST
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
  TPSImport_RestRequest = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TRestRequest(CL: TPSPascalCompiler);
procedure SIRegister_RestRequest(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TRestRequest(CL: TPSRuntimeClassImporter);
procedure RIRegister_RestRequest(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   IdHttp
  ,IdAuthentication
  ,IdMultipartFormData
  ,IdURI
  ,RestRequest
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_RestRequest]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TRestRequest(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TObject', 'TRestRequest') do
  with CL.AddClassN(CL.FindClass('TObject'),'TRestRequest') do begin
    RegisterMethod('Constructor Create( aIsSSL : boolean);');
    RegisterMethod('Constructor Create1;');
    RegisterMethod('Procedure Free');
    RegisterMethod('Function Domain( aDomain : string) : TRestRequest');
    RegisterMethod('Function Path( aPath : string) : TRestRequest');
    RegisterMethod('Function Param( aKey : string; aValue : string) : TRestRequest');
    RegisterMethod('Function FileParam( aKey : string; aValue : string) : TRestRequest');
    RegisterMethod('Function WithHeader( aName : string; aValue : string) : TRestRequest');
    RegisterMethod('Function WithCredentials( username, password : string) : TRestRequest');
    RegisterProperty('Response', 'THttpResponse', iptr);
    RegisterProperty('FullUrl', 'string', iptr);
    RegisterProperty('Accept', 'string', iptrw);
    RegisterProperty('ContentType', 'string', iptrw);
    RegisterProperty('BeforeRequest', 'TBeforeRequest', iptrw);
    RegisterMethod('Function Get : THttpResponse');
    RegisterMethod('Function Put( aParams : TStringList) : THttpResponse');
    RegisterMethod('Function Post( aParams : TStringList) : THttpResponse');
    RegisterMethod('Function Delete : THttpResponse');
    RegisterMethod('Function Options : THttpResponse');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_RestRequest(CL: TPSPascalCompiler);
begin
  CL.AddTypeS('TBeforeRequest', 'Procedure ( Sender : TObject; var AHttpClient: TIdHttp)');
  CL.AddTypeS('THttpResponse', 'record ResponseCode : integer; ResponseStr : string; end');
  SIRegister_TRestRequest(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TRestRequestBeforeRequest_W(Self: TRestRequest; const T: TBeforeRequest);
begin Self.BeforeRequest := T; end;

(*----------------------------------------------------------------------------*)
procedure TRestRequestBeforeRequest_R(Self: TRestRequest; var T: TBeforeRequest);
begin T := Self.BeforeRequest; end;

(*----------------------------------------------------------------------------*)
procedure TRestRequestContentType_W(Self: TRestRequest; const T: string);
begin Self.ContentType := T; end;

(*----------------------------------------------------------------------------*)
procedure TRestRequestContentType_R(Self: TRestRequest; var T: string);
begin T := Self.ContentType; end;

(*----------------------------------------------------------------------------*)
procedure TRestRequestAccept_W(Self: TRestRequest; const T: string);
begin Self.Accept := T; end;

(*----------------------------------------------------------------------------*)
procedure TRestRequestAccept_R(Self: TRestRequest; var T: string);
begin T := Self.Accept; end;

(*----------------------------------------------------------------------------*)
procedure TRestRequestFullUrl_R(Self: TRestRequest; var T: string);
begin T := Self.FullUrl; end;

(*----------------------------------------------------------------------------*)
procedure TRestRequestResponse_R(Self: TRestRequest; var T: THttpResponse);
begin T := Self.Response; end;

(*----------------------------------------------------------------------------*)
Function TRestRequestCreate1_P(Self: TClass; CreateNewInstance: Boolean):TObject;
Begin Result := TRestRequest.Create; END;

(*----------------------------------------------------------------------------*)
Function TRestRequestCreate_P(Self: TClass; CreateNewInstance: Boolean;  aIsSSL : boolean):TObject;
Begin Result := TRestRequest.Create(aIsSSL); END;

(*----------------------------------------------------------------------------*)
Function TRestRequestdoPost1_P(Self: TRestRequest;  aParams : TStringStream) : THttpResponse;
Begin
   //Result := Self.doPost(aParams);
 END;

(*----------------------------------------------------------------------------*)
Function TRestRequestdoPost_P(Self: TRestRequest;  aParams : TIdMultiPartFormDataStream) : THttpResponse;
Begin
   //Result := Self.doPost(aParams);
END;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TRestRequest(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TRestRequest) do begin
    RegisterConstructor(@TRestRequestCreate_P, 'Create');
    RegisterConstructor(@TRestRequestCreate1_P, 'Create1');
    RegisterMethod(@TRestRequest.Destroy, 'Free');
    RegisterMethod(@TRestRequest.Domain, 'Domain');
    RegisterMethod(@TRestRequest.Path, 'Path');
    RegisterMethod(@TRestRequest.Param, 'Param');
    RegisterMethod(@TRestRequest.FileParam, 'FileParam');
    RegisterMethod(@TRestRequest.WithHeader, 'WithHeader');
    RegisterMethod(@TRestRequest.WithCredentials, 'WithCredentials');
    RegisterPropertyHelper(@TRestRequestResponse_R,nil,'Response');
    RegisterPropertyHelper(@TRestRequestFullUrl_R,nil,'FullUrl');
    RegisterPropertyHelper(@TRestRequestAccept_R,@TRestRequestAccept_W,'Accept');
    RegisterPropertyHelper(@TRestRequestContentType_R,@TRestRequestContentType_W,'ContentType');
    RegisterPropertyHelper(@TRestRequestBeforeRequest_R,@TRestRequestBeforeRequest_W,'BeforeRequest');
    RegisterMethod(@TRestRequest.Get, 'Get');
    RegisterMethod(@TRestRequest.Put, 'Put');
    RegisterMethod(@TRestRequest.Post, 'Post');
    RegisterMethod(@TRestRequest.Delete, 'Delete');
    RegisterMethod(@TRestRequest.Options, 'Options');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_RestRequest(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TRestRequest(CL);
end;

 
 
{ TPSImport_RestRequest }
(*----------------------------------------------------------------------------*)
procedure TPSImport_RestRequest.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_RestRequest(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_RestRequest.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_RestRequest(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
