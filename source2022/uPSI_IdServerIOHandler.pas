unit uPSI_IdServerIOHandler;
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
  TPSImport_IdServerIOHandler = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TIdServerIOHandler(CL: TPSPascalCompiler);
procedure SIRegister_IdServerIOHandler(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TIdServerIOHandler(CL: TPSRuntimeClassImporter);
procedure RIRegister_IdServerIOHandler(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   IdComponent
  ,IdIOHandlerSocket
  ,IdStackConsts
  ,IdIOHandler
  ,IdThread
  ,IdServerIOHandler
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_IdServerIOHandler]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TIdServerIOHandler(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TIdComponent', 'TIdServerIOHandler') do
  with CL.AddClassN(CL.FindClass('TIdComponent'),'TIdServerIOHandler') do
  begin
    RegisterMethod('Procedure Init');
    RegisterMethod('Function Accept( ASocket : TIdStackSocketHandle; AThread : TIdThread) : TIdIOHandler');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_IdServerIOHandler(CL: TPSPascalCompiler);
begin
  SIRegister_TIdServerIOHandler(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure RIRegister_TIdServerIOHandler(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TIdServerIOHandler) do
  begin
    RegisterVirtualMethod(@TIdServerIOHandler.Init, 'Init');
    RegisterVirtualMethod(@TIdServerIOHandler.Accept, 'Accept');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_IdServerIOHandler(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TIdServerIOHandler(CL);
end;

 
 
{ TPSImport_IdServerIOHandler }
(*----------------------------------------------------------------------------*)
procedure TPSImport_IdServerIOHandler.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_IdServerIOHandler(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_IdServerIOHandler.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_IdServerIOHandler(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
