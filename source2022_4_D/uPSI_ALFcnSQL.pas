unit uPSI_ALFcnSQL;
{
   to firebird
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
  TPSImport_ALFcnSQL = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TAlUpdateSQLClauses(CL: TPSPascalCompiler);
procedure SIRegister_TALUpdateSQLClause(CL: TPSPascalCompiler);
procedure SIRegister_TAlSelectSQLClauses(CL: TPSPascalCompiler);
procedure SIRegister_TAlSelectSQLClause(CL: TPSPascalCompiler);
procedure SIRegister_ALFcnSQL(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TAlUpdateSQLClauses(CL: TPSRuntimeClassImporter);
procedure RIRegister_TALUpdateSQLClause(CL: TPSRuntimeClassImporter);
procedure RIRegister_TAlSelectSQLClauses(CL: TPSRuntimeClassImporter);
procedure RIRegister_TAlSelectSQLClause(CL: TPSRuntimeClassImporter);
procedure RIRegister_ALFcnSQL(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   AlStringList
  ,ALFbxClient
  ,Contnrs
  ,ALFcnSQL
  ;


procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_ALFcnSQL]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TAlUpdateSQLClauses(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TObjectList', 'TAlUpdateSQLClauses') do
  with CL.AddClassN(CL.FindClass('TObjectList'),'TAlUpdateSQLClauses') do begin
    RegisterMethod('Function Add( aUpdateSQLClause : TAlUpdateSQLClause) : Integer');
    RegisterMethod('Function Extract( Item : TAlUpdateSQLClause) : TAlUpdateSQLClause');
    RegisterMethod('Function Remove( aUpdateSQLClause : TAlUpdateSQLClause) : Integer');
    RegisterMethod('Function IndexOf( aUpdateSQLClause : TAlUpdateSQLClause) : Integer');
    RegisterMethod('Function First : TAlUpdateSQLClause');
    RegisterMethod('Function Last : TAlUpdateSQLClause');
    RegisterMethod('Procedure Insert( Index : Integer; aUpdateSQLClause : TAlUpdateSQLClause)');
    RegisterProperty('Items', 'TAlUpdateSQLClause Integer', iptrw);
    SetDefaultPropery('Items');
    RegisterMethod('Function FBXClientUpdateDataSQLs9( const ViewTag, RowTag : AnsiString) : TALFBXClientUpdateDataSQLs;');
    RegisterMethod('Function FBXClientUpdateDataSQLs10( const RowTag : AnsiString) : TALFBXClientUpdateDataSQLs;');
    RegisterMethod('Function FBXClientUpdateDataSQLs11 : TALFBXClientUpdateDataSQLs;');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TALUpdateSQLClause(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'Tobject', 'TALUpdateSQLClause') do
  with CL.AddClassN(CL.FindClass('Tobject'),'TALUpdateSQLClause') do begin
    RegisterProperty('ServerType', 'TALSQLClauseServerType', iptrw);
    RegisterProperty('Kind', 'TALSQLClauseUpdateKind', iptrw);
    RegisterProperty('Table', 'ansiString', iptrw);
    RegisterProperty('Value', 'TALStrings', iptrw);
    RegisterProperty('Where', 'TALStrings', iptrw);
    RegisterProperty('Customs', 'TALStrings', iptrw);
    RegisterProperty('FBXClientSQLParams', 'TALFBXClientSQLParams', iptrw);
    RegisterMethod('Constructor Create');
    RegisterMethod('Procedure clear');
    RegisterMethod('Procedure Assign( Source : TALUpdateSQLClause)');
    RegisterMethod('Function SQLText : AnsiString');
    RegisterMethod('Function FBXClientUpdateDataSQL6( const ViewTag, RowTag : AnsiString) : TALFBXClientUpdateDataSQL;');
    RegisterMethod('Function FBXClientUpdateDataSQL7( const RowTag : AnsiString) : TALFBXClientUpdateDataSQL;');
    RegisterMethod('Function FBXClientUpdateDataSQL8 : TALFBXClientUpdateDataSQL;');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TAlSelectSQLClauses(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TObjectList', 'TAlSelectSQLClauses') do
  with CL.AddClassN(CL.FindClass('TObjectList'),'TAlSelectSQLClauses') do begin
    RegisterMethod('Function Add( aSelectSQLClause : TAlSelectSQLClause) : Integer');
    RegisterMethod('Function Extract( Item : TAlSelectSQLClause) : TAlSelectSQLClause');
    RegisterMethod('Function Remove( aSelectSQLClause : TAlSelectSQLClause) : Integer');
    RegisterMethod('Function IndexOf( aSelectSQLClause : TAlSelectSQLClause) : Integer');
    RegisterMethod('Function First : TAlSelectSQLClause');
    RegisterMethod('Function Last : TAlSelectSQLClause');
    RegisterMethod('Procedure Insert( Index : Integer; aSelectSQLClause : TAlSelectSQLClause)');
    RegisterProperty('Items', 'TAlSelectSQLClause Integer', iptrw);
    SetDefaultPropery('Items');
    RegisterMethod('Function FBXClientSelectDataSQLs3( const ViewTag, RowTag : AnsiString) : TALFBXClientSelectDataSQLs;');
    RegisterMethod('Function FBXClientSelectDataSQLs4( const RowTag : AnsiString) : TALFBXClientSelectDataSQLs;');
    RegisterMethod('Function FBXClientSelectDataSQLs5 : TALFBXClientSelectDataSQLs;');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TAlSelectSQLClause(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'Tobject', 'TAlSelectSQLClause') do
  with CL.AddClassN(CL.FindClass('Tobject'),'TAlSelectSQLClause') do begin
    RegisterProperty('ServerType', 'TALSQLClauseServerType', iptrw);
    RegisterProperty('First', 'integer', iptrw);
    RegisterProperty('Skip', 'Integer', iptrw);
    RegisterProperty('Distinct', 'Boolean', iptrw);
    RegisterProperty('Select', 'TALStrings', iptrw);
    RegisterProperty('Where', 'TALStrings', iptrw);
    RegisterProperty('From', 'TALStrings', iptrw);
    RegisterProperty('Join', 'TALStrings', iptrw);
    RegisterProperty('GroupBy', 'TALStrings', iptrw);
    RegisterProperty('Having', 'TALStrings', iptrw);
    RegisterProperty('Plan', 'ansiString', iptrw);
    RegisterProperty('OrderBy', 'TALStrings', iptrw);
    RegisterProperty('Customs', 'TALStrings', iptrw);
    RegisterProperty('FBXClientSQLParams', 'TALFBXClientSQLParams', iptrw);
    RegisterMethod('Constructor Create');
    RegisterMethod('Procedure clear');
    RegisterMethod('Procedure Assign( Source : TAlSelectSQLClause)');
    RegisterMethod('Function SQLText : AnsiString');
    RegisterMethod('Function FBXClientSelectDataSQL( const ViewTag, RowTag : AnsiString) : TALFBXClientSelectDataSQL;');
    RegisterMethod('Function FBXClientSelectDataSQL1( const RowTag : AnsiString) : TALFBXClientSelectDataSQL;');
    RegisterMethod('Function FBXClientSelectDataSQL2 : TALFBXClientSelectDataSQL;');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_ALFcnSQL(CL: TPSPascalCompiler);
begin
  CL.AddTypeS('TALSQLClauseUpdateKind', '( alDelete, alUpdate, AlInsert, AlUpdateOrInsert )');
  CL.AddTypeS('TALSQLClauseServerType', '( alFirebird, AlSphinx, AlMySql )');
  SIRegister_TAlSelectSQLClause(CL);
  SIRegister_TAlSelectSQLClauses(CL);
  SIRegister_TALUpdateSQLClause(CL);
  SIRegister_TAlUpdateSQLClauses(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
Function TAlUpdateSQLClausesFBXClientUpdateDataSQLs11_P(Self: TAlUpdateSQLClauses) : TALFBXClientUpdateDataSQLs;
Begin Result := Self.FBXClientUpdateDataSQLs; END;

(*----------------------------------------------------------------------------*)
Function TAlUpdateSQLClausesFBXClientUpdateDataSQLs10_P(Self: TAlUpdateSQLClauses;  const RowTag : AnsiString) : TALFBXClientUpdateDataSQLs;
Begin Result := Self.FBXClientUpdateDataSQLs(RowTag); END;

(*----------------------------------------------------------------------------*)
Function TAlUpdateSQLClausesFBXClientUpdateDataSQLs9_P(Self: TAlUpdateSQLClauses;  const ViewTag, RowTag : AnsiString) : TALFBXClientUpdateDataSQLs;
Begin Result := Self.FBXClientUpdateDataSQLs(ViewTag, RowTag); END;

(*----------------------------------------------------------------------------*)
procedure TAlUpdateSQLClausesItems_W(Self: TAlUpdateSQLClauses; const T: TAlUpdateSQLClause; const t1: Integer);
begin Self.Items[t1] := T; end;

(*----------------------------------------------------------------------------*)
procedure TAlUpdateSQLClausesItems_R(Self: TAlUpdateSQLClauses; var T: TAlUpdateSQLClause; const t1: Integer);
begin T := Self.Items[t1]; end;

(*----------------------------------------------------------------------------*)
Function TALUpdateSQLClauseFBXClientUpdateDataSQL8_P(Self: TALUpdateSQLClause) : TALFBXClientUpdateDataSQL;
Begin Result := Self.FBXClientUpdateDataSQL; END;

(*----------------------------------------------------------------------------*)
Function TALUpdateSQLClauseFBXClientUpdateDataSQL7_P(Self: TALUpdateSQLClause;  const RowTag : AnsiString) : TALFBXClientUpdateDataSQL;
Begin Result := Self.FBXClientUpdateDataSQL(RowTag); END;

(*----------------------------------------------------------------------------*)
Function TALUpdateSQLClauseFBXClientUpdateDataSQL6_P(Self: TALUpdateSQLClause;  const ViewTag, RowTag : AnsiString) : TALFBXClientUpdateDataSQL;
Begin Result := Self.FBXClientUpdateDataSQL(ViewTag, RowTag); END;

(*----------------------------------------------------------------------------*)
procedure TALUpdateSQLClauseFBXClientSQLParams_W(Self: TALUpdateSQLClause; const T: TALFBXClientSQLParams);
Begin Self.FBXClientSQLParams := T; end;

(*----------------------------------------------------------------------------*)
procedure TALUpdateSQLClauseFBXClientSQLParams_R(Self: TALUpdateSQLClause; var T: TALFBXClientSQLParams);
Begin T := Self.FBXClientSQLParams; end;

(*----------------------------------------------------------------------------*)
procedure TALUpdateSQLClauseCustoms_W(Self: TALUpdateSQLClause; const T: TALStrings);
Begin Self.Customs := T; end;

(*----------------------------------------------------------------------------*)
procedure TALUpdateSQLClauseCustoms_R(Self: TALUpdateSQLClause; var T: TALStrings);
Begin T := Self.Customs; end;

(*----------------------------------------------------------------------------*)
procedure TALUpdateSQLClauseWhere_W(Self: TALUpdateSQLClause; const T: TALStrings);
Begin Self.Where := T; end;

(*----------------------------------------------------------------------------*)
procedure TALUpdateSQLClauseWhere_R(Self: TALUpdateSQLClause; var T: TALStrings);
Begin T := Self.Where; end;

(*----------------------------------------------------------------------------*)
procedure TALUpdateSQLClauseValue_W(Self: TALUpdateSQLClause; const T: TALStrings);
Begin Self.Value := T; end;

(*----------------------------------------------------------------------------*)
procedure TALUpdateSQLClauseValue_R(Self: TALUpdateSQLClause; var T: TALStrings);
Begin T := Self.Value; end;

(*----------------------------------------------------------------------------*)
procedure TALUpdateSQLClauseTable_W(Self: TALUpdateSQLClause; const T: ansiString);
Begin Self.Table := T; end;

(*----------------------------------------------------------------------------*)
procedure TALUpdateSQLClauseTable_R(Self: TALUpdateSQLClause; var T: ansiString);
Begin T := Self.Table; end;

(*----------------------------------------------------------------------------*)
procedure TALUpdateSQLClauseKind_W(Self: TALUpdateSQLClause; const T: TALSQLClauseUpdateKind);
Begin Self.Kind := T; end;

(*----------------------------------------------------------------------------*)
procedure TALUpdateSQLClauseKind_R(Self: TALUpdateSQLClause; var T: TALSQLClauseUpdateKind);
Begin T := Self.Kind; end;

(*----------------------------------------------------------------------------*)
procedure TALUpdateSQLClauseServerType_W(Self: TALUpdateSQLClause; const T: TALSQLClauseServerType);
Begin Self.ServerType := T; end;

(*----------------------------------------------------------------------------*)
procedure TALUpdateSQLClauseServerType_R(Self: TALUpdateSQLClause; var T: TALSQLClauseServerType);
Begin T := Self.ServerType; end;

(*----------------------------------------------------------------------------*)
Function TAlSelectSQLClausesFBXClientSelectDataSQLs5_P(Self: TAlSelectSQLClauses) : TALFBXClientSelectDataSQLs;
Begin Result := Self.FBXClientSelectDataSQLs; END;

(*----------------------------------------------------------------------------*)
Function TAlSelectSQLClausesFBXClientSelectDataSQLs4_P(Self: TAlSelectSQLClauses;  const RowTag : AnsiString) : TALFBXClientSelectDataSQLs;
Begin Result := Self.FBXClientSelectDataSQLs(RowTag); END;

(*----------------------------------------------------------------------------*)
Function TAlSelectSQLClausesFBXClientSelectDataSQLs3_P(Self: TAlSelectSQLClauses;  const ViewTag, RowTag : AnsiString) : TALFBXClientSelectDataSQLs;
Begin Result := Self.FBXClientSelectDataSQLs(ViewTag, RowTag); END;

(*----------------------------------------------------------------------------*)
procedure TAlSelectSQLClausesItems_W(Self: TAlSelectSQLClauses; const T: TAlSelectSQLClause; const t1: Integer);
begin Self.Items[t1] := T; end;

(*----------------------------------------------------------------------------*)
procedure TAlSelectSQLClausesItems_R(Self: TAlSelectSQLClauses; var T: TAlSelectSQLClause; const t1: Integer);
begin T := Self.Items[t1]; end;

(*----------------------------------------------------------------------------*)
Function TAlSelectSQLClauseFBXClientSelectDataSQL2_P(Self: TAlSelectSQLClause) : TALFBXClientSelectDataSQL;
Begin Result := Self.FBXClientSelectDataSQL; END;

(*----------------------------------------------------------------------------*)
Function TAlSelectSQLClauseFBXClientSelectDataSQL1_P(Self: TAlSelectSQLClause;  const RowTag : AnsiString) : TALFBXClientSelectDataSQL;
Begin Result := Self.FBXClientSelectDataSQL(RowTag); END;

(*----------------------------------------------------------------------------*)
Function TAlSelectSQLClauseFBXClientSelectDataSQL_P(Self: TAlSelectSQLClause;  const ViewTag, RowTag : AnsiString) : TALFBXClientSelectDataSQL;
Begin Result := Self.FBXClientSelectDataSQL(ViewTag, RowTag); END;

(*----------------------------------------------------------------------------*)
procedure TAlSelectSQLClauseFBXClientSQLParams_W(Self: TAlSelectSQLClause; const T: TALFBXClientSQLParams);
Begin Self.FBXClientSQLParams := T; end;

(*----------------------------------------------------------------------------*)
procedure TAlSelectSQLClauseFBXClientSQLParams_R(Self: TAlSelectSQLClause; var T: TALFBXClientSQLParams);
Begin T := Self.FBXClientSQLParams; end;

(*----------------------------------------------------------------------------*)
procedure TAlSelectSQLClauseCustoms_W(Self: TAlSelectSQLClause; const T: TALStrings);
Begin Self.Customs := T; end;

(*----------------------------------------------------------------------------*)
procedure TAlSelectSQLClauseCustoms_R(Self: TAlSelectSQLClause; var T: TALStrings);
Begin T := Self.Customs; end;

(*----------------------------------------------------------------------------*)
procedure TAlSelectSQLClauseOrderBy_W(Self: TAlSelectSQLClause; const T: TALStrings);
Begin Self.OrderBy := T; end;

(*----------------------------------------------------------------------------*)
procedure TAlSelectSQLClauseOrderBy_R(Self: TAlSelectSQLClause; var T: TALStrings);
Begin T := Self.OrderBy; end;

(*----------------------------------------------------------------------------*)
procedure TAlSelectSQLClausePlan_W(Self: TAlSelectSQLClause; const T: ansiString);
Begin Self.Plan := T; end;

(*----------------------------------------------------------------------------*)
procedure TAlSelectSQLClausePlan_R(Self: TAlSelectSQLClause; var T: ansiString);
Begin T := Self.Plan; end;

(*----------------------------------------------------------------------------*)
procedure TAlSelectSQLClauseHaving_W(Self: TAlSelectSQLClause; const T: TALStrings);
Begin Self.Having := T; end;

(*----------------------------------------------------------------------------*)
procedure TAlSelectSQLClauseHaving_R(Self: TAlSelectSQLClause; var T: TALStrings);
Begin T := Self.Having; end;

(*----------------------------------------------------------------------------*)
procedure TAlSelectSQLClauseGroupBy_W(Self: TAlSelectSQLClause; const T: TALStrings);
Begin Self.GroupBy := T; end;

(*----------------------------------------------------------------------------*)
procedure TAlSelectSQLClauseGroupBy_R(Self: TAlSelectSQLClause; var T: TALStrings);
Begin T := Self.GroupBy; end;

(*----------------------------------------------------------------------------*)
procedure TAlSelectSQLClauseJoin_W(Self: TAlSelectSQLClause; const T: TALStrings);
Begin Self.Join := T; end;

(*----------------------------------------------------------------------------*)
procedure TAlSelectSQLClauseJoin_R(Self: TAlSelectSQLClause; var T: TALStrings);
Begin T := Self.Join; end;

(*----------------------------------------------------------------------------*)
procedure TAlSelectSQLClauseFrom_W(Self: TAlSelectSQLClause; const T: TALStrings);
Begin Self.From := T; end;

(*----------------------------------------------------------------------------*)
procedure TAlSelectSQLClauseFrom_R(Self: TAlSelectSQLClause; var T: TALStrings);
Begin T := Self.From; end;

(*----------------------------------------------------------------------------*)
procedure TAlSelectSQLClauseWhere_W(Self: TAlSelectSQLClause; const T: TALStrings);
Begin Self.Where := T; end;

(*----------------------------------------------------------------------------*)
procedure TAlSelectSQLClauseWhere_R(Self: TAlSelectSQLClause; var T: TALStrings);
Begin T := Self.Where; end;

(*----------------------------------------------------------------------------*)
procedure TAlSelectSQLClauseSelect_W(Self: TAlSelectSQLClause; const T: TALStrings);
Begin Self.Select := T; end;

(*----------------------------------------------------------------------------*)
procedure TAlSelectSQLClauseSelect_R(Self: TAlSelectSQLClause; var T: TALStrings);
Begin T := Self.Select; end;

(*----------------------------------------------------------------------------*)
procedure TAlSelectSQLClauseDistinct_W(Self: TAlSelectSQLClause; const T: Boolean);
Begin Self.Distinct := T; end;

(*----------------------------------------------------------------------------*)
procedure TAlSelectSQLClauseDistinct_R(Self: TAlSelectSQLClause; var T: Boolean);
Begin T := Self.Distinct; end;

(*----------------------------------------------------------------------------*)
procedure TAlSelectSQLClauseSkip_W(Self: TAlSelectSQLClause; const T: Integer);
Begin Self.Skip := T; end;

(*----------------------------------------------------------------------------*)
procedure TAlSelectSQLClauseSkip_R(Self: TAlSelectSQLClause; var T: Integer);
Begin T := Self.Skip; end;

(*----------------------------------------------------------------------------*)
procedure TAlSelectSQLClauseFirst_W(Self: TAlSelectSQLClause; const T: integer);
Begin Self.First := T; end;

(*----------------------------------------------------------------------------*)
procedure TAlSelectSQLClauseFirst_R(Self: TAlSelectSQLClause; var T: integer);
Begin T := Self.First; end;

(*----------------------------------------------------------------------------*)
procedure TAlSelectSQLClauseServerType_W(Self: TAlSelectSQLClause; const T: TALSQLClauseServerType);
Begin Self.ServerType := T; end;

(*----------------------------------------------------------------------------*)
procedure TAlSelectSQLClauseServerType_R(Self: TAlSelectSQLClause; var T: TALSQLClauseServerType);
Begin T := Self.ServerType; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TAlUpdateSQLClauses(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TAlUpdateSQLClauses) do begin
    RegisterMethod(@TAlUpdateSQLClauses.Add, 'Add');
    RegisterMethod(@TAlUpdateSQLClauses.Extract, 'Extract');
    RegisterMethod(@TAlUpdateSQLClauses.Remove, 'Remove');
    RegisterMethod(@TAlUpdateSQLClauses.IndexOf, 'IndexOf');
    RegisterMethod(@TAlUpdateSQLClauses.First, 'First');
    RegisterMethod(@TAlUpdateSQLClauses.Last, 'Last');
    RegisterMethod(@TAlUpdateSQLClauses.Insert, 'Insert');
    RegisterPropertyHelper(@TAlUpdateSQLClausesItems_R,@TAlUpdateSQLClausesItems_W,'Items');
    RegisterMethod(@TAlUpdateSQLClausesFBXClientUpdateDataSQLs9_P, 'FBXClientUpdateDataSQLs9');
    RegisterMethod(@TAlUpdateSQLClausesFBXClientUpdateDataSQLs10_P, 'FBXClientUpdateDataSQLs10');
    RegisterMethod(@TAlUpdateSQLClausesFBXClientUpdateDataSQLs11_P, 'FBXClientUpdateDataSQLs11');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TALUpdateSQLClause(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TALUpdateSQLClause) do begin
    RegisterPropertyHelper(@TALUpdateSQLClauseServerType_R,@TALUpdateSQLClauseServerType_W,'ServerType');
    RegisterPropertyHelper(@TALUpdateSQLClauseKind_R,@TALUpdateSQLClauseKind_W,'Kind');
    RegisterPropertyHelper(@TALUpdateSQLClauseTable_R,@TALUpdateSQLClauseTable_W,'Table');
    RegisterPropertyHelper(@TALUpdateSQLClauseValue_R,@TALUpdateSQLClauseValue_W,'Value');
    RegisterPropertyHelper(@TALUpdateSQLClauseWhere_R,@TALUpdateSQLClauseWhere_W,'Where');
    RegisterPropertyHelper(@TALUpdateSQLClauseCustoms_R,@TALUpdateSQLClauseCustoms_W,'Customs');
    RegisterPropertyHelper(@TALUpdateSQLClauseFBXClientSQLParams_R,@TALUpdateSQLClauseFBXClientSQLParams_W,'FBXClientSQLParams');
    RegisterConstructor(@TALUpdateSQLClause.Create, 'Create');
    RegisterMethod(@TALUpdateSQLClause.clear, 'Clear');
    RegisterMethod(@TALUpdateSQLClause.Assign, 'Assign');
    RegisterMethod(@TALUpdateSQLClause.SQLText, 'SQLText');
    RegisterMethod(@TALUpdateSQLClauseFBXClientUpdateDataSQL6_P, 'FBXClientUpdateDataSQL6');
    RegisterMethod(@TALUpdateSQLClauseFBXClientUpdateDataSQL7_P, 'FBXClientUpdateDataSQL7');
    RegisterMethod(@TALUpdateSQLClauseFBXClientUpdateDataSQL8_P, 'FBXClientUpdateDataSQL8');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TAlSelectSQLClauses(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TAlSelectSQLClauses) do begin
    RegisterMethod(@TAlSelectSQLClauses.Add, 'Add');
    RegisterMethod(@TAlSelectSQLClauses.Extract, 'Extract');
    RegisterMethod(@TAlSelectSQLClauses.Remove, 'Remove');
    RegisterMethod(@TAlSelectSQLClauses.IndexOf, 'IndexOf');
    RegisterMethod(@TAlSelectSQLClauses.First, 'First');
    RegisterMethod(@TAlSelectSQLClauses.Last, 'Last');
    RegisterMethod(@TAlSelectSQLClauses.Insert, 'Insert');
    RegisterPropertyHelper(@TAlSelectSQLClausesItems_R,@TAlSelectSQLClausesItems_W,'Items');
    RegisterMethod(@TAlSelectSQLClausesFBXClientSelectDataSQLs3_P, 'FBXClientSelectDataSQLs3');
    RegisterMethod(@TAlSelectSQLClausesFBXClientSelectDataSQLs4_P, 'FBXClientSelectDataSQLs4');
    RegisterMethod(@TAlSelectSQLClausesFBXClientSelectDataSQLs5_P, 'FBXClientSelectDataSQLs5');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TAlSelectSQLClause(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TAlSelectSQLClause) do
  begin
    RegisterPropertyHelper(@TAlSelectSQLClauseServerType_R,@TAlSelectSQLClauseServerType_W,'ServerType');
    RegisterPropertyHelper(@TAlSelectSQLClauseFirst_R,@TAlSelectSQLClauseFirst_W,'First');
    RegisterPropertyHelper(@TAlSelectSQLClauseSkip_R,@TAlSelectSQLClauseSkip_W,'Skip');
    RegisterPropertyHelper(@TAlSelectSQLClauseDistinct_R,@TAlSelectSQLClauseDistinct_W,'Distinct');
    RegisterPropertyHelper(@TAlSelectSQLClauseSelect_R,@TAlSelectSQLClauseSelect_W,'Select');
    RegisterPropertyHelper(@TAlSelectSQLClauseWhere_R,@TAlSelectSQLClauseWhere_W,'Where');
    RegisterPropertyHelper(@TAlSelectSQLClauseFrom_R,@TAlSelectSQLClauseFrom_W,'From');
    RegisterPropertyHelper(@TAlSelectSQLClauseJoin_R,@TAlSelectSQLClauseJoin_W,'Join');
    RegisterPropertyHelper(@TAlSelectSQLClauseGroupBy_R,@TAlSelectSQLClauseGroupBy_W,'GroupBy');
    RegisterPropertyHelper(@TAlSelectSQLClauseHaving_R,@TAlSelectSQLClauseHaving_W,'Having');
    RegisterPropertyHelper(@TAlSelectSQLClausePlan_R,@TAlSelectSQLClausePlan_W,'Plan');
    RegisterPropertyHelper(@TAlSelectSQLClauseOrderBy_R,@TAlSelectSQLClauseOrderBy_W,'OrderBy');
    RegisterPropertyHelper(@TAlSelectSQLClauseCustoms_R,@TAlSelectSQLClauseCustoms_W,'Customs');
    RegisterPropertyHelper(@TAlSelectSQLClauseFBXClientSQLParams_R,@TAlSelectSQLClauseFBXClientSQLParams_W,'FBXClientSQLParams');
    RegisterConstructor(@TAlSelectSQLClause.Create, 'Create');
    RegisterVirtualMethod(@TAlSelectSQLClause.clear, 'Clear');
    RegisterVirtualMethod(@TAlSelectSQLClause.Assign, 'Assign');
    RegisterVirtualMethod(@TAlSelectSQLClause.SQLText, 'SQLText');
    RegisterMethod(@TAlSelectSQLClauseFBXClientSelectDataSQL_P, 'FBXClientSelectDataSQL');
    RegisterMethod(@TAlSelectSQLClauseFBXClientSelectDataSQL1_P, 'FBXClientSelectDataSQL1');
    RegisterMethod(@TAlSelectSQLClauseFBXClientSelectDataSQL2_P, 'FBXClientSelectDataSQL2');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_ALFcnSQL(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TAlSelectSQLClause(CL);
  RIRegister_TAlSelectSQLClauses(CL);
  RIRegister_TALUpdateSQLClause(CL);
  RIRegister_TAlUpdateSQLClauses(CL);
end;

 
 
{ TPSImport_ALFcnSQL }
(*----------------------------------------------------------------------------*)
procedure TPSImport_ALFcnSQL.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_ALFcnSQL(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_ALFcnSQL.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_ALFcnSQL(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
