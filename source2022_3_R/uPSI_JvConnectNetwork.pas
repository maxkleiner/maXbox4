unit uPSI_JvConnectNetwork;
{
   to connect the test rest
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
  TPSImport_JvConnectNetwork = class(TPSPlugin)
  public
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TJvNetworkConnect(CL: TPSPascalCompiler);
procedure SIRegister_TJvDisconnectNetwork(CL: TPSPascalCompiler);
procedure SIRegister_TJvConnectNetwork(CL: TPSPascalCompiler);
procedure SIRegister_JvConnectNetwork(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TJvNetworkConnect(CL: TPSRuntimeClassImporter);
procedure RIRegister_TJvDisconnectNetwork(CL: TPSRuntimeClassImporter);
procedure RIRegister_TJvConnectNetwork(CL: TPSRuntimeClassImporter);
procedure RIRegister_JvConnectNetwork(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
  // JclUnitVersioning
  Windows
  ,JvBaseDlg
  ,JvConnectNetwork
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_JvConnectNetwork]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TJvNetworkConnect(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TJvCommonDialog', 'TJvNetworkConnect') do
  with CL.AddClassN(CL.FindClass('TCommonDialog'),'TJvNetworkConnect') do
  begin
    RegisterProperty('Connect', 'Boolean', iptrw);
    RegisterMethod('Function Execute : Boolean');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TJvDisconnectNetwork(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TJvCommonDialog', 'TJvDisconnectNetwork') do
  with CL.AddClassN(CL.FindClass('TCommonDialog'),'TJvDisconnectNetwork') do
  begin
    RegisterMethod('Function Execute : Boolean');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TJvConnectNetwork(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TJvCommonDialog', 'TJvConnectNetwork') do
  with CL.AddClassN(CL.FindClass('TCommonDialog'),'TJvConnectNetwork') do
  begin
    RegisterMethod('Function Execute : Boolean');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_JvConnectNetwork(CL: TPSPascalCompiler);
begin
  SIRegister_TJvConnectNetwork(CL);
  SIRegister_TJvDisconnectNetwork(CL);
  SIRegister_TJvNetworkConnect(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TJvNetworkConnectConnect_W(Self: TJvNetworkConnect; const T: Boolean);
begin Self.Connect := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvNetworkConnectConnect_R(Self: TJvNetworkConnect; var T: Boolean);
begin T := Self.Connect; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJvNetworkConnect(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJvNetworkConnect) do
  begin
    RegisterPropertyHelper(@TJvNetworkConnectConnect_R,@TJvNetworkConnectConnect_W,'Connect');
    RegisterMethod(@TJvNetworkConnect.Execute, 'Execute');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJvDisconnectNetwork(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJvDisconnectNetwork) do
  begin
    RegisterMethod(@TJvDisconnectNetwork.Execute, 'Execute');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJvConnectNetwork(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJvConnectNetwork) do
  begin
    RegisterMethod(@TJvConnectNetwork.Execute, 'Execute');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_JvConnectNetwork(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TJvConnectNetwork(CL);
  RIRegister_TJvDisconnectNetwork(CL);
  RIRegister_TJvNetworkConnect(CL);
end;

 
 
{ TPSImport_JvConnectNetwork }
(*----------------------------------------------------------------------------*)
procedure TPSImport_JvConnectNetwork.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_JvConnectNetwork(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_JvConnectNetwork.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_JvConnectNetwork(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
