unit uPSI_IdIntercept;
{
   to webbroker
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
  TPSImport_IdIntercept = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TIdServerIntercept(CL: TPSPascalCompiler);
procedure SIRegister_TIdConnectionIntercept(CL: TPSPascalCompiler);
procedure SIRegister_IdIntercept(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TIdServerIntercept(CL: TPSRuntimeClassImporter);
procedure RIRegister_TIdConnectionIntercept(CL: TPSRuntimeClassImporter);
procedure RIRegister_IdIntercept(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   IdBaseComponent
  ,IdException
  ,IdIntercept
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_IdIntercept]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TIdServerIntercept(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TIdBaseComponent', 'TIdServerIntercept') do
  with CL.AddClassN(CL.FindClass('TIdBaseComponent'),'TIdServerIntercept') do begin
    RegisterMethod('Procedure Init');
    RegisterMethod('Function Accept( AConnection : TComponent) : TIdConnectionIntercept');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TIdConnectionIntercept(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TIdBaseComponent', 'TIdConnectionIntercept') do
  with CL.AddClassN(CL.FindClass('TIdBaseComponent'),'TIdConnectionIntercept') do begin
    RegisterMethod('Procedure Connect( AConnection : TComponent)');
    RegisterMethod('Constructor Create( AOwner : TComponent)');
    RegisterMethod('Procedure Disconnect');
    RegisterMethod('Procedure Receive( ABuffer : TStream)');
    RegisterMethod('Procedure Send( ABuffer : TStream)');
    RegisterProperty('Connection', 'TComponent', iptr);
    RegisterProperty('IsClient', 'Boolean', iptr);
    RegisterProperty('OnConnect', 'TIdInterceptNotifyEvent', iptrw);
    RegisterProperty('OnDisconnect', 'TIdInterceptNotifyEvent', iptrw);
    RegisterProperty('OnReceive', 'TIdInterceptStreamEvent', iptrw);
    RegisterProperty('OnSend', 'TIdInterceptStreamEvent', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_IdIntercept(CL: TPSPascalCompiler);
begin
  CL.AddClassN(CL.FindClass('TOBJECT'),'EIdInterceptCircularLink');
  CL.AddClassN(CL.FindClass('TOBJECT'),'TIdConnectionIntercept');
  CL.AddTypeS('TIdInterceptNotifyEvent', 'Procedure ( ASender : TIdConnectionIntercept)');
  CL.AddTypeS('TIdInterceptStreamEvent', 'Procedure ( ASender : TIdConnectionIntercept; AStream : TStream)');
  SIRegister_TIdConnectionIntercept(CL);
  SIRegister_TIdServerIntercept(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TIdConnectionInterceptOnSend_W(Self: TIdConnectionIntercept; const T: TIdInterceptStreamEvent);
begin Self.OnSend := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdConnectionInterceptOnSend_R(Self: TIdConnectionIntercept; var T: TIdInterceptStreamEvent);
begin T := Self.OnSend; end;

(*----------------------------------------------------------------------------*)
procedure TIdConnectionInterceptOnReceive_W(Self: TIdConnectionIntercept; const T: TIdInterceptStreamEvent);
begin Self.OnReceive := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdConnectionInterceptOnReceive_R(Self: TIdConnectionIntercept; var T: TIdInterceptStreamEvent);
begin T := Self.OnReceive; end;

(*----------------------------------------------------------------------------*)
procedure TIdConnectionInterceptOnDisconnect_W(Self: TIdConnectionIntercept; const T: TIdInterceptNotifyEvent);
begin Self.OnDisconnect := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdConnectionInterceptOnDisconnect_R(Self: TIdConnectionIntercept; var T: TIdInterceptNotifyEvent);
begin T := Self.OnDisconnect; end;

(*----------------------------------------------------------------------------*)
procedure TIdConnectionInterceptOnConnect_W(Self: TIdConnectionIntercept; const T: TIdInterceptNotifyEvent);
begin Self.OnConnect := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdConnectionInterceptOnConnect_R(Self: TIdConnectionIntercept; var T: TIdInterceptNotifyEvent);
begin T := Self.OnConnect; end;

(*----------------------------------------------------------------------------*)
procedure TIdConnectionInterceptIsClient_R(Self: TIdConnectionIntercept; var T: Boolean);
begin T := Self.IsClient; end;

(*----------------------------------------------------------------------------*)
procedure TIdConnectionInterceptConnection_R(Self: TIdConnectionIntercept; var T: TComponent);
begin T := Self.Connection; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TIdServerIntercept(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TIdServerIntercept) do begin
    //RegisterVirtualAbstractMethod(@TIdServerIntercept, @!.Init, 'Init');
    //RegisterVirtualAbstractMethod(@TIdServerIntercept, @!.Accept, 'Accept');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TIdConnectionIntercept(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TIdConnectionIntercept) do
  begin
    RegisterVirtualMethod(@TIdConnectionIntercept.Connect, 'Connect');
    RegisterConstructor(@TIdConnectionIntercept.Create, 'Create');
    RegisterVirtualMethod(@TIdConnectionIntercept.Disconnect, 'Disconnect');
    RegisterVirtualMethod(@TIdConnectionIntercept.Receive, 'Receive');
    RegisterVirtualMethod(@TIdConnectionIntercept.Send, 'Send');
    RegisterPropertyHelper(@TIdConnectionInterceptConnection_R,nil,'Connection');
    RegisterPropertyHelper(@TIdConnectionInterceptIsClient_R,nil,'IsClient');
    RegisterPropertyHelper(@TIdConnectionInterceptOnConnect_R,@TIdConnectionInterceptOnConnect_W,'OnConnect');
    RegisterPropertyHelper(@TIdConnectionInterceptOnDisconnect_R,@TIdConnectionInterceptOnDisconnect_W,'OnDisconnect');
    RegisterPropertyHelper(@TIdConnectionInterceptOnReceive_R,@TIdConnectionInterceptOnReceive_W,'OnReceive');
    RegisterPropertyHelper(@TIdConnectionInterceptOnSend_R,@TIdConnectionInterceptOnSend_W,'OnSend');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_IdIntercept(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(EIdInterceptCircularLink) do
  with CL.Add(TIdConnectionIntercept) do
  RIRegister_TIdConnectionIntercept(CL);
  RIRegister_TIdServerIntercept(CL);
end;

 
 
{ TPSImport_IdIntercept }
(*----------------------------------------------------------------------------*)
procedure TPSImport_IdIntercept.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_IdIntercept(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_IdIntercept.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_IdIntercept(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
