unit uPSI_DosCommand;
{
  DOS for BOX
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
  TPSImport_DosCommand = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TDosCommand(CL: TPSPascalCompiler);
procedure SIRegister_TDosThread(CL: TPSPascalCompiler);
procedure SIRegister_TProcessTimer(CL: TPSPascalCompiler);
procedure SIRegister_DosCommand(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_DosCommand_Routines(S: TPSExec);
procedure RIRegister_TDosCommand(CL: TPSRuntimeClassImporter);
procedure RIRegister_TDosThread(CL: TPSRuntimeClassImporter);
procedure RIRegister_TProcessTimer(CL: TPSRuntimeClassImporter);
procedure RIRegister_DosCommand(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   Windows
  ,Messages
  ,Graphics
  ,Controls
  ,Forms
  ,ExtCtrls
  ,DosCommand
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_DosCommand]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TDosCommand(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TComponent', 'TDosCommand') do
  with CL.AddClassN(CL.FindClass('TComponent'),'TDosCommand') do begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
    RegisterMethod('Procedure Free;');
    RegisterMethod('Procedure Execute');
    RegisterMethod('Function Execute2 : Integer');
    RegisterMethod('Procedure Stop');
    RegisterMethod('Procedure SendLine( Value : string; Eol : Boolean)');
    RegisterProperty('OutputLines', 'TStrings', iptrw);
    RegisterProperty('Lines', 'TStringList', iptr);
    RegisterProperty('Priority', 'Integer', iptrw);
    RegisterProperty('Active', 'Boolean', iptr);
    RegisterProperty('Prompting', 'boolean', iptr);
    RegisterProperty('SinceBeginning', 'Integer', iptr);
    RegisterProperty('SinceLastOutput', 'integer', iptr);
    RegisterProperty('ExitCode', 'Integer', iptrw);
    RegisterProperty('ProcessInfo', 'PROCESS_INFORMATION', iptr);
    RegisterProperty('ThreadStatus', 'TDosThreadStatus', iptrw);
    RegisterProperty('Sync', 'TMultiReadExclusiveWriteSynchronizer', iptr);
    RegisterProperty('CommandLine', 'string', iptrw);
    RegisterProperty('OnNewLine', 'TNewLineEvent', iptrw);
    RegisterProperty('OnTerminated', 'TTerminateEvent', iptrw);
    RegisterProperty('InputToOutput', 'Boolean', iptrw);
    RegisterProperty('MaxTimeAfterBeginning', 'Integer', iptrw);
    RegisterProperty('MaxTimeAfterLastOutput', 'Integer', iptrw);
    RegisterProperty('ShowWindow', 'TShowWindow', iptrw);
    RegisterProperty('CreationFlag', 'TCreationFlag', iptrw);
    RegisterProperty('ReturnCode', 'TReturnCode', iptrw);
    RegisterProperty('OutputReturnCode', 'TReturnCode', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TDosThread(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TThread', 'TDosThread') do
  with CL.AddClassN(CL.FindClass('TThread'),'TDosThread') do begin
    RegisterProperty('InputLines_SHARED', 'TstringList', iptrw);
    RegisterProperty('FLineBeginned', 'Boolean', iptrw);
    RegisterProperty('FActive', 'Boolean', iptrw);
    RegisterMethod('Constructor Create( AOwner : TDosCommand)');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TProcessTimer(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TTimer', 'TProcessTimer') do
  with CL.AddClassN(CL.FindClass('TTimer'),'TProcessTimer') do begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
    RegisterMethod('Procedure Beginning');
    RegisterMethod('Procedure NewOutput');
    RegisterMethod('Procedure Ending');
    RegisterProperty('SinceBeginning', 'Integer', iptr);
    RegisterProperty('SinceLastOutput', 'Integer', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_DosCommand(CL: TPSPascalCompiler);
begin
  CL.AddClassN(CL.FindClass('TOBJECT'),'TCreatePipeError');
  CL.AddClassN(CL.FindClass('TOBJECT'),'TCreateProcessError');
  CL.AddTypeS('TOutputType', '( otEntireLine, otBeginningOfLine )');
  CL.AddTypeS('TReturnCode', '( rcCRLF, rcLF )');
  SIRegister_TProcessTimer(CL);
  CL.AddTypeS('TNewLineEvent', 'Procedure ( Sender : TObject; NewLine : string;'
   +' OutputType : TOutputType)');
  CL.AddTypeS('TTerminateEvent', 'Procedure ( Sender : TObject; ExitCode : LongWord)');
  CL.AddTypeS('TShowWindow', '( swHIDE, swMAXIMIZE, swMINIMIZE, swRESTORE, swSH'
   +'OW, swSHOWDEFAULT, swSHOWMAXIMIZED, swSHOWMINIMIZED, swSHOWMINNOACTIVE, sw'
   +'SHOWNA, swSHOWNOACTIVATE, swSHOWNORMAL )');
  CL.AddTypeS('TCreationFlag', '( fCREATE_DEFAULT_ERROR_MODE, fCREATE_NEW_CONSO'
   +'LE, fCREATE_NEW_PROCESS_GROUP, fCREATE_SEPARATE_WOW_VDM, fCREATE_SHARED_WO'
   +'W_VDM, fCREATE_SUSPENDED, fCREATE_UNICODE_ENVIRONMENT, fDEBUG_PROCESS, fDE'
   +'BUG_ONLY_THIS_PROCESS, fDETACHED_PROCESS )');
  CL.AddTypeS('TDosThreadStatus', '( dtsAllocatingMemory, dtsAllocateMemoryFail'
   +', dtsCreatingPipes, dtsCreatePipesFail, dtsCreatingProcess, dtsCreateProce'
   +'ssFail, dtsRunning, dtsRunningError, dtsSuccess, dtsUserAborted, dtsTimeOut)');
  CL.AddClassN(CL.FindClass('TOBJECT'),'TDosCommand');
  SIRegister_TDosThread(CL);
  SIRegister_TDosCommand(CL);
 //CL.AddDelphiFunction('Procedure Register');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TDosCommandOutputReturnCode_R(Self: TDosCommand; var T: TReturnCode);
begin T := Self.OutputReturnCode; end;

(*----------------------------------------------------------------------------*)
procedure TDosCommandReturnCode_W(Self: TDosCommand; const T: TReturnCode);
begin Self.ReturnCode := T; end;

(*----------------------------------------------------------------------------*)
procedure TDosCommandReturnCode_R(Self: TDosCommand; var T: TReturnCode);
begin T := Self.ReturnCode; end;

(*----------------------------------------------------------------------------*)
procedure TDosCommandCreationFlag_W(Self: TDosCommand; const T: TCreationFlag);
begin Self.CreationFlag := T; end;

(*----------------------------------------------------------------------------*)
procedure TDosCommandCreationFlag_R(Self: TDosCommand; var T: TCreationFlag);
begin T := Self.CreationFlag; end;

(*----------------------------------------------------------------------------*)
procedure TDosCommandShowWindow_W(Self: TDosCommand; const T: TShowWindow);
begin Self.ShowWindow := T; end;

(*----------------------------------------------------------------------------*)
procedure TDosCommandShowWindow_R(Self: TDosCommand; var T: TShowWindow);
begin T := Self.ShowWindow; end;

(*----------------------------------------------------------------------------*)
procedure TDosCommandMaxTimeAfterLastOutput_W(Self: TDosCommand; const T: Integer);
begin Self.MaxTimeAfterLastOutput := T; end;

(*----------------------------------------------------------------------------*)
procedure TDosCommandMaxTimeAfterLastOutput_R(Self: TDosCommand; var T: Integer);
begin T := Self.MaxTimeAfterLastOutput; end;

(*----------------------------------------------------------------------------*)
procedure TDosCommandMaxTimeAfterBeginning_W(Self: TDosCommand; const T: Integer);
begin Self.MaxTimeAfterBeginning := T; end;

(*----------------------------------------------------------------------------*)
procedure TDosCommandMaxTimeAfterBeginning_R(Self: TDosCommand; var T: Integer);
begin T := Self.MaxTimeAfterBeginning; end;

(*----------------------------------------------------------------------------*)
procedure TDosCommandInputToOutput_W(Self: TDosCommand; const T: Boolean);
begin Self.InputToOutput := T; end;

(*----------------------------------------------------------------------------*)
procedure TDosCommandInputToOutput_R(Self: TDosCommand; var T: Boolean);
begin T := Self.InputToOutput; end;

(*----------------------------------------------------------------------------*)
procedure TDosCommandOnTerminated_W(Self: TDosCommand; const T: TTerminateEvent);
begin Self.OnTerminated := T; end;

(*----------------------------------------------------------------------------*)
procedure TDosCommandOnTerminated_R(Self: TDosCommand; var T: TTerminateEvent);
begin T := Self.OnTerminated; end;

(*----------------------------------------------------------------------------*)
procedure TDosCommandOnNewLine_W(Self: TDosCommand; const T: TNewLineEvent);
begin Self.OnNewLine := T; end;

(*----------------------------------------------------------------------------*)
procedure TDosCommandOnNewLine_R(Self: TDosCommand; var T: TNewLineEvent);
begin T := Self.OnNewLine; end;

(*----------------------------------------------------------------------------*)
procedure TDosCommandCommandLine_W(Self: TDosCommand; const T: string);
begin Self.CommandLine := T; end;

(*----------------------------------------------------------------------------*)
procedure TDosCommandCommandLine_R(Self: TDosCommand; var T: string);
begin T := Self.CommandLine; end;

(*----------------------------------------------------------------------------*)
procedure TDosCommandSync_R(Self: TDosCommand; var T: TMultiReadExclusiveWriteSynchronizer);
begin T := Self.Sync; end;

(*----------------------------------------------------------------------------*)
procedure TDosCommandThreadStatus_W(Self: TDosCommand; const T: TDosThreadStatus);
begin Self.ThreadStatus := T; end;

(*----------------------------------------------------------------------------*)
procedure TDosCommandThreadStatus_R(Self: TDosCommand; var T: TDosThreadStatus);
begin T := Self.ThreadStatus; end;

(*----------------------------------------------------------------------------*)
procedure TDosCommandProcessInfo_R(Self: TDosCommand; var T: PROCESS_INFORMATION);
begin T := Self.ProcessInfo; end;

(*----------------------------------------------------------------------------*)
procedure TDosCommandExitCode_W(Self: TDosCommand; const T: Integer);
begin Self.ExitCode := T; end;

(*----------------------------------------------------------------------------*)
procedure TDosCommandExitCode_R(Self: TDosCommand; var T: Integer);
begin T := Self.ExitCode; end;

(*----------------------------------------------------------------------------*)
procedure TDosCommandSinceLastOutput_R(Self: TDosCommand; var T: integer);
begin T := Self.SinceLastOutput; end;

(*----------------------------------------------------------------------------*)
procedure TDosCommandSinceBeginning_R(Self: TDosCommand; var T: Integer);
begin T := Self.SinceBeginning; end;

(*----------------------------------------------------------------------------*)
procedure TDosCommandPrompting_R(Self: TDosCommand; var T: boolean);
begin T := Self.Prompting; end;

(*----------------------------------------------------------------------------*)
procedure TDosCommandActive_R(Self: TDosCommand; var T: Boolean);
begin T := Self.Active; end;

(*----------------------------------------------------------------------------*)
procedure TDosCommandPriority_W(Self: TDosCommand; const T: Integer);
begin Self.Priority := T; end;

(*----------------------------------------------------------------------------*)
procedure TDosCommandPriority_R(Self: TDosCommand; var T: Integer);
begin T := Self.Priority; end;

(*----------------------------------------------------------------------------*)
procedure TDosCommandLines_R(Self: TDosCommand; var T: TStringList);
begin T := Self.Lines; end;

(*----------------------------------------------------------------------------*)
procedure TDosCommandOutputLines_W(Self: TDosCommand; const T: TStrings);
begin Self.OutputLines := T; end;

(*----------------------------------------------------------------------------*)
procedure TDosCommandOutputLines_R(Self: TDosCommand; var T: TStrings);
begin T := Self.OutputLines; end;

(*----------------------------------------------------------------------------*)
procedure TDosThreadFActive_W(Self: TDosThread; const T: Boolean);
Begin Self.FActive := T; end;

(*----------------------------------------------------------------------------*)
procedure TDosThreadFActive_R(Self: TDosThread; var T: Boolean);
Begin T := Self.FActive; end;

(*----------------------------------------------------------------------------*)
procedure TDosThreadFLineBeginned_W(Self: TDosThread; const T: Boolean);
Begin Self.FLineBeginned := T; end;

(*----------------------------------------------------------------------------*)
procedure TDosThreadFLineBeginned_R(Self: TDosThread; var T: Boolean);
Begin T := Self.FLineBeginned; end;

(*----------------------------------------------------------------------------*)
procedure TDosThreadInputLines_SHARED_W(Self: TDosThread; const T: TstringList);
Begin Self.InputLines_SHARED := T; end;

(*----------------------------------------------------------------------------*)
procedure TDosThreadInputLines_SHARED_R(Self: TDosThread; var T: TstringList);
Begin T := Self.InputLines_SHARED; end;

(*----------------------------------------------------------------------------*)
procedure TProcessTimerSinceLastOutput_R(Self: TProcessTimer; var T: Integer);
begin T := Self.SinceLastOutput; end;

(*----------------------------------------------------------------------------*)
procedure TProcessTimerSinceBeginning_R(Self: TProcessTimer; var T: Integer);
begin T := Self.SinceBeginning; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_DosCommand_Routines(S: TPSExec);
begin
 //S.RegisterDelphiFunction(@Register, 'Register', cdRegister);
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TDosCommand(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TDosCommand) do begin
    RegisterConstructor(@TDosCommand.Create, 'Create');
    RegisterMethod(@TDosCommand.Destroy, 'Free');
    RegisterMethod(@TDosCommand.Execute, 'Execute');
    RegisterMethod(@TDosCommand.Execute2, 'Execute2');
    RegisterMethod(@TDosCommand.Stop, 'Stop');
    RegisterMethod(@TDosCommand.SendLine, 'SendLine');
    RegisterPropertyHelper(@TDosCommandOutputLines_R,@TDosCommandOutputLines_W,'OutputLines');
    RegisterPropertyHelper(@TDosCommandLines_R,nil,'Lines');
    RegisterPropertyHelper(@TDosCommandPriority_R,@TDosCommandPriority_W,'Priority');
    RegisterPropertyHelper(@TDosCommandActive_R,nil,'Active');
    RegisterPropertyHelper(@TDosCommandPrompting_R,nil,'Prompting');
    RegisterPropertyHelper(@TDosCommandSinceBeginning_R,nil,'SinceBeginning');
    RegisterPropertyHelper(@TDosCommandSinceLastOutput_R,nil,'SinceLastOutput');
    RegisterPropertyHelper(@TDosCommandExitCode_R,@TDosCommandExitCode_W,'ExitCode');
    RegisterPropertyHelper(@TDosCommandProcessInfo_R,nil,'ProcessInfo');
    RegisterPropertyHelper(@TDosCommandThreadStatus_R,@TDosCommandThreadStatus_W,'ThreadStatus');
    RegisterPropertyHelper(@TDosCommandSync_R,nil,'Sync');
    RegisterPropertyHelper(@TDosCommandCommandLine_R,@TDosCommandCommandLine_W,'CommandLine');
    RegisterPropertyHelper(@TDosCommandOnNewLine_R,@TDosCommandOnNewLine_W,'OnNewLine');
    RegisterPropertyHelper(@TDosCommandOnTerminated_R,@TDosCommandOnTerminated_W,'OnTerminated');
    RegisterPropertyHelper(@TDosCommandInputToOutput_R,@TDosCommandInputToOutput_W,'InputToOutput');
    RegisterPropertyHelper(@TDosCommandMaxTimeAfterBeginning_R,@TDosCommandMaxTimeAfterBeginning_W,'MaxTimeAfterBeginning');
    RegisterPropertyHelper(@TDosCommandMaxTimeAfterLastOutput_R,@TDosCommandMaxTimeAfterLastOutput_W,'MaxTimeAfterLastOutput');
    RegisterPropertyHelper(@TDosCommandShowWindow_R,@TDosCommandShowWindow_W,'ShowWindow');
    RegisterPropertyHelper(@TDosCommandCreationFlag_R,@TDosCommandCreationFlag_W,'CreationFlag');
    RegisterPropertyHelper(@TDosCommandReturnCode_R,@TDosCommandReturnCode_W,'ReturnCode');
    RegisterPropertyHelper(@TDosCommandOutputReturnCode_R,nil,'OutputReturnCode');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TDosThread(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TDosThread) do begin
    RegisterPropertyHelper(@TDosThreadInputLines_SHARED_R,@TDosThreadInputLines_SHARED_W,'InputLines_SHARED');
    RegisterPropertyHelper(@TDosThreadFLineBeginned_R,@TDosThreadFLineBeginned_W,'FLineBeginned');
    RegisterPropertyHelper(@TDosThreadFActive_R,@TDosThreadFActive_W,'FActive');
    RegisterConstructor(@TDosThread.Create, 'Create');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TProcessTimer(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TProcessTimer) do begin
    RegisterConstructor(@TProcessTimer.Create, 'Create');
    RegisterMethod(@TProcessTimer.Beginning, 'Beginning');
    RegisterMethod(@TProcessTimer.NewOutput, 'NewOutput');
    RegisterMethod(@TProcessTimer.Ending, 'Ending');
    RegisterPropertyHelper(@TProcessTimerSinceBeginning_R,nil,'SinceBeginning');
    RegisterPropertyHelper(@TProcessTimerSinceLastOutput_R,nil,'SinceLastOutput');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_DosCommand(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TCreatePipeError) do
  with CL.Add(TCreateProcessError) do
  RIRegister_TProcessTimer(CL);
  with CL.Add(TDosCommand) do
  RIRegister_TDosThread(CL);
  RIRegister_TDosCommand(CL);
end;

 
 
{ TPSImport_DosCommand }
(*----------------------------------------------------------------------------*)
procedure TPSImport_DosCommand.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_DosCommand(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_DosCommand.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_DosCommand(ri);
  RIRegister_DosCommand_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
