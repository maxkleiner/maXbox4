unit uPSR_Grids;
{
   canvas and parent and more properties in    mX3.1
          mX3.1
          rowheights, colwidths mX3.8     , setfocus
}
interface
Uses uPSRuntime;

procedure RIRegister_TInplaceEditList(CL: TPSRuntimeClassImporter);
procedure RIRegister_TStringGrid(CL: TPSRuntimeClassImporter);
procedure RIRegister_TStringGridStrings(CL: TPSRuntimeClassImporter);
procedure RIRegister_TDrawGrid(CL: TPSRuntimeClassImporter);
procedure RIRegister_TCustomDrawGrid(CL: TPSRuntimeClassImporter);
procedure RIRegister_TCustomGrid(CL: TPSRuntimeClassImporter);
procedure RIRegister_TInplaceEdit(CL: TPSRuntimeClassImporter);
procedure RIRegister_Grids(CL: TPSRuntimeClassImporter);
procedure RIRegister_GridCommon_Routines(S: TPSExec);

implementation

Uses
 Messages, Windows, {$IFDEF LINUX} WinUtils, {$ENDIF} SysUtils, Classes, Variants, Graphics, Menus, Controls, Forms, 
StdCtrls, Mask, Grids;

type
 TGridRect2 = record
      Left, Top, Right, Bottom: Longint;
  end;


procedure TInplaceEditListOnGetPickListitems_W(Self: TInplaceEditList; const T: TOnGetPickListItems);
begin Self.OnGetPickListitems := T; end;

procedure TInplaceEditListOnGetPickListitems_R(Self: TInplaceEditList; var T: TOnGetPickListItems);
begin T := Self.OnGetPickListitems; end;

procedure TInplaceEditListOnEditButtonClick_W(Self: TInplaceEditList; const T: TNotifyEvent);
begin Self.OnEditButtonClick := T; end;

procedure TInplaceEditListOnEditButtonClick_R(Self: TInplaceEditList; var T: TNotifyEvent);
begin T := Self.OnEditButtonClick; end;

procedure TInplaceEditListPressed_R(Self: TInplaceEditList; var T: Boolean);
begin T := Self.Pressed; end;

procedure TInplaceEditListPickListLoaded_W(Self: TInplaceEditList; const T: Boolean);
begin Self.PickListLoaded := T; end;

procedure TInplaceEditListPickListLoaded_R(Self: TInplaceEditList; var T: Boolean);
begin T := Self.PickListLoaded; end;

procedure TInplaceEditListPickList_R(Self: TInplaceEditList; var T: TCustomListbox);
begin T := Self.PickList; end;

procedure TInplaceEditListListVisible_W(Self: TInplaceEditList; const T: Boolean);
begin Self.ListVisible := T; end;

procedure TInplaceEditListListVisible_R(Self: TInplaceEditList; var T: Boolean);
begin T := Self.ListVisible; end;

procedure TInplaceEditListEditStyle_R(Self: TInplaceEditList; var T: TEditStyle);
begin T := Self.EditStyle; end;

procedure TInplaceEditListDropDownRows_W(Self: TInplaceEditList; const T: Integer);
begin Self.DropDownRows := T; end;

procedure TInplaceEditListDropDownRows_R(Self: TInplaceEditList; var T: Integer);
begin T := Self.DropDownRows; end;

procedure TInplaceEditListButtonWidth_W(Self: TInplaceEditList; const T: Integer);
begin Self.ButtonWidth := T; end;

procedure TInplaceEditListButtonWidth_R(Self: TInplaceEditList; var T: Integer);
begin T := Self.ButtonWidth; end;

procedure TInplaceEditListActiveList_W(Self: TInplaceEditList; const T: TWinControl);
begin Self.ActiveList := T; end;

procedure TInplaceEditListActiveList_R(Self: TInplaceEditList; var T: TWinControl);
begin T := Self.ActiveList; end;

procedure TStringGridRows_W(Self: TStringGrid; const T: TStrings; const t1: Integer);
begin Self.Rows[t1] := T; end;

