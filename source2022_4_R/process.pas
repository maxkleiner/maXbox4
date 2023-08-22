unit process;

//https://github.com/z505/TProcess-Delphi/blob/master/dprocess.pas

interface

Uses Classes,
     pipes,
{$ifdef linux}
     Libc,
{$else}          
     Windows,
{$endif}     
     SysUtils;

Type
  TProcessOption = (poRunSuspended,poWaitOnExit,
                    poUsePipes,poStderrToOutPut,
                    poNoConsole,poNewConsole,
                    poDefaultErrorMode,poNewProcessGroup,
                    poDebugProcess,poDebugOnlyThisProcess);

  TShowWindowOptions = (swoNone,swoHIDE,swoMaximize,swoMinimize,swoRestore,swoShow,
                        swoShowDefault,swoShowMaximized,swoShowMinimized,
                        swoshowMinNOActive,swoShowNA,swoShowNoActivate,swoShowNormal);

  TStartupOption = (suoUseShowWindow,suoUseSize,suoUsePosition,
                    suoUseCountChars,suoUseFillAttribute);

  TProcessPriority = (ppHigh,ppIdle,ppNormal,ppRealTime);

  TProcessOptions = Set of TPRocessOption;
  TstartUpoptions = set of TStartupOption;

{$ifdef linux}
Const
  STARTF_USESHOWWINDOW    = 1;    // Ignored
  STARTF_USESIZE          = 2;
  STARTF_USEPOSITION      = 4;
  STARTF_USECOUNTCHARS    = 8;    // Ignored
  STARTF_USEFILLATTRIBUTE = $10;
  STARTF_RUNFULLSCREEN    = $20;  // Ignored
  STARTF_FORCEONFEEDBACK  = $40;  // Ignored
  STARTF_FORCEOFFFEEDBACK = $80;  // Ignored
  STARTF_USESTDHANDLES    = $100; // Ignored
  STARTF_USEHOTKEY        = $200; // Ignored

