unit uPSI_pingsend;
{
   synapse tcp ping
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
  TPSImport_pingsend = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TPINGSend(CL: TPSPascalCompiler);
procedure SIRegister_pingsend(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_pingsend_Routines(S: TPSExec);
procedure RIRegister_TPINGSend(CL: TPSRuntimeClassImporter);
procedure RIRegister_pingsend(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   synsock
  ,blcksock
  ,synautil
  ,synafpc
  ,synaip
  ,windows
  ,pingsend
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_pingsend]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TPINGSend(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TSynaClient', 'TPINGSend') do
  with CL.AddClassN(CL.FindClass('TSynaClient'),'TPINGSend') do begin
    RegisterMethod('Function Ping( const Host : string) : Boolean');
    RegisterMethod('Constructor Create');
      RegisterMethod('Procedure Free');
      RegisterProperty('PacketSize', 'Integer', iptrw);
    RegisterProperty('PingTime', 'Integer', iptr);
    RegisterProperty('ReplyFrom', 'string', iptr);
    RegisterProperty('ReplyType', 'byte', iptr);
    RegisterProperty('ReplyCode', 'byte', iptr);
    RegisterProperty('ReplyError', 'TICMPError', iptr);
    RegisterProperty('ReplyErrorDesc', 'string', iptr);
    RegisterProperty('Sock', 'TICMPBlockSocket', iptr);
    RegisterProperty('TTL', 'byte', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_pingsend(CL: TPSPascalCompiler);
begin
 CL.AddConstantN('ICMP_ECHO','LongInt').SetInt( 8);
 CL.AddConstantN('ICMP_ECHOREPLY','LongInt').SetInt( 0);
 CL.AddConstantN('ICMP_UNREACH','LongInt').SetInt( 3);
 CL.AddConstantN('ICMP_TIME_EXCEEDED','LongInt').SetInt( 11);
 CL.AddConstantN('ICMP6_ECHO','LongInt').SetInt( 128);
 CL.AddConstantN('ICMP6_ECHOREPLY','LongInt').SetInt( 129);
 CL.AddConstantN('ICMP6_UNREACH','LongInt').SetInt( 1);
 CL.AddConstantN('ICMP6_TIME_EXCEEDED','LongInt').SetInt( 3);
  CL.AddTypeS('TICMPError', '( IE_NoError, IE_Other, IE_TTLExceed, IE_UnreachOt'
   +'her, IE_UnreachRoute, IE_UnreachAdmin, IE_UnreachAddr, IE_UnreachPort )');
  SIRegister_TPINGSend(CL);
 CL.AddDelphiFunction('Function PingHost( const Host : string) : Integer');
 CL.AddDelphiFunction('Function TraceRouteHost( const Host : string) : string');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TPINGSendTTL_W(Self: TPINGSend; const T: byte);
begin Self.TTL := T; end;

(*----------------------------------------------------------------------------*)
procedure TPINGSendTTL_R(Self: TPINGSend; var T: byte);
begin T := Self.TTL; end;

(*----------------------------------------------------------------------------*)
procedure TPINGSendSock_R(Self: TPINGSend; var T: TICMPBlockSocket);
begin T := Self.Sock; end;

(*----------------------------------------------------------------------------*)
procedure TPINGSendReplyErrorDesc_R(Self: TPINGSend; var T: string);
begin T := Self.ReplyErrorDesc; end;

(*----------------------------------------------------------------------------*)
procedure TPINGSendReplyError_R(Self: TPINGSend; var T: TICMPError);
begin T := Self.ReplyError; end;

(*----------------------------------------------------------------------------*)
procedure TPINGSendReplyCode_R(Self: TPINGSend; var T: byte);
begin T := Self.ReplyCode; end;

(*----------------------------------------------------------------------------*)
procedure TPINGSendReplyType_R(Self: TPINGSend; var T: byte);
begin T := Self.ReplyType; end;

(*----------------------------------------------------------------------------*)
procedure TPINGSendReplyFrom_R(Self: TPINGSend; var T: string);
begin T := Self.ReplyFrom; end;

(*----------------------------------------------------------------------------*)
procedure TPINGSendPingTime_R(Self: TPINGSend; var T: Integer);
begin T := Self.PingTime; end;

(*----------------------------------------------------------------------------*)
procedure TPINGSendPacketSize_W(Self: TPINGSend; const T: Integer);
begin Self.PacketSize := T; end;

(*----------------------------------------------------------------------------*)
procedure TPINGSendPacketSize_R(Self: TPINGSend; var T: Integer);
begin T := Self.PacketSize; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_pingsend_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@PingHost, 'PingHost', cdRegister);
 S.RegisterDelphiFunction(@TraceRouteHost, 'TraceRouteHost', cdRegister);
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TPINGSend(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TPINGSend) do begin
    RegisterMethod(@TPINGSend.Ping, 'Ping');
    RegisterConstructor(@TPINGSend.Create, 'Create');
    RegisterMethod(@TPINGSend.Destroy, 'Free');
    RegisterPropertyHelper(@TPINGSendPacketSize_R,@TPINGSendPacketSize_W,'PacketSize');
    RegisterPropertyHelper(@TPINGSendPingTime_R,nil,'PingTime');
    RegisterPropertyHelper(@TPINGSendReplyFrom_R,nil,'ReplyFrom');
    RegisterPropertyHelper(@TPINGSendReplyType_R,nil,'ReplyType');
    RegisterPropertyHelper(@TPINGSendReplyCode_R,nil,'ReplyCode');
    RegisterPropertyHelper(@TPINGSendReplyError_R,nil,'ReplyError');
    RegisterPropertyHelper(@TPINGSendReplyErrorDesc_R,nil,'ReplyErrorDesc');
    RegisterPropertyHelper(@TPINGSendSock_R,nil,'Sock');
    RegisterPropertyHelper(@TPINGSendTTL_R,@TPINGSendTTL_W,'TTL');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_pingsend(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TPINGSend(CL);
end;

 
 
{ TPSImport_pingsend }
(*----------------------------------------------------------------------------*)
procedure TPSImport_pingsend.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_pingsend(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_pingsend.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_pingsend(ri);
  RIRegister_pingsend_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
