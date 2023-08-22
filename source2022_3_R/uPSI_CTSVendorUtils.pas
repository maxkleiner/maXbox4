unit uPSI_CTSVendorUtils;
{
  to test framework
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
  TPSImport_CTSVendorUtils = class(TPSPlugin)
  public
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TInterval(CL: TPSPascalCompiler);
procedure SIRegister_TCTSDbObjects(CL: TPSPascalCompiler);
procedure SIRegister_TConnectedCTSHelper(CL: TPSPascalCompiler);
procedure SIRegister_TCTSUtils(CL: TPSPascalCompiler);
procedure SIRegister_CTSVendorUtils(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TCTSDbObjects(CL: TPSRuntimeClassImporter);
procedure RIRegister_TInterval(CL: TPSRuntimeClassImporter);
procedure RIRegister_TConnectedCTSHelper(CL: TPSRuntimeClassImporter);
procedure RIRegister_TCTSUtils(CL: TPSRuntimeClassImporter);
procedure RIRegister_CTSVendorUtils(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   VendorTestFramework
  ,DB
  ,Variants
  ,DBXCommon
  ,CTSVendorUtils
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_CTSVendorUtils]);
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TInterval(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TObject', 'TInterval') do
  with CL.AddClassN(CL.FindClass('TObject'),'TInterval') do begin
    RegisterMethod('Constructor Create');
    RegisterMethod('Procedure Start');
    RegisterMethod('Procedure Stop');
    RegisterMethod('Procedure Clear');
    RegisterProperty('TimeSpan', 'TDateTime', iptr);
    RegisterProperty('TotalSeconds', 'Int64', iptr);
    RegisterProperty('TotalMinuets', 'Int64', iptr);
    RegisterProperty('TotalHours', 'Int64', iptr);
    RegisterMethod('Function ToString: String;');
  end;
end;


(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TCTSDbObjects(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TConnectedCTSHelper', 'TCTSDbObjects') do
  with CL.AddClassN(CL.FindClass('TConnectedCTSHelper'),'TCTSDbObjects') do begin
    RegisterMethod('Procedure InitDBObjects');
    RegisterMethod('Procedure CreateDBObjects');
    RegisterMethod('Procedure CleanUpDBObjects');
    RegisterMethod('Function GetAllTypesColumns : TColumnInfoArray');
    RegisterMethod('Function GetUserToken : WideString');
    RegisterProperty('MasterTable', 'WideString', iptr);
    RegisterProperty('DetailTable', 'WideString', iptr);
    RegisterProperty('AlllTypesTable', 'WideString', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TConnectedCTSHelper(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TCTSUtils', 'TConnectedCTSHelper') do
  with CL.AddClassN(CL.FindClass('TCTSUtils'),'TConnectedCTSHelper') do
  begin
    RegisterMethod('Constructor Create( ADialect : TBaseDialect)');
    RegisterMethod('Function GetConnectionFromName( const ConnectionName : WideString) : TDBXConnection');
    RegisterMethod('Procedure ExecuteSQLStatement( SQL : WideString; TransactionType : TTransactionMode; IgnoreException : TExecuteSQLOption)');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TCTSUtils(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOBJECT', 'TCTSUtils') do
  with CL.AddClassN(CL.FindClass('TOBJECT'),'TCTSUtils') do
  begin
    RegisterMethod('Constructor Create( ADialect : TBaseDialect)');
    RegisterMethod('Function BuildColumnInfoArray0( const ForTypes : TSQLTypeArray) : TColumnInfoArray;');
    RegisterMethod('Function BuildColumnInfoArray1( const ForTypes : TSQLTypeSet) : TColumnInfoArray;');
    RegisterMethod('Procedure ClearColumnInfoArray( Columns : TColumnInfoArray)');
    RegisterMethod('Procedure SetDbxParamForColumn( Param : TDBXParameter; const Column : TColumnInfo)');
    RegisterMethod('Procedure GenerateValueForDbxParam( DbxParam : TDBXParameter; const Column : TColumnInfo)');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_CTSVendorUtils(CL: TPSPascalCompiler);
begin
 CL.AddConstantN('DBXCTSSEEDField','String').SetString( 'SEED_ID');
 CL.AddConstantN('DBXCTSGenFieldSuffix','String').SetString( '_FIELD');
  SIRegister_TCTSUtils(CL);
  CL.AddTypeS('TTransactionMode', '( tmNone, tmCommit, tmRollback )');
  CL.AddTypeS('TExecuteSQLOption', '( optIgnoreException, optRaiseException )');
  SIRegister_TConnectedCTSHelper(CL);
  SIRegister_TCTSDbObjects(CL);
  SIRegister_TInterval(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TCTSDbObjectsAlllTypesTable_R(Self: TCTSDbObjects; var T: WideString);
begin T := Self.AlllTypesTable; end;

(*----------------------------------------------------------------------------*)
procedure TCTSDbObjectsDetailTable_R(Self: TCTSDbObjects; var T: WideString);
begin T := Self.DetailTable; end;

(*----------------------------------------------------------------------------*)
procedure TCTSDbObjectsMasterTable_R(Self: TCTSDbObjects; var T: WideString);
begin T := Self.MasterTable; end;

(*----------------------------------------------------------------------------*)
Function TCTSUtilsBuildColumnInfoArray1_P(Self: TCTSUtils;  const ForTypes : TSQLTypeSet) : TColumnInfoArray;
Begin Result := Self.BuildColumnInfoArray(ForTypes); END;

(*----------------------------------------------------------------------------*)
Function TCTSUtilsBuildColumnInfoArray0_P(Self: TCTSUtils;  const ForTypes : TSQLTypeArray) : TColumnInfoArray;
Begin Result := Self.BuildColumnInfoArray(ForTypes); END;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TCTSDbObjects(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TCTSDbObjects) do begin
    RegisterVirtualMethod(@TCTSDbObjects.InitDBObjects, 'InitDBObjects');
    RegisterVirtualMethod(@TCTSDbObjects.CreateDBObjects, 'CreateDBObjects');
    RegisterVirtualMethod(@TCTSDbObjects.CleanUpDBObjects, 'CleanUpDBObjects');
    RegisterMethod(@TCTSDbObjects.GetAllTypesColumns, 'GetAllTypesColumns');
    RegisterMethod(@TCTSDbObjects.GetUserToken, 'GetUserToken');
    RegisterPropertyHelper(@TCTSDbObjectsMasterTable_R,nil,'MasterTable');
    RegisterPropertyHelper(@TCTSDbObjectsDetailTable_R,nil,'DetailTable');
    RegisterPropertyHelper(@TCTSDbObjectsAlllTypesTable_R,nil,'AlllTypesTable');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TConnectedCTSHelper(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TConnectedCTSHelper) do begin
    RegisterConstructor(@TConnectedCTSHelper.Create, 'Create');
    RegisterMethod(@TConnectedCTSHelper.GetConnectionFromName, 'GetConnectionFromName');
    RegisterMethod(@TConnectedCTSHelper.ExecuteSQLStatement, 'ExecuteSQLStatement');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TCTSUtils(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TCTSUtils) do begin
    RegisterConstructor(@TCTSUtils.Create, 'Create');
    RegisterMethod(@TCTSUtilsBuildColumnInfoArray0_P, 'BuildColumnInfoArray0');
    RegisterMethod(@TCTSUtilsBuildColumnInfoArray1_P, 'BuildColumnInfoArray1');
    RegisterMethod(@TCTSUtils.ClearColumnInfoArray, 'ClearColumnInfoArray');
    RegisterMethod(@TCTSUtils.SetDbxParamForColumn, 'SetDbxParamForColumn');
    RegisterMethod(@TCTSUtils.GenerateValueForDbxParam, 'GenerateValueForDbxParam');
  end;
end;

(*----------------------------------------------------------------------------*)
Function TIntervalToString0_P(Self: TInterval) : String;
Begin Result := Self.ToString; END;

(*----------------------------------------------------------------------------*)
procedure TIntervalTotalHours_R(Self: TInterval; var T: Int64);
begin T := Self.TotalHours; end;

(*----------------------------------------------------------------------------*)
procedure TIntervalTotalMinuets_R(Self: TInterval; var T: Int64);
begin T := Self.TotalMinuets; end;

(*----------------------------------------------------------------------------*)
procedure TIntervalTotalSeconds_R(Self: TInterval; var T: Int64);
begin T := Self.TotalSeconds; end;

(*----------------------------------------------------------------------------*)
procedure TIntervalTimeSpan_R(Self: TInterval; var T: TDateTime);
begin T := Self.TimeSpan; end;

procedure RIRegister_TInterval(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TInterval) do begin
    RegisterConstructor(@TInterval.Create, 'Create');
    RegisterMethod(@TInterval.Start, 'Start');
    RegisterMethod(@TInterval.Stop, 'Stop');
    RegisterMethod(@TInterval.Clear, 'Clear');
    RegisterPropertyHelper(@TIntervalTimeSpan_R,nil,'TimeSpan');
    RegisterPropertyHelper(@TIntervalTotalSeconds_R,nil,'TotalSeconds');
    RegisterPropertyHelper(@TIntervalTotalMinuets_R,nil,'TotalMinuets');
    RegisterPropertyHelper(@TIntervalTotalHours_R,nil,'TotalHours');
    RegisterMethod(@TIntervalToString0_P, 'ToString');
  end;
end;



(*----------------------------------------------------------------------------*)
procedure RIRegister_CTSVendorUtils(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TCTSUtils(CL);
  RIRegister_TConnectedCTSHelper(CL);
  RIRegister_TCTSDbObjects(CL);
  RIRegister_TInterval(CL);
end;

 
 
{ TPSImport_CTSVendorUtils }
(*----------------------------------------------------------------------------*)
procedure TPSImport_CTSVendorUtils.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_CTSVendorUtils(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_CTSVendorUtils.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_CTSVendorUtils(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
