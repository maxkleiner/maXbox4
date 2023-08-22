
// add procedure SIRegisterTSCREEN(Cl: TPSPascalCompiler);
// and NO NativeString         add TFrame 4.7.5.20      locs=1199

unit uPSR_forms;

{$I PascalScript.inc}
interface
uses
  uPSRuntime, uPSUtils, ActnList;

procedure RIRegisterTCONTROLSCROLLBAR(Cl: TPSRuntimeClassImporter);
{$IFNDEF FPC} procedure RIRegisterTSCROLLINGWINCONTROL(Cl: TPSRuntimeClassImporter);{$ENDIF}
procedure RIRegisterTSCROLLBOX(Cl: TPSRuntimeClassImporter);
procedure RIRegisterTFORM(Cl: TPSRuntimeClassImporter);
procedure RIRegisterTAPPLICATION(Cl: TPSRuntimeClassImporter);
procedure RIRegister_TScreen(CL: TPSRuntimeClassImporter);
procedure RIRegister_TStatusBar(CL: TPSRuntimeClassImporter);
procedure RIRegister_TCustomStatusBar(CL: TPSRuntimeClassImporter);
procedure RIRegister_TStatusPanels(CL: TPSRuntimeClassImporter);
procedure RIRegister_TStatusPanel(CL: TPSRuntimeClassImporter);
procedure RIRegister_TMonitor(CL: TPSRuntimeClassImporter);
procedure RIRegister_TGlassFrame(CL: TPSRuntimeClassImporter);
procedure RIRegister_TFrame(CL: TPSRuntimeClassImporter);
procedure RIRegister_TCustomFrame(CL: TPSRuntimeClassImporter);


procedure RIRegister_Forms(Cl: TPSRuntimeClassImporter);

implementation
uses
  sysutils, classes, types, {$IFDEF CLX}QControls, QForms,
   QGraphics{$ELSE}Controls, Forms, Windows, Graphics, ComCtrls {$ENDIF};

procedure TCONTROLSCROLLBARKIND_R(Self: TCONTROLSCROLLBAR; var T: TSCROLLBARKIND); begin T := Self.KIND; end;
procedure TCONTROLSCROLLBARSCROLLPOS_R(Self: TCONTROLSCROLLBAR; var T: INTEGER); begin t := Self.SCROLLPOS; end;

procedure RIRegisterTCONTROLSCROLLBAR(Cl: TPSRuntimeClassImporter);
begin
  with Cl.Add(TCONTROLSCROLLBAR) do begin
   RegisterMethod(@TCONTROLSCROLLBAR.Assign, 'Assign');
   RegisterMethod(@TCONTROLSCROLLBAR.ChangeBiDiPosition, 'ChangeBiDiPosition');
   RegisterMethod(@TCONTROLSCROLLBAR.IsScrollBarVisible, 'IsScrollBarVisible');
   RegisterPropertyHelper(@TCONTROLSCROLLBARKIND_R, nil, 'KIND');
    RegisterPropertyHelper(@TCONTROLSCROLLBARSCROLLPOS_R, nil, 'SCROLLPOS');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure TMonitorPrimary_R(Self: TMonitor; var T: Boolean);
begin T := Self.Primary; end;

(*----------------------------------------------------------------------------*)
procedure TMonitorWorkareaRect_R(Self: TMonitor; var T: TRect);
begin T := Self.WorkareaRect; end;

(*----------------------------------------------------------------------------*)
procedure TMonitorBoundsRect_R(Self: TMonitor; var T: TRect);
begin T := Self.BoundsRect; end;

(*----------------------------------------------------------------------------*)
procedure TMonitorWidth_R(Self: TMonitor; var T: Integer);
begin T := Self.Width; end;

(*----------------------------------------------------------------------------*)
procedure TMonitorTop_R(Self: TMonitor; var T: Integer);
begin T := Self.Top; end;

(*----------------------------------------------------------------------------*)
procedure TMonitorHeight_R(Self: TMonitor; var T: Integer);
begin T := Self.Height; end;

(*----------------------------------------------------------------------------*)
procedure TMonitorLeft_R(Self: TMonitor; var T: Integer);
begin T := Self.Left; end;

(*----------------------------------------------------------------------------*)
procedure TMonitorMonitorNum_R(Self: TMonitor; var T: Integer);
begin T := Self.MonitorNum; end;

(*----------------------------------------------------------------------------*)
procedure TMonitorHandle_R(Self: TMonitor; var T: integer);
begin T := Self.Handle; end;



(*----------------------------------------------------------------------------*)
procedure RIRegister_TMonitor(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TMonitor) do begin
    RegisterPropertyHelper(@TMonitorHandle_R,nil,'Handle');
    RegisterPropertyHelper(@TMonitorMonitorNum_R,nil,'MonitorNum');
    RegisterPropertyHelper(@TMonitorLeft_R,nil,'Left');
    RegisterPropertyHelper(@TMonitorHeight_R,nil,'Height');
    RegisterPropertyHelper(@TMonitorTop_R,nil,'Top');
    RegisterPropertyHelper(@TMonitorWidth_R,nil,'Width');
    RegisterPropertyHelper(@TMonitorBoundsRect_R,nil,'BoundsRect');
    RegisterPropertyHelper(@TMonitorWorkareaRect_R,nil,'WorkareaRect');
    RegisterPropertyHelper(@TMonitorPrimary_R,nil,'Primary');
  end;
end;


{$IFNDEF FPC}
procedure RIRegisterTSCROLLINGWINCONTROL(Cl: TPSRuntimeClassImporter);
begin
  with Cl.Add(TSCROLLINGWINCONTROL) do begin
    RegisterConstructor(@TSCROLLINGWINCONTROL.Create, 'Create');
    RegisterMethod(@TSCROLLINGWINCONTROL.Destroy, 'Free');
    RegisterMethod(@TSCROLLINGWINCONTROL.EnableAutoRange, 'EnableAutoRange');
    RegisterMethod(@TSCROLLINGWINCONTROL.DisableAutoRange, 'DisableAutoRange');
    RegisterMethod(@TSCROLLINGWINCONTROL.SCROLLINVIEW, 'SCROLLINVIEW');
    //RegisterPublishedProperties;
  end;
end;
{$ENDIF}

procedure RIRegisterTSCROLLBOX(Cl: TPSRuntimeClassImporter);
begin
  Cl.Add(TSCROLLBOX);
end;
{$IFNDEF FPC}
{$IFNDEF CLX}
procedure TFORMACTIVEOLECONTROL_W(Self: TFORM; T: TWINCONTROL); begin Self.ACTIVEOLECONTROL := T; end;
procedure TFORMACTIVEOLECONTROL_R(Self: TFORM; var T: TWINCONTROL); begin T := Self.ACTIVEOLECONTROL; 
end;
procedure TFORMTILEMODE_W(Self: TFORM; T: TTILEMODE); begin Self.TILEMODE := T; end;
procedure TFORMTILEMODE_R(Self: TFORM; var T: TTILEMODE); begin T := Self.TILEMODE; end;
{$ENDIF}{CLX}
procedure TFORMACTIVEMDICHILD_R(Self: TFORM; var T: TFORM); begin T := Self.ACTIVEMDICHILD; end;
procedure TFORMDROPTARGET_W(Self: TFORM; T: BOOLEAN); begin Self.DROPTARGET := T; end;
procedure TFORMDROPTARGET_R(Self: TFORM; var T: BOOLEAN); begin T := Self.DROPTARGET; end;
procedure TFORMMDICHILDCOUNT_R(Self: TFORM; var T: INTEGER); begin T := Self.MDICHILDCOUNT; end;
procedure TFORMMDICHILDREN_R(Self: TFORM; var T: TFORM; t1: INTEGER); begin T := Self.MDICHILDREN[T1]; 
end;
{$ENDIF}{FPC}

procedure TFORMMODALRESULT_W(Self: TFORM; T: TMODALRESULT); begin Self.MODALRESULT := T; end;
procedure TFORMMODALRESULT_R(Self: TFORM; var T: TMODALRESULT); begin T := Self.MODALRESULT; end;
procedure TFORMACTIVE_R(Self: TFORM; var T: BOOLEAN); begin T := Self.ACTIVE; end;
procedure TFORMClientRect_R(Self: TFORM; var T: TRect); begin T := Self.ClientRect; end;
//procedure TFORMClientRect_W(Self: TFORM; var T: TRect); begin Self.ClientRect:= T; end;

procedure TFORMCANVAS_R(Self: TFORM; var T: TCANVAS); begin T := Self.CANVAS; end;
procedure TFORMBUFFER_R(Self: TFORM; var T: BOOLEAN); begin T:= Self.DoubleBuffered; end;
procedure TFORMBUFFER_W(Self: TFORM; T: BOOLEAN); begin Self.DoubleBuffered:= T; end;
procedure TFORMIcon_W(Self: TFORM; T: TICON); begin Self.Icon:= T; end;
procedure TFORMIcon_R(Self: TFORM; var T: TICON); begin T:= Self.Icon; end;

