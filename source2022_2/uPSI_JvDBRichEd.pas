unit uPSI_JvDBRichEd;
{
  with riched
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
  TPSImport_JvDBRichEd = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TJvDBRichEdit(CL: TPSPascalCompiler);
procedure SIRegister_JvDBRichEd(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TJvDBRichEdit(CL: TPSRuntimeClassImporter);
procedure RIRegister_JvDBRichEd(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   Windows
  ,Messages
  ,ComCtrls
  ,RichEdit
  ,Graphics
  ,Controls
  ,Menus
  ,StdCtrls
  ,DB
  ,DBCtrls
  ,JvRichEd
  ,JvDBRichEd
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_JvDBRichEd]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TJvDBRichEdit(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TJvCustomRichEdit', 'TJvDBRichEdit') do
  with CL.AddClassN(CL.FindClass('TJvCustomRichEdit'),'TJvDBRichEdit') do begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
    RegisterMethod('Procedure LoadMemo');
    RegisterMethod('Procedure UpdateMemo');
    RegisterMethod('Function ExecuteAction( Action : TBasicAction) : Boolean');
    RegisterMethod('Function UpdateAction( Action : TBasicAction) : Boolean');
    RegisterMethod('Function UseRightToLeftAlignment : Boolean');
    RegisterProperty('Field', 'TField', iptr);
    RegisterProperty('AutoDisplay', 'Boolean', iptrw);
    RegisterProperty('DataField', 'string', iptrw);
    RegisterProperty('DataSource', 'TDataSource', iptrw);
    RegisterProperty('ReadOnly', 'Boolean', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_JvDBRichEd(CL: TPSPascalCompiler);
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
  with CL.Add(TJvDBRichEdit) do
  begin
    RegisterConstructor(@TJvDBRichEdit.Create, 'Create');
    RegisterVirtualMethod(@TJvDBRichEdit.LoadMemo, 'LoadMemo');
    RegisterMethod(@TJvDBRichEdit.UpdateMemo, 'UpdateMemo');
    RegisterMethod(@TJvDBRichEdit.ExecuteAction, 'ExecuteAction');
    RegisterMethod(@TJvDBRichEdit.UpdateAction, 'UpdateAction');
    RegisterMethod(@TJvDBRichEdit.UseRightToLeftAlignment, 'UseRightToLeftAlignment');
    RegisterPropertyHelper(@TJvDBRichEditField_R,nil,'Field');
    RegisterPropertyHelper(@TJvDBRichEditAutoDisplay_R,@TJvDBRichEditAutoDisplay_W,'AutoDisplay');
    RegisterPropertyHelper(@TJvDBRichEditDataField_R,@TJvDBRichEditDataField_W,'DataField');
    RegisterPropertyHelper(@TJvDBRichEditDataSource_R,@TJvDBRichEditDataSource_W,'DataSource');
    RegisterPropertyHelper(@TJvDBRichEditReadOnly_R,@TJvDBRichEditReadOnly_W,'ReadOnly');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_JvDBRichEd(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TJvDBRichEdit(CL);
end;

 
 
{ TPSImport_JvDBRichEd }
(*----------------------------------------------------------------------------*)
procedure TPSImport_JvDBRichEd.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_JvDBRichEd(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_JvDBRichEd.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_JvDBRichEd(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
