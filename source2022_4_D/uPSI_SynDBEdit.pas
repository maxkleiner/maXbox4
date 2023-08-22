unit uPSI_SynDBEdit;
{
  syn and db
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
  TPSImport_SynDBEdit = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TDBSynEdit(CL: TPSPascalCompiler);
procedure SIRegister_TCustomDBSynEdit(CL: TPSPascalCompiler);
procedure SIRegister_SynDBEdit(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TDBSynEdit(CL: TPSRuntimeClassImporter);
procedure RIRegister_TCustomDBSynEdit(CL: TPSRuntimeClassImporter);
procedure RIRegister_SynDBEdit(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   DbTables
  {,Qt
  ,QControls
  ,QDBCtrls
  ,QSynEdit
  ,QSynEditKeyCmds }
  ,Windows
  ,Messages
  ,Controls
  ,DbCtrls
  ,SynEdit
  ,SynEditKeyCmds
  ,DB
  ,SynDBEdit
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_SynDBEdit]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TDBSynEdit(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TCustomDBSynEdit', 'TDBSynEdit') do
  with CL.AddClassN(CL.FindClass('TCustomDBSynEdit'),'TDBSynEdit') do begin
  RegisterPublishedProperties;
  RegisterProperty('CANMODIFY', 'BOOLEAN', iptr);
  RegisterProperty('DATAFIELD', 'string', iptrw);
  RegisterProperty('DATASOURCE', 'TDATASOURCE', iptr);
  RegisterProperty('FIELD', 'TField', iptr);

  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TCustomDBSynEdit(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TCustomSynEdit', 'TCustomDBSynEdit') do
  with CL.AddClassN(CL.FindClass('TCustomSynEdit'),'TCustomDBSynEdit') do
  begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
    RegisterMethod('Procedure DragDrop( Source : TObject; X, Y : Integer)');
    RegisterMethod('Procedure ExecuteCommand( Command : TSynEditorCommand; AChar : char; Data : pointer)');
    RegisterMethod('Procedure LoadMemo');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_SynDBEdit(CL: TPSPascalCompiler);
begin
  SIRegister_TCustomDBSynEdit(CL);
  SIRegister_TDBSynEdit(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure RIRegister_TDBSynEdit(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TDBSynEdit) do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TCustomDBSynEdit(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TCustomDBSynEdit) do
  begin
    RegisterConstructor(@TCustomDBSynEdit.Create, 'Create');
    RegisterMethod(@TCustomDBSynEdit.DragDrop, 'DragDrop');
    RegisterMethod(@TCustomDBSynEdit.ExecuteCommand, 'ExecuteCommand');
    RegisterMethod(@TCustomDBSynEdit.LoadMemo, 'LoadMemo');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_SynDBEdit(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TCustomDBSynEdit(CL);
  RIRegister_TDBSynEdit(CL);
end;

 
 
{ TPSImport_SynDBEdit }
(*----------------------------------------------------------------------------*)
procedure TPSImport_SynDBEdit.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_SynDBEdit(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_SynDBEdit.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_SynDBEdit(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