procedure TFORMBorderwidth_W(Self: TFORM; T: TBorderWidth); begin Self.BorderWidth:= T; end;
procedure TFORMBorderwidth_R(Self: TFORM; var T: TBorderWidth); begin T:= Self.BorderWidth; end;

//procedure TFORMState_W(Self: TFORM; T: TFormState); begin Self.Formstate:= T; end;
procedure TFORMState_R(Self: TFORM; var T: TFormState); begin T:= Self.FormState; end;

procedure TFAPPLICATIONONMINIMIZE_R(Self: TApplication; var T: TNOTIFYEVENT); begin T := Self.ONMINIMIZE; end;
procedure TFAPPLICATIONONMINIMIZE_W(Self: TApplication; T: TNOTIFYEVENT); begin Self.ONMINIMIZE := T; end;

procedure TFAPPLICATIONONRESTORE_R(Self: TAPPLICATION; var T: TNOTIFYEVENT); begin T := Self.ONRESTORE; end;
procedure TFAPPLICATIONONRESTORE_W(Self: TAPPLICATION; T: TNOTIFYEVENT); begin Self.ONRESTORE := T; end;

procedure TApplicationIcon_W(Self: TApplication; T: TICON); begin Self.Icon:= T; end;
procedure TApplicationIcon_R(Self: TApplication; var T: TICON); begin T:= Self.Icon; end;



{$IFNDEF CLX}
procedure TFORMCLIENTHANDLE_R(Self: TFORM; var T: Longint); begin T:= Self.CLIENTHANDLE; end;
{$ENDIF}

{ Innerfuse Pascal Script Class Import Utility (runtime) }

procedure RIRegisterTFORM(Cl: TPSRuntimeClassImporter);
begin
  with Cl.Add(TFORM) do begin
    {$IFDEF DELPHI4UP}
    RegisterVirtualConstructor(@TFORM.CREATENEW, 'CREATENEW');
    {$ELSE}
    RegisterConstructor(@TFORM.CREATENEW, 'CREATENEW');
    {$ENDIF}
    RegisterMethod(@TForm.Destroy, 'Free');
    RegisterMethod(@TForm.FreeOnRelease, 'FreeOnRelease');

    RegisterConstructor(@TForm.Create, 'CREATE');
    RegisterMethod(@TFORM.CLOSE, 'CLOSE');
    RegisterMethod(@TFORM.HIDE, 'HIDE');
    RegisterMethod(@TFORM.SHOW, 'SHOW');
    RegisterMethod(@TFORM.SHOWMODAL, 'SHOWMODAL');
    RegisterMethod(@TFORM.InstanceSize, 'InstanceSize');
    RegisterMethod(@TFORM.Dock, 'Dock');
    RegisterMethod(@TFORM.RELEASE, 'RELEASE');
    RegisterMethod(@TFORM.ClassNameIs, 'ClassNameIs');
    RegisterMethod(@TFORM.RecreateAsPopup, 'RecreateAsPopup');
    RegisterMethod(@TFORM.IsShortCut, 'IsShortCut');
    RegisterMethod(@TFORM.MakeFullyVisible, 'MakeFullyVisible');
    RegisterMethod(@TFORM.SendCancelMode, 'SendCancelMode');
    RegisterMethod(@TFORM.DefaultHandler, 'DefaultHandler');
    RegisterMethod(@TFORM.Dock, 'Dock');
    RegisterMethod(@TFORM.GetFormImage, 'GetFormImage');
    RegisterMethod(@TFORM.MouseWheelHandler, 'MouseWheelHandler');
    RegisterMethod(@TFORM.WantChildKey, 'WantChildKey');

     //procedure RecreateAsPopup(AWindowHandle: HWND);
    //RegisterMethod(@TFORM.Maximize, 'MINIMIZE');
    //RegisterMethod(@TFORM.MakeFullyVisible, 'MAXIMIZE');

    //RegisterMethod(@TFORM.MINIMIZE, 'MINIMIZE');
    //RegisterMethod(@TFORM.RESTORE, 'RESTORE');
    RegisterPropertyHelper(@TFAPPLICATIONONMINIMIZE_R, @TFAPPLICATIONONMINIMIZE_W, 'ONMINIMIZE');
    RegisterPropertyHelper(@TFAPPLICATIONONRESTORE_R, @TFAPPLICATIONONRESTORE_W, 'ONRESTORE');

    RegisterPropertyHelper(@TFORMACTIVE_R, nil, 'ACTIVE');
    RegisterPropertyHelper(@TFORMClientRect_R, nil, 'ClientRect');

    RegisterPropertyHelper(@TFORMBUFFER_R, @TFORMBUFFER_W,'DOUBLEBUFFERED');
    RegisterPropertyHelper(@TFORMState_R, NIL,'FormState');


    {$IFNDEF PS_MINIVCL}
 {$IFNDEF FPC}
{$IFNDEF CLX} 
    RegisterMethod(@TFORM.ARRANGEICONS, 'ARRANGEICONS');
    RegisterMethod(@TFORM.GETFORMIMAGE, 'GETFORMIMAGE');
    RegisterMethod(@TFORM.PRINT, 'PRINT');
    RegisterMethod(@TFORM.SENDCANCELMODE, 'SENDCANCELMODE');
    RegisterPropertyHelper(@TFORMACTIVEOLECONTROL_R, @TFORMACTIVEOLECONTROL_W, 'ACTIVEOLECONTROL');
    RegisterPropertyHelper(@TFORMCLIENTHANDLE_R, nil, 'CLIENTHANDLE');
    RegisterPropertyHelper(@TFORMTILEMODE_R, @TFORMTILEMODE_W, 'TILEMODE');
{$ENDIF}{CLX}
    RegisterMethod(@TFORM.CASCADE, 'CASCADE');
    RegisterMethod(@TFORM.NEXT, 'NEXT');
    RegisterMethod(@TFORM.PREVIOUS, 'PREVIOUS');
    RegisterMethod(@TFORM.TILE, 'TILE');
    RegisterPropertyHelper(@TFORMACTIVEMDICHILD_R, nil, 'ACTIVEMDICHILD');
    RegisterPropertyHelper(@TFORMDROPTARGET_R, @TFORMDROPTARGET_W, 'DROPTARGET');
    RegisterPropertyHelper(@TFORMMDICHILDCOUNT_R, nil, 'MDICHILDCOUNT');
    RegisterPropertyHelper(@TFORMMDICHILDREN_R, nil, 'MDICHILDREN');
 {$ENDIF}{FPC}
    RegisterMethod(@TFORM.CLOSEQUERY, 'CLOSEQUERY');
    RegisterMethod(@TFORM.DEFOCUSCONTROL, 'DEFOCUSCONTROL');
    RegisterMethod(@TFORM.FOCUSCONTROL, 'FOCUSCONTROL');
    RegisterMethod(@TFORM.SETFOCUSEDCONTROL, 'SETFOCUSEDCONTROL');
    RegisterPropertyHelper(@TFORMCANVAS_R, nil, 'CANVAS');
    RegisterPropertyHelper(@TFORMMODALRESULT_R, @TFORMMODALRESULT_W, 'MODALRESULT');
    RegisterPropertyHelper(@TFORMIcon_R, @TFORMIcon_W, 'ICON');
    RegisterPropertyHelper(@TFORMBorderwidth_R, @TFORMBorderWidth_W, 'BorderWidth');

    {$ENDIF}{PS_MINIVCL}
  end;
end;

 {$IFNDEF FPC}
procedure TAPPLICATIONACTIVE_R(Self: TAPPLICATION; var T: BOOLEAN); begin T := Self.ACTIVE; end;
{$IFNDEF CLX}
procedure TAPPLICATIONDIALOGHANDLE_R(Self: TAPPLICATION; var T: Longint); begin T := Self.DIALOGHANDLE; end;
procedure TAPPLICATIONDIALOGHANDLE_W(Self: TAPPLICATION; T: Longint); begin Self.DIALOGHANDLE := T; end;
procedure TAPPLICATIONHANDLE_R(Self: TAPPLICATION; var T: Longint); begin T := Self.HANDLE; end;
procedure TAPPLICATIONHANDLE_W(Self: TAPPLICATION; T: Longint); begin Self.HANDLE := T; end;
procedure TAPPLICATIONUPDATEFORMATSETTINGS_R(Self: TAPPLICATION; var T: BOOLEAN); begin T := Self.UPDATEFORMATSETTINGS; end;
procedure TAPPLICATIONUPDATEFORMATSETTINGS_W(Self: TAPPLICATION; T: BOOLEAN); begin Self.UPDATEFORMATSETTINGS := T; end;
{$ENDIF}
{$ENDIF}{FPC}


