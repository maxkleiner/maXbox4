
unit uPSR_controls;

{$I PascalScript.inc}
interface
uses
  uPSRuntime, uPSUtils;

  //more handlers and constructors
  //color2 hack  + ReplaceDockedControl   4.7.1




procedure RIRegisterTControl(Cl: TPSRuntimeClassImporter);
procedure RIRegisterTWinControl(Cl: TPSRuntimeClassImporter);
procedure RIRegisterTGraphicControl(cl: TPSRuntimeClassImporter);
procedure RIRegisterTCustomControl(cl: TPSRuntimeClassImporter);
procedure RIRegister_TDragObject(CL: TPSRuntimeClassImporter);

procedure RIRegister_Controls(Cl: TPSRuntimeClassImporter);    //main call
procedure RIRegister_TImageList(CL: TPSRuntimeClassImporter);      //3.9.3
procedure RIRegister_TDragImageList(CL: TPSRuntimeClassImporter);
procedure RIRegister_Controls_Routines(S: TPSExec);
procedure RIRegister_TMouse(CL: TPSRuntimeClassImporter);

procedure RIRegister_TCustomMultiSelectListControl(CL: TPSRuntimeClassImporter);
procedure RIRegister_TCustomListControl(CL: TPSRuntimeClassImporter);
procedure RIRegister_TCustomPanningWindow(CL: TPSRuntimeClassImporter);
procedure RIRegister_THintWindow(CL: TPSRuntimeClassImporter);
procedure RIRegister_TCustomTransparentControl(CL: TPSRuntimeClassImporter);


procedure RIRegister_TWinControlActionLink(CL: TPSRuntimeClassImporter);
//procedure RIRegister_TControl(CL: TPSRuntimeClassImporter);
procedure RIRegister_TPadding(CL: TPSRuntimeClassImporter);
procedure RIRegister_TMargins(CL: TPSRuntimeClassImporter);
procedure RIRegister_TSizeConstraints(CL: TPSRuntimeClassImporter);
procedure RIRegister_TControlActionLink(CL: TPSRuntimeClassImporter);
procedure RIRegister_TControlAction(CL: TPSRuntimeClassImporter);
procedure RIRegister_TCustomControlAction(CL: TPSRuntimeClassImporter);
procedure RIRegister_TControlCanvas(CL: TPSRuntimeClassImporter);





implementation
{$IFNDEF FPC}
uses
  Classes{$IFDEF CLX}, QControls, QGraphics{$ELSE}, Controls, Graphics, Menus, Windows{$ENDIF};
{$ELSE}
uses
  Classes, Controls, Graphics;
{$ENDIF}

procedure TControlAlignR(Self: TControl; var T: Byte); begin T := Byte(Self.Align); end;
procedure TControlAlignW(Self: TControl; T: Byte); begin Self.Align:= TAlign(T); end;

procedure TControlClientHeightR(Self: TControl; var T: Longint); begin T := Self.ClientHeight; end;
procedure TControlClientHeightW(Self: TControl; T: Longint); begin Self.ClientHeight := T; end;

procedure TControlClientWidthR(Self: TControl; var T: Longint); begin T := Self.ClientWidth; end;
procedure TControlClientWidthW(Self: TControl; T: Longint); begin Self.ClientWidth:= T; end;

procedure TControlShowHintR(Self: TControl; var T: Boolean); begin T := Self.ShowHint; end;
procedure TControlShowHintW(Self: TControl; T: Boolean); begin Self.ShowHint:= T; end;

procedure TControlVisibleR(Self: TControl; var T: Boolean); begin T := Self.Visible; end;
procedure TControlVisibleW(Self: TControl; T: Boolean); begin Self.Visible:= T; end;

procedure TControlParentR(Self: TControl; var T: TWinControl); begin T := Self.Parent; end;
procedure TControlParentW(Self: TControl; T: TWinControl); begin Self.Parent:= T; end;

procedure TControlWinProcR(Self: TControl; var T: TWndMethod); begin T := Self.WindowProc; end;
procedure TControlWinProcW(Self: TControl; T: TWndMethod); begin Self.WindowProc:= T; end;

  // RegisterProperty('WindowProc', 'TWndMethod', iptrw);

procedure TControlStateR(Self: TControl; var T: TControlState); begin T := Self.ControlState; end;
procedure TControlStateW(Self: TControl; T: TControlState); begin Self.ControlState:= T; end;

procedure TControlStyleR(Self: TControl; var T: TControlStyle); begin T := Self.ControlStyle; end;
procedure TControlStyleW(Self: TControl; T: TControlStyle); begin Self.ControlStyle:= T; end;

procedure TCONTROLSHOWHINT_W(Self: TCONTROL; T: BOOLEAN); begin Self.SHOWHINT := T; end;
procedure TCONTROLSHOWHINT_R(Self: TCONTROL; var T: BOOLEAN); begin T := Self.SHOWHINT; end;
procedure TCONTROLENABLED_W(Self: TCONTROL; T: BOOLEAN); begin Self.ENABLED := T; end;
procedure TCONTROLENABLED_R(Self: TCONTROL; var T: BOOLEAN); begin T := Self.ENABLED; end;

procedure TControlAnchorsR(Self: TControl; var T: TAnchors); begin T := Self.Anchors; end;
procedure TControlAnchorsW(Self: TControl; T: TAnchors); begin Self.Anchors:= T; end;
procedure TControlBiDiModeR(Self: TControl; var T: TBiDiMode); begin T := Self.BiDiMode; end;
procedure TControlBiDiModeW(Self: TControl; T: TBiDiMode); begin Self.BiDiMode:= T; end;
procedure TControlBoundsRectR(Self: TControl; var T: TRect); begin T := Self.BoundsRect; end;
procedure TControlBoundsRectW(Self: TControl; T: TRect); begin Self.BoundsRect:= T; end;

//procedure TControlColorW(Self: TControl; T: TRect); begin Self.BoundsRect:= T; end;

type THackWinControl = class(TWinControl);

 //  property ParentBackground: Boolean read GetParentBackground write SetParentBackground;

procedure TWinControlparentbackgroundW(Self: TWinControl; T: boolean);
//type tmycontrol: TControl
begin THackWinControl(Self).ParentBackground:= T;
end;

procedure TWinControlparentbackgroundR(Self: TControl; var T: boolean);
begin T := THackWinControl(Self).ParentBackground;
end;



type THackControl = class(TControl);

procedure TControlColorW(Self: TControl; T: TColor);
//type tmycontrol: TControl
begin THackControl(Self).Color:= T;
end;
procedure TControlColorR(Self: TControl; var T: TColor); begin T := THackControl(Self).Color; end;

procedure TControlCaptionW(Self: TControl; T: TCaption);
//type tmycontrol: TControl
begin THackControl(Self).Caption:= T;
end;
procedure TControlCaptionR(Self: TControl; var T: TCaption); begin T := THackControl(Self).Caption; end;

(*----------------------------------------------------------------------------*)
procedure TControlConstraints_W(Self: TControl; const T: TSizeConstraints);
begin Self.Constraints := T; end;

(*----------------------------------------------------------------------------*)
procedure TControlConstraints_R(Self: TControl; var T: TSizeConstraints);
begin T := Self.Constraints; end;


procedure TControlHostDockSite_W(Self: TControl; const T: TWinControl);
begin Self.HostDockSite:= T; end;

(*----------------------------------------------------------------------------*)
procedure TControlHostDockSite_R(Self: TControl; var T: TWinControl);
begin T := Self.HostDockSite; end;


procedure TControlLRDockWidth_W(Self: TControl; const T: Integer);
begin Self.LRDockWidth := T; end;

