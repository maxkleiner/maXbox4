unit uPSI_ButtonGroup;
{
   more buttons and controls  , needs category buttons
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
  TPSImport_ButtonGroup = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TGrpButtonItems(CL: TPSPascalCompiler);
procedure SIRegister_TGrpButtonItem(CL: TPSPascalCompiler);
procedure SIRegister_TButtonGroup(CL: TPSPascalCompiler);
procedure SIRegister_ButtonGroup(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TGrpButtonItems(CL: TPSRuntimeClassImporter);
procedure RIRegister_TGrpButtonItem(CL: TPSRuntimeClassImporter);
procedure RIRegister_TButtonGroup(CL: TPSRuntimeClassImporter);
procedure RIRegister_ButtonGroup(CL: TPSRuntimeClassImporter);

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
  ,CategoryButtons
  ,ButtonGroup
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_ButtonGroup]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TGrpButtonItems(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TCollection', 'TGrpButtonItems') do
  with CL.AddClassN(CL.FindClass('TCollection'),'TGrpButtonItems') do begin
    RegisterMethod('Constructor Create( const ButtonGroup : TButtonGroup)');
    RegisterMethod('Function Add : TGrpButtonItem');
    RegisterMethod('Function AddItem( Item : TGrpButtonItem; Index : Integer) : TGrpButtonItem');
    RegisterMethod('Procedure BeginUpdate');
    RegisterMethod('Function Insert( Index : Integer) : TGrpButtonItem');
    RegisterProperty('Items', 'TGrpButtonItem Integer', iptrw);
    SetDefaultPropery('Items');
    RegisterProperty('ButtonGroup', 'TButtonGroup', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TGrpButtonItem(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TBaseButtonItem', 'TGrpButtonItem') do
  with CL.AddClassN(CL.FindClass('TBaseButtonItem'),'TGrpButtonItem') do begin
    RegisterProperty('Collection', 'TGrpButtonItems', iptrw);
    RegisterProperty('ButtonGroup', 'TButtonGroup', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TButtonGroup(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TCustomControl', 'TButtonGroup') do
  with CL.AddClassN(CL.FindClass('TCustomControl'),'TButtonGroup') do begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
      RegisterMethod('Procedure Free');
     RegisterMethod('Procedure Assign( Source : TPersistent)');
    RegisterProperty('DragIndex', 'Integer', iptrw);
    RegisterProperty('DragImageList', 'TDragImageList', iptr);
    RegisterMethod('Function GetButtonRect( const Index : Integer) : TRect');
    RegisterMethod('Function IndexOfButtonAt( const X, Y : Integer) : Integer');
    RegisterMethod('Procedure RemoveInsertionPoints');
    RegisterMethod('Procedure ScrollIntoView( const Index : Integer)');
    RegisterMethod('Procedure SetInsertionPoints( const InsertionIndex : Integer)');
    RegisterMethod('Function TargetIndexAt( const X, Y : Integer) : Integer');
    RegisterProperty('BorderStyle', 'TBorderStyle', iptrw);
    RegisterProperty('ButtonHeight', 'Integer', iptrw);
    RegisterProperty('ButtonWidth', 'Integer', iptrw);
    RegisterProperty('ButtonOptions', 'TGrpButtonOptions', iptrw);
    RegisterProperty('Images', 'TCustomImageList', iptrw);
    RegisterProperty('Items', 'TGrpButtonItems', iptrw);
    RegisterProperty('ItemIndex', 'Integer', iptrw);
    RegisterProperty('OnButtonClicked', 'TGrpButtonEvent', iptrw);
    RegisterProperty('OnClick', 'TNotifyEvent', iptrw);
    RegisterProperty('OnHotButton', 'TGrpButtonEvent', iptrw);
    RegisterProperty('OnAfterDrawButton', 'TGrpButtonDrawEvent', iptrw);
    RegisterProperty('OnBeforeDrawButton', 'TGrpButtonDrawEvent', iptrw);
    RegisterProperty('OnDrawButton', 'TGrpButtonDrawEvent', iptrw);
    RegisterProperty('OnDrawIcon', 'TGrpButtonDrawIconEvent', iptrw);
    RegisterProperty('OnReorderButton', 'TGrpButtonReorderEvent', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_ButtonGroup(CL: TPSPascalCompiler);
begin
  CL.AddClassN(CL.FindClass('TOBJECT'),'TGrpButtonItem');
  //CL.AddTypeS('TGrpButtonItemClass', 'class of TGrpButtonItem');
  CL.AddClassN(CL.FindClass('TOBJECT'),'TGrpButtonItems');
  //CL.AddTypeS('TGrpButtonItemsClass', 'class of TGrpButtonItems');
  CL.AddTypeS('TGrpButtonOption', '(gboAllowReorder, gboFullSize, gboGroupStyle, gboShowCaptions )');
  CL.AddTypeS('TGrpButtonOptions', 'set of TGrpButtonOption');
  CL.AddTypeS('TGrpButtonEvent', 'Procedure ( Sender : TObject; Index : Integer)');
  CL.AddTypeS('TGrpButtonDrawEvent', 'Procedure ( Sender : TObject; Index : Int'
   +'eger; Canvas : TCanvas; Rect : TRect; State : TButtonDrawState)');
  CL.AddTypeS('TGrpButtonDrawIconEvent', 'Procedure ( Sender : TObject; Index :'
   +' Integer; Canvas : TCanvas; Rect : TRect; State : TButtonDrawState; var Te'
   +'xtOffset : Integer)');
  CL.AddTypeS('TGrpButtonReorderEvent', 'Procedure ( Sender : TObject; OldIndex, NewIndex : Integer)');
  SIRegister_TButtonGroup(CL);
  SIRegister_TGrpButtonItem(CL);
  SIRegister_TGrpButtonItems(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TGrpButtonItemsButtonGroup_R(Self: TGrpButtonItems; var T: TButtonGroup);
begin T := Self.ButtonGroup; end;

(*----------------------------------------------------------------------------*)
procedure TGrpButtonItemsItems_W(Self: TGrpButtonItems; const T: TGrpButtonItem; const t1: Integer);
begin Self.Items[t1] := T; end;

(*----------------------------------------------------------------------------*)
procedure TGrpButtonItemsItems_R(Self: TGrpButtonItems; var T: TGrpButtonItem; const t1: Integer);
begin T := Self.Items[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TGrpButtonItemButtonGroup_R(Self: TGrpButtonItem; var T: TButtonGroup);
begin T := Self.ButtonGroup; end;

(*----------------------------------------------------------------------------*)
procedure TGrpButtonItemCollection_W(Self: TGrpButtonItem; const T: TGrpButtonItems);
begin Self.Collection := T; end;

(*----------------------------------------------------------------------------*)
procedure TGrpButtonItemCollection_R(Self: TGrpButtonItem; var T: TGrpButtonItems);
begin T := Self.Collection; end;

(*----------------------------------------------------------------------------*)
procedure TButtonGroupOnReorderButton_W(Self: TButtonGroup; const T: TGrpButtonReorderEvent);
begin Self.OnReorderButton := T; end;

(*----------------------------------------------------------------------------*)
procedure TButtonGroupOnReorderButton_R(Self: TButtonGroup; var T: TGrpButtonReorderEvent);
begin T := Self.OnReorderButton; end;

(*----------------------------------------------------------------------------*)
procedure TButtonGroupOnDrawIcon_W(Self: TButtonGroup; const T: TGrpButtonDrawIconEvent);
begin Self.OnDrawIcon := T; end;

(*----------------------------------------------------------------------------*)
procedure TButtonGroupOnDrawIcon_R(Self: TButtonGroup; var T: TGrpButtonDrawIconEvent);
begin T := Self.OnDrawIcon; end;

(*----------------------------------------------------------------------------*)
procedure TButtonGroupOnDrawButton_W(Self: TButtonGroup; const T: TGrpButtonDrawEvent);
begin Self.OnDrawButton := T; end;

(*----------------------------------------------------------------------------*)
procedure TButtonGroupOnDrawButton_R(Self: TButtonGroup; var T: TGrpButtonDrawEvent);
begin T := Self.OnDrawButton; end;

(*----------------------------------------------------------------------------*)
procedure TButtonGroupOnBeforeDrawButton_W(Self: TButtonGroup; const T: TGrpButtonDrawEvent);
begin Self.OnBeforeDrawButton := T; end;

(*----------------------------------------------------------------------------*)
procedure TButtonGroupOnBeforeDrawButton_R(Self: TButtonGroup; var T: TGrpButtonDrawEvent);
begin T := Self.OnBeforeDrawButton; end;

(*----------------------------------------------------------------------------*)
procedure TButtonGroupOnAfterDrawButton_W(Self: TButtonGroup; const T: TGrpButtonDrawEvent);
begin Self.OnAfterDrawButton := T; end;

(*----------------------------------------------------------------------------*)
procedure TButtonGroupOnAfterDrawButton_R(Self: TButtonGroup; var T: TGrpButtonDrawEvent);
begin T := Self.OnAfterDrawButton; end;

(*----------------------------------------------------------------------------*)
procedure TButtonGroupOnHotButton_W(Self: TButtonGroup; const T: TGrpButtonEvent);
begin Self.OnHotButton := T; end;

(*----------------------------------------------------------------------------*)
procedure TButtonGroupOnHotButton_R(Self: TButtonGroup; var T: TGrpButtonEvent);
begin T := Self.OnHotButton; end;

(*----------------------------------------------------------------------------*)
procedure TButtonGroupOnClick_W(Self: TButtonGroup; const T: TNotifyEvent);
begin Self.OnClick := T; end;

(*----------------------------------------------------------------------------*)
procedure TButtonGroupOnClick_R(Self: TButtonGroup; var T: TNotifyEvent);
begin T := Self.OnClick; end;

(*----------------------------------------------------------------------------*)
procedure TButtonGroupOnButtonClicked_W(Self: TButtonGroup; const T: TGrpButtonEvent);
begin Self.OnButtonClicked := T; end;

(*----------------------------------------------------------------------------*)
procedure TButtonGroupOnButtonClicked_R(Self: TButtonGroup; var T: TGrpButtonEvent);
begin T := Self.OnButtonClicked; end;

(*----------------------------------------------------------------------------*)
procedure TButtonGroupItemIndex_W(Self: TButtonGroup; const T: Integer);
begin Self.ItemIndex := T; end;

(*----------------------------------------------------------------------------*)
procedure TButtonGroupItemIndex_R(Self: TButtonGroup; var T: Integer);
begin T := Self.ItemIndex; end;

(*----------------------------------------------------------------------------*)
procedure TButtonGroupItems_W(Self: TButtonGroup; const T: TGrpButtonItems);
begin Self.Items := T; end;

(*----------------------------------------------------------------------------*)
procedure TButtonGroupItems_R(Self: TButtonGroup; var T: TGrpButtonItems);
begin T := Self.Items; end;

(*----------------------------------------------------------------------------*)
procedure TButtonGroupImages_W(Self: TButtonGroup; const T: TCustomImageList);
begin Self.Images := T; end;

(*----------------------------------------------------------------------------*)
procedure TButtonGroupImages_R(Self: TButtonGroup; var T: TCustomImageList);
begin T := Self.Images; end;

(*----------------------------------------------------------------------------*)
procedure TButtonGroupButtonOptions_W(Self: TButtonGroup; const T: TGrpButtonOptions);
begin Self.ButtonOptions := T; end;

(*----------------------------------------------------------------------------*)
procedure TButtonGroupButtonOptions_R(Self: TButtonGroup; var T: TGrpButtonOptions);
begin T := Self.ButtonOptions; end;

(*----------------------------------------------------------------------------*)
procedure TButtonGroupButtonWidth_W(Self: TButtonGroup; const T: Integer);
begin Self.ButtonWidth := T; end;

(*----------------------------------------------------------------------------*)
procedure TButtonGroupButtonWidth_R(Self: TButtonGroup; var T: Integer);
begin T := Self.ButtonWidth; end;

(*----------------------------------------------------------------------------*)
procedure TButtonGroupButtonHeight_W(Self: TButtonGroup; const T: Integer);
begin Self.ButtonHeight := T; end;

(*----------------------------------------------------------------------------*)
procedure TButtonGroupButtonHeight_R(Self: TButtonGroup; var T: Integer);
begin T := Self.ButtonHeight; end;

(*----------------------------------------------------------------------------*)
procedure TButtonGroupBorderStyle_W(Self: TButtonGroup; const T: TBorderStyle);
begin Self.BorderStyle := T; end;

(*----------------------------------------------------------------------------*)
procedure TButtonGroupBorderStyle_R(Self: TButtonGroup; var T: TBorderStyle);
begin T := Self.BorderStyle; end;

(*----------------------------------------------------------------------------*)
procedure TButtonGroupDragImageList_R(Self: TButtonGroup; var T: TDragImageList);
begin T := Self.DragImageList; end;

(*----------------------------------------------------------------------------*)
procedure TButtonGroupDragIndex_W(Self: TButtonGroup; const T: Integer);
begin Self.DragIndex := T; end;

(*----------------------------------------------------------------------------*)
procedure TButtonGroupDragIndex_R(Self: TButtonGroup; var T: Integer);
begin T := Self.DragIndex; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TGrpButtonItems(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TGrpButtonItems) do begin
    RegisterConstructor(@TGrpButtonItems.Create, 'Create');
    RegisterMethod(@TGrpButtonItems.Add, 'Add');
    RegisterMethod(@TGrpButtonItems.AddItem, 'AddItem');
    RegisterMethod(@TGrpButtonItems.BeginUpdate, 'BeginUpdate');
    RegisterMethod(@TGrpButtonItems.Insert, 'Insert');
    RegisterPropertyHelper(@TGrpButtonItemsItems_R,@TGrpButtonItemsItems_W,'Items');
    RegisterPropertyHelper(@TGrpButtonItemsButtonGroup_R,nil,'ButtonGroup');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TGrpButtonItem(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TGrpButtonItem) do begin
    RegisterPropertyHelper(@TGrpButtonItemCollection_R,@TGrpButtonItemCollection_W,'Collection');
    RegisterPropertyHelper(@TGrpButtonItemButtonGroup_R,nil,'ButtonGroup');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TButtonGroup(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TButtonGroup) do begin
    RegisterConstructor(@TButtonGroup.Create, 'Create');
    RegisterMethod(@TButtonGroup.Free, 'Free');
     RegisterMethod(@TButtonGroup.Assign, 'Assign');
    RegisterPropertyHelper(@TButtonGroupDragIndex_R,@TButtonGroupDragIndex_W,'DragIndex');
    RegisterPropertyHelper(@TButtonGroupDragImageList_R,nil,'DragImageList');
    RegisterMethod(@TButtonGroup.GetButtonRect, 'GetButtonRect');
    RegisterMethod(@TButtonGroup.IndexOfButtonAt, 'IndexOfButtonAt');
    RegisterMethod(@TButtonGroup.RemoveInsertionPoints, 'RemoveInsertionPoints');
    RegisterMethod(@TButtonGroup.ScrollIntoView, 'ScrollIntoView');
    RegisterMethod(@TButtonGroup.SetInsertionPoints, 'SetInsertionPoints');
    RegisterMethod(@TButtonGroup.TargetIndexAt, 'TargetIndexAt');
    RegisterPropertyHelper(@TButtonGroupBorderStyle_R,@TButtonGroupBorderStyle_W,'BorderStyle');
    RegisterPropertyHelper(@TButtonGroupButtonHeight_R,@TButtonGroupButtonHeight_W,'ButtonHeight');
    RegisterPropertyHelper(@TButtonGroupButtonWidth_R,@TButtonGroupButtonWidth_W,'ButtonWidth');
    RegisterPropertyHelper(@TButtonGroupButtonOptions_R,@TButtonGroupButtonOptions_W,'ButtonOptions');
    RegisterPropertyHelper(@TButtonGroupImages_R,@TButtonGroupImages_W,'Images');
    RegisterPropertyHelper(@TButtonGroupItems_R,@TButtonGroupItems_W,'Items');
    RegisterPropertyHelper(@TButtonGroupItemIndex_R,@TButtonGroupItemIndex_W,'ItemIndex');
    RegisterPropertyHelper(@TButtonGroupOnButtonClicked_R,@TButtonGroupOnButtonClicked_W,'OnButtonClicked');
    RegisterPropertyHelper(@TButtonGroupOnClick_R,@TButtonGroupOnClick_W,'OnClick');
    RegisterPropertyHelper(@TButtonGroupOnHotButton_R,@TButtonGroupOnHotButton_W,'OnHotButton');
    RegisterPropertyHelper(@TButtonGroupOnAfterDrawButton_R,@TButtonGroupOnAfterDrawButton_W,'OnAfterDrawButton');
    RegisterPropertyHelper(@TButtonGroupOnBeforeDrawButton_R,@TButtonGroupOnBeforeDrawButton_W,'OnBeforeDrawButton');
    RegisterPropertyHelper(@TButtonGroupOnDrawButton_R,@TButtonGroupOnDrawButton_W,'OnDrawButton');
    RegisterPropertyHelper(@TButtonGroupOnDrawIcon_R,@TButtonGroupOnDrawIcon_W,'OnDrawIcon');
    RegisterPropertyHelper(@TButtonGroupOnReorderButton_R,@TButtonGroupOnReorderButton_W,'OnReorderButton');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_ButtonGroup(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TGrpButtonItem) do
  with CL.Add(TGrpButtonItems) do
  RIRegister_TButtonGroup(CL);
  RIRegister_TGrpButtonItem(CL);
  RIRegister_TGrpButtonItems(CL);
end;

 
 
{ TPSImport_ButtonGroup }
(*----------------------------------------------------------------------------*)
procedure TPSImport_ButtonGroup.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_ButtonGroup(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_ButtonGroup.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_ButtonGroup(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
