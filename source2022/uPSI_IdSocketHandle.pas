unit uPSI_IdSocketHandle;
{
    top of with assign
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
  TPSImport_IdSocketHandle = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TIdSocketHandle(CL: TPSPascalCompiler);
procedure SIRegister_TIdSocketHandles(CL: TPSPascalCompiler);
procedure SIRegister_IdSocketHandle(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TIdSocketHandle(CL: TPSRuntimeClassImporter);
procedure RIRegister_TIdSocketHandles(CL: TPSRuntimeClassImporter);
procedure RIRegister_IdSocketHandle(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   IdException
  ,IdGlobal
  ,IdStack
  ,IdStackConsts
  ,IdSocketHandle
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_IdSocketHandle]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TIdSocketHandle(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TCollectionItem', 'TIdSocketHandle') do
  with CL.AddClassN(CL.FindClass('TCollectionItem'),'TIdSocketHandle') do begin
    RegisterPublishedProperties;
    RegisterMethod('Function Accept( ASocket : TIdStackSocketHandle) : boolean');
    RegisterMethod('Procedure AllocateSocket( const ASocketType : Integer; const AProtocol : Integer)');
    RegisterMethod('Procedure Bind');
    RegisterMethod('Procedure CloseSocket( const AResetLocal : boolean)');
    RegisterMethod('Function Connect( const AFamily : Integer) : Integer');
    RegisterMethod('Constructor Create( ACollection : TCollection)');
    RegisterMethod('procedure Assign(Source: TPersistent)');
    RegisterMethod('Procedure GetSockOpt( level, optname : Integer; optval : PChar; optlen : Integer)');
    RegisterMethod('Procedure Listen( const anQueueCount : integer)');
    RegisterMethod('Function Readable( AMSec : Integer) : boolean');
    RegisterMethod('Function Recv( var ABuf, ALen, AFlags : Integer) : Integer');
    RegisterMethod('Procedure Reset( const AResetLocal : boolean)');
    RegisterMethod('Function Send( var Buf, len, flags : Integer) : Integer');
    RegisterMethod('Procedure SetPeer( const asIP : string; anPort : integer)');
    RegisterMethod('Procedure SetSockOpt( level, optname : Integer; optval : PChar; optlen : Integer)');
    RegisterMethod('Function Select( ASocket : TIdStackSocketHandle; ATimeOut : Integer) : boolean');
    RegisterMethod('Procedure UpdateBindingLocal');
    RegisterMethod('Procedure UpdateBindingPeer');
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
procedure SIRegister_TIdSocketHandles(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOwnedCollection', 'TIdSocketHandles') do
  with CL.AddClassN(CL.FindClass('TOwnedCollection'),'TIdSocketHandles') do begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
    RegisterMethod('Function Add : TIdSocketHandle');
    RegisterMethod('Function BindingByHandle( const AHandle : TIdStackSocketHandle) : TIdSocketHandle');
    RegisterProperty('Items', 'TIdSocketHandle Integer', iptrw);
    SetDefaultPropery('Items');
    RegisterProperty('DefaultPort', 'integer', iptrw);
    //SetDefaultPropery('Items');

  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_IdSocketHandle(CL: TPSPascalCompiler);
begin
  CL.AddClassN(CL.FindClass('TOBJECT'),'TIdSocketHandle');
  SIRegister_TIdSocketHandles(CL);
  SIRegister_TIdSocketHandle(CL);
  CL.AddClassN(CL.FindClass('TOBJECT'),'EIdSocketHandleError');
  CL.AddClassN(CL.FindClass('TOBJECT'),'EIdPackageSizeTooBig');
  CL.AddClassN(CL.FindClass('TOBJECT'),'EIdNotAllBytesSent');
  CL.AddClassN(CL.FindClass('TOBJECT'),'EIdCouldNotBindSocket');
  CL.AddClassN(CL.FindClass('TOBJECT'),'EIdCanNotBindPortInRange');
  CL.AddClassN(CL.FindClass('TOBJECT'),'EIdInvalidPortRange');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TIdSocketHandlePort_W(Self: TIdSocketHandle; const T: integer);
begin Self.Port := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdSocketHandlePort_R(Self: TIdSocketHandle; var T: integer);
begin T := Self.Port; end;

(*----------------------------------------------------------------------------*)
procedure TIdSocketHandleIP_W(Self: TIdSocketHandle; const T: string);
begin Self.IP := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdSocketHandleIP_R(Self: TIdSocketHandle; var T: string);
begin T := Self.IP; end;

(*----------------------------------------------------------------------------*)
procedure TIdSocketHandleClientPortMax_W(Self: TIdSocketHandle; const T: Integer);
begin Self.ClientPortMax := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdSocketHandleClientPortMax_R(Self: TIdSocketHandle; var T: Integer);
begin T := Self.ClientPortMax; end;

(*----------------------------------------------------------------------------*)
procedure TIdSocketHandleClientPortMin_W(Self: TIdSocketHandle; const T: Integer);
begin Self.ClientPortMin := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdSocketHandleClientPortMin_R(Self: TIdSocketHandle; var T: Integer);
begin T := Self.ClientPortMin; end;

(*----------------------------------------------------------------------------*)
procedure TIdSocketHandlePeerPort_R(Self: TIdSocketHandle; var T: integer);
begin T := Self.PeerPort; end;

(*----------------------------------------------------------------------------*)
procedure TIdSocketHandlePeerIP_R(Self: TIdSocketHandle; var T: string);
begin T := Self.PeerIP; end;

(*----------------------------------------------------------------------------*)
procedure TIdSocketHandleHandle_R(Self: TIdSocketHandle; var T: TIdStackSocketHandle);
begin T := Self.Handle; end;

(*----------------------------------------------------------------------------*)
procedure TIdSocketHandleHandleAllocated_R(Self: TIdSocketHandle; var T: Boolean);
begin T := Self.HandleAllocated; end;

(*----------------------------------------------------------------------------*)
procedure TIdSocketHandlesDefaultPort_W(Self: TIdSocketHandles; const T: integer);
begin Self.DefaultPort := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdSocketHandlesDefaultPort_R(Self: TIdSocketHandles; var T: integer);
begin T := Self.DefaultPort; end;

(*----------------------------------------------------------------------------*)
procedure TIdSocketHandlesItems_W(Self: TIdSocketHandles; const T: TIdSocketHandle; const t1: Integer);
begin Self.Items[t1] := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdSocketHandlesItems_R(Self: TIdSocketHandles; var T: TIdSocketHandle; const t1: Integer);
begin T := Self.Items[t1]; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TIdSocketHandle(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TIdSocketHandle) do begin
    RegisterMethod(@TIdSocketHandle.Accept, 'Accept');
    RegisterMethod(@TIdSocketHandle.AllocateSocket, 'AllocateSocket');
    RegisterMethod(@TIdSocketHandle.Bind, 'Bind');
    RegisterMethod(@TIdSocketHandle.Assign, 'Assign');
    RegisterVirtualMethod(@TIdSocketHandle.CloseSocket, 'CloseSocket');
    RegisterVirtualMethod(@TIdSocketHandle.Connect, 'Connect');
    RegisterConstructor(@TIdSocketHandle.Create, 'Create');
    RegisterMethod(@TIdSocketHandle.GetSockOpt, 'GetSockOpt');
    RegisterMethod(@TIdSocketHandle.Listen, 'Listen');
    RegisterMethod(@TIdSocketHandle.Readable, 'Readable');
    RegisterMethod(@TIdSocketHandle.Recv, 'Recv');
    RegisterMethod(@TIdSocketHandle.Reset, 'Reset');
    RegisterMethod(@TIdSocketHandle.Send, 'Send');
    RegisterMethod(@TIdSocketHandle.SetPeer, 'SetPeer');
    RegisterMethod(@TIdSocketHandle.SetSockOpt, 'SetSockOpt');
    RegisterMethod(@TIdSocketHandle.Select, 'Select');
    RegisterMethod(@TIdSocketHandle.UpdateBindingLocal, 'UpdateBindingLocal');
    RegisterMethod(@TIdSocketHandle.UpdateBindingPeer, 'UpdateBindingPeer');
    RegisterPropertyHelper(@TIdSocketHandleHandleAllocated_R,nil,'HandleAllocated');
    RegisterPropertyHelper(@TIdSocketHandleHandle_R,nil,'Handle');
    RegisterPropertyHelper(@TIdSocketHandlePeerIP_R,nil,'PeerIP');
    RegisterPropertyHelper(@TIdSocketHandlePeerPort_R,nil,'PeerPort');
    RegisterPropertyHelper(@TIdSocketHandleClientPortMin_R,@TIdSocketHandleClientPortMin_W,'ClientPortMin');
    RegisterPropertyHelper(@TIdSocketHandleClientPortMax_R,@TIdSocketHandleClientPortMax_W,'ClientPortMax');
    RegisterPropertyHelper(@TIdSocketHandleIP_R,@TIdSocketHandleIP_W,'IP');
    RegisterPropertyHelper(@TIdSocketHandlePort_R,@TIdSocketHandlePort_W,'Port');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TIdSocketHandles(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TIdSocketHandles) do
  begin
    RegisterConstructor(@TIdSocketHandles.Create, 'Create');
    RegisterMethod(@TIdSocketHandles.Add, 'Add');
    RegisterMethod(@TIdSocketHandles.BindingByHandle, 'BindingByHandle');
    RegisterPropertyHelper(@TIdSocketHandlesItems_R,@TIdSocketHandlesItems_W,'Items');
    RegisterPropertyHelper(@TIdSocketHandlesDefaultPort_R,@TIdSocketHandlesDefaultPort_W,'DefaultPort');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_IdSocketHandle(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TIdSocketHandle) do
  RIRegister_TIdSocketHandles(CL);
  RIRegister_TIdSocketHandle(CL);
  with CL.Add(EIdSocketHandleError) do
  with CL.Add(EIdPackageSizeTooBig) do
  with CL.Add(EIdNotAllBytesSent) do
  with CL.Add(EIdCouldNotBindSocket) do
  with CL.Add(EIdCanNotBindPortInRange) do
  with CL.Add(EIdInvalidPortRange) do
end;

 
 
{ TPSImport_IdSocketHandle }
(*----------------------------------------------------------------------------*)
procedure TPSImport_IdSocketHandle.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_IdSocketHandle(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_IdSocketHandle.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_IdSocketHandle(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