(*----------------------------------------------------------------------------*)
procedure TControlLRDockWidth_R(Self: TControl; var T: Integer);
begin T := Self.LRDockWidth; end;

(*----------------------------------------------------------------------------*)
procedure TControlClientWidth_W(Self: TControl; const T: Integer);
begin Self.ClientWidth := T; end;

(*----------------------------------------------------------------------------*)
procedure TControlClientWidth_R(Self: TControl; var T: Integer);
begin T := Self.ClientWidth; end;

(*----------------------------------------------------------------------------*)
procedure TControlClientRect_R(Self: TControl; var T: TRect);
begin T := Self.ClientRect; end;


procedure TControlAction_R(Self: TControl; var T: TBasicAction);
begin T := Self.action; end;

(*----------------------------------------------------------------------------*)
procedure TControlAction_W(Self: TControl; const T: TBasicAction);
begin Self.Action:= T; end;

(*----------------------------------------------------------------------------*)
procedure TControlClientOrigin_R(Self: TControl; var T: TPoint);
begin T := Self.ClientOrigin; end;

(*----------------------------------------------------------------------------*)
procedure TControlClientHeight_W(Self: TControl; const T: Integer);
begin Self.ClientHeight := T; end;

(*----------------------------------------------------------------------------*)
procedure TControlClientHeight_R(Self: TControl; var T: Integer);
begin T := Self.ClientHeight; end;

(*----------------------------------------------------------------------------*)
procedure TControlBoundsRect_W(Self: TControl; const T: TRect);
begin Self.BoundsRect := T; end;

(*----------------------------------------------------------------------------*)
procedure TControlBoundsRect_R(Self: TControl; var T: TRect);
begin T := Self.BoundsRect; end;

(*----------------------------------------------------------------------------*)
procedure TControlExplicitHeight_R(Self: TControl; var T: Integer);
begin T := Self.ExplicitHeight; end;

(*----------------------------------------------------------------------------*)
procedure TControlExplicitWidth_R(Self: TControl; var T: Integer);
begin T := Self.ExplicitWidth; end;

(*----------------------------------------------------------------------------*)
procedure TControlExplicitTop_R(Self: TControl; var T: Integer);
begin T := Self.ExplicitTop; end;

(*----------------------------------------------------------------------------*)
procedure TControlExplicitLeft_R(Self: TControl; var T: Integer);
begin T := Self.ExplicitLeft; end;

(*----------------------------------------------------------------------------*)
procedure TControlDockOrientation_W(Self: TControl; const T: TDockOrientation);
begin Self.DockOrientation := T; end;

(*----------------------------------------------------------------------------*)
procedure TControlDockOrientation_R(Self: TControl; var T: TDockOrientation);
begin T := Self.DockOrientation; end;
(*----------------------------------------------------------------------------*)
procedure TControlMargins_W(Self: TControl; const T: TMargins);
begin Self.Margins := T; end;

(*----------------------------------------------------------------------------*)
procedure TControlMargins_R(Self: TControl; var T: TMargins);
begin T := Self.Margins; end;

(*----------------------------------------------------------------------------*)
procedure TControlHelpContext_W(Self: TControl; const T: THelpContext);
begin Self.HelpContext := T; end;

(*----------------------------------------------------------------------------*)
procedure TControlHelpContext_R(Self: TControl; var T: THelpContext);
begin T := Self.HelpContext; end;

(*----------------------------------------------------------------------------*)
procedure TControlHelpKeyword_W(Self: TControl; const T: String);
begin Self.HelpKeyword := T; end;

(*----------------------------------------------------------------------------*)
procedure TControlHelpKeyword_R(Self: TControl; var T: String);
begin T := Self.HelpKeyword; end;

(*----------------------------------------------------------------------------*)
procedure TControlHelpType_W(Self: TControl; const T: THelpType);
begin Self.HelpType := T; end;

(*----------------------------------------------------------------------------*)
procedure TControlHelpType_R(Self: TControl; var T: THelpType);
begin T := Self.HelpType; end;

(*----------------------------------------------------------------------------*)
procedure TControlFloating_R(Self: TControl; var T: Boolean);
begin T := Self.Floating; end;


(*----------------------------------------------------------------------------*)
procedure TCustomMultiSelectListControlSelCount_R(Self: TCustomMultiSelectListControl; var T: Integer);
begin T := Self.SelCount; end;

(*----------------------------------------------------------------------------*)
procedure TCustomMultiSelectListControlMultiSelect_W(Self: TCustomMultiSelectListControl; const T: Boolean);
begin Self.MultiSelect := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomMultiSelectListControlMultiSelect_R(Self: TCustomMultiSelectListControl; var T: Boolean);
begin T := Self.MultiSelect; end;

(*----------------------------------------------------------------------------*)
procedure TCustomListControlItemIndex_W(Self: TCustomListControl; const T: Integer);
begin Self.ItemIndex := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomListControlItemIndex_R(Self: TCustomListControl; var T: Integer);
begin T := Self.ItemIndex; end;

(*----------------------------------------------------------------------------*)
Procedure TCustomListControlSetItemIndex_P(Self: TCustomListControl;  const Value : Integer);
Begin //Self.SetItemIndex(Value);
END;


(*----------------------------------------------------------------------------*)
procedure TCustomTransparentControlInterceptMouse_W(Self: TCustomTransparentControl; const T: Boolean);
begin Self.InterceptMouse := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomTransparentControlInterceptMouse_R(Self: TCustomTransparentControl; var T: Boolean);
begin T := Self.InterceptMouse; end;

(*----------------------------------------------------------------------------*)
procedure TCustomControlActionPopupMenu_W(Self: TCustomControlAction; const T: TPopupMenu);
begin Self.PopupMenu := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomControlActionPopupMenu_R(Self: TCustomControlAction; var T: TPopupMenu);
begin T := Self.PopupMenu; end;

(*----------------------------------------------------------------------------*)
procedure TCustomControlActionEnableDropdown_W(Self: TCustomControlAction; const T: Boolean);
begin Self.EnableDropdown := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomControlActionEnableDropdown_R(Self: TCustomControlAction; var T: Boolean);
begin T := Self.EnableDropdown; end;

(*----------------------------------------------------------------------------*)
procedure TCustomControlActionDropdownMenu_W(Self: TCustomControlAction; const T: TPopupMenu);
begin Self.DropdownMenu := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomControlActionDropdownMenu_R(Self: TCustomControlAction; var T: TPopupMenu);
begin T := Self.DropdownMenu; end;



