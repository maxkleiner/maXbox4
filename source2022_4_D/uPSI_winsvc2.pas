unit uPSI_winsvc2;
{
Tanother second service manager - store communication act

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
  TPSImport_winsvc2 = class(TPSPlugin)
  public
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_winsvc2(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_winsvc2_Routines(S: TPSExec);

procedure Register;

implementation


uses
   winsvc
  ,windows
  ,winsvc2
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_winsvc2]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_winsvc2(CL: TPSPascalCompiler);
begin
 CL.AddConstantN('SERVICE_AUTO_START','LongWord').SetUInt( $00000002);
 CL.AddConstantN('SERVICE_CONFIG_DELAYED_AUTO_START_INFO','LongInt').SetInt( 3);
 CL.AddConstantN('SERVICE_CONFIG_FAILURE_ACTIONS_FLAG','LongInt').SetInt( 4);
 CL.AddConstantN('SERVICE_CONFIG_PREFERRED_NODE','LongInt').SetInt( 9);
 CL.AddConstantN('SERVICE_CONFIG_PRESHUTDOWN_INFO','LongInt').SetInt( 7);
 CL.AddConstantN('SERVICE_CONFIG_REQUIRED_PRIVILEGES_INFO','LongInt').SetInt( 6);
 CL.AddConstantN('SERVICE_CONFIG_SERVICE_SID_INFO','LongInt').SetInt( 5);
 CL.AddConstantN('SERVICE_CONFIG_TRIGGER_INFO','LongInt').SetInt( 8);
 CL.AddConstantN('SC_MANAGER_ALL_ACCESS','LongWord').SetUInt($F003F);
 CL.AddConstantN('SERVICE_ALL_ACCESS','LongWord').SetUInt($F01FF);
 //SC_MANAGER_ALL_ACCESS =  $F003F; //0xF003F)
   //       SERVICE_ALL_ACCESS = $F01FF;

 CL.AddDelphiFunction('Function ChangeServiceType( ServiceName : String; TypeID : DWord) : Boolean');
 CL.AddDelphiFunction('Function GetServiceStatus2( ServiceName : String; ErrorState : Boolean) : Boolean');
 CL.AddDelphiFunction('Function StartService2( ServiceName : string) : boolean');
 CL.AddDelphiFunction('Function StopService2( ServiceName : string) : boolean');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure RIRegister_winsvc2_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@ChangeServiceType, 'ChangeServiceType', cdRegister);
 S.RegisterDelphiFunction(@GetServiceStatus2, 'GetServiceStatus2', cdRegister);
 S.RegisterDelphiFunction(@StartService2, 'StartService2', cdRegister);
 S.RegisterDelphiFunction(@StopService2, 'StopService2', cdRegister);
end;

 
 
{ TPSImport_winsvc2 }
(*----------------------------------------------------------------------------*)
procedure TPSImport_winsvc2.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_winsvc2(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_winsvc2.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_winsvc2_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
