unit uPSI_ObjBrkr;
{
   the last broker config connect
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
  TPSImport_ObjBrkr = class(TPSPlugin)
  public
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TSimpleObjectBroker(CL: TPSPascalCompiler);
procedure SIRegister_TServerCollection(CL: TPSPascalCompiler);
procedure SIRegister_TServerItem(CL: TPSPascalCompiler);
procedure SIRegister_ObjBrkr(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TSimpleObjectBroker(CL: TPSRuntimeClassImporter);
procedure RIRegister_TServerCollection(CL: TPSRuntimeClassImporter);
procedure RIRegister_TServerItem(CL: TPSRuntimeClassImporter);
procedure RIRegister_ObjBrkr(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   MConnect
  ,Variants
  ,ObjBrkr
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_ObjBrkr]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TSimpleObjectBroker(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TCustomObjectBroker', 'TSimpleObjectBroker') do
  with CL.AddClassN(CL.FindClass('TCustomObjectBroker'),'TSimpleObjectBroker') do begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
        RegisterMethod('Procedure Free');
     RegisterMethod('Procedure SaveToStream( Stream : TStream)');
    RegisterMethod('Procedure LoadFromStream( Stream : TStream)');
    RegisterProperty('ServerData', 'OleVariant', iptrw);
    RegisterMethod('Procedure SetConnectStatus( ComputerName : string; Success : Boolean)');
    RegisterMethod('Function GetComputerForGUID( GUID : TGUID) : string');
    RegisterMethod('Function GetComputerForProgID( const ProgID) : string');
    RegisterMethod('Function GetPortForComputer( const ComputerName : string) : Integer');
    RegisterProperty('Servers', 'TServerCollection', iptrw);
    RegisterProperty('LoadBalanced', 'Boolean', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TServerCollection(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOwnedCollection', 'TServerCollection') do
  with CL.AddClassN(CL.FindClass('TOwnedCollection'),'TServerCollection') do
  begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
    RegisterMethod('Function GetBalancedName : string');
    RegisterMethod('Function GetNextName : string');
    RegisterMethod('Function FindServer( const ComputerName : string) : TServerItem');
    RegisterProperty('Items', 'TServerItem Integer', iptrw);
    SetDefaultPropery('Items');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TServerItem(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TCollectionItem', 'TServerItem') do
  with CL.AddClassN(CL.FindClass('TCollectionItem'),'TServerItem') do
  begin
    RegisterMethod('Constructor Create( AOwner : TCollection)');
    RegisterProperty('HasFailed', 'Boolean', iptrw);
    RegisterProperty('ComputerName', 'string', iptrw);
    RegisterProperty('Port', 'Integer', iptrw);
    RegisterProperty('Enabled', 'Boolean', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_ObjBrkr(CL: TPSPascalCompiler);
begin
  CL.AddClassN(CL.FindClass('TOBJECT'),'EBrokerException');
  SIRegister_TServerItem(CL);
  SIRegister_TServerCollection(CL);
  SIRegister_TSimpleObjectBroker(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TSimpleObjectBrokerLoadBalanced_W(Self: TSimpleObjectBroker; const T: Boolean);
begin Self.LoadBalanced := T; end;

(*----------------------------------------------------------------------------*)
procedure TSimpleObjectBrokerLoadBalanced_R(Self: TSimpleObjectBroker; var T: Boolean);
begin T := Self.LoadBalanced; end;

(*----------------------------------------------------------------------------*)
procedure TSimpleObjectBrokerServers_W(Self: TSimpleObjectBroker; const T: TServerCollection);
begin Self.Servers := T; end;

(*----------------------------------------------------------------------------*)
procedure TSimpleObjectBrokerServers_R(Self: TSimpleObjectBroker; var T: TServerCollection);
begin T := Self.Servers; end;

(*----------------------------------------------------------------------------*)
procedure TSimpleObjectBrokerServerData_W(Self: TSimpleObjectBroker; const T: OleVariant);
begin Self.ServerData := T; end;

(*----------------------------------------------------------------------------*)
procedure TSimpleObjectBrokerServerData_R(Self: TSimpleObjectBroker; var T: OleVariant);
begin T := Self.ServerData; end;

(*----------------------------------------------------------------------------*)
procedure TServerCollectionItems_W(Self: TServerCollection; const T: TServerItem; const t1: Integer);
begin Self.Items[t1] := T; end;

(*----------------------------------------------------------------------------*)
procedure TServerCollectionItems_R(Self: TServerCollection; var T: TServerItem; const t1: Integer);
begin T := Self.Items[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TServerItemEnabled_W(Self: TServerItem; const T: Boolean);
begin Self.Enabled := T; end;

(*----------------------------------------------------------------------------*)
procedure TServerItemEnabled_R(Self: TServerItem; var T: Boolean);
begin T := Self.Enabled; end;

(*----------------------------------------------------------------------------*)
procedure TServerItemPort_W(Self: TServerItem; const T: Integer);
begin Self.Port := T; end;

(*----------------------------------------------------------------------------*)
procedure TServerItemPort_R(Self: TServerItem; var T: Integer);
begin T := Self.Port; end;

(*----------------------------------------------------------------------------*)
procedure TServerItemComputerName_W(Self: TServerItem; const T: string);
begin Self.ComputerName := T; end;

(*----------------------------------------------------------------------------*)
procedure TServerItemComputerName_R(Self: TServerItem; var T: string);
begin T := Self.ComputerName; end;

(*----------------------------------------------------------------------------*)
procedure TServerItemHasFailed_W(Self: TServerItem; const T: Boolean);
begin Self.HasFailed := T; end;

(*----------------------------------------------------------------------------*)
procedure TServerItemHasFailed_R(Self: TServerItem; var T: Boolean);
begin T := Self.HasFailed; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TSimpleObjectBroker(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TSimpleObjectBroker) do begin
    RegisterConstructor(@TSimpleObjectBroker.Create, 'Create');
     RegisterMethod(@TSimpleObjectBroker.Destroy, 'Free');
    RegisterMethod(@TSimpleObjectBroker.SaveToStream, 'SaveToStream');
    RegisterMethod(@TSimpleObjectBroker.LoadFromStream, 'LoadFromStream');
    RegisterPropertyHelper(@TSimpleObjectBrokerServerData_R,@TSimpleObjectBrokerServerData_W,'ServerData');
    RegisterMethod(@TSimpleObjectBroker.SetConnectStatus, 'SetConnectStatus');
    RegisterMethod(@TSimpleObjectBroker.GetComputerForGUID, 'GetComputerForGUID');
    RegisterMethod(@TSimpleObjectBroker.GetComputerForProgID, 'GetComputerForProgID');
    RegisterMethod(@TSimpleObjectBroker.GetPortForComputer, 'GetPortForComputer');
    RegisterPropertyHelper(@TSimpleObjectBrokerServers_R,@TSimpleObjectBrokerServers_W,'Servers');
    RegisterPropertyHelper(@TSimpleObjectBrokerLoadBalanced_R,@TSimpleObjectBrokerLoadBalanced_W,'LoadBalanced');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TServerCollection(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TServerCollection) do
  begin
    RegisterConstructor(@TServerCollection.Create, 'Create');
    RegisterMethod(@TServerCollection.GetBalancedName, 'GetBalancedName');
    RegisterMethod(@TServerCollection.GetNextName, 'GetNextName');
    RegisterMethod(@TServerCollection.FindServer, 'FindServer');
    RegisterPropertyHelper(@TServerCollectionItems_R,@TServerCollectionItems_W,'Items');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TServerItem(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TServerItem) do
  begin
    RegisterConstructor(@TServerItem.Create, 'Create');
    RegisterPropertyHelper(@TServerItemHasFailed_R,@TServerItemHasFailed_W,'HasFailed');
    RegisterPropertyHelper(@TServerItemComputerName_R,@TServerItemComputerName_W,'ComputerName');
    RegisterPropertyHelper(@TServerItemPort_R,@TServerItemPort_W,'Port');
    RegisterPropertyHelper(@TServerItemEnabled_R,@TServerItemEnabled_W,'Enabled');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_ObjBrkr(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(EBrokerException) do
  RIRegister_TServerItem(CL);
  RIRegister_TServerCollection(CL);
  RIRegister_TSimpleObjectBroker(CL);
end;

 
 
{ TPSImport_ObjBrkr }
(*----------------------------------------------------------------------------*)
procedure TPSImport_ObjBrkr.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_ObjBrkr(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_ObjBrkr.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_ObjBrkr(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