(*----------------------------------------------------------------------------*)
procedure RIRegister_TCustomMultiSelectListControl(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TCustomMultiSelectListControl) do begin
    RegisterPropertyHelper(@TCustomMultiSelectListControlMultiSelect_R,@TCustomMultiSelectListControlMultiSelect_W,'MultiSelect');
    RegisterPropertyHelper(@TCustomMultiSelectListControlSelCount_R,nil,'SelCount');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TCustomListControl(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TCustomListControl) do begin
    //RegisterVirtualAbstractMethod(@TCustomListControl, @!.AddItem, 'AddItem');
    //RegisterVirtualAbstractMethod(@TCustomListControl, @!.Clear, 'Clear');
    //RegisterVirtualAbstractMethod(@TCustomListControl, @!.ClearSelection, 'ClearSelection');
    //RegisterVirtualAbstractMethod(@TCustomListControl, @!.CopySelection, 'CopySelection');
    //RegisterVirtualAbstractMethod(@TCustomListControl, @!.DeleteSelected, 'DeleteSelected');
    RegisterVirtualMethod(@TCustomListControl.MoveSelection, 'MoveSelection');
    //RegisterVirtualAbstractMethod(@TCustomListControl, @!.SelectAll, 'SelectAll');
    RegisterPropertyHelper(@TCustomListControlItemIndex_R,@TCustomListControlItemIndex_W,'ItemIndex');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TCustomPanningWindow(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TCustomPanningWindow) do begin
    //RegisterVirtualAbstractMethod(@TCustomPanningWindow, @!.GetIsPanning, 'GetIsPanning');
    //RegisterVirtualAbstractMethod(@TCustomPanningWindow, @!.StartPanning, 'StartPanning');
    //RegisterVirtualAbstractMethod(@TCustomPanningWindow, @!.StopPanning, 'StopPanning');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_THintWindow(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(THintWindow) do begin
    RegisterConstructor(@THintWindow.Create, 'Create');
    RegisterVirtualMethod(@THintWindow.ActivateHint, 'ActivateHint');
    RegisterVirtualMethod(@THintWindow.ActivateHintData, 'ActivateHintData');
    RegisterVirtualMethod(@THintWindow.CalcHintRect, 'CalcHintRect');
    RegisterVirtualMethod(@THintWindow.IsHintMsg, 'IsHintMsg');
    RegisterVirtualMethod(@THintWindow.ShouldHideHint, 'ShouldHideHint');
    RegisterMethod(@THintWindow.ReleaseHandle, 'ReleaseHandle');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TCustomTransparentControl(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TCustomTransparentControl) do
  begin
    RegisterPropertyHelper(@TCustomTransparentControlInterceptMouse_R,@TCustomTransparentControlInterceptMouse_W,'InterceptMouse');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TCustomControl(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TCustomControl) do begin
    RegisterConstructor(@TCustomControl.Create, 'Create');
    RegisterMethod(@TCustomControl.Destroy, 'Free');
  end;
end;



procedure RIRegisterTControl(Cl: TPSRuntimeClassImporter);
begin
  with Cl.Add(TControl) do begin
    RegisterVirtualConstructor(@TControl.Create, 'CREATE');
    RegisterMethod(@TControl.Destroy, 'Free');

      RegisterMethod(@TControl.BRingToFront, 'BRINGTOFRONT');
    RegisterMethod(@TControl.Hide, 'HIDE');
    RegisterVirtualMethod(@TControl.Invalidate, 'INVALIDATE');
    RegisterMethod(@TControl.Refresh, 'REFRESH');
    RegisterVirtualMethod(@TControl.Repaint, 'REPAINT');
    RegisterMethod(@TControl.SendToBack, 'SENDTOBACK');
    RegisterMethod(@TControl.Show, 'SHOW');
    RegisterMethod(@TControl.SetDesignVisible, 'SetDesignVisible');
    RegisterVirtualMethod(@TControl.Update, 'UPDATE');
    RegisterVirtualMethod(@TControl.SetBounds, 'SETBOUNDS');

    RegisterMethod(@TControl.IsRightToLeft, 'IsRightToLeft');
    RegisterMethod(@TControl.MouseWheelHandler, 'MouseWheelHandler');
    RegisterMethod(@TControl.GetParentComponent, 'GetParentComponent');
    RegisterMethod(@TControl.GetTextBuf, 'GetTextBuf');
    RegisterMethod(@TControl.GetTextLen, 'GetTextLen');
    RegisterMethod(@TControl.HasParent, 'HasParent');
    RegisterMethod(@TControl.InitiateAction, 'InitiateAction');
    RegisterMethod(@TControl.GetControlsAlignment, 'GetControlsAlignment');
    RegisterMethod(@TControl.DragDrop, 'DragDrop');
  RegisterMethod(@TControl.DrawTextBiDiModeFlags, 'DrawTextBiDiModeFlags');
  RegisterMethod(@TControl.DrawTextBiDiModeFlagsReadingOnly, 'DrawTextBiDiModeFlagsReadingOnly');
  RegisterMethod(@TControl.UseRightToLeftAlignment, 'UseRightToLeftAlignment');
  RegisterMethod(@TControl.UseRightToLeftReading, 'UseRightToLeftReading');
  RegisterMethod(@TControl.UseRightToLeftScrollBar, 'UseRightToLeftScrollBar');

    RegisterPropertyHelper(@TControlShowHintR, @TControlShowHintW, 'SHOWHINT');
    RegisterPropertyHelper(@TControlAlignR, @TControlAlignW, 'ALIGN');
    RegisterPropertyHelper(@TControlClientHeightR, @TControlClientHeightW, 'CLIENTHEIGHT');
    RegisterPropertyHelper(@TControlClientWidthR, @TControlClientWidthW, 'CLIENTWIDTH');
    RegisterPropertyHelper(@TControlVisibleR, @TControlVisibleW, 'VISIBLE');
    RegisterPropertyHelper(@TCONTROLENABLED_R, @TCONTROLENABLED_W, 'ENABLED');

    RegisterPropertyHelper(@TControlParentR, @TControlParentW, 'PARENT');

    RegisterPropertyHelper(@TControlWinProcR, @TControlWinProcW, 'WindowProc');

    // RegisterProperty('WindowProc', 'TWndMethod', iptrw);

    RegisterPropertyHelper(@TControlConstraints_R,@TControlConstraints_W,'Constraints');
    //RegisterPropertyHelper(@TControlControlState_R,@TControlControlState_W,'ControlState');
    //RegisterPropertyHelper(@TControlControlStyle_R,@TControlControlStyle_W,'ControlStyle');
    RegisterPropertyHelper(@TControlDockOrientation_R,@TControlDockOrientation_W,'DockOrientation');
    RegisterPropertyHelper(@TControlExplicitLeft_R,nil,'ExplicitLeft');
    RegisterPropertyHelper(@TControlExplicitTop_R,nil,'ExplicitTop');
    RegisterPropertyHelper(@TControlExplicitWidth_R,nil,'ExplicitWidth');
    RegisterPropertyHelper(@TControlExplicitHeight_R,nil,'ExplicitHeight');
    RegisterPropertyHelper(@TControlFloating_R,nil,'Floating');
     RegisterPropertyHelper(@TControlBoundsRect_R,@TControlBoundsRect_W,'BoundsRect');
    //RegisterPropertyHelper(@TControlClientHeight_R,@TControlClientHeight_W,'ClientHeight');
    RegisterPropertyHelper(@TControlClientOrigin_R,nil,'ClientOrigin');
    RegisterPropertyHelper(@TControlClientRect_R,nil,'ClientRect');
    //RegisterPropertyHelper(@TControlClientWidth_R,@TControlClientWidth_W,'ClientWidth');
       RegisterPropertyHelper(@TControlHelpType_R,@TControlHelpType_W,'HelpType');
    RegisterPropertyHelper(@TControlHelpKeyword_R,@TControlHelpKeyword_W,'HelpKeyword');
    RegisterPropertyHelper(@TControlHelpContext_R,@TControlHelpContext_W,'HelpContext');
    RegisterPropertyHelper(@TControlMargins_R,@TControlMargins_W,'Margins');
    RegisterPropertyHelper(@TControlAction_R,@TControlAction_W,'Action');



    RegisterPropertyHelper(@TControlStateR, @TControlStateW, 'ControlState');
    RegisterPropertyHelper(@TControlStyleR, @TControlStyleW, 'ControlStyle');
    //property ControlState: TControlState read FControlState write FControlState;
    //property ControlStyle: TControlStyle read FControlStyle write FControlStyle;

    RegisterPropertyHelper(@TControlAnchorsR, @TControlAnchorsW, 'Anchors');
    RegisterPropertyHelper(@TControlBidiModeR, @TControlBidiModeW, 'BidiMode');
    RegisterPropertyHelper(@TControlBoundsRectR, @TControlBoundsRectW, 'BoundsRect');
    RegisterPropertyHelper(@TControlColorR, @TControlColorW, 'Color');    //hack
    RegisterPropertyHelper(@TControlCaptionR, @TControlCaptionW, 'Caption');    //hack
    RegisterPropertyHelper(@TControlHostDockSite_R, @TControlHostDockSite_W, 'HostDockSite');    //hack
    RegisterPropertyHelper(@TControlLRDockWidth_R, @TControlLRDockWidth_W, 'LRDockWidth');    //hack



    {$IFNDEF PS_MINIVCL}
    RegisterMethod(@TControl.Dragging, 'DRAGGING');
    RegisterMethod(@TControl.HasParent, 'HASPARENT');
    RegisterMethod(@TCONTROL.CLIENTTOSCREEN, 'CLIENTTOSCREEN');
    RegisterMethod(@TCONTROL.CLIENTTOSCREEN, 'ManualFloat');

    RegisterMethod(@TCONTROL.DRAGGING, 'DRAGGING');
   {$IFNDEF FPC}
    RegisterMethod(@TCONTROL.BEGINDRAG, 'BEGINDRAG');
    RegisterMethod(@TCONTROL.ENDDRAG, 'ENDDRAG');
   {$ENDIF}
    {$IFNDEF CLX}
    RegisterMethod(@TCONTROL.GETTEXTBUF, 'GETTEXTBUF');
    RegisterMethod(@TCONTROL.GETTEXTLEN, 'GETTEXTLEN');
    RegisterMethod(@TCONTROL.PERFORM, 'PERFORM');
    RegisterMethod(@TCONTROL.SETTEXTBUF, 'SETTEXTBUF');
    {$ENDIF}
    RegisterMethod(@TCONTROL.SCREENTOCLIENT, 'SCREENTOCLIENT');
     //with CL.Add(TWinControl) do

    RegisterMethod(@TCONTROL.ParentTOCLIENT, 'ParentTOCLIENT');
    RegisterMethod(@TCONTROL.ReplaceDockedControl, 'ReplaceDockedControl');

      {$ENDIF}
  end;
