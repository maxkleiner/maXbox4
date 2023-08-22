unit uPSI_IdEcho;
{
   echoes in the dark
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
  TPSImport_IdEcho = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TIdEcho(CL: TPSPascalCompiler);
procedure SIRegister_IdEcho(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TIdEcho(CL: TPSRuntimeClassImporter);
procedure RIRegister_IdEcho(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   IdAssignedNumbers
  ,IdTCPClient
  ,IdEcho
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_IdEcho]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TIdEcho(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TIdTCPClient', 'TIdEcho') do
  with CL.AddClassN(CL.FindClass('TIdTCPClient'),'TIdEcho') do begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
    RegisterMethod('Function Echo( AText : String) : String');
    RegisterProperty('EchoTime', 'Cardinal', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_IdEcho(CL: TPSPascalCompiler);
begin
  SIRegister_TIdEcho(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TIdEchoEchoTime_R(Self: TIdEcho; var T: Cardinal);
begin T := Self.EchoTime; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TIdEcho(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TIdEcho) do
  begin
    RegisterConstructor(@TIdEcho.Create, 'Create');
    RegisterMethod(@TIdEcho.Echo, 'Echo');
    RegisterPropertyHelper(@TIdEchoEchoTime_R,nil,'EchoTime');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_IdEcho(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TIdEcho(CL);
end;

 
 
{ TPSImport_IdEcho }
(*----------------------------------------------------------------------------*)
procedure TPSImport_IdEcho.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_IdEcho(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_IdEcho.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_IdEcho(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