procedure TStringGridRows_R(Self: TStringGrid; var T: TStrings; const t1: Integer);
begin T := Self.Rows[t1]; end;

procedure TStringGridObjects_W(Self: TStringGrid; const T: TObject; const t1: Integer; const t2: Integer);
begin Self.Objects[t1, t2] := T; end;

procedure TStringGridObjects_R(Self: TStringGrid; var T: TObject; const t1: Integer; const t2: Integer);
begin T := Self.Objects[t1, t2]; end;

procedure TStringGridCols_W(Self: TStringGrid; const T: TStrings; const t1: Integer);
begin Self.Cols[t1] := T; end;

procedure TStringGridCols_R(Self: TStringGrid; var T: TStrings; const t1: Integer);
begin T := Self.Cols[t1]; end;

procedure TStringGridCol_W(Self: TStringGrid; const T: integer);
begin Self.Col:= T; end;

procedure TStringGridCol_R(Self: TStringGrid; var T: integer);
begin T:= Self.Col; end;

procedure TStringGridRow_W(Self: TStringGrid; const T: integer);
begin Self.Row:= T; end;

procedure TStringGridRow_R(Self: TStringGrid; var T: integer);
begin T:= Self.Row; end;


//procedure TDrawGridCols_R(Self: TDrawGrid; var T: integer; const t1: Integer);
//procedure TDrawGridRows_W(Self: TDrawGrid; const T: integer; const t1: Integer);


procedure TStringGridColwidths_W(Self: TStringGrid; const T: integer; const t1: integer);
begin Self.ColWidths[t1]:= T; end;

procedure TStringGridColwidths_R(Self: TStringGrid; var T: integer; const t1: Integer);
begin T:= Self.ColWidths[t1]; end;

procedure TStringGridRowheights_W(Self: TStringGrid; const T: integer; const t1: integer);
begin Self.RowHeights[t1]:= T; end;

procedure TStringGridRowheights_R(Self: TStringGrid; var T: integer; const t1: Integer);
begin T:= Self.RowHeights[t1]; end;

procedure TStringGridSelection_W(Self: TStringGrid; const T: TGridRect);
begin Self.Selection:= T; end;

procedure TStringGridSelection_R(Self: TStringGrid; var T: TGridRect);
begin T:= Self.Selection; end;

procedure TStringGridSelection_W2(Self: TStringGrid; const T: TGridRect2);
begin Self.Selection:= TGridRect(T); end;

procedure TStringGridSelection_R2(Self: TStringGrid; var T: TGridRect2);
begin TGridRect(T):= Self.Selection; end;

procedure TStringGridtabstops_W(Self: TStringGrid; const T: boolean; const t1: integer);
begin Self.TabStops[t1]:= T; end;

procedure TStringGridtabstops_R(Self: TStringGrid; var T: boolean; const t1: Integer);
begin T:= Self.TabStops[t1]; end;

{procedure TStringGridtabstops_W(Self: TStringGrid; const T: TGridRect);
begin Self.Selection:= T; end;

procedure TStringGridSelection_R(Self: TStringGrid; var T: TGridRect);
begin T:= Self.Selection; end;}

//RegisterPropertyHelper(@TStringGridSelection_R,@TStringGridSelection_W,'Selection');


//procedure TStringGridCol_R(Self: TStringGrid; var T: TStrings; const t1: Integer);
//begin T := Self.col; end;

procedure TStringGridCells_W(Self: TStringGrid; const T: string; const t1: Integer; const t2: Integer);
begin Self.Cells[t1, t2] := T; end;

procedure TStringGridCells_R(Self: TStringGrid; var T: string; const t1: Integer; const t2: Integer);
begin T := Self.Cells[t1, t2]; end;

procedure TControlParentR(Self: TControl; var T: TWinControl); begin T := Self.Parent; end;
procedure TControlParentW(Self: TControl; T: TWinControl); begin Self.Parent:= T; end;

