unit uPSI_ParallelJobs;
{
  as a beta framework with asynccalls and syncobjs
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
  TPSImport_ParallelJobs = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TParallelJob(CL: TPSPascalCompiler);
procedure SIRegister_TParallelJobLocker(CL: TPSPascalCompiler);
procedure SIRegister_TParallelJobSemaphore(CL: TPSPascalCompiler);
procedure SIRegister_TParallelJobInfo(CL: TPSPascalCompiler);
procedure SIRegister_TJobsGroup(CL: TPSPascalCompiler);
procedure SIRegister_ParallelJobs(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_ParallelJobs_Routines(S: TPSExec);
procedure RIRegister_TParallelJob(CL: TPSRuntimeClassImporter);
procedure RIRegister_TParallelJobLocker(CL: TPSRuntimeClassImporter);
procedure RIRegister_TParallelJobSemaphore(CL: TPSRuntimeClassImporter);
procedure RIRegister_TParallelJobInfo(CL: TPSRuntimeClassImporter);
procedure RIRegister_TJobsGroup(CL: TPSRuntimeClassImporter);
procedure RIRegister_ParallelJobs(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   Windows
  ,ParallelJobs
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_ParallelJobs]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TParallelJob(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOBJECT', 'TParallelJob') do
  with CL.AddClassN(CL.FindClass('TOBJECT'),'TParallelJob') do begin
    RegisterMethod('Constructor Create( ASelf : TObject; ATarget : Pointer; AParam : Pointer; ASafeSection : boolean);');
    RegisterMethod('Constructor Create1( ATarget : Pointer; AParam : Pointer; ASafeSection : boolean);');
    RegisterMethod('Procedure Start;');
    RegisterMethod('Procedure Start1( AParam : Pointer);');
    RegisterMethod('Procedure Pause');
    RegisterMethod('Procedure Stop( AWaitFinish : Boolean)');
    RegisterMethod('Function IsDone : boolean');
    RegisterMethod('Function WaitForEnd( ATimeout : DWORD) : integer;');
    RegisterMethod('Function WaitForEnd1 : integer;');
    RegisterProperty('Priority', 'Integer', iptrw);
    RegisterProperty('Locker', 'TParallelJobLocker', iptrw);
    RegisterProperty('Info', 'TParallelJobInfo', iptr);
    RegisterMethod('Function ParallelJobsCount : integer');
    RegisterMethod('Procedure TerminateAllParallelJobs( AForce : boolean)');
    RegisterMethod('Procedure WaitAllParallelJobsFinalization( AWaitNotify : TWaitProcessNotify)');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TParallelJobLocker(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOBJECT', 'TParallelJobLocker') do
  with CL.AddClassN(CL.FindClass('TOBJECT'),'TParallelJobLocker') do begin
    RegisterMethod('Constructor Create');
    RegisterMethod('Procedure Lock');
    RegisterMethod('Procedure Unlock');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TParallelJobSemaphore(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOBJECT', 'TParallelJobSemaphore') do
  with CL.AddClassN(CL.FindClass('TOBJECT'),'TParallelJobSemaphore') do begin
    RegisterMethod('Constructor Create');
    RegisterMethod('Constructor Create( AManualReset : boolean);');
    RegisterMethod('Constructor Create1( AName : string; AManualReset : boolean);');
    RegisterMethod('Constructor Create2( AName : string; AManualReset, AInitialState : boolean; ASecurityAttributes : PSecurityAttributes);');
    RegisterMethod('Function WaitEvent( ATimeout : DWORD) : integer;');
    RegisterMethod('Function WaitEvent1 : integer;');
    RegisterMethod('Procedure SetEvent');
    RegisterMethod('Procedure Reset');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TParallelJobInfo(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOBJECT', 'TParallelJobInfo') do
  with CL.AddClassN(CL.FindClass('TOBJECT'),'TParallelJobInfo') do begin
    RegisterMethod('Function Id : DWORD');
    RegisterMethod('Function Handle : THandle');
    RegisterMethod('Function Terminated : boolean');
    RegisterMethod('Function Job : TParallelJob');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TJobsGroup(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOBJECT', 'TJobsGroup') do
  with CL.AddClassN(CL.FindClass('TOBJECT'),'TJobsGroup') do begin
    RegisterMethod('Constructor Create( AName : string)');
    RegisterMethod('Procedure Free');
    RegisterMethod('Procedure Clear');
    RegisterMethod('Procedure InitJobCapture');
    RegisterMethod('Procedure EndJobCapture');
    RegisterMethod('Function StartJobs : integer');
    RegisterMethod('Function StopJobs( AWaitNotify : TWaitProcessNotify; AForce : boolean) : integer');
    RegisterMethod('Function JobsCount : integer');
    RegisterMethod('Function JobsIsRunning : Integer');
    RegisterMethod('Function WaitForJobs( AWaitAll : boolean; AMilliseconds : DWORD) : DWORD');
    RegisterMethod('Procedure RemoveJob( AIndex : integer)');
    RegisterProperty('Jobs', 'PJobItem integer', iptr);
    RegisterProperty('Name', 'string', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_ParallelJobs(CL: TPSPascalCompiler);
begin
  CL.AddTypeS('TWaitProcessNotify', 'Procedure');
  CL.AddTypeS('TJobState', '( jgsRunning, jgsStopped )');
  //CL.AddTypeS('PJobItem', '^TJobItem // will not work');
  //CL.AddTypeS('TJobItem', 'record Job : Pointer; prev : PJobItem; next : PJobItem; end');
  //CL.AddTypeS('PJobsGroup', '^TJobsGroup // will not work');
  SIRegister_TJobsGroup(CL);
  CL.AddClassN(CL.FindClass('TOBJECT'),'TParallelJob');
  SIRegister_TParallelJobInfo(CL);
  SIRegister_TParallelJobSemaphore(CL);
  SIRegister_TParallelJobLocker(CL);
  SIRegister_TParallelJob(CL);
 CL.AddDelphiFunction('Procedure ParallelJob( ASelf : TObject; ATarget : ___Pointer; AParam : ___Pointer; ASafeSection : boolean);');
 CL.AddDelphiFunction('Procedure ParallelJob1( ATarget : ___Pointer; AParam : ___Pointer; ASafeSection : boolean);');
 CL.AddDelphiFunction('Procedure ParallelJob2( AJobGroup : TJobsGroup; ASelf : TObject; ATarget : ___Pointer; AParam : ___Pointer; ASafeSection : boolean);');
 CL.AddDelphiFunction('Procedure ParallelJob3( AJobGroup : TJobsGroup; ATarget : ___Pointer; AParam : ___Pointer; ASafeSection : boolean);');
 CL.AddDelphiFunction('Function CreateParallelJob( ASelf : TObject; ATarget : ___Pointer; AParam : ___Pointer; ASafeSection : boolean) : TParallelJob;');
 CL.AddDelphiFunction('Function CreateParallelJob1( ATarget : ___Pointer; AParam : ___Pointer; ASafeSection : boolean) : TParallelJob;');
 CL.AddDelphiFunction('Function CurrentParallelJobInfo : TParallelJobInfo');
 CL.AddDelphiFunction('Function ObtainParallelJobInfo : TParallelJobInfo');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
Function CreateParallelJob1_P( ATarget : Pointer; AParam : Pointer; ASafeSection : boolean) : TParallelJob;
Begin Result := ParallelJobs.CreateParallelJob(ATarget, AParam, ASafeSection); END;

(*----------------------------------------------------------------------------*)
Function CreateParallelJob_P( ASelf : TObject; ATarget : Pointer; AParam : Pointer; ASafeSection : boolean) : TParallelJob;
Begin Result := ParallelJobs.CreateParallelJob(ASelf, ATarget, AParam, ASafeSection); END;

(*----------------------------------------------------------------------------*)
Procedure ParallelJob3_P( AJobGroup : TJobsGroup; ATarget : Pointer; AParam : Pointer; ASafeSection : boolean);
Begin ParallelJobs.ParallelJob(AJobGroup, ATarget, AParam, ASafeSection); END;

(*----------------------------------------------------------------------------*)
Procedure ParallelJob2_P( AJobGroup : TJobsGroup; ASelf : TObject; ATarget : Pointer; AParam : Pointer; ASafeSection : boolean);
Begin ParallelJobs.ParallelJob(AJobGroup, ASelf, ATarget, AParam, ASafeSection); END;

(*----------------------------------------------------------------------------*)
Procedure ParallelJob1_P( ATarget : Pointer; AParam : Pointer; ASafeSection : boolean);
Begin ParallelJobs.ParallelJob(ATarget, AParam, ASafeSection); END;

(*----------------------------------------------------------------------------*)
Procedure ParallelJob_P( ASelf : TObject; ATarget : Pointer; AParam : Pointer; ASafeSection : boolean);
Begin ParallelJobs.ParallelJob(ASelf, ATarget, AParam, ASafeSection); END;

(*----------------------------------------------------------------------------*)
procedure TParallelJobInfo_R(Self: TParallelJob; var T: TParallelJobInfo);
begin T := Self.Info; end;

(*----------------------------------------------------------------------------*)
procedure TParallelJobLocker_W(Self: TParallelJob; const T: TParallelJobLocker);
begin Self.Locker := T; end;

(*----------------------------------------------------------------------------*)
procedure TParallelJobLocker_R(Self: TParallelJob; var T: TParallelJobLocker);
begin T := Self.Locker; end;

(*----------------------------------------------------------------------------*)
procedure TParallelJobPriority_W(Self: TParallelJob; const T: Integer);
begin Self.Priority := T; end;

(*----------------------------------------------------------------------------*)
procedure TParallelJobPriority_R(Self: TParallelJob; var T: Integer);
begin T := Self.Priority; end;

(*----------------------------------------------------------------------------*)
Function TParallelJobWaitForEnd1_P(Self: TParallelJob) : integer;
Begin Result := Self.WaitForEnd; END;

(*----------------------------------------------------------------------------*)
Function TParallelJobWaitForEnd_P(Self: TParallelJob;  ATimeout : DWORD) : integer;
Begin Result := Self.WaitForEnd(ATimeout); END;

(*----------------------------------------------------------------------------*)
Procedure TParallelJobStart1_P(Self: TParallelJob;  AParam : Pointer);
Begin Self.Start(AParam); END;

(*----------------------------------------------------------------------------*)
Procedure TParallelJobStart_P(Self: TParallelJob);
Begin Self.Start; END;

(*----------------------------------------------------------------------------*)
Function TParallelJobCreate1_P(Self: TClass; CreateNewInstance: Boolean;  ATarget : Pointer; AParam : Pointer; ASafeSection : boolean):TObject;
Begin Result := TParallelJob.Create(ATarget, AParam, ASafeSection); END;

(*----------------------------------------------------------------------------*)
Function TParallelJobCreate_P(Self: TClass; CreateNewInstance: Boolean;  ASelf : TObject; ATarget : Pointer; AParam : Pointer; ASafeSection : boolean):TObject;
Begin Result := TParallelJob.Create(ASelf, ATarget, AParam, ASafeSection); END;

(*----------------------------------------------------------------------------*)
Function TParallelJobSemaphoreWaitEvent1_P(Self: TParallelJobSemaphore) : integer;
Begin Result := Self.WaitEvent; END;

(*----------------------------------------------------------------------------*)
Function TParallelJobSemaphoreWaitEvent_P(Self: TParallelJobSemaphore;  ATimeout : DWORD) : integer;
Begin Result := Self.WaitEvent(ATimeout); END;

(*----------------------------------------------------------------------------*)
Function TParallelJobSemaphoreCreate2_P(Self: TClass; CreateNewInstance: Boolean;  AName : string; AManualReset, AInitialState : boolean; ASecurityAttributes : PSecurityAttributes):TObject;
Begin Result := TParallelJobSemaphore.Create(AName, AManualReset, AInitialState, ASecurityAttributes); END;

(*----------------------------------------------------------------------------*)
Function TParallelJobSemaphoreCreate1_P(Self: TClass; CreateNewInstance: Boolean;  AName : string; AManualReset : boolean):TObject;
Begin Result := TParallelJobSemaphore.Create(AName, AManualReset); END;

(*----------------------------------------------------------------------------*)
Function TParallelJobSemaphoreCreate_P(Self: TClass; CreateNewInstance: Boolean;  AManualReset : boolean):TObject;
Begin Result := TParallelJobSemaphore.Create(AManualReset); END;

(*----------------------------------------------------------------------------*)
procedure TJobsGroupName_R(Self: TJobsGroup; var T: string);
begin T := Self.Name; end;

(*----------------------------------------------------------------------------*)
procedure TJobsGroupJobs_R(Self: TJobsGroup; var T: PJobItem; const t1: integer);
begin T := Self.Jobs[t1]; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_ParallelJobs_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@ParallelJob, 'ParallelJob', cdRegister);
 S.RegisterDelphiFunction(@ParallelJob1_P, 'ParallelJob1', cdRegister);
 S.RegisterDelphiFunction(@ParallelJob2_P, 'ParallelJob2', cdRegister);
 S.RegisterDelphiFunction(@ParallelJob3_P, 'ParallelJob3', cdRegister);
 S.RegisterDelphiFunction(@CreateParallelJob, 'CreateParallelJob', cdRegister);
 S.RegisterDelphiFunction(@CreateParallelJob1_P, 'CreateParallelJob1', cdRegister);
 S.RegisterDelphiFunction(@CurrentParallelJobInfo, 'CurrentParallelJobInfo', cdRegister);
 S.RegisterDelphiFunction(@ObtainParallelJobInfo, 'ObtainParallelJobInfo', cdRegister);
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TParallelJob(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TParallelJob) do begin
    RegisterConstructor(@TParallelJobCreate_P, 'Create');
    RegisterConstructor(@TParallelJobCreate1_P, 'Create1');
    RegisterVirtualMethod(@TParallelJobStart_P, 'Start');
    RegisterVirtualMethod(@TParallelJobStart1_P, 'Start1');
    RegisterVirtualMethod(@TParallelJob.Pause, 'Pause');
    RegisterVirtualMethod(@TParallelJob.Stop, 'Stop');
    RegisterVirtualMethod(@TParallelJob.IsDone, 'IsDone');
    RegisterVirtualMethod(@TParallelJobWaitForEnd_P, 'WaitForEnd');
    RegisterVirtualMethod(@TParallelJobWaitForEnd1_P, 'WaitForEnd1');
    RegisterPropertyHelper(@TParallelJobPriority_R,@TParallelJobPriority_W,'Priority');
    RegisterPropertyHelper(@TParallelJobLocker_R,@TParallelJobLocker_W,'Locker');
    RegisterPropertyHelper(@TParallelJobInfo_R,nil,'Info');
    RegisterMethod(@TParallelJob.ParallelJobsCount, 'ParallelJobsCount');
    RegisterMethod(@TParallelJob.TerminateAllParallelJobs, 'TerminateAllParallelJobs');
    RegisterMethod(@TParallelJob.WaitAllParallelJobsFinalization, 'WaitAllParallelJobsFinalization');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TParallelJobLocker(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TParallelJobLocker) do begin
    RegisterConstructor(@TParallelJobLocker.Create, 'Create');
    RegisterVirtualMethod(@TParallelJobLocker.Lock, 'Lock');
    RegisterVirtualMethod(@TParallelJobLocker.Unlock, 'Unlock');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TParallelJobSemaphore(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TParallelJobSemaphore) do begin
    RegisterConstructor(@TParallelJobSemaphore.Create, 'Create');
    RegisterConstructor(@TParallelJobSemaphoreCreate_P, 'Create');
    RegisterConstructor(@TParallelJobSemaphoreCreate1_P, 'Create1');
    RegisterConstructor(@TParallelJobSemaphoreCreate2_P, 'Create2');
    RegisterVirtualMethod(@TParallelJobSemaphoreWaitEvent_P, 'WaitEvent');
    RegisterVirtualMethod(@TParallelJobSemaphoreWaitEvent1_P, 'WaitEvent1');
    RegisterVirtualMethod(@TParallelJobSemaphore.SetEvent, 'SetEvent');
    RegisterVirtualMethod(@TParallelJobSemaphore.Reset, 'Reset');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TParallelJobInfo(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TParallelJobInfo) do begin
    RegisterMethod(@TParallelJobInfo.Id, 'Id');
    RegisterMethod(@TParallelJobInfo.Handle, 'Handle');
    RegisterMethod(@TParallelJobInfo.Terminated, 'Terminated');
    RegisterMethod(@TParallelJobInfo.Job, 'Job');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJobsGroup(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJobsGroup) do begin
    RegisterConstructor(@TJobsGroup.Create, 'Create');
    RegisterMethod(@TJobsGroup.Clear, 'Clear');
    RegisterMethod(@TJobsGroup.Destroy, 'Free');
    RegisterMethod(@TJobsGroup.InitJobCapture, 'InitJobCapture');
    RegisterMethod(@TJobsGroup.EndJobCapture, 'EndJobCapture');
    RegisterMethod(@TJobsGroup.StartJobs, 'StartJobs');
    RegisterMethod(@TJobsGroup.StopJobs, 'StopJobs');
    RegisterMethod(@TJobsGroup.JobsCount, 'JobsCount');
    RegisterMethod(@TJobsGroup.JobsIsRunning, 'JobsIsRunning');
    RegisterMethod(@TJobsGroup.WaitForJobs, 'WaitForJobs');
    RegisterMethod(@TJobsGroup.RemoveJob, 'RemoveJob');
    RegisterPropertyHelper(@TJobsGroupJobs_R,nil,'Jobs');
    RegisterPropertyHelper(@TJobsGroupName_R,nil,'Name');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_ParallelJobs(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TJobsGroup(CL);
  with CL.Add(TParallelJob) do
  RIRegister_TParallelJobInfo(CL);
  RIRegister_TParallelJobSemaphore(CL);
  RIRegister_TParallelJobLocker(CL);
  RIRegister_TParallelJob(CL);
end;

 
 
{ TPSImport_ParallelJobs }
(*----------------------------------------------------------------------------*)
procedure TPSImport_ParallelJobs.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_ParallelJobs(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_ParallelJobs.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_ParallelJobs(ri);
  RIRegister_ParallelJobs_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
