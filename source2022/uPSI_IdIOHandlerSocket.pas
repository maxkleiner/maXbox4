unit uPSI_IdIOHandlerSocket;
{
   for tcpserverconnection
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
  TPSImport_IdIOHandlerSocket = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TIdIOHandlerSocket(CL: TPSPascalCompiler);
procedure SIRegister_TIdIOHandler(CL: TPSPascalCompiler);
procedure SIRegister_IdIOHandlerSocket(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TIdIOHandlerSocket(CL: TPSRuntimeClassImporter);
procedure RIRegister_TIdIOHandler(CL: TPSRuntimeClassImporter);
procedure RIRegister_IdIOHandlerSocket(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   IdGlobal
  ,IdSocks
  ,IdSocketHandle
  ,IdIOHandler
  ,IdException
  ,IdComponent
  ,IdIOHandlerSocket
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_IdIOHandlerSocket]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TIdIOHandlerSocket(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TIdIOHandler', 'TIdIOHandlerSocket') do
  with CL.AddClassN(CL.FindClass('TIdIOHandler'),'TIdIOHandlerSocket') do begin
    RegisterPublishedProperties;
    RegisterMethod('Procedure Close');
    RegisterMethod('Procedure ConnectClient( const AHost : string; const APort : Integer; const ABoundIP : string; const ABoundPort : Integer; const ABoundPortMin : Integer; const ABoundPortMax : Integer; const ATimeout : Integer)');
    RegisterMethod('Function Connected : Boolean');
    RegisterMethod('Constructor Create( AOwner : TComponent)');
    RegisterMethod('Procedure Open');
    RegisterMethod('Function Readable( AMSec : integer) : boolean');
    RegisterMethod('Function Recv( var ABuf, ALen : integer) : integer');
    RegisterMethod('Function Send( var ABuf, ALen : integer) : integer');
    RegisterProperty('Binding', 'TIdSocketHandle', iptr);
    RegisterProperty('SocksInfo', 'TIdSocksInfo', iptrw);
    RegisterProperty('UseNagle', 'boolean', iptrw);
    RegisterProperty('HandleAllocated', 'Boolean', iptr);
    RegisterProperty('Handle', 'TIdStackSocketHandle', iptr);
    RegisterProperty('PeerIP', 'string', iptr);
    RegisterProperty('PeerPort', 'integer', iptr);
    RegisterProperty('ClientPortMin', 'Integer', iptrw);
    RegisterProperty('ClientPortMax', 'Integer', iptrw);
    RegisterProperty('IP', 'string', iptrw);
    RegisterProperty('Port', 'integer', iptrw);

  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TIdIOHandler(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TIdComponent', 'TIdIOHandler') do
  with CL.AddClassN(CL.FindClass('TIdComponent'),'TIdIOHandler') do begin
    RegisterMethod('Procedure AfterAccept');
    RegisterMethod('Procedure Close');
    RegisterMethod('Procedure ConnectClient( const AHost : string; const APort : Integer; const ABoundIP : string; const ABoundPort : Integer; const ABoundPortMin : Integer; const ABoundPortMax : Integer; const ATimeout : Integer)');
    RegisterMethod('Function Connected : Boolean');
    RegisterMethod('Procedure Open');
    RegisterMethod('Function Readable( AMSec : Integer) : Boolean');
    RegisterMethod('Function Recv( var ABuf, ALen : Integer) : Integer');
    RegisterMethod('Function Send( var ABuf, ALen : Integer) : Integer');
    RegisterProperty('Active', 'Boolean', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_IdIOHandlerSocket(CL: TPSPascalCompiler);
begin
  SIRegister_TIdIOHandler(CL);
  SIRegister_TIdIOHandlerSocket(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TIdIOHandlerSocketUseNagle_W(Self: TIdIOHandlerSocket; const T: boolean);
begin Self.UseNagle := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdIOHandlerSocketUseNagle_R(Self: TIdIOHandlerSocket; var T: boolean);
begin T := Self.UseNagle; end;

(*----------------------------------------------------------------------------*)
procedure TIdIOHandlerSocketSocksInfo_W(Self: TIdIOHandlerSocket; const T: TIdSocksInfo);
begin Self.SocksInfo := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdIOHandlerSocketSocksInfo_R(Self: TIdIOHandlerSocket; var T: TIdSocksInfo);
begin T := Self.SocksInfo; end;

(*----------------------------------------------------------------------------*)
procedure TIdIOHandlerSocketBinding_R(Self: TIdIOHandlerSocket; var T: TIdSocketHandle);
begin T := Self.Binding; end;

(*
procedure TIdIOHandlerSocketPeerIp_R(Self: TIdIOHandlerSocket; var T: string);
begin T := Self.peerIP; end;
procedure TIdIOHandlerSocketPeerPort_R(Self: TIdIOHandlerSocket; var T: integer);
begin T := Self.peerport; end;
procedure TIdIOHandlerSocketBinding_R(Self: TIdIOHandlerSocket; var T: TIdSocketHandle);
begin T := Self.Binding; end;
procedure TIdIOHandlerSocketBinding_R(Self: TIdIOHandlerSocket; var T: TIdSocketHandle);
begin T := Self.Binding; end;*)




(*----------------------------------------------------------------------------*)
procedure TIdIOHandlerActive_R(Self: TIdIOHandler; var T: Boolean);
begin T := Self.Active; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TIdIOHandlerSocket(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TIdIOHandlerSocket) do begin
    RegisterMethod(@TIdIOHandlerSocket.Close, 'Close');
    RegisterMethod(@TIdIOHandlerSocket.ConnectClient, 'ConnectClient');
    RegisterMethod(@TIdIOHandlerSocket.Connected, 'Connected');
    RegisterConstructor(@TIdIOHandlerSocket.Create, 'Create');
    RegisterMethod(@TIdIOHandlerSocket.Open, 'Open');
    RegisterMethod(@TIdIOHandlerSocket.Readable, 'Readable');
    RegisterMethod(@TIdIOHandlerSocket.Recv, 'Recv');
    RegisterMethod(@TIdIOHandlerSocket.Send, 'Send');
    RegisterPropertyHelper(@TIdIOHandlerSocketBinding_R,nil,'Binding');
    RegisterPropertyHelper(@TIdIOHandlerSocketSocksInfo_R,@TIdIOHandlerSocketSocksInfo_W,'SocksInfo');
    RegisterPropertyHelper(@TIdIOHandlerSocketUseNagle_R,@TIdIOHandlerSocketUseNagle_W,'UseNagle');
    //RegisterPropertyHelper(@TIdIOHandlerSocketPeerIP_R,nil,'PeerIp');
    //RegisterPropertyHelper(@TIdIOHandlerSocketPeerPort_R,nil,'PeerPort');
    //RegisterPropertyHelper(@TIdIOHandlerSocketIP_R,nil,'Ip');
    //RegisterPropertyHelper(@TIdIOHandlerSocketPort_R,nil,'Port');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TIdIOHandler(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TIdIOHandler) do begin
    RegisterVirtualMethod(@TIdIOHandler.AfterAccept, 'AfterAccept');
    RegisterVirtualMethod(@TIdIOHandler.Close, 'Close');
    RegisterVirtualMethod(@TIdIOHandler.ConnectClient, 'ConnectClient');
    RegisterVirtualMethod(@TIdIOHandler.Connected, 'Connected');
    RegisterVirtualMethod(@TIdIOHandler.Open, 'Open');
    //RegisterVirtualAbstractMethod(@TIdIOHandler, @!.Readable, 'Readable');
    //RegisterVirtualAbstractMethod(@TIdIOHandler, @!.Recv, 'Recv');
    //RegisterVirtualAbstractMethod(@TIdIOHandler, @!.Send, 'Send');
    RegisterPropertyHelper(@TIdIOHandlerActive_R,nil,'Active');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_IdIOHandlerSocket(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TIdIOHandler(CL);
  RIRegister_TIdIOHandlerSocket(CL);
end;

 
 
{ TPSImport_IdIOHandlerSocket }
(*----------------------------------------------------------------------------*)
procedure TPSImport_IdIOHandlerSocket.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_IdIOHandlerSocket(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_IdIOHandlerSocket.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_IdIOHandlerSocket(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
