unit uPSI_IdUDPClient;
{
  for FTP  sendbuffer 3.99.96
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
  TPSImport_IdUDPClient = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TIdUDPClient(CL: TPSPascalCompiler);
procedure SIRegister_IdUDPClient(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TIdUDPClient(CL: TPSRuntimeClassImporter);
procedure RIRegister_IdUDPClient(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   IdUDPBase
  ,IdUDPClient
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_IdUDPClient]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TIdUDPClient(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TIdUDPBase', 'TIdUDPClient') do
  with CL.AddClassN(CL.FindClass('TIdUDPBase'),'TIdUDPClient') do begin
    RegisterMethod('Procedure Send( AData : string);');
    RegisterMethod('procedure SendBuffer(var ABuffer: string; const AByteCount: integer);');
    RegisterMethod('procedure SendBufferAB(var ABuffer: array of Byte; const AByteCount: integer);');
   //     procedure SendBuffer(var ABuffer; const AByteCount: integer); overload;
    RegisterProperty('Host', 'string', iptrw);
    RegisterProperty('Port', 'Integer', iptrw);
    RegisterPublishedProperties;
    RegisterProperty('ReceiveTimeout', 'Integer', iptrw);
 end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_IdUDPClient(CL: TPSPascalCompiler);
begin
  SIRegister_TIdUDPClient(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TIdUDPClientPort_W(Self: TIdUDPClient; const T: Integer);
begin Self.Port := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdUDPClientPort_R(Self: TIdUDPClient; var T: Integer);
begin T := Self.Port; end;

(*----------------------------------------------------------------------------*)
procedure TIdUDPClientHost_W(Self: TIdUDPClient; const T: string);
begin Self.Host := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdUDPClientHost_R(Self: TIdUDPClient; var T: string);
begin T := Self.Host; end;

(*----------------------------------------------------------------------------*)
Procedure TIdUDPClientSend_P(Self: TIdUDPClient;  AData : string);
Begin Self.Send(AData); END;

Procedure TIdUDPClientSendBufferAB(Self: TIdUDPClient;  var AData: array of byte; const AByteCount: integer);
//Procedure TIdUDPClientSendBufferAB(Self: TIdUDPBase;  var AData: array of byte; const AByteCount: integer);
Begin
    Self.SendBuffer(AData, AByteCount);
    //Self.SendBuffer(self.Host, self.Port,AData);
 END;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TIdUDPClient(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TIdUDPClient) do begin
    RegisterMethod(@TIdUDPClientSend_P, 'Send');
    RegisterMethod(@TIdUDPClient.sendBuffer, 'SendbUFFER');
    RegisterMethod(@TIdUDPClientsendBufferAB, 'SendBufferAB');
    //RegisterMethod(@TIdUDPClient.sendBuffer, 'SendBufferAB');

    RegisterPropertyHelper(@TIdUDPClientHost_R,@TIdUDPClientHost_W,'Host');
    RegisterPropertyHelper(@TIdUDPClientPort_R,@TIdUDPClientPort_W,'Port');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_IdUDPClient(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TIdUDPClient(CL);
end;

 
 
{ TPSImport_IdUDPClient }
(*----------------------------------------------------------------------------*)
procedure TPSImport_IdUDPClient.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_IdUDPClient(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_IdUDPClient.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_IdUDPClient(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