procedure TBitmapCanvas_R(Self: TStringGrid; var T: TCanvas); begin T:= Self.Canvas; end;

procedure TBitmapCanvas2_R(Self: TCustomDrawGrid; var T: TCanvas); begin T:= Self.Canvas; end;

procedure TDrawGridCols_W(Self: TDrawGrid; const T: integer; const t1: Integer);
begin Self.ColWidths[t1]:= T; end;

procedure TDrawGridCols_R(Self: TDrawGrid; var T: integer; const t1: Integer);
begin T := Self.ColWidths[t1]; end;

procedure TDrawGridRows_W(Self: TDrawGrid; const T: integer; const t1: Integer);
begin Self.RowHeights[t1]:= T; end;

procedure TDrawGridRows_R(Self: TDrawGrid; var T: integer; const t1: Integer);
begin T:= Self.RowHeights[t1]; end;


procedure TDrawGridCol_W(Self: TDrawGrid; const T: integer);
begin Self.Col:= T; end;

procedure TDrawGridCol_R(Self: TDrawGrid; var T: integer);
begin T:= Self.Col; end;

procedure TDrawGridRow_W(Self: TDrawGrid; const T: integer);
begin Self.Row:= T; end;

procedure TDrawGridRow_R(Self: TDrawGrid; var T: integer);
begin T:= Self.Row; end;

procedure TCustomDrawGridEM_W(Self: TCustomDrawGrid; const T: boolean);
begin Self.EditorMode:= T; end;

procedure TCustomDrawGridEM_R(Self: TCustomDrawGrid; var T: boolean);
begin T:= Self.EditorMode; end;


procedure TDrawGridWidth_R(Self: TDrawGrid; var T: integer);
begin T:= Self.GridWidth; end;

procedure TDrawGridHeight_R(Self: TDrawGrid; var T: integer);
begin T:= Self.GridHeight; end;


procedure TDrawGridTop_R(Self: TDrawGrid; var T: integer);
begin T:= Self.TopRow; end;

procedure TDrawGridTop_W(Self: TDrawGrid; const T: integer);
begin Self.TopRow:= T; end;

procedure TDrawGrideditmode_R(Self: TDrawGrid; var T: boolean);
begin T:= Self.EditorMode; end;

procedure TDrawGrideditmode_W(Self: TDrawGrid; const T: boolean);
begin Self.Editormode:= T; end;

procedure TDrawGridleftcol_R(Self: TDrawGrid; var T: integer);
begin T:= Self.LeftCol; end;

procedure TDrawGridleftcol_W(Self: TDrawGrid; const T: integer);
begin Self.leftcol:= T; end;

procedure TDrawGridtaborder_R(Self: TDrawGrid; var T: integer);
begin T:= Self.taborder; end;

procedure TDrawGridtaborder_W(Self: TDrawGrid; const T: integer);
begin Self.taborder:= T; end;


procedure TDrawGridHit_R(Self: TDrawGrid; var T: TPoint);
begin
//T:= Self.hittest;
 end;

//---------------------------------

procedure TStringGridWidth_R(Self: TStringGrid; var T: integer);
begin T:= Self.GridWidth; end;

procedure TStringGridHeight_R(Self: TStringGrid; var T: integer);
begin T:= Self.GridHeight;
     //self.ScrollBars:= ssvertical;
 end;


//procedure TStringGridOnDrawCell_R(Self: TStringGrid; var T: TNOTIFYEVENT); begin T := Self.OnDrawCell; end;
//procedure TAPPLICATIONONRESTORE_W(Self: TAPPLICATION; T: TNOTIFYEVENT); begin Self.ONRESTORE := T; end;


procedure RIRegister_TInplaceEditList(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TInplaceEditList) do begin
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

