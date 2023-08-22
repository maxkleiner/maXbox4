unit uPSI_devExec;
{
  to exec and watch
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
  TPSImport_devExec = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TdevExecutor(CL: TPSPascalCompiler);
procedure SIRegister_TExecThread(CL: TPSPascalCompiler);
procedure SIRegister_devExec(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_devExec_Routines(S: TPSExec);
procedure RIRegister_TdevExecutor(CL: TPSRuntimeClassImporter);
procedure RIRegister_TExecThread(CL: TPSRuntimeClassImporter);
procedure RIRegister_devExec(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   Windows
  ,devExec
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_devExec]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TdevExecutor(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TPersistent', 'TdevExecutor') do
  with CL.AddClassN(CL.FindClass('TPersistent'),'TdevExecutor') do begin
    RegisterMethod('Function devExecutor : TdevExecutor');
    RegisterMethod('Procedure Reset');
    RegisterMethod('Procedure ExecuteAndWatch( sFileName, sParams, sPath : string; bVisible : boolean; iTimeOut : Cardinal; OnTermEvent : TNotifyEvent)');
    RegisterProperty('Running', 'boolean', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TExecThread(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TThread', 'TExecThread') do
  with CL.AddClassN(CL.FindClass('TThread'),'TExecThread') do begin
    RegisterMethod('Procedure Execute');
    RegisterProperty('FileName', 'string', iptrw);
    RegisterProperty('Path', 'string', iptrw);
    RegisterProperty('Params', 'string', iptrw);
    RegisterProperty('TimeOut', 'Cardinal', iptrw);
    RegisterProperty('Visible', 'boolean', iptrw);
    RegisterProperty('Process', 'Cardinal', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_devExec(CL: TPSPascalCompiler);
begin
  SIRegister_TExecThread(CL);
  SIRegister_TdevExecutor(CL);
 CL.AddDelphiFunction('Function devExecutor : TdevExecutor');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TdevExecutorRunning_R(Self: TdevExecutor; var T: boolean);
begin T := Self.Running; end;

(*----------------------------------------------------------------------------*)
procedure TExecThreadProcess_R(Self: TExecThread; var T: Cardinal);
begin T := Self.Process; end;

(*----------------------------------------------------------------------------*)
procedure TExecThreadVisible_W(Self: TExecThread; const T: boolean);
begin Self.Visible := T; end;

(*----------------------------------------------------------------------------*)
procedure TExecThreadVisible_R(Self: TExecThread; var T: boolean);
begin T := Self.Visible; end;

(*----------------------------------------------------------------------------*)
procedure TExecThreadTimeOut_W(Self: TExecThread; const T: Cardinal);
begin Self.TimeOut := T; end;

(*----------------------------------------------------------------------------*)
procedure TExecThreadTimeOut_R(Self: TExecThread; var T: Cardinal);
begin T := Self.TimeOut; end;

(*----------------------------------------------------------------------------*)
procedure TExecThreadParams_W(Self: TExecThread; const T: string);
begin Self.Params := T; end;

(*----------------------------------------------------------------------------*)
procedure TExecThreadParams_R(Self: TExecThread; var T: string);
begin T := Self.Params; end;

(*----------------------------------------------------------------------------*)
procedure TExecThreadPath_W(Self: TExecThread; const T: string);
begin Self.Path := T; end;

(*----------------------------------------------------------------------------*)
procedure TExecThreadPath_R(Self: TExecThread; var T: string);
begin T := Self.Path; end;

(*----------------------------------------------------------------------------*)
procedure TExecThreadFileName_W(Self: TExecThread; const T: string);
begin Self.FileName := T; end;

(*----------------------------------------------------------------------------*)
procedure TExecThreadFileName_R(Self: TExecThread; var T: string);
begin T := Self.FileName; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_devExec_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@devExecutor, 'devExecutor', cdRegister);
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TdevExecutor(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TdevExecutor) do
  begin
    RegisterMethod(@TdevExecutor.devExecutor, 'devExecutor');
    RegisterMethod(@TdevExecutor.Reset, 'Reset');
    RegisterMethod(@TdevExecutor.ExecuteAndWatch, 'ExecuteAndWatch');
    RegisterPropertyHelper(@TdevExecutorRunning_R,nil,'Running');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TExecThread(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TExecThread) do
  begin
    RegisterMethod(@TExecThread.Execute, 'Execute');
    RegisterPropertyHelper(@TExecThreadFileName_R,@TExecThreadFileName_W,'FileName');
    RegisterPropertyHelper(@TExecThreadPath_R,@TExecThreadPath_W,'Path');
    RegisterPropertyHelper(@TExecThreadParams_R,@TExecThreadParams_W,'Params');
    RegisterPropertyHelper(@TExecThreadTimeOut_R,@TExecThreadTimeOut_W,'TimeOut');
    RegisterPropertyHelper(@TExecThreadVisible_R,@TExecThreadVisible_W,'Visible');
    RegisterPropertyHelper(@TExecThreadProcess_R,nil,'Process');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_devExec(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TExecThread(CL);
  RIRegister_TdevExecutor(CL);
end;

 
 
{ TPSImport_devExec }
(*----------------------------------------------------------------------------*)
procedure TPSImport_devExec.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_devExec(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_devExec.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_devExec(ri);
  RIRegister_devExec_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
