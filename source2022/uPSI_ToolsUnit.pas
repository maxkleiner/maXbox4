unit uPSI_ToolsUnit;
{
   lazarus db tester
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
  TPSImport_ToolsUnit = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TTestDataLink(CL: TPSPascalCompiler);
procedure SIRegister_TDBBasicsTestSetup(CL: TPSPascalCompiler);
procedure SIRegister_TDBConnector(CL: TPSPascalCompiler);
procedure SIRegister_ToolsUnit(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_ToolsUnit_Routines(S: TPSExec);
procedure RIRegister_TTestDataLink(CL: TPSRuntimeClassImporter);
procedure RIRegister_TDBBasicsTestSetup(CL: TPSRuntimeClassImporter);
procedure RIRegister_TDBConnector(CL: TPSRuntimeClassImporter);
procedure RIRegister_ToolsUnit(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   DB
  ,testdecorator
  ,FmtBCD
  ,ToolsUnit
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_ToolsUnit]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TTestDataLink(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TDataLink', 'TTestDataLink') do
  with CL.AddClassN(CL.FindClass('TDataLink'),'TTestDataLink') do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TDBBasicsTestSetup(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TTestSetup', 'TDBBasicsTestSetup') do
  with CL.AddClassN(CL.FindClass('TTestSetup'),'TDBBasicsTestSetup') do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TDBConnector(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TPersistent', 'TDBConnector') do
  with CL.AddClassN(CL.FindClass('TPersistent'),'TDBConnector') do begin
    RegisterMethod('Constructor create');
      RegisterMethod('Procedure Free');
      RegisterMethod('Procedure DataEvent( dataset : TDataset)');
    RegisterMethod('Function GetNDataset( n : integer) : TDataset;');
    RegisterMethod('Function GetNDataset1( AChange : Boolean; n : integer) : TDataset;');
    RegisterMethod('Function GetFieldDataset : TDataSet;');
    RegisterMethod('Function GetFieldDataset1( AChange : Boolean) : TDataSet;');
    RegisterMethod('Function GetTraceDataset( AChange : Boolean) : TDataset');
    RegisterMethod('Procedure StartTest');
    RegisterMethod('Procedure StopTest');
    RegisterProperty('TestUniDirectional', 'boolean', iptrw);
    RegisterProperty('FormatSettings', 'TFormatSettings', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_ToolsUnit(CL: TPSPascalCompiler);
begin
 CL.AddConstantN('MaxDataSet','LongInt').SetInt( 35);
  //CL.AddTypeS('TDBConnectorClass', 'class of TDBConnector');
  SIRegister_TDBConnector(CL);
  SIRegister_TDBBasicsTestSetup(CL);
  SIRegister_TTestDataLink(CL);
 CL.AddConstantN('testValuesCount','LongInt').SetInt( 25);
 CL.AddDelphiFunction('Procedure InitialiseDBConnector');
 CL.AddDelphiFunction('Procedure FreeDBConnector');
 CL.AddDelphiFunction('Function DateTimeToTimeString( d : tdatetime) : string');
 CL.AddDelphiFunction('Function TimeStringToDateTime( d : String) : TDateTime');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TDBConnectorFormatSettings_R(Self: TDBConnector; var T: TFormatSettings);
begin T := Self.FormatSettings; end;

(*----------------------------------------------------------------------------*)
procedure TDBConnectorTestUniDirectional_W(Self: TDBConnector; const T: boolean);
begin Self.TestUniDirectional := T; end;

(*----------------------------------------------------------------------------*)
procedure TDBConnectorTestUniDirectional_R(Self: TDBConnector; var T: boolean);
begin T := Self.TestUniDirectional; end;

(*----------------------------------------------------------------------------*)
Function TDBConnectorGetFieldDataset1_P(Self: TDBConnector;  AChange : Boolean) : TDataSet;
Begin Result := Self.GetFieldDataset(AChange); END;

(*----------------------------------------------------------------------------*)
Function TDBConnectorGetFieldDataset_P(Self: TDBConnector) : TDataSet;
Begin Result := Self.GetFieldDataset; END;

(*----------------------------------------------------------------------------*)
Function TDBConnectorGetNDataset1_P(Self: TDBConnector;  AChange : Boolean; n : integer) : TDataset;
Begin Result := Self.GetNDataset(AChange, n); END;

(*----------------------------------------------------------------------------*)
Function TDBConnectorGetNDataset_P(Self: TDBConnector;  n : integer) : TDataset;
Begin Result := Self.GetNDataset(n); END;

(*----------------------------------------------------------------------------*)
procedure RIRegister_ToolsUnit_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@InitialiseDBConnector, 'InitialiseDBConnector', cdRegister);
 S.RegisterDelphiFunction(@FreeDBConnector, 'FreeDBConnector', cdRegister);
 S.RegisterDelphiFunction(@DateTimeToTimeString, 'DateTimeToTimeString', cdRegister);
 S.RegisterDelphiFunction(@TimeStringToDateTime, 'TimeStringToDateTime', cdRegister);
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TTestDataLink(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TTestDataLink) do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TDBBasicsTestSetup(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TDBBasicsTestSetup) do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TDBConnector(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TDBConnector) do begin
    RegisterVirtualConstructor(@TDBConnector.create, 'create');
       RegisterMethod(@TDBConnector.Destroy, 'Free');
     RegisterMethod(@TDBConnector.DataEvent, 'DataEvent');
    RegisterMethod(@TDBConnectorGetNDataset_P, 'GetNDataset');
    RegisterMethod(@TDBConnectorGetNDataset1_P, 'GetNDataset1');
    RegisterMethod(@TDBConnectorGetFieldDataset_P, 'GetFieldDataset');
    RegisterMethod(@TDBConnectorGetFieldDataset1_P, 'GetFieldDataset1');
    RegisterVirtualMethod(@TDBConnector.GetTraceDataset, 'GetTraceDataset');
    RegisterMethod(@TDBConnector.StartTest, 'StartTest');
    RegisterMethod(@TDBConnector.StopTest, 'StopTest');
    RegisterPropertyHelper(@TDBConnectorTestUniDirectional_R,@TDBConnectorTestUniDirectional_W,'TestUniDirectional');
    RegisterPropertyHelper(@TDBConnectorFormatSettings_R,nil,'FormatSettings');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_ToolsUnit(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TDBConnector(CL);
  RIRegister_TDBBasicsTestSetup(CL);
  RIRegister_TTestDataLink(CL);
end;

 
 
{ TPSImport_ToolsUnit }
(*----------------------------------------------------------------------------*)
procedure TPSImport_ToolsUnit.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_ToolsUnit(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_ToolsUnit.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_ToolsUnit(ri);
  RIRegister_ToolsUnit_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
