unit uPSI_TConnect;
{
    iNTERFACE
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
  TPSImport_TConnect = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TLocalConnection(CL: TPSPascalCompiler);
procedure SIRegister_TConnect(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TLocalConnection(CL: TPSRuntimeClassImporter);
procedure RIRegister_TConnect(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   Variants
  ,Midas
  ,DB
  ,DBClient
  ,Windows
  ,ActiveX
  ,ComObj
  //,Libc
  ,Provider
  ,TConnect
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_TConnect]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TLocalConnection(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TCustomRemoteServer', 'TLocalConnection') do
  with CL.AddClassN(CL.FindClass('TCustomRemoteServer'),'TLocalConnection') do
  begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
    RegisterProperty('AppServer', 'IAppServer', iptr);
    RegisterMethod('Procedure GetProviderNames( Proc : TGetStrProc)');
    RegisterProperty('Providers', 'TCustomProvider string', iptr);
    RegisterProperty('ProviderCount', 'integer', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TConnect(CL: TPSPascalCompiler);
begin
  SIRegister_TLocalConnection(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TLocalConnectionProviderCount_R(Self: TLocalConnection; var T: integer);
begin T := Self.ProviderCount; end;

(*----------------------------------------------------------------------------*)
procedure TLocalConnectionProviders_R(Self: TLocalConnection; var T: TCustomProvider; const t1: string);
begin T := Self.Providers[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TLocalConnectionAppServer_R(Self: TLocalConnection; var T: IAppServer);
begin T := Self.AppServer; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TLocalConnection(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TLocalConnection) do
  begin
    RegisterConstructor(@TLocalConnection.Create, 'Create');
    RegisterPropertyHelper(@TLocalConnectionAppServer_R,nil,'AppServer');
    RegisterMethod(@TLocalConnection.GetProviderNames, 'GetProviderNames');
    RegisterPropertyHelper(@TLocalConnectionProviders_R,nil,'Providers');
    RegisterPropertyHelper(@TLocalConnectionProviderCount_R,nil,'ProviderCount');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TConnect(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TLocalConnection(CL);
end;

 
 
{ TPSImport_TConnect }
(*----------------------------------------------------------------------------*)
procedure TPSImport_TConnect.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_TConnect(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_TConnect.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_TConnect(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
