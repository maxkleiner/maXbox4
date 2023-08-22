unit uPSI_WDosResolvers;
{
   RT
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
  TPSImport_WDosResolvers = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TResolver(CL: TPSPascalCompiler);
procedure SIRegister_TSocketEntry(CL: TPSPascalCompiler);
procedure SIRegister_WDosResolvers(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TResolver(CL: TPSRuntimeClassImporter);
procedure RIRegister_TSocketEntry(CL: TPSRuntimeClassImporter);
procedure RIRegister_WDosResolvers(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   Contnrs
  ,WDosSocketUtils
  ,WDosResolvers
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_WDosResolvers]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TResolver(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TObject', 'TResolver') do
  with CL.AddClassN(CL.FindClass('TObject'),'TResolver') do begin
    RegisterMethod('Constructor Create');
    RegisterMethod('Function GetHostByName( const AName : string) : TIpAddr');
    RegisterMethod('Function GetHostByAddr( Addr : TIpAddr) : string');
    RegisterMethod('Function GetServByName( const AName, AProtocol : string) : Word');
    RegisterMethod('Function GetServByPort( APort : Word; const AProtocol : string) : string');
    RegisterMethod('Function AsyncGetHostByName( ADest : TObject; AMsg : Cardinal; const AName : string; Entry : TSocketEntry) : Integer');
    RegisterMethod('Function AsyncGetHostByAddr( ADest : TObject; AMsg : Cardinal; AAddr : TIpAddr; Entry : TSocketEntry) : Integer');
    RegisterMethod('Function AsyncGetServByName( ADest : TObject; AMsg : Cardinal; const AName, AProtocol : string; Entry : TSocketEntry) : Integer');
    RegisterMethod('Function AsyncGetServByPort( ADest : TObject; AMsg : Cardinal; APort : Word; const AProtocol : string; Entry : TSocketEntry) : Integer');
    RegisterMethod('Function CancelLookupRequest( LookupHandle : Integer) : TLookupResult');
    RegisterProperty('HostName', 'string', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TSocketEntry(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TObject', 'TSocketEntry') do
  with CL.AddClassN(CL.FindClass('TObject'),'TSocketEntry') do begin
    RegisterProperty('HostName', 'string', iptr);
    RegisterProperty('IpAddr', 'TIpAddr', iptr);
    RegisterProperty('ServiceName', 'string', iptr);
    RegisterProperty('Port', 'Word', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_WDosResolvers(CL: TPSPascalCompiler);
begin
 CL.AddConstantN('SHostFileName','String').SetString( 'c:\etc\hosts');
 CL.AddConstantN('SServicesFileName','String').SetString( 'c:\etc\services');
 CL.AddConstantN('SHostNameFileName','String').SetString( 'c:\etc\hostname');
  SIRegister_TSocketEntry(CL);
  CL.AddTypeS('TLookupResult', '( clrOk, clrNetDown, clrInval, clrAlready )');
  SIRegister_TResolver(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TResolverHostName_R(Self: TResolver; var T: string);
begin T := Self.HostName; end;

(*----------------------------------------------------------------------------*)
procedure TSocketEntryPort_R(Self: TSocketEntry; var T: Word);
begin T := Self.Port; end;

(*----------------------------------------------------------------------------*)
procedure TSocketEntryServiceName_R(Self: TSocketEntry; var T: string);
begin T := Self.ServiceName; end;

(*----------------------------------------------------------------------------*)
procedure TSocketEntryIpAddr_R(Self: TSocketEntry; var T: TIpAddr);
begin T := Self.IpAddr; end;

(*----------------------------------------------------------------------------*)
procedure TSocketEntryHostName_R(Self: TSocketEntry; var T: string);
begin T := Self.HostName; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TResolver(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TResolver) do begin
    RegisterConstructor(@TResolver.Create, 'Create');
    RegisterMethod(@TResolver.GetHostByName, 'GetHostByName');
    RegisterMethod(@TResolver.GetHostByAddr, 'GetHostByAddr');
    RegisterMethod(@TResolver.GetServByName, 'GetServByName');
    RegisterMethod(@TResolver.GetServByPort, 'GetServByPort');
    RegisterMethod(@TResolver.AsyncGetHostByName, 'AsyncGetHostByName');
    RegisterMethod(@TResolver.AsyncGetHostByAddr, 'AsyncGetHostByAddr');
    RegisterMethod(@TResolver.AsyncGetServByName, 'AsyncGetServByName');
    RegisterMethod(@TResolver.AsyncGetServByPort, 'AsyncGetServByPort');
    RegisterMethod(@TResolver.CancelLookupRequest, 'CancelLookupRequest');
    RegisterPropertyHelper(@TResolverHostName_R,nil,'HostName');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TSocketEntry(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TSocketEntry) do
  begin
    RegisterPropertyHelper(@TSocketEntryHostName_R,nil,'HostName');
    RegisterPropertyHelper(@TSocketEntryIpAddr_R,nil,'IpAddr');
    RegisterPropertyHelper(@TSocketEntryServiceName_R,nil,'ServiceName');
    RegisterPropertyHelper(@TSocketEntryPort_R,nil,'Port');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_WDosResolvers(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TSocketEntry(CL);
  RIRegister_TResolver(CL);
end;

 
 
{ TPSImport_WDosResolvers }
(*----------------------------------------------------------------------------*)
procedure TPSImport_WDosResolvers.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_WDosResolvers(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_WDosResolvers.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_WDosResolvers(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
