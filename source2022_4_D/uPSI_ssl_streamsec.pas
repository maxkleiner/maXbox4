unit uPSI_ssl_streamsec;
{
   synapse ssl
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
  TPSImport_ssl_streamsec = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TSSLStreamSec(CL: TPSPascalCompiler);
procedure SIRegister_TMyTLSSynSockSlave(CL: TPSPascalCompiler);
procedure SIRegister_ssl_streamsec(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TSSLStreamSec(CL: TPSRuntimeClassImporter);
procedure RIRegister_TMyTLSSynSockSlave(CL: TPSRuntimeClassImporter);
procedure RIRegister_ssl_streamsec(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   blcksock
  ,synsock
  ,synautil
  ,synacode
  ,TlsInternalServer
  ,TlsSynaSock
  ,TlsConst
  ,StreamSecII
  ,Asn1
  ,X509Base
  ,SecUtils
  ,ssl_streamsec
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_ssl_streamsec]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TSSLStreamSec(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TCustomSSL', 'TSSLStreamSec') do
  with CL.AddClassN(CL.FindClass('TCustomSSL'),'TSSLStreamSec') do
  begin
    RegisterProperty('TLSServer', 'TCustomTLSInternalServer', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TMyTLSSynSockSlave(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TTLSSynSockSlave', 'TMyTLSSynSockSlave') do
  with CL.AddClassN(CL.FindClass('TTLSSynSockSlave'),'TMyTLSSynSockSlave') do
  begin
    RegisterProperty('MyTLSServer', 'TCustomTLSInternalServer', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_ssl_streamsec(CL: TPSPascalCompiler);
begin
  SIRegister_TMyTLSSynSockSlave(CL);
  SIRegister_TSSLStreamSec(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TSSLStreamSecTLSServer_W(Self: TSSLStreamSec; const T: TCustomTLSInternalServer);
begin Self.TLSServer := T; end;

(*----------------------------------------------------------------------------*)
procedure TSSLStreamSecTLSServer_R(Self: TSSLStreamSec; var T: TCustomTLSInternalServer);
begin T := Self.TLSServer; end;

(*----------------------------------------------------------------------------*)
procedure TMyTLSSynSockSlaveMyTLSServer_W(Self: TMyTLSSynSockSlave; const T: TCustomTLSInternalServer);
begin Self.MyTLSServer := T; end;

(*----------------------------------------------------------------------------*)
procedure TMyTLSSynSockSlaveMyTLSServer_R(Self: TMyTLSSynSockSlave; var T: TCustomTLSInternalServer);
begin T := Self.MyTLSServer; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TSSLStreamSec(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TSSLStreamSec) do
  begin
    RegisterPropertyHelper(@TSSLStreamSecTLSServer_R,@TSSLStreamSecTLSServer_W,'TLSServer');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TMyTLSSynSockSlave(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TMyTLSSynSockSlave) do
  begin
    RegisterPropertyHelper(@TMyTLSSynSockSlaveMyTLSServer_R,@TMyTLSSynSockSlaveMyTLSServer_W,'MyTLSServer');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_ssl_streamsec(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TMyTLSSynSockSlave(CL);
  RIRegister_TSSLStreamSec(CL);
end;

 
 
{ TPSImport_ssl_streamsec }
(*----------------------------------------------------------------------------*)
procedure TPSImport_ssl_streamsec.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_ssl_streamsec(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_ssl_streamsec.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_ssl_streamsec(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
