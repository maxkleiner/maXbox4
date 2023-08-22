unit uPSI_StSpawn;
{
   Linux init unit
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
  TPSImport_StSpawn = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TStSpawnApplication(CL: TPSPascalCompiler);
procedure SIRegister_TStWaitThread(CL: TPSPascalCompiler);
procedure SIRegister_StSpawn(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TStSpawnApplication(CL: TPSRuntimeClassImporter);
procedure RIRegister_TStWaitThread(CL: TPSRuntimeClassImporter);
procedure RIRegister_StSpawn(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   Windows
  ,ExtCtrls
  ,Messages
  ,ShellAPI
  ,StBase
  ,StConst
  ,StSpawn
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_StSpawn]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TStSpawnApplication(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TStComponent', 'TStSpawnApplication') do
  with CL.AddClassN(CL.FindClass('TStComponent'),'TStSpawnApplication') do begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
     RegisterMethod('Procedure Free');
     RegisterMethod('Procedure CancelWait');
    RegisterMethod('Function Execute : THandle');
    RegisterProperty('DefaultDir', 'AnsiString', iptrw);
    RegisterProperty('FileName', 'AnsiString', iptrw);
    RegisterProperty('NotifyWhenDone', 'Boolean', iptrw);
    RegisterProperty('OnCompleted', 'TStSpawnCompletedEvent', iptrw);
    RegisterProperty('OnSpawnError', 'TStSpawnErrorEvent', iptrw);
    RegisterProperty('OnTimeOut', 'TStSpawnTimeOutEvent', iptrw);
    RegisterProperty('RunParameters', 'AnsiString', iptrw);
    RegisterProperty('ShowState', 'TStShowState', iptrw);
    RegisterProperty('SpawnCommand', 'TStSpawnCommand', iptrw);
    RegisterProperty('TimeOut', 'Longint', iptrw);
    RegisterProperty('SpawnCommandStr', 'AnsiString', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TStWaitThread(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TThread', 'TStWaitThread') do
  with CL.AddClassN(CL.FindClass('TThread'),'TStWaitThread') do
  begin
    RegisterProperty('CancelWaitEvent', 'THandle', iptrw);
    RegisterProperty('WaitResult', 'DWORD', iptrw);
    RegisterProperty('WaitFors', 'PWOHandleArray', iptrw);
    RegisterMethod('Constructor Create( aInst, CancelIt : THandle; ATimeOut : Longint)');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_StSpawn(CL: TPSPascalCompiler);
begin
  SIRegister_TStWaitThread(CL);
  CL.AddTypeS('TStSpawnCommand', '( scOpen, scPrint, scOther )');
  CL.AddTypeS('TStShowState', '( ssMinimized, ssMaximized, ssNormal, ssMinNotActive )');
  CL.AddTypeS('TStSpawnErrorEvent', 'Procedure ( Sender : TObject; Error : Word)');
  CL.AddTypeS('TStSpawnCompletedEvent', 'Procedure ( Sender : TObject)');
  CL.AddTypeS('TStSpawnTimeOutEvent', 'Procedure ( Sender : TObject)');
  SIRegister_TStSpawnApplication(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TStSpawnApplicationSpawnCommandStr_W(Self: TStSpawnApplication; const T: AnsiString);
begin Self.SpawnCommandStr := T; end;

(*----------------------------------------------------------------------------*)
procedure TStSpawnApplicationSpawnCommandStr_R(Self: TStSpawnApplication; var T: AnsiString);
begin T := Self.SpawnCommandStr; end;

(*----------------------------------------------------------------------------*)
procedure TStSpawnApplicationTimeOut_W(Self: TStSpawnApplication; const T: Longint);
begin Self.TimeOut := T; end;

(*----------------------------------------------------------------------------*)
procedure TStSpawnApplicationTimeOut_R(Self: TStSpawnApplication; var T: Longint);
begin T := Self.TimeOut; end;

(*----------------------------------------------------------------------------*)
procedure TStSpawnApplicationSpawnCommand_W(Self: TStSpawnApplication; const T: TStSpawnCommand);
begin Self.SpawnCommand := T; end;

(*----------------------------------------------------------------------------*)
procedure TStSpawnApplicationSpawnCommand_R(Self: TStSpawnApplication; var T: TStSpawnCommand);
begin T := Self.SpawnCommand; end;

(*----------------------------------------------------------------------------*)
procedure TStSpawnApplicationShowState_W(Self: TStSpawnApplication; const T: TStShowState);
begin Self.ShowState := T; end;

(*----------------------------------------------------------------------------*)
procedure TStSpawnApplicationShowState_R(Self: TStSpawnApplication; var T: TStShowState);
begin T := Self.ShowState; end;

(*----------------------------------------------------------------------------*)
procedure TStSpawnApplicationRunParameters_W(Self: TStSpawnApplication; const T: AnsiString);
begin Self.RunParameters := T; end;

(*----------------------------------------------------------------------------*)
procedure TStSpawnApplicationRunParameters_R(Self: TStSpawnApplication; var T: AnsiString);
begin T := Self.RunParameters; end;

(*----------------------------------------------------------------------------*)
procedure TStSpawnApplicationOnTimeOut_W(Self: TStSpawnApplication; const T: TStSpawnTimeOutEvent);
begin Self.OnTimeOut := T; end;

(*----------------------------------------------------------------------------*)
procedure TStSpawnApplicationOnTimeOut_R(Self: TStSpawnApplication; var T: TStSpawnTimeOutEvent);
begin T := Self.OnTimeOut; end;

(*----------------------------------------------------------------------------*)
procedure TStSpawnApplicationOnSpawnError_W(Self: TStSpawnApplication; const T: TStSpawnErrorEvent);
begin Self.OnSpawnError := T; end;

(*----------------------------------------------------------------------------*)
procedure TStSpawnApplicationOnSpawnError_R(Self: TStSpawnApplication; var T: TStSpawnErrorEvent);
begin T := Self.OnSpawnError; end;

(*----------------------------------------------------------------------------*)
procedure TStSpawnApplicationOnCompleted_W(Self: TStSpawnApplication; const T: TStSpawnCompletedEvent);
begin Self.OnCompleted := T; end;

(*----------------------------------------------------------------------------*)
procedure TStSpawnApplicationOnCompleted_R(Self: TStSpawnApplication; var T: TStSpawnCompletedEvent);
begin T := Self.OnCompleted; end;

(*----------------------------------------------------------------------------*)
procedure TStSpawnApplicationNotifyWhenDone_W(Self: TStSpawnApplication; const T: Boolean);
begin Self.NotifyWhenDone := T; end;

(*----------------------------------------------------------------------------*)
procedure TStSpawnApplicationNotifyWhenDone_R(Self: TStSpawnApplication; var T: Boolean);
begin T := Self.NotifyWhenDone; end;

(*----------------------------------------------------------------------------*)
procedure TStSpawnApplicationFileName_W(Self: TStSpawnApplication; const T: AnsiString);
begin Self.FileName := T; end;

(*----------------------------------------------------------------------------*)
procedure TStSpawnApplicationFileName_R(Self: TStSpawnApplication; var T: AnsiString);
begin T := Self.FileName; end;

(*----------------------------------------------------------------------------*)
procedure TStSpawnApplicationDefaultDir_W(Self: TStSpawnApplication; const T: AnsiString);
begin Self.DefaultDir := T; end;

(*----------------------------------------------------------------------------*)
procedure TStSpawnApplicationDefaultDir_R(Self: TStSpawnApplication; var T: AnsiString);
begin T := Self.DefaultDir; end;

(*----------------------------------------------------------------------------*)
procedure TStWaitThreadWaitFors_W(Self: TStWaitThread; const T: PWOHandleArray);
Begin Self.WaitFors := T; end;

(*----------------------------------------------------------------------------*)
procedure TStWaitThreadWaitFors_R(Self: TStWaitThread; var T: PWOHandleArray);
Begin T := Self.WaitFors; end;

(*----------------------------------------------------------------------------*)
procedure TStWaitThreadWaitResult_W(Self: TStWaitThread; const T: DWORD);
Begin Self.WaitResult := T; end;

(*----------------------------------------------------------------------------*)
procedure TStWaitThreadWaitResult_R(Self: TStWaitThread; var T: DWORD);
Begin T := Self.WaitResult; end;

(*----------------------------------------------------------------------------*)
procedure TStWaitThreadCancelWaitEvent_W(Self: TStWaitThread; const T: THandle);
Begin Self.CancelWaitEvent := T; end;

(*----------------------------------------------------------------------------*)
procedure TStWaitThreadCancelWaitEvent_R(Self: TStWaitThread; var T: THandle);
Begin T := Self.CancelWaitEvent; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TStSpawnApplication(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TStSpawnApplication) do begin
    RegisterConstructor(@TStSpawnApplication.Create, 'Create');
         RegisterMethod(@TStSpawnApplication.Destroy, 'Free');
    RegisterMethod(@TStSpawnApplication.CancelWait, 'CancelWait');
    RegisterMethod(@TStSpawnApplication.Execute, 'Execute');
    RegisterPropertyHelper(@TStSpawnApplicationDefaultDir_R,@TStSpawnApplicationDefaultDir_W,'DefaultDir');
    RegisterPropertyHelper(@TStSpawnApplicationFileName_R,@TStSpawnApplicationFileName_W,'FileName');
    RegisterPropertyHelper(@TStSpawnApplicationNotifyWhenDone_R,@TStSpawnApplicationNotifyWhenDone_W,'NotifyWhenDone');
    RegisterPropertyHelper(@TStSpawnApplicationOnCompleted_R,@TStSpawnApplicationOnCompleted_W,'OnCompleted');
    RegisterPropertyHelper(@TStSpawnApplicationOnSpawnError_R,@TStSpawnApplicationOnSpawnError_W,'OnSpawnError');
    RegisterPropertyHelper(@TStSpawnApplicationOnTimeOut_R,@TStSpawnApplicationOnTimeOut_W,'OnTimeOut');
    RegisterPropertyHelper(@TStSpawnApplicationRunParameters_R,@TStSpawnApplicationRunParameters_W,'RunParameters');
    RegisterPropertyHelper(@TStSpawnApplicationShowState_R,@TStSpawnApplicationShowState_W,'ShowState');
    RegisterPropertyHelper(@TStSpawnApplicationSpawnCommand_R,@TStSpawnApplicationSpawnCommand_W,'SpawnCommand');
    RegisterPropertyHelper(@TStSpawnApplicationTimeOut_R,@TStSpawnApplicationTimeOut_W,'TimeOut');
    RegisterPropertyHelper(@TStSpawnApplicationSpawnCommandStr_R,@TStSpawnApplicationSpawnCommandStr_W,'SpawnCommandStr');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TStWaitThread(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TStWaitThread) do
  begin
    RegisterPropertyHelper(@TStWaitThreadCancelWaitEvent_R,@TStWaitThreadCancelWaitEvent_W,'CancelWaitEvent');
    RegisterPropertyHelper(@TStWaitThreadWaitResult_R,@TStWaitThreadWaitResult_W,'WaitResult');
    RegisterPropertyHelper(@TStWaitThreadWaitFors_R,@TStWaitThreadWaitFors_W,'WaitFors');
    RegisterConstructor(@TStWaitThread.Create, 'Create');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_StSpawn(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TStWaitThread(CL);
  RIRegister_TStSpawnApplication(CL);
end;

 
 
{ TPSImport_StSpawn }
(*----------------------------------------------------------------------------*)
procedure TPSImport_StSpawn.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_StSpawn(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_StSpawn.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_StSpawn(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
