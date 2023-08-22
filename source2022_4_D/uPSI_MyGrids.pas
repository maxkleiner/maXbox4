unit uPSI_MyGrids;
{
   base for sort grid
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
  TPSImport_MyGrids = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
//procedure SIRegister_TInplaceEditList(CL: TPSPascalCompiler);
procedure SIRegister_TMyStringGrid(CL: TPSPascalCompiler);
procedure SIRegister_TMyStringGridStrings(CL: TPSPascalCompiler);
procedure SIRegister_TMyDrawGrid(CL: TPSPascalCompiler);
procedure SIRegister_TMyCustomDrawGrid(CL: TPSPascalCompiler);
procedure SIRegister_TMyCustomGrid(CL: TPSPascalCompiler);
//procedure SIRegister_TInplaceEdit(CL: TPSPascalCompiler);
procedure SIRegister_MyGrids(CL: TPSPascalCompiler);

{ run-time registration functions }
//procedure RIRegister_TInplaceEditList(CL: TPSRuntimeClassImporter);
procedure RIRegister_TMyStringGrid(CL: TPSRuntimeClassImporter);
procedure RIRegister_TMyStringGridStrings(CL: TPSRuntimeClassImporter);
procedure RIRegister_TMyDrawGrid(CL: TPSRuntimeClassImporter);
procedure RIRegister_TMyCustomDrawGrid(CL: TPSRuntimeClassImporter);
procedure RIRegister_TMyCustomGrid(CL: TPSRuntimeClassImporter);
//procedure RIRegister_TInplaceEdit(CL: TPSRuntimeClassImporter);
procedure RIRegister_MyGrids(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
  // WinUtils
  //,Maskedit
  //,LMessages
  //,LCLtype
  Mask
  ,Messages
  ,Windows
  ,Variants
  ,Graphics
  ,Menus
  ,Controls
  ,Forms
  ,StdCtrls
  ,MyGrids
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_MyGrids]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TInplaceEditList(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TInPlaceEdit', 'TInplaceEditList') do
  with CL.AddClassN(CL.FindClass('TInPlaceEdit'),'TInplaceEditList') do
  begin
    RegisterMethod('Constructor Create( aOwner : TComponent)');
    RegisterMethod('Procedure RestoreContents');
    RegisterProperty('ActiveList', 'TWinControl', iptrw);
    RegisterProperty('ButtonWidth', 'Integer', iptrw);
    RegisterProperty('DropDownRows', 'Integer', iptrw);
    RegisterProperty('EditStyle', 'TEditStyle', iptr);
    RegisterProperty('ListVisible', 'Boolean', iptrw);
    RegisterProperty('PickList', 'TCustomListbox', iptr);
    RegisterProperty('PickListLoaded', 'Boolean', iptrw);
    RegisterProperty('Pressed', 'Boolean', iptr);
    RegisterProperty('OnEditButtonClick', 'TNotifyEvent', iptrw);
    RegisterProperty('OnGetPickListitems', 'TOnGetPickListItems', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TMyStringGrid(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TMyDrawGrid', 'TMyStringGrid') do
  with CL.AddClassN(CL.FindClass('TMyDrawGrid'),'TMyStringGrid') do begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
    RegisterMethod('Procedure Free');
    RegisterMethod('Procedure Repaint;');
    RegisterMethod('function MouseCoord(X, Y: Integer): TGridCoord;');
    RegisterMethod('Function CellRect( ACol, ARow : Longint) : TRect');
    RegisterMethod('Procedure MouseToCell( X, Y : Integer; var ACol, ARow : Longint)');
    RegisterMethod('Procedure SetBounds(ALeft, ATop, AWidth, AHeight: Integer)');
    RegisterPublishedProperties;
    RegisterProperty('Cells', 'string Integer Integer', iptrw);
    RegisterProperty('Cols', 'TStrings Integer', iptrw);
    RegisterProperty('Objects', 'TObject Integer Integer', iptrw);
    RegisterProperty('Rows', 'TStrings Integer', iptrw);
    //RegisterProperty('Rows', 'TStrings Integer', iptrw);
     RegisterProperty('ColWidths', 'Integer', iptrw);
    RegisterProperty('Col', 'Integer', iptrw);
    RegisterProperty('Row', 'Integer', iptrw);
    RegisterProperty('Colcount', 'Integer', iptrw);
    RegisterProperty('Rowcount', 'Integer', iptrw);
    //RegisterProperty('Objects', 'TObject Integer Integer', iptrw);
    RegisterProperty('RowHeigths', 'Integer', iptrw);
    RegisterProperty('GridHeight', 'Integer', iptrw);
    RegisterProperty('GridWidth', 'Integer', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TMyStringGridStrings(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TStrings', 'TMyStringGridStrings') do
  with CL.AddClassN(CL.FindClass('TStrings'),'TMyStringGridStrings') do begin
    RegisterMethod('Constructor Create( AGrid : TMyStringGrid; AIndex : Longint)');
    RegisterMethod('Function Add( const S : string) : Integer');
    RegisterMethod('Procedure Assign( Source : TPersistent)');
    RegisterMethod('Procedure Clear');
    RegisterMethod('Procedure Delete( Index : Integer)');
    RegisterMethod('Procedure Insert( Index : Integer; const S : string)');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TMyDrawGrid(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TMyCustomDrawGrid', 'TMyDrawGrid') do
  with CL.AddClassN(CL.FindClass('TMyCustomDrawGrid'),'TMyDrawGrid') do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TMyCustomDrawGrid(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TMyCustomGrid', 'TMyCustomDrawGrid') do
  with CL.AddClassN(CL.FindClass('TMyCustomGrid'),'TMyCustomDrawGrid') do
  begin
    RegisterMethod('Function CellRect( ACol, ARow : Longint) : TRect');
    RegisterMethod('Procedure MouseToCell( X, Y : Integer; var ACol, ARow : Longint)');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TMyCustomGrid(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TCustomControl', 'TMyCustomGrid') do
  with CL.AddClassN(CL.FindClass('TCustomControl'),'TMyCustomGrid') do
  begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
    RegisterMethod('Function MouseCoord( X, Y : Integer) : TGridCoord');
    RegisterMethod('Procedure BeginUpdate');
    RegisterMethod('Procedure EndUpdate');
    RegisterProperty('NowUpdating', 'Boolean', iptr);
    RegisterProperty('OnBeginUpdate', 'TNotifyEvent', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TInplaceEdit(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TCustomMaskEdit', 'TInplaceEdit') do
  with CL.AddClassN(CL.FindClass('TCustomMaskEdit'),'TInplaceEdit') do
  begin
    RegisterMethod('Procedure Deselect');
    RegisterMethod('Procedure Hide');
    RegisterMethod('Procedure Invalidate');
    RegisterMethod('Procedure Move( const Loc : TRect)');
    RegisterMethod('Function PosEqual( const Rect : TRect) : Boolean');
    RegisterMethod('Procedure SetFocus');
    RegisterMethod('Procedure UpdateLoc( const Loc : TRect)');
    RegisterMethod('Function Visible : Boolean');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_MyGrids(CL: TPSPascalCompiler);
begin
 CL.AddConstantN('CM_CTL3DCHANGED','LongInt').SetInt( CM_BASE + 16);
 //CL.AddConstantN('MaxCustomExtents','').SetString( MaxListSize);
  CL.AddClassN(CL.FindClass('TOBJECT'),'EInvalidGridOperation');
  {CL.AddTypeS('TGetExtentsFunc', 'Function ( Index : Longint) : Integer');
  CL.AddTypeS('TGridAxisDrawInfo', 'record EffectiveLineWidth : Integer; FixedB'
   +'oundary : Integer; GridBoundary : Integer; GridExtent : Integer; LastFullV'
   +'isibleCell : Longint; FullVisBoundary : Integer; FixedCellCount : Integer;'
   +' FirstGridCell : Integer; GridCellCount : Integer; GetExtent : TGetExtentsFunc; end');
  CL.AddTypeS('TGridState', '( gsNormal, gsSelecting, gsRowSizing, gsColSizing,'
   +' gsRowMoving, gsColMoving )');
  CL.AddClassN(CL.FindClass('TOBJECT'),'TMyCustomGrid');
  SIRegister_TInplaceEdit(CL);
  CL.AddTypeS('TGridOption', '( goFixedVertLine, goFixedHorzLine, goVertLine, g'
   +'oHorzLine, goRangeSelect, goDrawFocusSelected, goRowSizing, goColSizing, g'
   +'oRowMoving, goColMoving, goEditing, goTabs, goRowSelect, goAlwaysShowEditor, goThumbTracking )');
  CL.AddTypeS('TGridOptions', 'set of TGridOption');
  CL.AddTypeS('TGridDrawState', 'set of ( gdSelected, gdFocused, gdFixed )');
  CL.AddTypeS('TGridScrollDirection', 'set of ( sdLeft, sdRight, sdUp, sdDown )');
  CL.AddTypeS('TGridCoord', 'record X : Longint; Y : Longint; end');
  CL.AddTypeS('TEditStyle', '( esSimple, esEllipsis, esPickList )');
  CL.AddTypeS('TSelectCellEvent', 'Procedure ( Sender : TObject; ACol, ARow : L'
   +'ongint; var CanSelect : Boolean)');
  CL.AddTypeS('TDrawCellEvent', 'Procedure ( Sender : TObject; ACol, ARow : Lon'
   +'gint; Rect : TRect; State : TGridDrawState)');  }
  SIRegister_TMyCustomGrid(CL);
  {CL.AddTypeS('TGetEditEvent', 'Procedure ( Sender : TObject; ACol, ARow : Long'
   +'int; var Value : string)');
  CL.AddTypeS('TSetEditEvent', 'Procedure ( Sender : TObject; ACol, ARow : Long'
   +'int; const Value : string)');
  CL.AddTypeS('TMovedEvent', 'Procedure ( Sender : TObject; FromIndex, ToIndex '
   +': Longint)');   }
  SIRegister_TMyCustomDrawGrid(CL);
  SIRegister_TMyDrawGrid(CL);
  CL.AddClassN(CL.FindClass('TOBJECT'),'TMyStringGrid');
  SIRegister_TMyStringGridStrings(CL);
  SIRegister_TMyStringGrid(CL);
  CL.AddTypeS('TOnGetPickListItems', 'Procedure ( ACol, ARow : Integer; Items : TStrings)');
  SIRegister_TInplaceEditList(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TInplaceEditListOnGetPickListitems_W(Self: TInplaceEditList; const T: TOnGetPickListItems);
begin Self.OnGetPickListitems := T; end;

(*----------------------------------------------------------------------------*)
procedure TInplaceEditListOnGetPickListitems_R(Self: TInplaceEditList; var T: TOnGetPickListItems);
begin T := Self.OnGetPickListitems; end;

(*----------------------------------------------------------------------------*)
procedure TInplaceEditListOnEditButtonClick_W(Self: TInplaceEditList; const T: TNotifyEvent);
begin Self.OnEditButtonClick := T; end;

(*----------------------------------------------------------------------------*)
procedure TInplaceEditListOnEditButtonClick_R(Self: TInplaceEditList; var T: TNotifyEvent);
begin T := Self.OnEditButtonClick; end;

(*----------------------------------------------------------------------------*)
procedure TInplaceEditListPressed_R(Self: TInplaceEditList; var T: Boolean);
begin T := Self.Pressed; end;

(*----------------------------------------------------------------------------*)
procedure TInplaceEditListPickListLoaded_W(Self: TInplaceEditList; const T: Boolean);
begin Self.PickListLoaded := T; end;

(*----------------------------------------------------------------------------*)
procedure TInplaceEditListPickListLoaded_R(Self: TInplaceEditList; var T: Boolean);
begin T := Self.PickListLoaded; end;

(*----------------------------------------------------------------------------*)
procedure TInplaceEditListPickList_R(Self: TInplaceEditList; var T: TCustomListbox);
begin T := Self.PickList; end;

(*----------------------------------------------------------------------------*)
procedure TInplaceEditListListVisible_W(Self: TInplaceEditList; const T: Boolean);
begin Self.ListVisible := T; end;

(*----------------------------------------------------------------------------*)
procedure TInplaceEditListListVisible_R(Self: TInplaceEditList; var T: Boolean);
begin T := Self.ListVisible; end;

(*----------------------------------------------------------------------------*)
procedure TInplaceEditListEditStyle_R(Self: TInplaceEditList; var T: TEditStyle);
begin T := Self.EditStyle; end;

(*----------------------------------------------------------------------------*)
procedure TInplaceEditListDropDownRows_W(Self: TInplaceEditList; const T: Integer);
begin Self.DropDownRows := T; end;

(*----------------------------------------------------------------------------*)
procedure TInplaceEditListDropDownRows_R(Self: TInplaceEditList; var T: Integer);
begin T := Self.DropDownRows; end;

(*----------------------------------------------------------------------------*)
procedure TInplaceEditListButtonWidth_W(Self: TInplaceEditList; const T: Integer);
begin Self.ButtonWidth := T; end;

(*----------------------------------------------------------------------------*)
procedure TInplaceEditListButtonWidth_R(Self: TInplaceEditList; var T: Integer);
begin T := Self.ButtonWidth; end;

(*----------------------------------------------------------------------------*)
procedure TInplaceEditListActiveList_W(Self: TInplaceEditList; const T: TWinControl);
begin Self.ActiveList := T; end;

(*----------------------------------------------------------------------------*)
procedure TInplaceEditListActiveList_R(Self: TInplaceEditList; var T: TWinControl);
begin T := Self.ActiveList; end;

(*----------------------------------------------------------------------------*)
procedure TMyStringGridRows_W(Self: TMyStringGrid; const T: TStrings; const t1: Integer);
begin Self.Rows[t1] := T; end;

(*----------------------------------------------------------------------------*)
procedure TMyStringGridRows_R(Self: TMyStringGrid; var T: TStrings; const t1: Integer);
begin T := Self.Rows[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TMyStringGridRow_W(Self: TMyStringGrid; const T: Integer);
begin Self.Row:= T; end;

(*----------------------------------------------------------------------------*)
procedure TMyStringGridRow_R(Self: TMyStringGrid; var T: Integer);
begin T := Self.Row; end;

(*----------------------------------------------------------------------------*)
procedure TMyStringGridRowc_W(Self: TMyStringGrid; const T: Integer);
begin Self.Rowcount:= T; end;

(*----------------------------------------------------------------------------*)
procedure TMyStringGridRowc_R(Self: TMyStringGrid; var T: Integer);
begin T := Self.Rowcount; end;

(*----------------------------------------------------------------------------*)
procedure TMyStringGridObjects_W(Self: TMyStringGrid; const T: TObject; const t1: Integer; const t2: Integer);
begin Self.Objects[t1, t2] := T; end;

(*----------------------------------------------------------------------------*)
procedure TMyStringGridObjects_R(Self: TMyStringGrid; var T: TObject; const t1: Integer; const t2: Integer);
begin T := Self.Objects[t1, t2]; end;

(*----------------------------------------------------------------------------*)
procedure TMyStringGridCols_W(Self: TMyStringGrid; const T: TStrings; const t1: Integer);
begin Self.Cols[t1] := T; end;

(*----------------------------------------------------------------------------*)
procedure TMyStringGridCols_R(Self: TMyStringGrid; var T: TStrings; const t1: Integer);
begin T := Self.Cols[t1]; end;

procedure TMyStringGridCol_W(Self: TMyStringGrid; const T: integer);
begin Self.Col:= T; end;

(*----------------------------------------------------------------------------*)
procedure TMyStringGridCol_R(Self: TMyStringGrid; var T: Integer);
begin T := Self.Col; end;

procedure TMyStringGridColc_W(Self: TMyStringGrid; const T: integer);
begin Self.Colcount:= T; end;

(*----------------------------------------------------------------------------*)
procedure TMyStringGridColc_R(Self: TMyStringGrid; var T: Integer);
begin T := Self.Colcount; end;

(*----------------------------------------------------------------------------*)
procedure TMyStringGridCells_W(Self: TMyStringGrid; const T: string; const t1: Integer; const t2: Integer);
begin Self.Cells[t1, t2] := T; end;

(*----------------------------------------------------------------------------*)
procedure TMyStringGridCells_R(Self: TMyStringGrid; var T: string; const t1: Integer; const t2: Integer);
begin T := Self.Cells[t1, t2]; end;

(*----------------------------------------------------------------------------*)
procedure TMyCustomGridOnBeginUpdate_W(Self: TMyCustomGrid; const T: TNotifyEvent);
begin Self.OnBeginUpdate := T; end;

(*----------------------------------------------------------------------------*)
procedure TMyCustomGridOnBeginUpdate_R(Self: TMyCustomGrid; var T: TNotifyEvent);
begin T := Self.OnBeginUpdate; end;

(*----------------------------------------------------------------------------*)
procedure TMyCustomGridNowUpdating_R(Self: TMyCustomGrid; var T: Boolean);
begin T := Self.NowUpdating; end;

procedure TmyStringGridWidth_R(Self: TmyStringGrid; var T: integer);
begin T:= Self.GridWidth; end;

procedure TmyStringGridHeight_R(Self: TmyStringGrid; var T: integer);
begin T:= Self.GridHeight;
     //self.ScrollBars:= ssvertical;
 end;


(*----------------------------------------------------------------------------*)
procedure RIRegister_TInplaceEditList(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TInplaceEditList) do
  begin
    RegisterConstructor(@TInplaceEditList.Create, 'Create');
    RegisterMethod(@TInplaceEditList.RestoreContents, 'RestoreContents');
    RegisterPropertyHelper(@TInplaceEditListActiveList_R,@TInplaceEditListActiveList_W,'ActiveList');
    RegisterPropertyHelper(@TInplaceEditListButtonWidth_R,@TInplaceEditListButtonWidth_W,'ButtonWidth');
    RegisterPropertyHelper(@TInplaceEditListDropDownRows_R,@TInplaceEditListDropDownRows_W,'DropDownRows');
    RegisterPropertyHelper(@TInplaceEditListEditStyle_R,nil,'EditStyle');
    RegisterPropertyHelper(@TInplaceEditListListVisible_R,@TInplaceEditListListVisible_W,'ListVisible');
    RegisterPropertyHelper(@TInplaceEditListPickList_R,nil,'PickList');
    RegisterPropertyHelper(@TInplaceEditListPickListLoaded_R,@TInplaceEditListPickListLoaded_W,'PickListLoaded');
    RegisterPropertyHelper(@TInplaceEditListPressed_R,nil,'Pressed');
    RegisterPropertyHelper(@TInplaceEditListOnEditButtonClick_R,@TInplaceEditListOnEditButtonClick_W,'OnEditButtonClick');
    RegisterPropertyHelper(@TInplaceEditListOnGetPickListitems_R,@TInplaceEditListOnGetPickListitems_W,'OnGetPickListitems');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TMyStringGrid(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TMyStringGrid) do begin
    RegisterConstructor(@TMyStringGrid.Create, 'Create');
    RegisterMethod(@TMyStringGrid.SetBounds, 'SetBounds');
    RegisterMethod(@TMyStringGrid.Destroy, 'Free');
    RegisterMethod(@TMyStringGrid.MouseCoord, 'MouseCoord');
    RegisterMethod(@TMyStringGrid.CellRect, 'CellRect');
    RegisterMethod(@TMyStringGrid.MouseToCell, 'MouseToCell');
    RegisterPropertyHelper(@TMyStringGridCells_R,@TMyStringGridCells_W,'Cells');
    RegisterPropertyHelper(@TMyStringGridCols_R,@TMyStringGridCols_W,'Cols');
    RegisterPropertyHelper(@TMyStringGridObjects_R,@TMyStringGridObjects_W,'Objects');
    RegisterPropertyHelper(@TMyStringGridRows_R,@TMyStringGridRows_W,'Rows');
    RegisterPropertyHelper(@TmyStringGridWidth_R,NIL,'GridWidth');
    RegisterPropertyHelper(@TmyStringGridHeight_R,NIL,'GridHeight');
    RegisterPropertyHelper(@TMyStringGridCol_R,@TMyStringGridCol_W,'Col');
    RegisterPropertyHelper(@TMyStringGridRow_R,@TMyStringGridRow_W,'Row');
    RegisterPropertyHelper(@TMyStringGridColc_R,@TMyStringGridColc_W,'Colcount');
    RegisterPropertyHelper(@TMyStringGridRowc_R,@TMyStringGridRowc_W,'Rowcount');

  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TMyStringGridStrings(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TMyStringGridStrings) do begin
    RegisterConstructor(@TMyStringGridStrings.Create, 'Create');
    RegisterMethod(@TMyStringGridStrings.Add, 'Add');
    RegisterMethod(@TMyStringGridStrings.Assign, 'Assign');
    RegisterMethod(@TMyStringGridStrings.Clear, 'Clear');
    RegisterMethod(@TMyStringGridStrings.Delete, 'Delete');
    RegisterMethod(@TMyStringGridStrings.Insert, 'Insert');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TMyDrawGrid(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TMyDrawGrid) do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TMyCustomDrawGrid(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TMyCustomDrawGrid) do
  begin
    RegisterMethod(@TMyCustomDrawGrid.CellRect, 'CellRect');
    RegisterMethod(@TMyCustomDrawGrid.MouseToCell, 'MouseToCell');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TMyCustomGrid(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TMyCustomGrid) do
  begin
    RegisterConstructor(@TMyCustomGrid.Create, 'Create');
    RegisterMethod(@TMyCustomGrid.MouseCoord, 'MouseCoord');
    RegisterVirtualMethod(@TMyCustomGrid.BeginUpdate, 'BeginUpdate');
    RegisterVirtualMethod(@TMyCustomGrid.EndUpdate, 'EndUpdate');
    RegisterPropertyHelper(@TMyCustomGridNowUpdating_R,nil,'NowUpdating');
    RegisterPropertyHelper(@TMyCustomGridOnBeginUpdate_R,@TMyCustomGridOnBeginUpdate_W,'OnBeginUpdate');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TInplaceEdit(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TInplaceEdit) do
  begin
    RegisterMethod(@TInplaceEdit.Deselect, 'Deselect');
    RegisterMethod(@TInplaceEdit.Hide, 'Hide');
    RegisterMethod(@TInplaceEdit.Invalidate, 'Invalidate');
    RegisterMethod(@TInplaceEdit.Move, 'Move');
    RegisterMethod(@TInplaceEdit.PosEqual, 'PosEqual');
    RegisterMethod(@TInplaceEdit.SetFocus, 'SetFocus');
    RegisterMethod(@TInplaceEdit.UpdateLoc, 'UpdateLoc');
    RegisterMethod(@TInplaceEdit.Visible, 'Visible');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_MyGrids(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(EInvalidGridOperation) do
  with CL.Add(TMyCustomGrid) do
  RIRegister_TInplaceEdit(CL);
  RIRegister_TMyCustomGrid(CL);
  RIRegister_TMyCustomDrawGrid(CL);
  RIRegister_TMyDrawGrid(CL);
  with CL.Add(TMyStringGrid) do
  RIRegister_TMyStringGridStrings(CL);
  RIRegister_TMyStringGrid(CL);
  RIRegister_TInplaceEditList(CL);
end;

 
 
{ TPSImport_MyGrids }
(*----------------------------------------------------------------------------*)
procedure TPSImport_MyGrids.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_MyGrids(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_MyGrids.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_MyGrids(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
