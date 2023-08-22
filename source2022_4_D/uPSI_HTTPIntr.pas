unit uPSI_HTTPIntr;
{
   with a dfm
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
  TPSImport_HTTPIntr = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_THTTPServer(CL: TPSPascalCompiler);
procedure SIRegister_HTTPIntr(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_HTTPIntr_Routines(S: TPSExec);
procedure RIRegister_THTTPServer(CL: TPSRuntimeClassImporter);
procedure RIRegister_HTTPIntr(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   Windows
  ,Messages
  ,Variants
  ,HTTPApp
  ,SConnect
  ,HTTPIntr
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_HTTPIntr]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_THTTPServer(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TWebModule', 'THTTPServer') do
  with CL.AddClassN(CL.FindClass('TWebModule'),'THTTPServer') do
  begin
    RegisterMethod('Procedure InterpreterAction( Sender : TObject; Request : TWebRequest; Response : TWebResponse; var Handled : Boolean)');
    RegisterMethod('Procedure WebModuleCreate( Sender : TObject)');
    RegisterMethod('Procedure WebModuleDestroy( Sender : TObject)');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_HTTPIntr(CL: TPSPascalCompiler);
begin
  SIRegister_THTTPServer(CL);
 CL.AddDelphiFunction('Function TerminateExtension( dwFlags : DWORD) : BOOL');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure RIRegister_HTTPIntr_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@TerminateExtension, 'TerminateExtension', CdStdCall);
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_THTTPServer(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(THTTPServer) do
  begin
    RegisterMethod(@THTTPServer.InterpreterAction, 'InterpreterAction');
    RegisterMethod(@THTTPServer.WebModuleCreate, 'WebModuleCreate');
    RegisterMethod(@THTTPServer.WebModuleDestroy, 'WebModuleDestroy');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_HTTPIntr(CL: TPSRuntimeClassImporter);
begin
  RIRegister_THTTPServer(CL);
end;

 
 
{ TPSImport_HTTPIntr }
(*----------------------------------------------------------------------------*)
procedure TPSImport_HTTPIntr.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_HTTPIntr(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_HTTPIntr.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_HTTPIntr(ri);
  RIRegister_HTTPIntr_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
