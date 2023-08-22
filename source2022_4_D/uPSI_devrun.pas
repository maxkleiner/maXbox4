unit uPSI_devrun;
{
   run from thread
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
  TPSImport_devrun = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TDevRun(CL: TPSPascalCompiler);
procedure SIRegister_devrun(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TDevRun(CL: TPSRuntimeClassImporter);
procedure RIRegister_devrun(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   Windows
  ,Dialogs
  //,utils
  ,devrun
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_devrun]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TDevRun(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TThread', 'TDevRun') do
  with CL.AddClassN(CL.FindClass('TThread'),'TDevRun') do begin
    RegisterProperty('Command', 'string', iptrw);
    RegisterProperty('Directory', 'string', iptrw);
    RegisterProperty('Output', 'string', iptrw);
    RegisterProperty('OnLineOutput', 'TLineOutputEvent', iptrw);
    RegisterProperty('OnCheckAbort', 'TCheckAbortFunc', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_devrun(CL: TPSPascalCompiler);
begin
  CL.AddTypeS('TLineOutputEvent', 'Procedure ( Sender : TObject; const Line : String)');
  SIRegister_TDevRun(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TDevRunOnCheckAbort_W(Self: TDevRun; const T: TCheckAbortFunc);
begin Self.OnCheckAbort := T; end;

(*----------------------------------------------------------------------------*)
procedure TDevRunOnCheckAbort_R(Self: TDevRun; var T: TCheckAbortFunc);
begin T := Self.OnCheckAbort; end;

(*----------------------------------------------------------------------------*)
procedure TDevRunOnLineOutput_W(Self: TDevRun; const T: TLineOutputEvent);
begin Self.OnLineOutput := T; end;

(*----------------------------------------------------------------------------*)
procedure TDevRunOnLineOutput_R(Self: TDevRun; var T: TLineOutputEvent);
begin T := Self.OnLineOutput; end;

(*----------------------------------------------------------------------------*)
procedure TDevRunOutput_W(Self: TDevRun; const T: string);
Begin Self.Output := T; end;

(*----------------------------------------------------------------------------*)
procedure TDevRunOutput_R(Self: TDevRun; var T: string);
Begin T := Self.Output; end;

(*----------------------------------------------------------------------------*)
procedure TDevRunDirectory_W(Self: TDevRun; const T: string);
Begin Self.Directory := T; end;

(*----------------------------------------------------------------------------*)
procedure TDevRunDirectory_R(Self: TDevRun; var T: string);
Begin T := Self.Directory; end;

(*----------------------------------------------------------------------------*)
procedure TDevRunCommand_W(Self: TDevRun; const T: string);
Begin Self.Command := T; end;

(*----------------------------------------------------------------------------*)
procedure TDevRunCommand_R(Self: TDevRun; var T: string);
Begin T := Self.Command; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TDevRun(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TDevRun) do begin
    RegisterPropertyHelper(@TDevRunCommand_R,@TDevRunCommand_W,'Command');
    RegisterPropertyHelper(@TDevRunDirectory_R,@TDevRunDirectory_W,'Directory');
    RegisterPropertyHelper(@TDevRunOutput_R,@TDevRunOutput_W,'Output');
    RegisterPropertyHelper(@TDevRunOnLineOutput_R,@TDevRunOnLineOutput_W,'OnLineOutput');
    RegisterPropertyHelper(@TDevRunOnCheckAbort_R,@TDevRunOnCheckAbort_W,'OnCheckAbort');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_devrun(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TDevRun(CL);
end;

 
 
{ TPSImport_devrun }
(*----------------------------------------------------------------------------*)
procedure TPSImport_devrun.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_devrun(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_devrun.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_devrun(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
