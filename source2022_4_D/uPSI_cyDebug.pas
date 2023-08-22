unit uPSI_cyDebug;
{
  cy one 1000!
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
  TPSImport_cyDebug = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TcyDebug(CL: TPSPascalCompiler);
procedure SIRegister_cyDebug(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TcyDebug(CL: TPSRuntimeClassImporter);
procedure RIRegister_cyDebug(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   Windows
  ,Grids
  ,cyDebug
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_cyDebug]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TcyDebug(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TComponent', 'TcyDebug') do
  with CL.AddClassN(CL.FindClass('TComponent'),'TcyDebug') do begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
      RegisterMethod('Procedure Free');
      RegisterMethod('Function GetProcessIndex( aProcessName : String) : Integer');
    RegisterMethod('Procedure ProcessEnter( aProcessName : String)');
    RegisterMethod('Procedure ProcessExit( aProcessName : String)');
    RegisterMethod('Procedure InitializeProcesses');
    RegisterProperty('ProcessCount', 'Integer', iptr);
    RegisterProperty('ProcessName', 'ShortString Integer', iptr);
    RegisterProperty('ProcessDurationMs', 'Cardinal Integer', iptr);
    RegisterProperty('ProcessFirstDurationMs', 'Cardinal Integer', iptr);
    RegisterProperty('ProcessLastDurationMs', 'Cardinal Integer', iptr);
    RegisterProperty('ProcessMinDurationMs', 'Cardinal Integer', iptr);
    RegisterProperty('ProcessMaxDurationMs', 'Cardinal Integer', iptr);
    RegisterProperty('ProcessEnterCount', 'Integer Integer', iptr);
    RegisterProperty('ProcessExitCount', 'Integer Integer', iptr);
    RegisterProperty('Active', 'Boolean', iptrw);
    RegisterProperty('ProcessGrid', 'TStringGrid', iptrw);
    RegisterProperty('OnEnterProcess', 'TProcProcessEvent', iptrw);
    RegisterProperty('OnExitProcess', 'TProcProcessEvent', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_cyDebug(CL: TPSPascalCompiler);
begin
  CL.AddTypeS('TProcProcessEvent', 'Procedure ( Sender : TObject; Index : Integer)');
  CL.AddTypeS('RecProcess', 'record Name : ShortString; DurationMs : Cardinal; '
   +'FirstDurationMs : Cardinal; LastDurationMs : Cardinal; MinDurationMs : Int'
   +'64; MaxDurationMs : Cardinal; MarksCount : Integer; ArrayMarks : array of '
   +'Cardinal; EnterCount : Integer; ExitCount : Integer; end');
  SIRegister_TcyDebug(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TcyDebugOnExitProcess_W(Self: TcyDebug; const T: TProcProcessEvent);
begin Self.OnExitProcess := T; end;

(*----------------------------------------------------------------------------*)
procedure TcyDebugOnExitProcess_R(Self: TcyDebug; var T: TProcProcessEvent);
begin T := Self.OnExitProcess; end;

(*----------------------------------------------------------------------------*)
procedure TcyDebugOnEnterProcess_W(Self: TcyDebug; const T: TProcProcessEvent);
begin Self.OnEnterProcess := T; end;

(*----------------------------------------------------------------------------*)
procedure TcyDebugOnEnterProcess_R(Self: TcyDebug; var T: TProcProcessEvent);
begin T := Self.OnEnterProcess; end;

(*----------------------------------------------------------------------------*)
procedure TcyDebugProcessGrid_W(Self: TcyDebug; const T: TStringGrid);
begin Self.ProcessGrid := T; end;

(*----------------------------------------------------------------------------*)
procedure TcyDebugProcessGrid_R(Self: TcyDebug; var T: TStringGrid);
begin T := Self.ProcessGrid; end;

(*----------------------------------------------------------------------------*)
procedure TcyDebugActive_W(Self: TcyDebug; const T: Boolean);
begin Self.Active := T; end;

(*----------------------------------------------------------------------------*)
procedure TcyDebugActive_R(Self: TcyDebug; var T: Boolean);
begin T := Self.Active; end;

(*----------------------------------------------------------------------------*)
procedure TcyDebugProcessExitCount_R(Self: TcyDebug; var T: Integer; const t1: Integer);
begin T := Self.ProcessExitCount[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TcyDebugProcessEnterCount_R(Self: TcyDebug; var T: Integer; const t1: Integer);
begin T := Self.ProcessEnterCount[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TcyDebugProcessMaxDurationMs_R(Self: TcyDebug; var T: Cardinal; const t1: Integer);
begin T := Self.ProcessMaxDurationMs[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TcyDebugProcessMinDurationMs_R(Self: TcyDebug; var T: Cardinal; const t1: Integer);
begin T := Self.ProcessMinDurationMs[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TcyDebugProcessLastDurationMs_R(Self: TcyDebug; var T: Cardinal; const t1: Integer);
begin T := Self.ProcessLastDurationMs[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TcyDebugProcessFirstDurationMs_R(Self: TcyDebug; var T: Cardinal; const t1: Integer);
begin T := Self.ProcessFirstDurationMs[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TcyDebugProcessDurationMs_R(Self: TcyDebug; var T: Cardinal; const t1: Integer);
begin T := Self.ProcessDurationMs[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TcyDebugProcessName_R(Self: TcyDebug; var T: ShortString; const t1: Integer);
begin T := Self.ProcessName[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TcyDebugProcessCount_R(Self: TcyDebug; var T: Integer);
begin T := Self.ProcessCount; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TcyDebug(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TcyDebug) do begin
    RegisterConstructor(@TcyDebug.Create, 'Create');
      RegisterMethod(@TcyDebug.Destroy, 'Free');
      RegisterMethod(@TcyDebug.GetProcessIndex, 'GetProcessIndex');
    RegisterMethod(@TcyDebug.ProcessEnter, 'ProcessEnter');
    RegisterMethod(@TcyDebug.ProcessExit, 'ProcessExit');
    RegisterMethod(@TcyDebug.InitializeProcesses, 'InitializeProcesses');
    RegisterPropertyHelper(@TcyDebugProcessCount_R,nil,'ProcessCount');
    RegisterPropertyHelper(@TcyDebugProcessName_R,nil,'ProcessName');
    RegisterPropertyHelper(@TcyDebugProcessDurationMs_R,nil,'ProcessDurationMs');
    RegisterPropertyHelper(@TcyDebugProcessFirstDurationMs_R,nil,'ProcessFirstDurationMs');
    RegisterPropertyHelper(@TcyDebugProcessLastDurationMs_R,nil,'ProcessLastDurationMs');
    RegisterPropertyHelper(@TcyDebugProcessMinDurationMs_R,nil,'ProcessMinDurationMs');
    RegisterPropertyHelper(@TcyDebugProcessMaxDurationMs_R,nil,'ProcessMaxDurationMs');
    RegisterPropertyHelper(@TcyDebugProcessEnterCount_R,nil,'ProcessEnterCount');
    RegisterPropertyHelper(@TcyDebugProcessExitCount_R,nil,'ProcessExitCount');
    RegisterPropertyHelper(@TcyDebugActive_R,@TcyDebugActive_W,'Active');
    RegisterPropertyHelper(@TcyDebugProcessGrid_R,@TcyDebugProcessGrid_W,'ProcessGrid');
    RegisterPropertyHelper(@TcyDebugOnEnterProcess_R,@TcyDebugOnEnterProcess_W,'OnEnterProcess');
    RegisterPropertyHelper(@TcyDebugOnExitProcess_R,@TcyDebugOnExitProcess_W,'OnExitProcess');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_cyDebug(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TcyDebug(CL);
end;

 
 
{ TPSImport_cyDebug }
(*----------------------------------------------------------------------------*)
procedure TPSImport_cyDebug.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_cyDebug(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_cyDebug.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_cyDebug(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
