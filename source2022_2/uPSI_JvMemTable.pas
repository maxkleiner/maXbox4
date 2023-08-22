unit uPSI_JvMemTable;
{
  no routines an object!
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
  TPSImport_JvMemTable = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TJvMemoryTable(CL: TPSPascalCompiler);
procedure SIRegister_JvMemTable(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TJvMemoryTable(CL: TPSRuntimeClassImporter);
procedure RIRegister_JvMemTable(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   Bde
  ,DbiTypes
  ,DbiProcs
  ,DbiErrs
  ,DB
  ,DBTables
  ,JvMemTable
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_JvMemTable]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TJvMemoryTable(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TDBDataSet', 'TJvMemoryTable') do
  with CL.AddClassN(CL.FindClass('TDBDataSet'),'TJvMemoryTable') do begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
    RegisterMethod('Function BatchMove( ASource : TDataSet; AMode : TBatchMode; ARecordCount : Longint) : Longint');
    RegisterMethod('Procedure CopyStructure( ASource : TDataSet)');
    RegisterMethod('Procedure CreateTable');
    RegisterMethod('Procedure DeleteTable');
    RegisterMethod('Procedure EmptyTable');
    RegisterMethod('Procedure GotoRecord( RecordNo : Longint)');
    RegisterMethod('Function GetFieldData( Field : TField; Buffer : Pointer) : Boolean');
    RegisterMethod('Function IsSequenced : Boolean');
    RegisterMethod('Function Locate( const KeyFields : string; const KeyValues : Variant; Options : TLocateOptions) : Boolean');
    RegisterMethod('Function Lookup( const KeyFields : string; const KeyValues : Variant; const ResultFields : string) : Variant');
    RegisterMethod('Procedure SetFieldValues( const FieldNames : array of string; const Values : array of const)');
    RegisterProperty('RecordCount', 'Longint', iptr);
    RegisterProperty('RecNo', 'Longint', iptrw);
    RegisterProperty('EnableDelete', 'Boolean', iptrw);
    RegisterProperty('TableName', 'TFileName', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_JvMemTable(CL: TPSPascalCompiler);
begin
  SIRegister_TJvMemoryTable(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TJvMemoryTableTableName_W(Self: TJvMemoryTable; const T: TFileName);
begin Self.TableName := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvMemoryTableTableName_R(Self: TJvMemoryTable; var T: TFileName);
begin T := Self.TableName; end;

(*----------------------------------------------------------------------------*)
procedure TJvMemoryTableEnableDelete_W(Self: TJvMemoryTable; const T: Boolean);
begin Self.EnableDelete := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvMemoryTableEnableDelete_R(Self: TJvMemoryTable; var T: Boolean);
begin T := Self.EnableDelete; end;

(*----------------------------------------------------------------------------*)
procedure TJvMemoryTableRecNo_W(Self: TJvMemoryTable; const T: Longint);
begin Self.RecNo := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvMemoryTableRecNo_R(Self: TJvMemoryTable; var T: Longint);
begin T := Self.RecNo; end;

(*----------------------------------------------------------------------------*)
procedure TJvMemoryTableRecordCount_R(Self: TJvMemoryTable; var T: Longint);
begin T := Self.RecordCount; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJvMemoryTable(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJvMemoryTable) do begin
    RegisterConstructor(@TJvMemoryTable.Create, 'Create');
    RegisterMethod(@TJvMemoryTable.BatchMove, 'BatchMove');
    RegisterMethod(@TJvMemoryTable.CopyStructure, 'CopyStructure');
    RegisterMethod(@TJvMemoryTable.CreateTable, 'CreateTable');
    RegisterMethod(@TJvMemoryTable.DeleteTable, 'DeleteTable');
    RegisterMethod(@TJvMemoryTable.EmptyTable, 'EmptyTable');
    RegisterMethod(@TJvMemoryTable.GotoRecord, 'GotoRecord');
    RegisterMethod(@TJvMemoryTable.GetFieldData, 'GetFieldData');
    RegisterMethod(@TJvMemoryTable.IsSequenced, 'IsSequenced');
    RegisterMethod(@TJvMemoryTable.Locate, 'Locate');
    RegisterMethod(@TJvMemoryTable.Lookup, 'Lookup');
    RegisterMethod(@TJvMemoryTable.SetFieldValues, 'SetFieldValues');
    RegisterPropertyHelper(@TJvMemoryTableRecordCount_R,nil,'RecordCount');
    RegisterPropertyHelper(@TJvMemoryTableRecNo_R,@TJvMemoryTableRecNo_W,'RecNo');
    RegisterPropertyHelper(@TJvMemoryTableEnableDelete_R,@TJvMemoryTableEnableDelete_W,'EnableDelete');
    RegisterPropertyHelper(@TJvMemoryTableTableName_R,@TJvMemoryTableTableName_W,'TableName');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_JvMemTable(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TJvMemoryTable(CL);
end;

 
 
{ TPSImport_JvMemTable }
(*----------------------------------------------------------------------------*)
procedure TPSImport_JvMemTable.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_JvMemTable(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_JvMemTable.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_JvMemTable(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
