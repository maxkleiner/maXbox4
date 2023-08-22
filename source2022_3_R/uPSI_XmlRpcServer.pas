unit uPSI_XmlRpcServer;
{
for build with indy9   - add 2 free

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
  TPSImport_XmlRpcServer = class(TPSPlugin)
  public
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TRpcServer(CL: TPSPascalCompiler);
procedure SIRegister_TRpcServerParser(CL: TPSPascalCompiler);
procedure SIRegister_TRpcMethodHandler(CL: TPSPascalCompiler);
procedure SIRegister_XmlRpcServer(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TRpcServer(CL: TPSRuntimeClassImporter);
procedure RIRegister_TRpcServerParser(CL: TPSRuntimeClassImporter);
procedure RIRegister_TRpcMethodHandler(CL: TPSRuntimeClassImporter);
procedure RIRegister_XmlRpcServer(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   Contnrs
  ,SyncObjs
  ,IdCustomHTTPServer
  ,IdHTTPServer
  ,IdTCPServer
  ,XmlRpcCommon
  ,LibXmlParser
  ,XmlRpcTypes
  ,XmlRpcServer
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_XmlRpcServer]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TRpcServer(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TObject', 'TRpcServer') do
  with CL.AddClassN(CL.FindClass('TObject'),'TRpcServer') do begin
    RegisterMethod('Constructor Create');
    RegisterMethod('Procedure Free');
    RegisterProperty('EnableIntrospect', 'Boolean', iptrw);
    RegisterMethod('Procedure RegisterMethodHandler( MethodHandler : TRpcMethodHandler)');
    RegisterProperty('ListenPort', 'Integer', iptrw);
    RegisterProperty('Active', 'Boolean', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TRpcServerParser(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TObject', 'TRpcServerParser') do
  with CL.AddClassN(CL.FindClass('TObject'),'TRpcServerParser') do begin
    RegisterMethod('Constructor Create');
    RegisterMethod('Procedure Free');
    RegisterProperty('RequestName', 'string', iptrw);
    RegisterMethod('Procedure Parse( const Data : string)');
    RegisterMethod('Function GetParameters : TObjectList');
    RegisterMethod('Procedure StartTag');
    RegisterMethod('Procedure EndTag');
    RegisterMethod('Procedure DataTag');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TRpcMethodHandler(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TObject', 'TRpcMethodHandler') do
  with CL.AddClassN(CL.FindClass('TObject'),'TRpcMethodHandler') do
  begin
    RegisterProperty('Name', 'string', iptrw);
    RegisterProperty('Method', 'TRPCMethod', iptrw);
    RegisterProperty('Help', 'string', iptrw);
    RegisterProperty('Signature', 'string', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_XmlRpcServer(CL: TPSPascalCompiler);
begin
  CL.AddTypeS('TRpcThread', 'TIdPeerThread');
  CL.AddTypeS('TRPCMethod', 'Procedure ( Thread : TRpcThread; const MethodName '
   +': string; List : TList; Return : TRpcReturn)');
  SIRegister_TRpcMethodHandler(CL);
  SIRegister_TRpcServerParser(CL);
  SIRegister_TRpcServer(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TRpcServerActive_W(Self: TRpcServer; const T: Boolean);
begin Self.Active := T; end;

(*----------------------------------------------------------------------------*)
procedure TRpcServerActive_R(Self: TRpcServer; var T: Boolean);
begin T := Self.Active; end;

(*----------------------------------------------------------------------------*)
procedure TRpcServerListenPort_W(Self: TRpcServer; const T: Integer);
begin Self.ListenPort := T; end;

(*----------------------------------------------------------------------------*)
procedure TRpcServerListenPort_R(Self: TRpcServer; var T: Integer);
begin T := Self.ListenPort; end;

(*----------------------------------------------------------------------------*)
procedure TRpcServerEnableIntrospect_W(Self: TRpcServer; const T: Boolean);
begin Self.EnableIntrospect := T; end;

(*----------------------------------------------------------------------------*)
procedure TRpcServerEnableIntrospect_R(Self: TRpcServer; var T: Boolean);
begin T := Self.EnableIntrospect; end;

(*----------------------------------------------------------------------------*)
procedure TRpcServerParserRequestName_W(Self: TRpcServerParser; const T: string);
begin Self.RequestName := T; end;

(*----------------------------------------------------------------------------*)
procedure TRpcServerParserRequestName_R(Self: TRpcServerParser; var T: string);
begin T := Self.RequestName; end;

(*----------------------------------------------------------------------------*)
procedure TRpcMethodHandlerSignature_W(Self: TRpcMethodHandler; const T: string);
Begin Self.Signature := T; end;

(*----------------------------------------------------------------------------*)
procedure TRpcMethodHandlerSignature_R(Self: TRpcMethodHandler; var T: string);
Begin T := Self.Signature; end;

(*----------------------------------------------------------------------------*)
procedure TRpcMethodHandlerHelp_W(Self: TRpcMethodHandler; const T: string);
Begin Self.Help := T; end;

(*----------------------------------------------------------------------------*)
procedure TRpcMethodHandlerHelp_R(Self: TRpcMethodHandler; var T: string);
Begin T := Self.Help; end;

(*----------------------------------------------------------------------------*)
procedure TRpcMethodHandlerMethod_W(Self: TRpcMethodHandler; const T: TRPCMethod);
Begin Self.Method := T; end;

(*----------------------------------------------------------------------------*)
procedure TRpcMethodHandlerMethod_R(Self: TRpcMethodHandler; var T: TRPCMethod);
Begin T := Self.Method; end;

(*----------------------------------------------------------------------------*)
procedure TRpcMethodHandlerName_W(Self: TRpcMethodHandler; const T: string);
Begin Self.Name := T; end;

(*----------------------------------------------------------------------------*)
procedure TRpcMethodHandlerName_R(Self: TRpcMethodHandler; var T: string);
Begin T := Self.Name; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TRpcServer(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TRpcServer) do begin
    RegisterConstructor(@TRpcServer.Create, 'Create');
    RegisterMethod(@TRpcServer.Destroy, 'Free');
    RegisterPropertyHelper(@TRpcServerEnableIntrospect_R,@TRpcServerEnableIntrospect_W,'EnableIntrospect');
    RegisterMethod(@TRpcServer.RegisterMethodHandler, 'RegisterMethodHandler');
    RegisterPropertyHelper(@TRpcServerListenPort_R,@TRpcServerListenPort_W,'ListenPort');
    RegisterPropertyHelper(@TRpcServerActive_R,@TRpcServerActive_W,'Active');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TRpcServerParser(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TRpcServerParser) do begin
    RegisterConstructor(@TRpcServerParser.Create, 'Create');
    RegisterMethod(@TRpcServerParser.Destroy, 'Free');
    RegisterPropertyHelper(@TRpcServerParserRequestName_R,@TRpcServerParserRequestName_W,'RequestName');
    RegisterMethod(@TRpcServerParser.Parse, 'Parse');
    RegisterMethod(@TRpcServerParser.GetParameters, 'GetParameters');
    RegisterMethod(@TRpcServerParser.StartTag, 'StartTag');
    RegisterMethod(@TRpcServerParser.EndTag, 'EndTag');
    RegisterMethod(@TRpcServerParser.DataTag, 'DataTag');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TRpcMethodHandler(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TRpcMethodHandler) do
  begin
    RegisterPropertyHelper(@TRpcMethodHandlerName_R,@TRpcMethodHandlerName_W,'Name');
    RegisterPropertyHelper(@TRpcMethodHandlerMethod_R,@TRpcMethodHandlerMethod_W,'Method');
    RegisterPropertyHelper(@TRpcMethodHandlerHelp_R,@TRpcMethodHandlerHelp_W,'Help');
    RegisterPropertyHelper(@TRpcMethodHandlerSignature_R,@TRpcMethodHandlerSignature_W,'Signature');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_XmlRpcServer(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TRpcMethodHandler(CL);
  RIRegister_TRpcServerParser(CL);
  RIRegister_TRpcServer(CL);
end;

 
 
{ TPSImport_XmlRpcServer }
(*----------------------------------------------------------------------------*)
procedure TPSImport_XmlRpcServer.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_XmlRpcServer(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_XmlRpcServer.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_XmlRpcServer(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
