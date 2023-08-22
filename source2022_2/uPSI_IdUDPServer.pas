unit uPSI_IdUDPServer;
{
  4 classes in one unit
  209 unit IdUDPServer;
210 unit IdTimeUDPServer;
211 unit IdTimeServer;
212 unit IdTimeUDP; (unit uPSI_IdUDPServer;)

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
  TPSImport_IdUDPServer = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;


{ compile-time registration functions }
procedure SIRegister_TIdTimeUDP(CL: TPSPascalCompiler);
procedure SIRegister_TIdTimeServer(CL: TPSPascalCompiler);
procedure SIRegister_TIdTimeUDPServer(CL: TPSPascalCompiler);
procedure SIRegister_TIdUDPServer(CL: TPSPascalCompiler);
procedure SIRegister_TIdUDPListenerThread(CL: TPSPascalCompiler);
procedure SIRegister_IdUDPServer(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TIdTimeUDP(CL: TPSRuntimeClassImporter);
procedure RIRegister_TIdTimeServer(CL: TPSRuntimeClassImporter);
procedure RIRegister_TIdTimeUDPServer(CL: TPSRuntimeClassImporter);
procedure RIRegister_TIdUDPServer(CL: TPSRuntimeClassImporter);
procedure RIRegister_TIdUDPListenerThread(CL: TPSRuntimeClassImporter);
procedure RIRegister_IdUDPServer(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   IdComponent
  ,IdException
  ,IdGlobal
  ,IdSocketHandle
  ,IdStackConsts
  ,IdThread
  ,IdUDPBase
  ,IdTimeUDPServer
  ,IdTCPServer
  ,IdUDPClient
  ,IdUDPServer
  ,IdTimeUDP
  ,IdTimeServer
  ;


procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_IdUDPServer]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TIdTimeUDP(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TIdUDPClient', 'TIdTimeUDP') do
  with CL.AddClassN(CL.FindClass('TIdUDPClient'),'TIdTimeUDP') do begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
    RegisterMethod('Function SyncTime : Boolean');
    RegisterProperty('DateTimeCard', 'Cardinal', iptr);
    RegisterProperty('DateTime', 'TDateTime', iptr);
    RegisterProperty('RoundTripDelay', 'Cardinal', iptr);
    RegisterProperty('BaseDate', 'TDateTime', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TIdTimeServer(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TIdTCPServer', 'TIdTimeServer') do
  with CL.AddClassN(CL.FindClass('TIdTCPServer'),'TIdTimeServer') do begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
    RegisterProperty('BaseDate', 'TDateTime', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TIdTimeUDPServer(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TIdUDPServer', 'TIdTimeUDPServer') do
  with CL.AddClassN(CL.FindClass('TIdUDPServer'),'TIdTimeUDPServer') do begin
    RegisterMethod('Constructor Create( axOwner : TComponent)');
    RegisterProperty('BaseDate', 'TDateTime', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TIdUDPServer(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TIdUDPBase', 'TIdUDPServer') do
  with CL.AddClassN(CL.FindClass('TIdUDPBase'),'TIdUDPServer') do begin
    RegisterMethod('Constructor Create( axOwner : TComponent)');
    RegisterProperty('Bindings', 'TIdSocketHandles', iptrw);
    RegisterProperty('DefaultPort', 'integer', iptrw);
    RegisterProperty('OnUDPRead', 'TUDPReadEvent', iptrw);
    RegisterProperty('ThreadedEvent', 'boolean', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TIdUDPListenerThread(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TIdThread', 'TIdUDPListenerThread') do
  with CL.AddClassN(CL.FindClass('TIdThread'),'TIdUDPListenerThread') do begin
    RegisterProperty('FServer', 'TIdUDPServer', iptrw);
    RegisterMethod('Constructor Create( const ABufferSize : integer; Owner : TIdUDPServer)');
    RegisterMethod('Procedure Run');
    RegisterMethod('Procedure UDPRead');
    RegisterProperty('AcceptWait', 'integer', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_IdUDPServer(CL: TPSPascalCompiler);
begin
 CL.AddConstantN('TIMEUDP_DEFBASEDATE','LongInt').SetInt( 2);
  CL.AddTypeS('TUDPReadEvent', 'Procedure ( Sender : TObject; AData : TStream; '
   +'ABinding : TIdSocketHandle)');
  CL.AddClassN(CL.FindClass('TOBJECT'),'TIdUDPServer');
  SIRegister_TIdUDPListenerThread(CL);
  SIRegister_TIdUDPServer(CL);
  CL.AddClassN(CL.FindClass('TOBJECT'),'EIdUDPServerException');
  SIRegister_TIdTimeUDPServer(CL);
  SIRegister_TIdTimeServer(CL);
  SIRegister_TIdTimeUDP(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TIdTimeUDPBaseDate_W(Self: TIdTimeUDP; const T: TDateTime);
begin Self.BaseDate := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdTimeUDPBaseDate_R(Self: TIdTimeUDP; var T: TDateTime);
begin T := Self.BaseDate; end;

(*----------------------------------------------------------------------------*)
procedure TIdTimeUDPRoundTripDelay_R(Self: TIdTimeUDP; var T: Cardinal);
begin T := Self.RoundTripDelay; end;

(*----------------------------------------------------------------------------*)
procedure TIdTimeUDPDateTime_R(Self: TIdTimeUDP; var T: TDateTime);
begin T := Self.DateTime; end;

(*----------------------------------------------------------------------------*)
procedure TIdTimeUDPDateTimeCard_R(Self: TIdTimeUDP; var T: Cardinal);
begin T := Self.DateTimeCard; end;

(*----------------------------------------------------------------------------*)
procedure TIdTimeServerBaseDate_W(Self: TIdTimeServer; const T: TDateTime);
begin Self.BaseDate := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdTimeServerBaseDate_R(Self: TIdTimeServer; var T: TDateTime);
begin T := Self.BaseDate; end;

(*----------------------------------------------------------------------------*)
procedure TIdTimeUDPServerBaseDate_W(Self: TIdTimeUDPServer; const T: TDateTime);
begin Self.BaseDate := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdTimeUDPServerBaseDate_R(Self: TIdTimeUDPServer; var T: TDateTime);
begin T := Self.BaseDate; end;

(*----------------------------------------------------------------------------*)
procedure TIdUDPServerThreadedEvent_W(Self: TIdUDPServer; const T: boolean);
begin Self.ThreadedEvent := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdUDPServerThreadedEvent_R(Self: TIdUDPServer; var T: boolean);
begin T := Self.ThreadedEvent; end;

(*----------------------------------------------------------------------------*)
procedure TIdUDPServerOnUDPRead_W(Self: TIdUDPServer; const T: TUDPReadEvent);
begin Self.OnUDPRead := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdUDPServerOnUDPRead_R(Self: TIdUDPServer; var T: TUDPReadEvent);
begin T := Self.OnUDPRead; end;

(*----------------------------------------------------------------------------*)
procedure TIdUDPServerDefaultPort_W(Self: TIdUDPServer; const T: integer);
begin Self.DefaultPort := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdUDPServerDefaultPort_R(Self: TIdUDPServer; var T: integer);
begin T := Self.DefaultPort; end;

(*----------------------------------------------------------------------------*)
procedure TIdUDPServerBindings_W(Self: TIdUDPServer; const T: TIdSocketHandles);
begin Self.Bindings := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdUDPServerBindings_R(Self: TIdUDPServer; var T: TIdSocketHandles);
begin T := Self.Bindings; end;

(*----------------------------------------------------------------------------*)
procedure TIdUDPListenerThreadAcceptWait_W(Self: TIdUDPListenerThread; const T: integer);
begin Self.AcceptWait := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdUDPListenerThreadAcceptWait_R(Self: TIdUDPListenerThread; var T: integer);
begin T := Self.AcceptWait; end;

(*----------------------------------------------------------------------------*)
procedure TIdUDPListenerThreadFServer_W(Self: TIdUDPListenerThread; const T: TIdUDPServer);
Begin Self.FServer := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdUDPListenerThreadFServer_R(Self: TIdUDPListenerThread; var T: TIdUDPServer);
Begin T := Self.FServer; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TIdTimeUDP(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TIdTimeUDP) do begin
    RegisterConstructor(@TIdTimeUDP.Create, 'Create');
    RegisterMethod(@TIdTimeUDP.SyncTime, 'SyncTime');
    RegisterPropertyHelper(@TIdTimeUDPDateTimeCard_R,nil,'DateTimeCard');
    RegisterPropertyHelper(@TIdTimeUDPDateTime_R,nil,'DateTime');
    RegisterPropertyHelper(@TIdTimeUDPRoundTripDelay_R,nil,'RoundTripDelay');
    RegisterPropertyHelper(@TIdTimeUDPBaseDate_R,@TIdTimeUDPBaseDate_W,'BaseDate');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TIdTimeServer(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TIdTimeServer) do begin
    RegisterConstructor(@TIdTimeServer.Create, 'Create');
    RegisterPropertyHelper(@TIdTimeServerBaseDate_R,@TIdTimeServerBaseDate_W,'BaseDate');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TIdTimeUDPServer(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TIdTimeUDPServer) do begin
    RegisterConstructor(@TIdTimeUDPServer.Create, 'Create');
    RegisterPropertyHelper(@TIdTimeUDPServerBaseDate_R,@TIdTimeUDPServerBaseDate_W,'BaseDate');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TIdUDPServer(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TIdUDPServer) do begin
    RegisterConstructor(@TIdUDPServer.Create, 'Create');
    RegisterPropertyHelper(@TIdUDPServerBindings_R,@TIdUDPServerBindings_W,'Bindings');
    RegisterPropertyHelper(@TIdUDPServerDefaultPort_R,@TIdUDPServerDefaultPort_W,'DefaultPort');
    RegisterPropertyHelper(@TIdUDPServerOnUDPRead_R,@TIdUDPServerOnUDPRead_W,'OnUDPRead');
    RegisterPropertyHelper(@TIdUDPServerThreadedEvent_R,@TIdUDPServerThreadedEvent_W,'ThreadedEvent');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TIdUDPListenerThread(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TIdUDPListenerThread) do begin
    RegisterPropertyHelper(@TIdUDPListenerThreadFServer_R,@TIdUDPListenerThreadFServer_W,'FServer');
    RegisterConstructor(@TIdUDPListenerThread.Create, 'Create');
    RegisterMethod(@TIdUDPListenerThread.Run, 'Run');
    RegisterMethod(@TIdUDPListenerThread.UDPRead, 'UDPRead');
    RegisterPropertyHelper(@TIdUDPListenerThreadAcceptWait_R,@TIdUDPListenerThreadAcceptWait_W,'AcceptWait');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_IdUDPServer(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TIdUDPServer) do
  RIRegister_TIdUDPListenerThread(CL);
  RIRegister_TIdUDPServer(CL);
  with CL.Add(EIdUDPServerException) do
  RIRegister_TIdTimeUDPServer(CL);
  RIRegister_TIdTimeServer(CL);
  RIRegister_TIdTimeUDP(CL);
end;



{ TPSImport_IdUDPServer }
(*----------------------------------------------------------------------------*)
procedure TPSImport_IdUDPServer.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_IdUDPServer(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_IdUDPServer.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_IdUDPServer(ri);
end;
(*----------------------------------------------------------------------------*)


end.
