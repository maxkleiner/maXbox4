unit uPSI_JvCreateProcess;
{
   real create
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
  TPSImport_JvCreateProcess = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TJvCreateProcess(CL: TPSPascalCompiler);
procedure SIRegister_TJvBaseReader(CL: TPSPascalCompiler);
procedure SIRegister_TJvCPSStartupInfo(CL: TPSPascalCompiler);
procedure SIRegister_TJvProcessEntry(CL: TPSPascalCompiler);
procedure SIRegister_JvCreateProcess(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TJvCreateProcess(CL: TPSRuntimeClassImporter);
procedure RIRegister_TJvBaseReader(CL: TPSRuntimeClassImporter);
procedure RIRegister_TJvCPSStartupInfo(CL: TPSRuntimeClassImporter);
procedure RIRegister_TJvProcessEntry(CL: TPSRuntimeClassImporter);
procedure RIRegister_JvCreateProcess(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   //JclUnitVersioning
  Windows
  ,Messages
  ,ShellAPI
  ,SyncObjs
  ,JvComponentBase
  ,JvTypes
  ,JvCreateProcess
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_JvCreateProcess]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TJvCreateProcess(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TJvComponent', 'TJvCreateProcess') do
  with CL.AddClassN(CL.FindClass('TJvComponent'),'TJvCreateProcess') do begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
     RegisterMethod('Procedure Free');
     RegisterMethod('Function CloseApplication( SendQuit : Boolean) : Boolean');
    RegisterMethod('Procedure Run');
    RegisterMethod('Procedure StopWaiting');
    RegisterMethod('Procedure Terminate');
    RegisterMethod('Function Write( const S : AnsiString) : Boolean');
    RegisterMethod('Function WriteLn( const S : AnsiString) : Boolean');
    RegisterProperty('ProcessInfo', 'TProcessInformation', iptr);
    RegisterProperty('State', 'TJvCPSState', iptr);
    RegisterProperty('ConsoleOutput', 'TStrings', iptr);
    RegisterProperty('InputReader', 'TJvBaseReader', iptr);
    RegisterProperty('ErrorReader', 'TJvBaseReader', iptr);
    RegisterProperty('ApplicationName', 'string', iptrw);
    RegisterProperty('CommandLine', 'string', iptrw);
    RegisterProperty('CreationFlags', 'TJvCPSFlags', iptrw);
    RegisterProperty('CurrentDirectory', 'string', iptrw);
    RegisterProperty('Environment', 'TStrings', iptrw);
    RegisterProperty('Priority', 'TJvProcessPriority', iptrw);
    RegisterProperty('StartupInfo', 'TJvCPSStartupInfo', iptrw);
    RegisterProperty('WaitForTerminate', 'Boolean', iptrw);
    RegisterProperty('ConsoleOptions', 'TJvConsoleOptions', iptrw);
    RegisterProperty('OnTerminate', 'TJvCPSTerminateEvent', iptrw);
    RegisterProperty('OnRead', 'TJvCPSReadEvent', iptrw);
    RegisterProperty('OnRawRead', 'TJvCPSRawReadEvent', iptrw);
    RegisterProperty('OnErrorRead', 'TJvCPSReadEvent', iptrw);
    RegisterProperty('OnErrorRawRead', 'TJvCPSRawReadEvent', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TJvBaseReader(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TObject', 'TJvBaseReader') do
  with CL.AddClassN(CL.FindClass('TObject'),'TJvBaseReader') do begin
   RegisterMethod('Procedure Free');
    RegisterMethod('Constructor Create( ACreateProcess : TJvCreateProcess)');
    RegisterProperty('ConsoleOutput', 'TStrings', iptr);
    RegisterProperty('OnRead', 'TJvCPSReadEvent', iptrw);
    RegisterProperty('OnRawRead', 'TJvCPSRawReadEvent', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TJvCPSStartupInfo(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TPersistent', 'TJvCPSStartupInfo') do
  with CL.AddClassN(CL.FindClass('TPersistent'),'TJvCPSStartupInfo') do
  begin
    RegisterMethod('Constructor Create');
    RegisterProperty('StartupInfo', 'TStartupInfo', iptr);
    RegisterProperty('Desktop', 'string', iptrw);
    RegisterProperty('Title', 'string', iptrw);
    RegisterProperty('Left', 'Integer', iptrw);
    RegisterProperty('Top', 'Integer', iptrw);
    RegisterProperty('DefaultPosition', 'Boolean', iptrw);
    RegisterProperty('Width', 'Integer', iptrw);
    RegisterProperty('Height', 'Integer', iptrw);
    RegisterProperty('DefaultSize', 'Boolean', iptrw);
    RegisterProperty('ShowWindow', 'TJvCPSShowWindow', iptrw);
    RegisterProperty('DefaultWindowState', 'Boolean', iptrw);
    RegisterProperty('ForceOnFeedback', 'Boolean', iptrw);
    RegisterProperty('ForceOffFeedback', 'Boolean', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TJvProcessEntry(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TObject', 'TJvProcessEntry') do
  with CL.AddClassN(CL.FindClass('TObject'),'TJvProcessEntry') do
  begin
    RegisterMethod('Constructor Create( AProcessID : DWORD; const AFileName : TFileName; const AProcessName : string)');
    RegisterMethod('Function Close( UseQuit : Boolean) : Boolean');
    RegisterMethod('Function PriorityText( Priority : TJvProcessPriority) : string');
    RegisterMethod('Function Terminate : Boolean');
    RegisterProperty('FileName', 'TFileName', iptr);
    RegisterProperty('LargeIconIndex', 'Integer', iptr);
    RegisterProperty('Priority', 'TJvProcessPriority', iptrw);
    RegisterProperty('ProcessID', 'DWORD', iptr);
    RegisterProperty('ProcessName', 'string', iptr);
    RegisterProperty('SmallIconIndex', 'Integer', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_JvCreateProcess(CL: TPSPascalCompiler);
begin
 CL.AddConstantN('CCPS_BufferSize','LongInt').SetInt( 1024);
 CL.AddConstantN('CCPS_MaxBufferSize','LongInt').SetInt( 65536);
  CL.AddTypeS('EJvProcessError', 'EJVCLException');
  CL.AddTypeS('TJvProcessPriority', '( ppIdle, ppNormal, ppHigh, ppRealTime )');
  CL.AddTypeS('TJvConsoleOption', '( coOwnerData, coRedirect, coSeparateError )');
  CL.AddTypeS('TJvConsoleOptions', 'set of TJvConsoleOption');
  CL.AddTypeS('TJvCPSRawReadEvent', 'Procedure ( Sender : TObject; const S : string)');
  CL.AddTypeS('TJvCPSReadEvent', 'Procedure ( Sender : TObject; const S : string; const StartsOnNewLine : Boolean)');
  CL.AddTypeS('TJvCPSTerminateEvent', 'Procedure ( Sender : TObject; ExitCode : DWORD)');
  SIRegister_TJvProcessEntry(CL);
  CL.AddTypeS('TJvCPSState', '( psReady, psRunning, psWaiting )');
  CL.AddTypeS('TJvCPSFlag', '( cfDefaultErrorMode, cfNewConsole, cfNewProcGroup'
   +', cfSeparateWdm, cfSharedWdm, cfSuspended, cfUnicode, cfDetached )');
  CL.AddTypeS('TJvCPSFlags', 'set of TJvCPSFlag');
  CL.AddTypeS('TJvCPSShowWindow', '( swHide, swMinimize, swMaximize, swNormal )');
  SIRegister_TJvCPSStartupInfo(CL);
  CL.AddClassN(CL.FindClass('TOBJECT'),'TJvCreateProcess');
  SIRegister_TJvBaseReader(CL);
  SIRegister_TJvCreateProcess(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TJvCreateProcessOnErrorRawRead_W(Self: TJvCreateProcess; const T: TJvCPSRawReadEvent);
begin Self.OnErrorRawRead := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvCreateProcessOnErrorRawRead_R(Self: TJvCreateProcess; var T: TJvCPSRawReadEvent);
begin T := Self.OnErrorRawRead; end;

(*----------------------------------------------------------------------------*)
procedure TJvCreateProcessOnErrorRead_W(Self: TJvCreateProcess; const T: TJvCPSReadEvent);
begin Self.OnErrorRead := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvCreateProcessOnErrorRead_R(Self: TJvCreateProcess; var T: TJvCPSReadEvent);
begin T := Self.OnErrorRead; end;

(*----------------------------------------------------------------------------*)
procedure TJvCreateProcessOnRawRead_W(Self: TJvCreateProcess; const T: TJvCPSRawReadEvent);
begin Self.OnRawRead := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvCreateProcessOnRawRead_R(Self: TJvCreateProcess; var T: TJvCPSRawReadEvent);
begin T := Self.OnRawRead; end;

(*----------------------------------------------------------------------------*)
procedure TJvCreateProcessOnRead_W(Self: TJvCreateProcess; const T: TJvCPSReadEvent);
begin Self.OnRead := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvCreateProcessOnRead_R(Self: TJvCreateProcess; var T: TJvCPSReadEvent);
begin T := Self.OnRead; end;

(*----------------------------------------------------------------------------*)
procedure TJvCreateProcessOnTerminate_W(Self: TJvCreateProcess; const T: TJvCPSTerminateEvent);
begin Self.OnTerminate := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvCreateProcessOnTerminate_R(Self: TJvCreateProcess; var T: TJvCPSTerminateEvent);
begin T := Self.OnTerminate; end;

(*----------------------------------------------------------------------------*)
procedure TJvCreateProcessConsoleOptions_W(Self: TJvCreateProcess; const T: TJvConsoleOptions);
begin Self.ConsoleOptions := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvCreateProcessConsoleOptions_R(Self: TJvCreateProcess; var T: TJvConsoleOptions);
begin T := Self.ConsoleOptions; end;

(*----------------------------------------------------------------------------*)
procedure TJvCreateProcessWaitForTerminate_W(Self: TJvCreateProcess; const T: Boolean);
begin Self.WaitForTerminate := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvCreateProcessWaitForTerminate_R(Self: TJvCreateProcess; var T: Boolean);
begin T := Self.WaitForTerminate; end;

(*----------------------------------------------------------------------------*)
procedure TJvCreateProcessStartupInfo_W(Self: TJvCreateProcess; const T: TJvCPSStartupInfo);
begin Self.StartupInfo := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvCreateProcessStartupInfo_R(Self: TJvCreateProcess; var T: TJvCPSStartupInfo);
begin T := Self.StartupInfo; end;

(*----------------------------------------------------------------------------*)
procedure TJvCreateProcessPriority_W(Self: TJvCreateProcess; const T: TJvProcessPriority);
begin Self.Priority := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvCreateProcessPriority_R(Self: TJvCreateProcess; var T: TJvProcessPriority);
begin T := Self.Priority; end;

(*----------------------------------------------------------------------------*)
procedure TJvCreateProcessEnvironment_W(Self: TJvCreateProcess; const T: TStrings);
begin Self.Environment := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvCreateProcessEnvironment_R(Self: TJvCreateProcess; var T: TStrings);
begin T := Self.Environment; end;

(*----------------------------------------------------------------------------*)
procedure TJvCreateProcessCurrentDirectory_W(Self: TJvCreateProcess; const T: string);
begin Self.CurrentDirectory := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvCreateProcessCurrentDirectory_R(Self: TJvCreateProcess; var T: string);
begin T := Self.CurrentDirectory; end;

(*----------------------------------------------------------------------------*)
procedure TJvCreateProcessCreationFlags_W(Self: TJvCreateProcess; const T: TJvCPSFlags);
begin Self.CreationFlags := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvCreateProcessCreationFlags_R(Self: TJvCreateProcess; var T: TJvCPSFlags);
begin T := Self.CreationFlags; end;

(*----------------------------------------------------------------------------*)
procedure TJvCreateProcessCommandLine_W(Self: TJvCreateProcess; const T: string);
begin Self.CommandLine := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvCreateProcessCommandLine_R(Self: TJvCreateProcess; var T: string);
begin T := Self.CommandLine; end;

(*----------------------------------------------------------------------------*)
procedure TJvCreateProcessApplicationName_W(Self: TJvCreateProcess; const T: string);
begin Self.ApplicationName := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvCreateProcessApplicationName_R(Self: TJvCreateProcess; var T: string);
begin T := Self.ApplicationName; end;

(*----------------------------------------------------------------------------*)
procedure TJvCreateProcessErrorReader_R(Self: TJvCreateProcess; var T: TJvBaseReader);
begin T := Self.ErrorReader; end;

(*----------------------------------------------------------------------------*)
procedure TJvCreateProcessInputReader_R(Self: TJvCreateProcess; var T: TJvBaseReader);
begin T := Self.InputReader; end;

(*----------------------------------------------------------------------------*)
procedure TJvCreateProcessConsoleOutput_R(Self: TJvCreateProcess; var T: TStrings);
begin T := Self.ConsoleOutput; end;

(*----------------------------------------------------------------------------*)
procedure TJvCreateProcessState_R(Self: TJvCreateProcess; var T: TJvCPSState);
begin T := Self.State; end;

(*----------------------------------------------------------------------------*)
procedure TJvCreateProcessProcessInfo_R(Self: TJvCreateProcess; var T: TProcessInformation);
begin T := Self.ProcessInfo; end;

(*----------------------------------------------------------------------------*)
procedure TJvBaseReaderOnRawRead_W(Self: TJvBaseReader; const T: TJvCPSRawReadEvent);
begin Self.OnRawRead := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvBaseReaderOnRawRead_R(Self: TJvBaseReader; var T: TJvCPSRawReadEvent);
begin T := Self.OnRawRead; end;

(*----------------------------------------------------------------------------*)
procedure TJvBaseReaderOnRead_W(Self: TJvBaseReader; const T: TJvCPSReadEvent);
begin Self.OnRead := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvBaseReaderOnRead_R(Self: TJvBaseReader; var T: TJvCPSReadEvent);
begin T := Self.OnRead; end;

(*----------------------------------------------------------------------------*)
procedure TJvBaseReaderConsoleOutput_R(Self: TJvBaseReader; var T: TStrings);
begin T := Self.ConsoleOutput; end;

(*----------------------------------------------------------------------------*)
procedure TJvCPSStartupInfoForceOffFeedback_W(Self: TJvCPSStartupInfo; const T: Boolean);
begin Self.ForceOffFeedback := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvCPSStartupInfoForceOffFeedback_R(Self: TJvCPSStartupInfo; var T: Boolean);
begin T := Self.ForceOffFeedback; end;

(*----------------------------------------------------------------------------*)
procedure TJvCPSStartupInfoForceOnFeedback_W(Self: TJvCPSStartupInfo; const T: Boolean);
begin Self.ForceOnFeedback := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvCPSStartupInfoForceOnFeedback_R(Self: TJvCPSStartupInfo; var T: Boolean);
begin T := Self.ForceOnFeedback; end;

(*----------------------------------------------------------------------------*)
procedure TJvCPSStartupInfoDefaultWindowState_W(Self: TJvCPSStartupInfo; const T: Boolean);
begin Self.DefaultWindowState := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvCPSStartupInfoDefaultWindowState_R(Self: TJvCPSStartupInfo; var T: Boolean);
begin T := Self.DefaultWindowState; end;

(*----------------------------------------------------------------------------*)
procedure TJvCPSStartupInfoShowWindow_W(Self: TJvCPSStartupInfo; const T: TJvCPSShowWindow);
begin Self.ShowWindow := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvCPSStartupInfoShowWindow_R(Self: TJvCPSStartupInfo; var T: TJvCPSShowWindow);
begin T := Self.ShowWindow; end;

(*----------------------------------------------------------------------------*)
procedure TJvCPSStartupInfoDefaultSize_W(Self: TJvCPSStartupInfo; const T: Boolean);
begin Self.DefaultSize := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvCPSStartupInfoDefaultSize_R(Self: TJvCPSStartupInfo; var T: Boolean);
begin T := Self.DefaultSize; end;

(*----------------------------------------------------------------------------*)
procedure TJvCPSStartupInfoHeight_W(Self: TJvCPSStartupInfo; const T: Integer);
begin Self.Height := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvCPSStartupInfoHeight_R(Self: TJvCPSStartupInfo; var T: Integer);
begin T := Self.Height; end;

(*----------------------------------------------------------------------------*)
procedure TJvCPSStartupInfoWidth_W(Self: TJvCPSStartupInfo; const T: Integer);
begin Self.Width := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvCPSStartupInfoWidth_R(Self: TJvCPSStartupInfo; var T: Integer);
begin T := Self.Width; end;

(*----------------------------------------------------------------------------*)
procedure TJvCPSStartupInfoDefaultPosition_W(Self: TJvCPSStartupInfo; const T: Boolean);
begin Self.DefaultPosition := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvCPSStartupInfoDefaultPosition_R(Self: TJvCPSStartupInfo; var T: Boolean);
begin T := Self.DefaultPosition; end;

(*----------------------------------------------------------------------------*)
procedure TJvCPSStartupInfoTop_W(Self: TJvCPSStartupInfo; const T: Integer);
begin Self.Top := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvCPSStartupInfoTop_R(Self: TJvCPSStartupInfo; var T: Integer);
begin T := Self.Top; end;

(*----------------------------------------------------------------------------*)
procedure TJvCPSStartupInfoLeft_W(Self: TJvCPSStartupInfo; const T: Integer);
begin Self.Left := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvCPSStartupInfoLeft_R(Self: TJvCPSStartupInfo; var T: Integer);
begin T := Self.Left; end;

(*----------------------------------------------------------------------------*)
procedure TJvCPSStartupInfoTitle_W(Self: TJvCPSStartupInfo; const T: string);
begin Self.Title := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvCPSStartupInfoTitle_R(Self: TJvCPSStartupInfo; var T: string);
begin T := Self.Title; end;

(*----------------------------------------------------------------------------*)
procedure TJvCPSStartupInfoDesktop_W(Self: TJvCPSStartupInfo; const T: string);
begin Self.Desktop := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvCPSStartupInfoDesktop_R(Self: TJvCPSStartupInfo; var T: string);
begin T := Self.Desktop; end;

(*----------------------------------------------------------------------------*)
procedure TJvCPSStartupInfoStartupInfo_R(Self: TJvCPSStartupInfo; var T: TStartupInfo);
begin T := Self.StartupInfo; end;

(*----------------------------------------------------------------------------*)
procedure TJvProcessEntrySmallIconIndex_R(Self: TJvProcessEntry; var T: Integer);
begin T := Self.SmallIconIndex; end;

(*----------------------------------------------------------------------------*)
procedure TJvProcessEntryProcessName_R(Self: TJvProcessEntry; var T: string);
begin T := Self.ProcessName; end;

(*----------------------------------------------------------------------------*)
procedure TJvProcessEntryProcessID_R(Self: TJvProcessEntry; var T: DWORD);
begin T := Self.ProcessID; end;

(*----------------------------------------------------------------------------*)
procedure TJvProcessEntryPriority_W(Self: TJvProcessEntry; const T: TJvProcessPriority);
begin Self.Priority := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvProcessEntryPriority_R(Self: TJvProcessEntry; var T: TJvProcessPriority);
begin T := Self.Priority; end;

(*----------------------------------------------------------------------------*)
procedure TJvProcessEntryLargeIconIndex_R(Self: TJvProcessEntry; var T: Integer);
begin T := Self.LargeIconIndex; end;

(*----------------------------------------------------------------------------*)
procedure TJvProcessEntryFileName_R(Self: TJvProcessEntry; var T: TFileName);
begin T := Self.FileName; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJvCreateProcess(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJvCreateProcess) do begin
    RegisterConstructor(@TJvCreateProcess.Create, 'Create');
    RegisterMethod(@TJvCreateProcess.Destroy, 'Free');
    RegisterMethod(@TJvCreateProcess.CloseApplication, 'CloseApplication');
    RegisterMethod(@TJvCreateProcess.Run, 'Run');
    RegisterMethod(@TJvCreateProcess.StopWaiting, 'StopWaiting');
    RegisterMethod(@TJvCreateProcess.Terminate, 'Terminate');
    RegisterMethod(@TJvCreateProcess.Write, 'Write');
    RegisterMethod(@TJvCreateProcess.WriteLn, 'WriteLn');
    RegisterPropertyHelper(@TJvCreateProcessProcessInfo_R,nil,'ProcessInfo');
    RegisterPropertyHelper(@TJvCreateProcessState_R,nil,'State');
    RegisterPropertyHelper(@TJvCreateProcessConsoleOutput_R,nil,'ConsoleOutput');
    RegisterPropertyHelper(@TJvCreateProcessInputReader_R,nil,'InputReader');
    RegisterPropertyHelper(@TJvCreateProcessErrorReader_R,nil,'ErrorReader');
    RegisterPropertyHelper(@TJvCreateProcessApplicationName_R,@TJvCreateProcessApplicationName_W,'ApplicationName');
    RegisterPropertyHelper(@TJvCreateProcessCommandLine_R,@TJvCreateProcessCommandLine_W,'CommandLine');
    RegisterPropertyHelper(@TJvCreateProcessCreationFlags_R,@TJvCreateProcessCreationFlags_W,'CreationFlags');
    RegisterPropertyHelper(@TJvCreateProcessCurrentDirectory_R,@TJvCreateProcessCurrentDirectory_W,'CurrentDirectory');
    RegisterPropertyHelper(@TJvCreateProcessEnvironment_R,@TJvCreateProcessEnvironment_W,'Environment');
    RegisterPropertyHelper(@TJvCreateProcessPriority_R,@TJvCreateProcessPriority_W,'Priority');
    RegisterPropertyHelper(@TJvCreateProcessStartupInfo_R,@TJvCreateProcessStartupInfo_W,'StartupInfo');
    RegisterPropertyHelper(@TJvCreateProcessWaitForTerminate_R,@TJvCreateProcessWaitForTerminate_W,'WaitForTerminate');
    RegisterPropertyHelper(@TJvCreateProcessConsoleOptions_R,@TJvCreateProcessConsoleOptions_W,'ConsoleOptions');
    RegisterPropertyHelper(@TJvCreateProcessOnTerminate_R,@TJvCreateProcessOnTerminate_W,'OnTerminate');
    RegisterPropertyHelper(@TJvCreateProcessOnRead_R,@TJvCreateProcessOnRead_W,'OnRead');
    RegisterPropertyHelper(@TJvCreateProcessOnRawRead_R,@TJvCreateProcessOnRawRead_W,'OnRawRead');
    RegisterPropertyHelper(@TJvCreateProcessOnErrorRead_R,@TJvCreateProcessOnErrorRead_W,'OnErrorRead');
    RegisterPropertyHelper(@TJvCreateProcessOnErrorRawRead_R,@TJvCreateProcessOnErrorRawRead_W,'OnErrorRawRead');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJvBaseReader(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJvBaseReader) do begin
    RegisterVirtualConstructor(@TJvBaseReader.Create, 'Create');
    RegisterMethod(@TJvBaseReader.Destroy, 'Free');
    RegisterPropertyHelper(@TJvBaseReaderConsoleOutput_R,nil,'ConsoleOutput');
    RegisterPropertyHelper(@TJvBaseReaderOnRead_R,@TJvBaseReaderOnRead_W,'OnRead');
    RegisterPropertyHelper(@TJvBaseReaderOnRawRead_R,@TJvBaseReaderOnRawRead_W,'OnRawRead');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJvCPSStartupInfo(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJvCPSStartupInfo) do
  begin
    RegisterConstructor(@TJvCPSStartupInfo.Create, 'Create');
    RegisterPropertyHelper(@TJvCPSStartupInfoStartupInfo_R,nil,'StartupInfo');
    RegisterPropertyHelper(@TJvCPSStartupInfoDesktop_R,@TJvCPSStartupInfoDesktop_W,'Desktop');
    RegisterPropertyHelper(@TJvCPSStartupInfoTitle_R,@TJvCPSStartupInfoTitle_W,'Title');
    RegisterPropertyHelper(@TJvCPSStartupInfoLeft_R,@TJvCPSStartupInfoLeft_W,'Left');
    RegisterPropertyHelper(@TJvCPSStartupInfoTop_R,@TJvCPSStartupInfoTop_W,'Top');
    RegisterPropertyHelper(@TJvCPSStartupInfoDefaultPosition_R,@TJvCPSStartupInfoDefaultPosition_W,'DefaultPosition');
    RegisterPropertyHelper(@TJvCPSStartupInfoWidth_R,@TJvCPSStartupInfoWidth_W,'Width');
    RegisterPropertyHelper(@TJvCPSStartupInfoHeight_R,@TJvCPSStartupInfoHeight_W,'Height');
    RegisterPropertyHelper(@TJvCPSStartupInfoDefaultSize_R,@TJvCPSStartupInfoDefaultSize_W,'DefaultSize');
    RegisterPropertyHelper(@TJvCPSStartupInfoShowWindow_R,@TJvCPSStartupInfoShowWindow_W,'ShowWindow');
    RegisterPropertyHelper(@TJvCPSStartupInfoDefaultWindowState_R,@TJvCPSStartupInfoDefaultWindowState_W,'DefaultWindowState');
    RegisterPropertyHelper(@TJvCPSStartupInfoForceOnFeedback_R,@TJvCPSStartupInfoForceOnFeedback_W,'ForceOnFeedback');
    RegisterPropertyHelper(@TJvCPSStartupInfoForceOffFeedback_R,@TJvCPSStartupInfoForceOffFeedback_W,'ForceOffFeedback');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJvProcessEntry(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJvProcessEntry) do
  begin
    RegisterConstructor(@TJvProcessEntry.Create, 'Create');
    RegisterMethod(@TJvProcessEntry.Close, 'Close');
    RegisterMethod(@TJvProcessEntry.PriorityText, 'PriorityText');
    RegisterMethod(@TJvProcessEntry.Terminate, 'Terminate');
    RegisterPropertyHelper(@TJvProcessEntryFileName_R,nil,'FileName');
    RegisterPropertyHelper(@TJvProcessEntryLargeIconIndex_R,nil,'LargeIconIndex');
    RegisterPropertyHelper(@TJvProcessEntryPriority_R,@TJvProcessEntryPriority_W,'Priority');
    RegisterPropertyHelper(@TJvProcessEntryProcessID_R,nil,'ProcessID');
    RegisterPropertyHelper(@TJvProcessEntryProcessName_R,nil,'ProcessName');
    RegisterPropertyHelper(@TJvProcessEntrySmallIconIndex_R,nil,'SmallIconIndex');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_JvCreateProcess(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TJvProcessEntry(CL);
  RIRegister_TJvCPSStartupInfo(CL);
  with CL.Add(TJvCreateProcess) do
  RIRegister_TJvBaseReader(CL);
  RIRegister_TJvCreateProcess(CL);
end;

 
 
{ TPSImport_JvCreateProcess }
(*----------------------------------------------------------------------------*)
procedure TPSImport_JvCreateProcess.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_JvCreateProcess(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_JvCreateProcess.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_JvCreateProcess(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
