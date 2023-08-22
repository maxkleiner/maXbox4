unit uPSI_PJConsoleApp;
{
   timeslice   seconde     , fix add properties
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
  TPSImport_PJConsoleApp = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TPJConsoleApp(CL: TPSPascalCompiler);
procedure SIRegister_TPJCustomConsoleApp(CL: TPSPascalCompiler);
procedure SIRegister_PJConsoleApp(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TPJConsoleApp(CL: TPSRuntimeClassImporter);
procedure RIRegister_TPJCustomConsoleApp(CL: TPSRuntimeClassImporter);
procedure RIRegister_PJConsoleApp_Routines(S: TPSExec);

procedure Register;

implementation


uses
   Windows
  ,Graphics
  ,Types
  ,PJConsoleApp
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_PJConsoleApp]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TPJConsoleApp(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TPJCustomConsoleApp', 'TPJConsoleApp') do
  with CL.AddClassN(CL.FindClass('TPJCustomConsoleApp'),'TPJConsoleApp') do
  begin
    RegisterPublishedProperties;
    RegisterProperty('StdIn', 'THandle', iptrw);
    RegisterProperty('StdOut', 'THandle', iptrw);
    RegisterProperty('StdErr', 'THandle', iptrw);
    RegisterProperty('CommandLine', 'string', iptrw);
    RegisterProperty('CurrentDir', 'string', iptrw);
    RegisterProperty('Visible', 'Boolean', iptrw);
    RegisterProperty('MaxExecTime', 'LongWord', iptrw);
    RegisterProperty('TimeSlice', 'LongWord', iptrw);
    RegisterProperty('KillTimedOutProcess', 'Boolean', iptrw);
    RegisterProperty('ProcessAttrs', 'PSecurityAttributes', iptrw);
    RegisterProperty('ThreadAttrs', 'PSecurityAttributes', iptrw);
    RegisterProperty('UseNewConsole', 'Boolean', iptrw);
    RegisterProperty('ConsoleTitle', 'string', iptrw);
    RegisterProperty('ConsoleColors', 'TPJConsoleColors', iptrw);
    RegisterProperty('ScreenBufferSize', 'TSize', iptrw);
    RegisterProperty('WindowPosition', 'TPoint', iptrw);
    RegisterProperty('WindowSize', 'TSize', iptrw);
    RegisterProperty('Environment', 'Pointer', iptrw);
    RegisterProperty('UnicodeEnvironment', 'Boolean', iptrw);
    RegisterProperty('Priority', 'TPJConsoleAppPriority', iptrw);
    RegisterProperty('TimeToLive', 'LongWord', iptr);
    RegisterProperty('ElapsedTime', 'LongWord', iptr);
    RegisterProperty('ProcessInfo', 'TProcessInformation', iptr);
    RegisterProperty('ExitCode', 'LongWord', iptr);
    RegisterProperty('ErrorCode', 'LongWord', iptr);
    RegisterProperty('ErrorMessage', 'string', iptr);
    RegisterProperty('OnStart', 'TNotifyEvent', iptrw);
    RegisterProperty('OnWork', 'TNotifyEvent', iptrw);
    RegisterProperty('OnComplete', 'TNotifyEvent', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TPJCustomConsoleApp(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TObject', 'TPJCustomConsoleApp') do
  with CL.AddClassN(CL.FindClass('TObject'),'TPJCustomConsoleApp') do begin
    RegisterMethod('Constructor Create');
    RegisterMethod('Procedure Free');
    RegisterMethod('Function Execute( const CmdLine : string; const CurrentDir : string) : Boolean;');
    RegisterMethod('Function Execute1 : Boolean;');
    RegisterMethod('Procedure Terminate');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_PJConsoleApp(CL: TPSPascalCompiler);
begin
 CL.AddConstantN('cOneSecInMS','LongInt').SetInt( 1000);
 CL.AddConstantN('cOneMinInMS','longint').Setint(60 * 1000);
 CL.AddConstantN('cDefTimeSlice','LongInt').SetInt( 50);
 CL.AddConstantN('cDefMaxExecTime','longint').SetInt(60 * 1000);
 CL.AddConstantN('cAppErrorMask','LongInt').SetInt( 1 shl 29);
 CL.AddDelphiFunction('Function IsApplicationError( const ErrCode : LongWord) : Boolean');
  CL.AddTypeS('TPJConsoleAppPriority', '( cpDefault, cpHigh, cpNormal, cpIdle, cpRealTime )');
  CL.AddTypeS('TPJConsoleColor','TColor');
  CL.AddTypeS('TPJConsoleColors', 'record Foreground : TPJConsoleColor; Background : TPJConsoleColor; end');
 CL.AddDelphiFunction('Function MakeConsoleColors( const AForeground, ABackground : TPJConsoleColor) : TPJConsoleColors;');
 CL.AddDelphiFunction('Function MakeConsoleColors1( const AForeground, ABackground : TColor) : TPJConsoleColors;');
 CL.AddDelphiFunction('Function MakeConsoleColors2( const AForeground, ABackground : TColor) : TPJConsoleColors;');
 CL.AddDelphiFunction('Function MakeSize( const ACX, ACY : LongInt) : TSize');
  SIRegister_TPJCustomConsoleApp(CL);
  SIRegister_TPJConsoleApp(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
Function TPJCustomConsoleAppExecute1_P(Self: TPJCustomConsoleApp) : Boolean;
Begin Result := Self.Execute; END;

(*----------------------------------------------------------------------------*)
Function TPJCustomConsoleAppExecute_P(Self: TPJCustomConsoleApp;  const CmdLine : string; const CurrentDir : string) : Boolean;
Begin Result := Self.Execute(CmdLine, CurrentDir); END;

(*----------------------------------------------------------------------------*)
Function MakeConsoleColors2_P( const AForeground, ABackground : TColor) : TPJConsoleColors;
Begin Result := PJConsoleApp.MakeConsoleColors(AForeground, ABackground); END;

(*----------------------------------------------------------------------------*)
Function MakeConsoleColors1_P( const AForeground, ABackground : TColor) : TPJConsoleColors;
Begin Result := PJConsoleApp.MakeConsoleColors(AForeground, ABackground); END;

(*----------------------------------------------------------------------------*)
Function MakeConsoleColors_P( const AForeground, ABackground : TPJConsoleColor) : TPJConsoleColors;
Begin Result := PJConsoleApp.MakeConsoleColors(AForeground, ABackground); END;

 //bug fix add properites
(*----------------------------------------------------------------------------*)
procedure TPJCustomConsoleAppOnComplete_W(Self: TPJConsoleApp; const T: TNotifyEvent);
begin Self.OnComplete := T; end;

(*----------------------------------------------------------------------------*)
procedure TPJCustomConsoleAppOnComplete_R(Self: TPJConsoleApp; var T: TNotifyEvent);
begin T := Self.OnComplete; end;

(*----------------------------------------------------------------------------*)
procedure TPJCustomConsoleAppOnWork_W(Self: TPJConsoleApp; const T: TNotifyEvent);
begin Self.OnWork := T; end;

(*----------------------------------------------------------------------------*)
procedure TPJCustomConsoleAppOnWork_R(Self: TPJConsoleApp; var T: TNotifyEvent);
begin T := Self.OnWork; end;

(*----------------------------------------------------------------------------*)
procedure TPJCustomConsoleAppOnStart_W(Self: TPJConsoleApp; const T: TNotifyEvent);
begin Self.OnStart := T; end;

(*----------------------------------------------------------------------------*)
procedure TPJCustomConsoleAppOnStart_R(Self: TPJConsoleApp; var T: TNotifyEvent);
begin T := Self.OnStart; end;

(*----------------------------------------------------------------------------*)
procedure TPJCustomConsoleAppErrorMessage_R(Self: TPJConsoleApp; var T: string);
begin T := Self.ErrorMessage; end;

(*----------------------------------------------------------------------------*)
procedure TPJCustomConsoleAppErrorCode_R(Self: TPJConsoleApp; var T: LongWord);
begin T := Self.ErrorCode; end;

(*----------------------------------------------------------------------------*)
procedure TPJCustomConsoleAppExitCode_R(Self: TPJConsoleApp; var T: LongWord);
begin T := Self.ExitCode; end;

(*----------------------------------------------------------------------------*)
procedure TPJCustomConsoleAppProcessInfo_R(Self: TPJConsoleApp; var T: TProcessInformation);
begin T := Self.ProcessInfo; end;

(*----------------------------------------------------------------------------*)
procedure TPJCustomConsoleAppElapsedTime_R(Self: TPJConsoleApp; var T: LongWord);
begin T := Self.ElapsedTime; end;

(*----------------------------------------------------------------------------*)
procedure TPJCustomConsoleAppTimeToLive_R(Self: TPJConsoleApp; var T: LongWord);
begin T := Self.TimeToLive; end;

(*----------------------------------------------------------------------------*)
procedure TPJCustomConsoleAppPriority_W(Self: TPJConsoleApp; const T: TPJConsoleAppPriority);
begin Self.Priority := T; end;

(*----------------------------------------------------------------------------*)
procedure TPJCustomConsoleAppPriority_R(Self: TPJConsoleApp; var T: TPJConsoleAppPriority);
begin T := Self.Priority; end;

(*----------------------------------------------------------------------------*)
procedure TPJCustomConsoleAppUnicodeEnvironment_W(Self: TPJConsoleApp; const T: Boolean);
begin //Self.UnicodeEnvironment := T;
end;

(*----------------------------------------------------------------------------*)
procedure TPJCustomConsoleAppUnicodeEnvironment_R(Self: TPJConsoleApp; var T: Boolean);
begin //T := Self.UnicodeEnvironment;
end;

(*----------------------------------------------------------------------------*)
procedure TPJCustomConsoleAppEnvironment_W(Self: TPJConsoleApp; const T: Pointer);
begin Self.Environment := T; end;

(*----------------------------------------------------------------------------*)
procedure TPJCustomConsoleAppEnvironment_R(Self: TPJConsoleApp; var T: Pointer);
begin T := Self.Environment; end;

(*----------------------------------------------------------------------------*)
procedure TPJCustomConsoleAppWindowSize_W(Self: TPJConsoleApp; const T: TSize);
begin Self.WindowSize := T; end;

(*----------------------------------------------------------------------------*)
procedure TPJCustomConsoleAppWindowSize_R(Self: TPJConsoleApp; var T: TSize);
begin T := Self.WindowSize; end;

(*----------------------------------------------------------------------------*)
procedure TPJCustomConsoleAppWindowPosition_W(Self: TPJConsoleApp; const T: TPoint);
begin Self.WindowPosition := T; end;

(*----------------------------------------------------------------------------*)
procedure TPJCustomConsoleAppWindowPosition_R(Self: TPJConsoleApp; var T: TPoint);
begin T := Self.WindowPosition; end;

(*----------------------------------------------------------------------------*)
procedure TPJCustomConsoleAppScreenBufferSize_W(Self: TPJConsoleApp; const T: TSize);
begin Self.ScreenBufferSize := T; end;

(*----------------------------------------------------------------------------*)
procedure TPJCustomConsoleAppScreenBufferSize_R(Self: TPJConsoleApp; var T: TSize);
begin T := Self.ScreenBufferSize; end;

(*----------------------------------------------------------------------------*)
procedure TPJCustomConsoleAppConsoleColors_W(Self: TPJConsoleApp; const T: TPJConsoleColors);
begin Self.ConsoleColors := T; end;

(*----------------------------------------------------------------------------*)
procedure TPJCustomConsoleAppConsoleColors_R(Self: TPJConsoleApp; var T: TPJConsoleColors);
begin T := Self.ConsoleColors; end;

(*----------------------------------------------------------------------------*)
procedure TPJCustomConsoleAppConsoleTitle_W(Self: TPJConsoleApp; const T: string);
begin Self.ConsoleTitle := T; end;

(*----------------------------------------------------------------------------*)
procedure TPJCustomConsoleAppConsoleTitle_R(Self: TPJConsoleApp; var T: string);
begin T := Self.ConsoleTitle; end;

(*----------------------------------------------------------------------------*)
procedure TPJCustomConsoleAppUseNewConsole_W(Self: TPJConsoleApp; const T: Boolean);
begin Self.UseNewConsole := T; end;

(*----------------------------------------------------------------------------*)
procedure TPJCustomConsoleAppUseNewConsole_R(Self: TPJConsoleApp; var T: Boolean);
begin T := Self.UseNewConsole; end;

(*----------------------------------------------------------------------------*)
procedure TPJCustomConsoleAppThreadAttrs_W(Self: TPJConsoleApp; const T: PSecurityAttributes);
begin Self.ThreadAttrs := T; end;

(*----------------------------------------------------------------------------*)
procedure TPJCustomConsoleAppThreadAttrs_R(Self: TPJConsoleApp; var T: PSecurityAttributes);
begin T := Self.ThreadAttrs; end;

(*----------------------------------------------------------------------------*)
procedure TPJCustomConsoleAppProcessAttrs_W(Self: TPJConsoleApp; const T: PSecurityAttributes);
begin Self.ProcessAttrs := T; end;

(*----------------------------------------------------------------------------*)
procedure TPJCustomConsoleAppProcessAttrs_R(Self: TPJConsoleApp; var T: PSecurityAttributes);
begin T := Self.ProcessAttrs; end;

(*----------------------------------------------------------------------------*)
procedure TPJCustomConsoleAppKillTimedOutProcess_W(Self: TPJConsoleApp; const T: Boolean);
begin Self.KillTimedOutProcess := T; end;

(*----------------------------------------------------------------------------*)
procedure TPJCustomConsoleAppKillTimedOutProcess_R(Self: TPJConsoleApp; var T: Boolean);
begin T := Self.KillTimedOutProcess; end;

(*----------------------------------------------------------------------------*)
procedure TPJCustomConsoleAppTimeSlice_W(Self: TPJConsoleApp; const T: LongWord);
begin Self.TimeSlice := T; end;

(*----------------------------------------------------------------------------*)
procedure TPJCustomConsoleAppTimeSlice_R(Self: TPJConsoleApp; var T: LongWord);
begin T := Self.TimeSlice; end;

(*----------------------------------------------------------------------------*)
procedure TPJCustomConsoleAppMaxExecTime_W(Self: TPJConsoleApp; const T: LongWord);
begin Self.MaxExecTime := T; end;

(*----------------------------------------------------------------------------*)
procedure TPJCustomConsoleAppMaxExecTime_R(Self: TPJConsoleApp; var T: LongWord);
begin T := Self.MaxExecTime; end;

(*----------------------------------------------------------------------------*)
procedure TPJCustomConsoleAppVisible_W(Self: TPJConsoleApp; const T: Boolean);
begin Self.Visible := T; end;

(*----------------------------------------------------------------------------*)
procedure TPJCustomConsoleAppVisible_R(Self: TPJConsoleApp; var T: Boolean);
begin T := Self.Visible; end;

(*----------------------------------------------------------------------------*)
procedure TPJCustomConsoleAppCurrentDir_W(Self: TPJConsoleApp; const T: string);
begin Self.CurrentDir := T; end;

(*----------------------------------------------------------------------------*)
procedure TPJCustomConsoleAppCurrentDir_R(Self: TPJConsoleApp; var T: string);
begin T := Self.CurrentDir; end;

(*----------------------------------------------------------------------------*)
procedure TPJCustomConsoleAppCommandLine_W(Self: TPJConsoleApp; const T: string);
begin Self.CommandLine := T; end;

(*----------------------------------------------------------------------------*)
procedure TPJCustomConsoleAppCommandLine_R(Self: TPJConsoleApp; var T: string);
begin T := Self.CommandLine; end;

(*----------------------------------------------------------------------------*)
procedure TPJCustomConsoleAppStdErr_W(Self: TPJConsoleApp; const T: THandle);
begin Self.StdErr := T; end;

(*----------------------------------------------------------------------------*)
procedure TPJCustomConsoleAppStdErr_R(Self: TPJConsoleApp; var T: THandle);
begin T := Self.StdErr; end;

(*----------------------------------------------------------------------------*)
procedure TPJCustomConsoleAppStdOut_W(Self: TPJConsoleApp; const T: THandle);
begin Self.StdOut := T; end;

(*----------------------------------------------------------------------------*)
procedure TPJCustomConsoleAppStdOut_R(Self: TPJConsoleApp; var T: THandle);
begin T := Self.StdOut; end;

(*----------------------------------------------------------------------------*)
procedure TPJCustomConsoleAppStdIn_W(Self: TPJConsoleApp; const T: THandle);
begin Self.StdIn := T; end;

(*----------------------------------------------------------------------------*)
procedure TPJCustomConsoleAppStdIn_R(Self: TPJConsoleApp; var T: THandle);
begin T := Self.StdIn; end;
// end fix


(*----------------------------------------------------------------------------*)
procedure RIRegister_TPJConsoleApp(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TPJConsoleApp) do begin

  RegisterPropertyHelper(@TPJCustomConsoleAppStdIn_R,@TPJCustomConsoleAppStdIn_W,'StdIn');
    RegisterPropertyHelper(@TPJCustomConsoleAppStdOut_R,@TPJCustomConsoleAppStdOut_W,'StdOut');
    RegisterPropertyHelper(@TPJCustomConsoleAppStdErr_R,@TPJCustomConsoleAppStdErr_W,'StdErr');
    RegisterPropertyHelper(@TPJCustomConsoleAppCommandLine_R,@TPJCustomConsoleAppCommandLine_W,'CommandLine');
    RegisterPropertyHelper(@TPJCustomConsoleAppCurrentDir_R,@TPJCustomConsoleAppCurrentDir_W,'CurrentDir');
    RegisterPropertyHelper(@TPJCustomConsoleAppVisible_R,@TPJCustomConsoleAppVisible_W,'Visible');
    RegisterPropertyHelper(@TPJCustomConsoleAppMaxExecTime_R,@TPJCustomConsoleAppMaxExecTime_W,'MaxExecTime');
    RegisterPropertyHelper(@TPJCustomConsoleAppTimeSlice_R,@TPJCustomConsoleAppTimeSlice_W,'TimeSlice');
    RegisterPropertyHelper(@TPJCustomConsoleAppKillTimedOutProcess_R,@TPJCustomConsoleAppKillTimedOutProcess_W,'KillTimedOutProcess');
    RegisterPropertyHelper(@TPJCustomConsoleAppProcessAttrs_R,@TPJCustomConsoleAppProcessAttrs_W,'ProcessAttrs');
    RegisterPropertyHelper(@TPJCustomConsoleAppThreadAttrs_R,@TPJCustomConsoleAppThreadAttrs_W,'ThreadAttrs');
    RegisterPropertyHelper(@TPJCustomConsoleAppUseNewConsole_R,@TPJCustomConsoleAppUseNewConsole_W,'UseNewConsole');
    RegisterPropertyHelper(@TPJCustomConsoleAppConsoleTitle_R,@TPJCustomConsoleAppConsoleTitle_W,'ConsoleTitle');
    RegisterPropertyHelper(@TPJCustomConsoleAppConsoleColors_R,@TPJCustomConsoleAppConsoleColors_W,'ConsoleColors');
    RegisterPropertyHelper(@TPJCustomConsoleAppScreenBufferSize_R,@TPJCustomConsoleAppScreenBufferSize_W,'ScreenBufferSize');
    RegisterPropertyHelper(@TPJCustomConsoleAppWindowPosition_R,@TPJCustomConsoleAppWindowPosition_W,'WindowPosition');
    RegisterPropertyHelper(@TPJCustomConsoleAppWindowSize_R,@TPJCustomConsoleAppWindowSize_W,'WindowSize');
    RegisterPropertyHelper(@TPJCustomConsoleAppEnvironment_R,@TPJCustomConsoleAppEnvironment_W,'Environment');
    RegisterPropertyHelper(@TPJCustomConsoleAppUnicodeEnvironment_R,@TPJCustomConsoleAppUnicodeEnvironment_W,'UnicodeEnvironment');
    RegisterPropertyHelper(@TPJCustomConsoleAppPriority_R,@TPJCustomConsoleAppPriority_W,'Priority');
    RegisterPropertyHelper(@TPJCustomConsoleAppTimeToLive_R,nil,'TimeToLive');
    RegisterPropertyHelper(@TPJCustomConsoleAppElapsedTime_R,nil,'ElapsedTime');
    RegisterPropertyHelper(@TPJCustomConsoleAppProcessInfo_R,nil,'ProcessInfo');
    RegisterPropertyHelper(@TPJCustomConsoleAppExitCode_R,nil,'ExitCode');
    RegisterPropertyHelper(@TPJCustomConsoleAppErrorCode_R,nil,'ErrorCode');
    RegisterPropertyHelper(@TPJCustomConsoleAppErrorMessage_R,nil,'ErrorMessage');
    RegisterPropertyHelper(@TPJCustomConsoleAppOnStart_R,@TPJCustomConsoleAppOnStart_W,'OnStart');
    RegisterPropertyHelper(@TPJCustomConsoleAppOnWork_R,@TPJCustomConsoleAppOnWork_W,'OnWork');
    RegisterPropertyHelper(@TPJCustomConsoleAppOnComplete_R,@TPJCustomConsoleAppOnComplete_W,'OnComplete');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TPJCustomConsoleApp(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TPJCustomConsoleApp) do begin
    RegisterConstructor(@TPJCustomConsoleApp.Create, 'Create');
    RegisterMethod(@TPJCustomConsoleApp.Destroy, 'Free');
    RegisterMethod(@TPJCustomConsoleAppExecute_P, 'Execute');
    RegisterMethod(@TPJCustomConsoleAppExecute1_P, 'Execute1');
    RegisterMethod(@TPJCustomConsoleApp.Terminate, 'Terminate');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_PJConsoleApp_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@IsApplicationError, 'IsApplicationError', cdRegister);
 S.RegisterDelphiFunction(@MakeConsoleColors, 'MakeConsoleColors', cdRegister);
 S.RegisterDelphiFunction(@MakeConsoleColors1_P, 'MakeConsoleColors1', cdRegister);
 S.RegisterDelphiFunction(@MakeConsoleColors2_P, 'MakeConsoleColors2', cdRegister);
 S.RegisterDelphiFunction(@MakeSize, 'MakeSize', cdRegister);
  //RIRegister_TPJCustomConsoleApp(CL);
  //RIRegister_TPJConsoleApp(CL);
end;

 
 
{ TPSImport_PJConsoleApp }
(*----------------------------------------------------------------------------*)
procedure TPSImport_PJConsoleApp.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_PJConsoleApp(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_PJConsoleApp.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  //RIRegister_PJConsoleApp(ri);
  RIRegister_PJConsoleApp_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
