unit uPSI_TabGrid;
{
   grid it
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
  TPSImport_TabGrid = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TDBTabGrid(CL: TPSPascalCompiler);
procedure SIRegister_TabGrid(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TabGrid_Routines(S: TPSExec);
procedure RIRegister_TDBTabGrid(CL: TPSRuntimeClassImporter);
procedure RIRegister_TabGrid(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   Variants
  ,Windows
  ,Messages
  ,Controls
  ,Forms
  ,Graphics
  ,StdCtrls
  ,DBCtrls
  ,Grids
  ,DBGrids
  ,Db
  ,DBTables
  ,TabGrid
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_TabGrid]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TDBTabGrid(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TCustomDBGrid', 'TDBTabGrid') do
  with CL.AddClassN(CL.FindClass('TCustomDBGrid'),'TDBTabGrid') do begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
    RegisterMethod('Procedure Free');
    RegisterMethod('Procedure WriteText( ACanvas : TCanvas; ARect : TRect; DX, DY : Integer; const Text : string; Alignment : TAlignment; ARightToLeft : Boolean)');
    RegisterMethod('Function GetScrollBarWidth : Integer');
    RegisterProperty('ShowArrow', 'Boolean', iptrw);
    RegisterProperty('SortColumn', 'string', iptrw);
    RegisterProperty('SortDesc', 'Boolean', iptrw);
    RegisterProperty('EnterKeyIsTabKey', 'Boolean', iptrw);
    RegisterProperty('AlternateRowColor', 'TColor', iptrw);
    RegisterProperty('AutoAppend', 'Boolean', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TabGrid(CL: TPSPascalCompiler);
begin
  SIRegister_TDBTabGrid(CL);
 //CL.AddDelphiFunction('Procedure Register');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TDBTabGridAutoAppend_W(Self: TDBTabGrid; const T: Boolean);
begin Self.AutoAppend := T; end;

(*----------------------------------------------------------------------------*)
procedure TDBTabGridAutoAppend_R(Self: TDBTabGrid; var T: Boolean);
begin T := Self.AutoAppend; end;

(*----------------------------------------------------------------------------*)
procedure TDBTabGridAlternateRowColor_W(Self: TDBTabGrid; const T: TColor);
begin Self.AlternateRowColor := T; end;

(*----------------------------------------------------------------------------*)
procedure TDBTabGridAlternateRowColor_R(Self: TDBTabGrid; var T: TColor);
begin T := Self.AlternateRowColor; end;

(*----------------------------------------------------------------------------*)
procedure TDBTabGridEnterKeyIsTabKey_W(Self: TDBTabGrid; const T: Boolean);
begin Self.EnterKeyIsTabKey := T; end;

(*----------------------------------------------------------------------------*)
procedure TDBTabGridEnterKeyIsTabKey_R(Self: TDBTabGrid; var T: Boolean);
begin T := Self.EnterKeyIsTabKey; end;

(*----------------------------------------------------------------------------*)
procedure TDBTabGridSortDesc_W(Self: TDBTabGrid; const T: Boolean);
begin Self.SortDesc := T; end;

(*----------------------------------------------------------------------------*)
procedure TDBTabGridSortDesc_R(Self: TDBTabGrid; var T: Boolean);
begin T := Self.SortDesc; end;

(*----------------------------------------------------------------------------*)
procedure TDBTabGridSortColumn_W(Self: TDBTabGrid; const T: string);
begin Self.SortColumn := T; end;

(*----------------------------------------------------------------------------*)
procedure TDBTabGridSortColumn_R(Self: TDBTabGrid; var T: string);
begin T := Self.SortColumn; end;

(*----------------------------------------------------------------------------*)
procedure TDBTabGridShowArrow_W(Self: TDBTabGrid; const T: Boolean);
begin Self.ShowArrow := T; end;

(*----------------------------------------------------------------------------*)
procedure TDBTabGridShowArrow_R(Self: TDBTabGrid; var T: Boolean);
begin T := Self.ShowArrow; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TabGrid_Routines(S: TPSExec);
begin
 //S.RegisterDelphiFunction(@Register, 'Register', cdRegister);
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TDBTabGrid(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TDBTabGrid) do begin
    RegisterConstructor(@TDBTabGrid.Create, 'Create');
          RegisterMethod(@TDBTabGrid.Destroy, 'Free');
       RegisterMethod(@TDBTabGrid.WriteText, 'WriteText');
    RegisterMethod(@TDBTabGrid.GetScrollBarWidth, 'GetScrollBarWidth');
    RegisterPropertyHelper(@TDBTabGridShowArrow_R,@TDBTabGridShowArrow_W,'ShowArrow');
    RegisterPropertyHelper(@TDBTabGridSortColumn_R,@TDBTabGridSortColumn_W,'SortColumn');
    RegisterPropertyHelper(@TDBTabGridSortDesc_R,@TDBTabGridSortDesc_W,'SortDesc');
    RegisterPropertyHelper(@TDBTabGridEnterKeyIsTabKey_R,@TDBTabGridEnterKeyIsTabKey_W,'EnterKeyIsTabKey');
    RegisterPropertyHelper(@TDBTabGridAlternateRowColor_R,@TDBTabGridAlternateRowColor_W,'AlternateRowColor');
    RegisterPropertyHelper(@TDBTabGridAutoAppend_R,@TDBTabGridAutoAppend_W,'AutoAppend');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TabGrid(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TDBTabGrid(CL);
end;

 
 
{ TPSImport_TabGrid }
(*----------------------------------------------------------------------------*)
procedure TPSImport_TabGrid.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_TabGrid(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_TabGrid.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_TabGrid(ri);
  RIRegister_TabGrid_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
