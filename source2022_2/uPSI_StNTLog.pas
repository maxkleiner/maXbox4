unit uPSI_StNTLog;
{
  admin
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
  TPSImport_StNTLog = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TStNTEventLog(CL: TPSPascalCompiler);
procedure SIRegister_StNTLog(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TStNTEventLog(CL: TPSRuntimeClassImporter);
procedure RIRegister_StNTLog(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   Windows
  ,Registry
  ,StBase
  ,StNTLog
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_StNTLog]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TStNTEventLog(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TStComponent', 'TStNTEventLog') do
  with CL.AddClassN(CL.FindClass('TStComponent'),'TStNTEventLog') do begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
    RegisterMethod('Procedure Free');
    RegisterMethod('Procedure AddEntry( const EventType : TStNTEventType; EventCategory, EventID : DWORD)');
    RegisterMethod('Procedure AddEntryEx( const EventType : TStNTEventType; EventCategory, EventID : DWORD; const Strings : TStrings; DataPtr : pointer; DataSize : DWORD)');
    RegisterMethod('Procedure ClearLog( const BackupName : TFileName)');
    RegisterMethod('Procedure CreateBackup( const BackupName : TFileName)');
    RegisterMethod('Procedure ReadLog( const Reverse : Boolean)');
    RegisterMethod('Procedure RefreshLogList');
    RegisterProperty('LogCount', 'DWORD', iptr);
    RegisterProperty('Logs', 'string Integer', iptr);
    RegisterProperty('RecordCount', 'DWORD', iptr);
    RegisterProperty('ComputerName', 'string', iptrw);
    RegisterProperty('Enabled', 'Boolean', iptrw);
    RegisterProperty('EventSource', 'string', iptrw);
    RegisterProperty('LogName', 'string', iptrw);
    RegisterProperty('OnReadRecord', 'TStReadRecordEvent', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_StNTLog(CL: TPSPascalCompiler);
begin
  CL.AddTypeS('TStNTEventType', '( etSuccess, etError, etWarning, etInfo, etAud'
   +'itSuccess, etAuditFailure )');
  //CL.AddTypeS('PStNTEventLogRec', '^TStNTEventLogRec // will not work');
  CL.AddTypeS('TStNTEventLogRec', 'record Length : DWORD; Reserved : DWORD; Rec'
   +'ordNumber : DWORD; TimeGenerated : DWORD; TimeWritten : DWORD; EventID : D'
   +'WORD; EventType : WORD; NumStrings : WORD; EventCategory : WORD; ReservedF'
   +'lags : WORD; ClosingRecordNumber : DWORD; StringOffset : DWORD; UserSidLen'
   +'gth : DWORD; UserSidOffset : DWORD; DataLength : DWORD; DataOffset : DWORD; end');
  CL.AddTypeS('TStReadRecordEvent', 'Procedure ( Sender : TObject; const EventR'
   +'ec : TStNTEventLogRec; var Abort : Boolean)');
  SIRegister_TStNTEventLog(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TStNTEventLogOnReadRecord_W(Self: TStNTEventLog; const T: TStReadRecordEvent);
begin Self.OnReadRecord := T; end;

(*----------------------------------------------------------------------------*)
procedure TStNTEventLogOnReadRecord_R(Self: TStNTEventLog; var T: TStReadRecordEvent);
begin T := Self.OnReadRecord; end;

(*----------------------------------------------------------------------------*)
procedure TStNTEventLogLogName_W(Self: TStNTEventLog; const T: string);
begin Self.LogName := T; end;

(*----------------------------------------------------------------------------*)
procedure TStNTEventLogLogName_R(Self: TStNTEventLog; var T: string);
begin T := Self.LogName; end;

(*----------------------------------------------------------------------------*)
procedure TStNTEventLogEventSource_W(Self: TStNTEventLog; const T: string);
begin Self.EventSource := T; end;

(*----------------------------------------------------------------------------*)
procedure TStNTEventLogEventSource_R(Self: TStNTEventLog; var T: string);
begin T := Self.EventSource; end;

(*----------------------------------------------------------------------------*)
procedure TStNTEventLogEnabled_W(Self: TStNTEventLog; const T: Boolean);
begin Self.Enabled := T; end;

(*----------------------------------------------------------------------------*)
procedure TStNTEventLogEnabled_R(Self: TStNTEventLog; var T: Boolean);
begin T := Self.Enabled; end;

(*----------------------------------------------------------------------------*)
procedure TStNTEventLogComputerName_W(Self: TStNTEventLog; const T: string);
begin Self.ComputerName := T; end;

(*----------------------------------------------------------------------------*)
procedure TStNTEventLogComputerName_R(Self: TStNTEventLog; var T: string);
begin T := Self.ComputerName; end;

(*----------------------------------------------------------------------------*)
procedure TStNTEventLogRecordCount_R(Self: TStNTEventLog; var T: DWORD);
begin T := Self.RecordCount; end;

(*----------------------------------------------------------------------------*)
procedure TStNTEventLogLogs_R(Self: TStNTEventLog; var T: string; const t1: Integer);
begin T := Self.Logs[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TStNTEventLogLogCount_R(Self: TStNTEventLog; var T: DWORD);
begin T := Self.LogCount; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TStNTEventLog(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TStNTEventLog) do begin
    RegisterConstructor(@TStNTEventLog.Create, 'Create');
    RegisterMethod(@TStNTEventLog.Destroy, 'Free');
    RegisterMethod(@TStNTEventLog.AddEntry, 'AddEntry');
    RegisterMethod(@TStNTEventLog.AddEntryEx, 'AddEntryEx');
    RegisterMethod(@TStNTEventLog.ClearLog, 'ClearLog');
    RegisterMethod(@TStNTEventLog.CreateBackup, 'CreateBackup');
    RegisterMethod(@TStNTEventLog.ReadLog, 'ReadLog');
    RegisterMethod(@TStNTEventLog.RefreshLogList, 'RefreshLogList');
    RegisterPropertyHelper(@TStNTEventLogLogCount_R,nil,'LogCount');
    RegisterPropertyHelper(@TStNTEventLogLogs_R,nil,'Logs');
    RegisterPropertyHelper(@TStNTEventLogRecordCount_R,nil,'RecordCount');
    RegisterPropertyHelper(@TStNTEventLogComputerName_R,@TStNTEventLogComputerName_W,'ComputerName');
    RegisterPropertyHelper(@TStNTEventLogEnabled_R,@TStNTEventLogEnabled_W,'Enabled');
    RegisterPropertyHelper(@TStNTEventLogEventSource_R,@TStNTEventLogEventSource_W,'EventSource');
    RegisterPropertyHelper(@TStNTEventLogLogName_R,@TStNTEventLogLogName_W,'LogName');
    RegisterPropertyHelper(@TStNTEventLogOnReadRecord_R,@TStNTEventLogOnReadRecord_W,'OnReadRecord');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_StNTLog(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TStNTEventLog(CL);
end;

 
 
{ TPSImport_StNTLog }
(*----------------------------------------------------------------------------*)
procedure TPSImport_StNTLog.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_StNTLog(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_StNTLog.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_StNTLog(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
