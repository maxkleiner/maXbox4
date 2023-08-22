unit uPSI_IdRawClient;
{
   add props
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
  TPSImport_IdRawClient = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TIdRawClient(CL: TPSPascalCompiler);
procedure SIRegister_IdRawClient(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TIdRawClient(CL: TPSRuntimeClassImporter);
procedure RIRegister_IdRawClient(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   IdRawBase
  ,IdRawClient
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_IdRawClient]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TIdRawClient(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TIdRawBase', 'TIdRawClient') do
  with CL.AddClassN(CL.FindClass('TIdRawBase'),'TIdRawClient') do begin
    RegisterPublishedProperties;
     RegisterProperty('Host', 'string', iptrw);
     RegisterProperty('Protocol', 'Integer', iptrw);
     RegisterProperty('Port', 'Integer', iptrw);
    RegisterProperty('ReceiveTimeout', 'Integer', iptrw);
   end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_IdRawClient(CL: TPSPascalCompiler);
begin
  SIRegister_TIdRawClient(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure RIRegister_TIdRawClient(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TIdRawClient) do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_IdRawClient(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TIdRawClient(CL);
end;

 
 
{ TPSImport_IdRawClient }
(*----------------------------------------------------------------------------*)
procedure TPSImport_IdRawClient.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_IdRawClient(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_IdRawClient.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_IdRawClient(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
