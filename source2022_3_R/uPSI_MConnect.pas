unit uPSI_MConnect;
{
  for object broker
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
  TPSImport_MConnect = class(TPSPlugin)
  public
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TSharedConnection(CL: TPSPascalCompiler);
procedure SIRegister_TOLEnterpriseConnection(CL: TPSPascalCompiler);
procedure SIRegister_TDCOMConnection(CL: TPSPascalCompiler);
procedure SIRegister_TCOMConnection(CL: TPSPascalCompiler);
procedure SIRegister_TDispatchConnection(CL: TPSPascalCompiler);
procedure SIRegister_TDispatchAppServer(CL: TPSPascalCompiler);
procedure SIRegister_TCustomObjectBroker(CL: TPSPascalCompiler);
procedure SIRegister_MConnect(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_MConnect_Routines(S: TPSExec);
procedure RIRegister_TSharedConnection(CL: TPSRuntimeClassImporter);
procedure RIRegister_TOLEnterpriseConnection(CL: TPSRuntimeClassImporter);
procedure RIRegister_TDCOMConnection(CL: TPSRuntimeClassImporter);
procedure RIRegister_TCOMConnection(CL: TPSRuntimeClassImporter);
procedure RIRegister_TDispatchConnection(CL: TPSRuntimeClassImporter);
procedure RIRegister_TDispatchAppServer(CL: TPSRuntimeClassImporter);
procedure RIRegister_TCustomObjectBroker(CL: TPSRuntimeClassImporter);
procedure RIRegister_MConnect(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   Variants
  ,Windows
  ,Midas
  ,DB
  ,DBClient
  ,ActiveX
  ,ComObj
  ,Provider
  ,MConnect
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_MConnect]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TSharedConnection(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TCustomRemoteServer', 'TSharedConnection') do
  with CL.AddClassN(CL.FindClass('TCustomRemoteServer'),'TSharedConnection') do begin
    RegisterMethod('Function GetServer : IAppServer');
        RegisterMethod('Procedure Free');
     RegisterMethod('Constructor Create( AOwner : TComponent)');
    RegisterProperty('ParentConnection', 'TDispatchConnection', iptrw);
    RegisterProperty('ChildName', 'String', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TOLEnterpriseConnection(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TCOMConnection', 'TOLEnterpriseConnection') do
  with CL.AddClassN(CL.FindClass('TCOMConnection'),'TOLEnterpriseConnection') do
  begin
    RegisterProperty('ComputerName', 'string', iptrw);
    RegisterProperty('BrokerName', 'string', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TDCOMConnection(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TCOMConnection', 'TDCOMConnection') do
  with CL.AddClassN(CL.FindClass('TCOMConnection'),'TDCOMConnection') do
  begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
    RegisterProperty('ComputerName', 'string', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TCOMConnection(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TDispatchConnection', 'TCOMConnection') do
  with CL.AddClassN(CL.FindClass('TDispatchConnection'),'TCOMConnection') do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TDispatchConnection(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TCustomRemoteServer', 'TDispatchConnection') do
  with CL.AddClassN(CL.FindClass('TCustomRemoteServer'),'TDispatchConnection') do
  begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
    RegisterMethod('Function GetServer : IAppServer');
    RegisterMethod('Function GetServerList : OleVariant');
    RegisterProperty('ServerGUID', 'string', iptrw);
    RegisterProperty('ServerName', 'string', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TDispatchAppServer(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TInterfacedObject', 'TDispatchAppServer') do
  with CL.AddClassN(CL.FindClass('TInterfacedObject'),'TDispatchAppServer') do
  begin
    RegisterMethod('Constructor Create( const AppServer : IAppServerDisp)');
    RegisterMethod('Function SafeCallException( ExceptObject : TObject; ExceptAddr : Pointer) : HResult');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TCustomObjectBroker(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TComponent', 'TCustomObjectBroker') do
  with CL.AddClassN(CL.FindClass('TComponent'),'TCustomObjectBroker') do
  begin
    RegisterMethod('Procedure SetConnectStatus( ComputerName : string; Success : Boolean)');
    RegisterMethod('Function GetComputerForGUID( GUID : TGUID) : string');
    RegisterMethod('Function GetComputerForProgID( const ProgID) : string');
    RegisterMethod('Function GetPortForComputer( const ComputerName : string) : Integer');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_MConnect(CL: TPSPascalCompiler);
begin
  SIRegister_TCustomObjectBroker(CL);
  SIRegister_TDispatchAppServer(CL);
  SIRegister_TDispatchConnection(CL);
  SIRegister_TCOMConnection(CL);
  SIRegister_TDCOMConnection(CL);
  SIRegister_TOLEnterpriseConnection(CL);
  SIRegister_TSharedConnection(CL);
 CL.AddDelphiFunction('Procedure GetMIDASAppServerList( List : TStringList; const RegCheck : string)');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TSharedConnectionChildName_W(Self: TSharedConnection; const T: String);
begin Self.ChildName := T; end;

(*----------------------------------------------------------------------------*)
procedure TSharedConnectionChildName_R(Self: TSharedConnection; var T: String);
begin T := Self.ChildName; end;

(*----------------------------------------------------------------------------*)
procedure TSharedConnectionParentConnection_W(Self: TSharedConnection; const T: TDispatchConnection);
begin Self.ParentConnection := T; end;

(*----------------------------------------------------------------------------*)
procedure TSharedConnectionParentConnection_R(Self: TSharedConnection; var T: TDispatchConnection);
begin T := Self.ParentConnection; end;

(*----------------------------------------------------------------------------*)
procedure TOLEnterpriseConnectionBrokerName_W(Self: TOLEnterpriseConnection; const T: string);
begin Self.BrokerName := T; end;

(*----------------------------------------------------------------------------*)
procedure TOLEnterpriseConnectionBrokerName_R(Self: TOLEnterpriseConnection; var T: string);
begin T := Self.BrokerName; end;

(*----------------------------------------------------------------------------*)
procedure TOLEnterpriseConnectionComputerName_W(Self: TOLEnterpriseConnection; const T: string);
begin Self.ComputerName := T; end;

(*----------------------------------------------------------------------------*)
procedure TOLEnterpriseConnectionComputerName_R(Self: TOLEnterpriseConnection; var T: string);
begin T := Self.ComputerName; end;

(*----------------------------------------------------------------------------*)
procedure TDCOMConnectionComputerName_W(Self: TDCOMConnection; const T: string);
begin Self.ComputerName := T; end;

(*----------------------------------------------------------------------------*)
procedure TDCOMConnectionComputerName_R(Self: TDCOMConnection; var T: string);
begin T := Self.ComputerName; end;

(*----------------------------------------------------------------------------*)
procedure TDispatchConnectionServerName_W(Self: TDispatchConnection; const T: string);
begin Self.ServerName := T; end;

(*----------------------------------------------------------------------------*)
procedure TDispatchConnectionServerName_R(Self: TDispatchConnection; var T: string);
begin T := Self.ServerName; end;

(*----------------------------------------------------------------------------*)
procedure TDispatchConnectionServerGUID_W(Self: TDispatchConnection; const T: string);
begin Self.ServerGUID := T; end;

(*----------------------------------------------------------------------------*)
procedure TDispatchConnectionServerGUID_R(Self: TDispatchConnection; var T: string);
begin T := Self.ServerGUID; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_MConnect_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@GetMIDASAppServerList, 'GetMIDASAppServerList', cdRegister);
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TSharedConnection(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TSharedConnection) do begin
    RegisterMethod(@TSharedConnection.GetServer, 'GetServer');
    RegisterConstructor(@TSharedConnection.Create, 'Create');
        RegisterMethod(@TSharedConnection.Destroy, 'Free');
    RegisterPropertyHelper(@TSharedConnectionParentConnection_R,@TSharedConnectionParentConnection_W,'ParentConnection');
    RegisterPropertyHelper(@TSharedConnectionChildName_R,@TSharedConnectionChildName_W,'ChildName');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TOLEnterpriseConnection(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TOLEnterpriseConnection) do
  begin
    RegisterPropertyHelper(@TOLEnterpriseConnectionComputerName_R,@TOLEnterpriseConnectionComputerName_W,'ComputerName');
    RegisterPropertyHelper(@TOLEnterpriseConnectionBrokerName_R,@TOLEnterpriseConnectionBrokerName_W,'BrokerName');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TDCOMConnection(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TDCOMConnection) do
  begin
    RegisterConstructor(@TDCOMConnection.Create, 'Create');
    RegisterPropertyHelper(@TDCOMConnectionComputerName_R,@TDCOMConnectionComputerName_W,'ComputerName');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TCOMConnection(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TCOMConnection) do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TDispatchConnection(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TDispatchConnection) do
  begin
    RegisterConstructor(@TDispatchConnection.Create, 'Create');
    RegisterMethod(@TDispatchConnection.GetServer, 'GetServer');
    RegisterMethod(@TDispatchConnection.GetServerList, 'GetServerList');
    RegisterPropertyHelper(@TDispatchConnectionServerGUID_R,@TDispatchConnectionServerGUID_W,'ServerGUID');
    RegisterPropertyHelper(@TDispatchConnectionServerName_R,@TDispatchConnectionServerName_W,'ServerName');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TDispatchAppServer(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TDispatchAppServer) do
  begin
    RegisterConstructor(@TDispatchAppServer.Create, 'Create');
    RegisterMethod(@TDispatchAppServer.SafeCallException, 'SafeCallException');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TCustomObjectBroker(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TCustomObjectBroker) do
  begin
    //RegisterVirtualAbstractMethod(@TCustomObjectBroker, @!.SetConnectStatus, 'SetConnectStatus');
    //RegisterVirtualAbstractMethod(@TCustomObjectBroker, @!.GetComputerForGUID, 'GetComputerForGUID');
    //RegisterVirtualAbstractMethod(@TCustomObjectBroker, @!.GetComputerForProgID, 'GetComputerForProgID');
    //RegisterVirtualAbstractMethod(@TCustomObjectBroker, @!.GetPortForComputer, 'GetPortForComputer');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_MConnect(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TCustomObjectBroker(CL);
  RIRegister_TDispatchAppServer(CL);
  RIRegister_TDispatchConnection(CL);
  RIRegister_TCOMConnection(CL);
  RIRegister_TDCOMConnection(CL);
  RIRegister_TOLEnterpriseConnection(CL);
  RIRegister_TSharedConnection(CL);
end;

 
 
{ TPSImport_MConnect }
(*----------------------------------------------------------------------------*)
procedure TPSImport_MConnect.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_MConnect(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_MConnect.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_MConnect(ri);
  RIRegister_MConnect_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
