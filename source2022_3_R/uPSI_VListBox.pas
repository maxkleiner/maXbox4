unit uPSI_VListBox;
{
the real virtual box
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
  TPSImport_VListBox = class(TPSPlugin)
  public
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TVirtListBoxEx(CL: TPSPascalCompiler);
procedure SIRegister_TVirtListBox(CL: TPSPascalCompiler);
procedure SIRegister_TBaseVirtListBox(CL: TPSPascalCompiler);
procedure SIRegister_TLbColors(CL: TPSPascalCompiler);
procedure SIRegister_TBaseLbColors(CL: TPSPascalCompiler);
procedure SIRegister_VListBox(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_VListBox_Routines(S: TPSExec);
procedure RIRegister_TVirtListBoxEx(CL: TPSRuntimeClassImporter);
procedure RIRegister_TVirtListBox(CL: TPSRuntimeClassImporter);
procedure RIRegister_TBaseVirtListBox(CL: TPSRuntimeClassImporter);
procedure RIRegister_TLbColors(CL: TPSRuntimeClassImporter);
procedure RIRegister_TBaseLbColors(CL: TPSRuntimeClassImporter);
procedure RIRegister_VListBox(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   WinTypes
  ,WinProcs
  ,Messages
  ,Menus
  ,Graphics
  ,Controls
  ,StdCtrls
  ,Forms
  ,Dialogs
  ,VListBox
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_VListBox]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TVirtListBoxEx(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TVirtListBox', 'TVirtListBoxEx') do
  with CL.AddClassN(CL.FindClass('TVirtListBox'),'TVirtListBoxEx') do begin
    RegisterMethod('Constructor Create( AnOwner : TComponent)');
      RegisterMethod('Procedure Free');
      RegisterMethod('Function QueryHeader( FldNum : Integer) : AnsiString');
    RegisterProperty('Splitter', 'Integer Integer', iptrw);
    RegisterProperty('ColumnWidth', 'Integer Integer', iptrw);
    RegisterProperty('Columns', 'TStrings', iptrw);
    RegisterProperty('NumCols', 'Integer', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TVirtListBox(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TBaseVirtListBox', 'TVirtListBox') do
  with CL.AddClassN(CL.FindClass('TBaseVirtListBox'),'TVirtListBox') do begin
   RegisterPublishedProperties;

    RegisterProperty('BorderStyle', 'TBorderStyle', iptrw);
    RegisterProperty('ScrollBars', 'TScrollStyle', iptrw);
    RegisterProperty('RecCount', 'Integer', iptrw);
    RegisterProperty('NumRows', 'Integer', iptrw);
    RegisterProperty('NumItems', 'Integer', iptrw);
    RegisterProperty('NumCols', 'Integer', iptrw);
    RegisterProperty('ColCOunt', 'Integer', iptrw);
    RegisterProperty('ItemRect', 'TRect Integer', iptr);
    RegisterProperty('HeaderRect', 'TRect', iptr);
    RegisterProperty('RowHeight', 'Integer', iptrw);
    RegisterProperty('HeaderHeight', 'Integer', iptrw);
    RegisterProperty('Colors', 'TLBColors', iptrw);
    RegisterProperty('Options', 'TVirtListBoxOptions', iptrw);
    RegisterProperty('FontHeader', 'TFont', iptrw);
    RegisterProperty('TopIndex', 'Integer', iptrw);
    RegisterProperty('ItemIndex', 'Integer', iptrw);
    RegisterProperty('SelCount', 'Integer', iptr);
    RegisterProperty('LeftColIndex', 'Integer', iptrw);
     RegisterProperty('OwnerDrawHeader', 'Boolean', iptrw);
    RegisterProperty('OwnerDraw', 'Boolean', iptrw);
     RegisterProperty('DefColWidth', 'Integer', iptrw);
    RegisterProperty('LeftOffset', 'Integer', iptrw);
   //  RegisterProperty('OnBeforeDrawItem', 'TBeforeAfterDrawItemEvent', iptrw);
   // RegisterProperty('OnAfterDrawItem', 'TBeforeAfterDrawItemEvent', iptrw);
    //RegisterProperty('OnDrawItem', 'TDrawItemEvent', iptrw);

     RegisterProperty('ALIGNMENT', 'TALIGNMENT', iptrw);
    RegisterProperty('ALIGN', 'TALIGN', iptrw);
      RegisterProperty('FONT', 'TFont', iptrw);
     RegisterProperty('Visible', 'Boolean', iptrw);
     RegisterProperty('Enabled', 'Boolean', iptrw);
   RegisterProperty('Color', 'TColor', iptrw);
   RegisterProperty('Caption', 'string', iptrw);
  // RegisterProperty('ForeColor', 'TColor', iptrw);
    RegisterProperty('PARENTCOLOR', 'Boolean', iptrw);
    RegisterProperty('PARENTFONT', 'Boolean', iptrw);
     RegisterProperty('CTL3D', 'Boolean', iptrw);
     RegisterProperty('CANVAS', 'TCanvas', iptrw);
     RegisterProperty('ItemHeight', 'Integer', iptrw);
    RegisterProperty('ONCLICK', 'TNotifyEvent', iptrw);
    RegisterProperty('ONDBLCLICK', 'TNotifyEvent', iptrw);
    RegisterProperty('ONENTER', 'TNotifyEvent', iptrw);
    RegisterProperty('ONEXIT', 'TNotifyEvent', iptrw);
  //  RegisterProperty('ONKEYDOWN', 'TKeyEvent', iptrw);
  //  RegisterProperty('ONKEYPRESS', 'TKeyPressEvent', iptrw);
  //  RegisterProperty('ONKEYUP', 'TKeyEvent', iptrw);
     RegisterProperty('ONMOUSEDOWN', 'TMouseEvent', iptrw);
    RegisterProperty('ONMOUSEMOVE', 'TMouseMoveEvent', iptrw);
    RegisterProperty('ONMOUSEUP', 'TMouseEvent', iptrw);
     RegisterProperty('ONKEYDOWN', 'TKeyEvent', iptrw);
    RegisterProperty('ONKEYPRESS', 'TKeyPressEvent', iptrw);
    RegisterProperty('ONKEYUP', 'TKeyEvent', iptrw);

     RegisterProperty('OnBeforeDrawItem', 'TBeforeAfterDrawItemEvent', iptrw);
    RegisterProperty('OnAfterDrawItem', 'TBeforeAfterDrawItemEvent', iptrw);
    RegisterProperty('OnDrawItem', 'TDrawItemEvent', iptrw);
     RegisterProperty('OnChange', 'TOnChangeEvent', iptrw);
    RegisterProperty('OnSelectionChange', 'TSelectionChangeEvent', iptrw);
    RegisterProperty('OnTopIndexChanged', 'TTopIndexChangedEvent', iptrw);
    RegisterProperty('OnQuerySplitter', 'TQuerySplitterEvent', iptrw);
    RegisterProperty('OnQueryItem', 'TQueryItemEvent', iptrw);
    RegisterProperty('OnQuerySelection', 'TQuerySelectionEvent', iptrw);
    RegisterProperty('OnQueryHeader', 'TQueryHeaderEvent', iptrw);
    RegisterProperty('OnQueryField', 'TQueryFieldAttrEvent', iptrw);
    RegisterProperty('OnResizeColumn', 'TResizeColumnEvent', iptrw);
    RegisterProperty('OnAfterPaintRow', 'TRowPaintEvent', iptrw);
    RegisterProperty('OnBeforePaintRow', 'TRowPaintEvent', iptrw);
    RegisterProperty('OnAfterPaint', 'TControlPaintEvent', iptrw);
    RegisterProperty('OnBeforePaint', 'TControlPaintEvent', iptrw);
    RegisterProperty('OnHeaderClick', 'THeaderClickEvent', iptrw);
    RegisterProperty('WheelDelta', 'Integer', iptrw);
    RegisterProperty('MultiSelect', 'Boolean', iptrw);
    RegisterProperty('OnMouseWheel', 'TMouseWheelEvent', iptrw);

  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TBaseVirtListBox(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TCustomControl', 'TBaseVirtListBox') do
  with CL.AddClassN(CL.FindClass('TCustomControl'),'TBaseVirtListBox') do begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
      RegisterMethod('Procedure Free');
      RegisterMethod('Function ClientToRow( Y : Integer) : Integer');
    RegisterMethod('Function ClientToCol( X : Integer) : Integer');
    RegisterMethod('Procedure ClientToGrid( APoint : TPoint; var Col, Row : Integer)');
    RegisterMethod('Function GridRect( Col, Row : Integer) : TRect');
    RegisterMethod('Function ClientToGridRect( APoint : TPoint) : TRect');
    RegisterMethod('Procedure Clear');
    RegisterMethod('Procedure InvalidateRows');
    RegisterMethod('Function IsHeaderVisible : Boolean');
    RegisterMethod('Procedure DeselectAll');
    RegisterMethod('Procedure SelectAll');
    RegisterMethod('Procedure BlockSelect( IndexFrom, IndexTo : Integer; Select : TSelectionChange)');
    RegisterMethod('Function DefaultQueryItem( RecNum, FldNum : Integer) : AnsiString');
    RegisterMethod('Function DefaultQueryHeader( FldNum : Integer) : AnsiString');
    RegisterMethod('Function DefaultQuerySplitter( AnIndex : Integer) : Integer');
    RegisterProperty('BorderStyle', 'TBorderStyle', iptrw);
    RegisterProperty('ScrollBars', 'TScrollStyle', iptrw);
    RegisterProperty('RecCount', 'Integer', iptrw);
    RegisterProperty('NumRows', 'Integer', iptrw);
    RegisterProperty('NumItems', 'Integer', iptrw);
    RegisterProperty('NumCols', 'Integer', iptrw);
    RegisterProperty('ColCOunt', 'Integer', iptrw);
    RegisterProperty('ItemRect', 'TRect Integer', iptr);
    RegisterProperty('HeaderRect', 'TRect', iptr);
    RegisterProperty('RowHeight', 'Integer', iptrw);
    RegisterProperty('HeaderHeight', 'Integer', iptrw);
    RegisterProperty('Colors', 'TLBColors', iptrw);
    RegisterProperty('Options', 'TVirtListBoxOptions', iptrw);
    RegisterProperty('FontHeader', 'TFont', iptrw);
    RegisterProperty('TopIndex', 'Integer', iptrw);
    RegisterProperty('ItemIndex', 'Integer', iptrw);
    RegisterProperty('SelCount', 'Integer', iptr);
    RegisterProperty('LeftColIndex', 'Integer', iptrw);
    RegisterProperty('OwnerDrawHeader', 'Boolean', iptrw);
    RegisterProperty('OwnerDraw', 'Boolean', iptrw);
    RegisterProperty('OnBeforeDrawItem', 'TBeforeAfterDrawItemEvent', iptrw);
    RegisterProperty('OnAfterDrawItem', 'TBeforeAfterDrawItemEvent', iptrw);
    RegisterProperty('OnDrawItem', 'TDrawItemEvent', iptrw);
    RegisterProperty('DefColWidth', 'Integer', iptrw);
    RegisterProperty('LeftOffset', 'Integer', iptrw);
    RegisterProperty('OnChange', 'TOnChangeEvent', iptrw);
    RegisterProperty('OnSelectionChange', 'TSelectionChangeEvent', iptrw);
    RegisterProperty('OnTopIndexChanged', 'TTopIndexChangedEvent', iptrw);
    RegisterProperty('OnQuerySplitter', 'TQuerySplitterEvent', iptrw);
    RegisterProperty('OnQueryItem', 'TQueryItemEvent', iptrw);
    RegisterProperty('OnQuerySelection', 'TQuerySelectionEvent', iptrw);
    RegisterProperty('OnQueryHeader', 'TQueryHeaderEvent', iptrw);
    RegisterProperty('OnQueryField', 'TQueryFieldAttrEvent', iptrw);
    RegisterProperty('OnResizeColumn', 'TResizeColumnEvent', iptrw);
    RegisterProperty('OnAfterPaintRow', 'TRowPaintEvent', iptrw);
    RegisterProperty('OnBeforePaintRow', 'TRowPaintEvent', iptrw);
    RegisterProperty('OnAfterPaint', 'TControlPaintEvent', iptrw);
    RegisterProperty('OnBeforePaint', 'TControlPaintEvent', iptrw);
    RegisterProperty('OnHeaderClick', 'THeaderClickEvent', iptrw);
    RegisterProperty('WheelDelta', 'Integer', iptrw);
    RegisterProperty('MultiSelect', 'Boolean', iptrw);
    RegisterProperty('OnMouseWheel', 'TMouseWheelEvent', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TLbColors(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TBaseLbColors', 'TLbColors') do
  with CL.AddClassN(CL.FindClass('TBaseLbColors'),'TLbColors') do begin
    RegisterPublishedProperties;
     RegisterProperty('Window', 'TColor', iptrw);
    RegisterProperty('Text', 'TColor', iptrw);
    RegisterProperty('Highlight', 'TColor', iptrw);
    RegisterProperty('HighText', 'TColor', iptrw);
    RegisterProperty('Disabled', 'TColor', iptrw);
    RegisterProperty('GridHoriz', 'TColor', iptrw);
    RegisterProperty('GridVert', 'TColor', iptrw);
    RegisterProperty('Header', 'TColor', iptrw);
    RegisterProperty('HeaderText', 'TColor', iptrw);

  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TBaseLbColors(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TPersistent', 'TBaseLbColors') do
  with CL.AddClassN(CL.FindClass('TPersistent'),'TBaseLbColors') do
  begin
    RegisterMethod('Constructor Create');
    RegisterProperty('Window', 'TColor', iptrw);
    RegisterProperty('Text', 'TColor', iptrw);
    RegisterProperty('Highlight', 'TColor', iptrw);
    RegisterProperty('HighText', 'TColor', iptrw);
    RegisterProperty('Disabled', 'TColor', iptrw);
    RegisterProperty('GridHoriz', 'TColor', iptrw);
    RegisterProperty('GridVert', 'TColor', iptrw);
    RegisterProperty('Header', 'TColor', iptrw);
    RegisterProperty('HeaderText', 'TColor', iptrw);
    RegisterProperty('OnChange', 'TOnColorChangeEvent', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_VListBox(CL: TPSPascalCompiler);
begin
 CL.AddConstantN('VScrollingAccel1Pixels','LongInt').SetInt( 60);
 CL.AddConstantN('VScrollingAccel2Pixels','LongInt').SetInt( 120);
 CL.AddConstantN('VScrollingAccel1Rows','LongInt').SetInt( 5);
 CL.AddConstantN('VScrollingAccel2Rows','LongInt').SetInt( 15);
  CL.AddTypeS('TLBColorIndex', '( clbWindow, clbText, clbHighlight, clbHighText'
   +', clbDisabled, clbHorizGrid, clbVertGrid, clbHeader, clbHeaderText )');
  CL.AddTypeS('TOnColorChangeEvent', 'Procedure ( AnIndex : TLBColorIndex; AColor : TColor)');
  SIRegister_TBaseLbColors(CL);
  SIRegister_TLbColors(CL);
  CL.AddTypeS('TZeroOrOne', 'Integer');
  CL.AddTypeS('TVirtListBoxOption', '( oDisableHScroll, oDoNotEraseBkgnd, oHide'
   +'FocusRect, oHideHeader, oHideHGrid, oHideVGrid, oHeaderCursor, oHideSelect'
   +'ion, oDoNotHighlightSelected, oDisableDragSplitter, oHeaderButton )');
  CL.AddTypeS('TVirtListBoxOptions', 'set of TVirtListBoxOption');
  CL.AddTypeS('TSelectionChange', '( selNone, selSelect, selDeselect, selToggle, selSelectAll, selDeselectAll )');
  CL.AddTypeS('TOnChangeEvent', 'Procedure ( Sender : TObject; OldIndex : Integer)');
  CL.AddTypeS('TIsSelectedEvent2', 'Procedure ( Sender : TObject; Index : Integer; var Selected : Boolean)');
  CL.AddTypeS('TSelectEvent2', 'Procedure ( Sender : TObject; Index : Integer; Selected : Boolean)');
  CL.AddTypeS('TQuerySplitterEvent', 'Function ( AnIndex : Integer) : Integer');
  CL.AddTypeS('TTopIndexChangedEvent', 'Procedure ( Sender : TObject; NewTopIndex : LongInt)');
  CL.AddTypeS('TQueryItemEvent', 'Function ( RecNum, ColNum : Integer) : AnsiString');
  CL.AddTypeS('TQuerySelectionEvent', 'Procedure ( RecNum : Integer; var Selected : Boolean)');
  CL.AddTypeS('TQueryHeaderEvent', 'Function ( ColNum : Integer) : AnsiString');
  CL.AddTypeS('TQueryFieldAttrEvent', 'Procedure ( RecNum, FieldNum : Integer; '
   +'var Align : TAlignment; Canvas : TCanvas)');
  CL.AddTypeS('TSelectionChangeEvent', 'Procedure ( RecNum : Integer; SelChange: TSelectionChange)');
  CL.AddTypeS('TResizeColumnEvent', 'Procedure ( SplitNum : Integer; NewPos : Integer)');
  CL.AddTypeS('TDrawItemEvent2', 'Procedure ( RecNum, FieldNum : Integer; Rect :'
   +' TRect; State : TOwnerDrawState)');
  CL.AddTypeS('TBeforeAfterDrawItemEvent', 'Procedure ( RecNum, FieldNum : Inte'
   +'ger; Rect : TRect; Align : TAlignment; State : TOwnerDrawState)');
  CL.AddTypeS('TRowPaintEvent', 'Procedure ( RecNum : Integer; Rect : TRect; St'
   +'ate : TOwnerDrawState; Canvas : TCanvas)');
  CL.AddTypeS('TControlPaintEvent', 'Procedure ( SenderCanvas : TCanvas)');
  CL.AddTypeS('TMouseWheelEvent2', 'Procedure ( Sender : TObject; Shift : TShift'
   +'State; Delta, XPos, YPos : Word)');
  CL.AddTypeS('THeaderClickEvent2', 'Procedure ( Sender : TObject; Col : Integer)');
  SIRegister_TBaseVirtListBox(CL);
  SIRegister_TVirtListBox(CL);
  SIRegister_TVirtListBoxEx(CL);
 //CL.AddDelphiFunction('Procedure Register');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TVirtListBoxExNumCols_R(Self: TVirtListBoxEx; var T: Integer);
begin T := Self.NumCols; end;

(*----------------------------------------------------------------------------*)
procedure TVirtListBoxExColumns_W(Self: TVirtListBoxEx; const T: TStrings);
begin Self.Columns := T; end;

(*----------------------------------------------------------------------------*)
procedure TVirtListBoxExColumns_R(Self: TVirtListBoxEx; var T: TStrings);
begin T := Self.Columns; end;

(*----------------------------------------------------------------------------*)
procedure TVirtListBoxExColumnWidth_W(Self: TVirtListBoxEx; const T: Integer; const t1: Integer);
begin Self.ColumnWidth[t1] := T; end;

(*----------------------------------------------------------------------------*)
procedure TVirtListBoxExColumnWidth_R(Self: TVirtListBoxEx; var T: Integer; const t1: Integer);
begin T := Self.ColumnWidth[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TVirtListBoxExSplitter_W(Self: TVirtListBoxEx; const T: Integer; const t1: Integer);
begin Self.Splitter[t1] := T; end;

(*----------------------------------------------------------------------------*)
procedure TVirtListBoxExSplitter_R(Self: TVirtListBoxEx; var T: Integer; const t1: Integer);
begin T := Self.Splitter[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TBaseVirtListBoxOnMouseWheel_W(Self: TBaseVirtListBox; const T: TMouseWheelEvent);
begin Self.OnMouseWheel := T; end;

(*----------------------------------------------------------------------------*)
procedure TBaseVirtListBoxOnMouseWheel_R(Self: TBaseVirtListBox; var T: TMouseWheelEvent);
begin T := Self.OnMouseWheel; end;

(*----------------------------------------------------------------------------*)
procedure TBaseVirtListBoxMultiSelect_W(Self: TBaseVirtListBox; const T: Boolean);
begin Self.MultiSelect := T; end;

(*----------------------------------------------------------------------------*)
procedure TBaseVirtListBoxMultiSelect_R(Self: TBaseVirtListBox; var T: Boolean);
begin T := Self.MultiSelect; end;

(*----------------------------------------------------------------------------*)
procedure TBaseVirtListBoxWheelDelta_W(Self: TBaseVirtListBox; const T: Integer);
begin Self.WheelDelta := T; end;

(*----------------------------------------------------------------------------*)
procedure TBaseVirtListBoxWheelDelta_R(Self: TBaseVirtListBox; var T: Integer);
begin T := Self.WheelDelta; end;

(*----------------------------------------------------------------------------*)
procedure TBaseVirtListBoxOnHeaderClick_W(Self: TBaseVirtListBox; const T: THeaderClickEvent);
begin Self.OnHeaderClick := T; end;

(*----------------------------------------------------------------------------*)
procedure TBaseVirtListBoxOnHeaderClick_R(Self: TBaseVirtListBox; var T: THeaderClickEvent);
begin T := Self.OnHeaderClick; end;

(*----------------------------------------------------------------------------*)
procedure TBaseVirtListBoxOnBeforePaint_W(Self: TBaseVirtListBox; const T: TControlPaintEvent);
begin Self.OnBeforePaint := T; end;

(*----------------------------------------------------------------------------*)
procedure TBaseVirtListBoxOnBeforePaint_R(Self: TBaseVirtListBox; var T: TControlPaintEvent);
begin T := Self.OnBeforePaint; end;

(*----------------------------------------------------------------------------*)
procedure TBaseVirtListBoxOnAfterPaint_W(Self: TBaseVirtListBox; const T: TControlPaintEvent);
begin Self.OnAfterPaint := T; end;

(*----------------------------------------------------------------------------*)
procedure TBaseVirtListBoxOnAfterPaint_R(Self: TBaseVirtListBox; var T: TControlPaintEvent);
begin T := Self.OnAfterPaint; end;

(*----------------------------------------------------------------------------*)
procedure TBaseVirtListBoxOnBeforePaintRow_W(Self: TBaseVirtListBox; const T: TRowPaintEvent);
begin Self.OnBeforePaintRow := T; end;

(*----------------------------------------------------------------------------*)
procedure TBaseVirtListBoxOnBeforePaintRow_R(Self: TBaseVirtListBox; var T: TRowPaintEvent);
begin T := Self.OnBeforePaintRow; end;

(*----------------------------------------------------------------------------*)
procedure TBaseVirtListBoxOnAfterPaintRow_W(Self: TBaseVirtListBox; const T: TRowPaintEvent);
begin Self.OnAfterPaintRow := T; end;

(*----------------------------------------------------------------------------*)
procedure TBaseVirtListBoxOnAfterPaintRow_R(Self: TBaseVirtListBox; var T: TRowPaintEvent);
begin T := Self.OnAfterPaintRow; end;

(*----------------------------------------------------------------------------*)
procedure TBaseVirtListBoxOnResizeColumn_W(Self: TBaseVirtListBox; const T: TResizeColumnEvent);
begin Self.OnResizeColumn := T; end;

(*----------------------------------------------------------------------------*)
procedure TBaseVirtListBoxOnResizeColumn_R(Self: TBaseVirtListBox; var T: TResizeColumnEvent);
begin T := Self.OnResizeColumn; end;

(*----------------------------------------------------------------------------*)
procedure TBaseVirtListBoxOnQueryField_W(Self: TBaseVirtListBox; const T: TQueryFieldAttrEvent);
begin Self.OnQueryField := T; end;

(*----------------------------------------------------------------------------*)
procedure TBaseVirtListBoxOnQueryField_R(Self: TBaseVirtListBox; var T: TQueryFieldAttrEvent);
begin T := Self.OnQueryField; end;

(*----------------------------------------------------------------------------*)
procedure TBaseVirtListBoxOnQueryHeader_W(Self: TBaseVirtListBox; const T: TQueryHeaderEvent);
begin Self.OnQueryHeader := T; end;

(*----------------------------------------------------------------------------*)
procedure TBaseVirtListBoxOnQueryHeader_R(Self: TBaseVirtListBox; var T: TQueryHeaderEvent);
begin T := Self.OnQueryHeader; end;

(*----------------------------------------------------------------------------*)
procedure TBaseVirtListBoxOnQuerySelection_W(Self: TBaseVirtListBox; const T: TQuerySelectionEvent);
begin Self.OnQuerySelection := T; end;

(*----------------------------------------------------------------------------*)
procedure TBaseVirtListBoxOnQuerySelection_R(Self: TBaseVirtListBox; var T: TQuerySelectionEvent);
begin T := Self.OnQuerySelection; end;

(*----------------------------------------------------------------------------*)
procedure TBaseVirtListBoxOnQueryItem_W(Self: TBaseVirtListBox; const T: TQueryItemEvent);
begin Self.OnQueryItem := T; end;

(*----------------------------------------------------------------------------*)
procedure TBaseVirtListBoxOnQueryItem_R(Self: TBaseVirtListBox; var T: TQueryItemEvent);
begin T := Self.OnQueryItem; end;

(*----------------------------------------------------------------------------*)
procedure TBaseVirtListBoxOnQuerySplitter_W(Self: TBaseVirtListBox; const T: TQuerySplitterEvent);
begin Self.OnQuerySplitter := T; end;

(*----------------------------------------------------------------------------*)
procedure TBaseVirtListBoxOnQuerySplitter_R(Self: TBaseVirtListBox; var T: TQuerySplitterEvent);
begin T := Self.OnQuerySplitter; end;

(*----------------------------------------------------------------------------*)
procedure TBaseVirtListBoxOnTopIndexChanged_W(Self: TBaseVirtListBox; const T: TTopIndexChangedEvent);
begin Self.OnTopIndexChanged := T; end;

(*----------------------------------------------------------------------------*)
procedure TBaseVirtListBoxOnTopIndexChanged_R(Self: TBaseVirtListBox; var T: TTopIndexChangedEvent);
begin T := Self.OnTopIndexChanged; end;

(*----------------------------------------------------------------------------*)
procedure TBaseVirtListBoxOnSelectionChange_W(Self: TBaseVirtListBox; const T: TSelectionChangeEvent);
begin Self.OnSelectionChange := T; end;

(*----------------------------------------------------------------------------*)
procedure TBaseVirtListBoxOnSelectionChange_R(Self: TBaseVirtListBox; var T: TSelectionChangeEvent);
begin T := Self.OnSelectionChange; end;

(*----------------------------------------------------------------------------*)
procedure TBaseVirtListBoxOnChange_W(Self: TBaseVirtListBox; const T: TOnChangeEvent);
begin Self.OnChange := T; end;

(*----------------------------------------------------------------------------*)
procedure TBaseVirtListBoxOnChange_R(Self: TBaseVirtListBox; var T: TOnChangeEvent);
begin T := Self.OnChange; end;

(*----------------------------------------------------------------------------*)
procedure TBaseVirtListBoxLeftOffset_W(Self: TBaseVirtListBox; const T: Integer);
begin Self.LeftOffset := T; end;

(*----------------------------------------------------------------------------*)
procedure TBaseVirtListBoxLeftOffset_R(Self: TBaseVirtListBox; var T: Integer);
begin T := Self.LeftOffset; end;

(*----------------------------------------------------------------------------*)
procedure TBaseVirtListBoxDefColWidth_W(Self: TBaseVirtListBox; const T: Integer);
begin Self.DefColWidth := T; end;

(*----------------------------------------------------------------------------*)
procedure TBaseVirtListBoxDefColWidth_R(Self: TBaseVirtListBox; var T: Integer);
begin T := Self.DefColWidth; end;

(*----------------------------------------------------------------------------*)
procedure TBaseVirtListBoxOnDrawItem_W(Self: TBaseVirtListBox; const T: TDrawItemEvent);
begin Self.OnDrawItem := T; end;

(*----------------------------------------------------------------------------*)
procedure TBaseVirtListBoxOnDrawItem_R(Self: TBaseVirtListBox; var T: TDrawItemEvent);
begin T := Self.OnDrawItem; end;

(*----------------------------------------------------------------------------*)
procedure TBaseVirtListBoxOnAfterDrawItem_W(Self: TBaseVirtListBox; const T: TBeforeAfterDrawItemEvent);
begin Self.OnAfterDrawItem := T; end;

(*----------------------------------------------------------------------------*)
procedure TBaseVirtListBoxOnAfterDrawItem_R(Self: TBaseVirtListBox; var T: TBeforeAfterDrawItemEvent);
begin T := Self.OnAfterDrawItem; end;

(*----------------------------------------------------------------------------*)
procedure TBaseVirtListBoxOnBeforeDrawItem_W(Self: TBaseVirtListBox; const T: TBeforeAfterDrawItemEvent);
begin Self.OnBeforeDrawItem := T; end;

(*----------------------------------------------------------------------------*)
procedure TBaseVirtListBoxOnBeforeDrawItem_R(Self: TBaseVirtListBox; var T: TBeforeAfterDrawItemEvent);
begin T := Self.OnBeforeDrawItem; end;

(*----------------------------------------------------------------------------*)
procedure TBaseVirtListBoxOwnerDraw_W(Self: TBaseVirtListBox; const T: Boolean);
begin Self.OwnerDraw := T; end;

(*----------------------------------------------------------------------------*)
procedure TBaseVirtListBoxOwnerDraw_R(Self: TBaseVirtListBox; var T: Boolean);
begin T := Self.OwnerDraw; end;

(*----------------------------------------------------------------------------*)
procedure TBaseVirtListBoxOwnerDrawHeader_W(Self: TBaseVirtListBox; const T: Boolean);
begin Self.OwnerDrawHeader := T; end;

(*----------------------------------------------------------------------------*)
procedure TBaseVirtListBoxOwnerDrawHeader_R(Self: TBaseVirtListBox; var T: Boolean);
begin T := Self.OwnerDrawHeader; end;

(*----------------------------------------------------------------------------*)
procedure TBaseVirtListBoxLeftColIndex_W(Self: TBaseVirtListBox; const T: Integer);
begin Self.LeftColIndex := T; end;

(*----------------------------------------------------------------------------*)
procedure TBaseVirtListBoxLeftColIndex_R(Self: TBaseVirtListBox; var T: Integer);
begin T := Self.LeftColIndex; end;

(*----------------------------------------------------------------------------*)
procedure TBaseVirtListBoxSelCount_R(Self: TBaseVirtListBox; var T: Integer);
begin T := Self.SelCount; end;

(*----------------------------------------------------------------------------*)
procedure TBaseVirtListBoxItemIndex_W(Self: TBaseVirtListBox; const T: Integer);
begin Self.ItemIndex := T; end;

(*----------------------------------------------------------------------------*)
procedure TBaseVirtListBoxItemIndex_R(Self: TBaseVirtListBox; var T: Integer);
begin T := Self.ItemIndex; end;

(*----------------------------------------------------------------------------*)
procedure TBaseVirtListBoxTopIndex_W(Self: TBaseVirtListBox; const T: Integer);
begin Self.TopIndex := T; end;

(*----------------------------------------------------------------------------*)
procedure TBaseVirtListBoxTopIndex_R(Self: TBaseVirtListBox; var T: Integer);
begin T := Self.TopIndex; end;

(*----------------------------------------------------------------------------*)
procedure TBaseVirtListBoxFontHeader_W(Self: TBaseVirtListBox; const T: TFont);
begin Self.FontHeader := T; end;

(*----------------------------------------------------------------------------*)
procedure TBaseVirtListBoxFontHeader_R(Self: TBaseVirtListBox; var T: TFont);
begin T := Self.FontHeader; end;

(*----------------------------------------------------------------------------*)
procedure TBaseVirtListBoxOptions_W(Self: TBaseVirtListBox; const T: TVirtListBoxOptions);
begin Self.Options := T; end;

(*----------------------------------------------------------------------------*)
procedure TBaseVirtListBoxOptions_R(Self: TBaseVirtListBox; var T: TVirtListBoxOptions);
begin T := Self.Options; end;

(*----------------------------------------------------------------------------*)
procedure TBaseVirtListBoxColors_W(Self: TBaseVirtListBox; const T: TLBColors);
begin Self.Colors := T; end;

(*----------------------------------------------------------------------------*)
procedure TBaseVirtListBoxColors_R(Self: TBaseVirtListBox; var T: TLBColors);
begin T := Self.Colors; end;

(*----------------------------------------------------------------------------*)
procedure TBaseVirtListBoxHeaderHeight_W(Self: TBaseVirtListBox; const T: Integer);
begin Self.HeaderHeight := T; end;

(*----------------------------------------------------------------------------*)
procedure TBaseVirtListBoxHeaderHeight_R(Self: TBaseVirtListBox; var T: Integer);
begin T := Self.HeaderHeight; end;

(*----------------------------------------------------------------------------*)
procedure TBaseVirtListBoxRowHeight_W(Self: TBaseVirtListBox; const T: Integer);
begin Self.RowHeight := T; end;

(*----------------------------------------------------------------------------*)
procedure TBaseVirtListBoxRowHeight_R(Self: TBaseVirtListBox; var T: Integer);
begin T := Self.RowHeight; end;

(*----------------------------------------------------------------------------*)
procedure TBaseVirtListBoxHeaderRect_R(Self: TBaseVirtListBox; var T: TRect);
begin T := Self.HeaderRect; end;

(*----------------------------------------------------------------------------*)
procedure TBaseVirtListBoxItemRect_R(Self: TBaseVirtListBox; var T: TRect; const t1: Integer);
begin T := Self.ItemRect[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TBaseVirtListBoxColCOunt_W(Self: TBaseVirtListBox; const T: Integer);
begin Self.ColCOunt := T; end;

(*----------------------------------------------------------------------------*)
procedure TBaseVirtListBoxColCOunt_R(Self: TBaseVirtListBox; var T: Integer);
begin T := Self.ColCOunt; end;

(*----------------------------------------------------------------------------*)
procedure TBaseVirtListBoxNumCols_W(Self: TBaseVirtListBox; const T: Integer);
begin Self.NumCols := T; end;

(*----------------------------------------------------------------------------*)
procedure TBaseVirtListBoxNumCols_R(Self: TBaseVirtListBox; var T: Integer);
begin T := Self.NumCols; end;

(*----------------------------------------------------------------------------*)
procedure TBaseVirtListBoxNumItems_W(Self: TBaseVirtListBox; const T: Integer);
begin Self.NumItems := T; end;

(*----------------------------------------------------------------------------*)
procedure TBaseVirtListBoxNumItems_R(Self: TBaseVirtListBox; var T: Integer);
begin T := Self.NumItems; end;

(*----------------------------------------------------------------------------*)
procedure TBaseVirtListBoxNumRows_W(Self: TBaseVirtListBox; const T: Integer);
begin Self.NumRows := T; end;

(*----------------------------------------------------------------------------*)
procedure TBaseVirtListBoxNumRows_R(Self: TBaseVirtListBox; var T: Integer);
begin T := Self.NumRows; end;

(*----------------------------------------------------------------------------*)
procedure TBaseVirtListBoxRecCount_W(Self: TBaseVirtListBox; const T: Integer);
begin Self.RecCount := T; end;

(*----------------------------------------------------------------------------*)
procedure TBaseVirtListBoxRecCount_R(Self: TBaseVirtListBox; var T: Integer);
begin T := Self.RecCount; end;

(*----------------------------------------------------------------------------*)
procedure TBaseVirtListBoxScrollBars_W(Self: TBaseVirtListBox; const T: TScrollStyle);
begin Self.ScrollBars := T; end;

(*----------------------------------------------------------------------------*)
procedure TBaseVirtListBoxScrollBars_R(Self: TBaseVirtListBox; var T: TScrollStyle);
begin T := Self.ScrollBars; end;

(*----------------------------------------------------------------------------*)
procedure TBaseVirtListBoxBorderStyle_W(Self: TBaseVirtListBox; const T: TBorderStyle);
begin Self.BorderStyle := T; end;

(*----------------------------------------------------------------------------*)
procedure TBaseVirtListBoxBorderStyle_R(Self: TBaseVirtListBox; var T: TBorderStyle);
begin T := Self.BorderStyle; end;

(*----------------------------------------------------------------------------*)
procedure TBaseLbColorsOnChange_W(Self: TBaseLbColors; const T: TOnColorChangeEvent);
begin Self.OnChange := T; end;

(*----------------------------------------------------------------------------*)
procedure TBaseLbColorsOnChange_R(Self: TBaseLbColors; var T: TOnColorChangeEvent);
begin T := Self.OnChange; end;

(*----------------------------------------------------------------------------*)
procedure TBaseLbColorsHeaderText_W(Self: TBaseLbColors; const T: TColor);
begin Self.HeaderText := T; end;

(*----------------------------------------------------------------------------*)
procedure TBaseLbColorsHeaderText_R(Self: TBaseLbColors; var T: TColor);
begin T := Self.HeaderText; end;

(*----------------------------------------------------------------------------*)
procedure TBaseLbColorsHeader_W(Self: TBaseLbColors; const T: TColor);
begin Self.Header := T; end;

(*----------------------------------------------------------------------------*)
procedure TBaseLbColorsHeader_R(Self: TBaseLbColors; var T: TColor);
begin T := Self.Header; end;

(*----------------------------------------------------------------------------*)
procedure TBaseLbColorsGridVert_W(Self: TBaseLbColors; const T: TColor);
begin Self.GridVert := T; end;

(*----------------------------------------------------------------------------*)
procedure TBaseLbColorsGridVert_R(Self: TBaseLbColors; var T: TColor);
begin T := Self.GridVert; end;

(*----------------------------------------------------------------------------*)
procedure TBaseLbColorsGridHoriz_W(Self: TBaseLbColors; const T: TColor);
begin Self.GridHoriz := T; end;

(*----------------------------------------------------------------------------*)
procedure TBaseLbColorsGridHoriz_R(Self: TBaseLbColors; var T: TColor);
begin T := Self.GridHoriz; end;

(*----------------------------------------------------------------------------*)
procedure TBaseLbColorsDisabled_W(Self: TBaseLbColors; const T: TColor);
begin Self.Disabled := T; end;

(*----------------------------------------------------------------------------*)
procedure TBaseLbColorsDisabled_R(Self: TBaseLbColors; var T: TColor);
begin T := Self.Disabled; end;

(*----------------------------------------------------------------------------*)
procedure TBaseLbColorsHighText_W(Self: TBaseLbColors; const T: TColor);
begin Self.HighText := T; end;

(*----------------------------------------------------------------------------*)
procedure TBaseLbColorsHighText_R(Self: TBaseLbColors; var T: TColor);
begin T := Self.HighText; end;

(*----------------------------------------------------------------------------*)
procedure TBaseLbColorsHighlight_W(Self: TBaseLbColors; const T: TColor);
begin Self.Highlight := T; end;

(*----------------------------------------------------------------------------*)
procedure TBaseLbColorsHighlight_R(Self: TBaseLbColors; var T: TColor);
begin T := Self.Highlight; end;

(*----------------------------------------------------------------------------*)
procedure TBaseLbColorsText_W(Self: TBaseLbColors; const T: TColor);
begin Self.Text := T; end;

(*----------------------------------------------------------------------------*)
procedure TBaseLbColorsText_R(Self: TBaseLbColors; var T: TColor);
begin T := Self.Text; end;

(*----------------------------------------------------------------------------*)
procedure TBaseLbColorsWindow_W(Self: TBaseLbColors; const T: TColor);
begin Self.Window := T; end;

(*----------------------------------------------------------------------------*)
procedure TBaseLbColorsWindow_R(Self: TBaseLbColors; var T: TColor);
begin T := Self.Window; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_VListBox_Routines(S: TPSExec);
begin
 //S.RegisterDelphiFunction(@Register, 'Register', cdRegister);
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TVirtListBoxEx(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TVirtListBoxEx) do begin
    RegisterConstructor(@TVirtListBoxEx.Create, 'Create');
      RegisterMethod(@TVirtListBoxEx.Destroy, 'Free');

    RegisterMethod(@TVirtListBoxEx.QueryHeader, 'QueryHeader');
    RegisterPropertyHelper(@TVirtListBoxExSplitter_R,@TVirtListBoxExSplitter_W,'Splitter');
    RegisterPropertyHelper(@TVirtListBoxExColumnWidth_R,@TVirtListBoxExColumnWidth_W,'ColumnWidth');
    RegisterPropertyHelper(@TVirtListBoxExColumns_R,@TVirtListBoxExColumns_W,'Columns');
    RegisterPropertyHelper(@TVirtListBoxExNumCols_R,nil,'NumCols');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TVirtListBox(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TVirtListBox) do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TBaseVirtListBox(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TBaseVirtListBox) do begin
    RegisterConstructor(@TBaseVirtListBox.Create, 'Create');
      RegisterMethod(@TBaseVirtListBox.Destroy, 'Free');

    RegisterMethod(@TBaseVirtListBox.ClientToRow, 'ClientToRow');
    RegisterMethod(@TBaseVirtListBox.ClientToCol, 'ClientToCol');
    RegisterMethod(@TBaseVirtListBox.ClientToGrid, 'ClientToGrid');
    RegisterMethod(@TBaseVirtListBox.GridRect, 'GridRect');
    RegisterMethod(@TBaseVirtListBox.ClientToGridRect, 'ClientToGridRect');
    RegisterMethod(@TBaseVirtListBox.Clear, 'Clear');
    RegisterMethod(@TBaseVirtListBox.InvalidateRows, 'InvalidateRows');
    RegisterMethod(@TBaseVirtListBox.IsHeaderVisible, 'IsHeaderVisible');
    RegisterMethod(@TBaseVirtListBox.DeselectAll, 'DeselectAll');
    RegisterMethod(@TBaseVirtListBox.SelectAll, 'SelectAll');
    RegisterMethod(@TBaseVirtListBox.BlockSelect, 'BlockSelect');
    RegisterMethod(@TBaseVirtListBox.DefaultQueryItem, 'DefaultQueryItem');
    RegisterMethod(@TBaseVirtListBox.DefaultQueryHeader, 'DefaultQueryHeader');
    RegisterMethod(@TBaseVirtListBox.DefaultQuerySplitter, 'DefaultQuerySplitter');
    RegisterPropertyHelper(@TBaseVirtListBoxBorderStyle_R,@TBaseVirtListBoxBorderStyle_W,'BorderStyle');
    RegisterPropertyHelper(@TBaseVirtListBoxScrollBars_R,@TBaseVirtListBoxScrollBars_W,'ScrollBars');
    RegisterPropertyHelper(@TBaseVirtListBoxRecCount_R,@TBaseVirtListBoxRecCount_W,'RecCount');
    RegisterPropertyHelper(@TBaseVirtListBoxNumRows_R,@TBaseVirtListBoxNumRows_W,'NumRows');
    RegisterPropertyHelper(@TBaseVirtListBoxNumItems_R,@TBaseVirtListBoxNumItems_W,'NumItems');
    RegisterPropertyHelper(@TBaseVirtListBoxNumCols_R,@TBaseVirtListBoxNumCols_W,'NumCols');
    RegisterPropertyHelper(@TBaseVirtListBoxColCOunt_R,@TBaseVirtListBoxColCOunt_W,'ColCOunt');
    RegisterPropertyHelper(@TBaseVirtListBoxItemRect_R,nil,'ItemRect');
    RegisterPropertyHelper(@TBaseVirtListBoxHeaderRect_R,nil,'HeaderRect');
    RegisterPropertyHelper(@TBaseVirtListBoxRowHeight_R,@TBaseVirtListBoxRowHeight_W,'RowHeight');
    RegisterPropertyHelper(@TBaseVirtListBoxHeaderHeight_R,@TBaseVirtListBoxHeaderHeight_W,'HeaderHeight');
    RegisterPropertyHelper(@TBaseVirtListBoxColors_R,@TBaseVirtListBoxColors_W,'Colors');
    RegisterPropertyHelper(@TBaseVirtListBoxOptions_R,@TBaseVirtListBoxOptions_W,'Options');
    RegisterPropertyHelper(@TBaseVirtListBoxFontHeader_R,@TBaseVirtListBoxFontHeader_W,'FontHeader');
    RegisterPropertyHelper(@TBaseVirtListBoxTopIndex_R,@TBaseVirtListBoxTopIndex_W,'TopIndex');
    RegisterPropertyHelper(@TBaseVirtListBoxItemIndex_R,@TBaseVirtListBoxItemIndex_W,'ItemIndex');
    RegisterPropertyHelper(@TBaseVirtListBoxSelCount_R,nil,'SelCount');
    RegisterPropertyHelper(@TBaseVirtListBoxLeftColIndex_R,@TBaseVirtListBoxLeftColIndex_W,'LeftColIndex');
    RegisterPropertyHelper(@TBaseVirtListBoxOwnerDrawHeader_R,@TBaseVirtListBoxOwnerDrawHeader_W,'OwnerDrawHeader');
    RegisterPropertyHelper(@TBaseVirtListBoxOwnerDraw_R,@TBaseVirtListBoxOwnerDraw_W,'OwnerDraw');
    RegisterPropertyHelper(@TBaseVirtListBoxOnBeforeDrawItem_R,@TBaseVirtListBoxOnBeforeDrawItem_W,'OnBeforeDrawItem');
    RegisterPropertyHelper(@TBaseVirtListBoxOnAfterDrawItem_R,@TBaseVirtListBoxOnAfterDrawItem_W,'OnAfterDrawItem');
    RegisterPropertyHelper(@TBaseVirtListBoxOnDrawItem_R,@TBaseVirtListBoxOnDrawItem_W,'OnDrawItem');
    RegisterPropertyHelper(@TBaseVirtListBoxDefColWidth_R,@TBaseVirtListBoxDefColWidth_W,'DefColWidth');
    RegisterPropertyHelper(@TBaseVirtListBoxLeftOffset_R,@TBaseVirtListBoxLeftOffset_W,'LeftOffset');
    RegisterPropertyHelper(@TBaseVirtListBoxOnChange_R,@TBaseVirtListBoxOnChange_W,'OnChange');
    RegisterPropertyHelper(@TBaseVirtListBoxOnSelectionChange_R,@TBaseVirtListBoxOnSelectionChange_W,'OnSelectionChange');
    RegisterPropertyHelper(@TBaseVirtListBoxOnTopIndexChanged_R,@TBaseVirtListBoxOnTopIndexChanged_W,'OnTopIndexChanged');
    RegisterPropertyHelper(@TBaseVirtListBoxOnQuerySplitter_R,@TBaseVirtListBoxOnQuerySplitter_W,'OnQuerySplitter');
    RegisterPropertyHelper(@TBaseVirtListBoxOnQueryItem_R,@TBaseVirtListBoxOnQueryItem_W,'OnQueryItem');
    RegisterPropertyHelper(@TBaseVirtListBoxOnQuerySelection_R,@TBaseVirtListBoxOnQuerySelection_W,'OnQuerySelection');
    RegisterPropertyHelper(@TBaseVirtListBoxOnQueryHeader_R,@TBaseVirtListBoxOnQueryHeader_W,'OnQueryHeader');
    RegisterPropertyHelper(@TBaseVirtListBoxOnQueryField_R,@TBaseVirtListBoxOnQueryField_W,'OnQueryField');
    RegisterPropertyHelper(@TBaseVirtListBoxOnResizeColumn_R,@TBaseVirtListBoxOnResizeColumn_W,'OnResizeColumn');
    RegisterPropertyHelper(@TBaseVirtListBoxOnAfterPaintRow_R,@TBaseVirtListBoxOnAfterPaintRow_W,'OnAfterPaintRow');
    RegisterPropertyHelper(@TBaseVirtListBoxOnBeforePaintRow_R,@TBaseVirtListBoxOnBeforePaintRow_W,'OnBeforePaintRow');
    RegisterPropertyHelper(@TBaseVirtListBoxOnAfterPaint_R,@TBaseVirtListBoxOnAfterPaint_W,'OnAfterPaint');
    RegisterPropertyHelper(@TBaseVirtListBoxOnBeforePaint_R,@TBaseVirtListBoxOnBeforePaint_W,'OnBeforePaint');
    RegisterPropertyHelper(@TBaseVirtListBoxOnHeaderClick_R,@TBaseVirtListBoxOnHeaderClick_W,'OnHeaderClick');
    RegisterPropertyHelper(@TBaseVirtListBoxWheelDelta_R,@TBaseVirtListBoxWheelDelta_W,'WheelDelta');
    RegisterPropertyHelper(@TBaseVirtListBoxMultiSelect_R,@TBaseVirtListBoxMultiSelect_W,'MultiSelect');
    RegisterPropertyHelper(@TBaseVirtListBoxOnMouseWheel_R,@TBaseVirtListBoxOnMouseWheel_W,'OnMouseWheel');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TLbColors(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TLbColors) do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TBaseLbColors(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TBaseLbColors) do
  begin
    RegisterConstructor(@TBaseLbColors.Create, 'Create');
    RegisterPropertyHelper(@TBaseLbColorsWindow_R,@TBaseLbColorsWindow_W,'Window');
    RegisterPropertyHelper(@TBaseLbColorsText_R,@TBaseLbColorsText_W,'Text');
    RegisterPropertyHelper(@TBaseLbColorsHighlight_R,@TBaseLbColorsHighlight_W,'Highlight');
    RegisterPropertyHelper(@TBaseLbColorsHighText_R,@TBaseLbColorsHighText_W,'HighText');
    RegisterPropertyHelper(@TBaseLbColorsDisabled_R,@TBaseLbColorsDisabled_W,'Disabled');
    RegisterPropertyHelper(@TBaseLbColorsGridHoriz_R,@TBaseLbColorsGridHoriz_W,'GridHoriz');
    RegisterPropertyHelper(@TBaseLbColorsGridVert_R,@TBaseLbColorsGridVert_W,'GridVert');
    RegisterPropertyHelper(@TBaseLbColorsHeader_R,@TBaseLbColorsHeader_W,'Header');
    RegisterPropertyHelper(@TBaseLbColorsHeaderText_R,@TBaseLbColorsHeaderText_W,'HeaderText');
    RegisterPropertyHelper(@TBaseLbColorsOnChange_R,@TBaseLbColorsOnChange_W,'OnChange');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_VListBox(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TBaseLbColors(CL);
  RIRegister_TLbColors(CL);
  RIRegister_TBaseVirtListBox(CL);
  RIRegister_TVirtListBox(CL);
  RIRegister_TVirtListBoxEx(CL);
end;

 
 
{ TPSImport_VListBox }
(*----------------------------------------------------------------------------*)
procedure TPSImport_VListBox.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_VListBox(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_VListBox.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_VListBox(ri);
  //RIRegister_VListBox_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
