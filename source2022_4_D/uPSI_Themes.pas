unit uPSI_Themes;
{
    a lot of themes
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
  TPSImport_Themes = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TThemeServices(CL: TPSPascalCompiler);
procedure SIRegister_Themes(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_Themes_Routines(S: TPSExec);
procedure RIRegister_TThemeServices(CL: TPSRuntimeClassImporter);
procedure RIRegister_Themes(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   Windows
  ,Messages
  ,Graphics
  ,UxTheme
  ,CommCtrl
  ,Controls
  ,Themes
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_Themes]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TThemeServices(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TObject', 'TThemeServices') do
  with CL.AddClassN(CL.FindClass('TObject'),'TThemeServices') do begin
    RegisterMethod('Constructor Create');
       RegisterMethod('Procedure Free;');
     RegisterMethod('Procedure ApplyThemeChange');
    RegisterMethod('Function ColorToRGB( Color : TColor; Details : PThemedElementDetails) : COLORREF');
    RegisterMethod('Function ContentRect( DC : HDC; Details : TThemedElementDetails; BoundingRect : TRect) : TRect');
    RegisterMethod('Procedure DrawEdge( DC : HDC; Details : TThemedElementDetails; const R : TRect; Edge, Flags : Cardinal; ContentRect : PRect)');
    RegisterMethod('Procedure DrawElement( DC : HDC; Details : TThemedElementDetails; const R : TRect; ClipRect : PRect)');
    RegisterMethod('Procedure DrawIcon( DC : HDC; Details : TThemedElementDetails; const R : TRect; himl : HIMAGELIST; Index : Integer)');
    RegisterMethod('Procedure DrawParentBackground( Window : HWND; Target : HDC; Details : PThemedElementDetails; OnlyIfTransparent : Boolean; Bounds : PRect)');
    RegisterMethod('Procedure DrawText( DC : HDC; Details : TThemedElementDetails; const S : WideString; R : TRect; Flags, Flags2 : Cardinal)');
    RegisterMethod('Function GetElementDetails( Detail : TThemedButton) : TThemedElementDetails;');
    RegisterMethod('Function GetElementDetails1( Detail : TThemedClock) : TThemedElementDetails;');
    RegisterMethod('Function GetElementDetails2( Detail : TThemedComboBox) : TThemedElementDetails;');
    RegisterMethod('Function GetElementDetails3( Detail : TThemedEdit) : TThemedElementDetails;');
    RegisterMethod('Function GetElementDetails4( Detail : TThemedExplorerBar) : TThemedElementDetails;');
    RegisterMethod('Function GetElementDetails5( Detail : TThemedHeader) : TThemedElementDetails;');
    RegisterMethod('Function GetElementDetails6( Detail : TThemedListView) : TThemedElementDetails;');
    RegisterMethod('Function GetElementDetails7( Detail : TThemedMenu) : TThemedElementDetails;');
    RegisterMethod('Function GetElementDetails8( Detail : TThemedPage) : TThemedElementDetails;');
    RegisterMethod('Function GetElementDetails9( Detail : TThemedProgress) : TThemedElementDetails;');
    RegisterMethod('Function GetElementDetails10( Detail : TThemedRebar) : TThemedElementDetails;');
    RegisterMethod('Function GetElementDetails11( Detail : TThemedScrollBar) : TThemedElementDetails;');
    RegisterMethod('Function GetElementDetails12( Detail : TThemedSpin) : TThemedElementDetails;');
    RegisterMethod('Function GetElementDetails13( Detail : TThemedStartPanel) : TThemedElementDetails;');
    RegisterMethod('Function GetElementDetails14( Detail : TThemedStatus) : TThemedElementDetails;');
    RegisterMethod('Function GetElementDetails15( Detail : TThemedTab) : TThemedElementDetails;');
    RegisterMethod('Function GetElementDetails16( Detail : TThemedTaskBand) : TThemedElementDetails;');
    RegisterMethod('Function GetElementDetails17( Detail : TThemedTaskBar) : TThemedElementDetails;');
    RegisterMethod('Function GetElementDetails18( Detail : TThemedToolBar) : TThemedElementDetails;');
    RegisterMethod('Function GetElementDetails19( Detail : TThemedToolTip) : TThemedElementDetails;');
    RegisterMethod('Function GetElementDetails20( Detail : TThemedTrackBar) : TThemedElementDetails;');
    RegisterMethod('Function GetElementDetails21( Detail : TThemedTrayNotify) : TThemedElementDetails;');
    RegisterMethod('Function GetElementDetails22( Detail : TThemedTreeview) : TThemedElementDetails;');
    RegisterMethod('Function GetElementDetails23( Detail : TThemedWindow) : TThemedElementDetails;');
    RegisterMethod('Function HasTransparentParts( Details : TThemedElementDetails) : Boolean');
    RegisterMethod('Procedure PaintBorder( Control : TWinControl; EraseLRCorner : Boolean)');
    RegisterMethod('Procedure UpdateThemes');
    RegisterProperty('Theme', 'HTHEME TThemedElement', iptr);
    RegisterProperty('ThemesAvailable', 'Boolean', iptr);
    RegisterProperty('ThemesEnabled', 'Boolean', iptr);
    RegisterProperty('OnThemeChange', 'TNotifyEvent', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_Themes(CL: TPSPascalCompiler);
begin
  CL.AddTypeS('TThemedElement', '( teButton, teClock, teComboBox, teEdit, teExp'
   +'lorerBar, teHeader, teListView, teMenu, tePage, teProgress, teRebar, teScr'
   +'ollBar, teSpin, teStartPanel, teStatus, teTab, teTaskBand, teTaskBar, teTo'
   +'olBar, teToolTip, teTrackBar, teTrayNotify, teTreeview, teWindow )');
  CL.AddTypeS('TThemedButton', '( tbButtonDontCare, tbButtonRoot, tbPushButtonN'
   +'ormal, tbPushButtonHot, tbPushButtonPressed, tbPushButtonDisabled, tbPushB'
   +'uttonDefaulted, tbRadioButtonUncheckedNormal, tbRadioButtonUncheckedHot, t'
   +'bRadioButtonUncheckedPressed, tbRadioButtonUncheckedDisabled, tbRadioButto'
   +'nCheckedNormal, tbRadioButtonCheckedHot, tbRadioButtonCheckedPressed, tbRa'
   +'dioButtonCheckedDisabled, tbCheckBoxUncheckedNormal, tbCheckBoxUncheckedHo'
   +'t, tbCheckBoxUncheckedPressed, tbCheckBoxUncheckedDisabled, tbCheckBoxChec'
   +'kedNormal, tbCheckBoxCheckedHot, tbCheckBoxCheckedPressed, tbCheckBoxCheck'
   +'edDisabled, tbCheckBoxMixedNormal, tbCheckBoxMixedHot, tbCheckBoxMixedPres'
   +'sed, tbCheckBoxMixedDisabled, tbGroupBoxNormal, tbGroupBoxDisabled, tbUserButton )');
  CL.AddTypeS('TThemedClock', '( tcClockDontCare, tcClockRoot, tcTimeNormal )');
  CL.AddTypeS('TThemedComboBox', '( tcComboBoxDontCare, tcComboBoxRoot, tcDropD'
   +'ownButtonNormal, tcDropDownButtonHot, tcDropDownButtonPressed, tcDropDownB'
   +'uttonDisabled )');
  CL.AddTypeS('TThemedEdit', '( teEditDontCare, teEditRoot, teEditTextNormal, t'
   +'eEditTextHot, teEditTextSelected, teEditTextDisabled, teEditTextFocused, t'
   +'eEditTextReadOnly, teEditTextAssist, teEditCaret )');
  CL.AddTypeS('TThemedExplorerBar', '( tebExplorerBarDontCare, tebExplorerBarRo'
   +'ot, tebHeaderBackgroundNormal, tebHeaderBackgroundHot, tebHeaderBackground'
   +'Pressed, tebHeaderCloseNormal, tebHeaderCloseHot, tebHeaderClosePressed, t'
   +'ebHeaderPinNormal, tebHeaderPinHot, tebHeaderPinPressed, tebHeaderPinSelec'
   +'tedNormal, tebHeaderPinSelectedHot, tebHeaderPinSelectedPressed, tebIEBarM'
   +'enuNormal, tebIEBarMenuHot, tebIEBarMenuPressed, tebNormalGroupBackground,'
   +' tebNormalGroupCollapseNormal, tebNormalGroupCollapseHot, tebNormalGroupCo'
   +'llapsePressed, tebNormalGroupExpandNormal, tebNormalGroupExpandHot, tebNor'
   +'malGroupExpandPressed, tebNormalGroupHead, tebSpecialGroupBackground, tebS'
   +'pecialGroupCollapseSpecial, tebSpecialGroupCollapseHot, tebSpecialGroupCol'
   +'lapsePressed, tebSpecialGroupExpandSpecial, tebSpecialGroupExpandHot, tebS'
   +'pecialGroupExpandPressed, tebSpecialGroupHead )');
  CL.AddTypeS('TThemedHeader', '( thHeaderDontCare, thHeaderRoot, thHeaderItemN'
   +'ormal, thHeaderItemHot, thHeaderItemPressed, thHeaderItemLeftNormal, thHea'
   +'derItemLeftHot, thHeaderItemLeftPressed, thHeaderItemRightNormal, thHeader'
   +'ItemRightHot, thHeaderItemRightPressed, thHeaderSortArrowSortedUp, thHeade'
   +'rSortArrowSortedDown )');
  CL.AddTypeS('TThemedListview', '( tlListviewDontCare, tlListviewRoot, tlListI'
   +'temNormal, tlListItemHot, tlListItemSelected, tlListItemDisabled, tlListIt'
   +'emSelectedNotFocus, tlListGroup, tlListDetail, tlListSortDetail, tlEmptyText )');
  CL.AddTypeS('TThemedMenu', '( tmMenuDontCare, tmMenuRoot, tmMenuItemNormal, t'
   +'mMenuItemSelected, tmMenuItemDemoted, tmMenuDropDown, tmMenuBarItem, tmMen'
   +'uBarDropDown, tmChevron, tmSeparator )');
  CL.AddTypeS('TThemedPage', '( tpPageDontCare, tpPageRoot, tpUpNormal, tpUpHot'
   +', tpUpPressed, tpUpDisabled, tpDownNormal, tpDownHot, tpDownPressed, tpDow'
   +'nDisabled, tpUpHorzNormal, tpUpHorzHot, tpUpHorzPressed, tpUpHorzDisabled,'
   +' tpDownHorzNormal, tpDownHorzHot, tpDownHorzPressed, tpDownHorzDisabled )');
  CL.AddTypeS('TThemedProgress', '( tpProgressDontCare, tpProgressRoot, tpBar, '
   +'tpBarVert, tpChunk, tpChunkVert )');
  CL.AddTypeS('TThemedRebar', '( trRebarDontCare, trRebarRoot, trGripper, trGri'
   +'pperVert, trBandNormal, trBandHot, trBandPressed, trBandDisabled, trBandCh'
   +'ecked, trBandHotChecked, trChevronNormal, trChevronHot, trChevronPressed, '
   +'trChevronDisabled, trChevronVertNormal, trChevronVertHot, trChevronVertPre'
   +'ssed, trChevronVertDisabled )');
  CL.AddTypeS('TThemedScrollBar', '( tsScrollBarDontCare, tsScrollBarRoot, tsAr'
   +'rowBtnUpNormal, tsArrowBtnUpHot, tsArrowBtnUpPressed, tsArrowBtnUpDisabled'
   +', tsArrowBtnDownNormal, tsArrowBtnDownHot, tsArrowBtnDownPressed, tsArrowB'
   +'tnDownDisabled, tsArrowBtnLeftNormal, tsArrowBtnLeftHot, tsArrowBtnLeftPre'
   +'ssed, tsArrowBtnLeftDisabled, tsArrowBtnRightNormal, tsArrowBtnRightHot, t'
   +'sArrowBtnRightPressed, tsArrowBtnRightDisabled, tsThumbBtnHorzNormal, tsTh'
   +'umbBtnHorzHot, tsThumbBtnHorzPressed, tsThumbBtnHorzDisabled, tsThumbBtnVe'
   +'rtNormal, tsThumbBtnVertHot, tsThumbBtnVertPressed, tsThumbBtnVertDisabled'
   +', tsLowerTrackHorzNormal, tsLowerTrackHorzHot, tsLowerTrackHorzPressed, ts'
   +'LowerTrackHorzDisabled, tsUpperTrackHorzNormal, tsUpperTrackHorzHot, tsUpp'
   +'erTrackHorzPressed, tsUpperTrackHorzDisabled, tsLowerTrackVertNormal, tsLo'
   +'werTrackVertHot, tsLowerTrackVertPressed, tsLowerTrackVertDisabled, tsUppe'
   +'rTrackVertNormal, tsUpperTrackVertHot, tsUpperTrackVertPressed, tsUpperTra'
   +'ckVertDisabled, tsGripperHorzNormal, tsGripperHorzHot, tsGripperHorzPresse'
   +'d, tsGripperHorzDisabled, tsGripperVertNormal, tsGripperVertHot, tsGripper'
   +'VertPressed, tsGripperVertDisabled, tsSizeBoxRightAlign, tsSizeBoxLeftAlign)');
  CL.AddTypeS('TThemedSpin', '( tsSpinDontCare, tsSpinRoot, tsUpNormal, tsUpHot'
   +', tsUpPressed, tsUpDisabled, tsDownNormal, tsDownHot, tsDownPressed, tsDow'
   +'nDisabled, tsUpHorzNormal, tsUpHorzHot, tsUpHorzPressed, tsUpHorzDisabled,'
   +' tsDownHorzNormal, tsDownHorzHot, tsDownHorzPressed, tsDownHorzDisabled )');
  CL.AddTypeS('TThemedStartPanel', '( tspStartPanelDontCare, tspStartPanelRoot,'
   +' tspUserPane, tspMorePrograms, tspMoreProgramsArrowNormal, tspMorePrograms'
   +'ArrowHot, tspMoreProgramsArrowPressed, tspProgList, tspProgListSeparator, '
   +'tspPlacesList, tspPlacesListSeparator, tspLogOff, tspLogOffButtonsNormal, '
   +'tspLogOffButtonsHot, tspLogOffButtonsPressed, tspUserPicture, tspPreview )');
  CL.AddTypeS('TThemedStatus', '( tsStatusDontCare, tsStatusRoot, tsPane, tsGripperPane, tsGripper )');
  CL.AddTypeS('TThemedTab', '( ttTabDontCare, ttTabRoot, ttTabItemNormal, ttTab'
   +'ItemHot, ttTabItemSelected, ttTabItemDisabled, ttTabItemFocused, ttTabItem'
   +'LeftEdgeNormal, ttTabItemLeftEdgeHot, ttTabItemLeftEdgeSelected, ttTabItem'
   +'LeftEdgeDisabled, ttTabItemLeftEdgeFocused, ttTabItemRightEdgeNormal, ttTa'
   +'bItemRightEdgeHot, ttTabItemRightEdgeSelected, ttTabItemRightEdgeDisabled,'
   +' ttTabItemRightEdgeFocused, ttTabItemBothEdgeNormal, ttTabItemBothEdgeHot,'
   +' ttTabItemBothEdgeSelected, ttTabItemBothEdgeDisabled, ttTabItemBothEdgeFo'
   +'cused, ttTopTabItemNormal, ttTopTabItemHot, ttTopTabItemSelected, ttTopTab'
   +'ItemDisabled, ttTopTabItemFocused, ttTopTabItemLeftEdgeNormal, ttTopTabIte'
   +'mLeftEdgeHot, ttTopTabItemLeftEdgeSelected, ttTopTabItemLeftEdgeDisabled, '
   +'ttTopTabItemLeftEdgeFocused, ttTopTabItemRightEdgeNormal, ttTopTabItemRigh'
   +'tEdgeHot, ttTopTabItemRightEdgeSelected, ttTopTabItemRightEdgeDisabled, tt'
   +'TopTabItemRightEdgeFocused, ttTopTabItemBothEdgeNormal, ttTopTabItemBothEd'
   +'geHot, ttTopTabItemBothEdgeSelected, ttTopTabItemBothEdgeDisabled, ttTopTa'
   +'bItemBothEdgeFocused, ttPane, ttBody )');
  CL.AddTypeS('TThemedTaskBand', '( ttbTaskBandDontCare, ttbTaskBandRoot, ttbGr'
   +'oupCount, ttbFlashButton, ttpFlashButtonGroupMenu )');
  CL.AddTypeS('TThemedTaskBar', '( ttTaskBarDontCare, ttTaskBarRoot, ttbTimeNormal )');
  CL.AddTypeS('TThemedToolBar', '( ttbToolBarDontCare, ttbToolBarRoot, ttbButto'
   +'nNormal, ttbButtonHot, ttbButtonPressed, ttbButtonDisabled, ttbButtonCheck'
   +'ed, ttbButtonCheckedHot, ttbDropDownButtonNormal, ttbDropDownButtonHot, tt'
   +'bDropDownButtonPressed, ttbDropDownButtonDisabled, ttbDropDownButtonChecke'
   +'d, ttbDropDownButtonCheckedHot, ttbSplitButtonNormal, ttbSplitButtonHot, t'
   +'tbSplitButtonPressed, ttbSplitButtonDisabled, ttbSplitButtonChecked, ttbSp'
   +'litButtonCheckedHot, ttbSplitButtonDropDownNormal, ttbSplitButtonDropDownH'
   +'ot, ttbSplitButtonDropDownPressed, ttbSplitButtonDropDownDisabled, ttbSpli'
   +'tButtonDropDownChecked, ttbSplitButtonDropDownCheckedHot, ttbSeparatorNorm'
   +'al, ttbSeparatorHot, ttbSeparatorPressed, ttbSeparatorDisabled, ttbSeparat'
   +'orChecked, ttbSeparatorCheckedHot, ttbSeparatorVertNormal, ttbSeparatorVer'
   +'tHot, ttbSeparatorVertPressed, ttbSeparatorVertDisabled, ttbSeparatorVertC'
   +'hecked, ttbSeparatorVertCheckedHot )');
  CL.AddTypeS('TThemedToolTip', '( tttToolTipDontCare, tttToolTipRoot, tttStand'
   +'ardNormal, tttStandardLink, tttStandardTitleNormal, tttStandardTitleLink, '
   +'tttBaloonNormal, tttBaloonLink, tttBaloonTitleNormal, tttBaloonTitleLink, '
   +'tttCloseNormal, tttCloseHot, tttClosePressed )');
  CL.AddTypeS('TThemedTrackBar', '( ttbTrackBarDontCare, ttbTrackBarRoot, ttbTr'
   +'ack, ttbTrackVert, ttbThumbNormal, ttbThumbHot, ttbThumbPressed, ttbThumbF'
   +'ocused, ttbThumbDisabled, ttbThumbBottomNormal, ttbThumbBottomHot, ttbThum'
   +'bBottomPressed, ttbThumbBottomFocused, ttbThumbBottomDisabled, ttbThumbTop'
   +'Normal, ttbThumbTopHot, ttbThumbTopPressed, ttbThumbTopFocused, ttbThumbTo'
   +'pDisabled, ttbThumbVertNormal, ttbThumbVertHot, ttbThumbVertPressed, ttbTh'
   +'umbVertFocused, ttbThumbVertDisabled, ttbThumbLeftNormal, ttbThumbLeftHot,'
   +' ttbThumbLeftPressed, ttbThumbLeftFocused, ttbThumbLeftDisabled, ttbThumbR'
   +'ightNormal, ttbThumbRightHot, ttbThumbRightPressed, ttbThumbRightFocused, '
   +'ttbThumbRightDisabled, ttbThumbTics, ttbThumbTicsVert )');
  CL.AddTypeS('TThemedTrayNotify', '( ttnTrayNotifyDontCare, ttnTrayNotifyRoot,'
   +' ttnBackground, ttnAnimBackground )');
  CL.AddTypeS('TThemedTreeview', '( ttTreeviewDontCare, ttTreeviewRoot, ttItemN'
   +'ormal, ttItemHot, ttItemSelected, ttItemDisabled, ttItemSelectedNotFocus, '
   +'ttGlyphClosed, ttGlyphOpened, ttBranch )');
  CL.AddTypeS('TThemedWindow', '( twWindowDontCare, twWindowRoot, twCaptionActi'
   +'ve, twCaptionInactive, twCaptionDisabled, twSmallCaptionActive, twSmallCap'
   +'tionInactive, twSmallCaptionDisabled, twMinCaptionActive, twMinCaptionInac'
   +'tive, twMinCaptionDisabled, twSmallMinCaptionActive, twSmallMinCaptionInac'
   +'tive, twSmallMinCaptionDisabled, twMaxCaptionActive, twMaxCaptionInactive,'
   +' twMaxCaptionDisabled, twSmallMaxCaptionActive, twSmallMaxCaptionInactive,'
   +' twSmallMaxCaptionDisabled, twFrameLeftActive, twFrameLeftInactive, twFram'
   +'eRightActive, twFrameRightInactive, twFrameBottomActive, twFrameBottomInac'
   +'tive, twSmallFrameLeftActive, twSmallFrameLeftInactive, twSmallFrameRightA'
   +'ctive, twSmallFrameRightInactive, twSmallFrameBottomActive, twSmallFrameBo'
   +'ttomInactive, twSysButtonNormal, twSysButtonHot, twSysButtonPushed, twSysB'
   +'uttonDisabled, twMDISysButtonNormal, twMDISysButtonHot, twMDISysButtonPush'
   +'ed, twMDISysButtonDisabled, twMinButtonNormal, twMinButtonHot, twMinButton'
   +'Pushed, twMinButtonDisabled, twMDIMinButtonNormal, twMDIMinButtonHot, twMD'
   +'IMinButtonPushed, twMDIMinButtonDisabled, twMaxButtonNormal, twMaxButtonHo'
   +'t, twMaxButtonPushed, twMaxButtonDisabled, twCloseButtonNormal, twCloseBut'
   +'tonHot, twCloseButtonPushed, twCloseButtonDisabled, twSmallCloseButtonNorm'
   +'al, twSmallCloseButtonHot, twSmallCloseButtonPushed, twSmallCloseButtonDis'
   +'abled, twMDICloseButtonNormal, twMDICloseButtonHot, twMDICloseButtonPushed'
   +', twMDICloseButtonDisabled, twRestoreButtonNormal, twRestoreButtonHot, twR'
   +'estoreButtonPushed, twRestoreButtonDisabled, twMDIRestoreButtonNormal, twM'
   +'DIRestoreButtonHot, twMDIRestoreButtonPushed, twMDIRestoreButtonDisabled, '
   +'twHelpButtonNormal, twHelpButtonHot, twHelpButtonPushed, twHelpButtonDisab'
   +'led, twMDIHelpButtonNormal, twMDIHelpButtonHot, twMDIHelpButtonPushed, twM'
   +'DIHelpButtonDisabled, twHorzScrollNormal, twHorzScrollHot, twHorzScrollPus'
   +'hed, twHorzScrollDisabled, twHorzThumbNormal, twHorzThumbHot, twHorzThumbP'
   +'ushed, twHorzThumbDisabled, twVertScrollNormal, twVertScrollHot, twVertScr'
   +'ollPushed, twVertScrollDisabled, twVertThumbNormal, twVertThumbHot, twVert'
   +'ThumbPushed, twVertThumbDisabled, twDialog, twCaptionSizingTemplate, twSma'
   +'llCaptionSizingTemplate, twFrameLeftSizingTemplate, twSmallFrameLeftSizing'
   +'Template, twFrameRightSizingTemplate, twSmallFrameRightSizingTemplate, twF'
   +'rameBottomSizingTemplate, twSmallFrameBottomSizingTemplate )');
  //CL.AddTypeS('PThemedElementDetails', '^TThemedElementDetails // will not work');
  CL.AddTypeS('TThemedElementDetails', 'record Element : TThemedElement; Part :'
   +' Integer; State : Integer; end');
  SIRegister_TThemeServices(CL);
  //CL.AddTypeS('TThemeServicesClass', 'class of TThemeServices');
 CL.AddDelphiFunction('Function ThemeServices : TThemeServices');
 CL.AddDelphiFunction('Function ThemeControl( AControl : TControl) : Boolean');
 CL.AddDelphiFunction('Function UnthemedDesigner( AControl : TControl) : Boolean');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TThemeServicesOnThemeChange_W(Self: TThemeServices; const T: TNotifyEvent);
begin Self.OnThemeChange := T; end;

(*----------------------------------------------------------------------------*)
procedure TThemeServicesOnThemeChange_R(Self: TThemeServices; var T: TNotifyEvent);
begin T := Self.OnThemeChange; end;

(*----------------------------------------------------------------------------*)
procedure TThemeServicesThemesEnabled_R(Self: TThemeServices; var T: Boolean);
begin T := Self.ThemesEnabled; end;

(*----------------------------------------------------------------------------*)
procedure TThemeServicesThemesAvailable_R(Self: TThemeServices; var T: Boolean);
begin T := Self.ThemesAvailable; end;

(*----------------------------------------------------------------------------*)
procedure TThemeServicesTheme_R(Self: TThemeServices; var T: HTHEME; const t1: TThemedElement);
begin T := Self.Theme[t1]; end;

(*----------------------------------------------------------------------------*)
Function TThemeServicesGetElementDetails23_P(Self: TThemeServices;  Detail : TThemedWindow) : TThemedElementDetails;
Begin Result := Self.GetElementDetails(Detail); END;

(*----------------------------------------------------------------------------*)
Function TThemeServicesGetElementDetails22_P(Self: TThemeServices;  Detail : TThemedTreeview) : TThemedElementDetails;
Begin Result := Self.GetElementDetails(Detail); END;

(*----------------------------------------------------------------------------*)
Function TThemeServicesGetElementDetails21_P(Self: TThemeServices;  Detail : TThemedTrayNotify) : TThemedElementDetails;
Begin Result := Self.GetElementDetails(Detail); END;

(*----------------------------------------------------------------------------*)
Function TThemeServicesGetElementDetails20_P(Self: TThemeServices;  Detail : TThemedTrackBar) : TThemedElementDetails;
Begin Result := Self.GetElementDetails(Detail); END;

(*----------------------------------------------------------------------------*)
Function TThemeServicesGetElementDetails19_P(Self: TThemeServices;  Detail : TThemedToolTip) : TThemedElementDetails;
Begin Result := Self.GetElementDetails(Detail); END;

(*----------------------------------------------------------------------------*)
Function TThemeServicesGetElementDetails18_P(Self: TThemeServices;  Detail : TThemedToolBar) : TThemedElementDetails;
Begin Result := Self.GetElementDetails(Detail); END;

(*----------------------------------------------------------------------------*)
Function TThemeServicesGetElementDetails17_P(Self: TThemeServices;  Detail : TThemedTaskBar) : TThemedElementDetails;
Begin Result := Self.GetElementDetails(Detail); END;

(*----------------------------------------------------------------------------*)
Function TThemeServicesGetElementDetails16_P(Self: TThemeServices;  Detail : TThemedTaskBand) : TThemedElementDetails;
Begin Result := Self.GetElementDetails(Detail); END;

(*----------------------------------------------------------------------------*)
Function TThemeServicesGetElementDetails15_P(Self: TThemeServices;  Detail : TThemedTab) : TThemedElementDetails;
Begin Result := Self.GetElementDetails(Detail); END;

(*----------------------------------------------------------------------------*)
Function TThemeServicesGetElementDetails14_P(Self: TThemeServices;  Detail : TThemedStatus) : TThemedElementDetails;
Begin Result := Self.GetElementDetails(Detail); END;

(*----------------------------------------------------------------------------*)
Function TThemeServicesGetElementDetails13_P(Self: TThemeServices;  Detail : TThemedStartPanel) : TThemedElementDetails;
Begin Result := Self.GetElementDetails(Detail); END;

(*----------------------------------------------------------------------------*)
Function TThemeServicesGetElementDetails12_P(Self: TThemeServices;  Detail : TThemedSpin) : TThemedElementDetails;
Begin Result := Self.GetElementDetails(Detail); END;

(*----------------------------------------------------------------------------*)
Function TThemeServicesGetElementDetails11_P(Self: TThemeServices;  Detail : TThemedScrollBar) : TThemedElementDetails;
Begin Result := Self.GetElementDetails(Detail); END;

(*----------------------------------------------------------------------------*)
Function TThemeServicesGetElementDetails10_P(Self: TThemeServices;  Detail : TThemedRebar) : TThemedElementDetails;
Begin Result := Self.GetElementDetails(Detail); END;

(*----------------------------------------------------------------------------*)
Function TThemeServicesGetElementDetails9_P(Self: TThemeServices;  Detail : TThemedProgress) : TThemedElementDetails;
Begin Result := Self.GetElementDetails(Detail); END;

(*----------------------------------------------------------------------------*)
Function TThemeServicesGetElementDetails8_P(Self: TThemeServices;  Detail : TThemedPage) : TThemedElementDetails;
Begin Result := Self.GetElementDetails(Detail); END;

(*----------------------------------------------------------------------------*)
Function TThemeServicesGetElementDetails7_P(Self: TThemeServices;  Detail : TThemedMenu) : TThemedElementDetails;
Begin Result := Self.GetElementDetails(Detail); END;

(*----------------------------------------------------------------------------*)
Function TThemeServicesGetElementDetails6_P(Self: TThemeServices;  Detail : TThemedListView) : TThemedElementDetails;
Begin Result := Self.GetElementDetails(Detail); END;

(*----------------------------------------------------------------------------*)
Function TThemeServicesGetElementDetails5_P(Self: TThemeServices;  Detail : TThemedHeader) : TThemedElementDetails;
Begin Result := Self.GetElementDetails(Detail); END;

(*----------------------------------------------------------------------------*)
Function TThemeServicesGetElementDetails4_P(Self: TThemeServices;  Detail : TThemedExplorerBar) : TThemedElementDetails;
Begin Result := Self.GetElementDetails(Detail); END;

(*----------------------------------------------------------------------------*)
Function TThemeServicesGetElementDetails3_P(Self: TThemeServices;  Detail : TThemedEdit) : TThemedElementDetails;
Begin Result := Self.GetElementDetails(Detail); END;

(*----------------------------------------------------------------------------*)
Function TThemeServicesGetElementDetails2_P(Self: TThemeServices;  Detail : TThemedComboBox) : TThemedElementDetails;
Begin Result := Self.GetElementDetails(Detail); END;

(*----------------------------------------------------------------------------*)
Function TThemeServicesGetElementDetails1_P(Self: TThemeServices;  Detail : TThemedClock) : TThemedElementDetails;
Begin Result := Self.GetElementDetails(Detail); END;

(*----------------------------------------------------------------------------*)
Function TThemeServicesGetElementDetails_P(Self: TThemeServices;  Detail : TThemedButton) : TThemedElementDetails;
Begin Result := Self.GetElementDetails(Detail); END;

(*----------------------------------------------------------------------------*)
procedure RIRegister_Themes_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@ThemeServices, 'ThemeServices', cdRegister);
 S.RegisterDelphiFunction(@ThemeControl, 'ThemeControl', cdRegister);
 S.RegisterDelphiFunction(@UnthemedDesigner, 'UnthemedDesigner', cdRegister);
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TThemeServices(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TThemeServices) do begin
    RegisterVirtualConstructor(@TThemeServices.Create, 'Create');
    RegisterMethod(@TThemeServices.Destroy, 'Free');
     RegisterMethod(@TThemeServices.ApplyThemeChange, 'ApplyThemeChange');
    RegisterMethod(@TThemeServices.ColorToRGB, 'ColorToRGB');
    RegisterMethod(@TThemeServices.ContentRect, 'ContentRect');
    RegisterMethod(@TThemeServices.DrawEdge, 'DrawEdge');
    RegisterMethod(@TThemeServices.DrawElement, 'DrawElement');
    RegisterMethod(@TThemeServices.DrawIcon, 'DrawIcon');
    RegisterMethod(@TThemeServices.DrawParentBackground, 'DrawParentBackground');
    RegisterMethod(@TThemeServices.DrawText, 'DrawText');
    RegisterMethod(@TThemeServicesGetElementDetails_P, 'GetElementDetails');
    RegisterMethod(@TThemeServicesGetElementDetails1_P, 'GetElementDetails1');
    RegisterMethod(@TThemeServicesGetElementDetails2_P, 'GetElementDetails2');
    RegisterMethod(@TThemeServicesGetElementDetails3_P, 'GetElementDetails3');
    RegisterMethod(@TThemeServicesGetElementDetails4_P, 'GetElementDetails4');
    RegisterMethod(@TThemeServicesGetElementDetails5_P, 'GetElementDetails5');
    RegisterMethod(@TThemeServicesGetElementDetails6_P, 'GetElementDetails6');
    RegisterMethod(@TThemeServicesGetElementDetails7_P, 'GetElementDetails7');
    RegisterMethod(@TThemeServicesGetElementDetails8_P, 'GetElementDetails8');
    RegisterMethod(@TThemeServicesGetElementDetails9_P, 'GetElementDetails9');
    RegisterMethod(@TThemeServicesGetElementDetails10_P, 'GetElementDetails10');
    RegisterMethod(@TThemeServicesGetElementDetails11_P, 'GetElementDetails11');
    RegisterMethod(@TThemeServicesGetElementDetails12_P, 'GetElementDetails12');
    RegisterMethod(@TThemeServicesGetElementDetails13_P, 'GetElementDetails13');
    RegisterMethod(@TThemeServicesGetElementDetails14_P, 'GetElementDetails14');
    RegisterMethod(@TThemeServicesGetElementDetails15_P, 'GetElementDetails15');
    RegisterMethod(@TThemeServicesGetElementDetails16_P, 'GetElementDetails16');
    RegisterMethod(@TThemeServicesGetElementDetails17_P, 'GetElementDetails17');
    RegisterMethod(@TThemeServicesGetElementDetails18_P, 'GetElementDetails18');
    RegisterMethod(@TThemeServicesGetElementDetails19_P, 'GetElementDetails19');
    RegisterMethod(@TThemeServicesGetElementDetails20_P, 'GetElementDetails20');
    RegisterMethod(@TThemeServicesGetElementDetails21_P, 'GetElementDetails21');
    RegisterMethod(@TThemeServicesGetElementDetails22_P, 'GetElementDetails22');
    RegisterMethod(@TThemeServicesGetElementDetails23_P, 'GetElementDetails23');
    RegisterMethod(@TThemeServices.HasTransparentParts, 'HasTransparentParts');
    RegisterMethod(@TThemeServices.PaintBorder, 'PaintBorder');
    RegisterMethod(@TThemeServices.UpdateThemes, 'UpdateThemes');
    RegisterPropertyHelper(@TThemeServicesTheme_R,nil,'Theme');
    RegisterPropertyHelper(@TThemeServicesThemesAvailable_R,nil,'ThemesAvailable');
    RegisterPropertyHelper(@TThemeServicesThemesEnabled_R,nil,'ThemesEnabled');
    RegisterPropertyHelper(@TThemeServicesOnThemeChange_R,@TThemeServicesOnThemeChange_W,'OnThemeChange');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_Themes(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TThemeServices(CL);
end;

 
 
{ TPSImport_Themes }
(*----------------------------------------------------------------------------*)
procedure TPSImport_Themes.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_Themes(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_Themes.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_Themes(ri);
  RIRegister_Themes_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
