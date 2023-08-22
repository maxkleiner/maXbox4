unit uPSI_cyBDE;
{
   good old bde
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
  TPSImport_cyBDE = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_cyBDE(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_cyBDE_Routines(S: TPSExec);

procedure Register;

implementation


uses
   Controls
  ,BDE
  ,Db
  ,DbTables
  ,cyBDE
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_cyBDE]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_cyBDE(CL: TPSPascalCompiler);
begin
 CL.AddDelphiFunction('Function TablePackTable( Tab : TTable) : Boolean');
 CL.AddDelphiFunction('Function TableRegenIndexes( Tab : TTable) : Boolean');
 CL.AddDelphiFunction('Function TableShowDeletedRecords( Tab : TTable; Show : Boolean) : Boolean');
 CL.AddDelphiFunction('Function TableUndeleteRecord( Tab : TTable) : Boolean');
 CL.AddDelphiFunction('Function TableAddIndex( Tab : TTable; FieldName : String; FieldExpression : String; IOpt : TIndexOptions) : Boolean');
 CL.AddDelphiFunction('Function TableDeleteIndex( Tab : TTable; IndexFieldName : String) : Boolean');
 CL.AddDelphiFunction('Function TableEmptyTable( Tab : TTable) : Boolean');
 CL.AddDelphiFunction('Function TableFindKey( aTable : TTable; Value : String) : Boolean');
 CL.AddDelphiFunction('Procedure TableFindNearest( aTable : TTable; Value : String)');
 CL.AddDelphiFunction('Function TableCreate( Owner : TComponent; DataBaseName : ShortString; TableName : String; IndexName : ShortString; ReadOnly : Boolean) : TTable');
 CL.AddDelphiFunction('Function TableOpen( Tab : TTable; FileName : String; IndexFieldName : String; RecordIndexValue : Variant; GotoRecordIndexValue : Boolean) : Boolean');
 CL.AddDelphiFunction('Function DateToBDESQLDate( aDate : TDate; const DateFormat : String) : String');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure RIRegister_cyBDE_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@TablePackTable, 'TablePackTable', cdRegister);
 S.RegisterDelphiFunction(@TableRegenIndexes, 'TableRegenIndexes', cdRegister);
 S.RegisterDelphiFunction(@TableShowDeletedRecords, 'TableShowDeletedRecords', cdRegister);
 S.RegisterDelphiFunction(@TableUndeleteRecord, 'TableUndeleteRecord', cdRegister);
 S.RegisterDelphiFunction(@TableAddIndex, 'TableAddIndex', cdRegister);
 S.RegisterDelphiFunction(@TableDeleteIndex, 'TableDeleteIndex', cdRegister);
 S.RegisterDelphiFunction(@TableEmptyTable, 'TableEmptyTable', cdRegister);
 S.RegisterDelphiFunction(@TableFindKey, 'TableFindKey', cdRegister);
 S.RegisterDelphiFunction(@TableFindNearest, 'TableFindNearest', cdRegister);
 S.RegisterDelphiFunction(@TableCreate, 'TableCreate', cdRegister);
 S.RegisterDelphiFunction(@TableOpen, 'TableOpen', cdRegister);
 S.RegisterDelphiFunction(@DateToBDESQLDate, 'DateToBDESQLDate', cdRegister);
end;

 
 
{ TPSImport_cyBDE }
(*----------------------------------------------------------------------------*)
procedure TPSImport_cyBDE.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_cyBDE(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_cyBDE.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  //RIRegister_cyBDE(ri);
  RIRegister_cyBDE_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
