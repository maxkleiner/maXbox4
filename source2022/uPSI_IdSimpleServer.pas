unit uPSI_IdSimpleServer;
{
  baseline
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
  TPSImport_IdSimpleServer = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;


{ compile-time registration functions }
procedure SIRegister_TIdSimpleServer(CL: TPSPascalCompiler);
procedure SIRegister_IdSimpleServer(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TIdSimpleServer(CL: TPSRuntimeClassImporter);
procedure RIRegister_IdSimpleServer(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   IdSocketHandle
  ,IdTCPConnection
  ,IdStackConsts
  ,IdSimpleServer
  ;


procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_IdSimpleServer]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TIdSimpleServer(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TIdTCPConnection', 'TIdSimpleServer') do
  with CL.AddClassN(CL.FindClass('TIdTCPConnection'),'TIdSimpleServer') do begin
    RegisterMethod('Procedure Abort');
    RegisterMethod('Procedure BeginListen');
    RegisterMethod('Procedure Bind');
    RegisterMethod('Constructor Create( AOwner : TComponent)');
    RegisterMethod('Procedure CreateBinding');
    RegisterMethod('Procedure EndListen');
    RegisterMethod('Function Listen : Boolean');
    RegisterMethod('Procedure ResetConnection');
    RegisterProperty('AcceptWait', 'integer', iptrw);
    RegisterProperty('Binding', 'TIdSocketHandle', iptr);
    RegisterProperty('ListenHandle', 'TIdStackSocketHandle', iptr);
    RegisterProperty('BoundIP', 'string', iptrw);
    RegisterProperty('BoundPort', 'Integer', iptrw);
    RegisterProperty('BoundPortMin', 'Integer', iptrw);
    RegisterProperty('BoundPortMax', 'Integer', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_IdSimpleServer(CL: TPSPascalCompiler);
begin
 CL.AddConstantN('ID_ACCEPT_WAIT','LongInt').SetInt( 1000);
  SIRegister_TIdSimpleServer(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TIdSimpleServerBoundPortMax_W(Self: TIdSimpleServer; const T: Integer);
begin Self.BoundPortMax := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdSimpleServerBoundPortMax_R(Self: TIdSimpleServer; var T: Integer);
begin T := Self.BoundPortMax; end;

(*----------------------------------------------------------------------------*)
procedure TIdSimpleServerBoundPortMin_W(Self: TIdSimpleServer; const T: Integer);
begin Self.BoundPortMin := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdSimpleServerBoundPortMin_R(Self: TIdSimpleServer; var T: Integer);
begin T := Self.BoundPortMin; end;

(*----------------------------------------------------------------------------*)
procedure TIdSimpleServerBoundPort_W(Self: TIdSimpleServer; const T: Integer);
begin Self.BoundPort := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdSimpleServerBoundPort_R(Self: TIdSimpleServer; var T: Integer);
begin T := Self.BoundPort; end;

(*----------------------------------------------------------------------------*)
procedure TIdSimpleServerBoundIP_W(Self: TIdSimpleServer; const T: string);
begin Self.BoundIP := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdSimpleServerBoundIP_R(Self: TIdSimpleServer; var T: string);
begin T := Self.BoundIP; end;

(*----------------------------------------------------------------------------*)
procedure TIdSimpleServerListenHandle_R(Self: TIdSimpleServer; var T: TIdStackSocketHandle);
begin T := Self.ListenHandle; end;

(*----------------------------------------------------------------------------*)
procedure TIdSimpleServerBinding_R(Self: TIdSimpleServer; var T: TIdSocketHandle);
begin T := Self.Binding; end;

(*----------------------------------------------------------------------------*)
procedure TIdSimpleServerAcceptWait_W(Self: TIdSimpleServer; const T: integer);
begin Self.AcceptWait := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdSimpleServerAcceptWait_R(Self: TIdSimpleServer; var T: integer);
begin T := Self.AcceptWait; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TIdSimpleServer(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TIdSimpleServer) do
  begin
    RegisterVirtualMethod(@TIdSimpleServer.Abort, 'Abort');
    RegisterVirtualMethod(@TIdSimpleServer.BeginListen, 'BeginListen');
    RegisterVirtualMethod(@TIdSimpleServer.Bind, 'Bind');
    RegisterConstructor(@TIdSimpleServer.Create, 'Create');
    RegisterMethod(@TIdSimpleServer.CreateBinding, 'CreateBinding');
    RegisterVirtualMethod(@TIdSimpleServer.EndListen, 'EndListen');
    RegisterVirtualMethod(@TIdSimpleServer.Listen, 'Listen');
    RegisterMethod(@TIdSimpleServer.ResetConnection, 'ResetConnection');
    RegisterPropertyHelper(@TIdSimpleServerAcceptWait_R,@TIdSimpleServerAcceptWait_W,'AcceptWait');
    RegisterPropertyHelper(@TIdSimpleServerBinding_R,nil,'Binding');
    RegisterPropertyHelper(@TIdSimpleServerListenHandle_R,nil,'ListenHandle');
    RegisterPropertyHelper(@TIdSimpleServerBoundIP_R,@TIdSimpleServerBoundIP_W,'BoundIP');
    RegisterPropertyHelper(@TIdSimpleServerBoundPort_R,@TIdSimpleServerBoundPort_W,'BoundPort');
    RegisterPropertyHelper(@TIdSimpleServerBoundPortMin_R,@TIdSimpleServerBoundPortMin_W,'BoundPortMin');
    RegisterPropertyHelper(@TIdSimpleServerBoundPortMax_R,@TIdSimpleServerBoundPortMax_W,'BoundPortMax');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_IdSimpleServer(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TIdSimpleServer(CL);
end;

 
 
{ TPSImport_IdSimpleServer }
(*----------------------------------------------------------------------------*)
procedure TPSImport_IdSimpleServer.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_IdSimpleServer(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_IdSimpleServer.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_IdSimpleServer(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
