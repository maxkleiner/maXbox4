unit uPSI_IndySockTransport;
{
    mX4
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
  TPSImport_IndySockTransport = class(TPSPlugin)
  public
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TIndyTCPClientTransport(CL: TPSPascalCompiler);
procedure SIRegister_TIndyTCPConnectionTransport(CL: TPSPascalCompiler);
procedure SIRegister_IndySockTransport(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TIndyTCPClientTransport(CL: TPSRuntimeClassImporter);
procedure RIRegister_TIndyTCPConnectionTransport(CL: TPSRuntimeClassImporter);
procedure RIRegister_IndySockTransport(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   IdTCPClient
  ,idTCPConnection
  ,SockTransport
  ,IndySockTransport
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_IndySockTransport]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TIndyTCPClientTransport(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TIndyTCPConnectionTransport', 'TIndyTCPClientTransport') do
  with CL.AddClassN(CL.FindClass('TIndyTCPConnectionTransport'),'TIndyTCPClientTransport') do begin
    RegisterMethod('Constructor Create');
   RegisterMethod('Procedure Free');
    RegisterProperty('Host', 'string', iptrw);
    RegisterProperty('Port', 'Integer', iptrw);
    RegisterProperty('Socket', 'TIdTCPClient', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TIndyTCPConnectionTransport(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TInterfacedObject', 'TIndyTCPConnectionTransport') do
  with CL.AddClassN(CL.FindClass('TInterfacedObject'),'TIndyTCPConnectionTransport') do begin
    RegisterMethod('Constructor Create( AConnection : TIdTCPConnection)');
    RegisterMethod('Procedure Free');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_IndySockTransport(CL: TPSPascalCompiler);
begin
  SIRegister_TIndyTCPConnectionTransport(CL);
  SIRegister_TIndyTCPClientTransport(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TIndyTCPClientTransportSocket_W(Self: TIndyTCPClientTransport; const T: TIdTCPClient);
begin Self.Socket := T; end;

(*----------------------------------------------------------------------------*)
procedure TIndyTCPClientTransportSocket_R(Self: TIndyTCPClientTransport; var T: TIdTCPClient);
begin T := Self.Socket; end;

(*----------------------------------------------------------------------------*)
procedure TIndyTCPClientTransportPort_W(Self: TIndyTCPClientTransport; const T: Integer);
begin Self.Port := T; end;

(*----------------------------------------------------------------------------*)
procedure TIndyTCPClientTransportPort_R(Self: TIndyTCPClientTransport; var T: Integer);
begin T := Self.Port; end;

(*----------------------------------------------------------------------------*)
procedure TIndyTCPClientTransportHost_W(Self: TIndyTCPClientTransport; const T: string);
begin Self.Host := T; end;

(*----------------------------------------------------------------------------*)
procedure TIndyTCPClientTransportHost_R(Self: TIndyTCPClientTransport; var T: string);
begin T := Self.Host; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TIndyTCPClientTransport(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TIndyTCPClientTransport) do begin
    RegisterConstructor(@TIndyTCPClientTransport.Create, 'Create');
      RegisterMethod(@TIndyTCPClientTransport.Destroy, 'Free');
       RegisterPropertyHelper(@TIndyTCPClientTransportHost_R,@TIndyTCPClientTransportHost_W,'Host');
    RegisterPropertyHelper(@TIndyTCPClientTransportPort_R,@TIndyTCPClientTransportPort_W,'Port');
    RegisterPropertyHelper(@TIndyTCPClientTransportSocket_R,@TIndyTCPClientTransportSocket_W,'Socket');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TIndyTCPConnectionTransport(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TIndyTCPConnectionTransport) do begin
    RegisterConstructor(@TIndyTCPConnectionTransport.Create, 'Create');
      RegisterMethod(@TIndyTCPConnectionTransport.Destroy, 'Free');
    end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_IndySockTransport(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TIndyTCPConnectionTransport(CL);
  RIRegister_TIndyTCPClientTransport(CL);
end;

 
 
{ TPSImport_IndySockTransport }
(*----------------------------------------------------------------------------*)
procedure TPSImport_IndySockTransport.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_IndySockTransport(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_IndySockTransport.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_IndySockTransport(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
