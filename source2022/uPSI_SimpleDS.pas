unit uPSI_SimpleDS;
{
  simple with properties
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
  TPSImport_SimpleDS = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TSimpleDataSet(CL: TPSPascalCompiler);
procedure SIRegister_TInternalSQLDataSet(CL: TPSPascalCompiler);
procedure SIRegister_SimpleDS(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TSimpleDataSet(CL: TPSRuntimeClassImporter);
procedure RIRegister_TInternalSQLDataSet(CL: TPSRuntimeClassImporter);
procedure RIRegister_SimpleDS(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   Variants
  ,DB
  ,DBCommon
  ,DBClient
  ,Provider
  ,SqlExpr
  ,SqlTimSt
  ,SQLConst
  ,SimpleDS
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_SimpleDS]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TSimpleDataSet(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TCustomClientDataSet', 'TSimpleDataSet') do
  with CL.AddClassN(CL.FindClass('TCustomClientDataSet'),'TSimpleDataSet') do begin
    RegisterPublishedProperties;
    RegisterMethod('Constructor Create( AOwner : TComponent)');
    RegisterProperty('Connection', 'TSQLConnection', iptrw);
    RegisterProperty('DataSet', 'TInternalSQLDataSet', iptr);
  RegisterProperty('MODIFIED', 'BOOLEAN', iptr);
  RegisterProperty('OBJECTVIEW', 'BOOLEAN', iptrw);
  RegisterProperty('RECORDCOUNT', 'INTEGER', iptr);
  RegisterProperty('RECNO', 'INTEGER', iptrw);
  RegisterProperty('RECORDSIZE', 'WORD', iptr);
  RegisterProperty('SPARSEARRAYS', 'BOOLEAN', iptrw);
  RegisterProperty('STATE', 'TDATASETSTATE', iptr);
  RegisterProperty('FILTER', 'String', iptrw);
  RegisterProperty('FILTERED', 'BOOLEAN', iptrw);
  RegisterProperty('FILTEROPTIONS', 'TFILTEROPTIONS', iptrw);
  RegisterProperty('ACTIVE', 'BOOLEAN', iptrw);
  RegisterProperty('AUTOCALCFIELDS', 'BOOLEAN', iptrw);
  RegisterProperty('BEFOREOPEN', 'TDATASETNOTIFYEVENT', iptrw);
  RegisterProperty('AFTEROPEN', 'TDATASETNOTIFYEVENT', iptrw);
  RegisterProperty('BEFORECLOSE', 'TDATASETNOTIFYEVENT', iptrw);
  RegisterProperty('AFTERCLOSE', 'TDATASETNOTIFYEVENT', iptrw);
  RegisterProperty('BEFOREINSERT', 'TDATASETNOTIFYEVENT', iptrw);
  RegisterProperty('AFTERINSERT', 'TDATASETNOTIFYEVENT', iptrw);
  RegisterProperty('BEFOREEDIT', 'TDATASETNOTIFYEVENT', iptrw);
  RegisterProperty('AFTEREDIT', 'TDATASETNOTIFYEVENT', iptrw);
  RegisterProperty('BEFOREPOST', 'TDATASETNOTIFYEVENT', iptrw);
  RegisterProperty('AFTERPOST', 'TDATASETNOTIFYEVENT', iptrw);
  RegisterProperty('BEFORECANCEL', 'TDATASETNOTIFYEVENT', iptrw);
  RegisterProperty('AFTERCANCEL', 'TDATASETNOTIFYEVENT', iptrw);
  RegisterProperty('BEFOREDELETE', 'TDATASETNOTIFYEVENT', iptrw);
  RegisterProperty('AFTERDELETE', 'TDATASETNOTIFYEVENT', iptrw);
  RegisterProperty('BEFORESCROLL', 'TDATASETNOTIFYEVENT', iptrw);
  RegisterProperty('AFTERSCROLL', 'TDATASETNOTIFYEVENT', iptrw);
  RegisterProperty('BEFOREREFRESH', 'TDATASETNOTIFYEVENT', iptrw);
  RegisterProperty('AFTERREFRESH', 'TDATASETNOTIFYEVENT', iptrw);
  RegisterProperty('ONCALCFIELDS', 'TDATASETNOTIFYEVENT', iptrw);
  RegisterProperty('ONDELETEERROR', 'TDATASETERROREVENT', iptrw);
  RegisterProperty('ONEDITERROR', 'TDATASETERROREVENT', iptrw);
  RegisterProperty('ONFILTERRECORD', 'TFILTERRECORDEVENT', iptrw);
  RegisterProperty('ONNEWRECORD', 'TDATASETNOTIFYEVENT', iptrw);
  RegisterProperty('ONPOSTERROR', 'TDATASETERROREVENT', iptrw);
  //RegisterProperty('SQL', 'TStrings', iptrw);
  RegisterProperty('Session', 'TSession', iptrw);
    RegisterProperty('AGGFIELDS', 'TFIELDS', iptr);
  RegisterProperty('BOF', 'BOOLEAN', iptr);
//  RegisterProperty('BOOKMARK', 'TBOOKMARKSTR', iptrw);
  RegisterProperty('CANMODIFY', 'BOOLEAN', iptr);
  RegisterProperty('DATASETFIELD', 'TDATASETFIELD', iptrw);
  RegisterProperty('DATASOURCE', 'TDATASOURCE', iptr);
  RegisterProperty('DEFAULTFIELDS', 'BOOLEAN', iptr);
  RegisterProperty('DESIGNER', 'TDATASETDESIGNER', iptr);
  RegisterProperty('EOF', 'BOOLEAN', iptr);
  RegisterProperty('BLOCKREADSIZE', 'INTEGER', iptrw);
  RegisterProperty('FIELDCOUNT', 'INTEGER', iptr);
  RegisterProperty('FIELDDEFS', 'TFIELDDEFS', iptrw);
  RegisterProperty('FIELDDEFLIST', 'TFIELDDEFLIST', iptr);
  RegisterProperty('FIELDS', 'TFIELDS', iptr);
  RegisterProperty('FIELDLIST', 'TFIELDLIST', iptr);
  RegisterProperty('FIELDVALUES', 'VARIANT String', iptrw);
  RegisterProperty('FOUND', 'BOOLEAN', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TInternalSQLDataSet(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TCustomSQLDataSet', 'TInternalSQLDataSet') do
  with CL.AddClassN(CL.FindClass('TCustomSQLDataSet'),'TInternalSQLDataSet') do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_SimpleDS(CL: TPSPascalCompiler);
begin
  SIRegister_TInternalSQLDataSet(CL);
  SIRegister_TSimpleDataSet(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TSimpleDataSetDataSet_R(Self: TSimpleDataSet; var T: TInternalSQLDataSet);
begin T := Self.DataSet; end;

(*----------------------------------------------------------------------------*)
procedure TSimpleDataSetConnection_W(Self: TSimpleDataSet; const T: TSQLConnection);
begin Self.Connection := T; end;

(*----------------------------------------------------------------------------*)
procedure TSimpleDataSetConnection_R(Self: TSimpleDataSet; var T: TSQLConnection);
begin T := Self.Connection; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TSimpleDataSet(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TSimpleDataSet) do
  begin
    RegisterConstructor(@TSimpleDataSet.Create, 'Create');
    RegisterPropertyHelper(@TSimpleDataSetConnection_R,@TSimpleDataSetConnection_W,'Connection');
    RegisterPropertyHelper(@TSimpleDataSetDataSet_R,nil,'DataSet');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TInternalSQLDataSet(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TInternalSQLDataSet) do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_SimpleDS(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TInternalSQLDataSet(CL);
  RIRegister_TSimpleDataSet(CL);
end;

 
 
{ TPSImport_SimpleDS }
(*----------------------------------------------------------------------------*)
procedure TPSImport_SimpleDS.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_SimpleDS(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_SimpleDS.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_SimpleDS(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
