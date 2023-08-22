unit uPSI_ULog;
{
for pascal coin

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
  TPSImport_ULog = class(TPSPlugin)
  public
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TLog(CL: TPSPascalCompiler);
procedure SIRegister_TThreadSafeLogEvent(CL: TPSPascalCompiler);
procedure SIRegister_ULog(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TLog(CL: TPSRuntimeClassImporter);
procedure RIRegister_TThreadSafeLogEvent(CL: TPSRuntimeClassImporter);
procedure RIRegister_ULog(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   UThread
  ,SyncObjs
  ,ULog
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_ULog]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TLog(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TComponent', 'TLog') do
  with CL.AddClassN(CL.FindClass('TComponent'),'TLog') do begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
     RegisterMethod('Procedure Free');

    RegisterMethod('Procedure NewLog( logtype : TLogType; const sender, logtext : String)');
    RegisterProperty('OnInThreadNewLog', 'TNewLogEvent', iptrw);
    RegisterProperty('OnNewLog', 'TNewLogEvent', iptrw);
    RegisterProperty('FileName', 'AnsiString', iptrw);
    RegisterProperty('SaveTypes', 'TLogTypes', iptrw);
    RegisterProperty('ProcessGlobalLogs', 'Boolean', iptrw);
    RegisterMethod('Procedure NotifyNewLog( logtype : TLogType; const sender, logtext : String)');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TThreadSafeLogEvent(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TPCThread', 'TThreadSafeLogEvent') do
  with CL.AddClassN(CL.FindClass('TPCThread'),'TThreadSafeLogEvent') do
  begin
    RegisterProperty('FLog', 'TLog', iptrw);
    RegisterMethod('Procedure SynchronizedProcess');
    RegisterMethod('Constructor Create( Suspended : Boolean)');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_ULog(CL: TPSPascalCompiler);
begin
  CL.AddTypeS('TLogType', '( ltinfo, ltupdate, lterror, ltdebug )');
  CL.AddTypeS('TLogTypes', 'set of TLogType');
  CL.AddTypeS('TNewLogEvent', 'Procedure ( logtype : TLogType; Time : TDateTime'
   +'; ThreadID : Cardinal; const sender, logtext : AnsiString)');
  CL.AddClassN(CL.FindClass('TOBJECT'),'TLog');
  SIRegister_TThreadSafeLogEvent(CL);
  CL.AddTypeS('TLogData', 'record Logtype : TLogType; Time : TDateTime; ThreadI'
   +'D : Cardinal; Sender : AnsiString; Logtext : AnsiString; end');
  SIRegister_TLog(CL);
 //CL.AddConstantN('CT_TLogTypes_ALL','TLogTypes').SetString(ord(ltinfo) or ord(ltupdate) or ord(lterror) or ord(ltdebug));
 //CL.AddConstantN('CT_TLogTypes_DEFAULT','TLogTypes').SetString(ord(ltinfo) or ord(ltupdate) or ord(lterror));
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TLogProcessGlobalLogs_W(Self: TLog; const T: Boolean);
begin Self.ProcessGlobalLogs := T; end;

(*----------------------------------------------------------------------------*)
procedure TLogProcessGlobalLogs_R(Self: TLog; var T: Boolean);
begin T := Self.ProcessGlobalLogs; end;

(*----------------------------------------------------------------------------*)
procedure TLogSaveTypes_W(Self: TLog; const T: TLogTypes);
begin Self.SaveTypes := T; end;

(*----------------------------------------------------------------------------*)
procedure TLogSaveTypes_R(Self: TLog; var T: TLogTypes);
begin T := Self.SaveTypes; end;

(*----------------------------------------------------------------------------*)
procedure TLogFileName_W(Self: TLog; const T: AnsiString);
begin Self.FileName := T; end;

(*----------------------------------------------------------------------------*)
procedure TLogFileName_R(Self: TLog; var T: AnsiString);
begin T := Self.FileName; end;

(*----------------------------------------------------------------------------*)
procedure TLogOnNewLog_W(Self: TLog; const T: TNewLogEvent);
begin Self.OnNewLog := T; end;

(*----------------------------------------------------------------------------*)
procedure TLogOnNewLog_R(Self: TLog; var T: TNewLogEvent);
begin T := Self.OnNewLog; end;

(*----------------------------------------------------------------------------*)
procedure TLogOnInThreadNewLog_W(Self: TLog; const T: TNewLogEvent);
begin Self.OnInThreadNewLog := T; end;

(*----------------------------------------------------------------------------*)
procedure TLogOnInThreadNewLog_R(Self: TLog; var T: TNewLogEvent);
begin T := Self.OnInThreadNewLog; end;

(*----------------------------------------------------------------------------*)
procedure TThreadSafeLogEventFLog_W(Self: TThreadSafeLogEvent; const T: TLog);
Begin Self.FLog := T; end;

(*----------------------------------------------------------------------------*)
procedure TThreadSafeLogEventFLog_R(Self: TThreadSafeLogEvent; var T: TLog);
Begin T := Self.FLog; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TLog(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TLog) do begin
    RegisterConstructor(@TLog.Create, 'Create');
      RegisterMethod(@TLog.Destroy, 'Free');

    RegisterMethod(@TLog.NewLog, 'NewLog');
    RegisterPropertyHelper(@TLogOnInThreadNewLog_R,@TLogOnInThreadNewLog_W,'OnInThreadNewLog');
    RegisterPropertyHelper(@TLogOnNewLog_R,@TLogOnNewLog_W,'OnNewLog');
    RegisterPropertyHelper(@TLogFileName_R,@TLogFileName_W,'FileName');
    RegisterPropertyHelper(@TLogSaveTypes_R,@TLogSaveTypes_W,'SaveTypes');
    RegisterPropertyHelper(@TLogProcessGlobalLogs_R,@TLogProcessGlobalLogs_W,'ProcessGlobalLogs');
    RegisterMethod(@TLog.NotifyNewLog, 'NotifyNewLog');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TThreadSafeLogEvent(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TThreadSafeLogEvent) do
  begin
    RegisterPropertyHelper(@TThreadSafeLogEventFLog_R,@TThreadSafeLogEventFLog_W,'FLog');
    RegisterMethod(@TThreadSafeLogEvent.SynchronizedProcess, 'SynchronizedProcess');
    RegisterConstructor(@TThreadSafeLogEvent.Create, 'Create');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_ULog(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TLog) do
  RIRegister_TThreadSafeLogEvent(CL);
  RIRegister_TLog(CL);
end;

 
 
{ TPSImport_ULog }
(*----------------------------------------------------------------------------*)
procedure TPSImport_ULog.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_ULog(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_ULog.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_ULog(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
