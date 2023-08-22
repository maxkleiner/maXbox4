unit uPSI_wmiserv;
{
   oleenumerator for wmi
   second connect for namespace params
   additional registry
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
  TPSImport_wmiserv = class(TPSPlugin)
  public
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_wmiserv(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_wmiserv_Routines(S: TPSExec);

procedure Register;

implementation


uses
   comobj
  ,activex
  ,WbemScripting_TLB
  ,wmiserv
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_wmiserv]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_wmiserv(CL: TPSPascalCompiler);
begin
 CL.AddConstantN('EOAC_NONE','LongInt').SetInt( 0);
 CL.AddConstantN('RPC_C_AUTHN_WINNT','LongInt').SetInt( 10);
 CL.AddConstantN('RPC_C_AUTHZ_NONE','LongInt').SetInt( 0);
 CL.AddConstantN('RPC_E_CHANGED_MODE','LongInt').SetInt( - 2147417850);
 CL.AddDelphiFunction('Function WMIStart : ISWBemLocator');
 CL.AddDelphiFunction('Function WMIConnect( WBemLocator : ISWBemLocator; Server, account, password : string) : ISWBemServices');
 CL.AddDelphiFunction('Function WMIConnect2( WBemLocator : ISWBemLocator; namespace, Server, account, password : string) : ISWBemServices');
 CL.AddDelphiFunction('Function WMIConnect3( WBemLocator : ISWBemLocator; Server,namespace,  account, password : string) : ISWBemServices');

 CL.AddDelphiFunction('Function WMIExecQuery( WBemServices : ISWBemServices; query : string) : ISWbemObjectSet');
 CL.AddDelphiFunction('Function WMIRowFindFirst( ObjectSet : ISWbemObjectSet; var ENum : IEnumVariant; var tempobj : OleVariant) : boolean');
 CL.AddDelphiFunction('Function WMIRowFindNext( ENum : IENumVariant; var tempobj : OleVariant) : boolean');
 CL.AddDelphiFunction('Function WMIColFindFirst( var propENum : IENumVariant; var tempObj : OleVariant) : boolean');
 CL.AddDelphiFunction('Function WMIColFindNext( propENum : IENumVariant; var tempobj : OleVariant) : boolean');
 CL.AddDelphiFunction('Function WMIGetValue( wbemservices : ISWBemServices; tablename, fieldname : string) : string');
 CL.AddDelphiFunction('Function WMIConvValue( tempobj : OleVariant; var keyname : string) : string');
 CL.AddDelphiFunction('function WMIRegConnect(WBemLocator: ISWBemLocator; Server, account, password: string): ISWBemServices;');
 CL.AddDelphiFunction('procedure WMIGetMethodInfo(srv: ISWbemServices; objname, method: string;  var regobject, inparms: ISWBemObject);');
 CL.AddDelphiFunction('procedure WMISetValue(InParam: ISWBemObject; keyvalue: string; invalue: OleVariant);');

end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure RIRegister_wmiserv_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@WMIStart, 'WMIStart', cdRegister);
 S.RegisterDelphiFunction(@WMIConnect, 'WMIConnect', cdRegister);
 S.RegisterDelphiFunction(@WMIConnect2, 'WMIConnect2', cdRegister);
 S.RegisterDelphiFunction(@WMIConnect3, 'WMIConnect3', cdRegister);

 S.RegisterDelphiFunction(@WMIExecQuery, 'WMIExecQuery', cdRegister);
 S.RegisterDelphiFunction(@WMIRowFindFirst, 'WMIRowFindFirst', cdRegister);
 S.RegisterDelphiFunction(@WMIRowFindNext, 'WMIRowFindNext', cdRegister);
 S.RegisterDelphiFunction(@WMIColFindFirst, 'WMIColFindFirst', cdRegister);
 S.RegisterDelphiFunction(@WMIColFindNext, 'WMIColFindNext', cdRegister);
 S.RegisterDelphiFunction(@WMIGetValue, 'WMIGetValue', cdRegister);
 S.RegisterDelphiFunction(@WMIConvValue, 'WMIConvValue', cdRegister);
 S.RegisterDelphiFunction(@WMIRegConnect, 'WMIRegConnect', cdRegister);
 S.RegisterDelphiFunction(@WMIGetMethodInfo, 'WMIGetMethodInfo', cdRegister);
 S.RegisterDelphiFunction(@WMISetValue, 'WMISetValue', cdRegister);

end;

 
 
{ TPSImport_wmiserv }
(*----------------------------------------------------------------------------*)
procedure TPSImport_wmiserv.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_wmiserv(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_wmiserv.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_wmiserv_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