procedure TAPPLICATIONEXENAME_R(Self: TAPPLICATION; var T: STRING); begin T := Self.EXENAME; end;
procedure TAPPLICATIONHELPFILE_R(Self: TAPPLICATION; var T: STRING); begin T := Self.HELPFILE; end;
procedure TAPPLICATIONHELPFILE_W(Self: TAPPLICATION; T: STRING); begin Self.HELPFILE := T; end;
procedure TAPPLICATIONHINT_R(Self: TAPPLICATION; var T: STRING); begin T := Self.HINT; end;
procedure TAPPLICATIONHINT_W(Self: TAPPLICATION; T: STRING); begin Self.HINT := T; end;
procedure TAPPLICATIONHINTCOLOR_R(Self: TAPPLICATION; var T: TCOLOR); begin T := Self.HINTCOLOR; end;
procedure TAPPLICATIONHINTCOLOR_W(Self: TAPPLICATION; T: TCOLOR); begin Self.HINTCOLOR := T; end;
procedure TAPPLICATIONHINTPAUSE_R(Self: TAPPLICATION; var T: INTEGER); begin T := Self.HINTPAUSE; end;
procedure TAPPLICATIONHINTPAUSE_W(Self: TAPPLICATION; T: INTEGER); begin Self.HINTPAUSE := T; end;
procedure TAPPLICATIONHINTshort_W(Self: TAPPLICATION; T: Boolean); begin Self.HintShortCuts:= T; end;
procedure TAPPLICATIONHINTShort_R(Self: TAPPLICATION; var T: Boolean); begin T:= Self.HINTShortcuts; end;

procedure TAPPLICATIONHINTSHORTPAUSE_R(Self: TAPPLICATION; var T: INTEGER); begin T := Self.HINTSHORTPAUSE; end;
procedure TAPPLICATIONHINTSHORTPAUSE_W(Self: TAPPLICATION; T: INTEGER); begin Self.HINTSHORTPAUSE := T; end;
procedure TAPPLICATIONHINTHIDEPAUSE_R(Self: TAPPLICATION; var T: INTEGER); begin T := Self.HINTHIDEPAUSE; end;
procedure TAPPLICATIONHINTHIDEPAUSE_W(Self: TAPPLICATION; T: INTEGER); begin Self.HINTHIDEPAUSE := T; end;
procedure TAPPLICATIONMAINFORM_R(Self: TAPPLICATION; var T: {$IFDEF DELPHI3UP}TCustomForm{$ELSE}TFORM{$ENDIF}); begin T := Self.MAINFORM; end;
procedure TAPPLICATIONMAINFORMHandle_R(Self: TAPPLICATION; var T: HWND); begin T:= Self.MAINFORMHandle; end;
procedure TAPPLICATIONActiveFORMHandle_R(Self: TAPPLICATION; var T: HWND); begin T:= Self.ActiveFORMHandle; end;

procedure TAPPLICATIONSHOWHINT_R(Self: TAPPLICATION; var T: BOOLEAN); begin T := Self.SHOWHINT; end;
procedure TAPPLICATIONSHOWHINT_W(Self: TAPPLICATION; T: BOOLEAN); begin Self.SHOWHINT := T; end;
procedure TAPPLICATIONSHOWMAINFORM_R(Self: TAPPLICATION; var T: BOOLEAN); begin T := Self.SHOWMAINFORM; end;
procedure TAPPLICATIONSHOWMAINFORM_W(Self: TAPPLICATION; T: BOOLEAN); begin Self.SHOWMAINFORM := T; end;
procedure TAPPLICATIONTERMINATED_R(Self: TAPPLICATION; var T: BOOLEAN); begin T := Self.TERMINATED; end;
procedure TAPPLICATIONTITLE_R(Self: TAPPLICATION; var T: STRING); begin T := Self.TITLE; end;
procedure TAPPLICATIONTITLE_W(Self: TAPPLICATION; T: STRING); begin Self.TITLE := T; end;

{$IFNDEF FPC}
procedure TAPPLICATIONONACTIVATE_R(Self: TAPPLICATION; var T: TNOTIFYEVENT); begin T := Self.ONACTIVATE; end;
procedure TAPPLICATIONONACTIVATE_W(Self: TAPPLICATION; T: TNOTIFYEVENT); begin Self.ONACTIVATE := T; end;
procedure TAPPLICATIONONDEACTIVATE_R(Self: TAPPLICATION; var T: TNOTIFYEVENT); begin T := Self.ONDEACTIVATE; end;
procedure TAPPLICATIONONDEACTIVATE_W(Self: TAPPLICATION; T: TNOTIFYEVENT); begin Self.ONDEACTIVATE := T; end;
{$ENDIF}

procedure TAPPLICATIONONIDLE_R(Self: TAPPLICATION; var T: TIDLEEVENT); begin T := Self.ONIDLE; end;
procedure TAPPLICATIONONIDLE_W(Self: TAPPLICATION; T: TIDLEEVENT); begin Self.ONIDLE := T; end;
procedure TAPPLICATIONONHELP_R(Self: TAPPLICATION; var T: THELPEVENT); begin T := Self.ONHELP; end;
procedure TAPPLICATIONONHELP_W(Self: TAPPLICATION; T: THELPEVENT); begin Self.ONHELP := T; end;
procedure TAPPLICATIONONHINT_R(Self: TAPPLICATION; var T: TNOTIFYEVENT); begin T := Self.ONHINT; end;
procedure TAPPLICATIONONHINT_W(Self: TAPPLICATION; T: TNOTIFYEVENT); begin Self.ONHINT := T; end;
procedure TAPPLICATIONONEXCEPTION_R(Self: TAPPLICATION; var T: TEXCEPTIONEVENT); begin T := Self.OnException; end;
procedure TAPPLICATIONONEXCEPTION_W(Self: TAPPLICATION; T: TEXCEPTIONEVENT); begin Self.ONEXCEPTION:= T; end;
procedure TAPPLICATIONONMESSAGE_R(Self: TAPPLICATION; var T: TMESSAGEEVENT); begin T := Self.ONMESSAGE; end;
procedure TAPPLICATIONONMESSAGE_W(Self: TAPPLICATION; T: TMESSAGEEVENT); begin Self.ONMESSAGE:= T; end;
procedure TAPPLICATIONONSETTINGCHANGE_W(Self: TAPPLICATION; T: TSettingChangeEvent);
 begin Self.ONSETTINGCHANGE:= T;
  end;
procedure TAPPLICATIONONSETTINGCHANGE_R(Self: TAPPLICATION; var T: TSettingChangeEvent);
 begin T := Self.ONSETTINGCHANGE;
  end;


{$IFNDEF FPC}
procedure TAPPLICATIONONMINIMIZE_R(Self: TAPPLICATION; var T: TNOTIFYEVENT); begin T := Self.ONMINIMIZE; end;
procedure TAPPLICATIONONMINIMIZE_W(Self: TAPPLICATION; T: TNOTIFYEVENT); begin Self.ONMINIMIZE := T; end;

procedure TAPPLICATIONONRESTORE_R(Self: TAPPLICATION; var T: TNOTIFYEVENT); begin T := Self.ONRESTORE; end;
procedure TAPPLICATIONONRESTORE_W(Self: TAPPLICATION; T: TNOTIFYEVENT); begin Self.ONRESTORE := T; end;
{$ENDIF}


(* === new run-time registration functions === 3.9.3*)
(*----------------------------------------------------------------------------*)

(*----------------------------------------------------------------------------*)
procedure TApplicationOnShortCut_W(Self: TApplication; const T: TShortCutEvent);
begin Self.OnShortCut := T; end;

(*----------------------------------------------------------------------------*)
procedure TApplicationOnShortCut_R(Self: TApplication; var T: TShortCutEvent);
begin T := Self.OnShortCut; end;

(*----------------------------------------------------------------------------*)
procedure TApplicationOnShowHint_W(Self: TApplication; const T: TShowHintEvent);
begin Self.OnShowHint := T; end;

(*----------------------------------------------------------------------------*)
procedure TApplicationOnShowHint_R(Self: TApplication; var T: TShowHintEvent);
begin T := Self.OnShowHint; end;


(*----------------------------------------------------------------------------*)
procedure TApplicationOnModalEnd_W(Self: TApplication; const T: TNotifyEvent);
begin Self.OnModalEnd := T; end;

(*----------------------------------------------------------------------------*)
procedure TApplicationOnModalEnd_R(Self: TApplication; var T: TNotifyEvent);
begin T := Self.OnModalEnd; end;

(*----------------------------------------------------------------------------*)
procedure TApplicationOnModalBegin_W(Self: TApplication; const T: TNotifyEvent);
begin Self.OnModalBegin := T; end;

(*----------------------------------------------------------------------------*)
procedure TApplicationOnModalBegin_R(Self: TApplication; var T: TNotifyEvent);
begin T := Self.OnModalBegin; end;

(*----------------------------------------------------------------------------*)
procedure TApplicationOnGetMainFormHandle_W(Self: TApplication; const T: TGetHandleEvent);
begin Self.OnGetMainFormHandle := T; end;

(*----------------------------------------------------------------------------*)
procedure TApplicationOnGetMainFormHandle_R(Self: TApplication; var T: TGetHandleEvent);
begin T := Self.OnGetMainFormHandle; end;

(*----------------------------------------------------------------------------*)
procedure TApplicationOnGetActiveFormHandle_W(Self: TApplication; const T: TGetHandleEvent);
begin Self.OnGetActiveFormHandle := T; end;

(*----------------------------------------------------------------------------*)
procedure TApplicationOnGetActiveFormHandle_R(Self: TApplication; var T: TGetHandleEvent);
begin T := Self.OnGetActiveFormHandle; end;

