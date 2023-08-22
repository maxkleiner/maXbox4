unit uPSI_MidasCon;
{
midas for mentor advance postlogistics

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
  TPSImport_MidasCon = class(TPSPlugin)
  public
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TMidasConnection(CL: TPSPascalCompiler);
procedure SIRegister_TRemoteServer(CL: TPSPascalCompiler);
procedure SIRegister_MidasCon(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TMidasConnection(CL: TPSRuntimeClassImporter);
procedure RIRegister_TRemoteServer(CL: TPSRuntimeClassImporter);
procedure RIRegister_MidasCon(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   MConnect
  ,SConnect
  ,MidasCon
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_MidasCon]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TMidasConnection(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TDCOMConnection', 'TMidasConnection') do
  with CL.AddClassN(CL.FindClass('TDCOMConnection'),'TMidasConnection') do
  begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
    RegisterProperty('ConnectType', 'TConnectType', iptrw);
    RegisterProperty('ServerPort', 'Integer', iptrw);
    RegisterProperty('UseBroker', 'Boolean', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TRemoteServer(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TDCOMConnection', 'TRemoteServer') do
  with CL.AddClassN(CL.FindClass('TDCOMConnection'),'TRemoteServer') do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_MidasCon(CL: TPSPascalCompiler);
begin
  SIRegister_TRemoteServer(CL);
  CL.AddTypeS('TConnectType', '( ctDCOM, ctSockets, ctOLEnterprise )');
  SIRegister_TMidasConnection(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TMidasConnectionUseBroker_W(Self: TMidasConnection; const T: Boolean);
begin Self.UseBroker := T; end;

(*----------------------------------------------------------------------------*)
procedure TMidasConnectionUseBroker_R(Self: TMidasConnection; var T: Boolean);
begin T := Self.UseBroker; end;

(*----------------------------------------------------------------------------*)
procedure TMidasConnectionServerPort_W(Self: TMidasConnection; const T: Integer);
begin Self.ServerPort := T; end;

(*----------------------------------------------------------------------------*)
procedure TMidasConnectionServerPort_R(Self: TMidasConnection; var T: Integer);
begin T := Self.ServerPort; end;

(*----------------------------------------------------------------------------*)
procedure TMidasConnectionConnectType_W(Self: TMidasConnection; const T: TConnectType);
begin Self.ConnectType := T; end;

(*----------------------------------------------------------------------------*)
procedure TMidasConnectionConnectType_R(Self: TMidasConnection; var T: TConnectType);
begin T := Self.ConnectType; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TMidasConnection(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TMidasConnection) do
  begin
    RegisterConstructor(@TMidasConnection.Create, 'Create');
    RegisterPropertyHelper(@TMidasConnectionConnectType_R,@TMidasConnectionConnectType_W,'ConnectType');
    RegisterPropertyHelper(@TMidasConnectionServerPort_R,@TMidasConnectionServerPort_W,'ServerPort');
    RegisterPropertyHelper(@TMidasConnectionUseBroker_R,@TMidasConnectionUseBroker_W,'UseBroker');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TRemoteServer(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TRemoteServer) do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_MidasCon(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TRemoteServer(CL);
  RIRegister_TMidasConnection(CL);
end;

 
 
{ TPSImport_MidasCon }
(*----------------------------------------------------------------------------*)
procedure TPSImport_MidasCon.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_MidasCon(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_MidasCon.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_MidasCon(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