Type
  PPoint = ^TPoint;
  TPoint = packed record
    X: Longint;
    Y: Longint;
  end;

  PRect = ^TRect;
  TRect = packed record
    case Integer of
      0: (Left, Top, Right, Bottom: Longint);
      1: (TopLeft, BottomRight: TPoint);
  end;

  DWord = Longword;
  THandle = Integer;

  PProcessInformation = ^TProcessInformation;
  TProcessInformation = record
    hProcess: THandle;
    hThread: THandle;
    dwProcessId: DWORD;
    dwThreadId: DWORD;
  end;

  PStartupInfo = ^TStartupInfo;
  TStartupInfo = Record
    cb: DWORD;
    lpReserved: Pointer;
    lpDesktop: Pointer;
    lpTitle: Pointer;
    dwX: DWORD;
    dwY: DWORD;
    dwXSize: DWORD;
    dwYSize: DWORD;
    dwXCountChars: DWORD;
    dwYCountChars: DWORD;
    dwFillAttribute: DWORD;
    dwFlags: DWORD;
    wShowWindow: Word;
    cbReserved2: Word;
    lpReserved2: PByte;
    hStdInput: THandle;
    hStdOutput: THandle;
    hStdError: THandle;
  end;
{$endif}

  TProcess = Class (TComponent)
  Private
{$ifndef linux}  
    FAccess : Cardinal;
{$endif}    
    FApplicationName : string;
    FChildErrorStream : TOutPutPipeStream;
    FChildInputSTream : TInputPipeStream;
    FChildOutPutStream : TOutPutPipeStream;
    FConsoleTitle : String;
    FProcessOptions : TProcessOptions;
    FStartUpOptions : TStartupOptions;
    FCommandLine : String;
    FExecutable : String;
    FParameters : TStrings;
    FCurrentDirectory : String;
    FDeskTop : String;
    FEnvironment : Tstrings;
    FExitCode : Cardinal;
    FHandle : THandle;
    FShowWindow : TShowWindowOptions;
    FInherithandles : LongBool;
    FParentErrorStream : TInputPipeStream;
    FParentInputSTream : TInputPipeStream;
    FParentOutputStream : TOutPutPipeStream;
    FRunning : Boolean;
    FThreadAttributes  : PSecurityAttributes;
    FProcessAttributes : PSecurityAttributes;
    FProcessInformation : TProcessInformation;
    FPRocessPriority : TProcessPriority;
    FStartupInfo : TStartupInfo;
    Procedure FreeStreams;
    Function  GetExitStatus : Integer;
    Function  GetHandle : THandle;
    Function  GetRunning : Boolean;
    Function  GetProcessAttributes : TSecurityAttributes;
    Function  GetThreadAttributes : TSecurityAttributes;
    Procedure SetProcessAttributes (Value : TSecurityAttributes);
    Procedure SetThreadAttributes (Value : TSecurityAttributes);
    Function  GetWindowRect : TRect;
    Procedure SetWindowRect (Value : TRect);
    Procedure SetFillAttribute (Value : Cardinal);
    Procedure SetShowWindow (Value : TShowWindowOptions);
    Procedure SetWindowColumns (Value : Cardinal);
    Procedure SetWindowHeight (Value : Cardinal);
    Procedure SetWindowLeft (Value : Cardinal);
    Procedure SetWindowRows (Value : Cardinal);
    Procedure SetWindowTop (Value : Cardinal);
    Procedure SetWindowWidth (Value : Cardinal);
    procedure CreateStreams;
    function GetCreationFlags: Cardinal;
    function GetStartupFlags: Cardinal;
    procedure SetApplicationname(const Value: String);
    procedure SetPRocessOptions(const Value: TProcessOptions);
    procedure SetActive(const Value: Boolean);
    procedure SetEnvironment(const Value: TStrings);
    Procedure ConvertCommandLine;
{$ifdef linux}
    function PeekLinuxExitStatus: Boolean;
{$endif}    
  Public
    Constructor Create (AOwner : TComponent);override;
    Destructor Destroy; override;
    Procedure Execute; virtual;
    Function Resume : Integer; virtual;
    Function Suspend : Integer; virtual;
    Function Terminate (AExitCode : Integer): Boolean; virtual;
    Function WaitOnExit : DWord;
    Property WindowRect : Trect Read GetWindowRect Write SetWindowRect;
    Property StartupInfo : TStartupInfo Read FStartupInfo;
    Property ProcessAttributes : TSecurityAttributes  Read GetProcessAttributes  Write SetProcessAttributes;
    Property ProcessInformation : TProcessInformation Read FPRocessInformation;
    Property Handle : THandle Read FProcessInformation.hProcess;
    Property ThreadHandle : THandle Read FprocessInformation.hThread;
    Property Input  : TOutPutPipeStream Read FParentOutPutStream;
    Property OutPut : TInputPipeStream  Read FParentInputStream;
    Property StdErr : TinputPipeStream  Read FParentErrorStream;
    Property ExitStatus : Integer Read GetExitStatus;
  Published
    Property Active : Boolean Read Getrunning Write SetActive;
    Property ApplicationName : String Read FApplicationname Write SetApplicationname;
    Property CommandLine : String Read FCommandLine Write FCommandLine;
    Property Executable : String Read FExecutable Write FExecutable;
    Property ConsoleTitle : String Read FConsoleTitle Write FConsoleTitle;
    Property CurrentDirectory : String Read FCurrentDirectory Write FCurrentDirectory;
    Property DeskTop : String Read FDeskTop Write FDeskTop;
    Property Environment : TStrings Read FEnvironment Write SetEnvironment;
    Property FillAttribute : Cardinal Read FStartupInfo.dwFillAttribute Write SetFillAttribute;
    Property InheritHandles : LongBool Read FInheritHandles Write FInheritHandles;
    Property Options : TProcessOptions Read FProcessOptions Write SetPRocessOptions;
    Property Priority : TProcessPriority Read FProcessPriority Write FProcessPriority;
    Property StartUpOptions : TStartUpOptions Read FStartUpOptions Write FStartupOptions;
    Property Running : Boolean Read GetRunning;
    Property ShowWindow : TShowWindowOptions Read FShowWindow Write SetShowWindow;
    Property ThreadAttributes : TSecurityAttributes Read GetThreadAttributes Write SetThreadAttributes;
    Property WindowColumns : Cardinal Read FStartupInfo.dwXCountchars Write SetWindowColumns;
    Property WindowHeight : Cardinal Read FStartupInfo.dwYsize Write SetWindowHeight;
    Property WindowLeft : Cardinal Read FStartupInfo.dwx Write SetWindowLeft;
    Property WindowRows : Cardinal Read FStartupInfo.dwYcountChars Write SetWindowRows;
    Property WindowTop : Cardinal Read FStartupInfo.dwy Write SetWindowTop ;
    Property WindowWidth : Cardinal Read FStartupInfo.dwXsize Write SetWindowWidth;
  end;


  Procedure CommandToList(S : String; List : TStrings);

