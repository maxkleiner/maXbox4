unit uPSI_SockRequestInterpreter;
{
   socks and rocks
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
  TPSImport_SockRequestInterpreter = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TLogSendDataBlock(CL: TPSPascalCompiler);
procedure SIRegister_TLogWebAppDataBlockInterpreter(CL: TPSPascalCompiler);
procedure SIRegister_TWebRequestDataBlockInterpreter(CL: TPSPascalCompiler);
procedure SIRegister_SockRequestInterpreter(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TLogSendDataBlock(CL: TPSRuntimeClassImporter);
procedure RIRegister_TLogWebAppDataBlockInterpreter(CL: TPSRuntimeClassImporter);
procedure RIRegister_TWebRequestDataBlockInterpreter(CL: TPSRuntimeClassImporter);
procedure RIRegister_SockRequestInterpreter(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   IdTCPClient
  ,idTCPConnection
  ,SockTransport
  ,IndySockTransport
  ,HTTPApp
  ,IdUDPServer
  ,IdSocketHandle
  ,IdUDPClient
  ,SyncObjs
  ,Contnrs
  ,SockRequestInterpreter
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_SockRequestInterpreter]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TLogSendDataBlock(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TSendDataBlock', 'TLogSendDataBlock') do
  with CL.AddClassN(CL.FindClass('TSendDataBlock'),'TLogSendDataBlock') do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TLogWebAppDataBlockInterpreter(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TWebRequestDataBlockInterpreter', 'TLogWebAppDataBlockInterpreter') do
  with CL.AddClassN(CL.FindClass('TWebRequestDataBlockInterpreter'),'TLogWebAppDataBlockInterpreter') do
  begin
    RegisterProperty('Complete', 'Boolean', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TWebRequestDataBlockInterpreter(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TCustomDataBlockInterpreter', 'TWebRequestDataBlockInterpreter') do
  with CL.AddClassN(CL.FindClass('TCustomDataBlockInterpreter'),'TWebRequestDataBlockInterpreter') do
  begin
    RegisterMethod('Procedure CallHandleRequest( ARequest : TWebRequest; AResponse : TWebResponse; AUsingStub : Boolean)');
    RegisterMethod('Function CallGetFieldByName( const AName : string) : string');
    RegisterMethod('Function CallReadClient( var ABuffer : string; ACount : Integer) : Integer');
    RegisterMethod('Function CallReadString( var ABuffer : string; ACount : Integer) : Integer');
    RegisterMethod('Function CallTranslateURI( const Value : string) : string');
    RegisterMethod('Function CallWriteClient( const ABuffer : string) : Integer');
    RegisterMethod('Function CallGetStringVariable( Index : Integer) : string');
    RegisterMethod('Function CallWriteHeaders( StatusCode : Integer; StatusText : string; Headers : string) : Boolean');
    RegisterMethod('Function CallUsingStub : Boolean');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_SockRequestInterpreter(CL: TPSPascalCompiler);
begin
  SIRegister_TWebRequestDataBlockInterpreter(CL);
  SIRegister_TLogWebAppDataBlockInterpreter(CL);
  SIRegister_TLogSendDataBlock(CL);
 CL.AddConstantN('asError','LongWord').SetUInt( $01);
 CL.AddConstantN('asHandleRequest','LongWord').SetUInt( $02);
 CL.AddConstantN('asGetFieldByName','LongWord').SetUInt( $03);
 CL.AddConstantN('asReadClient','LongWord').SetUInt( $04);
 CL.AddConstantN('asReadString','LongWord').SetUInt( $05);
 CL.AddConstantN('asTranslateURI','LongWord').SetUInt( $06);
 CL.AddConstantN('asWriteClient','LongWord').SetUInt( $07);
 CL.AddConstantN('asWriteHeaders','LongWord').SetUInt( $08);
 CL.AddConstantN('asUsingStub','LongWord').SetUInt( $09);
 CL.AddConstantN('asGetStringVariable','LongWord').SetUInt( $0A);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TLogWebAppDataBlockInterpreterComplete_R(Self: TLogWebAppDataBlockInterpreter; var T: Boolean);
begin T := Self.Complete; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TLogSendDataBlock(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TLogSendDataBlock) do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TLogWebAppDataBlockInterpreter(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TLogWebAppDataBlockInterpreter) do
  begin
    RegisterPropertyHelper(@TLogWebAppDataBlockInterpreterComplete_R,nil,'Complete');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TWebRequestDataBlockInterpreter(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TWebRequestDataBlockInterpreter) do begin
    RegisterMethod(@TWebRequestDataBlockInterpreter.CallHandleRequest, 'CallHandleRequest');
    RegisterMethod(@TWebRequestDataBlockInterpreter.CallGetFieldByName, 'CallGetFieldByName');
    RegisterMethod(@TWebRequestDataBlockInterpreter.CallReadClient, 'CallReadClient');
    RegisterMethod(@TWebRequestDataBlockInterpreter.CallReadString, 'CallReadString');
    RegisterMethod(@TWebRequestDataBlockInterpreter.CallTranslateURI, 'CallTranslateURI');
    RegisterMethod(@TWebRequestDataBlockInterpreter.CallWriteClient, 'CallWriteClient');
    RegisterMethod(@TWebRequestDataBlockInterpreter.CallGetStringVariable, 'CallGetStringVariable');
    RegisterMethod(@TWebRequestDataBlockInterpreter.CallWriteHeaders, 'CallWriteHeaders');
    RegisterMethod(@TWebRequestDataBlockInterpreter.CallUsingStub, 'CallUsingStub');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_SockRequestInterpreter(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TWebRequestDataBlockInterpreter(CL);
  RIRegister_TLogWebAppDataBlockInterpreter(CL);
  RIRegister_TLogSendDataBlock(CL);
end;

 
 
{ TPSImport_SockRequestInterpreter }
(*----------------------------------------------------------------------------*)
procedure TPSImport_SockRequestInterpreter.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_SockRequestInterpreter(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_SockRequestInterpreter.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_SockRequestInterpreter(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
