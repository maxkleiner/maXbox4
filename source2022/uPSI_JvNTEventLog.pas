unit uPSI_JvNTEventLog;
{
   Good old NT (GON)
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
  TPSImport_JvNTEventLog = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TJvNTEventLogRecord(CL: TPSPascalCompiler);
procedure SIRegister_TNotifyChangeEventLog(CL: TPSPascalCompiler);
procedure SIRegister_TJvNTEventLog(CL: TPSPascalCompiler);
procedure SIRegister_JvNTEventLog(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TJvNTEventLogRecord(CL: TPSRuntimeClassImporter);
procedure RIRegister_TNotifyChangeEventLog(CL: TPSRuntimeClassImporter);
procedure RIRegister_TJvNTEventLog(CL: TPSRuntimeClassImporter);
procedure RIRegister_JvNTEventLog(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
  // JclUnitVersioning
  Windows
  ,JvComponentBase
  ,JvNTEventLog
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_JvNTEventLog]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TJvNTEventLogRecord(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TObject', 'TJvNTEventLogRecord') do
  with CL.AddClassN(CL.FindClass('TObject'),'TJvNTEventLogRecord') do begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
    RegisterMethod('Procedure Free');
     RegisterProperty('RecordNumber', 'Cardinal', iptr);
    RegisterProperty('DateTime', 'TDateTime', iptr);
    RegisterProperty('EventType', 'string', iptr);
    RegisterProperty('Category', 'Cardinal', iptr);
    RegisterProperty('Source', 'string', iptr);
    RegisterProperty('Computer', 'string', iptr);
    RegisterProperty('ID', 'DWORD', iptr);
    RegisterProperty('StringCount', 'DWORD', iptr);
    RegisterProperty('SID', 'PSID', iptr);
    RegisterProperty('EventString', 'string Cardinal', iptr);
    RegisterProperty('MessageText', 'string', iptr);
    RegisterProperty('UserName', 'string', iptr);
    RegisterProperty('Owner', 'TComponent', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TNotifyChangeEventLog(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TThread', 'TNotifyChangeEventLog') do
  with CL.AddClassN(CL.FindClass('TThread'),'TNotifyChangeEventLog') do
  begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TJvNTEventLog(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TJvComponent', 'TJvNTEventLog') do
  with CL.AddClassN(CL.FindClass('TJvComponent'),'TJvNTEventLog') do begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
    RegisterMethod('Procedure Free');
    RegisterMethod('Procedure Open');
    RegisterMethod('Procedure Close');
    RegisterMethod('Procedure First');
    RegisterMethod('Procedure Last');
    RegisterMethod('Function Eof : Boolean');
    RegisterMethod('Procedure Next');
    RegisterMethod('Procedure Seek( N : Cardinal)');
    RegisterMethod('Procedure ReadEventLogs( AStrings : TStrings)');
    RegisterProperty('EventCount', 'Cardinal', iptr);
    RegisterProperty('EventRecord', 'TJvNTEventLogRecord', iptr);
    RegisterProperty('Server', 'string', iptrw);
    RegisterProperty('Source', 'string', iptrw);
    RegisterProperty('Log', 'string', iptrw);
    RegisterProperty('Active', 'Boolean', iptrw);
    RegisterProperty('OnChange', 'TNotifyEvent', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_JvNTEventLog(CL: TPSPascalCompiler);
begin
  CL.AddClassN(CL.FindClass('TOBJECT'),'TNotifyChangeEventLog');
  CL.AddClassN(CL.FindClass('TOBJECT'),'TJvNTEventLogRecord');
  SIRegister_TJvNTEventLog(CL);
  SIRegister_TNotifyChangeEventLog(CL);
  SIRegister_TJvNTEventLogRecord(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TJvNTEventLogRecordOwner_R(Self: TJvNTEventLogRecord; var T: TComponent);
begin T := Self.Owner; end;

(*----------------------------------------------------------------------------*)
procedure TJvNTEventLogRecordUserName_R(Self: TJvNTEventLogRecord; var T: string);
begin T := Self.UserName; end;

(*----------------------------------------------------------------------------*)
procedure TJvNTEventLogRecordMessageText_R(Self: TJvNTEventLogRecord; var T: string);
begin T := Self.MessageText; end;

(*----------------------------------------------------------------------------*)
procedure TJvNTEventLogRecordEventString_R(Self: TJvNTEventLogRecord; var T: string; const t1: Cardinal);
begin T := Self.EventString[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TJvNTEventLogRecordSID_R(Self: TJvNTEventLogRecord; var T: PSID);
begin T := Self.SID; end;

(*----------------------------------------------------------------------------*)
procedure TJvNTEventLogRecordStringCount_R(Self: TJvNTEventLogRecord; var T: DWORD);
begin T := Self.StringCount; end;

(*----------------------------------------------------------------------------*)
procedure TJvNTEventLogRecordID_R(Self: TJvNTEventLogRecord; var T: DWORD);
begin T := Self.ID; end;

(*----------------------------------------------------------------------------*)
procedure TJvNTEventLogRecordComputer_R(Self: TJvNTEventLogRecord; var T: string);
begin T := Self.Computer; end;

(*----------------------------------------------------------------------------*)
procedure TJvNTEventLogRecordSource_R(Self: TJvNTEventLogRecord; var T: string);
begin T := Self.Source; end;

(*----------------------------------------------------------------------------*)
procedure TJvNTEventLogRecordCategory_R(Self: TJvNTEventLogRecord; var T: Cardinal);
begin T := Self.Category; end;

(*----------------------------------------------------------------------------*)
procedure TJvNTEventLogRecordEventType_R(Self: TJvNTEventLogRecord; var T: string);
begin T := Self.EventType; end;

(*----------------------------------------------------------------------------*)
procedure TJvNTEventLogRecordDateTime_R(Self: TJvNTEventLogRecord; var T: TDateTime);
begin T := Self.DateTime; end;

(*----------------------------------------------------------------------------*)
procedure TJvNTEventLogRecordRecordNumber_R(Self: TJvNTEventLogRecord; var T: Cardinal);
begin T := Self.RecordNumber; end;

(*----------------------------------------------------------------------------*)
procedure TJvNTEventLogOnChange_W(Self: TJvNTEventLog; const T: TNotifyEvent);
begin Self.OnChange := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvNTEventLogOnChange_R(Self: TJvNTEventLog; var T: TNotifyEvent);
begin T := Self.OnChange; end;

(*----------------------------------------------------------------------------*)
procedure TJvNTEventLogActive_W(Self: TJvNTEventLog; const T: Boolean);
begin Self.Active := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvNTEventLogActive_R(Self: TJvNTEventLog; var T: Boolean);
begin T := Self.Active; end;

(*----------------------------------------------------------------------------*)
procedure TJvNTEventLogLog_W(Self: TJvNTEventLog; const T: string);
begin Self.Log := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvNTEventLogLog_R(Self: TJvNTEventLog; var T: string);
begin T := Self.Log; end;

(*----------------------------------------------------------------------------*)
procedure TJvNTEventLogSource_W(Self: TJvNTEventLog; const T: string);
begin Self.Source := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvNTEventLogSource_R(Self: TJvNTEventLog; var T: string);
begin T := Self.Source; end;

(*----------------------------------------------------------------------------*)
procedure TJvNTEventLogServer_W(Self: TJvNTEventLog; const T: string);
begin Self.Server := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvNTEventLogServer_R(Self: TJvNTEventLog; var T: string);
begin T := Self.Server; end;

(*----------------------------------------------------------------------------*)
procedure TJvNTEventLogEventRecord_R(Self: TJvNTEventLog; var T: TJvNTEventLogRecord);
begin T := Self.EventRecord; end;

(*----------------------------------------------------------------------------*)
procedure TJvNTEventLogEventCount_R(Self: TJvNTEventLog; var T: Cardinal);
begin T := Self.EventCount; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJvNTEventLogRecord(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJvNTEventLogRecord) do begin
    RegisterConstructor(@TJvNTEventLogRecord.Create, 'Create');
    RegisterPropertyHelper(@TJvNTEventLogRecordRecordNumber_R,nil,'RecordNumber');
    RegisterPropertyHelper(@TJvNTEventLogRecordDateTime_R,nil,'DateTime');
    RegisterPropertyHelper(@TJvNTEventLogRecordEventType_R,nil,'EventType');
    RegisterPropertyHelper(@TJvNTEventLogRecordCategory_R,nil,'Category');
    RegisterPropertyHelper(@TJvNTEventLogRecordSource_R,nil,'Source');
    RegisterPropertyHelper(@TJvNTEventLogRecordComputer_R,nil,'Computer');
    RegisterPropertyHelper(@TJvNTEventLogRecordID_R,nil,'ID');
    RegisterPropertyHelper(@TJvNTEventLogRecordStringCount_R,nil,'StringCount');
    RegisterPropertyHelper(@TJvNTEventLogRecordSID_R,nil,'SID');
    RegisterPropertyHelper(@TJvNTEventLogRecordEventString_R,nil,'EventString');
    RegisterPropertyHelper(@TJvNTEventLogRecordMessageText_R,nil,'MessageText');
    RegisterPropertyHelper(@TJvNTEventLogRecordUserName_R,nil,'UserName');
    RegisterPropertyHelper(@TJvNTEventLogRecordOwner_R,nil,'Owner');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TNotifyChangeEventLog(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TNotifyChangeEventLog) do
  begin
    RegisterConstructor(@TNotifyChangeEventLog.Create, 'Create');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJvNTEventLog(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJvNTEventLog) do begin
    RegisterConstructor(@TJvNTEventLog.Create, 'Create');
    RegisterMethod(@TJvNTEventLog.Destroy, 'Free');
    RegisterMethod(@TJvNTEventLog.Open, 'Open');
    RegisterMethod(@TJvNTEventLog.Close, 'Close');
    RegisterMethod(@TJvNTEventLog.First, 'First');
    RegisterMethod(@TJvNTEventLog.Last, 'Last');
    RegisterMethod(@TJvNTEventLog.Eof, 'Eof');
    RegisterMethod(@TJvNTEventLog.Next, 'Next');
    RegisterMethod(@TJvNTEventLog.Seek, 'Seek');
    RegisterMethod(@TJvNTEventLog.ReadEventLogs, 'ReadEventLogs');
    RegisterPropertyHelper(@TJvNTEventLogEventCount_R,nil,'EventCount');
    RegisterPropertyHelper(@TJvNTEventLogEventRecord_R,nil,'EventRecord');
    RegisterPropertyHelper(@TJvNTEventLogServer_R,@TJvNTEventLogServer_W,'Server');
    RegisterPropertyHelper(@TJvNTEventLogSource_R,@TJvNTEventLogSource_W,'Source');
    RegisterPropertyHelper(@TJvNTEventLogLog_R,@TJvNTEventLogLog_W,'Log');
    RegisterPropertyHelper(@TJvNTEventLogActive_R,@TJvNTEventLogActive_W,'Active');
    RegisterPropertyHelper(@TJvNTEventLogOnChange_R,@TJvNTEventLogOnChange_W,'OnChange');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_JvNTEventLog(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TNotifyChangeEventLog) do
  with CL.Add(TJvNTEventLogRecord) do
  RIRegister_TJvNTEventLog(CL);
  RIRegister_TNotifyChangeEventLog(CL);
  RIRegister_TJvNTEventLogRecord(CL);
end;

 
 
{ TPSImport_JvNTEventLog }
(*----------------------------------------------------------------------------*)
procedure TPSImport_JvNTEventLog.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_JvNTEventLog(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_JvNTEventLog.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_JvNTEventLog(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
