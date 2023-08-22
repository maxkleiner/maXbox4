unit uPSI_DataBkr;
{
          REMOTABLE
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
  TPSImport_DataBkr = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TCRemoteDataModule(CL: TPSPascalCompiler);
procedure SIRegister_TRemoteDataModule(CL: TPSPascalCompiler);
procedure SIRegister_DataBkr(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_DataBkr_Routines(S: TPSExec);
procedure RIRegister_TCRemoteDataModule(CL: TPSRuntimeClassImporter);
procedure RIRegister_TRemoteDataModule(CL: TPSRuntimeClassImporter);
procedure RIRegister_DataBkr(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   Windows
  ,Variants
  ,ActiveX
  ,Midas
  ,Provider
  ,DataBkr
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_DataBkr]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TCRemoteDataModule(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TDataModule', 'TCRemoteDataModule') do
  with CL.AddClassN(CL.FindClass('TDataModule'),'TCRemoteDataModule') do begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
      RegisterMethod('Procedure Free');
    RegisterMethod('Procedure RegisterProvider( Value : TCustomProvider)');
    RegisterMethod('Procedure UnRegisterProvider( Value : TCustomProvider)');
    RegisterMethod('Procedure Lock');
    RegisterMethod('Procedure UnLock');
    RegisterMethod('Function CRDMGetProviderNames : OleVariant');
    RegisterMethod('Function GetProvider( const ProviderName : string) : TCustomProvider');
    RegisterProperty('Providers', 'TCustomProvider string', iptr);
    RegisterProperty('ProviderCount', 'integer', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TRemoteDataModule(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TDataModule', 'TRemoteDataModule') do
  with CL.AddClassN(CL.FindClass('TDataModule'),'TRemoteDataModule') do begin
    RegisterMethod('Procedure Free');
    RegisterMethod('Constructor Create( AOwner : TComponent)');
    RegisterMethod('Procedure RegisterProvider( Value : TCustomProvider)');
    RegisterMethod('Procedure UnRegisterProvider( Value : TCustomProvider)');
    RegisterMethod('Procedure Lock');
    RegisterMethod('Procedure Unlock');
    RegisterProperty('Providers', 'TCustomProvider string', iptr);
    RegisterProperty('ProviderCount', 'integer', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_DataBkr(CL: TPSPascalCompiler);
begin
  SIRegister_TRemoteDataModule(CL);
  SIRegister_TCRemoteDataModule(CL);
 CL.AddDelphiFunction('Procedure RegisterPooled( const ClassID : string; Max, Timeout : Integer; Singleton : Boolean)');
 CL.AddDelphiFunction('Procedure UnregisterPooled( const ClassID : string)');
 CL.AddDelphiFunction('Procedure EnableSocketTransport( const ClassID : string)');
 CL.AddDelphiFunction('Procedure DisableSocketTransport( const ClassID : string)');
 CL.AddDelphiFunction('Procedure EnableWebTransport( const ClassID : string)');
 CL.AddDelphiFunction('Procedure DisableWebTransport( const ClassID : string)');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TCRemoteDataModuleProviderCount_R(Self: TCRemoteDataModule; var T: integer);
begin T := Self.ProviderCount; end;

(*----------------------------------------------------------------------------*)
procedure TCRemoteDataModuleProviders_R(Self: TCRemoteDataModule; var T: TCustomProvider; const t1: string);
begin T := Self.Providers[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TRemoteDataModuleProviderCount_R(Self: TRemoteDataModule; var T: integer);
begin T := Self.ProviderCount; end;

(*----------------------------------------------------------------------------*)
procedure TRemoteDataModuleProviders_R(Self: TRemoteDataModule; var T: TCustomProvider; const t1: string);
begin T := Self.Providers[t1]; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_DataBkr_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@RegisterPooled, 'RegisterPooled', cdRegister);
 S.RegisterDelphiFunction(@UnregisterPooled, 'UnregisterPooled', cdRegister);
 S.RegisterDelphiFunction(@EnableSocketTransport, 'EnableSocketTransport', cdRegister);
 S.RegisterDelphiFunction(@DisableSocketTransport, 'DisableSocketTransport', cdRegister);
 S.RegisterDelphiFunction(@EnableWebTransport, 'EnableWebTransport', cdRegister);
 S.RegisterDelphiFunction(@DisableWebTransport, 'DisableWebTransport', cdRegister);
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TCRemoteDataModule(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TCRemoteDataModule) do begin
    RegisterConstructor(@TCRemoteDataModule.Create, 'Create');
       RegisterMethod(@TCRemoteDataModule.Destroy, 'Free');
        RegisterVirtualMethod(@TCRemoteDataModule.RegisterProvider, 'RegisterProvider');
    RegisterVirtualMethod(@TCRemoteDataModule.UnRegisterProvider, 'UnRegisterProvider');
    RegisterVirtualMethod(@TCRemoteDataModule.Lock, 'Lock');
    RegisterVirtualMethod(@TCRemoteDataModule.UnLock, 'UnLock');
    RegisterMethod(@TCRemoteDataModule.CRDMGetProviderNames, 'CRDMGetProviderNames');
    RegisterVirtualMethod(@TCRemoteDataModule.GetProvider, 'GetProvider');
    RegisterPropertyHelper(@TCRemoteDataModuleProviders_R,nil,'Providers');
    RegisterPropertyHelper(@TCRemoteDataModuleProviderCount_R,nil,'ProviderCount');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TRemoteDataModule(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TRemoteDataModule) do begin
    RegisterConstructor(@TRemoteDataModule.Create, 'Create');
     RegisterMethod(@TRemoteDataModule.Destroy, 'Free');
     RegisterVirtualMethod(@TRemoteDataModule.RegisterProvider, 'RegisterProvider');
    RegisterVirtualMethod(@TRemoteDataModule.UnRegisterProvider, 'UnRegisterProvider');
    RegisterVirtualMethod(@TRemoteDataModule.Lock, 'Lock');
    RegisterVirtualMethod(@TRemoteDataModule.Unlock, 'Unlock');
    RegisterPropertyHelper(@TRemoteDataModuleProviders_R,nil,'Providers');
    RegisterPropertyHelper(@TRemoteDataModuleProviderCount_R,nil,'ProviderCount');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_DataBkr(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TRemoteDataModule(CL);
  RIRegister_TCRemoteDataModule(CL);
end;

 
 
{ TPSImport_DataBkr }
(*----------------------------------------------------------------------------*)
procedure TPSImport_DataBkr.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_DataBkr(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_DataBkr.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_DataBkr(ri);
  RIRegister_DataBkr_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
