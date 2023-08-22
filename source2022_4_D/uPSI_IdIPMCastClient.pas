unit uPSI_IdIPMCastClient;
{
  multicast
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
  TPSImport_IdIPMCastClient = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TIdIPMCastClient(CL: TPSPascalCompiler);
procedure SIRegister_TIdIPMCastListenerThread(CL: TPSPascalCompiler);
procedure SIRegister_IdIPMCastClient(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TIdIPMCastClient(CL: TPSRuntimeClassImporter);
procedure RIRegister_TIdIPMCastListenerThread(CL: TPSRuntimeClassImporter);
procedure RIRegister_IdIPMCastClient(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   IdIPMCastBase
  ,IdUDPBase
  ,IdComponent
  ,IdSocketHandle
  ,IdThread
  ,IdException
  ,IdIPMCastClient
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_IdIPMCastClient]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
Function BoolToStr(value : boolean) : string;
Begin If value then Result := 'TRUE' else Result := 'FALSE' End;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TIdIPMCastClient(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TIdIPMCastBase', 'TIdIPMCastClient') do
  with CL.AddClassN(CL.FindClass('TIdIPMCastBase'),'TIdIPMCastClient') do
  begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
    RegisterProperty('Bindings', 'TIdSocketHandles', iptrw);
    RegisterProperty('BufferSize', 'Integer', iptrw);
    RegisterProperty('DefaultPort', 'integer', iptrw);
    RegisterProperty('OnIPMCastRead', 'TIPMCastReadEvent', iptrw);
    RegisterProperty('ThreadedEvent', 'boolean', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TIdIPMCastListenerThread(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TIdThread', 'TIdIPMCastListenerThread') do
  with CL.AddClassN(CL.FindClass('TIdThread'),'TIdIPMCastListenerThread') do
  begin
    RegisterProperty('FServer', 'TIdIPMCastClient', iptrw);
    RegisterMethod('Constructor Create( Owner : TIdIPMCastClient)');
    RegisterMethod('Procedure Run');
    RegisterMethod('Procedure IPMCastRead');
    RegisterProperty('AcceptWait', 'integer', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_IdIPMCastClient(CL: TPSPascalCompiler);
begin
 CL.AddConstantN('DEF_IMP_THREADEDEVENT','String').SetString(BoolToStr( False));
  CL.AddTypeS('TIPMCastReadEvent', 'Procedure ( Sender : TObject; AData : TStre'
   +'am; ABinding : TIdSocketHandle)');
  CL.AddClassN(CL.FindClass('TOBJECT'),'TIdIPMCastClient');
  SIRegister_TIdIPMCastListenerThread(CL);
  SIRegister_TIdIPMCastClient(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TIdIPMCastClientThreadedEvent_W(Self: TIdIPMCastClient; const T: boolean);
begin Self.ThreadedEvent := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdIPMCastClientThreadedEvent_R(Self: TIdIPMCastClient; var T: boolean);
begin T := Self.ThreadedEvent; end;

(*----------------------------------------------------------------------------*)
procedure TIdIPMCastClientOnIPMCastRead_W(Self: TIdIPMCastClient; const T: TIPMCastReadEvent);
begin Self.OnIPMCastRead := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdIPMCastClientOnIPMCastRead_R(Self: TIdIPMCastClient; var T: TIPMCastReadEvent);
begin T := Self.OnIPMCastRead; end;

(*----------------------------------------------------------------------------*)
procedure TIdIPMCastClientDefaultPort_W(Self: TIdIPMCastClient; const T: integer);
begin Self.DefaultPort := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdIPMCastClientDefaultPort_R(Self: TIdIPMCastClient; var T: integer);
begin T := Self.DefaultPort; end;

(*----------------------------------------------------------------------------*)
procedure TIdIPMCastClientBufferSize_W(Self: TIdIPMCastClient; const T: Integer);
begin Self.BufferSize := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdIPMCastClientBufferSize_R(Self: TIdIPMCastClient; var T: Integer);
begin T := Self.BufferSize; end;

(*----------------------------------------------------------------------------*)
procedure TIdIPMCastClientBindings_W(Self: TIdIPMCastClient; const T: TIdSocketHandles);
begin Self.Bindings := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdIPMCastClientBindings_R(Self: TIdIPMCastClient; var T: TIdSocketHandles);
begin T := Self.Bindings; end;

(*----------------------------------------------------------------------------*)
procedure TIdIPMCastListenerThreadAcceptWait_W(Self: TIdIPMCastListenerThread; const T: integer);
begin Self.AcceptWait := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdIPMCastListenerThreadAcceptWait_R(Self: TIdIPMCastListenerThread; var T: integer);
begin T := Self.AcceptWait; end;

(*----------------------------------------------------------------------------*)
procedure TIdIPMCastListenerThreadFServer_W(Self: TIdIPMCastListenerThread; const T: TIdIPMCastClient);
Begin Self.FServer := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdIPMCastListenerThreadFServer_R(Self: TIdIPMCastListenerThread; var T: TIdIPMCastClient);
Begin T := Self.FServer; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TIdIPMCastClient(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TIdIPMCastClient) do
  begin
    RegisterConstructor(@TIdIPMCastClient.Create, 'Create');
    RegisterPropertyHelper(@TIdIPMCastClientBindings_R,@TIdIPMCastClientBindings_W,'Bindings');
    RegisterPropertyHelper(@TIdIPMCastClientBufferSize_R,@TIdIPMCastClientBufferSize_W,'BufferSize');
    RegisterPropertyHelper(@TIdIPMCastClientDefaultPort_R,@TIdIPMCastClientDefaultPort_W,'DefaultPort');
    RegisterPropertyHelper(@TIdIPMCastClientOnIPMCastRead_R,@TIdIPMCastClientOnIPMCastRead_W,'OnIPMCastRead');
    RegisterPropertyHelper(@TIdIPMCastClientThreadedEvent_R,@TIdIPMCastClientThreadedEvent_W,'ThreadedEvent');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TIdIPMCastListenerThread(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TIdIPMCastListenerThread) do
  begin
    RegisterPropertyHelper(@TIdIPMCastListenerThreadFServer_R,@TIdIPMCastListenerThreadFServer_W,'FServer');
    RegisterConstructor(@TIdIPMCastListenerThread.Create, 'Create');
    RegisterMethod(@TIdIPMCastListenerThread.Run, 'Run');
    RegisterMethod(@TIdIPMCastListenerThread.IPMCastRead, 'IPMCastRead');
    RegisterPropertyHelper(@TIdIPMCastListenerThreadAcceptWait_R,@TIdIPMCastListenerThreadAcceptWait_W,'AcceptWait');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_IdIPMCastClient(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TIdIPMCastClient) do
  RIRegister_TIdIPMCastListenerThread(CL);
  RIRegister_TIdIPMCastClient(CL);
end;

 
 
{ TPSImport_IdIPMCastClient }
(*----------------------------------------------------------------------------*)
procedure TPSImport_IdIPMCastClient.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_IdIPMCastClient(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_IdIPMCastClient.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_IdIPMCastClient(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
