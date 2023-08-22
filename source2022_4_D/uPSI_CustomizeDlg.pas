unit uPSI_CustomizeDlg;
{
  a last frm template
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
  TPSImport_CustomizeDlg = class(TPSPlugin)
  public
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TCustomizeDlg(CL: TPSPascalCompiler);
procedure SIRegister_TCustomizeFrm(CL: TPSPascalCompiler);
procedure SIRegister_CustomizeDlg(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TCustomizeDlg(CL: TPSRuntimeClassImporter);
procedure RIRegister_TCustomizeFrm(CL: TPSRuntimeClassImporter);
procedure RIRegister_CustomizeDlg(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   Windows
  ,Messages
  ,Variants
  ,Graphics
  ,Controls
  ,Forms
  ,Dialogs
  ,StdCtrls
  ,ActnList
  ,CheckLst
  ,ComCtrls
  ,Menus
  ,ExtCtrls
  ,ImgList
  ,ActnMan
  ,ActnCtrls
  ,ActnMenus
  ,Buttons
  ,CustomizeDlg
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_CustomizeDlg]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TCustomizeDlg(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TComponent', 'TCustomizeDlg') do
  with CL.AddClassN(CL.FindClass('TComponent'),'TCustomizeDlg') do
  begin
    RegisterMethod('Procedure Show');
    RegisterProperty('CustomizeForm', 'TCustomizeFrm', iptr);
    RegisterProperty('ActionManager', 'TCustomActionManager', iptrw);
    RegisterProperty('StayOnTop', 'Boolean', iptrw);
    RegisterProperty('OnClose', 'TNotifyEvent', iptrw);
    RegisterProperty('OnShow', 'TNotifyEvent', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TCustomizeFrm(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TForm', 'TCustomizeFrm') do
  with CL.AddClassN(CL.FindClass('TForm'),'TCustomizeFrm') do
  begin
    RegisterProperty('CloseBtn', 'TButton', iptrw);
    RegisterProperty('Tabs', 'TPageControl', iptrw);
    RegisterProperty('ToolbarsTab', 'TTabSheet', iptrw);
    RegisterProperty('ActionsTab', 'TTabSheet', iptrw);
    RegisterProperty('OptionsTab', 'TTabSheet', iptrw);
    RegisterProperty('ToolbarsLbl', 'TLabel', iptrw);
    RegisterProperty('ActionBarList', 'TCheckListBox', iptrw);
    RegisterProperty('ResetBtn', 'TButton', iptrw);
    RegisterProperty('CloseMenu', 'TPopupMenu', iptrw);
    RegisterProperty('CloseItem', 'TMenuItem', iptrw);
    RegisterProperty('PersonalizeLbl', 'TLabel', iptrw);
    RegisterProperty('OptionsBevel2', 'TBevel', iptrw);
    RegisterProperty('RecentlyUsedChk', 'TCheckBox', iptrw);
    RegisterProperty('ResetUsageBtn', 'TButton', iptrw);
    RegisterProperty('LargeIconsChk', 'TCheckBox', iptrw);
    RegisterProperty('ShowTipsChk', 'TCheckBox', iptrw);
    RegisterProperty('ShortCutTipsChk', 'TCheckBox', iptrw);
    RegisterProperty('OptionsBevel1', 'TBevel', iptrw);
    RegisterProperty('OtherLbl', 'TLabel', iptrw);
    RegisterProperty('ActionImages', 'TImageList', iptrw);
    RegisterProperty('Label1', 'TLabel', iptrw);
    RegisterProperty('MenuAnimationStyles', 'TComboBox', iptrw);
    RegisterProperty('InfoLbl', 'TLabel', iptrw);
    RegisterProperty('DescGroupBox', 'TGroupBox', iptrw);
    RegisterProperty('HintLbl', 'TLabel', iptrw);
    RegisterProperty('ActionsCatLbl', 'TLabel', iptrw);
    RegisterProperty('CatList', 'TListBox', iptrw);
    RegisterProperty('ActionsList', 'TListBox', iptrw);
    RegisterProperty('ActionsActionsLbl', 'TLabel', iptrw);
    RegisterProperty('ActionList1', 'TActionList', iptrw);
    RegisterProperty('ResetActn', 'TAction', iptrw);
    RegisterProperty('CloseActn', 'TAction', iptrw);
    RegisterProperty('ResetUsageDataActn', 'TAction', iptrw);
    RegisterProperty('RecentlyUsedActn', 'TAction', iptrw);
    RegisterProperty('FullMenusActn', 'TAction', iptrw);
    RegisterProperty('ShowHintsActn', 'TAction', iptrw);
    RegisterProperty('ShowShortCutsInTipsActn', 'TAction', iptrw);
    RegisterProperty('ListPanel', 'TPanel', iptrw);
    RegisterProperty('ComboPanel', 'TPanel', iptrw);
    RegisterProperty('ListCombo', 'TComboBox', iptrw);
    RegisterProperty('ApplyToAllActn', 'TAction', iptrw);
    RegisterProperty('CaptionOptionsGrp', 'TGroupBox', iptrw);
    RegisterProperty('ApplyToAllChk', 'TCheckBox', iptrw);
    RegisterProperty('Label4', 'TLabel', iptrw);
    RegisterProperty('LargeIconsActn', 'TAction', iptrw);
    RegisterProperty('CaptionOptionsCombo', 'TComboBox', iptrw);
    RegisterProperty('Label2', 'TLabel', iptrw);
    RegisterProperty('SeparatorBtn', 'TButton', iptrw);
    RegisterMethod('Procedure CatListClick( Sender : TObject)');
    RegisterMethod('Procedure ActionsListStartDrag( Sender : TObject; var DragObject : TDragObject)');
    RegisterMethod('Procedure ActionsListDrawItem( Control : TWinControl; Index : Integer; Rect : TRect; State : TOwnerDrawState)');
    RegisterMethod('Procedure FormClose( Sender : TObject; var Action : TCloseAction)');
    RegisterMethod('Procedure CloseBtnClick( Sender : TObject)');
    RegisterMethod('Procedure CatListStartDrag( Sender : TObject; var DragObject : TDragObject)');
    RegisterMethod('Procedure ActionBarListClickCheck( Sender : TObject)');
    RegisterMethod('Procedure ActionsListMeasureItem( Control : TWinControl; Index : Integer; var Height : Integer)');
    RegisterMethod('Procedure FormCreate( Sender : TObject)');
    RegisterMethod('Procedure ActionsListClick( Sender : TObject)');
    RegisterMethod('Procedure MenuAnimationStylesChange( Sender : TObject)');
    RegisterMethod('Procedure ResetActnUpdate( Sender : TObject)');
    RegisterMethod('Procedure ResetActnExecute( Sender : TObject)');
    RegisterMethod('Procedure ResetUsageDataActnExecute( Sender : TObject)');
    RegisterMethod('Procedure RecentlyUsedActnExecute( Sender : TObject)');
    RegisterMethod('Procedure ShowHintsActnExecute( Sender : TObject)');
    RegisterMethod('Procedure ShowHintsActnUpdate( Sender : TObject)');
    RegisterMethod('Procedure ShowShortCutsInTipsActnExecute( Sender : TObject)');
    RegisterMethod('Procedure RecentlyUsedActnUpdate( Sender : TObject)');
    RegisterMethod('Procedure ActionBarListClick( Sender : TObject)');
    RegisterMethod('Procedure ActionsListData( Control : TWinControl; Index : Integer; var Data : string)');
    RegisterMethod('Procedure LargeIconsActnExecute( Sender : TObject)');
    RegisterMethod('Procedure ListComboSelect( Sender : TObject)');
    RegisterMethod('Procedure CaptionOptionsComboChange( Sender : TObject)');
    RegisterMethod('Procedure FormResize( Sender : TObject)');
    RegisterMethod('Procedure LargeIconsActnUpdate( Sender : TObject)');
    RegisterMethod('Procedure SeparatorBtnStartDrag( Sender : TObject; var DragObject : TDragObject)');
    RegisterMethod('Procedure ApplyToAllActnUpdate( Sender : TObject)');
    RegisterProperty('ActionManager', 'TCustomActionManager', iptrw);
    RegisterProperty('ActiveActionList', 'TCustomActionList', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_CustomizeDlg(CL: TPSPascalCompiler);
begin
  SIRegister_TCustomizeFrm(CL);
  SIRegister_TCustomizeDlg(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TCustomizeDlgOnShow_W(Self: TCustomizeDlg; const T: TNotifyEvent);
begin Self.OnShow := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomizeDlgOnShow_R(Self: TCustomizeDlg; var T: TNotifyEvent);
begin T := Self.OnShow; end;

(*----------------------------------------------------------------------------*)
procedure TCustomizeDlgOnClose_W(Self: TCustomizeDlg; const T: TNotifyEvent);
begin Self.OnClose := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomizeDlgOnClose_R(Self: TCustomizeDlg; var T: TNotifyEvent);
begin T := Self.OnClose; end;

(*----------------------------------------------------------------------------*)
procedure TCustomizeDlgStayOnTop_W(Self: TCustomizeDlg; const T: Boolean);
begin Self.StayOnTop := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomizeDlgStayOnTop_R(Self: TCustomizeDlg; var T: Boolean);
begin T := Self.StayOnTop; end;

(*----------------------------------------------------------------------------*)
procedure TCustomizeDlgActionManager_W(Self: TCustomizeDlg; const T: TCustomActionManager);
begin Self.ActionManager := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomizeDlgActionManager_R(Self: TCustomizeDlg; var T: TCustomActionManager);
begin T := Self.ActionManager; end;

(*----------------------------------------------------------------------------*)
procedure TCustomizeDlgCustomizeForm_R(Self: TCustomizeDlg; var T: TCustomizeFrm);
begin T := Self.CustomizeForm; end;

(*----------------------------------------------------------------------------*)
procedure TCustomizeFrmActiveActionList_W(Self: TCustomizeFrm; const T: TCustomActionList);
begin Self.ActiveActionList := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomizeFrmActiveActionList_R(Self: TCustomizeFrm; var T: TCustomActionList);
begin T := Self.ActiveActionList; end;

(*----------------------------------------------------------------------------*)
procedure TCustomizeFrmActionManager_W(Self: TCustomizeFrm; const T: TCustomActionManager);
begin Self.ActionManager := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomizeFrmActionManager_R(Self: TCustomizeFrm; var T: TCustomActionManager);
begin T := Self.ActionManager; end;

(*----------------------------------------------------------------------------*)
procedure TCustomizeFrmSeparatorBtn_W(Self: TCustomizeFrm; const T: TButton);
Begin Self.SeparatorBtn := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomizeFrmSeparatorBtn_R(Self: TCustomizeFrm; var T: TButton);
Begin T := Self.SeparatorBtn; end;

(*----------------------------------------------------------------------------*)
procedure TCustomizeFrmLabel2_W(Self: TCustomizeFrm; const T: TLabel);
Begin Self.Label2 := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomizeFrmLabel2_R(Self: TCustomizeFrm; var T: TLabel);
Begin T := Self.Label2; end;

(*----------------------------------------------------------------------------*)
procedure TCustomizeFrmCaptionOptionsCombo_W(Self: TCustomizeFrm; const T: TComboBox);
Begin Self.CaptionOptionsCombo := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomizeFrmCaptionOptionsCombo_R(Self: TCustomizeFrm; var T: TComboBox);
Begin T := Self.CaptionOptionsCombo; end;

(*----------------------------------------------------------------------------*)
procedure TCustomizeFrmLargeIconsActn_W(Self: TCustomizeFrm; const T: TAction);
Begin Self.LargeIconsActn := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomizeFrmLargeIconsActn_R(Self: TCustomizeFrm; var T: TAction);
Begin T := Self.LargeIconsActn; end;

(*----------------------------------------------------------------------------*)
procedure TCustomizeFrmLabel4_W(Self: TCustomizeFrm; const T: TLabel);
Begin Self.Label4 := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomizeFrmLabel4_R(Self: TCustomizeFrm; var T: TLabel);
Begin T := Self.Label4; end;

(*----------------------------------------------------------------------------*)
procedure TCustomizeFrmApplyToAllChk_W(Self: TCustomizeFrm; const T: TCheckBox);
Begin Self.ApplyToAllChk := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomizeFrmApplyToAllChk_R(Self: TCustomizeFrm; var T: TCheckBox);
Begin T := Self.ApplyToAllChk; end;

(*----------------------------------------------------------------------------*)
procedure TCustomizeFrmCaptionOptionsGrp_W(Self: TCustomizeFrm; const T: TGroupBox);
Begin Self.CaptionOptionsGrp := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomizeFrmCaptionOptionsGrp_R(Self: TCustomizeFrm; var T: TGroupBox);
Begin T := Self.CaptionOptionsGrp; end;

(*----------------------------------------------------------------------------*)
procedure TCustomizeFrmApplyToAllActn_W(Self: TCustomizeFrm; const T: TAction);
Begin Self.ApplyToAllActn := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomizeFrmApplyToAllActn_R(Self: TCustomizeFrm; var T: TAction);
Begin T := Self.ApplyToAllActn; end;

(*----------------------------------------------------------------------------*)
procedure TCustomizeFrmListCombo_W(Self: TCustomizeFrm; const T: TComboBox);
Begin Self.ListCombo := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomizeFrmListCombo_R(Self: TCustomizeFrm; var T: TComboBox);
Begin T := Self.ListCombo; end;

(*----------------------------------------------------------------------------*)
procedure TCustomizeFrmComboPanel_W(Self: TCustomizeFrm; const T: TPanel);
Begin Self.ComboPanel := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomizeFrmComboPanel_R(Self: TCustomizeFrm; var T: TPanel);
Begin T := Self.ComboPanel; end;

(*----------------------------------------------------------------------------*)
procedure TCustomizeFrmListPanel_W(Self: TCustomizeFrm; const T: TPanel);
Begin Self.ListPanel := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomizeFrmListPanel_R(Self: TCustomizeFrm; var T: TPanel);
Begin T := Self.ListPanel; end;

(*----------------------------------------------------------------------------*)
procedure TCustomizeFrmShowShortCutsInTipsActn_W(Self: TCustomizeFrm; const T: TAction);
Begin Self.ShowShortCutsInTipsActn := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomizeFrmShowShortCutsInTipsActn_R(Self: TCustomizeFrm; var T: TAction);
Begin T := Self.ShowShortCutsInTipsActn; end;

(*----------------------------------------------------------------------------*)
procedure TCustomizeFrmShowHintsActn_W(Self: TCustomizeFrm; const T: TAction);
Begin Self.ShowHintsActn := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomizeFrmShowHintsActn_R(Self: TCustomizeFrm; var T: TAction);
Begin T := Self.ShowHintsActn; end;

(*----------------------------------------------------------------------------*)
procedure TCustomizeFrmFullMenusActn_W(Self: TCustomizeFrm; const T: TAction);
Begin Self.FullMenusActn := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomizeFrmFullMenusActn_R(Self: TCustomizeFrm; var T: TAction);
Begin T := Self.FullMenusActn; end;

(*----------------------------------------------------------------------------*)
procedure TCustomizeFrmRecentlyUsedActn_W(Self: TCustomizeFrm; const T: TAction);
Begin Self.RecentlyUsedActn := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomizeFrmRecentlyUsedActn_R(Self: TCustomizeFrm; var T: TAction);
Begin T := Self.RecentlyUsedActn; end;

(*----------------------------------------------------------------------------*)
procedure TCustomizeFrmResetUsageDataActn_W(Self: TCustomizeFrm; const T: TAction);
Begin Self.ResetUsageDataActn := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomizeFrmResetUsageDataActn_R(Self: TCustomizeFrm; var T: TAction);
Begin T := Self.ResetUsageDataActn; end;

(*----------------------------------------------------------------------------*)
procedure TCustomizeFrmCloseActn_W(Self: TCustomizeFrm; const T: TAction);
Begin Self.CloseActn := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomizeFrmCloseActn_R(Self: TCustomizeFrm; var T: TAction);
Begin T := Self.CloseActn; end;

(*----------------------------------------------------------------------------*)
procedure TCustomizeFrmResetActn_W(Self: TCustomizeFrm; const T: TAction);
Begin Self.ResetActn := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomizeFrmResetActn_R(Self: TCustomizeFrm; var T: TAction);
Begin T := Self.ResetActn; end;

(*----------------------------------------------------------------------------*)
procedure TCustomizeFrmActionList1_W(Self: TCustomizeFrm; const T: TActionList);
Begin Self.ActionList1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomizeFrmActionList1_R(Self: TCustomizeFrm; var T: TActionList);
Begin T := Self.ActionList1; end;

(*----------------------------------------------------------------------------*)
procedure TCustomizeFrmActionsActionsLbl_W(Self: TCustomizeFrm; const T: TLabel);
Begin Self.ActionsActionsLbl := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomizeFrmActionsActionsLbl_R(Self: TCustomizeFrm; var T: TLabel);
Begin T := Self.ActionsActionsLbl; end;

(*----------------------------------------------------------------------------*)
procedure TCustomizeFrmActionsList_W(Self: TCustomizeFrm; const T: TListBox);
Begin Self.ActionsList := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomizeFrmActionsList_R(Self: TCustomizeFrm; var T: TListBox);
Begin T := Self.ActionsList; end;

(*----------------------------------------------------------------------------*)
procedure TCustomizeFrmCatList_W(Self: TCustomizeFrm; const T: TListBox);
Begin Self.CatList := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomizeFrmCatList_R(Self: TCustomizeFrm; var T: TListBox);
Begin T := Self.CatList; end;

(*----------------------------------------------------------------------------*)
procedure TCustomizeFrmActionsCatLbl_W(Self: TCustomizeFrm; const T: TLabel);
Begin Self.ActionsCatLbl := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomizeFrmActionsCatLbl_R(Self: TCustomizeFrm; var T: TLabel);
Begin T := Self.ActionsCatLbl; end;

(*----------------------------------------------------------------------------*)
procedure TCustomizeFrmHintLbl_W(Self: TCustomizeFrm; const T: TLabel);
Begin Self.HintLbl := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomizeFrmHintLbl_R(Self: TCustomizeFrm; var T: TLabel);
Begin T := Self.HintLbl; end;

(*----------------------------------------------------------------------------*)
procedure TCustomizeFrmDescGroupBox_W(Self: TCustomizeFrm; const T: TGroupBox);
Begin Self.DescGroupBox := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomizeFrmDescGroupBox_R(Self: TCustomizeFrm; var T: TGroupBox);
Begin T := Self.DescGroupBox; end;

(*----------------------------------------------------------------------------*)
procedure TCustomizeFrmInfoLbl_W(Self: TCustomizeFrm; const T: TLabel);
Begin Self.InfoLbl := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomizeFrmInfoLbl_R(Self: TCustomizeFrm; var T: TLabel);
Begin T := Self.InfoLbl; end;

(*----------------------------------------------------------------------------*)
procedure TCustomizeFrmMenuAnimationStyles_W(Self: TCustomizeFrm; const T: TComboBox);
Begin Self.MenuAnimationStyles := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomizeFrmMenuAnimationStyles_R(Self: TCustomizeFrm; var T: TComboBox);
Begin T := Self.MenuAnimationStyles; end;

(*----------------------------------------------------------------------------*)
procedure TCustomizeFrmLabel1_W(Self: TCustomizeFrm; const T: TLabel);
Begin Self.Label1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomizeFrmLabel1_R(Self: TCustomizeFrm; var T: TLabel);
Begin T := Self.Label1; end;

(*----------------------------------------------------------------------------*)
procedure TCustomizeFrmActionImages_W(Self: TCustomizeFrm; const T: TImageList);
Begin Self.ActionImages := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomizeFrmActionImages_R(Self: TCustomizeFrm; var T: TImageList);
Begin T := Self.ActionImages; end;

(*----------------------------------------------------------------------------*)
procedure TCustomizeFrmOtherLbl_W(Self: TCustomizeFrm; const T: TLabel);
Begin Self.OtherLbl := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomizeFrmOtherLbl_R(Self: TCustomizeFrm; var T: TLabel);
Begin T := Self.OtherLbl; end;

(*----------------------------------------------------------------------------*)
procedure TCustomizeFrmOptionsBevel1_W(Self: TCustomizeFrm; const T: TBevel);
Begin Self.OptionsBevel1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomizeFrmOptionsBevel1_R(Self: TCustomizeFrm; var T: TBevel);
Begin T := Self.OptionsBevel1; end;

(*----------------------------------------------------------------------------*)
procedure TCustomizeFrmShortCutTipsChk_W(Self: TCustomizeFrm; const T: TCheckBox);
Begin Self.ShortCutTipsChk := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomizeFrmShortCutTipsChk_R(Self: TCustomizeFrm; var T: TCheckBox);
Begin T := Self.ShortCutTipsChk; end;

(*----------------------------------------------------------------------------*)
procedure TCustomizeFrmShowTipsChk_W(Self: TCustomizeFrm; const T: TCheckBox);
Begin Self.ShowTipsChk := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomizeFrmShowTipsChk_R(Self: TCustomizeFrm; var T: TCheckBox);
Begin T := Self.ShowTipsChk; end;

(*----------------------------------------------------------------------------*)
procedure TCustomizeFrmLargeIconsChk_W(Self: TCustomizeFrm; const T: TCheckBox);
Begin Self.LargeIconsChk := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomizeFrmLargeIconsChk_R(Self: TCustomizeFrm; var T: TCheckBox);
Begin T := Self.LargeIconsChk; end;

(*----------------------------------------------------------------------------*)
procedure TCustomizeFrmResetUsageBtn_W(Self: TCustomizeFrm; const T: TButton);
Begin Self.ResetUsageBtn := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomizeFrmResetUsageBtn_R(Self: TCustomizeFrm; var T: TButton);
Begin T := Self.ResetUsageBtn; end;

(*----------------------------------------------------------------------------*)
procedure TCustomizeFrmRecentlyUsedChk_W(Self: TCustomizeFrm; const T: TCheckBox);
Begin Self.RecentlyUsedChk := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomizeFrmRecentlyUsedChk_R(Self: TCustomizeFrm; var T: TCheckBox);
Begin T := Self.RecentlyUsedChk; end;

(*----------------------------------------------------------------------------*)
procedure TCustomizeFrmOptionsBevel2_W(Self: TCustomizeFrm; const T: TBevel);
Begin Self.OptionsBevel2 := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomizeFrmOptionsBevel2_R(Self: TCustomizeFrm; var T: TBevel);
Begin T := Self.OptionsBevel2; end;

(*----------------------------------------------------------------------------*)
procedure TCustomizeFrmPersonalizeLbl_W(Self: TCustomizeFrm; const T: TLabel);
Begin Self.PersonalizeLbl := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomizeFrmPersonalizeLbl_R(Self: TCustomizeFrm; var T: TLabel);
Begin T := Self.PersonalizeLbl; end;

(*----------------------------------------------------------------------------*)
procedure TCustomizeFrmCloseItem_W(Self: TCustomizeFrm; const T: TMenuItem);
Begin Self.CloseItem := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomizeFrmCloseItem_R(Self: TCustomizeFrm; var T: TMenuItem);
Begin T := Self.CloseItem; end;

(*----------------------------------------------------------------------------*)
procedure TCustomizeFrmCloseMenu_W(Self: TCustomizeFrm; const T: TPopupMenu);
Begin Self.CloseMenu := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomizeFrmCloseMenu_R(Self: TCustomizeFrm; var T: TPopupMenu);
Begin T := Self.CloseMenu; end;

(*----------------------------------------------------------------------------*)
procedure TCustomizeFrmResetBtn_W(Self: TCustomizeFrm; const T: TButton);
Begin Self.ResetBtn := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomizeFrmResetBtn_R(Self: TCustomizeFrm; var T: TButton);
Begin T := Self.ResetBtn; end;

(*----------------------------------------------------------------------------*)
procedure TCustomizeFrmActionBarList_W(Self: TCustomizeFrm; const T: TCheckListBox);
Begin Self.ActionBarList := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomizeFrmActionBarList_R(Self: TCustomizeFrm; var T: TCheckListBox);
Begin T := Self.ActionBarList; end;

(*----------------------------------------------------------------------------*)
procedure TCustomizeFrmToolbarsLbl_W(Self: TCustomizeFrm; const T: TLabel);
Begin Self.ToolbarsLbl := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomizeFrmToolbarsLbl_R(Self: TCustomizeFrm; var T: TLabel);
Begin T := Self.ToolbarsLbl; end;

(*----------------------------------------------------------------------------*)
procedure TCustomizeFrmOptionsTab_W(Self: TCustomizeFrm; const T: TTabSheet);
Begin Self.OptionsTab := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomizeFrmOptionsTab_R(Self: TCustomizeFrm; var T: TTabSheet);
Begin T := Self.OptionsTab; end;

(*----------------------------------------------------------------------------*)
procedure TCustomizeFrmActionsTab_W(Self: TCustomizeFrm; const T: TTabSheet);
Begin Self.ActionsTab := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomizeFrmActionsTab_R(Self: TCustomizeFrm; var T: TTabSheet);
Begin T := Self.ActionsTab; end;

(*----------------------------------------------------------------------------*)
procedure TCustomizeFrmToolbarsTab_W(Self: TCustomizeFrm; const T: TTabSheet);
Begin Self.ToolbarsTab := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomizeFrmToolbarsTab_R(Self: TCustomizeFrm; var T: TTabSheet);
Begin T := Self.ToolbarsTab; end;

(*----------------------------------------------------------------------------*)
procedure TCustomizeFrmTabs_W(Self: TCustomizeFrm; const T: TPageControl);
Begin Self.Tabs := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomizeFrmTabs_R(Self: TCustomizeFrm; var T: TPageControl);
Begin T := Self.Tabs; end;

(*----------------------------------------------------------------------------*)
procedure TCustomizeFrmCloseBtn_W(Self: TCustomizeFrm; const T: TButton);
Begin Self.CloseBtn := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomizeFrmCloseBtn_R(Self: TCustomizeFrm; var T: TButton);
Begin T := Self.CloseBtn; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TCustomizeDlg(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TCustomizeDlg) do
  begin
    RegisterMethod(@TCustomizeDlg.Show, 'Show');
    RegisterPropertyHelper(@TCustomizeDlgCustomizeForm_R,nil,'CustomizeForm');
    RegisterPropertyHelper(@TCustomizeDlgActionManager_R,@TCustomizeDlgActionManager_W,'ActionManager');
    RegisterPropertyHelper(@TCustomizeDlgStayOnTop_R,@TCustomizeDlgStayOnTop_W,'StayOnTop');
    RegisterPropertyHelper(@TCustomizeDlgOnClose_R,@TCustomizeDlgOnClose_W,'OnClose');
    RegisterPropertyHelper(@TCustomizeDlgOnShow_R,@TCustomizeDlgOnShow_W,'OnShow');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TCustomizeFrm(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TCustomizeFrm) do
  begin
    RegisterPropertyHelper(@TCustomizeFrmCloseBtn_R,@TCustomizeFrmCloseBtn_W,'CloseBtn');
    RegisterPropertyHelper(@TCustomizeFrmTabs_R,@TCustomizeFrmTabs_W,'Tabs');
    RegisterPropertyHelper(@TCustomizeFrmToolbarsTab_R,@TCustomizeFrmToolbarsTab_W,'ToolbarsTab');
    RegisterPropertyHelper(@TCustomizeFrmActionsTab_R,@TCustomizeFrmActionsTab_W,'ActionsTab');
    RegisterPropertyHelper(@TCustomizeFrmOptionsTab_R,@TCustomizeFrmOptionsTab_W,'OptionsTab');
    RegisterPropertyHelper(@TCustomizeFrmToolbarsLbl_R,@TCustomizeFrmToolbarsLbl_W,'ToolbarsLbl');
    RegisterPropertyHelper(@TCustomizeFrmActionBarList_R,@TCustomizeFrmActionBarList_W,'ActionBarList');
    RegisterPropertyHelper(@TCustomizeFrmResetBtn_R,@TCustomizeFrmResetBtn_W,'ResetBtn');
    RegisterPropertyHelper(@TCustomizeFrmCloseMenu_R,@TCustomizeFrmCloseMenu_W,'CloseMenu');
    RegisterPropertyHelper(@TCustomizeFrmCloseItem_R,@TCustomizeFrmCloseItem_W,'CloseItem');
    RegisterPropertyHelper(@TCustomizeFrmPersonalizeLbl_R,@TCustomizeFrmPersonalizeLbl_W,'PersonalizeLbl');
    RegisterPropertyHelper(@TCustomizeFrmOptionsBevel2_R,@TCustomizeFrmOptionsBevel2_W,'OptionsBevel2');
    RegisterPropertyHelper(@TCustomizeFrmRecentlyUsedChk_R,@TCustomizeFrmRecentlyUsedChk_W,'RecentlyUsedChk');
    RegisterPropertyHelper(@TCustomizeFrmResetUsageBtn_R,@TCustomizeFrmResetUsageBtn_W,'ResetUsageBtn');
    RegisterPropertyHelper(@TCustomizeFrmLargeIconsChk_R,@TCustomizeFrmLargeIconsChk_W,'LargeIconsChk');
    RegisterPropertyHelper(@TCustomizeFrmShowTipsChk_R,@TCustomizeFrmShowTipsChk_W,'ShowTipsChk');
    RegisterPropertyHelper(@TCustomizeFrmShortCutTipsChk_R,@TCustomizeFrmShortCutTipsChk_W,'ShortCutTipsChk');
    RegisterPropertyHelper(@TCustomizeFrmOptionsBevel1_R,@TCustomizeFrmOptionsBevel1_W,'OptionsBevel1');
    RegisterPropertyHelper(@TCustomizeFrmOtherLbl_R,@TCustomizeFrmOtherLbl_W,'OtherLbl');
    RegisterPropertyHelper(@TCustomizeFrmActionImages_R,@TCustomizeFrmActionImages_W,'ActionImages');
    RegisterPropertyHelper(@TCustomizeFrmLabel1_R,@TCustomizeFrmLabel1_W,'Label1');
    RegisterPropertyHelper(@TCustomizeFrmMenuAnimationStyles_R,@TCustomizeFrmMenuAnimationStyles_W,'MenuAnimationStyles');
    RegisterPropertyHelper(@TCustomizeFrmInfoLbl_R,@TCustomizeFrmInfoLbl_W,'InfoLbl');
    RegisterPropertyHelper(@TCustomizeFrmDescGroupBox_R,@TCustomizeFrmDescGroupBox_W,'DescGroupBox');
    RegisterPropertyHelper(@TCustomizeFrmHintLbl_R,@TCustomizeFrmHintLbl_W,'HintLbl');
    RegisterPropertyHelper(@TCustomizeFrmActionsCatLbl_R,@TCustomizeFrmActionsCatLbl_W,'ActionsCatLbl');
    RegisterPropertyHelper(@TCustomizeFrmCatList_R,@TCustomizeFrmCatList_W,'CatList');
    RegisterPropertyHelper(@TCustomizeFrmActionsList_R,@TCustomizeFrmActionsList_W,'ActionsList');
    RegisterPropertyHelper(@TCustomizeFrmActionsActionsLbl_R,@TCustomizeFrmActionsActionsLbl_W,'ActionsActionsLbl');
    RegisterPropertyHelper(@TCustomizeFrmActionList1_R,@TCustomizeFrmActionList1_W,'ActionList1');
    RegisterPropertyHelper(@TCustomizeFrmResetActn_R,@TCustomizeFrmResetActn_W,'ResetActn');
    RegisterPropertyHelper(@TCustomizeFrmCloseActn_R,@TCustomizeFrmCloseActn_W,'CloseActn');
    RegisterPropertyHelper(@TCustomizeFrmResetUsageDataActn_R,@TCustomizeFrmResetUsageDataActn_W,'ResetUsageDataActn');
    RegisterPropertyHelper(@TCustomizeFrmRecentlyUsedActn_R,@TCustomizeFrmRecentlyUsedActn_W,'RecentlyUsedActn');
    RegisterPropertyHelper(@TCustomizeFrmFullMenusActn_R,@TCustomizeFrmFullMenusActn_W,'FullMenusActn');
    RegisterPropertyHelper(@TCustomizeFrmShowHintsActn_R,@TCustomizeFrmShowHintsActn_W,'ShowHintsActn');
    RegisterPropertyHelper(@TCustomizeFrmShowShortCutsInTipsActn_R,@TCustomizeFrmShowShortCutsInTipsActn_W,'ShowShortCutsInTipsActn');
    RegisterPropertyHelper(@TCustomizeFrmListPanel_R,@TCustomizeFrmListPanel_W,'ListPanel');
    RegisterPropertyHelper(@TCustomizeFrmComboPanel_R,@TCustomizeFrmComboPanel_W,'ComboPanel');
    RegisterPropertyHelper(@TCustomizeFrmListCombo_R,@TCustomizeFrmListCombo_W,'ListCombo');
    RegisterPropertyHelper(@TCustomizeFrmApplyToAllActn_R,@TCustomizeFrmApplyToAllActn_W,'ApplyToAllActn');
    RegisterPropertyHelper(@TCustomizeFrmCaptionOptionsGrp_R,@TCustomizeFrmCaptionOptionsGrp_W,'CaptionOptionsGrp');
    RegisterPropertyHelper(@TCustomizeFrmApplyToAllChk_R,@TCustomizeFrmApplyToAllChk_W,'ApplyToAllChk');
    RegisterPropertyHelper(@TCustomizeFrmLabel4_R,@TCustomizeFrmLabel4_W,'Label4');
    RegisterPropertyHelper(@TCustomizeFrmLargeIconsActn_R,@TCustomizeFrmLargeIconsActn_W,'LargeIconsActn');
    RegisterPropertyHelper(@TCustomizeFrmCaptionOptionsCombo_R,@TCustomizeFrmCaptionOptionsCombo_W,'CaptionOptionsCombo');
    RegisterPropertyHelper(@TCustomizeFrmLabel2_R,@TCustomizeFrmLabel2_W,'Label2');
    RegisterPropertyHelper(@TCustomizeFrmSeparatorBtn_R,@TCustomizeFrmSeparatorBtn_W,'SeparatorBtn');
    RegisterMethod(@TCustomizeFrm.CatListClick, 'CatListClick');
    RegisterMethod(@TCustomizeFrm.ActionsListStartDrag, 'ActionsListStartDrag');
    RegisterMethod(@TCustomizeFrm.ActionsListDrawItem, 'ActionsListDrawItem');
    RegisterMethod(@TCustomizeFrm.FormClose, 'FormClose');
    RegisterMethod(@TCustomizeFrm.CloseBtnClick, 'CloseBtnClick');
    RegisterMethod(@TCustomizeFrm.CatListStartDrag, 'CatListStartDrag');
    RegisterMethod(@TCustomizeFrm.ActionBarListClickCheck, 'ActionBarListClickCheck');
    RegisterMethod(@TCustomizeFrm.ActionsListMeasureItem, 'ActionsListMeasureItem');
    RegisterMethod(@TCustomizeFrm.FormCreate, 'FormCreate');
    RegisterMethod(@TCustomizeFrm.ActionsListClick, 'ActionsListClick');
    RegisterMethod(@TCustomizeFrm.MenuAnimationStylesChange, 'MenuAnimationStylesChange');
    RegisterMethod(@TCustomizeFrm.ResetActnUpdate, 'ResetActnUpdate');
    RegisterMethod(@TCustomizeFrm.ResetActnExecute, 'ResetActnExecute');
    RegisterMethod(@TCustomizeFrm.ResetUsageDataActnExecute, 'ResetUsageDataActnExecute');
    RegisterMethod(@TCustomizeFrm.RecentlyUsedActnExecute, 'RecentlyUsedActnExecute');
    RegisterMethod(@TCustomizeFrm.ShowHintsActnExecute, 'ShowHintsActnExecute');
    RegisterMethod(@TCustomizeFrm.ShowHintsActnUpdate, 'ShowHintsActnUpdate');
    RegisterMethod(@TCustomizeFrm.ShowShortCutsInTipsActnExecute, 'ShowShortCutsInTipsActnExecute');
    RegisterMethod(@TCustomizeFrm.RecentlyUsedActnUpdate, 'RecentlyUsedActnUpdate');
    RegisterMethod(@TCustomizeFrm.ActionBarListClick, 'ActionBarListClick');
    RegisterMethod(@TCustomizeFrm.ActionsListData, 'ActionsListData');
    RegisterMethod(@TCustomizeFrm.LargeIconsActnExecute, 'LargeIconsActnExecute');
    RegisterMethod(@TCustomizeFrm.ListComboSelect, 'ListComboSelect');
    RegisterMethod(@TCustomizeFrm.CaptionOptionsComboChange, 'CaptionOptionsComboChange');
    RegisterMethod(@TCustomizeFrm.FormResize, 'FormResize');
    RegisterMethod(@TCustomizeFrm.LargeIconsActnUpdate, 'LargeIconsActnUpdate');
    RegisterMethod(@TCustomizeFrm.SeparatorBtnStartDrag, 'SeparatorBtnStartDrag');
    RegisterMethod(@TCustomizeFrm.ApplyToAllActnUpdate, 'ApplyToAllActnUpdate');
    RegisterPropertyHelper(@TCustomizeFrmActionManager_R,@TCustomizeFrmActionManager_W,'ActionManager');
    RegisterPropertyHelper(@TCustomizeFrmActiveActionList_R,@TCustomizeFrmActiveActionList_W,'ActiveActionList');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_CustomizeDlg(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TCustomizeFrm(CL);
  RIRegister_TCustomizeDlg(CL);
end;

 
 
{ TPSImport_CustomizeDlg }
(*----------------------------------------------------------------------------*)
procedure TPSImport_CustomizeDlg.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_CustomizeDlg(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_CustomizeDlg.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_CustomizeDlg(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
