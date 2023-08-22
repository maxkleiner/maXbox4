unit uPSI_Profiler;
{
  to profile with help file
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
  TPSImport_Profiler = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TProfiler(CL: TPSPascalCompiler);
procedure SIRegister_TProfilerTimers(CL: TPSPascalCompiler);
procedure SIRegister_TProfilerTimer(CL: TPSPascalCompiler);
procedure SIRegister_Profiler(CL: TPSPascalCompiler);

{ run-time registration functions }
//procedure RIRegister_Profiler_Routines(S: TPSExec);
procedure RIRegister_TProfiler(CL: TPSRuntimeClassImporter);
procedure RIRegister_TProfilerTimers(CL: TPSRuntimeClassImporter);
procedure RIRegister_TProfilerTimer(CL: TPSRuntimeClassImporter);
procedure RIRegister_Profiler(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   Windows
  ,Messages
  ,Profiler
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_Profiler]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TProfiler(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TComponent', 'TProfiler') do
  with CL.AddClassN(CL.FindClass('TComponent'),'TProfiler') do begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
    RegisterMethod('Procedure Free');
    RegisterMethod('Procedure OutputDebugTimers');
    RegisterProperty('Resolution', 'Extended', iptr);
    RegisterProperty('TimerByName', 'TProfilerTimer String', iptr);
    SetDefaultPropery('TimerByName');
    RegisterProperty('AutoOutputDebug', 'Boolean', iptrw);
    RegisterProperty('Timers', 'TProfilerTimers', iptrw);
    RegisterProperty('OnTimerStart', 'TProfilerNotifyEvent', iptrw);
    RegisterProperty('OnTimerStop', 'TProfilerNotifyEvent', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TProfilerTimers(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOwnedCollection', 'TProfilerTimers') do
  with CL.AddClassN(CL.FindClass('TOwnedCollection'),'TProfilerTimers') do begin
    RegisterMethod('Constructor Create( AOwner : TProfiler)');
    RegisterMethod('Procedure Free');
    RegisterProperty('Profiler', 'TProfiler', iptr);
    RegisterMethod('Function Add : TProfilerTimer');
    RegisterMethod('Function Insert( Index : Integer) : TProfilerTimer');
    RegisterProperty('Items', 'TProfilerTimer Integer', iptrw);
    SetDefaultPropery('Items');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TProfilerTimer(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TCollectionItem', 'TProfilerTimer') do
  with CL.AddClassN(CL.FindClass('TCollectionItem'),'TProfilerTimer') do begin
    RegisterMethod('Constructor Create( Collection : TCollection)');
    RegisterMethod('Procedure Free');
    RegisterMethod('Procedure Assign( Source : TPersistent)');
    RegisterMethod('Procedure Start');
    RegisterMethod('Procedure Stop');
    RegisterMethod('Procedure Reset');
    RegisterProperty('Profiler', 'TProfiler', iptr);
    RegisterProperty('FirstTime', 'Extended', iptr);
    RegisterProperty('LastTime', 'Extended', iptr);
    RegisterProperty('AvgTime', 'Extended', iptr);
    RegisterProperty('MinHit', 'DWORD', iptr);
    RegisterProperty('MinTime', 'Extended', iptr);
    RegisterProperty('MaxHit', 'DWORD', iptr);
    RegisterProperty('MaxTime', 'Extended', iptr);
    RegisterProperty('TotalHits', 'DWORD', iptr);
    RegisterProperty('TotalTime', 'Extended', iptr);
    RegisterProperty('AsText', 'String TTimeInfo', iptr);
    RegisterProperty('Name', 'String', iptrw);
    RegisterProperty('DisplayFormat', 'String', iptrw);
    RegisterProperty('TimeUnit', 'TTimeUnit', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_Profiler(CL: TPSPascalCompiler);
begin
  CL.AddTypeS('TTimeUnit', '( tuNanosecond, tuMicrosecond, tuMillisecond, tuSecond, tuMinute, tuHour )');
  CL.AddTypeS('TTimeInfo', '( tiAll, tiTotal, tiAvg, tiFirst, tiLast, tiMin, tiMax )');
  CL.AddClassN(CL.FindClass('TOBJECT'),'TProfiler');
  SIRegister_TProfilerTimer(CL);
  SIRegister_TProfilerTimers(CL);
  CL.AddTypeS('TProfilerNotifyEvent', 'Procedure ( Sender : TObject; Timer : TProfilerTimer)');
  SIRegister_TProfiler(CL);
 //CL.AddDelphiFunction('Procedure Register');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TProfilerOnTimerStop_W(Self: TProfiler; const T: TProfilerNotifyEvent);
begin Self.OnTimerStop := T; end;

(*----------------------------------------------------------------------------*)
procedure TProfilerOnTimerStop_R(Self: TProfiler; var T: TProfilerNotifyEvent);
begin T := Self.OnTimerStop; end;

(*----------------------------------------------------------------------------*)
procedure TProfilerOnTimerStart_W(Self: TProfiler; const T: TProfilerNotifyEvent);
begin Self.OnTimerStart := T; end;

(*----------------------------------------------------------------------------*)
procedure TProfilerOnTimerStart_R(Self: TProfiler; var T: TProfilerNotifyEvent);
begin T := Self.OnTimerStart; end;

(*----------------------------------------------------------------------------*)
procedure TProfilerTimers_W(Self: TProfiler; const T: TProfilerTimers);
begin Self.Timers := T; end;

(*----------------------------------------------------------------------------*)
procedure TProfilerTimers_R(Self: TProfiler; var T: TProfilerTimers);
begin T := Self.Timers; end;

(*----------------------------------------------------------------------------*)
procedure TProfilerAutoOutputDebug_W(Self: TProfiler; const T: Boolean);
begin Self.AutoOutputDebug := T; end;

(*----------------------------------------------------------------------------*)
procedure TProfilerAutoOutputDebug_R(Self: TProfiler; var T: Boolean);
begin T := Self.AutoOutputDebug; end;

(*----------------------------------------------------------------------------*)
procedure TProfilerTimerByName_R(Self: TProfiler; var T: TProfilerTimer; const t1: String);
begin T := Self.TimerByName[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TProfilerResolution_R(Self: TProfiler; var T: Extended);
begin T := Self.Resolution; end;

(*----------------------------------------------------------------------------*)
procedure TProfilerTimersItems_W(Self: TProfilerTimers; const T: TProfilerTimer; const t1: Integer);
begin Self.Items[t1] := T; end;

(*----------------------------------------------------------------------------*)
procedure TProfilerTimersItems_R(Self: TProfilerTimers; var T: TProfilerTimer; const t1: Integer);
begin T := Self.Items[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TProfilerTimersProfiler_R(Self: TProfilerTimers; var T: TProfiler);
begin T := Self.Profiler; end;

(*----------------------------------------------------------------------------*)
procedure TProfilerTimerTimeUnit_W(Self: TProfilerTimer; const T: TTimeUnit);
begin Self.TimeUnit := T; end;

(*----------------------------------------------------------------------------*)
procedure TProfilerTimerTimeUnit_R(Self: TProfilerTimer; var T: TTimeUnit);
begin T := Self.TimeUnit; end;

(*----------------------------------------------------------------------------*)
procedure TProfilerTimerDisplayFormat_W(Self: TProfilerTimer; const T: String);
begin Self.DisplayFormat := T; end;

(*----------------------------------------------------------------------------*)
procedure TProfilerTimerDisplayFormat_R(Self: TProfilerTimer; var T: String);
begin T := Self.DisplayFormat; end;

(*----------------------------------------------------------------------------*)
procedure TProfilerTimerName_W(Self: TProfilerTimer; const T: String);
begin Self.Name := T; end;

(*----------------------------------------------------------------------------*)
procedure TProfilerTimerName_R(Self: TProfilerTimer; var T: String);
begin T := Self.Name; end;

(*----------------------------------------------------------------------------*)
procedure TProfilerTimerAsText_R(Self: TProfilerTimer; var T: String; const t1: TTimeInfo);
begin T := Self.AsText[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TProfilerTimerTotalTime_R(Self: TProfilerTimer; var T: Extended);
begin T := Self.TotalTime; end;

(*----------------------------------------------------------------------------*)
procedure TProfilerTimerTotalHits_R(Self: TProfilerTimer; var T: DWORD);
begin T := Self.TotalHits; end;

(*----------------------------------------------------------------------------*)
procedure TProfilerTimerMaxTime_R(Self: TProfilerTimer; var T: Extended);
begin T := Self.MaxTime; end;

(*----------------------------------------------------------------------------*)
procedure TProfilerTimerMaxHit_R(Self: TProfilerTimer; var T: DWORD);
begin T := Self.MaxHit; end;

(*----------------------------------------------------------------------------*)
procedure TProfilerTimerMinTime_R(Self: TProfilerTimer; var T: Extended);
begin T := Self.MinTime; end;

(*----------------------------------------------------------------------------*)
procedure TProfilerTimerMinHit_R(Self: TProfilerTimer; var T: DWORD);
begin T := Self.MinHit; end;

(*----------------------------------------------------------------------------*)
procedure TProfilerTimerAvgTime_R(Self: TProfilerTimer; var T: Extended);
begin T := Self.AvgTime; end;

(*----------------------------------------------------------------------------*)
procedure TProfilerTimerLastTime_R(Self: TProfilerTimer; var T: Extended);
begin T := Self.LastTime; end;

(*----------------------------------------------------------------------------*)
procedure TProfilerTimerFirstTime_R(Self: TProfilerTimer; var T: Extended);
begin T := Self.FirstTime; end;

(*----------------------------------------------------------------------------*)
procedure TProfilerTimerProfiler_R(Self: TProfilerTimer; var T: TProfiler);
begin T := Self.Profiler; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_Profiler_Routines(S: TPSExec);
begin
// S.RegisterDelphiFunction(@Register, 'Register', cdRegister);
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TProfiler(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TProfiler) do begin
    RegisterConstructor(@TProfiler.Create, 'Create');
    RegisterMethod(@TProfiler.Destroy, 'Free');
    RegisterMethod(@TProfiler.OutputDebugTimers, 'OutputDebugTimers');
    RegisterPropertyHelper(@TProfilerResolution_R,nil,'Resolution');
    RegisterPropertyHelper(@TProfilerTimerByName_R,nil,'TimerByName');
    RegisterPropertyHelper(@TProfilerAutoOutputDebug_R,@TProfilerAutoOutputDebug_W,'AutoOutputDebug');
    RegisterPropertyHelper(@TProfilerTimers_R,@TProfilerTimers_W,'Timers');
    RegisterPropertyHelper(@TProfilerOnTimerStart_R,@TProfilerOnTimerStart_W,'OnTimerStart');
    RegisterPropertyHelper(@TProfilerOnTimerStop_R,@TProfilerOnTimerStop_W,'OnTimerStop');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TProfilerTimers(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TProfilerTimers) do begin
    RegisterConstructor(@TProfilerTimers.Create, 'Create');
    RegisterMethod(@TProfilerTimers.Destroy, 'Free');
    RegisterPropertyHelper(@TProfilerTimersProfiler_R,nil,'Profiler');
    RegisterMethod(@TProfilerTimers.Add, 'Add');
    RegisterMethod(@TProfilerTimers.Insert, 'Insert');
    RegisterPropertyHelper(@TProfilerTimersItems_R,@TProfilerTimersItems_W,'Items');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TProfilerTimer(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TProfilerTimer) do begin
    RegisterConstructor(@TProfilerTimer.Create, 'Create');
    RegisterMethod(@TProfilerTimer.Destroy, 'Free');
    RegisterMethod(@TProfilerTimer.Assign, 'Assign');
    RegisterMethod(@TProfilerTimer.Start, 'Start');
    RegisterMethod(@TProfilerTimer.Stop, 'Stop');
    RegisterMethod(@TProfilerTimer.Reset, 'Reset');
    RegisterPropertyHelper(@TProfilerTimerProfiler_R,nil,'Profiler');
    RegisterPropertyHelper(@TProfilerTimerFirstTime_R,nil,'FirstTime');
    RegisterPropertyHelper(@TProfilerTimerLastTime_R,nil,'LastTime');
    RegisterPropertyHelper(@TProfilerTimerAvgTime_R,nil,'AvgTime');
    RegisterPropertyHelper(@TProfilerTimerMinHit_R,nil,'MinHit');
    RegisterPropertyHelper(@TProfilerTimerMinTime_R,nil,'MinTime');
    RegisterPropertyHelper(@TProfilerTimerMaxHit_R,nil,'MaxHit');
    RegisterPropertyHelper(@TProfilerTimerMaxTime_R,nil,'MaxTime');
    RegisterPropertyHelper(@TProfilerTimerTotalHits_R,nil,'TotalHits');
    RegisterPropertyHelper(@TProfilerTimerTotalTime_R,nil,'TotalTime');
    RegisterPropertyHelper(@TProfilerTimerAsText_R,nil,'AsText');
    RegisterPropertyHelper(@TProfilerTimerName_R,@TProfilerTimerName_W,'Name');
    RegisterPropertyHelper(@TProfilerTimerDisplayFormat_R,@TProfilerTimerDisplayFormat_W,'DisplayFormat');
    RegisterPropertyHelper(@TProfilerTimerTimeUnit_R,@TProfilerTimerTimeUnit_W,'TimeUnit');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_Profiler(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TProfiler) do
  RIRegister_TProfilerTimer(CL);
  RIRegister_TProfilerTimers(CL);
  RIRegister_TProfiler(CL);
end;

 
 
{ TPSImport_Profiler }
(*----------------------------------------------------------------------------*)
procedure TPSImport_Profiler.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_Profiler(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_Profiler.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_Profiler(ri);
  //RIRegister_Profiler_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