end;
{$IFNDEF CLX}
procedure TWinControlHandleR(Self: TWinControl; var T: Longint); begin T := Self.Handle; end;
{$ENDIF}
procedure TWinControlShowingR(Self: TWinControl; var T: Boolean); begin T := Self.Showing; end;


procedure TWinControlTabOrderR(Self: TWinControl; var T: Longint); begin T := Self.TabOrder; end;
procedure TWinControlTabOrderW(Self: TWinControl; T: Longint); begin Self.TabOrder:= T; end;

procedure TWinControlTabStopR(Self: TWinControl; var T: Boolean); begin T := Self.TabStop; end;
procedure TWinControlTabStopW(Self: TWinControl; T: Boolean); begin Self.TabStop:= T; end;
procedure TWINCONTROLBRUSH_R(Self: TWINCONTROL; var T: TBRUSH); begin T := Self.BRUSH; end;
procedure TWINCONTROLCONTROLS_R(Self: TWINCONTROL; var T: TCONTROL; t1: INTEGER); begin t := Self.CONTROLS[t1]; end;
procedure TWINCONTROLCONTROLCOUNT_R(Self: TWINCONTROL; var T: INTEGER); begin t := Self.CONTROLCOUNT; end;

procedure TWinControlDB_R(Self: TWinControl; var T: boolean); begin T:= Self.DoubleBuffered; end;
procedure TWinControlDB_W(Self: TWinControl; T: boolean); begin Self.DoubleBuffered:= T; end;

procedure TWinControlUDM_R(Self: TWinControl; var T: boolean); begin T:= Self.UseDockManager; end;
procedure TWinControlUDM_W(Self: TWinControl; T: boolean); begin Self.UseDockManager:= T; end;

//7procedure TWinControlBW_R(Self: TWinControl; var T: TBorderWidth); begin T:= Self.borderwidth; end;
//procedure TWinControlBW_W(Self: TWinControl; T: boolean); begin Self.DoubleBuffered:= T; end;


(*----------------------------------------------------------------------------*)
Procedure TWinControlPaintTo1_P(Self: TWinControl;  Canvas : TCanvas; X, Y : Integer);
Begin Self.PaintTo(Canvas, X, Y); END;

(*----------------------------------------------------------------------------*)
Procedure TWinControlPaintTo_P(Self: TWinControl;  DC : HDC; X, Y : Integer);
Begin Self.PaintTo(DC, X, Y); END;

(*----------------------------------------------------------------------------*)
procedure TWinControlPadding_W(Self: TWinControl; const T: TPadding);
begin Self.Padding := T; end;

(*----------------------------------------------------------------------------*)
procedure TWinControlPadding_R(Self: TWinControl; var T: TPadding);
begin T := Self.Padding; end;

(*----------------------------------------------------------------------------*)
procedure TWinControlVisibleDockClientCount_R(Self: TWinControl; var T: Integer);
begin T := Self.VisibleDockClientCount; end;

(*----------------------------------------------------------------------------*)
procedure TWinControlMouseInClient_R(Self: TWinControl; var T: Boolean);
begin T := Self.MouseInClient; end;
(*----------------------------------------------------------------------------*)
procedure TWinControlAlignDisabled_R(Self: TWinControl; var T: Boolean);
begin T := Self.AlignDisabled; end;

