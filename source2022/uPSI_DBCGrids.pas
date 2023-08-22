unit uPSI_DBCGrids;
{

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
  TPSImport_DBCGrids = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TDBCtrlGrid(CL: TPSPascalCompiler);
procedure SIRegister_TDBCtrlPanel(CL: TPSPascalCompiler);
procedure SIRegister_TDBCtrlGridLink(CL: TPSPascalCompiler);
procedure SIRegister_DBCGrids(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TDBCtrlGrid(CL: TPSRuntimeClassImporter);
procedure RIRegister_TDBCtrlPanel(CL: TPSRuntimeClassImporter);
procedure RIRegister_TDBCtrlGridLink(CL: TPSRuntimeClassImporter);
procedure RIRegister_DBCGrids(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   Windows
  ,Messages
  ,Controls
  ,Forms
  ,Graphics
  ,Menus
  ,DB
  ,DBCGrids
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_DBCGrids]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TDBCtrlGrid(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TWinControl', 'TDBCtrlGrid') do
  with CL.AddClassN(CL.FindClass('TWinControl'),'TDBCtrlGrid') do begin
    RegisterPublishedProperties;
    RegisterMethod('Constructor Create( AOwner : TComponent)');
      RegisterMethod('Procedure Free');
     RegisterMethod('Procedure DoKey( Key : TDBCtrlGridKey)');
    RegisterMethod('function ExecuteAction(Action: TBasicAction): Boolean)');
    RegisterMethod('procedure GetTabOrderList(List: TList);');
    RegisterMethod('procedure KeyDown(var Key: Word; Shift: TShiftState);');
    RegisterMethod('procedure SetBounds(ALeft, ATop, AWidth, AHeight: Integer);');
    RegisterMethod('function UpdateAction(Action: TBasicAction): Boolean;');

    RegisterProperty('Field', 'TField', iptr);
    RegisterProperty('DataField', 'WideString', iptrw);
   // RegisterProperty('DataSource', 'TDataSource', iptrw);
     RegisterProperty('ALIGNMENT', 'TAlignment', iptrw);
     RegisterProperty('Align', 'TAlign', iptRW);
    RegisterProperty('ClientHeight', 'Longint', iptRW);
    RegisterProperty('ClientWidth', 'Longint', iptRW);
    RegisterProperty('ClientOrigin', 'TPoint', iptr);
    RegisterProperty('ClientRect', 'TRect', iptr);
    RegisterProperty('Anchors', 'TAnchors', iptRW);
    RegisterProperty('BidiMode', 'TBiDiMode', iptr);
    RegisterProperty('BoundsRect', 'TRect', iptr);
    //RegisterProperty('Color', 'TColor', iptr);
    //RegisterProperty('ClientWidth', 'Integer', iptrw);
    RegisterProperty('Constraints', 'TSizeConstraints', iptrw);
    RegisterProperty('AUTOSIZE', 'Boolean', iptrw);


    RegisterProperty('Canvas', 'TCanvas', iptr);
    RegisterProperty('EditMode', 'Boolean', iptrw);
    RegisterProperty('PanelCount', 'Integer', iptr);
    RegisterProperty('PanelIndex', 'Integer', iptrw);
    RegisterProperty('AllowDelete', 'Boolean', iptrw);
    RegisterProperty('AllowInsert', 'Boolean', iptrw);
    RegisterProperty('ColCount', 'Integer', iptrw);
    RegisterProperty('DataSource', 'TDataSource', iptrw);
    RegisterProperty('Orientation', 'TDBCtrlGridOrientation', iptrw);
    RegisterProperty('PanelBorder', 'TDBCtrlGridBorder', iptrw);
    RegisterProperty('PanelHeight', 'Integer', iptrw);
    RegisterProperty('PanelWidth', 'Integer', iptrw);
    RegisterProperty('RowCount', 'Integer', iptrw);
    RegisterProperty('SelectedColor', 'TColor', iptrw);
    RegisterProperty('ShowFocus', 'Boolean', iptrw);
    RegisterProperty('OnPaintPanel', 'TPaintPanelEvent', iptrw);

    RegisterMethod('Procedure REFRESH');
    RegisterMethod('Procedure Repaint;');
    RegisterMethod('Procedure Hide');
    RegisterMethod('Procedure Invalidate');
    RegisterMethod('Procedure Update');
    RegisterMethod('Procedure Show');

    RegisterProperty('OnCellClick', 'TDBGridClickEvent', iptrw);
    RegisterProperty('OnTitleClick', 'TDBGridClickEvent', iptrw);
    RegisterProperty('ONKEYDOWN', 'TKeyEvent', iptrw);
    RegisterProperty('ONKEYPRESS', 'TKeyPressEvent', iptrw);
    RegisterProperty('ONMOUSEDOWN', 'TMouseEvent', iptrw);
    RegisterProperty('ONMOUSEMOVE', 'TMouseMoveEvent', iptrw);
    RegisterProperty('ONMOUSEUP', 'TMouseEvent', iptrw);
    RegisterProperty('Visible', 'Boolean', iptrw);
    RegisterProperty('Font', 'TFont', iptrw);
    RegisterProperty('ENABLED', 'BOOLEAN', iptrw);
    RegisterProperty('Showhint', 'boolean', iptrw);
    RegisterProperty('BORDERSTYLE', 'TBorderStyle', iptrw);

  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TDBCtrlPanel(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TWinControl', 'TDBCtrlPanel') do
  with CL.AddClassN(CL.FindClass('TWinControl'),'TDBCtrlPanel') do
  begin
    RegisterMethod('Constructor CreateLinked( DBCtrlGrid : TDBCtrlGrid)');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TDBCtrlGridLink(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TDataLink', 'TDBCtrlGridLink') do
  with CL.AddClassN(CL.FindClass('TDataLink'),'TDBCtrlGridLink') do
  begin
    RegisterMethod('Constructor Create( DBCtrlGrid : TDBCtrlGrid)');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_DBCGrids(CL: TPSPascalCompiler);
begin
  CL.AddClassN(CL.FindClass('TOBJECT'),'TDBCtrlGrid');
  SIRegister_TDBCtrlGridLink(CL);
  SIRegister_TDBCtrlPanel(CL);
  CL.AddTypeS('TDBCtrlGridOrientation', '( goVertical, goHorizontal )');
  CL.AddTypeS('TDBCtrlGridBorder', '( gbNone, gbRaised )');
  CL.AddTypeS('TDBCtrlGridKey', '( gkNull, gkEditMode, gkPriorTab, gkNextTab, g'
   +'kLeft, gkRight, gkUp, gkDown, gkScrollUp, gkScrollDown, gkPageUp, gkPageDo'
   +'wn, gkHome, gkEnd, gkInsert, gkAppend, gkDelete, gkCancel )');
  CL.AddTypeS('TPaintPanelEvent', 'Procedure ( DBCtrlGrid : TDBCtrlGrid; Index: Integer)');
  SIRegister_TDBCtrlGrid(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TDBCtrlGridOnPaintPanel_W(Self: TDBCtrlGrid; const T: TPaintPanelEvent);
begin Self.OnPaintPanel := T; end;

(*----------------------------------------------------------------------------*)
procedure TDBCtrlGridOnPaintPanel_R(Self: TDBCtrlGrid; var T: TPaintPanelEvent);
begin T := Self.OnPaintPanel; end;

(*----------------------------------------------------------------------------*)
procedure TDBCtrlGridShowFocus_W(Self: TDBCtrlGrid; const T: Boolean);
begin Self.ShowFocus := T; end;

(*----------------------------------------------------------------------------*)
procedure TDBCtrlGridShowFocus_R(Self: TDBCtrlGrid; var T: Boolean);
begin T := Self.ShowFocus; end;

(*----------------------------------------------------------------------------*)
procedure TDBCtrlGridSelectedColor_W(Self: TDBCtrlGrid; const T: TColor);
begin Self.SelectedColor := T; end;

(*----------------------------------------------------------------------------*)
procedure TDBCtrlGridSelectedColor_R(Self: TDBCtrlGrid; var T: TColor);
begin T := Self.SelectedColor; end;

(*----------------------------------------------------------------------------*)
procedure TDBCtrlGridRowCount_W(Self: TDBCtrlGrid; const T: Integer);
begin Self.RowCount := T; end;

(*----------------------------------------------------------------------------*)
procedure TDBCtrlGridRowCount_R(Self: TDBCtrlGrid; var T: Integer);
begin T := Self.RowCount; end;

(*----------------------------------------------------------------------------*)
procedure TDBCtrlGridPanelWidth_W(Self: TDBCtrlGrid; const T: Integer);
begin Self.PanelWidth := T; end;

(*----------------------------------------------------------------------------*)
procedure TDBCtrlGridPanelWidth_R(Self: TDBCtrlGrid; var T: Integer);
begin T := Self.PanelWidth; end;

(*----------------------------------------------------------------------------*)
procedure TDBCtrlGridPanelHeight_W(Self: TDBCtrlGrid; const T: Integer);
begin Self.PanelHeight := T; end;

(*----------------------------------------------------------------------------*)
procedure TDBCtrlGridPanelHeight_R(Self: TDBCtrlGrid; var T: Integer);
begin T := Self.PanelHeight; end;

(*----------------------------------------------------------------------------*)
procedure TDBCtrlGridPanelBorder_W(Self: TDBCtrlGrid; const T: TDBCtrlGridBorder);
begin Self.PanelBorder := T; end;

(*----------------------------------------------------------------------------*)
procedure TDBCtrlGridPanelBorder_R(Self: TDBCtrlGrid; var T: TDBCtrlGridBorder);
begin T := Self.PanelBorder; end;

(*----------------------------------------------------------------------------*)
procedure TDBCtrlGridOrientation_W(Self: TDBCtrlGrid; const T: TDBCtrlGridOrientation);
begin Self.Orientation := T; end;

(*----------------------------------------------------------------------------*)
procedure TDBCtrlGridOrientation_R(Self: TDBCtrlGrid; var T: TDBCtrlGridOrientation);
begin T := Self.Orientation; end;

(*----------------------------------------------------------------------------*)
procedure TDBCtrlGridDataSource_W(Self: TDBCtrlGrid; const T: TDataSource);
begin Self.DataSource := T; end;

(*----------------------------------------------------------------------------*)
procedure TDBCtrlGridDataSource_R(Self: TDBCtrlGrid; var T: TDataSource);
begin T := Self.DataSource; end;

(*----------------------------------------------------------------------------*)
procedure TDBCtrlGridColCount_W(Self: TDBCtrlGrid; const T: Integer);
begin Self.ColCount := T; end;

(*----------------------------------------------------------------------------*)
procedure TDBCtrlGridColCount_R(Self: TDBCtrlGrid; var T: Integer);
begin T := Self.ColCount; end;

(*----------------------------------------------------------------------------*)
procedure TDBCtrlGridAllowInsert_W(Self: TDBCtrlGrid; const T: Boolean);
begin Self.AllowInsert := T; end;

(*----------------------------------------------------------------------------*)
procedure TDBCtrlGridAllowInsert_R(Self: TDBCtrlGrid; var T: Boolean);
begin T := Self.AllowInsert; end;

(*----------------------------------------------------------------------------*)
procedure TDBCtrlGridAllowDelete_W(Self: TDBCtrlGrid; const T: Boolean);
begin Self.AllowDelete := T; end;

(*----------------------------------------------------------------------------*)
procedure TDBCtrlGridAllowDelete_R(Self: TDBCtrlGrid; var T: Boolean);
begin T := Self.AllowDelete; end;

(*----------------------------------------------------------------------------*)
procedure TDBCtrlGridPanelIndex_W(Self: TDBCtrlGrid; const T: Integer);
begin Self.PanelIndex := T; end;

(*----------------------------------------------------------------------------*)
procedure TDBCtrlGridPanelIndex_R(Self: TDBCtrlGrid; var T: Integer);
begin T := Self.PanelIndex; end;

(*----------------------------------------------------------------------------*)
procedure TDBCtrlGridPanelCount_R(Self: TDBCtrlGrid; var T: Integer);
begin T := Self.PanelCount; end;

(*----------------------------------------------------------------------------*)
procedure TDBCtrlGridEditMode_W(Self: TDBCtrlGrid; const T: Boolean);
begin Self.EditMode := T; end;

(*----------------------------------------------------------------------------*)
procedure TDBCtrlGridEditMode_R(Self: TDBCtrlGrid; var T: Boolean);
begin T := Self.EditMode; end;

(*----------------------------------------------------------------------------*)
procedure TDBCtrlGridCanvas_R(Self: TDBCtrlGrid; var T: TCanvas);
begin T := Self.Canvas; end;


procedure TCustomDBGridVisible_W(Self: TDBCtrlGrid; const T: boolean);
begin Self.visible:= T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomDBGridVisible_R(Self: TDBCtrlGrid; var T: boolean);
begin T := Self.visible; end;

procedure TCustomDBGridEnabled_W(Self: TDBCtrlGrid; const T: boolean);
begin Self.enabled:= T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomDBGridEnabled_R(Self: TDBCtrlGrid; var T: boolean);
begin T := Self.enabled; end;

procedure TCustomDBGridshowhint_W(Self: TDBCtrlGrid; const T: boolean);
begin Self.showhint:= T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomDBGridshowhint_R(Self: TDBCtrlGrid; var T: boolean);
begin T := Self.showhint; end;


procedure TCustomDBGridBorderStyle_W(Self: TDBCtrlGrid; const T: tborderstyle);
begin //Self.borderstyle:= T;
 end;

(*----------------------------------------------------------------------------*)
procedure TCustomDBGridborderstyle_R(Self: TDBCtrlGrid; var T: tborderstyle);
begin
//T := Self.borderstyle;
end;

procedure TCustomDBGridFont_W(Self: TDBCtrlGrid; const T: TFont);
begin Self.font:= T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomDBGridfont_R(Self: TDBCtrlGrid; var T: tfont);
begin T := Self.font; end;



(*----------------------------------------------------------------------------*)
procedure RIRegister_TDBCtrlGrid(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TDBCtrlGrid) do begin
    RegisterConstructor(@TDBCtrlGrid.Create, 'Create');
    RegisterMethod(@TDBCtrlGrid.Destroy, 'Free');

    RegisterMethod(@TDBCtrlGrid.DoKey, 'DoKey');

    RegisterMethod(@TDBCtrlGrid.ExecuteAction,'ExecuteAction');
    RegisterMethod(@TDBCtrlGrid.GetTabOrderList,'GetTabOrderList');
    RegisterMethod(@TDBCtrlGrid.KeyDown,'KeyDown');
    RegisterMethod(@TDBCtrlGrid.SetBounds,'SetBounds');
    RegisterMethod(@TDBCtrlGrid.UpdateAction,'UpdateAction');

    RegisterMethod(@TDBCtrlGrid.Hide, 'Hide');
    RegisterMethod(@TDBCtrlGrid.Invalidate, 'Invalidate');
    RegisterMethod(@TDBCtrlGrid.Refresh, 'Refresh');
    RegisterMethod(@TDBCtrlGrid.Repaint, 'Repaint');
   RegisterMethod(@TDBCtrlGrid.Show, 'Show');
    RegisterMethod(@TDBCtrlGrid.Update, 'Update');


    RegisterPropertyHelper(@TDBCtrlGridCanvas_R,nil,'Canvas');
    RegisterPropertyHelper(@TDBCtrlGridEditMode_R,@TDBCtrlGridEditMode_W,'EditMode');
    RegisterPropertyHelper(@TDBCtrlGridPanelCount_R,nil,'PanelCount');
    RegisterPropertyHelper(@TDBCtrlGridPanelIndex_R,@TDBCtrlGridPanelIndex_W,'PanelIndex');
    RegisterPropertyHelper(@TDBCtrlGridAllowDelete_R,@TDBCtrlGridAllowDelete_W,'AllowDelete');
    RegisterPropertyHelper(@TDBCtrlGridAllowInsert_R,@TDBCtrlGridAllowInsert_W,'AllowInsert');
    RegisterPropertyHelper(@TDBCtrlGridColCount_R,@TDBCtrlGridColCount_W,'ColCount');
    RegisterPropertyHelper(@TDBCtrlGridDataSource_R,@TDBCtrlGridDataSource_W,'DataSource');
    RegisterPropertyHelper(@TDBCtrlGridOrientation_R,@TDBCtrlGridOrientation_W,'Orientation');
    RegisterPropertyHelper(@TDBCtrlGridPanelBorder_R,@TDBCtrlGridPanelBorder_W,'PanelBorder');
    RegisterPropertyHelper(@TDBCtrlGridPanelHeight_R,@TDBCtrlGridPanelHeight_W,'PanelHeight');
    RegisterPropertyHelper(@TDBCtrlGridPanelWidth_R,@TDBCtrlGridPanelWidth_W,'PanelWidth');
    RegisterPropertyHelper(@TDBCtrlGridRowCount_R,@TDBCtrlGridRowCount_W,'RowCount');
    RegisterPropertyHelper(@TDBCtrlGridSelectedColor_R,@TDBCtrlGridSelectedColor_W,'SelectedColor');
    RegisterPropertyHelper(@TDBCtrlGridShowFocus_R,@TDBCtrlGridShowFocus_W,'ShowFocus');
    RegisterPropertyHelper(@TDBCtrlGridOnPaintPanel_R,@TDBCtrlGridOnPaintPanel_W,'OnPaintPanel');
    //RegisterPropertyHelper(@TCustomDBGridUpdateLock_R,nil,'UpdateLock');
    {RegisterPropertyHelper(@TCustomDBGridOnColEnter_R,@TCustomDBGridOnColEnter_W,'OnColEnter');
    RegisterPropertyHelper(@TCustomDBGridOnColExit_R,@TCustomDBGridOnColExit_W,'OnColExit');
    RegisterPropertyHelper(@TCustomDBGridOnDrawDataCell_R,@TCustomDBGridOnDrawDataCell_W,'OnDrawDataCell');
    RegisterPropertyHelper(@TCustomDBGridOnDrawColumnCell_R,@TCustomDBGridOnDrawColumnCell_W,'OnDrawColumnCell');
    RegisterPropertyHelper(@TCustomDBGridOnEditButtonClick_R,@TCustomDBGridOnEditButtonClick_W,'OnEditButtonClick');
    RegisterPropertyHelper(@TCustomDBGridOnColumnMoved_R,@TCustomDBGridOnColumnMoved_W,'OnColumnMoved');
    RegisterPropertyHelper(@TCustomDBGridOnCellClick_R,@TCustomDBGridOnCellClick_W,'OnCellClick');
    RegisterPropertyHelper(@TCustomDBGridOnTitleClick_R,@TCustomDBGridOnTitleClick_W,'OnTitleClick');
    RegisterPropertyHelper(@TCustomDBGridShowing_R,NIL, 'Showing');}

    RegisterPropertyHelper(@TCustomDBGridvisible_R,@TCustomDBGridvisible_W,'visible');
    RegisterPropertyHelper(@TCustomDBGridfont_R,@TCustomDBGridfont_W,'font');
    RegisterPropertyHelper(@TCustomDBGridenabled_R,@TCustomDBGridenabled_W,'enabled');
    RegisterPropertyHelper(@TCustomDBGridshowhint_R,@TCustomDBGridshowhint_W,'showhint');
    RegisterPropertyHelper(@TCustomDBGridborderstyle_R,@TCustomDBGridborderstyle_W,'borderstyle');


  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TDBCtrlPanel(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TDBCtrlPanel) do
  begin
    RegisterConstructor(@TDBCtrlPanel.CreateLinked, 'CreateLinked');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TDBCtrlGridLink(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TDBCtrlGridLink) do
  begin
    RegisterConstructor(@TDBCtrlGridLink.Create, 'Create');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_DBCGrids(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TDBCtrlGrid) do
  RIRegister_TDBCtrlGridLink(CL);
  RIRegister_TDBCtrlPanel(CL);
  RIRegister_TDBCtrlGrid(CL);
end;

 
 
{ TPSImport_DBCGrids }
(*----------------------------------------------------------------------------*)
procedure TPSImport_DBCGrids.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_DBCGrids(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_DBCGrids.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_DBCGrids(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
