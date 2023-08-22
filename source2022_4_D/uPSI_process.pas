unit uPSI_process;
{
   at least process  with executable
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
  TPSImport_process = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TProcess(CL: TPSPascalCompiler);
procedure SIRegister_process(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TProcess(CL: TPSRuntimeClassImporter);
procedure RIRegister_process(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
  pipes
  //,Libc
  ,Windows
  ,process
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_process]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TProcess(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TComponent', 'TProcess') do
  with CL.AddClassN(CL.FindClass('TComponent'),'TProcess') do begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
    RegisterMethod('Procedure Free');
    RegisterMethod('Procedure Execute');
    RegisterMethod('Function Resume : Integer');
    RegisterMethod('Function Suspend : Integer');
    RegisterMethod('Function Terminate( AExitCode : Integer) : Boolean');
    RegisterMethod('Function WaitOnExit : DWord');
    RegisterProperty('WindowRect', 'Trect', iptrw);
    RegisterProperty('StartupInfo', 'TStartupInfo', iptr);
    RegisterProperty('ProcessAttributes', 'TSecurityAttributes', iptrw);
    RegisterProperty('ProcessInformation', 'TProcessInformation', iptr);
    RegisterProperty('Handle', 'THandle', iptr);
    RegisterProperty('ThreadHandle', 'THandle', iptr);
    RegisterProperty('Input', 'TOutPutPipeStream', iptr);
    RegisterProperty('OutPut', 'TInputPipeStream', iptr);
    RegisterProperty('StdErr', 'TinputPipeStream', iptr);
    RegisterProperty('ExitStatus', 'Integer', iptr);
    RegisterProperty('Active', 'Boolean', iptrw);
    RegisterProperty('ApplicationName', 'String', iptrw);
    RegisterProperty('CommandLine', 'String', iptrw);
    RegisterProperty('ConsoleTitle', 'String', iptrw);
    RegisterProperty('CurrentDirectory', 'String', iptrw);
    RegisterProperty('DeskTop', 'String', iptrw);
    RegisterProperty('Environment', 'TStrings', iptrw);
    RegisterProperty('FillAttribute', 'Cardinal', iptrw);
    RegisterProperty('InheritHandles', 'LongBool', iptrw);
    RegisterProperty('Options', 'TProcessOptions', iptrw);
    RegisterProperty('Priority', 'TProcessPriority', iptrw);
    RegisterProperty('StartUpOptions', 'TStartUpOptions', iptrw);
    RegisterProperty('Running', 'Boolean', iptr);
    RegisterProperty('ShowWindow', 'TShowWindowOptions', iptrw);
    RegisterProperty('ThreadAttributes', 'TSecurityAttributes', iptrw);
    RegisterProperty('WindowColumns', 'Cardinal', iptrw);
    RegisterProperty('WindowHeight', 'Cardinal', iptrw);
    RegisterProperty('WindowLeft', 'Cardinal', iptrw);
    RegisterProperty('WindowRows', 'Cardinal', iptrw);
    RegisterProperty('WindowTop', 'Cardinal', iptrw);
    RegisterProperty('WindowWidth', 'Cardinal', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_process(CL: TPSPascalCompiler);
begin
  CL.AddTypeS('TProcessOption', '( poRunSuspended, poWaitOnExit, poUsePipes, po'
   +'StderrToOutPut, poNoConsole, poNewConsole, poDefaultErrorMode, poNewProces'
   +'sGroup, poDebugProcess, poDebugOnlyThisProcess )');
  CL.AddTypeS('TShowWindowOptions', '( swoNone, swoHIDE, swoMaximize, swoMinimi'
   +'ze, swoRestore, swoShow, swoShowDefault, swoShowMaximized, swoShowMinimize'
   +'d, swoshowMinNOActive, swoShowNA, swoShowNoActivate, swoShowNormal )');
  CL.AddTypeS('TStartupOption', '( suoUseShowWindow, suoUseSize, suoUsePosition'
   +', suoUseCountChars, suoUseFillAttribute )');
  CL.AddTypeS('TProcessPriority', '( ppHigh, ppIdle, ppNormal, ppRealTime )');
  CL.AddTypeS('TProcessOptions', 'set of TPRocessOption');
  CL.AddTypeS('TstartUpoptions', 'set of TStartupOption');
 CL.AddConstantN('STARTF_USESHOWWINDOW','LongInt').SetInt( 1);
 CL.AddConstantN('STARTF_USESIZE','LongInt').SetInt( 2);
 CL.AddConstantN('STARTF_USEPOSITION','LongInt').SetInt( 4);
 CL.AddConstantN('STARTF_USECOUNTCHARS','LongInt').SetInt( 8);
 CL.AddConstantN('STARTF_USEFILLATTRIBUTE','LongWord').SetUInt( $10);
 CL.AddConstantN('STARTF_RUNFULLSCREEN','LongWord').SetUInt( $20);
 CL.AddConstantN('STARTF_FORCEONFEEDBACK','LongWord').SetUInt( $40);
 CL.AddConstantN('STARTF_FORCEOFFFEEDBACK','LongWord').SetUInt( $80);
 CL.AddConstantN('STARTF_USESTDHANDLES','LongWord').SetUInt( $100);
 CL.AddConstantN('STARTF_USEHOTKEY','LongWord').SetUInt( $200);
  //CL.AddTypeS('PProcessInformation', '^TProcessInformation // will not work');
  CL.AddTypeS('TProcessInformation', 'record hProcess : THandle; hThread : THan'
   +'dle; dwProcessId : DWORD; dwThreadId : DWORD; end');
  //CL.AddTypeS('PStartupInfo', '^TStartupInfo // will not work');
  CL.AddTypeS('TStartupInfo', 'record cb : DWORD; lpReserved : ___Pointer; lpDeskt'
   +'op : ___Pointer; lpTitle : ___Pointer; dwX : DWORD; dwY : DWORD; dwXSize : DWORD'
   +'; dwYSize : DWORD; dwXCountChars : DWORD; dwYCountChars : DWORD; dwFillAtt'
   +'ribute : DWORD; dwFlags : DWORD; wShowWindow : Word; cbReserved2 : Word; l'
   +'pReserved2 : ___Pointer; hStdInput : THandle; hStdOutput : THandle; hStdError : THandle; end');
   CL.AddDelphiFunction('Function CreateProcessAsUser(hToken : THandle; lpApplicationName : PKOLChar; lpCommandLine : PKOLChar; lpProcessAttributes : ___pointer; lpThreadAttributes : ___pointer;'
                         +'bInheritHandles : BOOL; dwCreationFlags : DWORD; lpEnvironment : ___Pointer; lpCurrentDirectory : PKOLChar; const lpStartupInfo : TStartupInfo; var lpProcessInformation : integer): BOOL');
  CL.AddDelphiFunction('Function wCreateProcess( lpApplicationName : PKOLChar; lpCommandLine : PKOLChar; lpProcessAttributes, lpThreadAttributes : PSecurityAttributes; bInheritHandles : BOOL; dwCreationFlags : DWORD; lpEnvironment : PSecurityAttributes;'
                  +'lpCurrentDirectory : PKOLChar; const lpStartupInfo : TStartupInfo; var lpProcessInformation : TProcessInformation) : BOOL');
  CL.AddDelphiFunction('Function CreateProcess(lpApplicationName: PChar; lpCommandLine: PChar; lpProcessAttributes, lpThreadAttributes : TObject; bInheritHandles : BOOL; dwCreationFlags : DWORD; lpEnvironment : TObject;'+
                      ' lpCurrentDirectory : PChar; const lpStartupInfo : TStartupInfo; var lpProcessInformation : TProcessInformation) : BOOL');


  SIRegister_TProcess(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TProcessWindowWidth_W(Self: TProcess; const T: Cardinal);
begin Self.WindowWidth := T; end;

(*----------------------------------------------------------------------------*)
procedure TProcessWindowWidth_R(Self: TProcess; var T: Cardinal);
begin T := Self.WindowWidth; end;

(*----------------------------------------------------------------------------*)
procedure TProcessWindowTop_W(Self: TProcess; const T: Cardinal);
begin Self.WindowTop := T; end;

(*----------------------------------------------------------------------------*)
procedure TProcessWindowTop_R(Self: TProcess; var T: Cardinal);
begin T := Self.WindowTop; end;

(*----------------------------------------------------------------------------*)
procedure TProcessWindowRows_W(Self: TProcess; const T: Cardinal);
begin Self.WindowRows := T; end;

(*----------------------------------------------------------------------------*)
procedure TProcessWindowRows_R(Self: TProcess; var T: Cardinal);
begin T := Self.WindowRows; end;

(*----------------------------------------------------------------------------*)
procedure TProcessWindowLeft_W(Self: TProcess; const T: Cardinal);
begin Self.WindowLeft := T; end;

(*----------------------------------------------------------------------------*)
procedure TProcessWindowLeft_R(Self: TProcess; var T: Cardinal);
begin T := Self.WindowLeft; end;

(*----------------------------------------------------------------------------*)
procedure TProcessWindowHeight_W(Self: TProcess; const T: Cardinal);
begin Self.WindowHeight := T; end;

(*----------------------------------------------------------------------------*)
procedure TProcessWindowHeight_R(Self: TProcess; var T: Cardinal);
begin T := Self.WindowHeight; end;

(*----------------------------------------------------------------------------*)
procedure TProcessWindowColumns_W(Self: TProcess; const T: Cardinal);
begin Self.WindowColumns := T; end;

(*----------------------------------------------------------------------------*)
procedure TProcessWindowColumns_R(Self: TProcess; var T: Cardinal);
begin T := Self.WindowColumns; end;

(*----------------------------------------------------------------------------*)
procedure TProcessThreadAttributes_W(Self: TProcess; const T: TSecurityAttributes);
begin Self.ThreadAttributes := T; end;

(*----------------------------------------------------------------------------*)
procedure TProcessThreadAttributes_R(Self: TProcess; var T: TSecurityAttributes);
begin T := Self.ThreadAttributes; end;

(*----------------------------------------------------------------------------*)
procedure TProcessShowWindow_W(Self: TProcess; const T: TShowWindowOptions);
begin Self.ShowWindow := T; end;

(*----------------------------------------------------------------------------*)
procedure TProcessShowWindow_R(Self: TProcess; var T: TShowWindowOptions);
begin T := Self.ShowWindow; end;

(*----------------------------------------------------------------------------*)
procedure TProcessRunning_R(Self: TProcess; var T: Boolean);
begin T := Self.Running; end;

(*----------------------------------------------------------------------------*)
procedure TProcessStartUpOptions_W(Self: TProcess; const T: TStartUpOptions);
begin Self.StartUpOptions := T; end;

(*----------------------------------------------------------------------------*)
procedure TProcessStartUpOptions_R(Self: TProcess; var T: TStartUpOptions);
begin T := Self.StartUpOptions; end;

(*----------------------------------------------------------------------------*)
procedure TProcessPriority_W(Self: TProcess; const T: TProcessPriority);
begin Self.Priority := T; end;

(*----------------------------------------------------------------------------*)
procedure TProcessPriority_R(Self: TProcess; var T: TProcessPriority);
begin T := Self.Priority; end;

(*----------------------------------------------------------------------------*)
procedure TProcessOptions_W(Self: TProcess; const T: TProcessOptions);
begin Self.Options := T; end;

(*----------------------------------------------------------------------------*)
procedure TProcessOptions_R(Self: TProcess; var T: TProcessOptions);
begin T := Self.Options; end;

(*----------------------------------------------------------------------------*)
procedure TProcessInheritHandles_W(Self: TProcess; const T: LongBool);
begin Self.InheritHandles := T; end;

(*----------------------------------------------------------------------------*)
procedure TProcessInheritHandles_R(Self: TProcess; var T: LongBool);
begin T := Self.InheritHandles; end;

(*----------------------------------------------------------------------------*)
procedure TProcessFillAttribute_W(Self: TProcess; const T: Cardinal);
begin Self.FillAttribute := T; end;

(*----------------------------------------------------------------------------*)
procedure TProcessFillAttribute_R(Self: TProcess; var T: Cardinal);
begin T := Self.FillAttribute; end;

(*----------------------------------------------------------------------------*)
procedure TProcessEnvironment_W(Self: TProcess; const T: TStrings);
begin Self.Environment := T; end;

(*----------------------------------------------------------------------------*)
procedure TProcessEnvironment_R(Self: TProcess; var T: TStrings);
begin T := Self.Environment; end;

(*----------------------------------------------------------------------------*)
procedure TProcessDeskTop_W(Self: TProcess; const T: String);
begin Self.DeskTop := T; end;

(*----------------------------------------------------------------------------*)
procedure TProcessDeskTop_R(Self: TProcess; var T: String);
begin T := Self.DeskTop; end;

(*----------------------------------------------------------------------------*)
procedure TProcessCurrentDirectory_W(Self: TProcess; const T: String);
begin Self.CurrentDirectory := T; end;

(*----------------------------------------------------------------------------*)
procedure TProcessCurrentDirectory_R(Self: TProcess; var T: String);
begin T := Self.CurrentDirectory; end;

(*----------------------------------------------------------------------------*)
procedure TProcessConsoleTitle_W(Self: TProcess; const T: String);
begin Self.ConsoleTitle := T; end;

(*----------------------------------------------------------------------------*)
procedure TProcessConsoleTitle_R(Self: TProcess; var T: String);
begin T := Self.ConsoleTitle; end;

(*----------------------------------------------------------------------------*)
procedure TProcessCommandLine_W(Self: TProcess; const T: String);
begin Self.CommandLine := T; end;

(*----------------------------------------------------------------------------*)
procedure TProcessCommandLine_R(Self: TProcess; var T: String);
begin T := Self.CommandLine; end;

(*----------------------------------------------------------------------------*)
procedure TProcessApplicationName_W(Self: TProcess; const T: String);
begin Self.ApplicationName := T; end;

(*----------------------------------------------------------------------------*)
procedure TProcessApplicationName_R(Self: TProcess; var T: String);
begin T := Self.ApplicationName; end;

(*----------------------------------------------------------------------------*)
procedure TProcessActive_W(Self: TProcess; const T: Boolean);
begin Self.Active := T; end;

(*----------------------------------------------------------------------------*)
procedure TProcessActive_R(Self: TProcess; var T: Boolean);
begin T := Self.Active; end;

(*----------------------------------------------------------------------------*)
procedure TProcessExitStatus_R(Self: TProcess; var T: Integer);
begin T := Self.ExitStatus; end;

(*----------------------------------------------------------------------------*)
procedure TProcessStdErr_R(Self: TProcess; var T: TinputPipeStream);
begin T := Self.StdErr; end;

(*----------------------------------------------------------------------------*)
procedure TProcessOutPut_R(Self: TProcess; var T: TInputPipeStream);
begin T := Self.OutPut; end;

(*----------------------------------------------------------------------------*)
procedure TProcessInput_R(Self: TProcess; var T: TOutPutPipeStream);
begin T := Self.Input; end;

(*----------------------------------------------------------------------------*)
procedure TProcessThreadHandle_R(Self: TProcess; var T: THandle);
begin T := Self.ThreadHandle; end;

(*----------------------------------------------------------------------------*)
procedure TProcessHandle_R(Self: TProcess; var T: THandle);
begin T := Self.Handle; end;

(*----------------------------------------------------------------------------*)
procedure TProcessProcessInformation_R(Self: TProcess; var T: TProcessInformation);
begin T := Self.ProcessInformation; end;

(*----------------------------------------------------------------------------*)
procedure TProcessProcessAttributes_W(Self: TProcess; const T: TSecurityAttributes);
begin Self.ProcessAttributes := T; end;

(*----------------------------------------------------------------------------*)
procedure TProcessProcessAttributes_R(Self: TProcess; var T: TSecurityAttributes);
begin T := Self.ProcessAttributes; end;

(*----------------------------------------------------------------------------*)
procedure TProcessStartupInfo_R(Self: TProcess; var T: TStartupInfo);
begin T := Self.StartupInfo; end;

(*----------------------------------------------------------------------------*)
procedure TProcessWindowRect_W(Self: TProcess; const T: Trect);
begin Self.WindowRect := T; end;

(*----------------------------------------------------------------------------*)
procedure TProcessWindowRect_R(Self: TProcess; var T: Trect);
begin T := Self.WindowRect; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TProcess(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TProcess) do begin
    RegisterConstructor(@TProcess.Create, 'Create');
     RegisterMethod(@TProcess.Destroy, 'Free');
      RegisterVirtualMethod(@TProcess.Execute, 'Execute');
    RegisterVirtualMethod(@TProcess.Resume, 'Resume');
    RegisterVirtualMethod(@TProcess.Suspend, 'Suspend');
    RegisterVirtualMethod(@TProcess.Terminate, 'Terminate');
    RegisterMethod(@TProcess.WaitOnExit, 'WaitOnExit');
    RegisterPropertyHelper(@TProcessWindowRect_R,@TProcessWindowRect_W,'WindowRect');
    RegisterPropertyHelper(@TProcessStartupInfo_R,nil,'StartupInfo');
    RegisterPropertyHelper(@TProcessProcessAttributes_R,@TProcessProcessAttributes_W,'ProcessAttributes');
    RegisterPropertyHelper(@TProcessProcessInformation_R,nil,'ProcessInformation');
    RegisterPropertyHelper(@TProcessHandle_R,nil,'Handle');
    RegisterPropertyHelper(@TProcessThreadHandle_R,nil,'ThreadHandle');
    RegisterPropertyHelper(@TProcessInput_R,nil,'Input');
    RegisterPropertyHelper(@TProcessOutPut_R,nil,'OutPut');
    RegisterPropertyHelper(@TProcessStdErr_R,nil,'StdErr');
    RegisterPropertyHelper(@TProcessExitStatus_R,nil,'ExitStatus');
    RegisterPropertyHelper(@TProcessActive_R,@TProcessActive_W,'Active');
    RegisterPropertyHelper(@TProcessApplicationName_R,@TProcessApplicationName_W,'ApplicationName');
    RegisterPropertyHelper(@TProcessCommandLine_R,@TProcessCommandLine_W,'CommandLine');
    RegisterPropertyHelper(@TProcessCommandLine_R,@TProcessCommandLine_W,'Executable');   //alias
    RegisterPropertyHelper(@TProcessConsoleTitle_R,@TProcessConsoleTitle_W,'ConsoleTitle');
    RegisterPropertyHelper(@TProcessCurrentDirectory_R,@TProcessCurrentDirectory_W,'CurrentDirectory');
    RegisterPropertyHelper(@TProcessDeskTop_R,@TProcessDeskTop_W,'DeskTop');
    RegisterPropertyHelper(@TProcessEnvironment_R,@TProcessEnvironment_W,'Environment');
    RegisterPropertyHelper(@TProcessFillAttribute_R,@TProcessFillAttribute_W,'FillAttribute');
    RegisterPropertyHelper(@TProcessInheritHandles_R,@TProcessInheritHandles_W,'InheritHandles');
    RegisterPropertyHelper(@TProcessOptions_R,@TProcessOptions_W,'Options');
    RegisterPropertyHelper(@TProcessPriority_R,@TProcessPriority_W,'Priority');
    RegisterPropertyHelper(@TProcessStartUpOptions_R,@TProcessStartUpOptions_W,'StartUpOptions');
    RegisterPropertyHelper(@TProcessRunning_R,nil,'Running');
    RegisterPropertyHelper(@TProcessShowWindow_R,@TProcessShowWindow_W,'ShowWindow');
    RegisterPropertyHelper(@TProcessThreadAttributes_R,@TProcessThreadAttributes_W,'ThreadAttributes');
    RegisterPropertyHelper(@TProcessWindowColumns_R,@TProcessWindowColumns_W,'WindowColumns');
    RegisterPropertyHelper(@TProcessWindowHeight_R,@TProcessWindowHeight_W,'WindowHeight');
    RegisterPropertyHelper(@TProcessWindowLeft_R,@TProcessWindowLeft_W,'WindowLeft');
    RegisterPropertyHelper(@TProcessWindowRows_R,@TProcessWindowRows_W,'WindowRows');
    RegisterPropertyHelper(@TProcessWindowTop_R,@TProcessWindowTop_W,'WindowTop');
    RegisterPropertyHelper(@TProcessWindowWidth_R,@TProcessWindowWidth_W,'WindowWidth');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_process(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TProcess(CL);
end;

 
 
{ TPSImport_process }
(*----------------------------------------------------------------------------*)
procedure TPSImport_process.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_process(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_process.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_process(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