(*----------------------------------------------------------------------------*)
procedure TApplicationOnActionUpdate_W(Self: TApplication; const T: TActionEvent);
begin Self.OnActionUpdate := T; end;

(*----------------------------------------------------------------------------*)
procedure TApplicationOnActionUpdate_R(Self: TApplication; var T: TActionEvent);
begin T := Self.OnActionUpdate; end;

(*----------------------------------------------------------------------------*)
procedure TApplicationOnActionExecute_W(Self: TApplication; const T: TActionEvent);
begin Self.OnActionExecute := T; end;

(*----------------------------------------------------------------------------*)
procedure TApplicationOnActionExecute_R(Self: TApplication; var T: TActionEvent);
begin T := Self.OnActionExecute; end;

(*----------------------------------------------------------------------------*)
procedure TApplicationUpdateMetricSettings_W(Self: TApplication; const T: Boolean);
begin Self.UpdateMetricSettings := T; end;

(*----------------------------------------------------------------------------*)
procedure TApplicationUpdateMetricSettings_R(Self: TApplication; var T: Boolean);
begin T := Self.UpdateMetricSettings; end;

(*----------------------------------------------------------------------------*)
procedure TApplicationPopupControlWnd_R(Self: TApplication; var T: HWND);
begin T := Self.PopupControlWnd; end;

(*----------------------------------------------------------------------------*)
procedure TApplicationNonBiDiKeyboard_W(Self: TApplication; const T: string);
begin Self.NonBiDiKeyboard := T; end;

(*----------------------------------------------------------------------------*)
procedure TApplicationNonBiDiKeyboard_R(Self: TApplication; var T: string);
begin T := Self.NonBiDiKeyboard; end;

(*----------------------------------------------------------------------------*)
procedure TApplicationBiDiKeyboard_W(Self: TApplication; const T: string);
begin Self.BiDiKeyboard := T; end;

(*----------------------------------------------------------------------------*)
procedure TApplicationBiDiKeyboard_R(Self: TApplication; var T: string);
begin T := Self.BiDiKeyboard; end;

(*----------------------------------------------------------------------------*)
procedure TApplicationBiDiMode_W(Self: TApplication; const T: TBiDiMode);
begin Self.BiDiMode := T; end;

(*----------------------------------------------------------------------------*)
procedure TApplicationBiDiMode_R(Self: TApplication; var T: TBiDiMode);
begin T := Self.BiDiMode; end;

(*----------------------------------------------------------------------------*)
procedure TApplicationModalPopupMode_W(Self: TApplication; const T: TPopupMode);
begin Self.ModalPopupMode := T; end;

(*----------------------------------------------------------------------------*)
procedure TApplicationModalPopupMode_R(Self: TApplication; var T: TPopupMode);
begin T := Self.ModalPopupMode; end;

(*----------------------------------------------------------------------------*)
procedure TApplicationModalLevel_R(Self: TApplication; var T: Integer);
begin T := Self.ModalLevel; end;

(*----------------------------------------------------------------------------*)
(*----------------------------------------------------------------------------*)
{procedure TApplicationIcon_W(Self: TApplication; const T: TIcon);
begin Self.Icon := T; end;

(*----------------------------------------------------------------------------*)
procedure TApplicationIcon_R(Self: TApplication; var T: TIcon);
begin T := Self.Icon; end; }

(*----------------------------------------------------------------------------*)
procedure TApplicationHintShortCuts_W(Self: TApplication; const T: Boolean);
begin Self.HintShortCuts := T; end;

(*----------------------------------------------------------------------------*)
procedure TApplicationHintShortCuts_R(Self: TApplication; var T: Boolean);
begin T := Self.HintShortCuts; end;

(*----------------------------------------------------------------------------*)
procedure TApplicationCurrentHelpFile_R(Self: TApplication; var T: string);
begin T := Self.CurrentHelpFile; end;

(*----------------------------------------------------------------------------*)
//procedure TApplicationHelpSystem_R(Self: TApplication; var T: IHelpSystem);
//begin T := Self.HelpSystem; end;

(*----------------------------------------------------------------------------*)
procedure TApplicationAutoDragDocking_W(Self: TApplication; const T: Boolean);
begin Self.AutoDragDocking := T; end;

(*----------------------------------------------------------------------------*)
procedure TApplicationAutoDragDocking_R(Self: TApplication; var T: Boolean);
begin T := Self.AutoDragDocking; end;

(*----------------------------------------------------------------------------*)
procedure TApplicationAllowTesting_W(Self: TApplication; const T: Boolean);
begin Self.AllowTesting := T; end;

(*----------------------------------------------------------------------------*)
procedure TApplicationAllowTesting_R(Self: TApplication; var T: Boolean);
begin T := Self.AllowTesting; end;

(*----------------------------------------------------------------------------*)
procedure TApplicationActionUpdateDelay_W(Self: TApplication; const T: Integer);
begin Self.ActionUpdateDelay := T; end;

(*----------------------------------------------------------------------------*)
procedure TApplicationActionUpdateDelay_R(Self: TApplication; var T: Integer);
begin T := Self.ActionUpdateDelay; end;

(*----------------------------------------------------------------------------*)