{$ifdef linux}
Const
  PriorityConstants : Array [TProcessPriority] of Integer =
                      (20,20,0,-20);

Var
  GeometryOption : String = '-geometry';
  TitleOption : String ='-title';

{$else}
Const
  PriorityConstants : Array [TProcessPriority] of Cardinal =
                      (HIGH_PRIORITY_CLASS,IDLE_PRIORITY_CLASS,
                       NORMAL_PRIORITY_CLASS,REALTIME_PRIORITY_CLASS);
{$endif}
implementation

Constructor TProcess.Create (AOwner : TComponent);
begin
  Inherited;
{$ifndef linux}
  FAccess:=PROCESS_ALL_ACCESS;
{$endif}
  FProcessPriority:=ppNormal;
  FShowWindow:=swoNone;
  FStartupInfo.cb:=SizeOf(TStartupInfo);
  FInheritHandles:=True;
  FEnvironment:=TStringList.Create;
end;

Destructor TProcess.Destroy;

begin
  If assigned (FProcessAttributes) then Dispose (FPRocessAttributes);
  If assigned (FThreadAttributes) then Dispose (FThreadAttributes);
  FEnvironment.Free;
  FreeStreams;
  Inherited;
end;

Function CharInSet4(C: AnsiChar; const CharSet: TSysCharSet):Bool;
begin
  Result:= C in CharSet;
end;