(*----------------------------------------------------------------------------*)
procedure TWinControlDockClients_R(Self: TWinControl; var T: TControl; const t1: Integer);
begin T := Self.DockClients[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TWinControlDockClientCount_R(Self: TWinControl; var T: Integer);
begin T := Self.DockClientCount; end;

(*----------------------------------------------------------------------------*)
procedure TWinControlParentWindow_W(Self: TWinControl; const T: HWnd);
begin Self.ParentWindow := T; end;

(*----------------------------------------------------------------------------*)
procedure TWinControlParentWindow_R(Self: TWinControl; var T: HWnd);
begin T := Self.ParentWindow; end;

(*----------------------------------------------------------------------------*)
procedure TWinControlDockSite_W(Self: TWinControl; const T: Boolean);
begin Self.DockSite := T; end;

(*----------------------------------------------------------------------------*)
procedure TWinControlDockSite_R(Self: TWinControl; var T: Boolean);
begin T := Self.DockSite; end;


procedure RIRegisterTWinControl(Cl: TPSRuntimeClassImporter); // requires TControl
begin
  with Cl.Add(TWinControl) do begin
    {$IFNDEF CLX}
    RegisterPropertyHelper(@TWinControlHandleR, nil, 'HANDLE');
    {$ENDIF}
     RegisterConstructor(@TWinControl.Create, 'CREATE');
     RegisterMethod(@TWinControl.Destroy, 'FREE');             //after all!
     RegisterConstructor(@TWinControl.CreateParented, 'CreateParented');
     RegisterMethod(@TWinControl.DefaultHandler, 'DefaultHandler');
     RegisterMethod(@TWinControl.DisableAlign, 'DisableAlign');
          RegisterMethod(@TWinControl.SetDesignVisible, 'SetDesignVisible');
     RegisterMethod(@TWinControl.SetBounds, 'SetBounds');
     RegisterMethod(@TWinControl.Repaint, 'Repaint');
      RegisterPropertyHelper(@TWinControlShowingR, nil, 'SHOWING');
    RegisterPropertyHelper(@TWinControlTabOrderR, @TWinControlTabOrderW, 'TABORDER');
    RegisterPropertyHelper(@TWinControlTabStopR, @TWinControlTabStopW, 'TABSTOP');
    RegisterMethod(@TWINCONTROL.CANFOCUS, 'CANFOCUS');
    RegisterMethod(@TWINCONTROL.FOCUSED, 'FOCUSED');
      RegisterMethod(@TWINCONTROL.ParentTOCLIENT, 'ParentTOCLIENT');

    RegisterPropertyHelper(@TWINCONTROLCONTROLS_R, nil, 'CONTROLS');
    RegisterPropertyHelper(@TWINCONTROLCONTROLCOUNT_R, nil, 'CONTROLCOUNT');
    {$IFNDEF PS_MINIVCL}
    RegisterMethod(@TWinControl.HandleAllocated, 'HANDLEALLOCATED');
    RegisterMethod(@TWinControl.HandleNeeded, 'HANDLENEEDED');
    RegisterMethod(@TWinControl.EnableAlign, 'ENABLEALIGN');
		RegisterMethod(@TWinControl.RemoveControl, 'REMOVECONTROL');
		{$IFNDEF FPC}
		RegisterMethod(@TWinControl.InsertControl, 'INSERTCONTROL');
		RegisterMethod(@TWinControl.ScaleBy, 'SCALEBY');
		RegisterMethod(@TWinControl.ScrollBy, 'SCROLLBY');
		{$IFNDEF CLX}
	 {	 RegisterMethod(@TWINCONTROL.PAINTTO, 'PAINTTO');
   	 RegisterMethod(@TWINCONTROL.PAINTTO, 'PAINTTOC');
   	 RegisterMethod(@TWINCONTROL.PAINTTO, 'PAINTTO1');}

    RegisterMethod(@TWinControlPaintTo_P, 'PaintTo');
    RegisterMethod(@TWinControlPaintTo1_P, 'PaintTo1');
    RegisterMethod(@TWinControlPaintTo1_P, 'PaintToC');
    	RegisterMethod(@TWinControl.ControlAtPos, 'ControlAtPos');
		RegisterMethod(@TWinControl.FindChildControl, 'FindChildControl');
		RegisterMethod(@TWinControl.FlipChildren, 'FlipChildren');
    RegisterPropertyHelper(@TWinControlDockClientCount_R,nil,'DockClientCount');
    RegisterPropertyHelper(@TWinControlDockClients_R,nil,'DockClients');
        RegisterPropertyHelper(@TWinControlAlignDisabled_R,nil,'AlignDisabled');
    RegisterPropertyHelper(@TWinControlMouseInClient_R,nil,'MouseInClient');
    RegisterPropertyHelper(@TWinControlVisibleDockClientCount_R,nil,'VisibleDockClientCount');
    //RegisterPropertyHelper(@TWinControlBrush_R,nil,'Brush');
    //RegisterPropertyHelper(@TWinControlControls_R,nil,'Controls');
    //RegisterPropertyHelper(@TWinControlControlCount_R,nil,'ControlCount');
    //RegisterPropertyHelper(@TWinControlHandle_R,nil,'Handle');
    RegisterPropertyHelper(@TWinControlPadding_R,@TWinControlPadding_W,'Padding');
    RegisterPropertyHelper(@TWinControlParentWindow_R,@TWinControlParentWindow_W,'ParentWindow');
      RegisterPropertyHelper(@TWinControlDockSite_R,@TWinControlDockSite_W,'DockSite');
    	 RegisterMethod(@TWINCONTROL.PreProcessMessage, 'PreProcessMessage');
		{$ENDIF}
		{$ENDIF}{FPC}
 		//RegisterMethod(@TWinControl.InheritsFrom, 'InheritsFrom');
    RegisterMethod(@TWinControl.Realign, 'REALIGN');
		RegisterVirtualMethod(@TWinControl.SetFocus, 'SETFOCUS');
		RegisterMethod(@TWINCONTROL.CONTAINSCONTROL, 'CONTAINSCONTROL');
		RegisterMethod(@TWINCONTROL.DISABLEALIGN, 'DISABLEALIGN');
		RegisterMethod(@TWINCONTROL.UPDATECONTROLSTATE, 'UPDATECONTROLSTATE');
    //RegisterMethod(@TWINCONTROL.paintwindow, 'paintwindow');


    RegisterPropertyHelper(@TWINCONTROLBRUSH_R, nil, 'BRUSH');
    RegisterPropertyHelper(@TWINCONTROLDB_R, @TWINCONTROLDB_W, 'DoubleBuffered');
    //RegisterPropertyHelper(@TWINCONTROLBW_R, @TWINCONTROLBW_W, 'BORDERWIDTH');
    RegisterPropertyHelper(@TWINCONTROLUDM_R, @TWINCONTROLUDM_W, 'UseDockManager');

    RegisterPropertyHelper(@TWinControlparentbackgroundR, @TWinControlparentbackgroundW, 'parentbackground');
    // TWinControlparentbackgroundW

    {$ENDIF}
  end;
end;

procedure RIRegisterTGraphicControl(cl: TPSRuntimeClassImporter); // requires TControl
begin
  with Cl.Add(TGraphicControl) do begin
   RegisterConstructor(@TGraphicControl.Create, 'Create');
   RegisterMethod(@TGraphicControl.Free, 'Free');
  end;
end;


//procedure TCCColorW(Self: TCustomControl; T: TColor); begin Self.Color:= T; end;
//procedure TCCColorR(Self: TWinControl; var T: TColor); begin T := Self.Color; end;


procedure RIRegisterTCustomControl(cl: TPSRuntimeClassImporter); // requires TControl
begin
  with Cl.Add(TCustomControl) do begin
   RegisterConstructor(@TCustomControl.Create, 'Create');
   RegisterMethod(@TCustomControl.Free, 'Free');
  end;
end;

{$IFDEF DELPHI4UP}
(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TDragObjectMouseDeltaY_R(Self: TDragObject; var T: Double);
begin T := Self.MouseDeltaY; end;

(*----------------------------------------------------------------------------*)
procedure TDragObjectMouseDeltaX_R(Self: TDragObject; var T: Double);
begin T := Self.MouseDeltaX; end;

(*----------------------------------------------------------------------------*)
procedure TDragObjectDragTarget_W(Self: TDragObject; const T: Pointer);
begin Self.DragTarget := T; end;

(*----------------------------------------------------------------------------*)
procedure TDragObjectDragTarget_R(Self: TDragObject; var T: Pointer);
begin T := Self.DragTarget; end;

(*----------------------------------------------------------------------------*)
procedure TDragObjectDragTargetPos_W(Self: TDragObject; const T: TPoint);
begin Self.DragTargetPos := T; end;

(*----------------------------------------------------------------------------*)
procedure TDragObjectDragTargetPos_R(Self: TDragObject; var T: TPoint);
begin T := Self.DragTargetPos; end;

(*----------------------------------------------------------------------------*)
procedure TDragObjectDragPos_W(Self: TDragObject; const T: TPoint);
begin Self.DragPos := T; end;

(*----------------------------------------------------------------------------*)
procedure TDragObjectDragPos_R(Self: TDragObject; var T: TPoint);
begin T := Self.DragPos; end;

(*----------------------------------------------------------------------------*)
procedure TDragObjectDragHandle_W(Self: TDragObject; const T: HWND);
begin Self.DragHandle := T; end;

(*----------------------------------------------------------------------------*)
procedure TDragObjectDragHandle_R(Self: TDragObject; var T: HWND);
begin T := Self.DragHandle; end;

(*----------------------------------------------------------------------------*)
procedure TDragObjectCancelling_W(Self: TDragObject; const T: Boolean);
begin Self.Cancelling := T; end;

(*----------------------------------------------------------------------------*)
procedure TDragObjectCancelling_R(Self: TDragObject; var T: Boolean);
begin T := Self.Cancelling; end;
{$ENDIF}
(*----------------------------------------------------------------------------*)
procedure RIRegister_TDragObject(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TDragObject) do begin
{$IFNDEF PS_MINIVCL}
{$IFDEF DELPHI4UP}
    RegisterVirtualMethod(@TDragObject.Assign, 'Assign');
{$ENDIF}
{$IFNDEF FPC}
    RegisterVirtualMethod(@TDragObject.GetName, 'GetName');
    RegisterVirtualMethod(@TDragObject.Instance, 'Instance');
    RegisterMethod(@TDragObject.AfterConstruction, 'AfterConstruction');
    RegisterMethod(@TDragObject.BeforeDestruction, 'BeforeDestruction');

{$ENDIF}
    RegisterVirtualMethod(@TDragObject.HideDragImage, 'HideDragImage');
    RegisterVirtualMethod(@TDragObject.ShowDragImage, 'ShowDragImage');
{$IFDEF DELPHI4UP}
    RegisterPropertyHelper(@TDragObjectCancelling_R,@TDragObjectCancelling_W,'Cancelling');
    RegisterPropertyHelper(@TDragObjectDragHandle_R,@TDragObjectDragHandle_W,'DragHandle');
    RegisterPropertyHelper(@TDragObjectDragPos_R,@TDragObjectDragPos_W,'DragPos');
    RegisterPropertyHelper(@TDragObjectDragTargetPos_R,@TDragObjectDragTargetPos_W,'DragTargetPos');
    RegisterPropertyHelper(@TDragObjectDragTarget_R,@TDragObjectDragTarget_W,'DragTarget');
    RegisterPropertyHelper(@TDragObjectMouseDeltaX_R,nil,'MouseDeltaX');
    RegisterPropertyHelper(@TDragObjectMouseDeltaY_R,nil,'MouseDeltaY');
{$ENDIF}
{$ENDIF}
  end;
end;

(*----------------------------------------------------------------------------*)
procedure TDragImageListDragging_R(Self: TDragImageList; var T: Boolean);
begin T := Self.Dragging; end;

(*----------------------------------------------------------------------------*)
procedure TDragImageListDragHotspot_W(Self: TDragImageList; const T: TPoint);
begin Self.DragHotspot := T; end;

(*----------------------------------------------------------------------------*)
procedure TDragImageListDragHotspot_R(Self: TDragImageList; var T: TPoint);
begin T := Self.DragHotspot; end;

(*----------------------------------------------------------------------------*)
procedure TDragImageListDragCursor_W(Self: TDragImageList; const T: TCursor);
begin Self.DragCursor := T; end;

(*----------------------------------------------------------------------------*)
procedure TDragImageListDragCursor_R(Self: TDragImageList; var T: TCursor);
begin T := Self.DragCursor; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TImageList(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TImageList) do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TDragImageList(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TDragImageList) do begin
    RegisterMethod(@TDragImageList.BeginDrag, 'BeginDrag');
    RegisterMethod(@TDragImageList.DragLock, 'DragLock');
    RegisterMethod(@TDragImageList.DragMove, 'DragMove');
    RegisterMethod(@TDragImageList.DragUnlock, 'DragUnlock');
    RegisterMethod(@TDragImageList.EndDrag, 'EndDrag');
    RegisterMethod(@TDragImageList.HideDragImage, 'HideDragImage');
    RegisterMethod(@TDragImageList.SetDragImage, 'SetDragImage');
    RegisterMethod(@TDragImageList.ShowDragImage, 'ShowDragImage');
      RegisterMethod(@TDragImageList.GetHotSpot, 'GetHotSpot');


    RegisterPropertyHelper(@TDragImageListDragCursor_R,@TDragImageListDragCursor_W,'DragCursor');
    RegisterPropertyHelper(@TDragImageListDragHotspot_R,@TDragImageListDragHotspot_W,'DragHotspot');
    RegisterPropertyHelper(@TDragImageListDragging_R,nil,'Dragging');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure TMouseWheelScrollLines_R(Self: TMouse; var T: Integer);
begin T := Self.WheelScrollLines; end;

(*----------------------------------------------------------------------------*)
procedure TMouseWheelPresent_R(Self: TMouse; var T: Boolean);
begin T := Self.WheelPresent; end;

(*----------------------------------------------------------------------------*)
procedure TMouseRegWheelMessage_R(Self: TMouse; var T: UINT);
begin T := Self.RegWheelMessage; end;

(*----------------------------------------------------------------------------*)
procedure TMousePanningWindowClass_W(Self: TMouse; const T: TPanningWindowClass);
begin Self.PanningWindowClass := T; end;

(*----------------------------------------------------------------------------*)
procedure TMousePanningWindowClass_R(Self: TMouse; var T: TPanningWindowClass);
begin T := Self.PanningWindowClass; end;

(*----------------------------------------------------------------------------*)
procedure TMousePanningWindow_W(Self: TMouse; const T: TCustomPanningWindow);
begin Self.PanningWindow := T; end;

(*----------------------------------------------------------------------------*)
procedure TMousePanningWindow_R(Self: TMouse; var T: TCustomPanningWindow);
begin T := Self.PanningWindow; end;

(*----------------------------------------------------------------------------*)
procedure TMouseIsPanning_R(Self: TMouse; var T: Boolean);
begin T := Self.IsPanning; end;

(*----------------------------------------------------------------------------*)
procedure TMouseIsDragging_R(Self: TMouse; var T: Boolean);
begin T := Self.IsDragging; end;

(*----------------------------------------------------------------------------*)
procedure TMouseMousePresent_R(Self: TMouse; var T: Boolean);
begin T := Self.MousePresent; end;

(*----------------------------------------------------------------------------*)
procedure TMouseDragThreshold_W(Self: TMouse; const T: Integer);
begin Self.DragThreshold := T; end;

(*----------------------------------------------------------------------------*)
procedure TMouseDragThreshold_R(Self: TMouse; var T: Integer);
begin T := Self.DragThreshold; end;

(*----------------------------------------------------------------------------*)
procedure TMouseDragImmediate_W(Self: TMouse; const T: Boolean);
begin Self.DragImmediate := T; end;

(*----------------------------------------------------------------------------*)
procedure TMouseDragImmediate_R(Self: TMouse; var T: Boolean);
begin T := Self.DragImmediate; end;

(*----------------------------------------------------------------------------*)
procedure TMouseCursorPos_W(Self: TMouse; const T: TPoint);
begin Self.CursorPos := T; end;

(*----------------------------------------------------------------------------*)
procedure TMouseCursorPos_R(Self: TMouse; var T: TPoint);
begin T := Self.CursorPos; end;

(*----------------------------------------------------------------------------*)
procedure TMouseCapture_W(Self: TMouse; const T: HWND);
begin Self.Capture := T; end;

(*----------------------------------------------------------------------------*)
procedure TMouseCapture_R(Self: TMouse; var T: HWND);
begin T := Self.Capture; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TMouse(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TMouse) do begin
    RegisterConstructor(@TMouse.Create, 'Create');
    RegisterMethod(@TMouse.SettingChanged, 'SettingChanged');
    RegisterMethod(@TMouse.CreatePanningWindow, 'CreatePanningWindow');
    RegisterPropertyHelper(@TMouseCapture_R,@TMouseCapture_W,'Capture');
    RegisterPropertyHelper(@TMouseCursorPos_R,@TMouseCursorPos_W,'CursorPos');
    RegisterPropertyHelper(@TMouseDragImmediate_R,@TMouseDragImmediate_W,'DragImmediate');
    RegisterPropertyHelper(@TMouseDragThreshold_R,@TMouseDragThreshold_W,'DragThreshold');
    RegisterPropertyHelper(@TMouseMousePresent_R,nil,'MousePresent');
    RegisterPropertyHelper(@TMouseIsDragging_R,nil,'IsDragging');
    RegisterPropertyHelper(@TMouseIsPanning_R,nil,'IsPanning');
    RegisterPropertyHelper(@TMousePanningWindow_R,@TMousePanningWindow_W,'PanningWindow');
    RegisterPropertyHelper(@TMousePanningWindowClass_R,@TMousePanningWindowClass_W,'PanningWindowClass');
    RegisterPropertyHelper(@TMouseRegWheelMessage_R,nil,'RegWheelMessage');
    RegisterPropertyHelper(@TMouseWheelPresent_R,nil,'WheelPresent');
    RegisterPropertyHelper(@TMouseWheelScrollLines_R,nil,'WheelScrollLines');
  end;
end;


(*----------------------------------------------------------------------------*)
procedure TMarginsBottom_W(Self: TMargins; const T: TMarginSize);
begin Self.Bottom := T; end;

(*----------------------------------------------------------------------------*)
procedure TMarginsBottom_R(Self: TMargins; var T: TMarginSize);
begin T := Self.Bottom; end;

(*----------------------------------------------------------------------------*)
procedure TMarginsRight_W(Self: TMargins; const T: TMarginSize);
begin Self.Right := T; end;

(*----------------------------------------------------------------------------*)
procedure TMarginsRight_R(Self: TMargins; var T: TMarginSize);
begin T := Self.Right; end;

(*----------------------------------------------------------------------------*)
procedure TMarginsTop_W(Self: TMargins; const T: TMarginSize);
begin Self.Top := T; end;

(*----------------------------------------------------------------------------*)
procedure TMarginsTop_R(Self: TMargins; var T: TMarginSize);
begin T := Self.Top; end;

(*----------------------------------------------------------------------------*)
procedure TMarginsLeft_W(Self: TMargins; const T: TMarginSize);
begin Self.Left := T; end;

(*----------------------------------------------------------------------------*)
procedure TMarginsLeft_R(Self: TMargins; var T: TMarginSize);
begin T := Self.Left; end;

(*----------------------------------------------------------------------------*)
procedure TMarginsOnChange_W(Self: TMargins; const T: TNotifyEvent);
begin Self.OnChange := T; end;

(*----------------------------------------------------------------------------*)
procedure TMarginsOnChange_R(Self: TMargins; var T: TNotifyEvent);
begin T := Self.OnChange; end;

(*----------------------------------------------------------------------------*)
procedure TMarginsExplicitHeight_R(Self: TMargins; var T: Integer);
begin T := Self.ExplicitHeight; end;

(*----------------------------------------------------------------------------*)
procedure TMarginsExplicitWidth_R(Self: TMargins; var T: Integer);
begin T := Self.ExplicitWidth; end;

(*----------------------------------------------------------------------------*)
procedure TMarginsExplicitTop_R(Self: TMargins; var T: Integer);
begin T := Self.ExplicitTop; end;

(*----------------------------------------------------------------------------*)
procedure TMarginsExplicitLeft_R(Self: TMargins; var T: Integer);
begin T := Self.ExplicitLeft; end;

(*----------------------------------------------------------------------------*)
procedure TMarginsControlHeight_R(Self: TMargins; var T: Integer);
begin T := Self.ControlHeight; end;

(*----------------------------------------------------------------------------*)
procedure TMarginsControlWidth_R(Self: TMargins; var T: Integer);
begin T := Self.ControlWidth; end;

(*----------------------------------------------------------------------------*)
procedure TMarginsControlTop_R(Self: TMargins; var T: Integer);
begin T := Self.ControlTop; end;

(*----------------------------------------------------------------------------*)
procedure TMarginsControlLeft_R(Self: TMargins; var T: Integer);
begin T := Self.ControlLeft; end;

(*----------------------------------------------------------------------------*)
Procedure TMarginsSetControlBounds1_P(Self: TMargins;  const ARect : TRect; Aligning : Boolean);
Begin Self.SetControlBounds(ARect, Aligning); END;

(*----------------------------------------------------------------------------*)
Procedure TMarginsSetControlBounds_P(Self: TMargins;  ALeft, ATop, AWidth, AHeight : Integer; Aligning : Boolean);
Begin Self.SetControlBounds(ALeft, ATop, AWidth, AHeight, Aligning); END;

(*----------------------------------------------------------------------------*)
procedure TSizeConstraintsMinWidth_W(Self: TSizeConstraints; const T: TConstraintSize);
begin Self.MinWidth := T; end;

(*----------------------------------------------------------------------------*)
procedure TSizeConstraintsMinWidth_R(Self: TSizeConstraints; var T: TConstraintSize);
begin T := Self.MinWidth; end;

(*----------------------------------------------------------------------------*)
procedure TSizeConstraintsMinHeight_W(Self: TSizeConstraints; const T: TConstraintSize);
begin Self.MinHeight := T; end;

(*----------------------------------------------------------------------------*)
procedure TSizeConstraintsMinHeight_R(Self: TSizeConstraints; var T: TConstraintSize);
begin T := Self.MinHeight; end;

(*----------------------------------------------------------------------------*)
procedure TSizeConstraintsMaxWidth_W(Self: TSizeConstraints; const T: TConstraintSize);
begin Self.MaxWidth := T; end;

(*----------------------------------------------------------------------------*)
procedure TSizeConstraintsMaxWidth_R(Self: TSizeConstraints; var T: TConstraintSize);
begin T := Self.MaxWidth; end;

(*----------------------------------------------------------------------------*)
procedure TSizeConstraintsMaxHeight_W(Self: TSizeConstraints; const T: TConstraintSize);
begin Self.MaxHeight := T; end;

(*----------------------------------------------------------------------------*)
procedure TSizeConstraintsMaxHeight_R(Self: TSizeConstraints; var T: TConstraintSize);
begin T := Self.MaxHeight; end;

(*----------------------------------------------------------------------------*)
procedure TSizeConstraintsOnChange_W(Self: TSizeConstraints; const T: TNotifyEvent);
begin Self.OnChange := T; end;

(*----------------------------------------------------------------------------*)
procedure TSizeConstraintsOnChange_R(Self: TSizeConstraints; var T: TNotifyEvent);
begin T := Self.OnChange; end;

(*----------------------------------------------------------------------------*)
(*----------------------------------------------------------------------------*)
procedure TControlCanvasControl_W(Self: TControlCanvas; const T: TControl);
begin Self.Control := T; end;

(*----------------------------------------------------------------------------*)
procedure TControlCanvasControl_R(Self: TControlCanvas; var T: TControl);
begin T := Self.Control; end;




(*----------------------------------------------------------------------------*)
procedure RIRegister_TWinControlActionLink(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TWinControlActionLink) do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)

(*----------------------------------------------------------------------------*)
procedure RIRegister_TPadding(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TPadding) do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TMargins(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TMargins) do begin
    RegisterVirtualConstructor(@TMargins.Create, 'Create');
    RegisterMethod(@TMarginsSetControlBounds_P, 'SetControlBounds');
    RegisterMethod(@TMarginsSetControlBounds1_P, 'SetControlBounds1');
    RegisterMethod(@TMargins.SetBounds, 'SetBounds');
    RegisterPropertyHelper(@TMarginsControlLeft_R,nil,'ControlLeft');
    RegisterPropertyHelper(@TMarginsControlTop_R,nil,'ControlTop');
    RegisterPropertyHelper(@TMarginsControlWidth_R,nil,'ControlWidth');
    RegisterPropertyHelper(@TMarginsControlHeight_R,nil,'ControlHeight');
    RegisterPropertyHelper(@TMarginsExplicitLeft_R,nil,'ExplicitLeft');
    RegisterPropertyHelper(@TMarginsExplicitTop_R,nil,'ExplicitTop');
    RegisterPropertyHelper(@TMarginsExplicitWidth_R,nil,'ExplicitWidth');
    RegisterPropertyHelper(@TMarginsExplicitHeight_R,nil,'ExplicitHeight');
    RegisterPropertyHelper(@TMarginsOnChange_R,@TMarginsOnChange_W,'OnChange');
    RegisterPropertyHelper(@TMarginsLeft_R,@TMarginsLeft_W,'Left');
    RegisterPropertyHelper(@TMarginsTop_R,@TMarginsTop_W,'Top');
    RegisterPropertyHelper(@TMarginsRight_R,@TMarginsRight_W,'Right');
    RegisterPropertyHelper(@TMarginsBottom_R,@TMarginsBottom_W,'Bottom');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TSizeConstraints(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TSizeConstraints) do begin
    RegisterVirtualConstructor(@TSizeConstraints.Create, 'Create');
    RegisterPropertyHelper(@TSizeConstraintsOnChange_R,@TSizeConstraintsOnChange_W,'OnChange');
    RegisterPropertyHelper(@TSizeConstraintsMaxHeight_R,@TSizeConstraintsMaxHeight_W,'MaxHeight');
    RegisterPropertyHelper(@TSizeConstraintsMaxWidth_R,@TSizeConstraintsMaxWidth_W,'MaxWidth');
    RegisterPropertyHelper(@TSizeConstraintsMinHeight_R,@TSizeConstraintsMinHeight_W,'MinHeight');
    RegisterPropertyHelper(@TSizeConstraintsMinWidth_R,@TSizeConstraintsMinWidth_W,'MinWidth');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TControlActionLink(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TControlActionLink) do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TControlAction(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TControlAction) do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TCustomControlAction(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TCustomControlAction) do
  begin
    RegisterPropertyHelper(@TCustomControlActionDropdownMenu_R,@TCustomControlActionDropdownMenu_W,'DropdownMenu');
    RegisterPropertyHelper(@TCustomControlActionEnableDropdown_R,@TCustomControlActionEnableDropdown_W,'EnableDropdown');
    RegisterPropertyHelper(@TCustomControlActionPopupMenu_R,@TCustomControlActionPopupMenu_W,'PopupMenu');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TControlCanvas(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TControlCanvas) do begin
    RegisterMethod(@TControlCanvas.Destroy, 'Free');
      RegisterMethod(@TControlCanvas.FreeHandle, 'FreeHandle');
    RegisterMethod(@TControlCanvas.UpdateTextFlags, 'UpdateTextFlags');
    RegisterPropertyHelper(@TControlCanvasControl_R,@TControlCanvasControl_W,'Control');
  end;
end;




procedure RIRegister_Controls_Routines(S: TPSExec);
begin
 //S.RegisterDelphiFunction(@IsPositiveResult, 'IsPositiveResult', cdRegister);
 //S.RegisterDelphiFunction(@IsNegativeResult, 'IsNegativeResult', cdRegister);
 //S.RegisterDelphiFunction(@IsAbortResult, 'IsAbortResult', cdRegister);
 S.RegisterDelphiFunction(@IsAnAllResult, 'IsAnAllResult', cdRegister);
 {S.RegisterDelphiFunction(@StripAllFromResult, 'StripAllFromResult', cdRegister);
  with CL.Add(TDragObject) do
  with CL.Add(TControl) do
  with CL.Add(TWinControl) do
  with CL.Add(TDragImageList) do
  RIRegister_TDragObject(CL);
  RIRegister_TDragObjectEx(CL);
  RIRegister_TBaseDragControlObject(CL);
  RIRegister_TDragControlObject(CL);
  RIRegister_TDragControlObjectEx(CL);
  RIRegister_TDragDockObject(CL);
  RIRegister_TDragDockObjectEx(CL);
  RIRegister_TControlCanvas(CL);
  RIRegister_TCustomControlAction(CL);
  RIRegister_TControlAction(CL);
  RIRegister_TControlActionLink(CL);
  RIRegister_TSizeConstraints(CL);
  RIRegister_TMargins(CL);
  RIRegister_TPadding(CL);
  RIRegister_TControl(CL);
  RIRegister_TWinControlActionLink(CL);
  RIRegister_TWinControl(CL);
  RIRegister_TGraphicControl(CL);
  RIRegister_TCustomControl(CL);
  RIRegister_TCustomTransparentControl(CL);
  RIRegister_THintWindow(CL);
  RIRegister_TDragImageList(CL);
  RIRegister_TImageList(CL);
  with CL.Add(TDockTree) do
  RIRegister_TDockZone(CL);
  RIRegister_TDockTree(CL);
  RIRegister_TCustomPanningWindow(CL);
  RIRegister_TMouse(CL);
  RIRegister_TCustomListControl(CL);
  RIRegister_TCustomMultiSelectListControl(CL); }
 S.RegisterDelphiFunction(@InitWndProc, 'InitWndProc', CdStdCall);
 S.RegisterDelphiFunction(@SetImeMode, 'SetImeMode', cdRegister);
 S.RegisterDelphiFunction(@SetImeName, 'SetImeName', cdRegister);
 S.RegisterDelphiFunction(@Win32NLSEnableIME, 'Win32NLSEnableIME', cdRegister);
 S.RegisterDelphiFunction(@Imm32GetContext, 'Imm32GetContext', cdRegister);
 S.RegisterDelphiFunction(@Imm32ReleaseContext, 'Imm32ReleaseContext', cdRegister);
 S.RegisterDelphiFunction(@Imm32GetConversionStatus, 'Imm32GetConversionStatus', cdRegister);
 S.RegisterDelphiFunction(@Imm32SetConversionStatus, 'Imm32SetConversionStatus', cdRegister);
 S.RegisterDelphiFunction(@Imm32SetOpenStatus, 'Imm32SetOpenStatus', cdRegister);
 S.RegisterDelphiFunction(@Imm32SetCompositionWindow, 'Imm32SetCompositionWindow', cdRegister);
 S.RegisterDelphiFunction(@Imm32SetCompositionFont, 'Imm32SetCompositionFont', cdRegister);
 S.RegisterDelphiFunction(@Imm32GetCompositionString, 'Imm32GetCompositionString', cdRegister);
 S.RegisterDelphiFunction(@Imm32IsIME, 'Imm32IsIME', cdRegister);
 S.RegisterDelphiFunction(@Imm32NotifyIME, 'Imm32NotifyIME', cdRegister);
 S.RegisterDelphiFunction(@DragDone, 'DragDone', cdRegister);

end;





procedure RIRegister_Controls(Cl: TPSRuntimeClassImporter);
begin
  RIRegisterTControl(Cl);
  RIRegisterTWinControl(Cl);
  RIRegisterTGraphicControl(cl);
  RIRegisterTCustomControl(cl);
  RIRegister_TDragObject(cl);
  RIRegister_TImageList(CL);      //3.9.3
  RIRegister_TDragImageList(CL);
  RIRegister_TMouse(CL);

  RIRegister_TPadding(CL);
  RIRegister_TMargins(CL);
  RIRegister_TSizeConstraints(CL);
  RIRegister_TControlActionLink(CL);
  RIRegister_TControlAction(CL);
  RIRegister_TCustomControlAction(CL);
  RIRegister_TControlCanvas(CL);
  RIRegister_TCustomMultiSelectListControl(CL);
  RIRegister_TCustomListControl(CL);
  RIRegister_TCustomPanningWindow(CL);
  RIRegister_THintWindow(CL);
  RIRegister_TCustomTransparentControl(CL);


  //SIRegister_Controls(Cl: TPSPascalCompiler);         //main call

end;

// PS_MINIVCL changes by Martijn Laan (mlaan at wintax _dot_ nl)


end.
