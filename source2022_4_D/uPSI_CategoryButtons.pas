unit uPSI_CategoryButtons;
{
   for buttongroup
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
  TPSImport_CategoryButtons = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TButtonItemActionLink(CL: TPSPascalCompiler);
procedure SIRegister_TButtonCategories(CL: TPSPascalCompiler);
procedure SIRegister_TButtonCategory(CL: TPSPascalCompiler);
procedure SIRegister_TButtonCollection(CL: TPSPascalCompiler);
procedure SIRegister_TButtonItem(CL: TPSPascalCompiler);
procedure SIRegister_TBaseButtonItem(CL: TPSPascalCompiler);
procedure SIRegister_TCategoryButtons(CL: TPSPascalCompiler);
procedure SIRegister_CategoryButtons(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TButtonItemActionLink(CL: TPSRuntimeClassImporter);
procedure RIRegister_TButtonCategories(CL: TPSRuntimeClassImporter);
procedure RIRegister_TButtonCategory(CL: TPSRuntimeClassImporter);
procedure RIRegister_TButtonCollection(CL: TPSRuntimeClassImporter);
procedure RIRegister_TButtonItem(CL: TPSRuntimeClassImporter);
procedure RIRegister_TBaseButtonItem(CL: TPSRuntimeClassImporter);
procedure RIRegister_TCategoryButtons(CL: TPSRuntimeClassImporter);
procedure RIRegister_CategoryButtons(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   Windows
  ,Controls
  ,ImgList
  ,Forms
  ,Messages
  ,Graphics
  ,StdCtrls
  ,GraphUtil
  ,ActnList
  ,CategoryButtons
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_CategoryButtons]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TButtonItemActionLink(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TActionLink', 'TButtonItemActionLink') do
  with CL.AddClassN(CL.FindClass('TActionLink'),'TButtonItemActionLink') do
  begin
    RegisterMethod('Function DoShowHint( var HintStr : string) : Boolean');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TButtonCategories(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TCollection', 'TButtonCategories') do
  with CL.AddClassN(CL.FindClass('TCollection'),'TButtonCategories') do begin
    RegisterMethod('Constructor Create( const ButtonGroup : TCategoryButtons)');
      RegisterMethod('Procedure Free');
     RegisterMethod('Function Add : TButtonCategory');
    RegisterMethod('Function AddItem( Item : TButtonCategory; Index : Integer) : TButtonCategory');
    RegisterMethod('Function Insert( Index : Integer) : TButtonCategory');
    RegisterMethod('Function IndexOf( const Caption : string) : Integer');
    RegisterProperty('Items', 'TButtonCategory Integer', iptrw);
    SetDefaultPropery('Items');
    RegisterProperty('ButtonGroup', 'TCategoryButtons', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TButtonCategory(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TCollectionItem', 'TButtonCategory') do
  with CL.AddClassN(CL.FindClass('TCollectionItem'),'TButtonCategory') do begin
    RegisterMethod('Constructor Create( Collection : TCollection)');
      RegisterMethod('Procedure Free');
     RegisterMethod('Procedure ScrollIntoView');
    RegisterMethod('Function IndexOf( const Caption : string) : Integer');
    RegisterProperty('Categories', 'TButtonCategories', iptr);
    RegisterProperty('Data', 'Pointer', iptrw);
    RegisterProperty('InterfaceData', 'IInterface', iptrw);
    RegisterMethod('Procedure Assign( Source : TPersistent)');
    RegisterProperty('Caption', 'string', iptrw);
    RegisterProperty('Color', 'TColor', iptrw);
    RegisterProperty('Collapsed', 'Boolean', iptrw);
    RegisterProperty('GradientColor', 'TColor', iptrw);
    RegisterProperty('Items', 'TButtonCollection', iptrw);
    RegisterProperty('TextColor', 'TColor', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TButtonCollection(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TCollection', 'TButtonCollection') do
  with CL.AddClassN(CL.FindClass('TCollection'),'TButtonCollection') do begin
    RegisterMethod('Constructor Create( const ACategory : TButtonCategory)');
      RegisterMethod('Procedure Free');
     RegisterMethod('Function Add : TButtonItem');
    RegisterMethod('Function AddItem( Item : TButtonItem; Index : Integer) : TButtonItem');
    RegisterMethod('Function Insert( Index : Integer) : TButtonItem');
    RegisterProperty('Items', 'TButtonItem Integer', iptrw);
    SetDefaultPropery('Items');
    RegisterProperty('Category', 'TButtonCategory', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TButtonItem(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TBaseButtonItem', 'TButtonItem') do
  with CL.AddClassN(CL.FindClass('TBaseButtonItem'),'TButtonItem') do begin
    RegisterProperty('InterfaceData', 'IInterface', iptrw);
    RegisterProperty('Category', 'TButtonCategory', iptr);
    RegisterProperty('ButtonGroup', 'TCategoryButtons', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TBaseButtonItem(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TCollectionItem', 'TBaseButtonItem') do
  with CL.AddClassN(CL.FindClass('TCollectionItem'),'TBaseButtonItem') do begin
    RegisterMethod('Constructor Create( Collection : TCollection)');
      RegisterMethod('Procedure Free');
     RegisterMethod('Procedure Assign( Source : TPersistent)');
    RegisterProperty('Data', 'Pointer', iptrw);
    RegisterMethod('Procedure ScrollIntoView');
    RegisterProperty('Action', 'TBasicAction', iptrw);
    RegisterProperty('Caption', 'string', iptrw);
    RegisterProperty('Hint', 'string', iptrw);
    RegisterProperty('ImageIndex', 'TImageIndex', iptrw);
    RegisterProperty('OnClick', 'TNotifyEvent', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TCategoryButtons(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TCustomControl', 'TCategoryButtons') do
  with CL.AddClassN(CL.FindClass('TCustomControl'),'TCategoryButtons') do begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
    RegisterMethod('Procedure Free');
    RegisterMethod('Procedure Assign( Source : TPersistent)');
    RegisterProperty('DragButton', 'TButtonItem', iptrw);
    RegisterProperty('DragCategory', 'TButtonCategory', iptrw);
    RegisterProperty('DragImageList', 'TDragImageList', iptr);
    RegisterMethod('Procedure DragDrop( Source : TObject; X : Integer; Y : Integer)');
    RegisterMethod('Procedure GenerateDragImage');
    RegisterMethod('Function GetButtonRect( const Button : TButtonItem) : TRect');
    RegisterMethod('Function GetCategoryRect( const Category : TButtonCategory) : TRect');
    RegisterMethod('Function GetButtonAt( X, Y : Integer; Category : TButtonCategory) : TButtonItem');
    RegisterMethod('Function GetCategoryAt( X, Y : Integer) : TButtonCategory');
    RegisterMethod('Procedure RemoveInsertionPoints');
    RegisterMethod('Procedure ScrollIntoView( const Button : TButtonItem);');
    RegisterMethod('Procedure ScrollIntoView1( const Category : TButtonCategory);');
    RegisterMethod('Procedure SetInsertionButton( InsertionButton : TButtonItem; InsertionCategory : TButtonCategory)');
    RegisterMethod('Procedure GetTargetAt( X, Y : Integer; var TargetButton : TButtonItem; var TargetCategory : TButtonCategory)');
    RegisterMethod('Procedure UpdateButton( const Button : TButtonItem)');
    RegisterMethod('Procedure UpdateAllButtons');
    RegisterProperty('SelectedItem', 'TButtonItem', iptrw);
    RegisterProperty('FocusedItem', 'TButtonItem', iptrw);
    RegisterProperty('BorderStyle', 'TBorderStyle', iptrw);
    RegisterProperty('ButtonFlow', 'TCatButtonFlow', iptrw);
    RegisterProperty('ButtonHeight', 'Integer', iptrw);
    RegisterProperty('ButtonWidth', 'Integer', iptrw);
    RegisterProperty('ButtonOptions', 'TCatButtonOptions', iptrw);
    RegisterProperty('Images', 'TCustomImageList', iptrw);
    RegisterProperty('BackgroundGradientColor', 'TColor', iptrw);
    RegisterProperty('BackgroundGradientDirection', 'TGradientDirection', iptrw);
    RegisterProperty('Categories', 'TButtonCategories', iptrw);
    RegisterProperty('GradientDirection', 'TGradientDirection', iptrw);
    RegisterProperty('HotButtonColor', 'TColor', iptrw);
    RegisterProperty('OnAfterDrawButton', 'TCatButtonDrawEvent', iptrw);
    RegisterProperty('OnBeforeDrawButton', 'TCatButtonDrawEvent', iptrw);
    RegisterProperty('OnButtonClicked', 'TCatButtonEvent', iptrw);
    RegisterProperty('OnCategoryCollapase', 'TCategoryCollapseEvent', iptrw);
    RegisterProperty('OnClick', 'TNotifyEvent', iptrw);
    RegisterProperty('OnCopyButton', 'TCatButtonCopyEvent', iptrw);
    RegisterProperty('OnDrawButton', 'TCatButtonDrawEvent', iptrw);
    RegisterProperty('OnDrawIcon', 'TCatButtonDrawIconEvent', iptrw);
    RegisterProperty('OnDrawText', 'TCatButtonDrawEvent', iptrw);
    RegisterProperty('OnGetHint', 'TCatButtonGetHint', iptrw);
    RegisterProperty('OnHotButton', 'TCatButtonEvent', iptrw);
    RegisterProperty('OnReorderButton', 'TCatButtonReorderEvent', iptrw);
    RegisterProperty('OnReorderCategory', 'TCategoryReorderEvent', iptrw);
    RegisterProperty('OnSelectedItemChange', 'TCatButtonEvent', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_CategoryButtons(CL: TPSPascalCompiler);
begin
 CL.AddConstantN('crDragCopy','LongInt').SetInt( TCursor ( - 23 ));
  CL.AddClassN(CL.FindClass('TOBJECT'),'TBaseButtonItem');
  //CL.AddTypeS('TBaseButtonItemClass', 'class of TBaseButtonItem');
  CL.AddClassN(CL.FindClass('TOBJECT'),'TButtonItem');
  //CL.AddTypeS('TButtonItemClass', 'class of TButtonItem');
  CL.AddClassN(CL.FindClass('TOBJECT'),'TButtonCategory');
  //CL.AddTypeS('TButtonCategoryClass', 'class of TButtonCategory');
  CL.AddClassN(CL.FindClass('TOBJECT'),'TButtonCategories');
  //CL.AddTypeS('TButtonCategoriesClass', 'class of TButtonCategories');
  CL.AddClassN(CL.FindClass('TOBJECT'),'TButtonItemActionLink');
  //CL.AddTypeS('TButtonItemActionLinkClass', 'class of TButtonItemActionLink');
  CL.AddTypeS('TButtonDrawStates', {set of}'( bdsSelected, bdsHot, bdsFocused, bd'
   +'sDown, bdsDragged, bdsInsertLeft, bdsInsertTop, bdsInsertRight, bdsInsertBottom )');
  CL.AddTypeS('TButtonDrawState', 'set of TButtonDrawStates');
  CL.AddTypeS('TCatButtonOptions', '( boAllowReorder, boAllowCopyingButt'
   +'ons, boFullSize, boGradientFill, boShowCaptions, boVerticalCategoryCaption'
   +'s, boBoldCaptions, boUsePlusMinus, boCaptionOnlyBorder )');
  CL.AddTypeS('TCatButtonEvent', 'Procedure ( Sender : TObject; const Button: TButtonItem)');
  CL.AddTypeS('TCatButtonGetHint', 'Procedure ( Sender : TObject; const Button '
   +': TButtonItem; const Category : TButtonCategory; var HintStr : string; var Handled : Boolean)');
  CL.AddTypeS('TCatButtonDrawEvent', 'Procedure ( Sender : TObject; const Butto'
   +'n : TButtonItem; Canvas : TCanvas; Rect : TRect; State : TButtonDrawState)');
  CL.AddTypeS('TCatButtonDrawIconEvent', 'Procedure ( Sender : TObject; const B'
   +'utton : TButtonItem; Canvas : TCanvas; Rect : TRect; State : TButtonDrawSt'
   +'ate; var TextOffset : Integer)');
  CL.AddTypeS('TCatButtonReorderEvent', 'Procedure ( Sender : TObject; const Bu'
   +'tton : TButtonItem; const SourceCategory, TargetCategory : TButtonCategory)');
  CL.AddTypeS('TCatButtonCopyEvent', 'Procedure ( Sender : TObject; const Sourc'
   +'eButton, CopiedButton : TButtonItem)');
  CL.AddTypeS('TCategoryReorderEvent', 'Procedure ( Sender : TObject; const Sou'
   +'rceCategory, TargetCategory : TButtonCategory)');
  CL.AddTypeS('TCategoryCollapseEvent', 'Procedure (Sender:TObject; const Category: TButtonCategory)');
  CL.AddTypeS('TCatButtonFlow', '( cbfVertical, cbfHorizontal )');
  SIRegister_TCategoryButtons(CL);
  SIRegister_TBaseButtonItem(CL);
  SIRegister_TButtonItem(CL);
  SIRegister_TButtonCollection(CL);
  SIRegister_TButtonCategory(CL);
  SIRegister_TButtonCategories(CL);
  SIRegister_TButtonItemActionLink(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TButtonCategoriesButtonGroup_R(Self: TButtonCategories; var T: TCategoryButtons);
begin T := Self.ButtonGroup; end;

(*----------------------------------------------------------------------------*)
procedure TButtonCategoriesItems_W(Self: TButtonCategories; const T: TButtonCategory; const t1: Integer);
begin Self.Items[t1] := T; end;

(*----------------------------------------------------------------------------*)
procedure TButtonCategoriesItems_R(Self: TButtonCategories; var T: TButtonCategory; const t1: Integer);
begin T := Self.Items[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TButtonCategoryTextColor_W(Self: TButtonCategory; const T: TColor);
begin Self.TextColor := T; end;

(*----------------------------------------------------------------------------*)
procedure TButtonCategoryTextColor_R(Self: TButtonCategory; var T: TColor);
begin T := Self.TextColor; end;

(*----------------------------------------------------------------------------*)
procedure TButtonCategoryItems_W(Self: TButtonCategory; const T: TButtonCollection);
begin Self.Items := T; end;

(*----------------------------------------------------------------------------*)
procedure TButtonCategoryItems_R(Self: TButtonCategory; var T: TButtonCollection);
begin T := Self.Items; end;

(*----------------------------------------------------------------------------*)
procedure TButtonCategoryGradientColor_W(Self: TButtonCategory; const T: TColor);
begin Self.GradientColor := T; end;

(*----------------------------------------------------------------------------*)
procedure TButtonCategoryGradientColor_R(Self: TButtonCategory; var T: TColor);
begin T := Self.GradientColor; end;

(*----------------------------------------------------------------------------*)
procedure TButtonCategoryCollapsed_W(Self: TButtonCategory; const T: Boolean);
begin Self.Collapsed := T; end;

(*----------------------------------------------------------------------------*)
procedure TButtonCategoryCollapsed_R(Self: TButtonCategory; var T: Boolean);
begin T := Self.Collapsed; end;

(*----------------------------------------------------------------------------*)
procedure TButtonCategoryColor_W(Self: TButtonCategory; const T: TColor);
begin Self.Color := T; end;

(*----------------------------------------------------------------------------*)
procedure TButtonCategoryColor_R(Self: TButtonCategory; var T: TColor);
begin T := Self.Color; end;

(*----------------------------------------------------------------------------*)
procedure TButtonCategoryCaption_W(Self: TButtonCategory; const T: string);
begin Self.Caption := T; end;

(*----------------------------------------------------------------------------*)
procedure TButtonCategoryCaption_R(Self: TButtonCategory; var T: string);
begin T := Self.Caption; end;

(*----------------------------------------------------------------------------*)
procedure TButtonCategoryInterfaceData_W(Self: TButtonCategory; const T: IInterface);
begin Self.InterfaceData := T; end;

(*----------------------------------------------------------------------------*)
procedure TButtonCategoryInterfaceData_R(Self: TButtonCategory; var T: IInterface);
begin T := Self.InterfaceData; end;

(*----------------------------------------------------------------------------*)
procedure TButtonCategoryData_W(Self: TButtonCategory; const T: Pointer);
begin Self.Data := T; end;

(*----------------------------------------------------------------------------*)
procedure TButtonCategoryData_R(Self: TButtonCategory; var T: Pointer);
begin T := Self.Data; end;

(*----------------------------------------------------------------------------*)
procedure TButtonCategoryCategories_R(Self: TButtonCategory; var T: TButtonCategories);
begin T := Self.Categories; end;

(*----------------------------------------------------------------------------*)
procedure TButtonCollectionCategory_R(Self: TButtonCollection; var T: TButtonCategory);
begin T := Self.Category; end;

(*----------------------------------------------------------------------------*)
procedure TButtonCollectionItems_W(Self: TButtonCollection; const T: TButtonItem; const t1: Integer);
begin Self.Items[t1] := T; end;

(*----------------------------------------------------------------------------*)
procedure TButtonCollectionItems_R(Self: TButtonCollection; var T: TButtonItem; const t1: Integer);
begin T := Self.Items[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TButtonItemButtonGroup_R(Self: TButtonItem; var T: TCategoryButtons);
begin T := Self.ButtonGroup; end;

(*----------------------------------------------------------------------------*)
procedure TButtonItemCategory_R(Self: TButtonItem; var T: TButtonCategory);
begin T := Self.Category; end;

(*----------------------------------------------------------------------------*)
procedure TButtonItemInterfaceData_W(Self: TButtonItem; const T: IInterface);
begin Self.InterfaceData := T; end;

(*----------------------------------------------------------------------------*)
procedure TButtonItemInterfaceData_R(Self: TButtonItem; var T: IInterface);
begin T := Self.InterfaceData; end;

(*----------------------------------------------------------------------------*)
procedure TBaseButtonItemOnClick_W(Self: TBaseButtonItem; const T: TNotifyEvent);
begin Self.OnClick := T; end;

(*----------------------------------------------------------------------------*)
procedure TBaseButtonItemOnClick_R(Self: TBaseButtonItem; var T: TNotifyEvent);
begin T := Self.OnClick; end;

(*----------------------------------------------------------------------------*)
procedure TBaseButtonItemImageIndex_W(Self: TBaseButtonItem; const T: TImageIndex);
begin Self.ImageIndex := T; end;

(*----------------------------------------------------------------------------*)
procedure TBaseButtonItemImageIndex_R(Self: TBaseButtonItem; var T: TImageIndex);
begin T := Self.ImageIndex; end;

(*----------------------------------------------------------------------------*)
procedure TBaseButtonItemHint_W(Self: TBaseButtonItem; const T: string);
begin Self.Hint := T; end;

(*----------------------------------------------------------------------------*)
procedure TBaseButtonItemHint_R(Self: TBaseButtonItem; var T: string);
begin T := Self.Hint; end;

(*----------------------------------------------------------------------------*)
procedure TBaseButtonItemCaption_W(Self: TBaseButtonItem; const T: string);
begin Self.Caption := T; end;

(*----------------------------------------------------------------------------*)
procedure TBaseButtonItemCaption_R(Self: TBaseButtonItem; var T: string);
begin T := Self.Caption; end;

(*----------------------------------------------------------------------------*)
procedure TBaseButtonItemAction_W(Self: TBaseButtonItem; const T: TBasicAction);
begin Self.Action := T; end;

(*----------------------------------------------------------------------------*)
procedure TBaseButtonItemAction_R(Self: TBaseButtonItem; var T: TBasicAction);
begin T := Self.Action; end;

(*----------------------------------------------------------------------------*)
procedure TBaseButtonItemData_W(Self: TBaseButtonItem; const T: Pointer);
begin Self.Data := T; end;

(*----------------------------------------------------------------------------*)
procedure TBaseButtonItemData_R(Self: TBaseButtonItem; var T: Pointer);
begin T := Self.Data; end;

(*----------------------------------------------------------------------------*)
procedure TCategoryButtonsOnSelectedItemChange_W(Self: TCategoryButtons; const T: TCatButtonEvent);
begin Self.OnSelectedItemChange := T; end;

(*----------------------------------------------------------------------------*)
procedure TCategoryButtonsOnSelectedItemChange_R(Self: TCategoryButtons; var T: TCatButtonEvent);
begin T := Self.OnSelectedItemChange; end;

(*----------------------------------------------------------------------------*)
procedure TCategoryButtonsOnReorderCategory_W(Self: TCategoryButtons; const T: TCategoryReorderEvent);
begin Self.OnReorderCategory := T; end;

(*----------------------------------------------------------------------------*)
procedure TCategoryButtonsOnReorderCategory_R(Self: TCategoryButtons; var T: TCategoryReorderEvent);
begin T := Self.OnReorderCategory; end;

(*----------------------------------------------------------------------------*)
procedure TCategoryButtonsOnReorderButton_W(Self: TCategoryButtons; const T: TCatButtonReorderEvent);
begin Self.OnReorderButton := T; end;

(*----------------------------------------------------------------------------*)
procedure TCategoryButtonsOnReorderButton_R(Self: TCategoryButtons; var T: TCatButtonReorderEvent);
begin T := Self.OnReorderButton; end;

(*----------------------------------------------------------------------------*)
procedure TCategoryButtonsOnHotButton_W(Self: TCategoryButtons; const T: TCatButtonEvent);
begin Self.OnHotButton := T; end;

(*----------------------------------------------------------------------------*)
procedure TCategoryButtonsOnHotButton_R(Self: TCategoryButtons; var T: TCatButtonEvent);
begin T := Self.OnHotButton; end;

(*----------------------------------------------------------------------------*)
procedure TCategoryButtonsOnGetHint_W(Self: TCategoryButtons; const T: TCatButtonGetHint);
begin Self.OnGetHint := T; end;

(*----------------------------------------------------------------------------*)
procedure TCategoryButtonsOnGetHint_R(Self: TCategoryButtons; var T: TCatButtonGetHint);
begin T := Self.OnGetHint; end;

(*----------------------------------------------------------------------------*)
procedure TCategoryButtonsOnDrawText_W(Self: TCategoryButtons; const T: TCatButtonDrawEvent);
begin Self.OnDrawText := T; end;

(*----------------------------------------------------------------------------*)
procedure TCategoryButtonsOnDrawText_R(Self: TCategoryButtons; var T: TCatButtonDrawEvent);
begin T := Self.OnDrawText; end;

(*----------------------------------------------------------------------------*)
procedure TCategoryButtonsOnDrawIcon_W(Self: TCategoryButtons; const T: TCatButtonDrawIconEvent);
begin Self.OnDrawIcon := T; end;

(*----------------------------------------------------------------------------*)
procedure TCategoryButtonsOnDrawIcon_R(Self: TCategoryButtons; var T: TCatButtonDrawIconEvent);
begin T := Self.OnDrawIcon; end;

(*----------------------------------------------------------------------------*)
procedure TCategoryButtonsOnDrawButton_W(Self: TCategoryButtons; const T: TCatButtonDrawEvent);
begin Self.OnDrawButton := T; end;

(*----------------------------------------------------------------------------*)
procedure TCategoryButtonsOnDrawButton_R(Self: TCategoryButtons; var T: TCatButtonDrawEvent);
begin T := Self.OnDrawButton; end;

(*----------------------------------------------------------------------------*)
procedure TCategoryButtonsOnCopyButton_W(Self: TCategoryButtons; const T: TCatButtonCopyEvent);
begin Self.OnCopyButton := T; end;

(*----------------------------------------------------------------------------*)
procedure TCategoryButtonsOnCopyButton_R(Self: TCategoryButtons; var T: TCatButtonCopyEvent);
begin T := Self.OnCopyButton; end;

(*----------------------------------------------------------------------------*)
procedure TCategoryButtonsOnClick_W(Self: TCategoryButtons; const T: TNotifyEvent);
begin Self.OnClick := T; end;

(*----------------------------------------------------------------------------*)
procedure TCategoryButtonsOnClick_R(Self: TCategoryButtons; var T: TNotifyEvent);
begin T := Self.OnClick; end;

(*----------------------------------------------------------------------------*)
procedure TCategoryButtonsOnCategoryCollapase_W(Self: TCategoryButtons; const T: TCategoryCollapseEvent);
begin Self.OnCategoryCollapase := T; end;

(*----------------------------------------------------------------------------*)
procedure TCategoryButtonsOnCategoryCollapase_R(Self: TCategoryButtons; var T: TCategoryCollapseEvent);
begin T := Self.OnCategoryCollapase; end;

(*----------------------------------------------------------------------------*)
procedure TCategoryButtonsOnButtonClicked_W(Self: TCategoryButtons; const T: TCatButtonEvent);
begin Self.OnButtonClicked := T; end;

(*----------------------------------------------------------------------------*)
procedure TCategoryButtonsOnButtonClicked_R(Self: TCategoryButtons; var T: TCatButtonEvent);
begin T := Self.OnButtonClicked; end;

(*----------------------------------------------------------------------------*)
procedure TCategoryButtonsOnBeforeDrawButton_W(Self: TCategoryButtons; const T: TCatButtonDrawEvent);
begin Self.OnBeforeDrawButton := T; end;

(*----------------------------------------------------------------------------*)
procedure TCategoryButtonsOnBeforeDrawButton_R(Self: TCategoryButtons; var T: TCatButtonDrawEvent);
begin T := Self.OnBeforeDrawButton; end;

(*----------------------------------------------------------------------------*)
procedure TCategoryButtonsOnAfterDrawButton_W(Self: TCategoryButtons; const T: TCatButtonDrawEvent);
begin Self.OnAfterDrawButton := T; end;

(*----------------------------------------------------------------------------*)
procedure TCategoryButtonsOnAfterDrawButton_R(Self: TCategoryButtons; var T: TCatButtonDrawEvent);
begin T := Self.OnAfterDrawButton; end;

(*----------------------------------------------------------------------------*)
procedure TCategoryButtonsHotButtonColor_W(Self: TCategoryButtons; const T: TColor);
begin Self.HotButtonColor := T; end;

(*----------------------------------------------------------------------------*)
procedure TCategoryButtonsHotButtonColor_R(Self: TCategoryButtons; var T: TColor);
begin T := Self.HotButtonColor; end;

(*----------------------------------------------------------------------------*)
procedure TCategoryButtonsGradientDirection_W(Self: TCategoryButtons; const T: TGradientDirection);
begin Self.GradientDirection := T; end;

(*----------------------------------------------------------------------------*)
procedure TCategoryButtonsGradientDirection_R(Self: TCategoryButtons; var T: TGradientDirection);
begin T := Self.GradientDirection; end;

(*----------------------------------------------------------------------------*)
procedure TCategoryButtonsCategories_W(Self: TCategoryButtons; const T: TButtonCategories);
begin Self.Categories := T; end;

(*----------------------------------------------------------------------------*)
procedure TCategoryButtonsCategories_R(Self: TCategoryButtons; var T: TButtonCategories);
begin T := Self.Categories; end;

(*----------------------------------------------------------------------------*)
procedure TCategoryButtonsBackgroundGradientDirection_W(Self: TCategoryButtons; const T: TGradientDirection);
begin Self.BackgroundGradientDirection := T; end;

(*----------------------------------------------------------------------------*)
procedure TCategoryButtonsBackgroundGradientDirection_R(Self: TCategoryButtons; var T: TGradientDirection);
begin T := Self.BackgroundGradientDirection; end;

(*----------------------------------------------------------------------------*)
procedure TCategoryButtonsBackgroundGradientColor_W(Self: TCategoryButtons; const T: TColor);
begin Self.BackgroundGradientColor := T; end;

(*----------------------------------------------------------------------------*)
procedure TCategoryButtonsBackgroundGradientColor_R(Self: TCategoryButtons; var T: TColor);
begin T := Self.BackgroundGradientColor; end;

(*----------------------------------------------------------------------------*)
procedure TCategoryButtonsImages_W(Self: TCategoryButtons; const T: TCustomImageList);
begin Self.Images := T; end;

(*----------------------------------------------------------------------------*)
procedure TCategoryButtonsImages_R(Self: TCategoryButtons; var T: TCustomImageList);
begin T := Self.Images; end;

(*----------------------------------------------------------------------------*)
procedure TCategoryButtonsButtonOptions_W(Self: TCategoryButtons; const T: TCatButtonOptions);
begin Self.ButtonOptions := T; end;

(*----------------------------------------------------------------------------*)
procedure TCategoryButtonsButtonOptions_R(Self: TCategoryButtons; var T: TCatButtonOptions);
begin T := Self.ButtonOptions; end;

(*----------------------------------------------------------------------------*)
procedure TCategoryButtonsButtonWidth_W(Self: TCategoryButtons; const T: Integer);
begin Self.ButtonWidth := T; end;

(*----------------------------------------------------------------------------*)
procedure TCategoryButtonsButtonWidth_R(Self: TCategoryButtons; var T: Integer);
begin T := Self.ButtonWidth; end;

(*----------------------------------------------------------------------------*)
procedure TCategoryButtonsButtonHeight_W(Self: TCategoryButtons; const T: Integer);
begin Self.ButtonHeight := T; end;

(*----------------------------------------------------------------------------*)
procedure TCategoryButtonsButtonHeight_R(Self: TCategoryButtons; var T: Integer);
begin T := Self.ButtonHeight; end;

(*----------------------------------------------------------------------------*)
procedure TCategoryButtonsButtonFlow_W(Self: TCategoryButtons; const T: TCatButtonFlow);
begin Self.ButtonFlow := T; end;

(*----------------------------------------------------------------------------*)
procedure TCategoryButtonsButtonFlow_R(Self: TCategoryButtons; var T: TCatButtonFlow);
begin T := Self.ButtonFlow; end;

(*----------------------------------------------------------------------------*)
procedure TCategoryButtonsBorderStyle_W(Self: TCategoryButtons; const T: TBorderStyle);
begin Self.BorderStyle := T; end;

(*----------------------------------------------------------------------------*)
procedure TCategoryButtonsBorderStyle_R(Self: TCategoryButtons; var T: TBorderStyle);
begin T := Self.BorderStyle; end;

(*----------------------------------------------------------------------------*)
procedure TCategoryButtonsFocusedItem_W(Self: TCategoryButtons; const T: TButtonItem);
begin Self.FocusedItem := T; end;

(*----------------------------------------------------------------------------*)
procedure TCategoryButtonsFocusedItem_R(Self: TCategoryButtons; var T: TButtonItem);
begin T := Self.FocusedItem; end;

(*----------------------------------------------------------------------------*)
procedure TCategoryButtonsSelectedItem_W(Self: TCategoryButtons; const T: TButtonItem);
begin Self.SelectedItem := T; end;

(*----------------------------------------------------------------------------*)
procedure TCategoryButtonsSelectedItem_R(Self: TCategoryButtons; var T: TButtonItem);
begin T := Self.SelectedItem; end;

(*----------------------------------------------------------------------------*)
Procedure TCategoryButtonsScrollIntoView1_P(Self: TCategoryButtons;  const Category : TButtonCategory);
Begin Self.ScrollIntoView(Category); END;

(*----------------------------------------------------------------------------*)
Procedure TCategoryButtonsScrollIntoView_P(Self: TCategoryButtons;  const Button : TButtonItem);
Begin Self.ScrollIntoView(Button); END;

(*----------------------------------------------------------------------------*)
procedure TCategoryButtonsDragImageList_R(Self: TCategoryButtons; var T: TDragImageList);
begin T := Self.DragImageList; end;

(*----------------------------------------------------------------------------*)
procedure TCategoryButtonsDragCategory_W(Self: TCategoryButtons; const T: TButtonCategory);
begin Self.DragCategory := T; end;

(*----------------------------------------------------------------------------*)
procedure TCategoryButtonsDragCategory_R(Self: TCategoryButtons; var T: TButtonCategory);
begin T := Self.DragCategory; end;

(*----------------------------------------------------------------------------*)
procedure TCategoryButtonsDragButton_W(Self: TCategoryButtons; const T: TButtonItem);
begin Self.DragButton := T; end;

(*----------------------------------------------------------------------------*)
procedure TCategoryButtonsDragButton_R(Self: TCategoryButtons; var T: TButtonItem);
begin T := Self.DragButton; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TButtonItemActionLink(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TButtonItemActionLink) do
  begin
    RegisterVirtualMethod(@TButtonItemActionLink.DoShowHint, 'DoShowHint');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TButtonCategories(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TButtonCategories) do begin
    RegisterConstructor(@TButtonCategories.Create, 'Create');
      RegisterMethod(@TButtonCategories.Free, 'Free');
     RegisterMethod(@TButtonCategories.Add, 'Add');
    RegisterMethod(@TButtonCategories.AddItem, 'AddItem');
    RegisterMethod(@TButtonCategories.Insert, 'Insert');
    RegisterMethod(@TButtonCategories.IndexOf, 'IndexOf');
    RegisterPropertyHelper(@TButtonCategoriesItems_R,@TButtonCategoriesItems_W,'Items');
    RegisterPropertyHelper(@TButtonCategoriesButtonGroup_R,nil,'ButtonGroup');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TButtonCategory(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TButtonCategory) do begin
    RegisterConstructor(@TButtonCategory.Create, 'Create');
          RegisterMethod(@TButtonCategory.Free, 'Free');
    RegisterMethod(@TButtonCategory.ScrollIntoView, 'ScrollIntoView');
    RegisterMethod(@TButtonCategory.IndexOf, 'IndexOf');
    RegisterPropertyHelper(@TButtonCategoryCategories_R,nil,'Categories');
    RegisterPropertyHelper(@TButtonCategoryData_R,@TButtonCategoryData_W,'Data');
    RegisterPropertyHelper(@TButtonCategoryInterfaceData_R,@TButtonCategoryInterfaceData_W,'InterfaceData');
    RegisterMethod(@TButtonCategory.Assign, 'Assign');
    RegisterPropertyHelper(@TButtonCategoryCaption_R,@TButtonCategoryCaption_W,'Caption');
    RegisterPropertyHelper(@TButtonCategoryColor_R,@TButtonCategoryColor_W,'Color');
    RegisterPropertyHelper(@TButtonCategoryCollapsed_R,@TButtonCategoryCollapsed_W,'Collapsed');
    RegisterPropertyHelper(@TButtonCategoryGradientColor_R,@TButtonCategoryGradientColor_W,'GradientColor');
    RegisterPropertyHelper(@TButtonCategoryItems_R,@TButtonCategoryItems_W,'Items');
    RegisterPropertyHelper(@TButtonCategoryTextColor_R,@TButtonCategoryTextColor_W,'TextColor');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TButtonCollection(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TButtonCollection) do begin
    RegisterConstructor(@TButtonCollection.Create, 'Create');
          RegisterMethod(@TButtonCollection.Free, 'Free');
    RegisterMethod(@TButtonCollection.Add, 'Add');
    RegisterMethod(@TButtonCollection.AddItem, 'AddItem');
    RegisterMethod(@TButtonCollection.Insert, 'Insert');
    RegisterPropertyHelper(@TButtonCollectionItems_R,@TButtonCollectionItems_W,'Items');
    RegisterPropertyHelper(@TButtonCollectionCategory_R,nil,'Category');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TButtonItem(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TButtonItem) do begin
    RegisterPropertyHelper(@TButtonItemInterfaceData_R,@TButtonItemInterfaceData_W,'InterfaceData');
    RegisterPropertyHelper(@TButtonItemCategory_R,nil,'Category');
    RegisterPropertyHelper(@TButtonItemButtonGroup_R,nil,'ButtonGroup');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TBaseButtonItem(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TBaseButtonItem) do begin
    RegisterConstructor(@TBaseButtonItem.Create, 'Create');
       RegisterMethod(@TBaseButtonItem.Free, 'Free');
    RegisterMethod(@TBaseButtonItem.Assign, 'Assign');
    RegisterPropertyHelper(@TBaseButtonItemData_R,@TBaseButtonItemData_W,'Data');
    //((RegisterVirtualAbstractMethod(@TBaseButtonItem, @!.ScrollIntoView, 'ScrollIntoView');
    RegisterPropertyHelper(@TBaseButtonItemAction_R,@TBaseButtonItemAction_W,'Action');
    RegisterPropertyHelper(@TBaseButtonItemCaption_R,@TBaseButtonItemCaption_W,'Caption');
    RegisterPropertyHelper(@TBaseButtonItemHint_R,@TBaseButtonItemHint_W,'Hint');
    RegisterPropertyHelper(@TBaseButtonItemImageIndex_R,@TBaseButtonItemImageIndex_W,'ImageIndex');
    RegisterPropertyHelper(@TBaseButtonItemOnClick_R,@TBaseButtonItemOnClick_W,'OnClick');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TCategoryButtons(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TCategoryButtons) do begin
    RegisterConstructor(@TCategoryButtons.Create, 'Create');
       RegisterMethod(@TCategoryButtons.Free, 'Free');
     RegisterMethod(@TCategoryButtons.Assign, 'Assign');
    RegisterPropertyHelper(@TCategoryButtonsDragButton_R,@TCategoryButtonsDragButton_W,'DragButton');
    RegisterPropertyHelper(@TCategoryButtonsDragCategory_R,@TCategoryButtonsDragCategory_W,'DragCategory');
    RegisterPropertyHelper(@TCategoryButtonsDragImageList_R,nil,'DragImageList');
    RegisterMethod(@TCategoryButtons.DragDrop, 'DragDrop');
    RegisterMethod(@TCategoryButtons.GenerateDragImage, 'GenerateDragImage');
    RegisterMethod(@TCategoryButtons.GetButtonRect, 'GetButtonRect');
    RegisterMethod(@TCategoryButtons.GetCategoryRect, 'GetCategoryRect');
    RegisterMethod(@TCategoryButtons.GetButtonAt, 'GetButtonAt');
    RegisterMethod(@TCategoryButtons.GetCategoryAt, 'GetCategoryAt');
    RegisterMethod(@TCategoryButtons.RemoveInsertionPoints, 'RemoveInsertionPoints');
    RegisterMethod(@TCategoryButtonsScrollIntoView_P, 'ScrollIntoView');
    RegisterMethod(@TCategoryButtonsScrollIntoView1_P, 'ScrollIntoView1');
    RegisterMethod(@TCategoryButtons.SetInsertionButton, 'SetInsertionButton');
    RegisterMethod(@TCategoryButtons.GetTargetAt, 'GetTargetAt');
    RegisterMethod(@TCategoryButtons.UpdateButton, 'UpdateButton');
    RegisterMethod(@TCategoryButtons.UpdateAllButtons, 'UpdateAllButtons');
    RegisterPropertyHelper(@TCategoryButtonsSelectedItem_R,@TCategoryButtonsSelectedItem_W,'SelectedItem');
    RegisterPropertyHelper(@TCategoryButtonsFocusedItem_R,@TCategoryButtonsFocusedItem_W,'FocusedItem');
    RegisterPropertyHelper(@TCategoryButtonsBorderStyle_R,@TCategoryButtonsBorderStyle_W,'BorderStyle');
    RegisterPropertyHelper(@TCategoryButtonsButtonFlow_R,@TCategoryButtonsButtonFlow_W,'ButtonFlow');
    RegisterPropertyHelper(@TCategoryButtonsButtonHeight_R,@TCategoryButtonsButtonHeight_W,'ButtonHeight');
    RegisterPropertyHelper(@TCategoryButtonsButtonWidth_R,@TCategoryButtonsButtonWidth_W,'ButtonWidth');
    RegisterPropertyHelper(@TCategoryButtonsButtonOptions_R,@TCategoryButtonsButtonOptions_W,'ButtonOptions');
    RegisterPropertyHelper(@TCategoryButtonsImages_R,@TCategoryButtonsImages_W,'Images');
    RegisterPropertyHelper(@TCategoryButtonsBackgroundGradientColor_R,@TCategoryButtonsBackgroundGradientColor_W,'BackgroundGradientColor');
    RegisterPropertyHelper(@TCategoryButtonsBackgroundGradientDirection_R,@TCategoryButtonsBackgroundGradientDirection_W,'BackgroundGradientDirection');
    RegisterPropertyHelper(@TCategoryButtonsCategories_R,@TCategoryButtonsCategories_W,'Categories');
    RegisterPropertyHelper(@TCategoryButtonsGradientDirection_R,@TCategoryButtonsGradientDirection_W,'GradientDirection');
    RegisterPropertyHelper(@TCategoryButtonsHotButtonColor_R,@TCategoryButtonsHotButtonColor_W,'HotButtonColor');
    RegisterPropertyHelper(@TCategoryButtonsOnAfterDrawButton_R,@TCategoryButtonsOnAfterDrawButton_W,'OnAfterDrawButton');
    RegisterPropertyHelper(@TCategoryButtonsOnBeforeDrawButton_R,@TCategoryButtonsOnBeforeDrawButton_W,'OnBeforeDrawButton');
    RegisterPropertyHelper(@TCategoryButtonsOnButtonClicked_R,@TCategoryButtonsOnButtonClicked_W,'OnButtonClicked');
    RegisterPropertyHelper(@TCategoryButtonsOnCategoryCollapase_R,@TCategoryButtonsOnCategoryCollapase_W,'OnCategoryCollapase');
    RegisterPropertyHelper(@TCategoryButtonsOnClick_R,@TCategoryButtonsOnClick_W,'OnClick');
    RegisterPropertyHelper(@TCategoryButtonsOnCopyButton_R,@TCategoryButtonsOnCopyButton_W,'OnCopyButton');
    RegisterPropertyHelper(@TCategoryButtonsOnDrawButton_R,@TCategoryButtonsOnDrawButton_W,'OnDrawButton');
    RegisterPropertyHelper(@TCategoryButtonsOnDrawIcon_R,@TCategoryButtonsOnDrawIcon_W,'OnDrawIcon');
    RegisterPropertyHelper(@TCategoryButtonsOnDrawText_R,@TCategoryButtonsOnDrawText_W,'OnDrawText');
    RegisterPropertyHelper(@TCategoryButtonsOnGetHint_R,@TCategoryButtonsOnGetHint_W,'OnGetHint');
    RegisterPropertyHelper(@TCategoryButtonsOnHotButton_R,@TCategoryButtonsOnHotButton_W,'OnHotButton');
    RegisterPropertyHelper(@TCategoryButtonsOnReorderButton_R,@TCategoryButtonsOnReorderButton_W,'OnReorderButton');
    RegisterPropertyHelper(@TCategoryButtonsOnReorderCategory_R,@TCategoryButtonsOnReorderCategory_W,'OnReorderCategory');
    RegisterPropertyHelper(@TCategoryButtonsOnSelectedItemChange_R,@TCategoryButtonsOnSelectedItemChange_W,'OnSelectedItemChange');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_CategoryButtons(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TBaseButtonItem) do
  with CL.Add(TButtonItem) do
  with CL.Add(TButtonCategory) do
  with CL.Add(TButtonCategories) do
  with CL.Add(TButtonItemActionLink) do
  RIRegister_TCategoryButtons(CL);
  RIRegister_TBaseButtonItem(CL);
  RIRegister_TButtonItem(CL);
  RIRegister_TButtonCollection(CL);
  RIRegister_TButtonCategory(CL);
  RIRegister_TButtonCategories(CL);
  RIRegister_TButtonItemActionLink(CL);
end;

 
 
{ TPSImport_CategoryButtons }
(*----------------------------------------------------------------------------*)
procedure TPSImport_CategoryButtons.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_CategoryButtons(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_CategoryButtons.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_CategoryButtons(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