procedure RIRegister_TStringGrid(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TStringGrid) do begin
    RegisterConstructor(@TStringGrid.Create, 'Create');
    RegisterMethod(@TStringGrid.Destroy, 'Free');
    RegisterMethod(@TStringGrid.Repaint, 'Repaint');
    RegisterMethod(@TStringGrid.Invalidate, 'Invalidate');
    RegisterMethod(@TStringGrid.update, 'Update');
    RegisterMethod(@TStringGrid.refresh, 'refresh');
    RegisterMethod(@TStringGrid.MouseCoord, 'MouseCoord');
      RegisterMethod(@TStringGrid.SetFocus, 'SetFocus');
    RegisterMethod(@TStringGrid.CellRect, 'CellRect');
    RegisterMethod(@TStringGrid.MouseToCell, 'MouseToCell');

      RegisterVirtualMethod(@TStringGrid.SetBounds, 'SETBOUNDS');
    RegisterPropertyHelper(@TStringGridCells_R,@TStringGridCells_W,'Cells');
    RegisterPropertyHelper(@TStringGridCols_R,@TStringGridCols_W,'Cols');
    RegisterPropertyHelper(@TStringGridCol_R,@TStringGridCol_W,'Col');
    RegisterPropertyHelper(@TStringGridRow_R,@TStringGridRow_W,'Row');
    RegisterPropertyHelper(@TStringGridColwidths_R,@TStringGridColwidths_W,'ColWidths');
    RegisterPropertyHelper(@TStringGridRowheights_R,@TStringGridRowheights_W,'RowHeights');
    RegisterPropertyHelper(@TStringGridSelection_R,@TStringGridSelection_W,'Selection');
    RegisterPropertyHelper(@TStringGridSelection_R2,@TStringGridSelection_W2,'Selection2');

    RegisterPropertyHelper(@TStringGridObjects_R,@TStringGridObjects_W,'Objects');
    RegisterPropertyHelper(@TStringGridRows_R,@TStringGridRows_W,'Rows');
    RegisterPropertyHelper(@TControlParentR, @TControlParentW, 'PARENT');
    RegisterPropertyHelper(@TBitmapCanvas_R,nil,'Canvas');
    RegisterPropertyHelper(@TStringGridWidth_R,NIL,'GridWidth');
    RegisterPropertyHelper(@TStringGridHeight_R,NIL,'GridHeight');
    RegisterPropertyHelper(@TStringGridtabstops_R,@TStringGridtabstops_W,'TabStops');

  end;
end;

procedure RIRegister_TStringGridStrings(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TStringGridStrings) do begin
    RegisterConstructor(@TStringGridStrings.Create, 'Create');
    RegisterMethod(@TStringGridStrings.Add, 'Add');
    RegisterMethod(@TStringGridStrings.Assign, 'Assign');
    RegisterMethod(@TStringGridStrings.Clear, 'Clear');
    RegisterMethod(@TStringGridStrings.Delete,'Delete');
    RegisterMethod(@TStringGridStrings.Insert,'Insert');

  end;
end;

