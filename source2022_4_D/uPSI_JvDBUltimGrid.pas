unit uPSI_JvDBUltimGrid;
{
This file has been generated by UnitParser v0.7, written by M. Knight
and updated by NP. v/d Spek and George Birbilis. 
Source Code from Carlo Kok has been used to implement various sections of
UnitParser. Components of ROPS are used in the construction of UnitParser,
code implementing the class wrapper is taken from Carlo Kok's conv utility

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
  TPSImport_JvDBUltimGrid = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TJvDBUltimGrid(CL: TPSPascalCompiler);
procedure SIRegister_JvDBUltimGrid(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TJvDBUltimGrid(CL: TPSRuntimeClassImporter);
procedure RIRegister_JvDBUltimGrid(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
  // JclUnitVersioning
  Windows
  ,Variants
  ,Graphics
  ,Controls
  ,DB
  //,JvDBGrid
  ,JvTypes
  ,JvDBUltimGrid
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_JvDBUltimGrid]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
Function BoolToStr(value : boolean) : string;
Begin If value then Result := 'TRUE' else Result := 'FALSE' End;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TJvDBUltimGrid(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TJvDBGrid', 'TJvDBUltimGrid') do
  with CL.AddClassN(CL.FindClass('TJvDBGrid'),'TJvDBUltimGrid') do begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
    RegisterMethod('Procedure Free');
    RegisterMethod('Procedure Sort( FieldsToSort : TSortFields)');
    RegisterProperty('SortedFields', 'TSortFields', iptr);
    RegisterProperty('SortOK', 'Boolean', iptr);
    RegisterMethod('Procedure SaveGridPosition');
    RegisterMethod('Procedure RestoreGridPosition');
    RegisterProperty('SearchFields', 'TStringList', iptrw);
    RegisterMethod('Function Search( const ValueToSearch : Variant; var ResultCol : Integer; var ResultField : TField; const CaseSensitive, WholeFieldOnly, Focus : Boolean) : Boolean');
    RegisterMethod('Function SearchNext( var ResultCol : Integer; var ResultField : TField; const CaseSensitive, WholeFieldOnly, Focus : Boolean) : Boolean');
    RegisterProperty('SortWith', 'TSortWith', iptrw);
    RegisterProperty('MultiColSort', 'Boolean', iptrw);
    RegisterProperty('OnIndexNotFound', 'TIndexNotFoundEvent', iptrw);
    RegisterProperty('OnUserSort', 'TUserSortEvent', iptrw);
    RegisterProperty('OnCheckIfValidSortField', 'TCheckIfValidSortFieldEvent', iptrw);
    RegisterProperty('OnRestoreGridPosition', 'TRestoreGridPosEvent', iptrw);
    RegisterProperty('OnGetSortFieldName', 'TGetSortFieldNameEvent', iptrw);
    RegisterProperty('OnAfterSort', 'TNotifyEvent', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_JvDBUltimGrid(CL: TPSPascalCompiler);
begin
 //CL.AddConstantN('JvGridSort_ASC','Boolean')BoolToStr( True);
 //CL.AddConstantN('JvGridSort_UP','Boolean')BoolToStr( True);
 //CL.AddConstantN('JvGridSort_DESC','Boolean')BoolToStr( True);
 //CL.AddConstantN('JvGridSort_DOWN','Boolean')BoolToStr( True);
  CL.AddTypeS('TSortField', 'record Name : string; Order : Boolean; end');
  CL.AddTypeS('TSortFields', 'array of TSortField');
  CL.AddClassN(CL.FindClass('TOBJECT'),'TJvDBUltimGrid');
  CL.AddTypeS('TIndexNotFoundEvent', 'Procedure ( Sender : TJvDBUltimGrid; Fiel'
   +'dsToSort : TSortFields; IndexFieldNames : string; DescFields : string; var Retry : Boolean)');
  CL.AddTypeS('TUserSortEvent', 'Procedure ( Sender : TJvDBUltimGrid; var Field'
   +'sToSort : TSortFields; SortString : string; var SortOK : Boolean)');
  CL.AddTypeS('TRestoreGridPosEvent', 'Procedure ( Sender : TJvDBUltimGrid; Sav'
   +'edBookmark : TBookmark; SavedRowPos : Integer)');
  CL.AddTypeS('TCheckIfValidSortFieldEvent', 'Function ( Sender : TJvDBUltimGri'
   +'d; FieldToSort : TField) : Boolean');
  CL.AddTypeS('TGetSortFieldNameEvent', 'Procedure ( Sender : TJvDBUltimGrid; var FieldName : string)');
  CL.AddTypeS('TSortWith', '( swIndex, swFields, swUserFunc, swWhere )');
  SIRegister_TJvDBUltimGrid(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TJvDBUltimGridOnAfterSort_W(Self: TJvDBUltimGrid; const T: TNotifyEvent);
begin Self.OnAfterSort := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvDBUltimGridOnAfterSort_R(Self: TJvDBUltimGrid; var T: TNotifyEvent);
begin T := Self.OnAfterSort; end;

(*----------------------------------------------------------------------------*)
procedure TJvDBUltimGridOnGetSortFieldName_W(Self: TJvDBUltimGrid; const T: TGetSortFieldNameEvent);
begin Self.OnGetSortFieldName := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvDBUltimGridOnGetSortFieldName_R(Self: TJvDBUltimGrid; var T: TGetSortFieldNameEvent);
begin T := Self.OnGetSortFieldName; end;

(*----------------------------------------------------------------------------*)
procedure TJvDBUltimGridOnRestoreGridPosition_W(Self: TJvDBUltimGrid; const T: TRestoreGridPosEvent);
begin Self.OnRestoreGridPosition := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvDBUltimGridOnRestoreGridPosition_R(Self: TJvDBUltimGrid; var T: TRestoreGridPosEvent);
begin T := Self.OnRestoreGridPosition; end;

(*----------------------------------------------------------------------------*)
procedure TJvDBUltimGridOnCheckIfValidSortField_W(Self: TJvDBUltimGrid; const T: TCheckIfValidSortFieldEvent);
begin Self.OnCheckIfValidSortField := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvDBUltimGridOnCheckIfValidSortField_R(Self: TJvDBUltimGrid; var T: TCheckIfValidSortFieldEvent);
begin T := Self.OnCheckIfValidSortField; end;

(*----------------------------------------------------------------------------*)
procedure TJvDBUltimGridOnUserSort_W(Self: TJvDBUltimGrid; const T: TUserSortEvent);
begin Self.OnUserSort := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvDBUltimGridOnUserSort_R(Self: TJvDBUltimGrid; var T: TUserSortEvent);
begin T := Self.OnUserSort; end;

(*----------------------------------------------------------------------------*)
procedure TJvDBUltimGridOnIndexNotFound_W(Self: TJvDBUltimGrid; const T: TIndexNotFoundEvent);
begin Self.OnIndexNotFound := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvDBUltimGridOnIndexNotFound_R(Self: TJvDBUltimGrid; var T: TIndexNotFoundEvent);
begin T := Self.OnIndexNotFound; end;

(*----------------------------------------------------------------------------*)
procedure TJvDBUltimGridMultiColSort_W(Self: TJvDBUltimGrid; const T: Boolean);
begin Self.MultiColSort := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvDBUltimGridMultiColSort_R(Self: TJvDBUltimGrid; var T: Boolean);
begin T := Self.MultiColSort; end;

(*----------------------------------------------------------------------------*)
procedure TJvDBUltimGridSortWith_W(Self: TJvDBUltimGrid; const T: TSortWith);
begin Self.SortWith := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvDBUltimGridSortWith_R(Self: TJvDBUltimGrid; var T: TSortWith);
begin T := Self.SortWith; end;

(*----------------------------------------------------------------------------*)
procedure TJvDBUltimGridSearchFields_W(Self: TJvDBUltimGrid; const T: TStringList);
begin Self.SearchFields := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvDBUltimGridSearchFields_R(Self: TJvDBUltimGrid; var T: TStringList);
begin T := Self.SearchFields; end;

(*----------------------------------------------------------------------------*)
procedure TJvDBUltimGridSortOK_R(Self: TJvDBUltimGrid; var T: Boolean);
begin T := Self.SortOK; end;

(*----------------------------------------------------------------------------*)
procedure TJvDBUltimGridSortedFields_R(Self: TJvDBUltimGrid; var T: TSortFields);
begin T := Self.SortedFields; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJvDBUltimGrid(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJvDBUltimGrid) do begin
    RegisterConstructor(@TJvDBUltimGrid.Create, 'Create');
    RegisterMethod(@TJvDBUltimGrid.Destroy, 'Free');
    RegisterMethod(@TJvDBUltimGrid.Sort, 'Sort');
    RegisterPropertyHelper(@TJvDBUltimGridSortedFields_R,nil,'SortedFields');
    RegisterPropertyHelper(@TJvDBUltimGridSortOK_R,nil,'SortOK');
    RegisterMethod(@TJvDBUltimGrid.SaveGridPosition, 'SaveGridPosition');
    RegisterMethod(@TJvDBUltimGrid.RestoreGridPosition, 'RestoreGridPosition');
    RegisterPropertyHelper(@TJvDBUltimGridSearchFields_R,@TJvDBUltimGridSearchFields_W,'SearchFields');
    RegisterMethod(@TJvDBUltimGrid.Search, 'Search');
    RegisterMethod(@TJvDBUltimGrid.SearchNext, 'SearchNext');
    RegisterPropertyHelper(@TJvDBUltimGridSortWith_R,@TJvDBUltimGridSortWith_W,'SortWith');
    RegisterPropertyHelper(@TJvDBUltimGridMultiColSort_R,@TJvDBUltimGridMultiColSort_W,'MultiColSort');
    RegisterPropertyHelper(@TJvDBUltimGridOnIndexNotFound_R,@TJvDBUltimGridOnIndexNotFound_W,'OnIndexNotFound');
    RegisterPropertyHelper(@TJvDBUltimGridOnUserSort_R,@TJvDBUltimGridOnUserSort_W,'OnUserSort');
    RegisterPropertyHelper(@TJvDBUltimGridOnCheckIfValidSortField_R,@TJvDBUltimGridOnCheckIfValidSortField_W,'OnCheckIfValidSortField');
    RegisterPropertyHelper(@TJvDBUltimGridOnRestoreGridPosition_R,@TJvDBUltimGridOnRestoreGridPosition_W,'OnRestoreGridPosition');
    RegisterPropertyHelper(@TJvDBUltimGridOnGetSortFieldName_R,@TJvDBUltimGridOnGetSortFieldName_W,'OnGetSortFieldName');
    RegisterPropertyHelper(@TJvDBUltimGridOnAfterSort_R,@TJvDBUltimGridOnAfterSort_W,'OnAfterSort');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_JvDBUltimGrid(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJvDBUltimGrid) do
  RIRegister_TJvDBUltimGrid(CL);
end;

 
 
{ TPSImport_JvDBUltimGrid }
(*----------------------------------------------------------------------------*)
procedure TPSImport_JvDBUltimGrid.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_JvDBUltimGrid(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_JvDBUltimGrid.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_JvDBUltimGrid(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