procedure RIRegisterTAPPLICATION(Cl: TPSRuntimeClassImporter);
begin
 //with CL.Add(Exception) do
  with Cl.Add(TAPPLICATION) do begin
 {$IFNDEF FPC}
    RegisterMethod(@TAPPLICATION.MINIMIZE, 'MINIMIZE');
    RegisterMethod(@TAPPLICATION.RESTORE, 'RESTORE');
    RegisterPropertyHelper(@TAPPLICATIONACTIVE_R, nil, 'ACTIVE');
    RegisterPropertyHelper(@TAPPLICATIONONACTIVATE_R, @TAPPLICATIONONACTIVATE_W, 'ONACTIVATE');
    RegisterPropertyHelper(@TAPPLICATIONONDEACTIVATE_R, @TAPPLICATIONONDEACTIVATE_W, 'ONDEACTIVATE');
    RegisterPropertyHelper(@TAPPLICATIONONMINIMIZE_R, @TAPPLICATIONONMINIMIZE_W, 'ONMINIMIZE');
    RegisterPropertyHelper(@TAPPLICATIONONRESTORE_R, @TAPPLICATIONONRESTORE_W, 'ONRESTORE');
    RegisterPropertyHelper(@TAPPLICATIONDIALOGHANDLE_R, @TAPPLICATIONDIALOGHANDLE_W, 'DIALOGHANDLE');
    RegisterMethod(@TAPPLICATION.CREATEHANDLE, 'CREATEHANDLE');
    RegisterMethod(@TAPPLICATION.NORMALIZETOPMOSTS, 'NORMALIZETOPMOSTS');
    RegisterMethod(@TAPPLICATION.RESTORETOPMOSTS, 'RESTORETOPMOSTS');
    RegisterMethod(@TApplication.InstanceSize, 'InstanceSize');
    RegisterMethod(@TApplication.ModalStarted, 'ModalStarted');
    RegisterMethod(@TApplication.ModalFinished, 'ModalFinished');
    RegisterMethod(@TApplication.IsRightToLeft, 'IsRightToLeft');
    RegisterMethod(@TApplication.ShowException, 'ShowException');
    RegisterMethod(@TApplication.DoApplicationIdle, 'DoApplicationIdle');
    //3.9.3
    RegisterMethod(@TApplication.ActivateHint, 'ActivateHint');
    RegisterMethod(@TApplication.AddPopupForm, 'AddPopupForm');
    RegisterMethod(@TApplication.ControlDestroyed, 'ControlDestroyed');
    RegisterMethod(@TApplication.CreateHandle, 'CreateHandle');
    RegisterMethod(@TApplication.ExecuteAction, 'ExecuteAction');
    RegisterMethod(@TApplication.HelpKeyword, 'HelpKeyword');
    RegisterMethod(@TApplication.HelpShowTableOfContents, 'HelpShowTableOfContents');
    RegisterMethod(@TApplication.HintMouseMessage, 'HintMouseMessage');
    RegisterMethod(@TApplication.NormalizeAllTopMosts, 'NormalizeAllTopMosts');
    RegisterMethod(@TApplication.RemovePopupForm, 'RemovePopupForm');
    RegisterMethod(@TApplication.UpdateAction, 'UpdateAction');
    RegisterMethod(@TApplication.UseRightToLeftAlignment, 'UseRightToLeftAlignment');
    RegisterMethod(@TApplication.UseRightToLeftReading, 'UseRightToLeftReading');
    RegisterMethod(@TApplication.UseRightToLeftScrollBar, 'UseRightToLeftScrollBar');


    {$IFNDEF CLX}
    RegisterPropertyHelper(@TAPPLICATIONHANDLE_R, @TAPPLICATIONHANDLE_W, 'HANDLE');
    RegisterPropertyHelper(@TAPPLICATIONUPDATEFORMATSETTINGS_R, @TAPPLICATIONUPDATEFORMATSETTINGS_W, 'UPDATEFORMATSETTINGS');
    {$ENDIF}
 {$ENDIF}
    RegisterMethod(@TAPPLICATION.BRINGTOFRONT, 'BRINGTOFRONT');
    RegisterMethod(@TAPPLICATION.MESSAGEBOX, 'MESSAGEBOX');
    RegisterMethod(@TAPPLICATION.PROCESSMESSAGES, 'PROCESSMESSAGES');
    RegisterMethod(@TAPPLICATION.TERMINATE, 'TERMINATE');
    RegisterPropertyHelper(@TAPPLICATIONEXENAME_R, nil, 'EXENAME');
    RegisterPropertyHelper(@TAPPLICATIONHINT_R, @TAPPLICATIONHINT_W, 'HINT');
    RegisterPropertyHelper(@TAPPLICATIONMAINFORM_R, nil, 'MAINFORM');
    RegisterPropertyHelper(@TAPPLICATIONSHOWHINT_R, @TAPPLICATIONSHOWHINT_W, 'SHOWHINT');
    RegisterPropertyHelper(@TAPPLICATIONSHOWMAINFORM_R, @TAPPLICATIONSHOWMAINFORM_W, 'SHOWMAINFORM');
    RegisterPropertyHelper(@TAPPLICATIONTERMINATED_R, nil, 'TERMINATED');
    RegisterPropertyHelper(@TAPPLICATIONTITLE_R, @TAPPLICATIONTITLE_W, 'TITLE');
    RegisterPropertyHelper(@TAPPLICATIONONIDLE_R, @TAPPLICATIONONIDLE_W, 'ONIDLE');
    RegisterPropertyHelper(@TAPPLICATIONONHINT_R, @TAPPLICATIONONHINT_W, 'ONHINT');
    //RegisterPropertyHelper(@TAPPLICATIONONHINT_R, @TAPPLICATIONONHINT_W, 'ONHINT');
    RegisterPropertyHelper(@TAPPLICATIONONEXCEPTION_R, @TAPPLICATIONONEXCEPTION_W, 'ONEXCEPTION');
    RegisterPropertyHelper(@TAPPLICATIONONMESSAGE_R, @TAPPLICATIONONMESSAGE_W, 'ONMESSAGE');
    RegisterPropertyHelper(@TAPPLICATIONONSETTINGCHANGE_R, @TAPPLICATIONONSETTINGCHANGE_W, 'ONSETTINGCHANGE');

   RegisterPropertyHelper(@TApplicationActive_R,nil,'Active');
    RegisterPropertyHelper(@TApplicationActionUpdateDelay_R,@TApplicationActionUpdateDelay_W,'ActionUpdateDelay');
    RegisterPropertyHelper(@TApplicationAllowTesting_R,@TApplicationAllowTesting_W,'AllowTesting');
    RegisterPropertyHelper(@TApplicationAutoDragDocking_R,@TApplicationAutoDragDocking_W,'AutoDragDocking');
    //RegisterPropertyHelper(@TApplicationHelpSystem_R,nil,'HelpSystem');
    RegisterPropertyHelper(@TApplicationCurrentHelpFile_R,nil,'CurrentHelpFile');
    //RegisterPropertyHelper(@TApplicationHintShortCuts_R,@TApplicationHintShortCuts_W,'HintShortCuts');
    //RegisterPropertyHelper(@TApplicationHintShortPause_R,@TApplicationHintShortPause_W,'HintShortPause');
    RegisterPropertyHelper(@TApplicationModalLevel_R,nil,'ModalLevel');
    RegisterPropertyHelper(@TApplicationModalPopupMode_R,@TApplicationModalPopupMode_W,'ModalPopupMode');
    RegisterPropertyHelper(@TApplicationBiDiMode_R,@TApplicationBiDiMode_W,'BiDiMode');
    RegisterPropertyHelper(@TApplicationBiDiKeyboard_R,@TApplicationBiDiKeyboard_W,'BiDiKeyboard');
    RegisterPropertyHelper(@TApplicationNonBiDiKeyboard_R,@TApplicationNonBiDiKeyboard_W,'NonBiDiKeyboard');
    RegisterPropertyHelper(@TApplicationPopupControlWnd_R,nil,'PopupControlWnd');
    RegisterPropertyHelper(@TApplicationUpdateMetricSettings_R,@TApplicationUpdateMetricSettings_W,'UpdateMetricSettings');
    RegisterPropertyHelper(@TApplicationOnActionExecute_R,@TApplicationOnActionExecute_W,'OnActionExecute');
    RegisterPropertyHelper(@TApplicationOnActionUpdate_R,@TApplicationOnActionUpdate_W,'OnActionUpdate');
    RegisterPropertyHelper(@TApplicationOnGetActiveFormHandle_R,@TApplicationOnGetActiveFormHandle_W,'OnGetActiveFormHandle');
    RegisterPropertyHelper(@TApplicationOnGetMainFormHandle_R,@TApplicationOnGetMainFormHandle_W,'OnGetMainFormHandle');
    RegisterPropertyHelper(@TApplicationOnModalBegin_R,@TApplicationOnModalBegin_W,'OnModalBegin');
    RegisterPropertyHelper(@TApplicationOnModalEnd_R,@TApplicationOnModalEnd_W,'OnModalEnd');
    //RegisterPropertyHelper(@TApplicationOnRestore_R,@TApplicationOnRestore_W,'OnRestore');
    RegisterPropertyHelper(@TApplicationOnShowHint_R,@TApplicationOnShowHint_W,'OnShowHint');
    RegisterPropertyHelper(@TApplicationOnShortCut_R,@TApplicationOnShortCut_W,'OnShortCut');
    //RegisterPropertyHelper(@TApplicationOnSettingChange_R,@TApplicationOnSettingChange_W,'OnSettingChange');
     RegisterPropertyHelper(@TApplicationIcon_R, @TApplicationIcon_W, 'ICON');


   //TAPPLICATIONONEXCEPTION_R
  //ONEXCEPTION
    {$IFNDEF PS_MINIVCL}
    RegisterMethod(@TAPPLICATION.CONTROLDESTROYED, 'CONTROLDESTROYED');
    RegisterMethod(@TAPPLICATION.CANCELHINT, 'CANCELHINT');
    {$IFNDEF CLX}
    {$IFNDEF FPC}
    RegisterMethod(@TAPPLICATION.HELPCOMMAND, 'HELPCOMMAND');
    {$ENDIF}
    RegisterMethod(@TAPPLICATION.HELPCONTEXT, 'HELPCONTEXT');
    {$IFNDEF FPC}
    RegisterMethod(@TAPPLICATION.HELPJUMP, 'HELPJUMP');
    {$ENDIF}
    {$ENDIF}
    RegisterMethod(@TAPPLICATION.HANDLEEXCEPTION, 'HANDLEEXCEPTION');
    RegisterMethod(@TAPPLICATION.HOOKMAINWINDOW, 'HOOKMAINWINDOW');
    RegisterMethod(@TAPPLICATION.UNHOOKMAINWINDOW, 'UNHOOKMAINWINDOW');
    RegisterMethod(@TApplication.UnhookSynchronizeWakeup, 'UnhookSynchronizeWakeup');


    RegisterMethod(@TAPPLICATION.HANDLEMESSAGE, 'HANDLEMESSAGE');
    RegisterMethod(@TAPPLICATION.HIDEHINT, 'HIDEHINT');
    RegisterMethod(@TAPPLICATION.HINTMOUSEMESSAGE, 'HINTMOUSEMESSAGE');
    RegisterMethod(@TAPPLICATION.INITIALIZE, 'INITIALIZE');
    RegisterMethod(@TAPPLICATION.RUN, 'RUN');
    RegisterMethod(@Tapplication.HookSynchronizeWakeup,'HookSynchronizeWakeup');
    RegisterMethod(@TAPPLICATION.SHOWEXCEPTION, 'SHOWEXCEPTION');
    RegisterPropertyHelper(@TAPPLICATIONHELPFILE_R, @TAPPLICATIONHELPFILE_W, 'HELPFILE');
    RegisterPropertyHelper(@TAPPLICATIONHINTCOLOR_R, @TAPPLICATIONHINTCOLOR_W, 'HINTCOLOR');
    RegisterPropertyHelper(@TAPPLICATIONHINTPAUSE_R, @TAPPLICATIONHINTPAUSE_W, 'HINTPAUSE');
    RegisterPropertyHelper(@TAPPLICATIONHINTShort_R, @TAPPLICATIONHINTShort_W, 'HINTSHORTCUTS');
    RegisterPropertyHelper(@TAPPLICATIONACTIVEFORMHandle_R, nil, 'ActiveFormHandle');
    RegisterPropertyHelper(@TAPPLICATIONMAINFORMHandle_R, nil, 'MainFormHandle');

    RegisterPropertyHelper(@TAPPLICATIONHINTSHORTPAUSE_R, @TAPPLICATIONHINTSHORTPAUSE_W, 'HINTSHORTPAUSE');
    RegisterPropertyHelper(@TAPPLICATIONHINTHIDEPAUSE_R, @TAPPLICATIONHINTHIDEPAUSE_W, 'HINTHIDEPAUSE');
    RegisterPropertyHelper(@TAPPLICATIONONHELP_R, @TAPPLICATIONONHELP_W, 'ONHELP');
    {$ENDIF}
  end;
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TScreenOnActiveFormChange_W(Self: TScreen; const T: TNotifyEvent);
begin Self.OnActiveFormChange := T; end;

