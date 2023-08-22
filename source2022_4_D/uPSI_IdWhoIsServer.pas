unit uPSI_IdWhoIsServer;
{
   add constructor
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
  TPSImport_IdWhoIsServer = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TIdWhoIsServer(CL: TPSPascalCompiler);
procedure SIRegister_IdWhoIsServer(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TIdWhoIsServer(CL: TPSRuntimeClassImporter);
procedure RIRegister_IdWhoIsServer(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   IdAssignedNumbers
  ,IdTCPServer
  ,IdWhoIsServer
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_IdWhoIsServer]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TIdWhoIsServer(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TIdTCPserver', 'TIdWhoIsServer') do
  with CL.AddClassN(CL.FindClass('TIdTCPserver'),'TIdWhoIsServer') do begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
       RegisterMethod('Procedure Free');
    RegisterProperty('OnCommandLookup', 'TGetEvent', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_IdWhoIsServer(CL: TPSPascalCompiler);
begin
  CL.AddTypeS('TGetEvent', 'Procedure ( AThread : TIdPeerThread; ALookup : string)');
  SIRegister_TIdWhoIsServer(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TIdWhoIsServerOnCommandLookup_W(Self: TIdWhoIsServer; const T: TGetEvent);
begin Self.OnCommandLookup := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdWhoIsServerOnCommandLookup_R(Self: TIdWhoIsServer; var T: TGetEvent);
begin T := Self.OnCommandLookup; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TIdWhoIsServer(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TIdWhoIsServer) do begin
    RegisterConstructor(@TIdWhoIsServer.Create, 'Create');
       RegisterMethod(@TIdWhoIsServer.Destroy, 'Free');
    RegisterPropertyHelper(@TIdWhoIsServerOnCommandLookup_R,@TIdWhoIsServerOnCommandLookup_W,'OnCommandLookup');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_IdWhoIsServer(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TIdWhoIsServer(CL);
end;

 
 
{ TPSImport_IdWhoIsServer }
(*----------------------------------------------------------------------------*)
procedure TPSImport_IdWhoIsServer.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_IdWhoIsServer(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_IdWhoIsServer.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_IdWhoIsServer(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
