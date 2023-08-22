unit uPSI_IdSysLogMessage;
{
  base class
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
  TPSImport_IdSysLogMessage = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TIdSysLogMessage(CL: TPSPascalCompiler);
procedure SIRegister_TIdSysLogMsgPart(CL: TPSPascalCompiler);
procedure SIRegister_IdSysLogMessage(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_IdSysLogMessage_Routines(S: TPSExec);
procedure RIRegister_TIdSysLogMessage(CL: TPSRuntimeClassImporter);
procedure RIRegister_TIdSysLogMsgPart(CL: TPSRuntimeClassImporter);
procedure RIRegister_IdSysLogMessage(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   IdGlobal
  ,IdBaseComponent
  ,IdSysLogMessage
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_IdSysLogMessage]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TIdSysLogMessage(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TIdBaseComponent', 'TIdSysLogMessage') do
  with CL.AddClassN(CL.FindClass('TIdBaseComponent'),'TIdSysLogMessage') do begin
    RegisterProperty('RawMessage', 'string', iptrw);
    RegisterMethod('Function EncodeMessage : String');
    RegisterMethod('Procedure ReadFromStream( Src : TStream; Size : integer; APeer : String)');
    RegisterMethod('Procedure assign( Source : TPersistent)');
    RegisterProperty('TimeStamp', 'TDateTime', iptrw);
    RegisterMethod('Constructor Create( AOwner : TComponent)');
    RegisterMethod('Procedure Free');
    RegisterMethod('Procedure SendToHost( const Dest : String)');
    RegisterProperty('Peer', 'String', iptrw);
    RegisterProperty('Pri', 'TIdSyslogPRI', iptrw);
    RegisterProperty('Facility', 'TidSyslogFacility', iptrw);
    RegisterProperty('Severity', 'TIdSyslogSeverity', iptrw);
    RegisterProperty('Hostname', 'string', iptrw);
    RegisterProperty('Msg', 'TIdSysLogMsgPart', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TIdSysLogMsgPart(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TPersistent', 'TIdSysLogMsgPart') do
  with CL.AddClassN(CL.FindClass('TPersistent'),'TIdSysLogMsgPart') do begin
    RegisterMethod('Procedure Assign( Source : Tpersistent)');
    RegisterProperty('Text', 'String', iptrw);
    RegisterProperty('PIDAvailable', 'Boolean', iptrw);
    RegisterProperty('Process', 'String', iptrw);
    RegisterProperty('PID', 'Integer', iptrw);
    RegisterProperty('Content', 'String', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_IdSysLogMessage(CL: TPSPascalCompiler);
begin
  CL.AddTypeS('TIdSyslogPRI', 'Integer');
  CL.AddTypeS('TIdSyslogFacility', '( sfKernel, sfUserLevel, sfMailSystem, sfSy'
   +'stemDaemon, sfSecurityOne, sfSysLogInternal, sfLPR, sfNNTP, sfUUCP, sfCloc'
   +'kDaemonOne, sfSecurityTwo, sfFTPDaemon, sfNTP, sfLogAudit, sfLogAlert, sfC'
   +'lockDaemonTwo, sfLocalUseZero, sfLocalUseOne, sfLocalUseTwo, sfLocalUseThr'
   +'ee, sfLocalUseFour, sfLocalUseFive, sfLocalUseSix, sfLocalUseSeven )');
  CL.AddTypeS('TIdSyslogSeverity', '( slEmergency, slAlert, slCritical, slError'
   +', slWarning, slNotice, slInformational, slDebug )');
  SIRegister_TIdSysLogMsgPart(CL);
  SIRegister_TIdSysLogMessage(CL);
 CL.AddDelphiFunction('Function FacilityToString( AFac : TIdSyslogFacility) : string');
 CL.AddDelphiFunction('Function SeverityToString( ASec : TIdsyslogSeverity) : string');
 CL.AddDelphiFunction('Function NoToSeverity( ASev : Word) : TIdSyslogSeverity');
 CL.AddDelphiFunction('Function logSeverityToNo( ASev : TIdSyslogSeverity) : Word');
 CL.AddDelphiFunction('Function NoToFacility( AFac : Word) : TIdSyslogFacility');
 CL.AddDelphiFunction('Function logFacilityToNo( AFac : TIdSyslogFacility) : Word');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TIdSysLogMessageMsg_W(Self: TIdSysLogMessage; const T: TIdSysLogMsgPart);
begin Self.Msg := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdSysLogMessageMsg_R(Self: TIdSysLogMessage; var T: TIdSysLogMsgPart);
begin T := Self.Msg; end;

(*----------------------------------------------------------------------------*)
procedure TIdSysLogMessageHostname_W(Self: TIdSysLogMessage; const T: string);
begin Self.Hostname := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdSysLogMessageHostname_R(Self: TIdSysLogMessage; var T: string);
begin T := Self.Hostname; end;

(*----------------------------------------------------------------------------*)
procedure TIdSysLogMessageSeverity_W(Self: TIdSysLogMessage; const T: TIdSyslogSeverity);
begin Self.Severity := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdSysLogMessageSeverity_R(Self: TIdSysLogMessage; var T: TIdSyslogSeverity);
begin T := Self.Severity; end;

(*----------------------------------------------------------------------------*)
procedure TIdSysLogMessageFacility_W(Self: TIdSysLogMessage; const T: TidSyslogFacility);
begin Self.Facility := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdSysLogMessageFacility_R(Self: TIdSysLogMessage; var T: TidSyslogFacility);
begin T := Self.Facility; end;

(*----------------------------------------------------------------------------*)
procedure TIdSysLogMessagePri_W(Self: TIdSysLogMessage; const T: TIdSyslogPRI);
begin Self.Pri := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdSysLogMessagePri_R(Self: TIdSysLogMessage; var T: TIdSyslogPRI);
begin T := Self.Pri; end;

(*----------------------------------------------------------------------------*)
procedure TIdSysLogMessagePeer_W(Self: TIdSysLogMessage; const T: String);
begin Self.Peer := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdSysLogMessagePeer_R(Self: TIdSysLogMessage; var T: String);
begin T := Self.Peer; end;

(*----------------------------------------------------------------------------*)
procedure TIdSysLogMessageTimeStamp_W(Self: TIdSysLogMessage; const T: TDateTime);
begin Self.TimeStamp := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdSysLogMessageTimeStamp_R(Self: TIdSysLogMessage; var T: TDateTime);
begin T := Self.TimeStamp; end;

(*----------------------------------------------------------------------------*)
procedure TIdSysLogMessageRawMessage_W(Self: TIdSysLogMessage; const T: string);
begin Self.RawMessage := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdSysLogMessageRawMessage_R(Self: TIdSysLogMessage; var T: string);
begin T := Self.RawMessage; end;

(*----------------------------------------------------------------------------*)
procedure TIdSysLogMsgPartContent_W(Self: TIdSysLogMsgPart; const T: String);
begin Self.Content := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdSysLogMsgPartContent_R(Self: TIdSysLogMsgPart; var T: String);
begin T := Self.Content; end;

(*----------------------------------------------------------------------------*)
procedure TIdSysLogMsgPartPID_W(Self: TIdSysLogMsgPart; const T: Integer);
begin Self.PID := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdSysLogMsgPartPID_R(Self: TIdSysLogMsgPart; var T: Integer);
begin T := Self.PID; end;

(*----------------------------------------------------------------------------*)
procedure TIdSysLogMsgPartProcess_W(Self: TIdSysLogMsgPart; const T: String);
begin Self.Process := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdSysLogMsgPartProcess_R(Self: TIdSysLogMsgPart; var T: String);
begin T := Self.Process; end;

(*----------------------------------------------------------------------------*)
procedure TIdSysLogMsgPartPIDAvailable_W(Self: TIdSysLogMsgPart; const T: Boolean);
begin Self.PIDAvailable := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdSysLogMsgPartPIDAvailable_R(Self: TIdSysLogMsgPart; var T: Boolean);
begin T := Self.PIDAvailable; end;

(*----------------------------------------------------------------------------*)
procedure TIdSysLogMsgPartText_W(Self: TIdSysLogMsgPart; const T: String);
begin Self.Text := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdSysLogMsgPartText_R(Self: TIdSysLogMsgPart; var T: String);
begin T := Self.Text; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_IdSysLogMessage_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@FacilityToString, 'FacilityToString', cdRegister);
 S.RegisterDelphiFunction(@SeverityToString, 'SeverityToString', cdRegister);
 S.RegisterDelphiFunction(@NoToSeverity, 'NoToSeverity', cdRegister);
 S.RegisterDelphiFunction(@logSeverityToNo, 'logSeverityToNo', cdRegister);
 S.RegisterDelphiFunction(@NoToFacility, 'NoToFacility', cdRegister);
 S.RegisterDelphiFunction(@logFacilityToNo, 'logFacilityToNo', cdRegister);
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TIdSysLogMessage(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TIdSysLogMessage) do
  begin
    RegisterPropertyHelper(@TIdSysLogMessageRawMessage_R,@TIdSysLogMessageRawMessage_W,'RawMessage');
    RegisterVirtualMethod(@TIdSysLogMessage.EncodeMessage, 'EncodeMessage');
    RegisterVirtualMethod(@TIdSysLogMessage.ReadFromStream, 'ReadFromStream');
    RegisterMethod(@TIdSysLogMessage.assign, 'assign');
    RegisterPropertyHelper(@TIdSysLogMessageTimeStamp_R,@TIdSysLogMessageTimeStamp_W,'TimeStamp');
    RegisterConstructor(@TIdSysLogMessage.Create, 'Create');
    RegisterMethod(@TIdSysLogMessage.SendToHost, 'SendToHost');
    RegisterPropertyHelper(@TIdSysLogMessagePeer_R,@TIdSysLogMessagePeer_W,'Peer');
    RegisterPropertyHelper(@TIdSysLogMessagePri_R,@TIdSysLogMessagePri_W,'Pri');
    RegisterPropertyHelper(@TIdSysLogMessageFacility_R,@TIdSysLogMessageFacility_W,'Facility');
    RegisterPropertyHelper(@TIdSysLogMessageSeverity_R,@TIdSysLogMessageSeverity_W,'Severity');
    RegisterPropertyHelper(@TIdSysLogMessageHostname_R,@TIdSysLogMessageHostname_W,'Hostname');
    RegisterPropertyHelper(@TIdSysLogMessageMsg_R,@TIdSysLogMessageMsg_W,'Msg');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TIdSysLogMsgPart(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TIdSysLogMsgPart) do
  begin
    RegisterMethod(@TIdSysLogMsgPart.Assign, 'Assign');
    RegisterPropertyHelper(@TIdSysLogMsgPartText_R,@TIdSysLogMsgPartText_W,'Text');
    RegisterPropertyHelper(@TIdSysLogMsgPartPIDAvailable_R,@TIdSysLogMsgPartPIDAvailable_W,'PIDAvailable');
    RegisterPropertyHelper(@TIdSysLogMsgPartProcess_R,@TIdSysLogMsgPartProcess_W,'Process');
    RegisterPropertyHelper(@TIdSysLogMsgPartPID_R,@TIdSysLogMsgPartPID_W,'PID');
    RegisterPropertyHelper(@TIdSysLogMsgPartContent_R,@TIdSysLogMsgPartContent_W,'Content');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_IdSysLogMessage(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TIdSysLogMsgPart(CL);
  RIRegister_TIdSysLogMessage(CL);
end;

 
 
{ TPSImport_IdSysLogMessage }
(*----------------------------------------------------------------------------*)
procedure TPSImport_IdSysLogMessage.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_IdSysLogMessage(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_IdSysLogMessage.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_IdSysLogMessage(ri);
  RIRegister_IdSysLogMessage_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