(*----------------------------------------------------------------------------*)
procedure TScreenOnActiveFormChange_R(Self: TScreen; var T: TNotifyEvent);
begin T := Self.OnActiveFormChange; end;

(*----------------------------------------------------------------------------*)
procedure TScreenOnActiveControlChange_W(Self: TScreen; const T: TNotifyEvent);
begin Self.OnActiveControlChange := T; end;

(*----------------------------------------------------------------------------*)
procedure TScreenOnActiveControlChange_R(Self: TScreen; var T: TNotifyEvent);
begin T := Self.OnActiveControlChange; end;

(*----------------------------------------------------------------------------*)
procedure TScreenWidth_R(Self: TScreen; var T: Integer);
begin T := Self.Width; end;

(*----------------------------------------------------------------------------*)
procedure TScreenPrimaryMonitor_R(Self: TScreen; var T: TMonitor);
begin T := Self.PrimaryMonitor; end;

(*----------------------------------------------------------------------------*)
procedure TScreenPixelsPerInch_R(Self: TScreen; var T: Integer);
begin T := Self.PixelsPerInch; end;

(*----------------------------------------------------------------------------*)
procedure TScreenHeight_R(Self: TScreen; var T: Integer);
begin T := Self.Height; end;

(*----------------------------------------------------------------------------*)
//procedure TScreenDefaultKbLayout_R(Self: TScreen; var T: HKL);
//begin T := Self.DefaultKbLayout; end;

(*----------------------------------------------------------------------------*)
procedure TScreenDefaultIme_R(Self: TScreen; var T: string);
begin T := Self.DefaultIme; end;

(*----------------------------------------------------------------------------*)
procedure TScreenImes_R(Self: TScreen; var T: TStrings);
begin T := Self.Imes; end;

