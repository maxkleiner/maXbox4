unit uPSI_NamedPipeServer;
{
   a named pipe for os
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
  TPSImport_NamedPipeServer = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TPipeServer(CL: TPSPascalCompiler);
procedure SIRegister_NamedPipeServer(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TPipeServer(CL: TPSRuntimeClassImporter);
procedure RIRegister_NamedPipeServer(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   Windows
  ,NamedPipes
  ,NamedPipeServer
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_NamedPipeServer]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TPipeServer(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TObject', 'TPipeServer') do
  with CL.AddClassN(CL.FindClass('TObject'),'TPipeServer') do begin
    RegisterMethod('Constructor Create');
    RegisterMethod('Procedure Free');
   end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_NamedPipeServer(CL: TPSPascalCompiler);
begin
  CL.AddTypeS('TPipeServerStatus', '( pss_Offline, pss_Starting, pss_Running, pss_Stopping )');
  SIRegister_TPipeServer(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure RIRegister_TPipeServer(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TPipeServer) do begin
    RegisterConstructor(@TPipeServer.Create, 'Create');
    RegisterMethod(@TPipeServer.Destroy, 'Free');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_NamedPipeServer(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TPipeServer(CL);
end;



{ TPSImport_NamedPipeServer }
(*----------------------------------------------------------------------------*)
procedure TPSImport_NamedPipeServer.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_NamedPipeServer(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_NamedPipeServer.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_NamedPipeServer(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
