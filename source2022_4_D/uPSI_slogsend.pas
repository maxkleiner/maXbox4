unit uPSI_slogsend;
{
   synapse syslog
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
  TPSImport_slogsend = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TSyslogSend(CL: TPSPascalCompiler);
procedure SIRegister_TSyslogMessage(CL: TPSPascalCompiler);
procedure SIRegister_slogsend(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_slogsend_Routines(S: TPSExec);
procedure RIRegister_TSyslogSend(CL: TPSRuntimeClassImporter);
procedure RIRegister_TSyslogMessage(CL: TPSRuntimeClassImporter);
procedure RIRegister_slogsend(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   blcksock
  ,synautil
  ,slogsend
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_slogsend]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TSyslogSend(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TSynaClient', 'TSyslogSend') do
  with CL.AddClassN(CL.FindClass('TSynaClient'),'TSyslogSend') do begin
    RegisterMethod('Constructor Create');
      RegisterMethod('Procedure Free');
      RegisterMethod('Function DoIt : Boolean');
    RegisterProperty('SysLogMessage', 'TSysLogMessage', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TSyslogMessage(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TObject', 'TSyslogMessage') do
  with CL.AddClassN(CL.FindClass('TObject'),'TSyslogMessage') do begin
    RegisterMethod('Procedure Clear');
     RegisterMethod('Procedure Free');
      RegisterProperty('Facility', 'Byte', iptrw);
    RegisterProperty('Severity', 'TSyslogSeverity', iptrw);
    RegisterProperty('DateTime', 'TDateTime', iptrw);
    RegisterProperty('Tag', 'String', iptrw);
    RegisterProperty('LogMessage', 'String', iptrw);
    RegisterProperty('LocalIP', 'String', iptrw);
    RegisterProperty('PacketBuf', 'String', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_slogsend(CL: TPSPascalCompiler);
begin
 CL.AddConstantN('cSysLogProtocol','String').SetString( '514');
 CL.AddConstantN('FCL_Kernel','LongInt').SetInt( 0);
 CL.AddConstantN('FCL_UserLevel','LongInt').SetInt( 1);
 CL.AddConstantN('FCL_MailSystem','LongInt').SetInt( 2);
 CL.AddConstantN('FCL_System','LongInt').SetInt( 3);
 CL.AddConstantN('FCL_Security','LongInt').SetInt( 4);
 CL.AddConstantN('FCL_Syslogd','LongInt').SetInt( 5);
 CL.AddConstantN('FCL_Printer','LongInt').SetInt( 6);
 CL.AddConstantN('FCL_News','LongInt').SetInt( 7);
 CL.AddConstantN('FCL_UUCP','LongInt').SetInt( 8);
 CL.AddConstantN('FCL_Clock','LongInt').SetInt( 9);
 CL.AddConstantN('FCL_Authorization','LongInt').SetInt( 10);
 CL.AddConstantN('FCL_FTP','LongInt').SetInt( 11);
 CL.AddConstantN('FCL_NTP','LongInt').SetInt( 12);
 CL.AddConstantN('FCL_LogAudit','LongInt').SetInt( 13);
 CL.AddConstantN('FCL_LogAlert','LongInt').SetInt( 14);
 CL.AddConstantN('FCL_Time','LongInt').SetInt( 15);
 CL.AddConstantN('FCL_Local0','LongInt').SetInt( 16);
 CL.AddConstantN('FCL_Local1','LongInt').SetInt( 17);
 CL.AddConstantN('FCL_Local2','LongInt').SetInt( 18);
 CL.AddConstantN('FCL_Local3','LongInt').SetInt( 19);
 CL.AddConstantN('FCL_Local4','LongInt').SetInt( 20);
 CL.AddConstantN('FCL_Local5','LongInt').SetInt( 21);
 CL.AddConstantN('FCL_Local6','LongInt').SetInt( 22);
 CL.AddConstantN('FCL_Local7','LongInt').SetInt( 23);
  CL.AddTypeS('TSyslogSeverity', '( asEmergency, asAlert, asCritical, asError, asWarning,'
   +' asNotice, asInfo, asDebug )');
  SIRegister_TSyslogMessage(CL);
  SIRegister_TSyslogSend(CL);
 CL.AddDelphiFunction('Function ToSysLog( const SyslogServer : string; Facil : Byte; Sever : TSyslogSeverity; const Content : string) : Boolean');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TSyslogSendSysLogMessage_W(Self: TSyslogSend; const T: TSysLogMessage);
begin Self.SysLogMessage := T; end;

(*----------------------------------------------------------------------------*)
procedure TSyslogSendSysLogMessage_R(Self: TSyslogSend; var T: TSysLogMessage);
begin T := Self.SysLogMessage; end;

(*----------------------------------------------------------------------------*)
procedure TSyslogMessagePacketBuf_W(Self: TSyslogMessage; const T: String);
begin Self.PacketBuf := T; end;

(*----------------------------------------------------------------------------*)
procedure TSyslogMessagePacketBuf_R(Self: TSyslogMessage; var T: String);
begin T := Self.PacketBuf; end;

(*----------------------------------------------------------------------------*)
procedure TSyslogMessageLocalIP_W(Self: TSyslogMessage; const T: String);
begin Self.LocalIP := T; end;

(*----------------------------------------------------------------------------*)
procedure TSyslogMessageLocalIP_R(Self: TSyslogMessage; var T: String);
begin T := Self.LocalIP; end;

(*----------------------------------------------------------------------------*)
procedure TSyslogMessageLogMessage_W(Self: TSyslogMessage; const T: String);
begin Self.LogMessage := T; end;

(*----------------------------------------------------------------------------*)
procedure TSyslogMessageLogMessage_R(Self: TSyslogMessage; var T: String);
begin T := Self.LogMessage; end;

(*----------------------------------------------------------------------------*)
procedure TSyslogMessageTag_W(Self: TSyslogMessage; const T: String);
begin Self.Tag := T; end;

(*----------------------------------------------------------------------------*)
procedure TSyslogMessageTag_R(Self: TSyslogMessage; var T: String);
begin T := Self.Tag; end;

(*----------------------------------------------------------------------------*)
procedure TSyslogMessageDateTime_W(Self: TSyslogMessage; const T: TDateTime);
begin Self.DateTime := T; end;

(*----------------------------------------------------------------------------*)
procedure TSyslogMessageDateTime_R(Self: TSyslogMessage; var T: TDateTime);
begin T := Self.DateTime; end;

(*----------------------------------------------------------------------------*)
procedure TSyslogMessageSeverity_W(Self: TSyslogMessage; const T: TSyslogSeverity);
begin Self.Severity := T; end;

(*----------------------------------------------------------------------------*)
procedure TSyslogMessageSeverity_R(Self: TSyslogMessage; var T: TSyslogSeverity);
begin T := Self.Severity; end;

(*----------------------------------------------------------------------------*)
procedure TSyslogMessageFacility_W(Self: TSyslogMessage; const T: Byte);
begin Self.Facility := T; end;

(*----------------------------------------------------------------------------*)
procedure TSyslogMessageFacility_R(Self: TSyslogMessage; var T: Byte);
begin T := Self.Facility; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_slogsend_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@ToSysLog, 'ToSysLog', cdRegister);
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TSyslogSend(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TSyslogSend) do begin
    RegisterConstructor(@TSyslogSend.Create, 'Create');
      RegisterMethod(@TSyslogSend.Destroy, 'Free');
      RegisterMethod(@TSyslogSend.DoIt, 'DoIt');
    RegisterPropertyHelper(@TSyslogSendSysLogMessage_R,@TSyslogSendSysLogMessage_W,'SysLogMessage');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TSyslogMessage(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TSyslogMessage) do begin
    RegisterMethod(@TSyslogMessage.Clear, 'Clear');
      RegisterMethod(@TSyslogMessage.Destroy, 'Free');
     RegisterPropertyHelper(@TSyslogMessageFacility_R,@TSyslogMessageFacility_W,'Facility');
    RegisterPropertyHelper(@TSyslogMessageSeverity_R,@TSyslogMessageSeverity_W,'Severity');
    RegisterPropertyHelper(@TSyslogMessageDateTime_R,@TSyslogMessageDateTime_W,'DateTime');
    RegisterPropertyHelper(@TSyslogMessageTag_R,@TSyslogMessageTag_W,'Tag');
    RegisterPropertyHelper(@TSyslogMessageLogMessage_R,@TSyslogMessageLogMessage_W,'LogMessage');
    RegisterPropertyHelper(@TSyslogMessageLocalIP_R,@TSyslogMessageLocalIP_W,'LocalIP');
    RegisterPropertyHelper(@TSyslogMessagePacketBuf_R,@TSyslogMessagePacketBuf_W,'PacketBuf');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_slogsend(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TSyslogMessage(CL);
  RIRegister_TSyslogSend(CL);
end;

 
 
{ TPSImport_slogsend }
(*----------------------------------------------------------------------------*)
procedure TPSImport_slogsend.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_slogsend(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_slogsend.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_slogsend(ri);
  RIRegister_slogsend_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
