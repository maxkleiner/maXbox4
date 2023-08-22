unit uPSI_NamedPipeThreads;
{
Tfor pipe gui
  TNamedThread.SetName('Main Thread');    fix namedpipethread
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
  TPSImport_NamedPipeThreads = class(TPSPlugin)
  public
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TNamedPipeThread(CL: TPSPascalCompiler);
procedure SIRegister_NamedPipeThreads(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TNamedPipeThread(CL: TPSRuntimeClassImporter);
procedure RIRegister_NamedPipeThreads(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   StdCtrls
  ,NamedPipesImpl
  //,DebugThreadSupport
  ,NamedPipeThreads
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_NamedPipeThreads]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TNamedPipeThread(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TNamedThread', 'TNamedPipeThread') do
  with CL.AddClassN(CL.FindClass('TNamedThread'),'TNamedPipeThread') do
  begin
    RegisterMethod('Constructor Create( NamedPipe : TNamedPipe2; Memo : TMemo)');
    RegisterMethod('Procedure Execute');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_NamedPipeThreads(CL: TPSPascalCompiler);
begin
  SIRegister_TNamedPipeThread(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure RIRegister_TNamedPipeThread(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TNamedPipeThread) do
  begin
    RegisterConstructor(@TNamedPipeThread.Create, 'Create');
    RegisterMethod(@TNamedPipeThread.Execute, 'Execute');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_NamedPipeThreads(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TNamedPipeThread(CL);
end;

 
 
{ TPSImport_NamedPipeThreads }
(*----------------------------------------------------------------------------*)
procedure TPSImport_NamedPipeThreads.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_NamedPipeThreads(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_NamedPipeThreads.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_NamedPipeThreads(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