Procedure CommandToList(S : String; List : TStrings);

  Function GetNextWord : String;

  Const
    WhiteSpace = [' ',#9,#10,#13];
    Literals = ['"',''''];

  Var
    Wstart,wend : Integer;
    InLiteral : Boolean;
    LastLiteral : char;

  begin
    WStart:=1;
    // L505 change "in" to CharInSet
    While (WStart<=Length(S)) and (CharInSet4(S[WStart], WhiteSpace)) do
      Inc(WStart);
    WEnd:=WStart;
    InLiteral:=False;
    LastLiteral:=#0;
    // L505
    // While (Wend<=Length(S)) and (Not (S[Wend] in WhiteSpace) or InLiteral) do
    While (Wend<=Length(S)) and (Not (CharInSet4(S[Wend], WhiteSpace)) or InLiteral) do
      begin
      // L505 changed "in" to CharInSet
      if CharInSet4(S[Wend], Literals) then
        If InLiteral then
          InLiteral:=Not (S[Wend]=LastLiteral)
        else
          begin
          InLiteral:=True;
          LastLiteral:=S[Wend];
          end;
       inc(wend);
       end;

     Result:=Copy(S,WStart,WEnd-WStart);
     // L505 changed "in" to CharInSet
     if  (Length(Result) > 0)
     and (Result[1] = Result[Length(Result)]) // if 1st char = last char and..
     and (CharInSet4(Result[1], Literals)) then // it's one of the literals, then
       Result:=Copy(Result, 2, Length(Result) - 2); //delete the 2 (but not others in it)
     // L505
     // While (WEnd<=Length(S)) and (S[Wend] in WhiteSpace) do
     While (WEnd<=Length(S)) and (CharInSet4(S[Wend], WhiteSpace)) do
       inc(Wend);
     Delete(S,1,WEnd-1);

  end;

Var
  W : String;

begin
  While Length(S)>0 do begin
    W:=GetNextWord;
    If (W<>'') then
      List.Add(W);
    end;
end;


procedure TProcess.ConvertCommandLine;
begin
  FParameters.Clear;
  CommandToList(FCommandLine,FParameters);
  If FParameters.Count>0 then
    begin
    Executable:=FParameters[0];
    FParameters.Delete(0);
    end;
end;

Procedure TProcess.FreeStreams;

begin
  FParentErrorStream.Free;
  FParentInputSTream.Free;
  FParentOutputStream.Free;
  FChildErrorStream.free;
  FChildInputSTream.Free;
  FChildOutPutStream.Free;
end;

Function TProcess.GetExitStatus : Integer;

begin
  If FRunning then
{$ifdef linux}
    PeekLinuxExitStatus;
{$else}
    GetExitCodeProcess(Handle,FExitCode);
{$endif}
  Result:=FExitCode;
end;

Function TProcess.GetHandle : THandle;

begin
{$ifndef linux}
  IF FHandle=0 Then
    FHandle:=OpenProcess (FAccess,True,FProcessInformation.dwProcessId);
{$endif}
  Result:=FHandle
end;

Function TProcess.GetProcessAttributes : TSecurityAttributes;

Var P : PSecurityAttributes;

begin
  IF not Assigned(FProcessAttributes) then
    begin
    // Provide empty dummy value;
    New(p);
    Fillchar(p^,Sizeof(TSecurityAttributes),0);
    Result:=p^;
    end
  else
    REsult:=FProcessAttributes^;
end;

{$ifdef linux}
Function TProcess.PeekLinuxExitStatus : Boolean;

begin
  Result:=WaitPID(Handle,@FExitCode,WNOHANG)=Handle;
  If Result then
    FExitCode:=wexitstatus(FExitCode)
  else
    FexitCode:=0;
end;
{$endif}

Function TProcess.GetRunning : Boolean;

begin
  IF FRunning then
    begin
{$ifdef linux}
    FRunning:=Not PeekLinuxExitStatus;
{$else}
    Frunning:=GetExitStatus=Still_Active;
{$endif}
    end;
  Result:=FRunning;
end;

Function TProcess.GetThreadAttributes : TSecurityAttributes;

Var P : PSecurityAttributes;

begin
  IF not Assigned(FThreadAttributes) then
    begin
    // Provide empty dummy value;
    New(p);
    Fillchar(p^,Sizeof(TSecurityAttributes),0);
    Result:=p^;
    end
  else
    Result:=FThreadAttributes^;
end;

Procedure TProcess.SetProcessAttributes (Value : TSecurityAttributes);

begin
  If not Assigned (FProcessAttributes) then
    New(FProcessAttributes);
  FPRocessAttributes^:=VAlue;
end;

Procedure TProcess.SetThreadAttributes (Value : TSecurityAttributes);

begin
  If not Assigned (FThreadAttributes) then
    New(FThreadAttributes);
  FThreadAttributes^:=VAlue;
end;

Procedure TProcess.CreateStreams;

begin
  FreeStreams;
  CreatePipeStreams (FChildInputSTream,FParentOutPutStream,@piInheritablePipe,1024);
  CreatePipeStreams (FParentInputStream,FChildOutPutStream,@piInheritablePipe,1024);
  if Not (poStdErrToOutPut in FProcessOptions) then
    CreatePipeStreams (FParentErrorStream,FChildErrorStream,@piInheritablePipe,1024)
  else
    begin
    FChildErrorStream:=FChildOutPutStream;
    FParentErrorStream:=FParentInputStream;
    end;
  FStartupInfo.dwFlags:=FStartupInfo.dwFlags or Startf_UseStdHandles;
  FStartupInfo.hStdInput:=FChildInputStream.Handle;
  FStartupInfo.hStdOutput:=FChildOutPutStream.Handle;
  FStartupInfo.hStdError:=FChildErrorStream.Handle;
end;

Function TProcess.GetCreationFlags : Cardinal;

begin
  Result:=0;
{$ifndef linux}
  if poNoConsole in FProcessOptions then
    Result:=Result or Detached_Process;
  if poNewConsole in FProcessOptions then
    Result:=Result or Create_new_console;
  if poNewProcessGroup in FProcessOptions then
    Result:=Result or CREATE_NEW_PROCESS_GROUP;
  If poRunSuspended in FProcessOptions Then
    Result:=Result or Create_Suspended;
  if poDebugProcess in FProcessOptions Then
    Result:=Result or DEBUG_PROCESS;
  if poDebugOnlyThisProcess in FProcessOptions Then
    Result:=Result or DEBUG_ONLY_THIS_PROCESS;
  if poDefaultErrorMode in FProcessOptions Then
    Result:=Result or CREATE_DEFAULT_ERROR_MODE;
  result:=result or PriorityConstants[FProcessPriority];
{$endif}
end;

Function TProcess.GetStartupFlags : Cardinal;

begin
  Result:=0;
  if poUsePipes in FProcessOptions then
     Result:=Result or Startf_UseStdHandles;
  if suoUseShowWindow in FStartupOptions then
    Result:=Result or startf_USESHOWWINDOW;
  if suoUSESIZE in FStartupOptions then
    Result:=Result or startf_usesize;
  if suoUsePosition in FStartupOptions then
    Result:=Result or startf_USEPOSITION;
  if suoUSECOUNTCHARS in FStartupoptions then
    Result:=Result or startf_usecountchars;
  if suoUsefIllAttribute in FStartupOptions then
    Result:=Result or startf_USEFILLATTRIBUTE;
end;

Type
{$ifndef linux}
  PPChar = ^PChar;
{$endif}
  TPCharArray = Array[Word] of pchar;
  PPCharArray = ^TPcharArray;


Function StringsToPCharList(List : TStrings) : PPChar;

Var
  I : Integer;
  S : String;

begin
  I:=(List.Count)+1;
  GetMem(Result,I*sizeOf(PChar));
  PPCharArray(Result)^[List.Count]:=Nil;
  For I:=0 to List.Count-1 do
    begin
    S:=List[i];
    PPCharArray(Result)^[i]:=StrNew(PChar(S));
    end;
end;

Procedure FreePCharList(List : PPChar);

Var
  I : integer;

begin
  I:=0;
  While PPCharArray(List)[i]<>Nil do
    begin
    StrDispose(PPCharArray(List)[i]);
    Inc(I);
    end;
  FreeMem(List);
end;


{$ifdef linux}
Procedure CommandToList(S : String; List : TStrings);

  Function GetNextWord : String;

  Const
    WhiteSpace = [' ',#8,#10];
    Literals = ['"',''''];

  Var
    Wstart,wend : Integer;
    InLiteral : Boolean;
    LastLiteral : char;

  begin
    WStart:=1;
    While (WStart<=Length(S)) and (S[WStart] in WhiteSpace) do
      Inc(WStart);
    WEnd:=WStart;
    InLiteral:=False;
    LastLiteral:=#0;
    While (Wend<=Length(S)) and (Not (S[Wend] in WhiteSpace) or InLiteral) do
      begin
      if S[Wend] in Literals then
        If InLiteral then
          InLiteral:=Not (S[Wend]=LastLiteral)
        else
          begin
          InLiteral:=True;
          LastLiteral:=S[Wend];
          end;
       inc(wend);
       end;
     Result:=Copy(S,WStart,WEnd-WStart);
     Result:=StringReplace(Result,'"','',[rfReplaceAll]);
     Result:=StringReplace(Result,'''','',[rfReplaceAll]);
     While (WEnd<=Length(S)) and (S[Wend] in WhiteSpace) do
       inc(Wend);
     Delete(S,1,WEnd-1);
     
  end;

Var
  W : String;

begin
  While Length(S)>0 do
    begin
    W:=GetNextWord;
    If (W<>'') then
      List.Add(W);
    end;
end;


Function MakeCommand(Var AppName,CommandLine : String;
                     StartupOptions : TStartUpOptions;
                     ProcessOptions : TProcessOptions;
                     StartupInfo : TStartupInfo) : PPchar;
Const
  SNoCommandLine = 'Cannot execute empty command-line';

Var
  S  : TStringList;
  G : String;

begin
  if (AppName='') then
    begin
    If (CommandLine='') then
      Raise Exception.Create(SNoCommandline)
    end
  else
    begin
    If (CommandLine='') then
      CommandLine:=AppName;
    end;
  S:=TStringList.Create;
  try
    CommandToList(CommandLine,S);
    if poNewConsole in ProcessOptions then
      begin
      S.Insert(0,'-e');
      If (AppName<>'') then
        begin
        S.Insert(0,AppName);
        S.Insert(0,'-title');
        end;
      if suoUseCountChars in StartupOptions then
        With StartupInfo do
          begin
          S.Insert(0,Format('%dx%d',[dwXCountChars,dwYCountChars]));
          S.Insert(0,'-geometry');
          end;
      S.Insert(0,'xterm');
      end;
    if (AppName<>'') then
      begin
      S.Add(TitleOption);
      S.Add(AppName);
      end;
    With StartupInfo do
      begin
      G:='';
      if (suoUseSize in StartupOptions) then
        g:=format('%dx%d',[dwXSize,dwYsize]);
      if (suoUsePosition in StartupOptions) then
        g:=g+Format('+%d+%d',[dwX,dwY]);
      if G<>'' then
        begin
        S.Add(GeometryOption);
        S.Add(g);
        end;
      end;
    Result:=StringsToPcharList(S);
    AppName:=S[0];
  Finally
    S.free;
  end;
end;

Function CreateProcess (PName,PCommandLine,PDir : String;
                        FEnv : PPChar;
                        StartupOptions : TStartupOptions;
                        ProcessOptions : TProcessOptions;
                        const FStartupInfo : TStartupInfo;
                        Var ProcessInfo : TProcessInformation)  : boolean;

Var
  PID : Longint;
  Argv : PPChar;
  fd : Integer;

begin
  Result:=True;
  Argv:=MakeCommand(Pname,PCommandLine,StartupOptions,ProcessOptions,FStartupInfo);
  if (pos('/',PName)<>1) then
    PName:=FileSearch(Pname,GetEnv('PATH'));
  Pid:=fork;
  if Pid=0 then
   begin
   { We're in the child }
   if (PDir<>'') then
     ChDir(PDir);
   if PoUsePipes in ProcessOptions then
     begin
     dup2(FStartupInfo.hStdInput,0);
     dup2(FStartupInfo.hStdOutput,1);
     dup2(FStartupInfo.hStdError,2);
     end
   else if poNoConsole in ProcessOptions then
     begin
     fd:=FileOpen('/dev/null',fmOpenReadWrite);
     dup2(fd,0);
     dup2(fd,1);
     dup2(fd,2);
     end;
   if (poRunSuspended in ProcessOptions) then
     __raise(SIGSTOP);
   if FEnv<>Nil then
     libc.Execve(PChar(PName),Argv,Fenv)
   else
     Execv(Pchar(PName),argv);
   Halt(127);
   end
 else
   begin
   FreePcharList(Argv);
   // Copy process information.
   ProcessInfo.hProcess:=PID;
   ProcessInfo.hThread:=PID;
   ProcessInfo.dwProcessId:=PID;
   ProcessInfo.dwThreadId:=PID;
   end;
end;
{$endif}

Procedure TProcess.Execute;


Var
{$ifndef linux}
  PName,PDir,PCommandLine : PChar;
{$endif}
  FEnv : PPChar;
  FCreationFlags : Cardinal;

begin
  If poUsePipes in FProcessOptions then
    CreateStreams;
  FCreationFlags:=GetCreationFlags;
  FStartupInfo.dwFlags:=GetStartupFlags;
{$ifndef linux}
  PName:=Nil;
  PCommandLine:=Nil;
  PDir:=Nil;
  If FApplicationName<>'' then
    PName:=Pchar(FApplicationName);
  If FCommandLine<>'' then
    PCommandLine:=Pchar(FCommandLine);
  If FCurrentDirectory<>'' then
    PDir:=Pchar(FCurrentDirectory);
{$endif}
  if FEnvironment.Count<>0 then
    FEnv:=StringsToPcharList(FEnvironment)
  else
    FEnv:=Nil;
  FInheritHandles:=True;
{$ifdef linux}
  if Not CreateProcess (FApplicationName,FCommandLine,FCurrentDirectory,FEnv,
                        FStartupOptions,FProcessOptions,FStartupInfo,
                        fProcessInformation) then
{$else}
  If Not CreateProcess (PName,PCommandLine,FProcessAttributes,FThreadAttributes,
                 FInheritHandles,FCreationFlags,FEnv,PDir,FStartupInfo,
                 fProcessInformation) then
{$endif}
    Raise Exception.CreateFmt('Failed to execute %s : %d',[FCommandLine,GetLastError]);
  if POUsePipes in FProcessOptions then
    begin
    FileClose(FStartupInfo.hStdInput);
    FileClose(FStartupInfo.hStdOutput);
    FileClose(FStartupInfo.hStdError);
    end;
{$ifdef linux}
  Fhandle:=fprocessinformation.hProcess;
{$endif}
  FRunning:=True;
  If FEnv<>Nil then
    FreePCharList(FEnv);
  if not (csDesigning in ComponentState) and // This would hang the IDE !
     (poWaitOnExit in FProcessOptions) and
      not (poRunSuspended in FProcessOptions) then
    WaitOnExit;
end;

Function TProcess.WaitOnExit : Dword;

begin
{$ifdef linux}
  Result:=WaitPid(Handle,@FExitCode,0);
  If Result=Handle then
    FExitCode:=WexitStatus(FExitCode);
{$else}
  Result:=WaitForSingleObject (FprocessInformation.hProcess,Infinite);
  If Result<>Wait_Failed then
    GetExitStatus;
{$endif}
  FRunning:=False;
end;

Function TProcess.Suspend : Longint;

begin
{$ifdef linux}
  If kill(Handle,SIGSTOP)<>0 then
    Result:=-1
  else
    Result:=1;
{$else}
  Result:=SuspendThread(ThreadHandle);
{$endif}
end;

Function TProcess.Resume : LongInt;

begin
{$ifdef linux}
  If kill(Handle,SIGCONT)<>0 then
    Result:=-1
  else
    Result:=0;
{$else}
  Result:=ResumeThread(ThreadHandle);
{$endif}
end;

Function TProcess.Terminate(AExitCode : Integer) : Boolean;

begin
  Result:=False;
{$ifdef linux}
  Result:=kill(Handle,SIGTERM)=0;
  If Result then
    begin
    If Running then
      Result:=Kill(Handle,SIGKILL)=0;
    end;
  GetExitStatus;
{$else}
  If ExitStatus=Still_active then
    Result:=TerminateProcess(Handle,AexitCode);
{$endif}
end;

Procedure TProcess.SetFillAttribute (Value : Cardinal);

begin
  FStartupInfo.dwFlags:=FStartupInfo.dwFlags or Startf_UseFillAttribute;
  FStartupInfo.dwFillAttribute:=Value;
end;

Procedure TProcess.SetShowWindow (Value : TShowWindowOptions);

{$ifndef linux}
Const
  SWC : Array [TShowWindowOptions] of Cardinal =
             (0,SW_HIDE,SW_Maximize,SW_Minimize,SW_Restore,SW_Show,
             SW_ShowDefault,SW_ShowMaximized,SW_ShowMinimized,
               SW_showMinNOActive,SW_ShowNA,SW_ShowNoActivate,SW_ShowNormal);
{$endif}

begin
  FShowWindow:=Value;
  if Value<>swoNone then
    FStartupInfo.dwFlags:=FStartupInfo.dwFlags or Startf_UseShowWindow
  else
    FStartupInfo.dwFlags:=FStartupInfo.dwFlags and not Startf_UseShowWindow;
{$ifndef linux}
  FStartupInfo.wShowWindow:=SWC[Value];
{$endif}  
end;

Procedure TProcess.SetWindowColumns (Value : Cardinal);

begin
  if Value<>0 then
    Include(FStartUpOptions,suoUseCountChars);
  FStartupInfo.dwXCountChars:=Value;
end;


Procedure TProcess.SetWindowHeight (Value : Cardinal);

begin
  if Value<>0 then
    include(FStartUpOptions,suoUsePosition);
  FStartupInfo.dwYsize:=Value;
end;

Procedure TProcess.SetWindowLeft (Value : Cardinal);

begin
  if Value<>0 then
    Include(FStartUpOptions,suoUseSize);
  FStartupInfo.dwx:=Value;
end;

Procedure TProcess.SetWindowTop (Value : Cardinal);

begin
  if Value<>0 then
    Include(FStartUpOptions,suoUsePosition);
  FStartupInfo.dwy:=Value;
end;

Procedure TProcess.SetWindowWidth (Value : Cardinal);
begin
  If (Value<>0) then
    Include(FStartUpOptions,suoUseSize);
  FStartupInfo.dwxsize:=Value;
end;

Function TProcess.GetWindowRect : TRect;
begin
  With Result do
    With FStartupInfo do
      begin
      Left:=dwx;
      Right:=dwx+dwxSize;
      Top:=dwy;
      Bottom:=dwy+dwysize;
      end;
end;

Procedure TProcess.SetWindowRect (Value : Trect);
begin
  Include(FStartupOptions,suouseSize);
  Include(FStartupOptions,suoUsePosition);
  With Value do
    With FStartupInfo do
      begin
      dwx:=Left;
      dwxSize:=Right-Left;
      dwy:=Top;
      dwySize:=Bottom-top;
      end;
end;


Procedure TProcess.SetWindowRows (Value : Cardinal);

begin
  FStartupInfo.dwFlags:=FStartupInfo.dwFlags or Startf_UseCountChars;
  FStartupInfo.dwYCountChars:=Value;
end;

procedure TProcess.SetApplicationname(const Value: String);
begin
  FApplicationname := Value;
  If (csdesigning in ComponentState) and
     (FCommandLine='') then
    FCommandLine:=Value;
end;

procedure TProcess.SetProcessOptions(const Value: TProcessOptions);
begin
  FProcessOptions := Value;
  If poNewConsole in FPRocessOptions then
    Exclude(FProcessoptions,poNoConsole);
  if poRunSuspended in FProcessOptions then
    Exclude(FPRocessoptions,poWaitOnExit);
end;

procedure TProcess.SetActive(const Value: Boolean);
begin
  if (Value<>GetRunning) then
    If Value then
      Execute
    else
      Terminate(0);
end;

procedure TProcess.SetEnvironment(const Value: TStrings);
begin
  FEnvironment.Assign(Value);
end;

end.
