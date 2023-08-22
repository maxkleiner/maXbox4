unit uPSI_JvDBRichEdit;
{
   rich on DB add free
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
  TPSImport_JvDBRichEdit = class(TPSPlugin)
  public
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TJvDBRichEdit(CL: TPSPascalCompiler);
procedure SIRegister_JvDBRichEdit(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TJvDBRichEdit(CL: TPSRuntimeClassImporter);
procedure RIRegister_JvDBRichEdit(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
 //  JclUnitVersioning
  Windows
  ,Messages
  ,RichEdit
  ,Controls
  ,DB
  ,DBCtrls
  ,JvRichEdit
  ,JvDBRichEdit
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_JvDBRichEdit]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TJvDBRichEdit(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TJvCustomRichEdit', 'TJvDBRichEdit') do
  with CL.AddClassN(CL.FindClass('TJvCustomRichEdit'),'TJvDBRichEdit') do begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
     RegisterMethod('Procedure Free');
     RegisterMethod('Procedure LoadMemo');
    RegisterMethod('Procedure UpdateMemo');
    RegisterMethod('Function ExecuteAction( Action : TBasicAction) : Boolean');
    RegisterMethod('Function UpdateAction( Action : TBasicAction) : Boolean');
    RegisterMethod('Function UseRightToLeftAlignment : Boolean');
    RegisterProperty('Field', 'TField', iptr);
    RegisterProperty('AutoDisplay', 'Boolean', iptrw);
    RegisterProperty('BeepOnError', 'Boolean', iptrw);
    RegisterProperty('DataField', 'string', iptrw);
    RegisterProperty('DataSource', 'TDataSource', iptrw);
    RegisterProperty('ReadOnly', 'Boolean', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_JvDBRichEdit(CL: TPSPascalCompiler);
begin
  SIRegister_TJvDBRichEdit(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TJvDBRichEditReadOnly_W(Self: TJvDBRichEdit; const T: Boolean);
begin Self.ReadOnly := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvDBRichEditReadOnly_R(Self: TJvDBRichEdit; var T: Boolean);
begin T := Self.ReadOnly; end;

(*----------------------------------------------------------------------------*)
procedure TJvDBRichEditDataSource_W(Self: TJvDBRichEdit; const T: TDataSource);
begin Self.DataSource := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvDBRichEditDataSource_R(Self: TJvDBRichEdit; var T: TDataSource);
begin T := Self.DataSource; end;

(*----------------------------------------------------------------------------*)
procedure TJvDBRichEditDataField_W(Self: TJvDBRichEdit; const T: string);
begin Self.DataField := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvDBRichEditDataField_R(Self: TJvDBRichEdit; var T: string);
begin T := Self.DataField; end;

(*----------------------------------------------------------------------------*)
procedure TJvDBRichEditBeepOnError_W(Self: TJvDBRichEdit; const T: Boolean);
begin Self.BeepOnError := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvDBRichEditBeepOnError_R(Self: TJvDBRichEdit; var T: Boolean);
begin T := Self.BeepOnError; end;

(*----------------------------------------------------------------------------*)
procedure TJvDBRichEditAutoDisplay_W(Self: TJvDBRichEdit; const T: Boolean);
begin Self.AutoDisplay := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvDBRichEditAutoDisplay_R(Self: TJvDBRichEdit; var T: Boolean);
begin T := Self.AutoDisplay; end;

(*----------------------------------------------------------------------------*)
procedure TJvDBRichEditField_R(Self: TJvDBRichEdit; var T: TField);
begin T := Self.Field; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJvDBRichEdit(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJvDBRichEdit) do begin
    RegisterConstructor(@TJvDBRichEdit.Create, 'Create');
    RegisterMethod(@TJvDBRichEdit.Destroy, 'Free');
    RegisterMethod(@TJvDBRichEdit.LoadMemo, 'LoadMemo');
    RegisterMethod(@TJvDBRichEdit.UpdateMemo, 'UpdateMemo');
    RegisterMethod(@TJvDBRichEdit.ExecuteAction, 'ExecuteAction');
    RegisterMethod(@TJvDBRichEdit.UpdateAction, 'UpdateAction');
    RegisterMethod(@TJvDBRichEdit.UseRightToLeftAlignment, 'UseRightToLeftAlignment');
    RegisterPropertyHelper(@TJvDBRichEditField_R,nil,'Field');
    RegisterPropertyHelper(@TJvDBRichEditAutoDisplay_R,@TJvDBRichEditAutoDisplay_W,'AutoDisplay');
    RegisterPropertyHelper(@TJvDBRichEditBeepOnError_R,@TJvDBRichEditBeepOnError_W,'BeepOnError');
    RegisterPropertyHelper(@TJvDBRichEditDataField_R,@TJvDBRichEditDataField_W,'DataField');
    RegisterPropertyHelper(@TJvDBRichEditDataSource_R,@TJvDBRichEditDataSource_W,'DataSource');
    RegisterPropertyHelper(@TJvDBRichEditReadOnly_R,@TJvDBRichEditReadOnly_W,'ReadOnly');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_JvDBRichEdit(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TJvDBRichEdit(CL);
end;

 
 
{ TPSImport_JvDBRichEdit }
(*----------------------------------------------------------------------------*)
procedure TPSImport_JvDBRichEdit.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_JvDBRichEdit(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_JvDBRichEdit.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_JvDBRichEdit(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
