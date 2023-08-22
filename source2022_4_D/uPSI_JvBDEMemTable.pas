unit uPSI_JvBDEMemTable;
{
  for scholz software
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
  TPSImport_JvBDEMemTable = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TJvBDEMemoryTable(CL: TPSPascalCompiler);
procedure SIRegister_JvBDEMemTable(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TJvBDEMemoryTable(CL: TPSRuntimeClassImporter);
procedure RIRegister_JvBDEMemTable(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
  // JclUnitVersioning
  BDE
  ,DB
  ,DBTables
  ,JvBDEMemTable
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_JvBDEMemTable]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TJvBDEMemoryTable(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TDBDataSet', 'TJvBDEMemoryTable') do
  with CL.AddClassN(CL.FindClass('TDBDataSet'),'TJvBDEMemoryTable') do begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
    RegisterMethod('Procedure Free');
    RegisterMethod('Function BatchMove( ASource : TDataSet; AMode : TBatchMode; ARecordCount : Longint) : Longint');
    RegisterMethod('Procedure CopyStructure( ASource : TDataSet)');
    RegisterMethod('Procedure CreateTable');
    RegisterMethod('Procedure DeleteTable');
    RegisterMethod('Procedure EmptyTable');
    RegisterMethod('Procedure GotoRecord( RecordNo : Longint)');
    RegisterMethod('Procedure SetFieldValues( const FieldNames : array of string; const Values : array of const)');
    RegisterProperty('EnableDelete', 'Boolean', iptrw);
    RegisterProperty('TableName', 'TFileName', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_JvBDEMemTable(CL: TPSPascalCompiler);
begin
  SIRegister_TJvBDEMemoryTable(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TJvBDEMemoryTableTableName_W(Self: TJvBDEMemoryTable; const T: TFileName);
begin Self.TableName := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvBDEMemoryTableTableName_R(Self: TJvBDEMemoryTable; var T: TFileName);
begin T := Self.TableName; end;

(*----------------------------------------------------------------------------*)
procedure TJvBDEMemoryTableEnableDelete_W(Self: TJvBDEMemoryTable; const T: Boolean);
begin Self.EnableDelete := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvBDEMemoryTableEnableDelete_R(Self: TJvBDEMemoryTable; var T: Boolean);
begin T := Self.EnableDelete; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJvBDEMemoryTable(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJvBDEMemoryTable) do begin
    RegisterConstructor(@TJvBDEMemoryTable.Create, 'Create');
    RegisterMethod(@TJvBDEMemoryTable.Destroy, 'Free');
    RegisterMethod(@TJvBDEMemoryTable.BatchMove, 'BatchMove');
    RegisterMethod(@TJvBDEMemoryTable.CopyStructure, 'CopyStructure');
    RegisterMethod(@TJvBDEMemoryTable.CreateTable, 'CreateTable');
    RegisterMethod(@TJvBDEMemoryTable.DeleteTable, 'DeleteTable');
    RegisterMethod(@TJvBDEMemoryTable.EmptyTable, 'EmptyTable');
    RegisterMethod(@TJvBDEMemoryTable.GotoRecord, 'GotoRecord');
    RegisterMethod(@TJvBDEMemoryTable.SetFieldValues, 'SetFieldValues');
    RegisterPropertyHelper(@TJvBDEMemoryTableEnableDelete_R,@TJvBDEMemoryTableEnableDelete_W,'EnableDelete');
    RegisterPropertyHelper(@TJvBDEMemoryTableTableName_R,@TJvBDEMemoryTableTableName_W,'TableName');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_JvBDEMemTable(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TJvBDEMemoryTable(CL);
end;

 
 
{ TPSImport_JvBDEMemTable }
(*----------------------------------------------------------------------------*)
procedure TPSImport_JvBDEMemTable.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_JvBDEMemTable(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_JvBDEMemTable.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_JvBDEMemTable(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
