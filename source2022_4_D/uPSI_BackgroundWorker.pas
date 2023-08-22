unit uPSI_BackgroundWorker;
{
  another thread
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
  TPSImport_BackgroundWorker = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TBackgroundWorker(CL: TPSPascalCompiler);
procedure SIRegister_BackgroundWorker(CL: TPSPascalCompiler);

{ run-time registration functions }
//procedure RIRegister_BackgroundWorker_Routines(S: TPSExec);
procedure RIRegister_TBackgroundWorker(CL: TPSRuntimeClassImporter);
procedure RIRegister_BackgroundWorker(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   Windows
  ,Messages
  ,BackgroundWorker
  ;

  //type TWorkEvent2 = procedure(Worker: TBackgroundWorker) of object;


  //type TworkEvent = TWorkevent2;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_BackgroundWorker]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TBackgroundWorker(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TComponent', 'TBackgroundWorker') do
  with CL.AddClassN(CL.FindClass('TComponent'),'TBackgroundWorker') do begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
      RegisterMethod('Procedure Free');
      RegisterMethod('Procedure Execute');
    RegisterMethod('Procedure Cancel');
    RegisterMethod('Procedure WaitFor');
    RegisterMethod('Procedure ReportProgress( PercentDone : Integer)');
    RegisterMethod('Procedure ReportProgressWait( PercentDone : Integer)');
    RegisterMethod('Procedure ReportFeedback( FeedbackID, FeedbackValue : Integer)');
    RegisterMethod('Procedure ReportFeedbackWait( FeedbackID, FeedbackValue : Integer)');
    RegisterMethod('Procedure Synchronize( Method : TThreadMethod)');
    RegisterMethod('Procedure AcceptCancellation');
    RegisterProperty('CancellationPending', 'Boolean', iptr);
    RegisterProperty('IsCancelled', 'Boolean', iptr);
    RegisterProperty('IsWorking', 'Boolean', iptr);
    RegisterProperty('ThreadID', 'DWORD', iptr);
    RegisterProperty('Priority', 'TThreadPriority', iptrw);
    RegisterProperty('OnWork', 'TWorkEvent2', iptrw);
    RegisterProperty('OnWorkComplete', 'TWorkCompleteEvent', iptrw);
    RegisterProperty('OnWorkProgress', 'TWorkProgressEvent', iptrw);
    RegisterProperty('OnWorkFeedback', 'TWorkFeedbackEvent', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_BackgroundWorker(CL: TPSPascalCompiler);
begin
  CL.AddClassN(CL.FindClass('TOBJECT'),'EBackgroundWorker');
  CL.AddClassN(CL.FindClass('TOBJECT'),'TBackgroundWorker');
  CL.AddTypeS('TWorkEvent2', 'Procedure ( Worker : TBackgroundWorker)');
  CL.AddTypeS('TWorkProgressEvent', 'Procedure ( Worker : TBackgroundWorker; PercentDone : Integer)');
  CL.AddTypeS('TWorkCompleteEvent', 'Procedure ( Worker : TBackgroundWorker; Cancelled : Boolean)');
  CL.AddTypeS('TWorkFeedbackEvent', 'Procedure ( Worker : TBackgroundWorker; FeedbackID, FeedbackValue : Integer)');
  SIRegister_TBackgroundWorker(CL);
 //CL.AddDelphiFunction('Procedure Register');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TBackgroundWorkerOnWorkFeedback_W(Self: TBackgroundWorker; const T: TWorkFeedbackEvent);
begin Self.OnWorkFeedback := T; end;

(*----------------------------------------------------------------------------*)
procedure TBackgroundWorkerOnWorkFeedback_R(Self: TBackgroundWorker; var T: TWorkFeedbackEvent);
begin T := Self.OnWorkFeedback; end;

(*----------------------------------------------------------------------------*)
procedure TBackgroundWorkerOnWorkProgress_W(Self: TBackgroundWorker; const T: TWorkProgressEvent);
begin Self.OnWorkProgress := T; end;

(*----------------------------------------------------------------------------*)
procedure TBackgroundWorkerOnWorkProgress_R(Self: TBackgroundWorker; var T: TWorkProgressEvent);
begin T := Self.OnWorkProgress; end;

(*----------------------------------------------------------------------------*)
procedure TBackgroundWorkerOnWorkComplete_W(Self: TBackgroundWorker; const T: TWorkCompleteEvent);
begin Self.OnWorkComplete := T; end;

(*----------------------------------------------------------------------------*)
procedure TBackgroundWorkerOnWorkComplete_R(Self: TBackgroundWorker; var T: TWorkCompleteEvent);
begin T := Self.OnWorkComplete; end;

(*----------------------------------------------------------------------------*)
procedure TBackgroundWorkerOnWork_W(Self: TBackgroundWorker; const T: TWorkEvent2);
begin Self.OnWork := T; end;

(*----------------------------------------------------------------------------*)
procedure TBackgroundWorkerOnWork_R(Self: TBackgroundWorker; var T: TWorkEvent2);
begin T := Self.OnWork; end;

(*----------------------------------------------------------------------------*)
procedure TBackgroundWorkerPriority_W(Self: TBackgroundWorker; const T: TThreadPriority);
begin Self.Priority := T; end;

(*----------------------------------------------------------------------------*)
procedure TBackgroundWorkerPriority_R(Self: TBackgroundWorker; var T: TThreadPriority);
begin T := Self.Priority; end;

(*----------------------------------------------------------------------------*)
procedure TBackgroundWorkerThreadID_R(Self: TBackgroundWorker; var T: DWORD);
begin T := Self.ThreadID; end;

(*----------------------------------------------------------------------------*)
procedure TBackgroundWorkerIsWorking_R(Self: TBackgroundWorker; var T: Boolean);
begin T := Self.IsWorking; end;

(*----------------------------------------------------------------------------*)
procedure TBackgroundWorkerIsCancelled_R(Self: TBackgroundWorker; var T: Boolean);
begin T := Self.IsCancelled; end;

(*----------------------------------------------------------------------------*)
procedure TBackgroundWorkerCancellationPending_R(Self: TBackgroundWorker; var T: Boolean);
begin T := Self.CancellationPending; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_BackgroundWorker_Routines(S: TPSExec);
begin
 //S.RegisterDelphiFunction(@Register, 'Register', cdRegister);
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TBackgroundWorker(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TBackgroundWorker) do begin
    RegisterConstructor(@TBackgroundWorker.Create, 'Create');
    RegisterMethod(@TBackgroundWorker.Destroy, 'Free');
    RegisterMethod(@TBackgroundWorker.Execute, 'Execute');
    RegisterMethod(@TBackgroundWorker.Cancel, 'Cancel');
    RegisterMethod(@TBackgroundWorker.WaitFor, 'WaitFor');
    RegisterMethod(@TBackgroundWorker.ReportProgress, 'ReportProgress');
    RegisterMethod(@TBackgroundWorker.ReportProgressWait, 'ReportProgressWait');
    RegisterMethod(@TBackgroundWorker.ReportFeedback, 'ReportFeedback');
    RegisterMethod(@TBackgroundWorker.ReportFeedbackWait, 'ReportFeedbackWait');
    RegisterMethod(@TBackgroundWorker.Synchronize, 'Synchronize');
    RegisterMethod(@TBackgroundWorker.AcceptCancellation, 'AcceptCancellation');
    RegisterPropertyHelper(@TBackgroundWorkerCancellationPending_R,nil,'CancellationPending');
    RegisterPropertyHelper(@TBackgroundWorkerIsCancelled_R,nil,'IsCancelled');
    RegisterPropertyHelper(@TBackgroundWorkerIsWorking_R,nil,'IsWorking');
    RegisterPropertyHelper(@TBackgroundWorkerThreadID_R,nil,'ThreadID');
    RegisterPropertyHelper(@TBackgroundWorkerPriority_R,@TBackgroundWorkerPriority_W,'Priority');
    RegisterPropertyHelper(@TBackgroundWorkerOnWork_R,@TBackgroundWorkerOnWork_W,'OnWork');
    RegisterPropertyHelper(@TBackgroundWorkerOnWorkComplete_R,@TBackgroundWorkerOnWorkComplete_W,'OnWorkComplete');
    RegisterPropertyHelper(@TBackgroundWorkerOnWorkProgress_R,@TBackgroundWorkerOnWorkProgress_W,'OnWorkProgress');
    RegisterPropertyHelper(@TBackgroundWorkerOnWorkFeedback_R,@TBackgroundWorkerOnWorkFeedback_W,'OnWorkFeedback');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_BackgroundWorker(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(EBackgroundWorker) do
  with CL.Add(TBackgroundWorker) do
  RIRegister_TBackgroundWorker(CL);
end;

 
 
{ TPSImport_BackgroundWorker }
(*----------------------------------------------------------------------------*)
procedure TPSImport_BackgroundWorker.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_BackgroundWorker(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_BackgroundWorker.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_BackgroundWorker(ri);
  //RIRegister_BackgroundWorker_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
