unit uPSI_IdServerIOHandlerSocket;
{
  for SSL
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
  TPSImport_IdServerIOHandlerSocket = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TIdServerIOHandlerSocket(CL: TPSPascalCompiler);
procedure SIRegister_IdServerIOHandlerSocket(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TIdServerIOHandlerSocket(CL: TPSRuntimeClassImporter);
procedure RIRegister_IdServerIOHandlerSocket(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   IdGlobal
  ,IdThread
  ,IdServerIOHandler
  ,IdStackConsts
  ,IdIOHandler
  ,IdIOHandlerSocket
  ,IdServerIOHandlerSocket
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_IdServerIOHandlerSocket]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TIdServerIOHandlerSocket(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TIdServerIOHandler', 'TIdServerIOHandlerSocket') do
  with CL.AddClassN(CL.FindClass('TIdServerIOHandler'),'TIdServerIOHandlerSocket') do
  begin
    RegisterMethod('Procedure Init');
    RegisterMethod('Function Accept( ASocket : TIdStackSocketHandle; AThread : TIdThread) : TIdIOHandler');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_IdServerIOHandlerSocket(CL: TPSPascalCompiler);
begin
  SIRegister_TIdServerIOHandlerSocket(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure RIRegister_TIdServerIOHandlerSocket(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TIdServerIOHandlerSocket) do
  begin
    RegisterMethod(@TIdServerIOHandlerSocket.Init, 'Init');
    RegisterMethod(@TIdServerIOHandlerSocket.Accept, 'Accept');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_IdServerIOHandlerSocket(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TIdServerIOHandlerSocket(CL);
end;

 
 
{ TPSImport_IdServerIOHandlerSocket }
(*----------------------------------------------------------------------------*)
procedure TPSImport_IdServerIOHandlerSocket.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_IdServerIOHandlerSocket(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_IdServerIOHandlerSocket.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_IdServerIOHandlerSocket(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
