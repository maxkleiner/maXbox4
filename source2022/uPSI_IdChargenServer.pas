unit uPSI_IdChargenServer;
{

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
  TPSImport_IdChargenServer = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TIdChargenServer(CL: TPSPascalCompiler);
procedure SIRegister_IdChargenServer(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TIdChargenServer(CL: TPSRuntimeClassImporter);
procedure RIRegister_IdChargenServer(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   IdAssignedNumbers
  ,IdTCPServer
  ,IdChargenServer
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_IdChargenServer]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TIdChargenServer(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TIdTCPServer', 'TIdChargenServer') do
  with CL.AddClassN(CL.FindClass('TIdTCPServer'),'TIdChargenServer') do
  begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
    RegisterMethod('Function DoExecute( AThread : TIdPeerThread) : boolean');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_IdChargenServer(CL: TPSPascalCompiler);
begin
  SIRegister_TIdChargenServer(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure RIRegister_TIdChargenServer(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TIdChargenServer) do begin
    RegisterConstructor(@TIdChargenServer.Create, 'Create');
    //RegisterMethod(@TIdChargenServer.DoExecute, 'DoExecute');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_IdChargenServer(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TIdChargenServer(CL);
end;

 
 
{ TPSImport_IdChargenServer }
(*----------------------------------------------------------------------------*)
procedure TPSImport_IdChargenServer.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_IdChargenServer(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_IdChargenServer.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_IdChargenServer(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
