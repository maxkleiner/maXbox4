unit uPSI_JvComCtrls;
{
  a second back to comctrls
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
  TPSImport_JvComCtrls = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TJvTreeView(CL: TPSPascalCompiler);
procedure SIRegister_TJvTreeNode(CL: TPSPascalCompiler);
procedure SIRegister_TJvTrackBar(CL: TPSPascalCompiler);
procedure SIRegister_TJvPageControl(CL: TPSPascalCompiler);
procedure SIRegister_TJvIpAddress(CL: TPSPascalCompiler);
procedure SIRegister_TJvIpAddressValues(CL: TPSPascalCompiler);
procedure SIRegister_TJvIpAddressRange(CL: TPSPascalCompiler);
procedure SIRegister_JvComCtrls(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TJvTreeView(CL: TPSRuntimeClassImporter);
procedure RIRegister_TJvTreeNode(CL: TPSRuntimeClassImporter);
procedure RIRegister_TJvTrackBar(CL: TPSRuntimeClassImporter);
procedure RIRegister_TJvPageControl(CL: TPSRuntimeClassImporter);
procedure RIRegister_TJvIpAddress(CL: TPSRuntimeClassImporter);
procedure RIRegister_TJvIpAddressValues(CL: TPSRuntimeClassImporter);
procedure RIRegister_TJvIpAddressRange(CL: TPSRuntimeClassImporter);
procedure RIRegister_JvComCtrls(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   Windows
  ,Messages
  ,Graphics
  ,Controls
  ,Forms
  ,Dialogs
  ,Menus
  ,ComCtrls
  ,CommCtrl
  ,StdActns
  ,Contnrs
  ,JclBase
  ,JVCLVer
  ,JvComCtrls
  ;
 

procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_JvComCtrls]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TJvTreeView(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TTreeView', 'TJvTreeView') do
  with CL.AddClassN(CL.FindClass('TTreeView'),'TJvTreeView') do begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
    RegisterMethod('Procedure Free');
    RegisterMethod('Procedure ClearSelection');
    RegisterMethod('Function IsNodeSelected( Node : TTreeNode) : Boolean');
    RegisterMethod('Procedure InvalidateNodeIcon( Node : TTreeNode)');
    RegisterMethod('Procedure InvalidateSelectedItems');
    RegisterMethod('Procedure SelectItem( Node : TTreeNode; Unselect : Boolean)');
    RegisterProperty('SelectedItems', 'TTreeNode Integer', iptr);
    RegisterProperty('SelectedCount', 'Integer', iptr);
    RegisterMethod('Function GetBold( Node : TTreeNode) : Boolean');
    RegisterMethod('Procedure SetBold( Node : TTreeNode; Value : Boolean)');
    RegisterMethod('Function GetChecked( Node : TTreenode) : Boolean');
    RegisterMethod('Procedure SetChecked( Node : TTreenode; Value : Boolean)');
    RegisterMethod('Procedure SetNodePopup( Node : TTreeNode; Value : TPopupMenu)');
    RegisterMethod('Function GetNodePopup( Node : TTreeNode) : TPopupMenu');
    RegisterProperty('HintColor', 'TColor', iptrw);
    RegisterProperty('Checkboxes', 'Boolean', iptrw);
    RegisterProperty('OnVerticalScroll', 'TNotifyEvent', iptrw);
    RegisterProperty('OnHorizontalScroll', 'TNotifyEvent', iptrw);
    RegisterProperty('PageControl', 'TPageControl', iptrw);
    RegisterProperty('OnPageChanged', 'TPageChangedEvent', iptrw);
    RegisterProperty('AboutJVCL', 'TJVCLAboutInfo', iptrw);
    RegisterProperty('AutoDragScroll', 'Boolean', iptrw);
    RegisterProperty('MultiSelect', 'Boolean', iptrw);
    RegisterProperty('OnMouseEnter', 'TNotifyEvent', iptrw);
    RegisterProperty('OnMouseLeave', 'TNotifyEvent', iptrw);
    RegisterProperty('OnParentColorChange', 'TNotifyEvent', iptrw);
    RegisterProperty('OnCtl3DChanged', 'TNotifyEvent', iptrw);
    RegisterProperty('OnCustomDrawItem', 'TTVCustomDrawItemEvent', iptrw);
    RegisterProperty('OnEditCancelled', 'TNotifyEvent', iptrw);
    RegisterProperty('OnSelectionChange', 'TNotifyEvent', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TJvTreeNode(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TTreeNode', 'TJvTreeNode') do
  with CL.AddClassN(CL.FindClass('TTreeNode'),'TJvTreeNode') do begin
    RegisterMethod('Constructor CreateEnh( AOwner : TTreeNodes)');
    RegisterProperty('Checked', 'Boolean', iptrw);
    RegisterProperty('Bold', 'Boolean', iptrw);
    RegisterProperty('PopupMenu', 'TPopupMenu', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TJvTrackBar(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TTrackBar', 'TJvTrackBar') do
  with CL.AddClassN(CL.FindClass('TTrackBar'),'TJvTrackBar') do begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
    RegisterProperty('AboutJVCL', 'TJVCLAboutInfo', iptrw);
    RegisterProperty('ShowRange', 'Boolean', iptrw);
    RegisterProperty('ToolTips', 'Boolean', iptrw);
    RegisterProperty('ToolTipSide', 'TJvTrackToolTipSide', iptrw);
    RegisterProperty('HintColor', 'TColor', iptrw);
    RegisterProperty('OnMouseEnter', 'TNotifyEvent', iptrw);
    RegisterProperty('OnMouseLeave', 'TNotifyEvent', iptrw);
    RegisterProperty('OnCtl3DChanged', 'TNotifyEvent', iptrw);
    RegisterProperty('OnParentColorChange', 'TNotifyEvent', iptrw);
    RegisterProperty('OnChanged', 'TNotifyEvent', iptrw);
    RegisterProperty('OnToolTip', 'TJvTrackToolTipEvent', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TJvPageControl(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TPageControl', 'TJvPageControl') do
  with CL.AddClassN(CL.FindClass('TPageControl'),'TJvPageControl') do begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
    RegisterMethod('Procedure UpdateTabImages');
    RegisterProperty('AboutJVCL', 'TJVCLAboutInfo', iptrw);
    RegisterProperty('HandleGlobalTab', 'Boolean', iptrw);
    RegisterProperty('ClientBorderWidth', 'TBorderWidth', iptrw);
    RegisterProperty('DrawTabShadow', 'Boolean', iptrw);
    RegisterProperty('HideAllTabs', 'Boolean', iptrw);
    RegisterProperty('HintColor', 'TColor', iptrw);
    RegisterProperty('OnMouseEnter', 'TNotifyEvent', iptrw);
    RegisterProperty('OnMouseLeave', 'TNotifyEvent', iptrw);
    RegisterProperty('OnParentColorChange', 'TNotifyEvent', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TJvIpAddress(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TWinControl', 'TJvIpAddress') do
  with CL.AddClassN(CL.FindClass('TWinControl'),'TJvIpAddress') do begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
    RegisterMethod('Procedure Free');
    RegisterMethod('Procedure ClearAddress');
    RegisterMethod('Function IsBlank : Boolean');
    RegisterProperty('AboutJVCL', 'TJVCLAboutInfo', iptrw);
    RegisterProperty('Address', 'LongWord', iptrw);
    RegisterProperty('AddressValues', 'TJvIpAddressValues', iptrw);
    RegisterProperty('Range', 'TJvIpAddressRange', iptrw);
    RegisterProperty('OnChange', 'TNotifyEvent', iptrw);
    RegisterProperty('OnFieldChange', 'TJvIpAddrFieldChangeEvent', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TJvIpAddressValues(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TPersistent', 'TJvIpAddressValues') do
  with CL.AddClassN(CL.FindClass('TPersistent'),'TJvIpAddressValues') do begin
    RegisterProperty('OnChange', 'TNotifyEvent', iptrw);
    RegisterProperty('OnChanging', 'TJvIPAddressChanging', iptrw);
    RegisterProperty('Address', 'Cardinal', iptrw);
    RegisterProperty('Value1', 'Byte', iptrw);
    RegisterProperty('Value2', 'Byte', iptrw);
    RegisterProperty('Value3', 'Byte', iptrw);
    RegisterProperty('Value4', 'Byte', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TJvIpAddressRange(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TPersistent', 'TJvIpAddressRange') do
  with CL.AddClassN(CL.FindClass('TPersistent'),'TJvIpAddressRange') do begin
    RegisterMethod('Constructor Create( Control : TWinControl)');
    RegisterProperty('Field1Min', 'Byte', iptrw);
    RegisterProperty('Field1Max', 'Byte', iptrw);
    RegisterProperty('Field2Min', 'Byte', iptrw);
    RegisterProperty('Field2Max', 'Byte', iptrw);
    RegisterProperty('Field3Min', 'Byte', iptrw);
    RegisterProperty('Field3Max', 'Byte', iptrw);
    RegisterProperty('Field4Min', 'Byte', iptrw);
    RegisterProperty('Field4Max', 'Byte', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_JvComCtrls(CL: TPSPascalCompiler);
begin
 CL.AddConstantN('JvDefPageControlBorder','LongInt').SetInt( 4);
  CL.AddClassN(CL.FindClass('TOBJECT'),'TJvIpAddress');
  CL.AddTypeS('TJvIpAddressMinMax', 'record Min : Byte; Max : Byte; end');
  SIRegister_TJvIpAddressRange(CL);
  CL.AddTypeS('TJvIpAddrFieldChangeEvent', 'Procedure ( Sender : TJvIpAddress; '
   +'FieldIndex : Integer; FieldRange : TJvIpAddressMinMax; var Value : Integer)');
  CL.AddTypeS('TJvIPAddressChanging', 'Procedure ( Sender : TObject; Index : Integer; Value : Byte; var AllowChange : Boolean)');
  SIRegister_TJvIpAddressValues(CL);
  SIRegister_TJvIpAddress(CL);
  SIRegister_TJvPageControl(CL);
  CL.AddTypeS('TJvTrackToolTipSide', '( tsLeft, tsTop, tsRight, tsBottom )');
  CL.AddTypeS('TJvTrackToolTipEvent', 'Procedure (Sender: TObject; var ToolTipText: string)');
  SIRegister_TJvTrackBar(CL);
  SIRegister_TJvTreeNode(CL);
  //CL.AddTypeS('TPageChangedEvent', 'Procedure ( Sender : TObject; Item : TTreeN'
  // +'ode; Page : TTabSheet)');
  SIRegister_TJvTreeView(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TJvTreeViewOnSelectionChange_W(Self: TJvTreeView; const T: TNotifyEvent);
begin Self.OnSelectionChange := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvTreeViewOnSelectionChange_R(Self: TJvTreeView; var T: TNotifyEvent);
begin T := Self.OnSelectionChange; end;

(*----------------------------------------------------------------------------*)
procedure TJvTreeViewOnEditCancelled_W(Self: TJvTreeView; const T: TNotifyEvent);
begin Self.OnEditCancelled := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvTreeViewOnEditCancelled_R(Self: TJvTreeView; var T: TNotifyEvent);
begin T := Self.OnEditCancelled; end;

(*----------------------------------------------------------------------------*)
procedure TJvTreeViewOnCustomDrawItem_W(Self: TJvTreeView; const T: TTVCustomDrawItemEvent);
begin Self.OnCustomDrawItem := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvTreeViewOnCustomDrawItem_R(Self: TJvTreeView; var T: TTVCustomDrawItemEvent);
begin T := Self.OnCustomDrawItem; end;

(*----------------------------------------------------------------------------*)
procedure TJvTreeViewOnCtl3DChanged_W(Self: TJvTreeView; const T: TNotifyEvent);
begin Self.OnCtl3DChanged := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvTreeViewOnCtl3DChanged_R(Self: TJvTreeView; var T: TNotifyEvent);
begin T := Self.OnCtl3DChanged; end;

(*----------------------------------------------------------------------------*)
procedure TJvTreeViewOnParentColorChange_W(Self: TJvTreeView; const T: TNotifyEvent);
begin Self.OnParentColorChange := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvTreeViewOnParentColorChange_R(Self: TJvTreeView; var T: TNotifyEvent);
begin T := Self.OnParentColorChange; end;

(*----------------------------------------------------------------------------*)
procedure TJvTreeViewOnMouseLeave_W(Self: TJvTreeView; const T: TNotifyEvent);
begin Self.OnMouseLeave := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvTreeViewOnMouseLeave_R(Self: TJvTreeView; var T: TNotifyEvent);
begin T := Self.OnMouseLeave; end;

(*----------------------------------------------------------------------------*)
procedure TJvTreeViewOnMouseEnter_W(Self: TJvTreeView; const T: TNotifyEvent);
begin Self.OnMouseEnter := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvTreeViewOnMouseEnter_R(Self: TJvTreeView; var T: TNotifyEvent);
begin T := Self.OnMouseEnter; end;

(*----------------------------------------------------------------------------*)
procedure TJvTreeViewMultiSelect_W(Self: TJvTreeView; const T: Boolean);
begin Self.MultiSelect := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvTreeViewMultiSelect_R(Self: TJvTreeView; var T: Boolean);
begin T := Self.MultiSelect; end;

(*----------------------------------------------------------------------------*)
procedure TJvTreeViewAutoDragScroll_W(Self: TJvTreeView; const T: Boolean);
begin Self.AutoDragScroll := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvTreeViewAutoDragScroll_R(Self: TJvTreeView; var T: Boolean);
begin T := Self.AutoDragScroll; end;

(*----------------------------------------------------------------------------*)
procedure TJvTreeViewAboutJVCL_W(Self: TJvTreeView; const T: TJVCLAboutInfo);
begin Self.AboutJVCL := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvTreeViewAboutJVCL_R(Self: TJvTreeView; var T: TJVCLAboutInfo);
begin T := Self.AboutJVCL; end;

(*----------------------------------------------------------------------------*)
procedure TJvTreeViewOnPageChanged_W(Self: TJvTreeView; const T: TPageChangedEvent);
begin Self.OnPageChanged := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvTreeViewOnPageChanged_R(Self: TJvTreeView; var T: TPageChangedEvent);
begin T := Self.OnPageChanged; end;

(*----------------------------------------------------------------------------*)
procedure TJvTreeViewPageControl_W(Self: TJvTreeView; const T: TPageControl);
begin Self.PageControl := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvTreeViewPageControl_R(Self: TJvTreeView; var T: TPageControl);
begin T := Self.PageControl; end;

(*----------------------------------------------------------------------------*)
procedure TJvTreeViewOnHorizontalScroll_W(Self: TJvTreeView; const T: TNotifyEvent);
begin Self.OnHorizontalScroll := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvTreeViewOnHorizontalScroll_R(Self: TJvTreeView; var T: TNotifyEvent);
begin T := Self.OnHorizontalScroll; end;

(*----------------------------------------------------------------------------*)
procedure TJvTreeViewOnVerticalScroll_W(Self: TJvTreeView; const T: TNotifyEvent);
begin Self.OnVerticalScroll := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvTreeViewOnVerticalScroll_R(Self: TJvTreeView; var T: TNotifyEvent);
begin T := Self.OnVerticalScroll; end;

(*----------------------------------------------------------------------------*)
procedure TJvTreeViewCheckboxes_W(Self: TJvTreeView; const T: Boolean);
begin Self.Checkboxes := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvTreeViewCheckboxes_R(Self: TJvTreeView; var T: Boolean);
begin T := Self.Checkboxes; end;

(*----------------------------------------------------------------------------*)
procedure TJvTreeViewHintColor_W(Self: TJvTreeView; const T: TColor);
begin Self.HintColor := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvTreeViewHintColor_R(Self: TJvTreeView; var T: TColor);
begin T := Self.HintColor; end;

(*----------------------------------------------------------------------------*)
procedure TJvTreeViewSelectedCount_R(Self: TJvTreeView; var T: Integer);
begin T := Self.SelectedCount; end;

(*----------------------------------------------------------------------------*)
procedure TJvTreeViewSelectedItems_R(Self: TJvTreeView; var T: TTreeNode; const t1: Integer);
begin T := Self.SelectedItems[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TJvTreeNodePopupMenu_W(Self: TJvTreeNode; const T: TPopupMenu);
begin Self.PopupMenu := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvTreeNodePopupMenu_R(Self: TJvTreeNode; var T: TPopupMenu);
begin T := Self.PopupMenu; end;

(*----------------------------------------------------------------------------*)
procedure TJvTreeNodeBold_W(Self: TJvTreeNode; const T: Boolean);
begin Self.Bold := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvTreeNodeBold_R(Self: TJvTreeNode; var T: Boolean);
begin T := Self.Bold; end;

(*----------------------------------------------------------------------------*)
procedure TJvTreeNodeChecked_W(Self: TJvTreeNode; const T: Boolean);
begin Self.Checked := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvTreeNodeChecked_R(Self: TJvTreeNode; var T: Boolean);
begin T := Self.Checked; end;

(*----------------------------------------------------------------------------*)
procedure TJvTrackBarOnToolTip_W(Self: TJvTrackBar; const T: TJvTrackToolTipEvent);
begin Self.OnToolTip := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvTrackBarOnToolTip_R(Self: TJvTrackBar; var T: TJvTrackToolTipEvent);
begin T := Self.OnToolTip; end;

(*----------------------------------------------------------------------------*)
procedure TJvTrackBarOnChanged_W(Self: TJvTrackBar; const T: TNotifyEvent);
begin Self.OnChanged := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvTrackBarOnChanged_R(Self: TJvTrackBar; var T: TNotifyEvent);
begin T := Self.OnChanged; end;

(*----------------------------------------------------------------------------*)
procedure TJvTrackBarOnParentColorChange_W(Self: TJvTrackBar; const T: TNotifyEvent);
begin Self.OnParentColorChange := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvTrackBarOnParentColorChange_R(Self: TJvTrackBar; var T: TNotifyEvent);
begin T := Self.OnParentColorChange; end;

(*----------------------------------------------------------------------------*)
procedure TJvTrackBarOnCtl3DChanged_W(Self: TJvTrackBar; const T: TNotifyEvent);
begin Self.OnCtl3DChanged := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvTrackBarOnCtl3DChanged_R(Self: TJvTrackBar; var T: TNotifyEvent);
begin T := Self.OnCtl3DChanged; end;

(*----------------------------------------------------------------------------*)
procedure TJvTrackBarOnMouseLeave_W(Self: TJvTrackBar; const T: TNotifyEvent);
begin Self.OnMouseLeave := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvTrackBarOnMouseLeave_R(Self: TJvTrackBar; var T: TNotifyEvent);
begin T := Self.OnMouseLeave; end;

(*----------------------------------------------------------------------------*)
procedure TJvTrackBarOnMouseEnter_W(Self: TJvTrackBar; const T: TNotifyEvent);
begin Self.OnMouseEnter := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvTrackBarOnMouseEnter_R(Self: TJvTrackBar; var T: TNotifyEvent);
begin T := Self.OnMouseEnter; end;

(*----------------------------------------------------------------------------*)
procedure TJvTrackBarHintColor_W(Self: TJvTrackBar; const T: TColor);
begin Self.HintColor := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvTrackBarHintColor_R(Self: TJvTrackBar; var T: TColor);
begin T := Self.HintColor; end;

(*----------------------------------------------------------------------------*)
procedure TJvTrackBarToolTipSide_W(Self: TJvTrackBar; const T: TJvTrackToolTipSide);
begin Self.ToolTipSide := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvTrackBarToolTipSide_R(Self: TJvTrackBar; var T: TJvTrackToolTipSide);
begin T := Self.ToolTipSide; end;

(*----------------------------------------------------------------------------*)
procedure TJvTrackBarToolTips_W(Self: TJvTrackBar; const T: Boolean);
begin Self.ToolTips := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvTrackBarToolTips_R(Self: TJvTrackBar; var T: Boolean);
begin T := Self.ToolTips; end;

(*----------------------------------------------------------------------------*)
procedure TJvTrackBarShowRange_W(Self: TJvTrackBar; const T: Boolean);
begin Self.ShowRange := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvTrackBarShowRange_R(Self: TJvTrackBar; var T: Boolean);
begin T := Self.ShowRange; end;

(*----------------------------------------------------------------------------*)
procedure TJvTrackBarAboutJVCL_W(Self: TJvTrackBar; const T: TJVCLAboutInfo);
begin Self.AboutJVCL := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvTrackBarAboutJVCL_R(Self: TJvTrackBar; var T: TJVCLAboutInfo);
begin T := Self.AboutJVCL; end;

(*----------------------------------------------------------------------------*)
procedure TJvPageControlOnParentColorChange_W(Self: TJvPageControl; const T: TNotifyEvent);
begin Self.OnParentColorChange := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvPageControlOnParentColorChange_R(Self: TJvPageControl; var T: TNotifyEvent);
begin T := Self.OnParentColorChange; end;

(*----------------------------------------------------------------------------*)
procedure TJvPageControlOnMouseLeave_W(Self: TJvPageControl; const T: TNotifyEvent);
begin Self.OnMouseLeave := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvPageControlOnMouseLeave_R(Self: TJvPageControl; var T: TNotifyEvent);
begin T := Self.OnMouseLeave; end;

(*----------------------------------------------------------------------------*)
procedure TJvPageControlOnMouseEnter_W(Self: TJvPageControl; const T: TNotifyEvent);
begin Self.OnMouseEnter := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvPageControlOnMouseEnter_R(Self: TJvPageControl; var T: TNotifyEvent);
begin T := Self.OnMouseEnter; end;

(*----------------------------------------------------------------------------*)
procedure TJvPageControlHintColor_W(Self: TJvPageControl; const T: TColor);
begin Self.HintColor := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvPageControlHintColor_R(Self: TJvPageControl; var T: TColor);
begin T := Self.HintColor; end;

(*----------------------------------------------------------------------------*)
procedure TJvPageControlHideAllTabs_W(Self: TJvPageControl; const T: Boolean);
begin Self.HideAllTabs := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvPageControlHideAllTabs_R(Self: TJvPageControl; var T: Boolean);
begin T := Self.HideAllTabs; end;

(*----------------------------------------------------------------------------*)
procedure TJvPageControlDrawTabShadow_W(Self: TJvPageControl; const T: Boolean);
begin Self.DrawTabShadow := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvPageControlDrawTabShadow_R(Self: TJvPageControl; var T: Boolean);
begin T := Self.DrawTabShadow; end;

(*----------------------------------------------------------------------------*)
procedure TJvPageControlClientBorderWidth_W(Self: TJvPageControl; const T: TBorderWidth);
begin Self.ClientBorderWidth := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvPageControlClientBorderWidth_R(Self: TJvPageControl; var T: TBorderWidth);
begin T := Self.ClientBorderWidth; end;

(*----------------------------------------------------------------------------*)
procedure TJvPageControlHandleGlobalTab_W(Self: TJvPageControl; const T: Boolean);
begin Self.HandleGlobalTab := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvPageControlHandleGlobalTab_R(Self: TJvPageControl; var T: Boolean);
begin T := Self.HandleGlobalTab; end;

(*----------------------------------------------------------------------------*)
procedure TJvPageControlAboutJVCL_W(Self: TJvPageControl; const T: TJVCLAboutInfo);
begin Self.AboutJVCL := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvPageControlAboutJVCL_R(Self: TJvPageControl; var T: TJVCLAboutInfo);
begin T := Self.AboutJVCL; end;

(*----------------------------------------------------------------------------*)
procedure TJvIpAddressOnFieldChange_W(Self: TJvIpAddress; const T: TJvIpAddrFieldChangeEvent);
begin Self.OnFieldChange := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvIpAddressOnFieldChange_R(Self: TJvIpAddress; var T: TJvIpAddrFieldChangeEvent);
begin T := Self.OnFieldChange; end;

(*----------------------------------------------------------------------------*)
procedure TJvIpAddressOnChange_W(Self: TJvIpAddress; const T: TNotifyEvent);
begin Self.OnChange := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvIpAddressOnChange_R(Self: TJvIpAddress; var T: TNotifyEvent);
begin T := Self.OnChange; end;

(*----------------------------------------------------------------------------*)
procedure TJvIpAddressRange_W(Self: TJvIpAddress; const T: TJvIpAddressRange);
begin Self.Range := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvIpAddressRange_R(Self: TJvIpAddress; var T: TJvIpAddressRange);
begin T := Self.Range; end;

(*----------------------------------------------------------------------------*)
procedure TJvIpAddressAddressValues_W(Self: TJvIpAddress; const T: TJvIpAddressValues);
begin Self.AddressValues := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvIpAddressAddressValues_R(Self: TJvIpAddress; var T: TJvIpAddressValues);
begin T := Self.AddressValues; end;

(*----------------------------------------------------------------------------*)
procedure TJvIpAddressAddress_W(Self: TJvIpAddress; const T: LongWord);
begin Self.Address := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvIpAddressAddress_R(Self: TJvIpAddress; var T: LongWord);
begin T := Self.Address; end;

(*----------------------------------------------------------------------------*)
procedure TJvIpAddressAboutJVCL_W(Self: TJvIpAddress; const T: TJVCLAboutInfo);
begin Self.AboutJVCL := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvIpAddressAboutJVCL_R(Self: TJvIpAddress; var T: TJVCLAboutInfo);
begin T := Self.AboutJVCL; end;

(*----------------------------------------------------------------------------*)
procedure TJvIpAddressValuesValue4_W(Self: TJvIpAddressValues; const T: Byte);
begin Self.Value4 := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvIpAddressValuesValue4_R(Self: TJvIpAddressValues; var T: Byte);
begin T := Self.Value4; end;

(*----------------------------------------------------------------------------*)
procedure TJvIpAddressValuesValue3_W(Self: TJvIpAddressValues; const T: Byte);
begin Self.Value3 := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvIpAddressValuesValue3_R(Self: TJvIpAddressValues; var T: Byte);
begin T := Self.Value3; end;

(*----------------------------------------------------------------------------*)
procedure TJvIpAddressValuesValue2_W(Self: TJvIpAddressValues; const T: Byte);
begin Self.Value2 := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvIpAddressValuesValue2_R(Self: TJvIpAddressValues; var T: Byte);
begin T := Self.Value2; end;

(*----------------------------------------------------------------------------*)
procedure TJvIpAddressValuesValue1_W(Self: TJvIpAddressValues; const T: Byte);
begin Self.Value1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvIpAddressValuesValue1_R(Self: TJvIpAddressValues; var T: Byte);
begin T := Self.Value1; end;

(*----------------------------------------------------------------------------*)
procedure TJvIpAddressValuesAddress_W(Self: TJvIpAddressValues; const T: Cardinal);
begin Self.Address := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvIpAddressValuesAddress_R(Self: TJvIpAddressValues; var T: Cardinal);
begin T := Self.Address; end;

(*----------------------------------------------------------------------------*)
procedure TJvIpAddressValuesOnChanging_W(Self: TJvIpAddressValues; const T: TJvIPAddressChanging);
begin Self.OnChanging := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvIpAddressValuesOnChanging_R(Self: TJvIpAddressValues; var T: TJvIPAddressChanging);
begin T := Self.OnChanging; end;

(*----------------------------------------------------------------------------*)
procedure TJvIpAddressValuesOnChange_W(Self: TJvIpAddressValues; const T: TNotifyEvent);
begin Self.OnChange := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvIpAddressValuesOnChange_R(Self: TJvIpAddressValues; var T: TNotifyEvent);
begin T := Self.OnChange; end;

(*----------------------------------------------------------------------------*)
procedure TJvIpAddressRangeField4Max_W(Self: TJvIpAddressRange; const T: Byte);
begin Self.Field4Max := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvIpAddressRangeField4Max_R(Self: TJvIpAddressRange; var T: Byte);
begin T := Self.Field4Max; end;

(*----------------------------------------------------------------------------*)
procedure TJvIpAddressRangeField4Min_W(Self: TJvIpAddressRange; const T: Byte);
begin Self.Field4Min := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvIpAddressRangeField4Min_R(Self: TJvIpAddressRange; var T: Byte);
begin T := Self.Field4Min; end;

(*----------------------------------------------------------------------------*)
procedure TJvIpAddressRangeField3Max_W(Self: TJvIpAddressRange; const T: Byte);
begin Self.Field3Max := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvIpAddressRangeField3Max_R(Self: TJvIpAddressRange; var T: Byte);
begin T := Self.Field3Max; end;

(*----------------------------------------------------------------------------*)
procedure TJvIpAddressRangeField3Min_W(Self: TJvIpAddressRange; const T: Byte);
begin Self.Field3Min := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvIpAddressRangeField3Min_R(Self: TJvIpAddressRange; var T: Byte);
begin T := Self.Field3Min; end;

(*----------------------------------------------------------------------------*)
procedure TJvIpAddressRangeField2Max_W(Self: TJvIpAddressRange; const T: Byte);
begin Self.Field2Max := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvIpAddressRangeField2Max_R(Self: TJvIpAddressRange; var T: Byte);
begin T := Self.Field2Max; end;

(*----------------------------------------------------------------------------*)
procedure TJvIpAddressRangeField2Min_W(Self: TJvIpAddressRange; const T: Byte);
begin Self.Field2Min := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvIpAddressRangeField2Min_R(Self: TJvIpAddressRange; var T: Byte);
begin T := Self.Field2Min; end;

(*----------------------------------------------------------------------------*)
procedure TJvIpAddressRangeField1Max_W(Self: TJvIpAddressRange; const T: Byte);
begin Self.Field1Max := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvIpAddressRangeField1Max_R(Self: TJvIpAddressRange; var T: Byte);
begin T := Self.Field1Max; end;

(*----------------------------------------------------------------------------*)
procedure TJvIpAddressRangeField1Min_W(Self: TJvIpAddressRange; const T: Byte);
begin Self.Field1Min := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvIpAddressRangeField1Min_R(Self: TJvIpAddressRange; var T: Byte);
begin T := Self.Field1Min; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJvTreeView(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJvTreeView) do begin
    RegisterConstructor(@TJvTreeView.Create, 'Create');
     RegisterMethod(@TJvTreeView.Destroy, 'Free');
     RegisterMethod(@TJvTreeView.ClearSelection, 'ClearSelection');
    RegisterMethod(@TJvTreeView.IsNodeSelected, 'IsNodeSelected');
    RegisterMethod(@TJvTreeView.InvalidateNodeIcon, 'InvalidateNodeIcon');
    RegisterMethod(@TJvTreeView.InvalidateSelectedItems, 'InvalidateSelectedItems');
    RegisterMethod(@TJvTreeView.SelectItem, 'SelectItem');
    RegisterPropertyHelper(@TJvTreeViewSelectedItems_R,nil,'SelectedItems');
    RegisterPropertyHelper(@TJvTreeViewSelectedCount_R,nil,'SelectedCount');
    RegisterMethod(@TJvTreeView.GetBold, 'GetBold');
    RegisterMethod(@TJvTreeView.SetBold, 'SetBold');
    RegisterMethod(@TJvTreeView.GetChecked, 'GetChecked');
    RegisterMethod(@TJvTreeView.SetChecked, 'SetChecked');
    RegisterMethod(@TJvTreeView.SetNodePopup, 'SetNodePopup');
    RegisterMethod(@TJvTreeView.GetNodePopup, 'GetNodePopup');
    RegisterPropertyHelper(@TJvTreeViewHintColor_R,@TJvTreeViewHintColor_W,'HintColor');
    RegisterPropertyHelper(@TJvTreeViewCheckboxes_R,@TJvTreeViewCheckboxes_W,'Checkboxes');
    RegisterPropertyHelper(@TJvTreeViewOnVerticalScroll_R,@TJvTreeViewOnVerticalScroll_W,'OnVerticalScroll');
    RegisterPropertyHelper(@TJvTreeViewOnHorizontalScroll_R,@TJvTreeViewOnHorizontalScroll_W,'OnHorizontalScroll');
    RegisterPropertyHelper(@TJvTreeViewPageControl_R,@TJvTreeViewPageControl_W,'PageControl');
    RegisterPropertyHelper(@TJvTreeViewOnPageChanged_R,@TJvTreeViewOnPageChanged_W,'OnPageChanged');
    RegisterPropertyHelper(@TJvTreeViewAboutJVCL_R,@TJvTreeViewAboutJVCL_W,'AboutJVCL');
    RegisterPropertyHelper(@TJvTreeViewAutoDragScroll_R,@TJvTreeViewAutoDragScroll_W,'AutoDragScroll');
    RegisterPropertyHelper(@TJvTreeViewMultiSelect_R,@TJvTreeViewMultiSelect_W,'MultiSelect');
    RegisterPropertyHelper(@TJvTreeViewOnMouseEnter_R,@TJvTreeViewOnMouseEnter_W,'OnMouseEnter');
    RegisterPropertyHelper(@TJvTreeViewOnMouseLeave_R,@TJvTreeViewOnMouseLeave_W,'OnMouseLeave');
    RegisterPropertyHelper(@TJvTreeViewOnParentColorChange_R,@TJvTreeViewOnParentColorChange_W,'OnParentColorChange');
    RegisterPropertyHelper(@TJvTreeViewOnCtl3DChanged_R,@TJvTreeViewOnCtl3DChanged_W,'OnCtl3DChanged');
    RegisterPropertyHelper(@TJvTreeViewOnCustomDrawItem_R,@TJvTreeViewOnCustomDrawItem_W,'OnCustomDrawItem');
    RegisterPropertyHelper(@TJvTreeViewOnEditCancelled_R,@TJvTreeViewOnEditCancelled_W,'OnEditCancelled');
    RegisterPropertyHelper(@TJvTreeViewOnSelectionChange_R,@TJvTreeViewOnSelectionChange_W,'OnSelectionChange');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJvTreeNode(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJvTreeNode) do begin
    RegisterConstructor(@TJvTreeNode.CreateEnh, 'CreateEnh');
    RegisterPropertyHelper(@TJvTreeNodeChecked_R,@TJvTreeNodeChecked_W,'Checked');
    RegisterPropertyHelper(@TJvTreeNodeBold_R,@TJvTreeNodeBold_W,'Bold');
    RegisterPropertyHelper(@TJvTreeNodePopupMenu_R,@TJvTreeNodePopupMenu_W,'PopupMenu');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJvTrackBar(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJvTrackBar) do begin
    RegisterConstructor(@TJvTrackBar.Create, 'Create');
    RegisterPropertyHelper(@TJvTrackBarAboutJVCL_R,@TJvTrackBarAboutJVCL_W,'AboutJVCL');
    RegisterPropertyHelper(@TJvTrackBarShowRange_R,@TJvTrackBarShowRange_W,'ShowRange');
    RegisterPropertyHelper(@TJvTrackBarToolTips_R,@TJvTrackBarToolTips_W,'ToolTips');
    RegisterPropertyHelper(@TJvTrackBarToolTipSide_R,@TJvTrackBarToolTipSide_W,'ToolTipSide');
    RegisterPropertyHelper(@TJvTrackBarHintColor_R,@TJvTrackBarHintColor_W,'HintColor');
    RegisterPropertyHelper(@TJvTrackBarOnMouseEnter_R,@TJvTrackBarOnMouseEnter_W,'OnMouseEnter');
    RegisterPropertyHelper(@TJvTrackBarOnMouseLeave_R,@TJvTrackBarOnMouseLeave_W,'OnMouseLeave');
    RegisterPropertyHelper(@TJvTrackBarOnCtl3DChanged_R,@TJvTrackBarOnCtl3DChanged_W,'OnCtl3DChanged');
    RegisterPropertyHelper(@TJvTrackBarOnParentColorChange_R,@TJvTrackBarOnParentColorChange_W,'OnParentColorChange');
    RegisterPropertyHelper(@TJvTrackBarOnChanged_R,@TJvTrackBarOnChanged_W,'OnChanged');
    RegisterPropertyHelper(@TJvTrackBarOnToolTip_R,@TJvTrackBarOnToolTip_W,'OnToolTip');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJvPageControl(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJvPageControl) do begin
    RegisterConstructor(@TJvPageControl.Create, 'Create');
    RegisterMethod(@TJvPageControl.UpdateTabImages, 'UpdateTabImages');
    RegisterPropertyHelper(@TJvPageControlAboutJVCL_R,@TJvPageControlAboutJVCL_W,'AboutJVCL');
    RegisterPropertyHelper(@TJvPageControlHandleGlobalTab_R,@TJvPageControlHandleGlobalTab_W,'HandleGlobalTab');
    RegisterPropertyHelper(@TJvPageControlClientBorderWidth_R,@TJvPageControlClientBorderWidth_W,'ClientBorderWidth');
    RegisterPropertyHelper(@TJvPageControlDrawTabShadow_R,@TJvPageControlDrawTabShadow_W,'DrawTabShadow');
    RegisterPropertyHelper(@TJvPageControlHideAllTabs_R,@TJvPageControlHideAllTabs_W,'HideAllTabs');
    RegisterPropertyHelper(@TJvPageControlHintColor_R,@TJvPageControlHintColor_W,'HintColor');
    RegisterPropertyHelper(@TJvPageControlOnMouseEnter_R,@TJvPageControlOnMouseEnter_W,'OnMouseEnter');
    RegisterPropertyHelper(@TJvPageControlOnMouseLeave_R,@TJvPageControlOnMouseLeave_W,'OnMouseLeave');
    RegisterPropertyHelper(@TJvPageControlOnParentColorChange_R,@TJvPageControlOnParentColorChange_W,'OnParentColorChange');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJvIpAddress(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJvIpAddress) do begin
    RegisterConstructor(@TJvIpAddress.Create, 'Create');
    RegisterMethod(@TJvIpAddress.Destroy, 'Free');
    RegisterMethod(@TJvIpAddress.ClearAddress, 'ClearAddress');
    RegisterMethod(@TJvIpAddress.IsBlank, 'IsBlank');
    RegisterPropertyHelper(@TJvIpAddressAboutJVCL_R,@TJvIpAddressAboutJVCL_W,'AboutJVCL');
    RegisterPropertyHelper(@TJvIpAddressAddress_R,@TJvIpAddressAddress_W,'Address');
    RegisterPropertyHelper(@TJvIpAddressAddressValues_R,@TJvIpAddressAddressValues_W,'AddressValues');
    RegisterPropertyHelper(@TJvIpAddressRange_R,@TJvIpAddressRange_W,'Range');
    RegisterPropertyHelper(@TJvIpAddressOnChange_R,@TJvIpAddressOnChange_W,'OnChange');
    RegisterPropertyHelper(@TJvIpAddressOnFieldChange_R,@TJvIpAddressOnFieldChange_W,'OnFieldChange');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJvIpAddressValues(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJvIpAddressValues) do begin
    RegisterPropertyHelper(@TJvIpAddressValuesOnChange_R,@TJvIpAddressValuesOnChange_W,'OnChange');
    RegisterPropertyHelper(@TJvIpAddressValuesOnChanging_R,@TJvIpAddressValuesOnChanging_W,'OnChanging');
    RegisterPropertyHelper(@TJvIpAddressValuesAddress_R,@TJvIpAddressValuesAddress_W,'Address');
    RegisterPropertyHelper(@TJvIpAddressValuesValue1_R,@TJvIpAddressValuesValue1_W,'Value1');
    RegisterPropertyHelper(@TJvIpAddressValuesValue2_R,@TJvIpAddressValuesValue2_W,'Value2');
    RegisterPropertyHelper(@TJvIpAddressValuesValue3_R,@TJvIpAddressValuesValue3_W,'Value3');
    RegisterPropertyHelper(@TJvIpAddressValuesValue4_R,@TJvIpAddressValuesValue4_W,'Value4');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJvIpAddressRange(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJvIpAddressRange) do begin
    RegisterConstructor(@TJvIpAddressRange.Create, 'Create');
    RegisterPropertyHelper(@TJvIpAddressRangeField1Min_R,@TJvIpAddressRangeField1Min_W,'Field1Min');
    RegisterPropertyHelper(@TJvIpAddressRangeField1Max_R,@TJvIpAddressRangeField1Max_W,'Field1Max');
    RegisterPropertyHelper(@TJvIpAddressRangeField2Min_R,@TJvIpAddressRangeField2Min_W,'Field2Min');
    RegisterPropertyHelper(@TJvIpAddressRangeField2Max_R,@TJvIpAddressRangeField2Max_W,'Field2Max');
    RegisterPropertyHelper(@TJvIpAddressRangeField3Min_R,@TJvIpAddressRangeField3Min_W,'Field3Min');
    RegisterPropertyHelper(@TJvIpAddressRangeField3Max_R,@TJvIpAddressRangeField3Max_W,'Field3Max');
    RegisterPropertyHelper(@TJvIpAddressRangeField4Min_R,@TJvIpAddressRangeField4Min_W,'Field4Min');
    RegisterPropertyHelper(@TJvIpAddressRangeField4Max_R,@TJvIpAddressRangeField4Max_W,'Field4Max');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_JvComCtrls(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJvIpAddress) do
  RIRegister_TJvIpAddressRange(CL);
  RIRegister_TJvIpAddressValues(CL);
  RIRegister_TJvIpAddress(CL);
  RIRegister_TJvPageControl(CL);
  RIRegister_TJvTrackBar(CL);
  RIRegister_TJvTreeNode(CL);
  RIRegister_TJvTreeView(CL);
end;



{ TPSImport_JvComCtrls }
(*----------------------------------------------------------------------------*)
procedure TPSImport_JvComCtrls.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_JvComCtrls(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_JvComCtrls.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_JvComCtrls(ri);
end;
(*----------------------------------------------------------------------------*)


end.