(*----------------------------------------------------------------------------*)
procedure TScreenForms_R(Self: TScreen; var T: TForm; const t1: Integer);
begin T := Self.Forms[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TScreenFormCount_R(Self: TScreen; var T: Integer);
begin T := Self.FormCount; end;

(*----------------------------------------------------------------------------*)
procedure TScreenFonts_R(Self: TScreen; var T: TStrings);
begin T := Self.Fonts; end;

(*----------------------------------------------------------------------------*)
procedure TScreenMenuFont_W(Self: TScreen; const T: TFont);
begin Self.MenuFont := T; end;

(*----------------------------------------------------------------------------*)
procedure TScreenMenuFont_R(Self: TScreen; var T: TFont);
begin T := Self.MenuFont; end;

(*----------------------------------------------------------------------------*)
procedure TScreenIconFont_W(Self: TScreen; const T: TFont);
begin Self.IconFont := T; end;

(*----------------------------------------------------------------------------*)
procedure TScreenIconFont_R(Self: TScreen; var T: TFont);
begin T := Self.IconFont; end;

(*----------------------------------------------------------------------------*)
procedure TScreenHintFont_W(Self: TScreen; const T: TFont);
begin Self.HintFont := T; end;

(*----------------------------------------------------------------------------*)
procedure TScreenHintFont_R(Self: TScreen; var T: TFont);
begin T := Self.HintFont; end;

(*----------------------------------------------------------------------------*)
procedure TScreenWorkAreaWidth_R(Self: TScreen; var T: Integer);
begin T := Self.WorkAreaWidth; end;

(*----------------------------------------------------------------------------*)
procedure TScreenWorkAreaTop_R(Self: TScreen; var T: Integer);
begin T := Self.WorkAreaTop; end;

(*----------------------------------------------------------------------------*)
procedure TScreenWorkAreaLeft_R(Self: TScreen; var T: Integer);
begin T := Self.WorkAreaLeft; end;

(*----------------------------------------------------------------------------*)
procedure TScreenWorkAreaHeight_R(Self: TScreen; var T: Integer);
begin T := Self.WorkAreaHeight; end;

(*----------------------------------------------------------------------------*)
procedure TScreenWorkAreaRect_R(Self: TScreen; var T: TRect);
begin T := Self.WorkAreaRect; end;

(*----------------------------------------------------------------------------*)
procedure TScreenDesktopWidth_R(Self: TScreen; var T: Integer);
begin T := Self.DesktopWidth; end;

(*----------------------------------------------------------------------------*)
procedure TScreenDesktopTop_R(Self: TScreen; var T: Integer);
begin T := Self.DesktopTop; end;

(*----------------------------------------------------------------------------*)
procedure TScreenDesktopLeft_R(Self: TScreen; var T: Integer);
begin T := Self.DesktopLeft; end;

(*----------------------------------------------------------------------------*)
procedure TScreenDesktopHeight_R(Self: TScreen; var T: Integer);
begin T := Self.DesktopHeight; end;

(*----------------------------------------------------------------------------*)
procedure TScreenDesktopRect_R(Self: TScreen; var T: TRect);
begin T := Self.DesktopRect; end;

(*----------------------------------------------------------------------------*)
procedure TScreenMonitors_R(Self: TScreen; var T: TMonitor; const t1: Integer);
begin T := Self.Monitors[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TScreenMonitorCount_R(Self: TScreen; var T: Integer);
begin T := Self.MonitorCount; end;

(*----------------------------------------------------------------------------*)
procedure TScreenSaveFocusedList_R(Self: TScreen; var T: TList);
begin T := Self.SaveFocusedList; end;

(*----------------------------------------------------------------------------*)
procedure TScreenFocusedForm_W(Self: TScreen; const T: TCustomForm);
begin Self.FocusedForm := T; end;

(*----------------------------------------------------------------------------*)
procedure TScreenFocusedForm_R(Self: TScreen; var T: TCustomForm);
begin T := Self.FocusedForm; end;

(*----------------------------------------------------------------------------*)
procedure TScreenDataModuleCount_R(Self: TScreen; var T: Integer);
begin T := Self.DataModuleCount; end;

(*----------------------------------------------------------------------------*)
procedure TScreenDataModules_R(Self: TScreen; var T: TDataModule; const t1: Integer);
begin T := Self.DataModules[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TScreenCursors_W(Self: TScreen; const T: HCURSOR; const t1: Integer);
begin Self.Cursors[t1] := T; end;

(*----------------------------------------------------------------------------*)
procedure TScreenCursors_R(Self: TScreen; var T: HCURSOR; const t1: Integer);
begin T := Self.Cursors[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TScreenCursor_W(Self: TScreen; const T: TCursor);
begin Self.Cursor := T; end;

(*----------------------------------------------------------------------------*)
procedure TScreenCursor_R(Self: TScreen; var T: TCursor);
begin T := Self.Cursor; end;

(*----------------------------------------------------------------------------*)
procedure TScreenCursorCount_R(Self: TScreen; var T: Integer);
begin T := Self.CursorCount; end;

(*----------------------------------------------------------------------------*)
procedure TScreenCustomForms_R(Self: TScreen; var T: TCustomForm; const t1: Integer);
begin T := Self.CustomForms[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TScreenCustomFormCount_R(Self: TScreen; var T: Integer);
begin T := Self.CustomFormCount; end;

(*----------------------------------------------------------------------------*)
procedure TScreenActiveForm_R(Self: TScreen; var T: TForm);
begin T := Self.ActiveForm; end;

(*----------------------------------------------------------------------------*)
procedure TScreenActiveCustomForm_R(Self: TScreen; var T: TCustomForm);
begin T := Self.ActiveCustomForm; end;

(*----------------------------------------------------------------------------*)
procedure TScreenActiveControl_R(Self: TScreen; var T: TWinControl);
begin T := Self.ActiveControl; end;

(*----------------------------------------------------------------------------*)
procedure TStatusBarOnDrawPanel_W(Self: TStatusBar; const T: TDrawPanelEvent);
begin Self.OnDrawPanel := T; end;

(*----------------------------------------------------------------------------*)
procedure TStatusBarOnDrawPanel_R(Self: TStatusBar; var T: TDrawPanelEvent);
begin T := Self.OnDrawPanel; end;

(*----------------------------------------------------------------------------*)
procedure TCustomStatusBarOnDrawPanel_W(Self: TCustomStatusBar; const T: TCustomDrawPanelEvent);
begin Self.OnDrawPanel := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomStatusBarOnDrawPanel_R(Self: TCustomStatusBar; var T: TCustomDrawPanelEvent);
begin T := Self.OnDrawPanel; end;

(*----------------------------------------------------------------------------*)
procedure TCustomStatusBarOnHint_W(Self: TCustomStatusBar; const T: TNotifyEvent);
begin Self.OnHint := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomStatusBarOnHint_R(Self: TCustomStatusBar; var T: TNotifyEvent);
begin T := Self.OnHint; end;

(*----------------------------------------------------------------------------*)
procedure TCustomStatusBarOnCreatePanelClass_W(Self: TCustomStatusBar; const T: TSBCreatePanelClassEvent);
begin Self.OnCreatePanelClass := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomStatusBarOnCreatePanelClass_R(Self: TCustomStatusBar; var T: TSBCreatePanelClassEvent);
begin T := Self.OnCreatePanelClass; end;

(*----------------------------------------------------------------------------*)
procedure TCustomStatusBarUseSystemFont_W(Self: TCustomStatusBar; const T: Boolean);
begin Self.UseSystemFont := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomStatusBarUseSystemFont_R(Self: TCustomStatusBar; var T: Boolean);
begin T := Self.UseSystemFont; end;

(*----------------------------------------------------------------------------*)
procedure TCustomStatusBarSizeGrip_W(Self: TCustomStatusBar; const T: Boolean);
begin Self.SizeGrip := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomStatusBarSizeGrip_R(Self: TCustomStatusBar; var T: Boolean);
begin T := Self.SizeGrip; end;

(*----------------------------------------------------------------------------*)
procedure TCustomStatusBarSimpleText_W(Self: TCustomStatusBar; const T: string);
begin Self.SimpleText := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomStatusBarSimpleText_R(Self: TCustomStatusBar; var T: string);
begin T := Self.SimpleText; end;

(*----------------------------------------------------------------------------*)
procedure TCustomStatusBarSimplePanel_W(Self: TCustomStatusBar; const T: Boolean);
begin Self.SimplePanel := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomStatusBarSimplePanel_R(Self: TCustomStatusBar; var T: Boolean);
begin T := Self.SimplePanel; end;

(*----------------------------------------------------------------------------*)
procedure TCustomStatusBarPanels_W(Self: TCustomStatusBar; const T: TStatusPanels);
begin Self.Panels := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomStatusBarPanels_R(Self: TCustomStatusBar; var T: TStatusPanels);
begin T := Self.Panels; end;

(*----------------------------------------------------------------------------*)
procedure TCustomStatusBarAutoHint_W(Self: TCustomStatusBar; const T: Boolean);
begin Self.AutoHint := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomStatusBarAutoHint_R(Self: TCustomStatusBar; var T: Boolean);
begin T := Self.AutoHint; end;

(*----------------------------------------------------------------------------*)
procedure TCustomStatusBarCanvas_R(Self: TCustomStatusBar; var T: TCanvas);
begin T := Self.Canvas; end;

(*----------------------------------------------------------------------------*)
procedure TStatusPanelsItems_W(Self: TStatusPanels; const T: TStatusPanel; const t1: Integer);
begin Self.Items[t1] := T; end;

(*----------------------------------------------------------------------------*)
procedure TStatusPanelsItems_R(Self: TStatusPanels; var T: TStatusPanel; const t1: Integer);
begin T := Self.Items[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TStatusPanelWidth_W(Self: TStatusPanel; const T: Integer);
begin Self.Width := T; end;

(*----------------------------------------------------------------------------*)
procedure TStatusPanelWidth_R(Self: TStatusPanel; var T: Integer);
begin T := Self.Width; end;

(*----------------------------------------------------------------------------*)
procedure TStatusPanelText_W(Self: TStatusPanel; const T: string);
begin Self.Text := T; end;

(*----------------------------------------------------------------------------*)
procedure TStatusPanelText_R(Self: TStatusPanel; var T: string);
begin T := Self.Text; end;

(*----------------------------------------------------------------------------*)
procedure TStatusPanelStyle_W(Self: TStatusPanel; const T: TStatusPanelStyle);
begin Self.Style := T; end;

(*----------------------------------------------------------------------------*)
procedure TStatusPanelStyle_R(Self: TStatusPanel; var T: TStatusPanelStyle);
begin T := Self.Style; end;

(*----------------------------------------------------------------------------*)
procedure TStatusPanelParentBiDiMode_W(Self: TStatusPanel; const T: Boolean);
begin Self.ParentBiDiMode := T; end;

(*----------------------------------------------------------------------------*)
procedure TStatusPanelParentBiDiMode_R(Self: TStatusPanel; var T: Boolean);
begin T := Self.ParentBiDiMode; end;

(*----------------------------------------------------------------------------*)
procedure TStatusPanelBiDiMode_W(Self: TStatusPanel; const T: TBiDiMode);
begin Self.BiDiMode := T; end;

(*----------------------------------------------------------------------------*)
procedure TStatusPanelBiDiMode_R(Self: TStatusPanel; var T: TBiDiMode);
begin T := Self.BiDiMode; end;

(*----------------------------------------------------------------------------*)
procedure TStatusPanelBevel_W(Self: TStatusPanel; const T: TStatusPanelBevel);
begin Self.Bevel := T; end;

(*----------------------------------------------------------------------------*)
procedure TStatusPanelBevel_R(Self: TStatusPanel; var T: TStatusPanelBevel);
begin T := Self.Bevel; end;

(*----------------------------------------------------------------------------*)
procedure TStatusPanelAlignment_W(Self: TStatusPanel; const T: TAlignment);
begin Self.Alignment := T; end;

(*----------------------------------------------------------------------------*)
procedure TStatusPanelAlignment_R(Self: TStatusPanel; var T: TAlignment);
begin T := Self.Alignment; end;



(*----------------------------------------------------------------------------*)
procedure RIRegister_TScreen(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TScreen) do begin
    RegisterMethod(@TScreen.DisableAlign, 'DisableAlign');
    RegisterMethod(@TScreen.EnableAlign, 'EnableAlign');
    RegisterMethod(@TScreen.MonitorFromPoint, 'MonitorFromPoint');
    RegisterMethod(@TScreen.MonitorFromRect, 'MonitorFromRect');
    RegisterMethod(@TScreen.MonitorFromWindow, 'MonitorFromWindow');
    RegisterMethod(@TScreen.Realign, 'Realign');
    RegisterMethod(@TScreen.ResetFonts, 'ResetFonts');
    RegisterPropertyHelper(@TScreenActiveControl_R,nil,'ActiveControl');
    RegisterPropertyHelper(@TScreenActiveCustomForm_R,nil,'ActiveCustomForm');
    RegisterPropertyHelper(@TScreenActiveForm_R,nil,'ActiveForm');
    RegisterPropertyHelper(@TScreenCustomFormCount_R,nil,'CustomFormCount');
    RegisterPropertyHelper(@TScreenCustomForms_R,nil,'CustomForms');
    RegisterPropertyHelper(@TScreenCursorCount_R,nil,'CursorCount');
    RegisterPropertyHelper(@TScreenCursor_R,@TScreenCursor_W,'Cursor');
    RegisterPropertyHelper(@TScreenCursors_R,@TScreenCursors_W,'Cursors');
    RegisterPropertyHelper(@TScreenDataModules_R,nil,'DataModules');
    RegisterPropertyHelper(@TScreenDataModuleCount_R,nil,'DataModuleCount');
    RegisterPropertyHelper(@TScreenFocusedForm_R,@TScreenFocusedForm_W,'FocusedForm');
    RegisterPropertyHelper(@TScreenSaveFocusedList_R,nil,'SaveFocusedList');
    RegisterPropertyHelper(@TScreenMonitorCount_R,nil,'MonitorCount');
    RegisterPropertyHelper(@TScreenMonitors_R,nil,'Monitors');
    RegisterPropertyHelper(@TScreenDesktopRect_R,nil,'DesktopRect');
    RegisterPropertyHelper(@TScreenDesktopHeight_R,nil,'DesktopHeight');
    RegisterPropertyHelper(@TScreenDesktopLeft_R,nil,'DesktopLeft');
    RegisterPropertyHelper(@TScreenDesktopTop_R,nil,'DesktopTop');
    RegisterPropertyHelper(@TScreenDesktopWidth_R,nil,'DesktopWidth');
    RegisterPropertyHelper(@TScreenWorkAreaRect_R,nil,'WorkAreaRect');
    RegisterPropertyHelper(@TScreenWorkAreaHeight_R,nil,'WorkAreaHeight');
    RegisterPropertyHelper(@TScreenWorkAreaLeft_R,nil,'WorkAreaLeft');
    RegisterPropertyHelper(@TScreenWorkAreaTop_R,nil,'WorkAreaTop');
    RegisterPropertyHelper(@TScreenWorkAreaWidth_R,nil,'WorkAreaWidth');
    RegisterPropertyHelper(@TScreenHintFont_R,@TScreenHintFont_W,'HintFont');
    RegisterPropertyHelper(@TScreenIconFont_R,@TScreenIconFont_W,'IconFont');
    RegisterPropertyHelper(@TScreenMenuFont_R,@TScreenMenuFont_W,'MenuFont');
    RegisterPropertyHelper(@TScreenFonts_R,nil,'Fonts');
    RegisterPropertyHelper(@TScreenFormCount_R,nil,'FormCount');
    RegisterPropertyHelper(@TScreenForms_R,nil,'Forms');
    RegisterPropertyHelper(@TScreenImes_R,nil,'Imes');
    RegisterPropertyHelper(@TScreenDefaultIme_R,nil,'DefaultIme');
    //RegisterPropertyHelper(@TScreenDefaultKbLayout_R,nil,'DefaultKbLayout');
    RegisterPropertyHelper(@TScreenHeight_R,nil,'Height');
    RegisterPropertyHelper(@TScreenPixelsPerInch_R,nil,'PixelsPerInch');
    RegisterPropertyHelper(@TScreenPrimaryMonitor_R,nil,'PrimaryMonitor');
    RegisterPropertyHelper(@TScreenWidth_R,nil,'Width');
    RegisterPropertyHelper(@TScreenOnActiveControlChange_R,@TScreenOnActiveControlChange_W,'OnActiveControlChange');
    RegisterPropertyHelper(@TScreenOnActiveFormChange_R,@TScreenOnActiveFormChange_W,'OnActiveFormChange');
  end;
end;


(*----------------------------------------------------------------------------*)
procedure RIRegister_TStatusBar(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TStatusBar) do
  begin
    RegisterPropertyHelper(@TStatusBarOnDrawPanel_R,@TStatusBarOnDrawPanel_W,'OnDrawPanel');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TCustomStatusBar(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TCustomStatusBar) do begin
    RegisterPropertyHelper(@TCustomStatusBarCanvas_R,nil,'Canvas');
    RegisterPropertyHelper(@TCustomStatusBarAutoHint_R,@TCustomStatusBarAutoHint_W,'AutoHint');
    RegisterPropertyHelper(@TCustomStatusBarPanels_R,@TCustomStatusBarPanels_W,'Panels');
    RegisterPropertyHelper(@TCustomStatusBarSimplePanel_R,@TCustomStatusBarSimplePanel_W,'SimplePanel');
    RegisterPropertyHelper(@TCustomStatusBarSimpleText_R,@TCustomStatusBarSimpleText_W,'SimpleText');
    RegisterPropertyHelper(@TCustomStatusBarSizeGrip_R,@TCustomStatusBarSizeGrip_W,'SizeGrip');
    RegisterPropertyHelper(@TCustomStatusBarUseSystemFont_R,@TCustomStatusBarUseSystemFont_W,'UseSystemFont');
    RegisterPropertyHelper(@TCustomStatusBarOnCreatePanelClass_R,@TCustomStatusBarOnCreatePanelClass_W,'OnCreatePanelClass');
    RegisterPropertyHelper(@TCustomStatusBarOnHint_R,@TCustomStatusBarOnHint_W,'OnHint');
    RegisterPropertyHelper(@TCustomStatusBarOnDrawPanel_R,@TCustomStatusBarOnDrawPanel_W,'OnDrawPanel');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TStatusPanels(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TStatusPanels) do begin
    RegisterConstructor(@TStatusPanels.Create, 'Create');
    RegisterMethod(@TStatusPanels.Add, 'Add');
    RegisterMethod(@TStatusPanels.AddItem, 'AddItem');
    RegisterMethod(@TStatusPanels.Insert, 'Insert');
    RegisterPropertyHelper(@TStatusPanelsItems_R,@TStatusPanelsItems_W,'Items');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TStatusPanel(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TStatusPanel) do begin
    RegisterMethod(@TStatusPanel.ParentBiDiModeChanged, 'ParentBiDiModeChanged');
    RegisterMethod(@TStatusPanel.UseRightToLeftAlignment, 'UseRightToLeftAlignment');
    RegisterMethod(@TStatusPanel.UseRightToLeftReading, 'UseRightToLeftReading');
    RegisterPropertyHelper(@TStatusPanelAlignment_R,@TStatusPanelAlignment_W,'Alignment');
    RegisterPropertyHelper(@TStatusPanelBevel_R,@TStatusPanelBevel_W,'Bevel');
    RegisterPropertyHelper(@TStatusPanelBiDiMode_R,@TStatusPanelBiDiMode_W,'BiDiMode');
    RegisterPropertyHelper(@TStatusPanelParentBiDiMode_R,@TStatusPanelParentBiDiMode_W,'ParentBiDiMode');
    RegisterPropertyHelper(@TStatusPanelStyle_R,@TStatusPanelStyle_W,'Style');
    RegisterPropertyHelper(@TStatusPanelText_R,@TStatusPanelText_W,'Text');
    RegisterPropertyHelper(@TStatusPanelWidth_R,@TStatusPanelWidth_W,'Width');
  end;
end;


(*----------------------------------------------------------------------------*)
procedure TGlassFrameSheetOfGlass_W(Self: TGlassFrame; const T: Boolean);
begin Self.SheetOfGlass := T; end;

(*----------------------------------------------------------------------------*)
procedure TGlassFrameSheetOfGlass_R(Self: TGlassFrame; var T: Boolean);
begin T := Self.SheetOfGlass; end;

(*----------------------------------------------------------------------------*)
procedure TGlassFrameBottom_W(Self: TGlassFrame; const T: Integer);
begin Self.Bottom := T; end;

(*----------------------------------------------------------------------------*)
procedure TGlassFrameBottom_R(Self: TGlassFrame; var T: Integer);
begin T := Self.Bottom; end;

(*----------------------------------------------------------------------------*)
procedure TGlassFrameRight_W(Self: TGlassFrame; const T: Integer);
begin Self.Right := T; end;

(*----------------------------------------------------------------------------*)
procedure TGlassFrameRight_R(Self: TGlassFrame; var T: Integer);
begin T := Self.Right; end;

(*----------------------------------------------------------------------------*)
procedure TGlassFrameTop_W(Self: TGlassFrame; const T: Integer);
begin Self.Top := T; end;

(*----------------------------------------------------------------------------*)
procedure TGlassFrameTop_R(Self: TGlassFrame; var T: Integer);
begin T := Self.Top; end;

(*----------------------------------------------------------------------------*)
procedure TGlassFrameLeft_W(Self: TGlassFrame; const T: Integer);
begin Self.Left := T; end;

(*----------------------------------------------------------------------------*)
procedure TGlassFrameLeft_R(Self: TGlassFrame; var T: Integer);
begin T := Self.Left; end;

(*----------------------------------------------------------------------------*)
procedure TGlassFrameEnabled_W(Self: TGlassFrame; const T: Boolean);
begin Self.Enabled := T; end;

(*----------------------------------------------------------------------------*)
procedure TGlassFrameEnabled_R(Self: TGlassFrame; var T: Boolean);
begin T := Self.Enabled; end;

(*----------------------------------------------------------------------------*)
procedure TGlassFrameOnChange_W(Self: TGlassFrame; const T: TNotifyEvent);
begin Self.OnChange := T; end;

(*----------------------------------------------------------------------------*)
procedure TGlassFrameOnChange_R(Self: TGlassFrame; var T: TNotifyEvent);
begin T := Self.OnChange; end;



(*----------------------------------------------------------------------------*)
procedure RIRegister_TGlassFrame(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TGlassFrame) do
  begin
    RegisterConstructor(@TGlassFrame.Create, 'Create');
    RegisterMethod(@TGlassFrame.Assign, 'Assign');
    RegisterMethod(@TGlassFrame.FrameExtended, 'FrameExtended');
    RegisterMethod(@TGlassFrame.IntersectsControl, 'IntersectsControl');
    RegisterPropertyHelper(@TGlassFrameOnChange_R,@TGlassFrameOnChange_W,'OnChange');
    RegisterPropertyHelper(@TGlassFrameEnabled_R,@TGlassFrameEnabled_W,'Enabled');
    RegisterPropertyHelper(@TGlassFrameLeft_R,@TGlassFrameLeft_W,'Left');
    RegisterPropertyHelper(@TGlassFrameTop_R,@TGlassFrameTop_W,'Top');
    RegisterPropertyHelper(@TGlassFrameRight_R,@TGlassFrameRight_W,'Right');
    RegisterPropertyHelper(@TGlassFrameBottom_R,@TGlassFrameBottom_W,'Bottom');
    RegisterPropertyHelper(@TGlassFrameSheetOfGlass_R,@TGlassFrameSheetOfGlass_W,'SheetOfGlass');
  end;
end;

 (*----------------------------------------------------------------------------*)
procedure RIRegister_TFrame(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TFrame) do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TCustomFrame(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TCustomFrame) do  begin
  RegisterConstructor(@TCustomFrame.Create, 'Create');
  end;
end;



procedure RIRegister_Forms(Cl: TPSRuntimeClassImporter);
begin
  {$IFNDEF PS_MINIVCL}
  RIRegisterTCONTROLSCROLLBAR(cl);
  RIRegisterTSCROLLBOX(cl);
  {$ENDIF}
{$IFNDEF FPC}  RIRegisterTScrollingWinControl(cl);{$ENDIF}
  RIRegisterTForm(Cl);
  {$IFNDEF PS_MINIVCL}
  RIRegisterTApplication(Cl);
  {$ENDIF}
  RIRegister_TScreen(CL);
   RIRegister_TStatusPanel(CL);
  RIRegister_TStatusPanels(CL);
  RIRegister_TCustomStatusBar(CL);
  with CL.Add(TStatusBar) do
  RIRegister_TStatusBar(CL);
  RIRegister_TMonitor(CL);
  RIRegister_TGlassFrame(CL);

  RIRegister_TFrame(CL);
   RIRegister_TCustomFrame(CL);

end;


// PS_MINIVCL changes by Martijn Laan (mlaan at wintax _dot_ nl)
// FPC changes by Boguslaw brandys (brandys at o2 _dot_ pl)

end.