procedure RIRegister_TDrawGrid(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TDrawGrid) do  begin
    RegisterConstructor(@TDrawGrid.Create, 'Create');
    RegisterMethod(@TDrawGrid.Destroy, 'Free');
    RegisterMethod(@TDrawGrid.Repaint, 'Repaint');
    RegisterMethod(@TDrawGrid.Invalidate, 'Invalidate');
    RegisterMethod(@TDrawGrid.Update, 'Update');
    RegisterVirtualMethod(@TDrawGrid.SetBounds, 'SETBOUNDS');
    RegisterPropertyHelper(@TControlParentR, @TControlParentW, 'PARENT');
    RegisterPropertyHelper(@TBitmapCanvas_R,NIL,'Canvas');
    RegisterMethod(@TDrawGrid.SetFocus, 'SetFocus');
    //RegisterMethod(@TDrawGrid.UpdateLoc, 'UpdateLoc');
    RegisterMethod(@TDrawGrid.refresh, 'refresh');

    //RegisterPropertyHelper(@TDrawGridCells_R,@TDrawGridCells_W,'Cells');
    RegisterPropertyHelper(@TDrawGridCols_R,@TDrawGridCols_W,'ColWidths');
    RegisterPropertyHelper(@TDrawGridCol_R,@TDrawGridCol_W,'Col');
    RegisterPropertyHelper(@TDrawGridRow_R,@TDrawGridRow_W,'Row');
    RegisterPropertyHelper(@TDrawGridRows_R,@TDrawGridRows_W,'RowHeights');
    RegisterPropertyHelper(@TDrawGridWidth_R,NIL,'GridWidth');
    RegisterPropertyHelper(@TDrawGridHeight_R,NIL,'GridHeight');
   // property GridHeight;
   // property GridWidth;
    RegisterPropertyHelper(@TStringGridObjects_R,@TStringGridObjects_W,'Objects');
    //RegisterPropertyHelper(@TStringGridObjects_R,@TStringGridObjects_W,'Objects');
    RegisterPropertyHelper(@TDrawGridTop_R,@TDrawGridTop_W,'TopRow');
    RegisterPropertyHelper(@TDrawGridEditmode_R,@TDrawGridEditmode_W,'EditorMode');
    RegisterPropertyHelper(@TDrawGridleftcol_R,@TDrawGridleftcol_W,'LeftCol');
    RegisterPropertyHelper(@TDrawGridtaborder_R,@TDrawGridtaborder_W,'Taborder');

    //RegisterProperty('TopRow','Longint',iptrw);
    //RegisterProperty('HitTest','TPoint',iptr);
  end;
end;

procedure RIRegister_TCustomDrawGrid(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TCustomDrawGrid) do begin
    RegisterMethod(@TCustomDrawGrid.CellRect, 'CellRect');
    RegisterMethod(@TCustomDrawGrid.MouseToCell, 'MouseToCell');
    RegisterMethod(@TCustomDrawGrid.Destroy, 'Free');
    // RegisterMethod(@TCustomDrawGrid.Invalidate, 'Invalidate');
     RegisterPropertyHelper(@TDrawGridRow_R,@TDrawGridRow_W,'Row');
     RegisterPropertyHelper(@TCustomDrawGridEM_R,@TCustomDrawGridEM_W,'EditorMode');

    RegisterPropertyHelper(@TBitmapCanvas2_R,NIL,'Canvas');


  end;
end;

procedure RIRegister_TCustomGrid(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TCustomGrid) do begin
    RegisterMethod(@TCustomGrid.Destroy, 'Free');
    RegisterConstructor(@TCustomGrid.Create, 'Create');
    RegisterMethod(@TCustomGrid.MouseCoord, 'MouseCoord');
  end;
end;

procedure RIRegister_TInplaceEdit(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TInplaceEdit) do begin
    RegisterMethod(@TInplaceEdit.Deselect, 'Deselect');
    RegisterConstructor(@TInplaceEdit.Create, 'Create');
    RegisterMethod(@TInplaceEdit.Hide, 'Hide');
    RegisterMethod(@TInplaceEdit.Invalidate, 'Invalidate');
    RegisterMethod(@TInplaceEdit.Move, 'Move');
    RegisterMethod(@TInplaceEdit.PosEqual, 'PosEqual');
    RegisterMethod(@TInplaceEdit.SetFocus, 'SetFocus');
    RegisterMethod(@TInplaceEdit.UpdateLoc, 'UpdateLoc');
    RegisterMethod(@TInplaceEdit.Visible, 'Visible');
  end;
end;

procedure RIRegister_GridCommon_Routines(S: TPSExec);
begin
  //S.RegisterDelphiFunction(@SwapGrid, 'SwapGrid', cdRegister);
end;


procedure RIRegister_Grids(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(EInvalidGridOperation) do
  with CL.Add(TCustomGrid) do
  RIRegister_TInplaceEdit(CL);
  RIRegister_TCustomGrid(CL);
  RIRegister_TCustomDrawGrid(CL);
  RIRegister_TDrawGrid(CL);
  with CL.Add(TStringGrid) do
  RIRegister_TStringGridStrings(CL);
  RIRegister_TStringGrid(CL);
  RIRegister_TInplaceEditList(CL);
end;

end.
