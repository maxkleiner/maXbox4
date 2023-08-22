unit uPSI_JvgUtils;
{
  to base the new JCL 4.5 for mX4 preparations
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
  TPSImport_JvgUtils = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TJvgPublicWinControl(CL: TPSPascalCompiler);
procedure SIRegister_JvgUtils(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_JvgUtils_Routines(S: TPSExec);
procedure RIRegister_TJvgPublicWinControl(CL: TPSRuntimeClassImporter);
procedure RIRegister_JvgUtils(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
  // JclUnitVersioning
  //Windows
  //,Messages
  //,Graphics
  //,ExtCtrls
  //,Controls
  //,Forms
  //,MMSystem
  JvTypes
  //,JvCommClasses
  //,Jvg3DColors
  ,JvgUtils_max
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_JvgUtils]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TJvgPublicWinControl(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TWinControl', 'TJvgPublicWinControl') do
  with CL.AddClassN(CL.FindClass('TWinControl'),'TJvgPublicWinControl') do begin
    RegisterMethod('Procedure RecreateWnd');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_JvgUtils(CL: TPSPascalCompiler);
begin
  SIRegister_TJvgPublicWinControl(CL);
  //JVGTypes    unit uPSI_JvgTypes;

   CL.AddTypeS('TglItemsDrawStyle', '( idsNone, idsRecessed, idsRaised )');
  CL.AddTypeS('TglWallpaperOption', '( fwoNone, fwoStretch, fwoPropStretch, fwoTile )');
  CL.AddTypeS('TglDrawState', '( fdsDefault, fdsDisabled, fdsDelicate )');
  CL.AddTypeS('TglVertAlign', '( fvaTop, fvaCenter, fvaBottom )');
  CL.AddTypeS('TglHorAlign', '( fhaLeft, fhaCenter, fhaRight )');
  CL.AddTypeS('TglSizingDir', '( fsdIncrease, fsdDecrease )');
  CL.AddTypeS('TglScalingDir', '( fsdRaising, fsdRecessing )');
  CL.AddTypeS('TglTextStyle', '( fstNone, fstRaised, fstRecessed, fstPushed, fs'
   +'tShadow, fstVolumetric )');
  CL.AddTypeS('TglAutoTransparentColor', '( ftcUser, ftcLeftTopPixel, ftcLeftBo'
   +'ttomPixel, ftcRightTopPixel, ftcRightBottomPixel )');
  CL.AddTypeS('TglGradientDir', '( fgdHorizontal, fgdVertical, fgdLeftBias, fgd'
   +'RightBias, fgdRectangle, fgdHorzConvergent, fgdVertConvergent )');
  CL.AddTypeS('TglLinesDir', '( fldHorizontal, fldVertical, fldLeftBias, fldRightBias )');
  CL.AddTypeS('TThreeDGradientType', '( fgtFlat, fgt3D )');
  CL.AddTypeS('TglLabelDir', '( fldLeftRight, fldRightLeft, fldUpDown, fldDownUp)');
  CL.AddTypeS('TglAlignment', '( ftaLeftJustify, ftaRightJustify, ftaCenter, ftaBroadwise )');
  CL.AddTypeS('TglGlyphKind', '( fgkCustom, fgkDefault )');
  CL.AddTypeS('TglFileType', '( fftUndefined, fftGif, fftJpeg, fftBmp )');
  CL.AddTypeS('TglLabelOption', '( floActiveWhileControlFocused, floBufferedDra'
   +'w, floDelineatedText, floIgnoreMouse, floTransparentFont )');
  CL.AddTypeS('TglLabelOptions', 'set of TglLabelOption');
  CL.AddTypeS('TglStaticTextOption', '( ftoActiveWhileControlFocused, ftoBroadw'
   +'iseLastLine, ftoIgnoreMouse, ftoUnderlinedActive )');
  CL.AddTypeS('TglStaticTextOptions', 'set of TglStaticTextOption');
  CL.AddTypeS('TglCheckBoxOption', '( fcoActiveWhileControlFocused, fcoBoldChec'
   +'ked, fcoEnabledFocusControlWhileChecked, fcoIgnoreMouse, fcoDelineatedText'
   +', fcoFastDraw, fcoUnderlinedActive )');
  CL.AddTypeS('TglCheckBoxOptions', 'set of TglCheckBoxOption');
  CL.AddTypeS('TglGroupBoxOption', '( fgoCanCollapse, fgoCollapseOther, fgoFill'
   +'edCaption, fgoFluentlyCollapse, fgoFluentlyExpand, fgoResizeParent, fgoHid'
   +'eChildrenWhenCollapsed, fgoIgnoreMouse, fgoDelineatedText, fgoBufferedDraw'
   +', fgoOneAlwaysExpanded, fgoSaveChildFocus )');
  CL.AddTypeS('TglGroupBoxOptions', 'set of TglGroupBoxOption');
  CL.AddTypeS('TglListBoxOption', '( fboAutoCtl3DColors, fboBufferedDraw, fboCh'
   +'angeGlyphColor, fboDelineatedText, fboExcludeGlyphs, fboHideText, fboHotTr'
   +'ack, fboHotTrackSelect, fboItemColorAsGradientFrom, fboItemColorAsGradient'
   +'To, fboMouseMoveSentensive, fboShowFocus, fboSingleGlyph, fboTransparent,fboWordWrap )');
  CL.AddTypeS('TglListBoxOptions', 'set of TglListBoxOption');
  CL.AddTypeS('TglProgressOption', '( fpoDelineatedText, fpoTransparent )');
  CL.AddTypeS('TglProgressOptions', 'set of TglProgressOption');
  CL.AddTypeS('TglTabOption', '( ftoAutoFontDirection, ftoExcludeGlyphs, ftoHid'
   +'eGlyphs, ftoInheriteTabFonts, ftoTabColorAsGradientFrom, ftoTabColorAsGrad'
   +'ientTo, ftoWordWrap )');
  CL.AddTypeS('TglTabOptions', 'set of TglTabOption');
  CL.AddTypeS('TglTreeViewOption', '( ftvFlatScroll )');
  CL.AddTypeS('TglTreeViewOptions', 'set of TglTreeViewOption');
  CL.AddTypeS('TFocusControlMethod', '( fcmOnMouseEnter, fcmOnMouseDown, fcmOnMouseUp)');
  CL.AddTypeS('TglOnGetItemColorEvent', 'Procedure ( Sender : TObject; Index : '
   +'Integer; var Color : TColor)');
  CL.AddTypeS('TglBoxStyle', '( fbsFlat, fbsCtl3D, fbsStatusControl, fbsRecesse'
   +'d, fbsRaised, fbsRaisedFrame, fbsRecessedFrame )');
  CL.AddTypeS('TglSide', '( fsdLeft, fsdTop, fsdRight, fsdBottom )');
  CL.AddTypeS('TglSides', 'set of TglSide');
  CL.AddTypeS('TglOrigin', '( forLeftTop, forRightBottom )');
  CL.AddTypeS('TglAlign', 'record Horizontal : TglHorAlign; Vertical : TglVertAlign; end');
  CL.AddTypeS('TglHComponentAlign', '( haNoChange, haLeft, haCenters, haRight, '
   +'haSpaceEqually, haCenterWindow, haClose )');
  CL.AddTypeS('TglVComponentAlign', '( vaNoChange, vaTops, vaCenters, vaBottoms'
   +', vaSpaceEqually, vaCenterWindow, vaClose )');
  CL.AddTypeS('TglCheckKind', '( fckCheckBoxes, fckRadioButtons )');
  //CL.AddTypeS('TglGlobalData', 'record fSuppressGradient : Boolean; lp3DColors '
   //+': ___Pointer; end');
 //CL.AddConstantN('ALLGLSIDES','LongInt').Value.ts32 := ord(fsdLeft) or ord(fsdTop) or ord(fsdRight) or ord(fsdBottom);


  //JVTypes   unit JvTypes;
  CL.AddConstantN('MaxPixelCount','LongInt').SetInt( 32767);
  //CL.AddTypeS('TJvBytes', '___Pointer');
  //CL.AddTypeS('IntPtr', '___Pointer');
  CL.AddTypeS('TVerticalAlignment', '( taAlignTop, taAlignBottom, taVerticalCenter)');
  CL.AddTypeS('PCaptionChar', 'PChar');
  CL.AddTypeS('THintString', 'string');
  CL.AddTypeS('THintStringList', 'TStringList');
  CL.AddTypeS('TInputKey','(ikAll,ikArrows,ikChars,ikButton,ikTabs,ikEdit, ikNative )');
  CL.AddTypeS('TInputKeys', 'set of TInputKey');
  CL.AddTypeS('TJvRGBTriple','record rgbBlue: Byte; rgbGreen: Byte; rgbRed: Byte; end');
 CL.AddConstantN('NullHandle','LongInt').SetInt( 0);
  //SIRegister_TJvPersistent(CL);
  CL.AddTypeS('TJvPropertyChangeEvent', 'Procedure ( Sender : TObject; const Pr'
   +'opName : string)');
  //SIRegister_TJvPersistentProperty(CL);
  CL.AddTypeS('TJvRegKey', '( hkClassesRoot, hkCurrentUser, hkLocalMachine, hkU'
   +'sers, hkPerformanceData, hkCurrentConfig, hkDynData )');
  CL.AddTypeS('TJvRegKeys', 'set of TJvRegKey');
  CL.AddClassN(CL.FindClass('TOBJECT'),'EJVCLException');
  CL.AddTypeS('TJvLinkClickEvent', 'Procedure ( Sender : TObject; Link : string)');
  CL.AddTypeS('TJvOutputMode', '( omFile, omStream )');
  CL.AddTypeS('TJvDoneFileEvent', 'Procedure ( Sender : TObject; FileName : str'
   +'ing; FileSize : Integer; Url : string)');
  CL.AddTypeS('TJvDoneStreamEvent', 'Procedure ( Sender : TObject; Stream : TSt'
   +'ream; StreamSize : Integer; Url : string)');
  CL.AddTypeS('TJvHTTPProgressEvent', 'Procedure ( Sender : TObject; UserData, '
   +'Position : Integer; TotalSize : Integer; Url : string; var Continue : Boolean)');
  CL.AddTypeS('TJvFTPProgressEvent', 'Procedure ( Sender : TObject; Position : '
   +'Integer; Url : string)');
  CL.AddTypeS('TJvClipboardCommand', '( caCopy, caCut, caPaste, caClear, caUndo)');
  CL.AddTypeS('TJvClipboardCommands', 'set of TJvClipboardCommand');
  CL.AddTypeS('TCMForceSize', 'record Msg : Cardinal; NewSize : TSmallPoint; Se'
   +'nder : TControl; Result : Longint; end');
  //CL.AddTypeS('PJvRGBArray', '^TJvRGBArray // will not work');
  //CL.AddTypeS('PRGBQuadArray', '^TRGBQuadArray // will not work');
  //CL.AddTypeS('PRGBPalette', '^TRGBPalette // will not work');
  CL.AddTypeS('TJvErrorEvent', 'Procedure ( Sender : TObject; ErrorMsg : string)');
  CL.AddTypeS('TJvWaveLocation', '( frFile, frResource, frRAM )');
  CL.AddTypeS('TJvPopupPosition', '( ppNone, pppForm, ppApplication )');
  CL.AddTypeS('TJvProgressEvent','Procedure(Sender: TObject; Current,Total : Integer)');
  CL.AddTypeS('TJvNextPageEvent', 'Procedure ( Sender : TObject; PageNumber : Integer)');
  CL.AddTypeS('TJvBitmapStyle', '( bsNormal, bsCentered, bsStretched )');
  CL.AddTypeS('TJvGradientStyle', '( grFilled, grEllipse, grHorizontal, grVerti'
   +'cal, grPyramid, grMount )');
  CL.AddTypeS('TJvParentEvent', 'Procedure(Sender: TObject; ParentWindow: THandle)');
  CL.AddTypeS('TJvDiskRes', '( dsSuccess, dsCancel, dsSkipfile, dsError )');
  CL.AddTypeS('TJvDiskStyle', '( idfCheckFirst, idfNoBeep, idfNoBrowse, idfNoCo'
   +'mpressed, idfNoDetails, idfNoForeground, idfNoSkip, idfOemDisk, idfWarnIfSkip )');
  CL.AddTypeS('TJvDiskStyles', 'set of TJvDiskStyle');
  CL.AddTypeS('TJvDeleteStyle', '( idNoBeep, idNoForeground )');
  CL.AddTypeS('TJvDeleteStyles', 'set of TJvDeleteStyle');
  //CL.AddTypeS('TJvNotifyParamsEvent', 'Procedure(Sender: TObject; Params: ___Pointer)');
  CL.AddTypeS('TJvFileInfoRec', 'record Attributes : DWORD; DisplayName : strin'
   +'g; ExeType : Integer; Icon : HICON; Location : string; TypeName : string; '
   +'SysIconIndex : Integer; end');
  CL.AddTypeS('TJvAnimation', '( anLeftRight, anRightLeft, anRightAndLeft, anLe'
   +'ftVumeter, anRightVumeter )');
  CL.AddTypeS('TJvAnimations', 'set of TJvAnimation');
  CL.AddTypeS('TJvTriggerKind', '( tkOneShot, tkEachSecond, tkEachMinute, tkEac'
   +'hHour, tkEachDay, tkEachMonth, tkEachYear )');
  //CL.AddTypeS('PJvAniTag', '^TJvAniTag // will not work');
  //CL.AddTypeS('TJvAniTag', 'record ckID : TJvFourCC; ckSize : Longint; end');
  CL.AddTypeS('TJvAniHeader', 'record dwSizeof : Longint; dwFrames : Longint; d'
   +'wSteps : Longint; dwCX : Longint; dwCY : Longint; dwBitCount : Longint; dw'
   +'Planes : Longint; dwJIFRate : Longint; dwFlags : Longint; end');
  CL.AddTypeS('TJvChangeColorEvent', 'Procedure ( Sender : TObject; Foreground,'
   +' Background : TColor)');
  CL.AddTypeS('TJvLayout', '( lTop, lCenter, lBottom )');
  CL.AddTypeS('TJvBevelStyle', '( bsShape, bsLowered, bsRaised )');
  CL.AddTypeS('TJvFocusChangeEvent', 'Procedure ( const ASender : TObject; cons'
   +'t AFocusControl : TWinControl)');
  CL.AddTypeS('TTickCount', 'Cardinal');
  //CL.AddTypeS('TSetOfChar', 'TSysCharSet');   set of char!!
  CL.AddTypeS('TCharSet', 'TSysCharSet');
  CL.AddTypeS('TDateOrder', '( doMDY, doDMY, doYMD )');
  CL.AddTypeS('TDayOfWeekName', '( Sun, Mon, Tue, Wed, Thu, Fri, Sat )');
  CL.AddTypeS('TDaysOfWeek', 'set of TDayOfWeekName');
 //CL.AddConstantN('DefaultDateOrder','').SetString( doDMY);
 CL.AddConstantN('CenturyOffset','Byte').SetUInt( 60);
 //CL.AddConstantN('NullDate','TDateTime').SetString( 0);
  CL.AddTypeS('TJvImageSize', '( isSmall, isLarge )');
  CL.AddTypeS('TJvImageAlign', '( iaLeft, iaCentered )');
  CL.AddTypeS('TJvDriveType', '( dtUnknown, dtRemovable, dtFixed, dtRemote, dtC'
   +'DROM, dtRamDisk )');
  CL.AddTypeS('TJvDriveTypes', 'set of TJvDriveType');
  CL.AddTypeS('TJvTrackFontOption', '( hoFollowFont, hoPreserveCharSet, hoPrese'
   +'rveColor, hoPreserveHeight, hoPreserveName, hoPreservePitch, hoPreserveStyle )');
  CL.AddTypeS('TJvTrackFontOptions', 'set of TJvTrackFontOption');
 //CL.AddConstantN('DefaultTrackFontOptions','LongInt').Value.ts32 := ord(hoFollowFont) or ord(hoPreserveColor) or ord(hoPreserveStyle);
 CL.AddConstantN('DefaultHotTrackColor','LongWord').SetUInt( $00D2BDB6);
 CL.AddConstantN('DefaultHotTrackFrameColor','LongWord').SetUInt( $006A240A);
  CL.AddTypeS('TJvSortMethod', '( smAutomatic, smAlphabetic, smNonCaseSensitive'
   +', smNumeric, smDate, smTime, smDateTime, smCurrency )');
  CL.AddTypeS('TJvListViewColumnSortEvent', 'Procedure ( Sender : TObject; Colu'
   +'mn : Integer; var AMethod : TJvSortMethod)');
  CL.AddTypeS('TJvAddInControlSiteInfo', 'record AddInControl : TControl; Bound'
   +'sRect : TRect; SiteInfoData : TObject; end');
  CL.AddTypeS('TJvClickColorType', '( cctColors, cctNoneColor, cctDefaultColor,'
   +' cctCustomColor, cctAddInControl, cctNone )');
  CL.AddTypeS('TJvHoldCustomColorEvent', 'Procedure(Sender: TObject; AColor: TColor)');
  CL.AddTypeS('TJvColorQuadLayOut', '( cqlNone, cqlLeft, cqlRight, cqlClient )');
  CL.AddTypeS('TJvGetAddInControlSiteInfoEvent', 'Procedure ( Sender : TControl'
   +'; var ASiteInfo : TJvAddInControlSiteInfo)');
  CL.AddTypeS('TColorType', '( ctStandard, ctSystem, ctCustom )');
  CL.AddTypeS('TDefColorItem', 'record Value : TColor; Constant : string; Descr'
   +'iption : string; end');
 CL.AddConstantN('ColCount','LongInt').SetInt( 20);
 CL.AddConstantN('StandardColCount','LongInt').SetInt( 40);
 CL.AddConstantN('SysColCount','LongInt').SetInt( 30);
  CL.AddTypeS('TJvSizeRect', 'record Top : Integer; Left : Integer; Width : Int'
   +'eger; Height : Integer; end');

 CL.AddDelphiFunction('Function IsEven( I : Integer) : Boolean');
 CL.AddDelphiFunction('Function InchesToPixels( DC : HDC; Value : Single; IsHorizontal : Boolean) : Integer');
 CL.AddDelphiFunction('Function CentimetersToPixels( DC : HDC; Value : Single; IsHorizontal : Boolean) : Integer');
 //CL.AddDelphiFunction('function CharInSet(const C: Char; const testSet: TSysCharSet): boolean');

 CL.AddDelphiFunction('Procedure SwapInt2( var I1, I2 : Integer)');
 CL.AddDelphiFunction('Function Spaces( Count : Integer) : string');
 CL.AddDelphiFunction('Function DupStr( const Str : string; Count : Integer) : string');
 CL.AddDelphiFunction('Function DupChar( C : Char; Count : Integer) : string');
 CL.AddDelphiFunction('Procedure Msg( const AMsg : string)');
 CL.AddDelphiFunction('Function RectW( R : TRect) : Integer');
 CL.AddDelphiFunction('Function RectH( R : TRect) : Integer');
 CL.AddDelphiFunction('Function IncColor( AColor : Longint; AOffset : Byte) : Longint');
 CL.AddDelphiFunction('Function DecColor( AColor : Longint; AOffset : Byte) : Longint');
 CL.AddDelphiFunction('Function IsItAFilledBitmap( Bmp : TBitmap) : Boolean');
 CL.AddDelphiFunction('Procedure DrawTextInRectWithAlign( DC : HDC; R : TRect; const Text : string; HAlign : TglHorAlign; VAlign : TglVertAlign; Style : TglTextStyle; Fnt : TFont; Flags : integer)');
 CL.AddDelphiFunction('Procedure DrawTextInRect( DC : HDC; R : TRect; const Text : string; Style : TglTextStyle; Fnt : TFont; Flags : integer)');
 CL.AddDelphiFunction('Procedure ExtTextOutExt(DC:HDC; X,Y: Integer; R: TRect; const Text : string; Style: TglTextStyle; ADelineated, ASupress3D : Boolean; FColor, DColor, HColor, SColor : TColor; Illumination: TJvgIllumination; Gradient : TJvgGradient; Font : TFont)');
 CL.AddDelphiFunction('Procedure DrawBox( DC : HDC; var R : TRect; Style : TglBoxStyle; BackgrColor : Longint; ATransparent : Boolean)');
 CL.AddDelphiFunction('Function DrawBoxEx( DC : HDC; ARect : TRect; Borders : TglSides; BevelInner, BevelOuter : TPanelBevel; Bold : Boolean; BackgrColor : Longint; ATransparent : Boolean) : TRect');
 CL.AddDelphiFunction('Procedure GradientBox( DC : HDC; R : TRect; Gradient : TJvgGradient; PenStyle, PenWidth : Integer)');
 CL.AddDelphiFunction('Procedure ChangeBitmapColor( Bitmap : TBitmap; FromColor, ToColor : TColor)');
 CL.AddDelphiFunction('Procedure DrawBitmapExt( DC : HDC; SourceBitmap : TBitmap; R : TRect; X, Y : Integer; BitmapOption : TglWallpaperOption; DrawState : TglDrawState; ATransparent : Boolean; TransparentColor : TColor; DisabledMaskColor : TColor)');
 CL.AddDelphiFunction('Procedure CreateBitmapExt( DC : HDC; SourceBitmap : TBitmap; R : TRect; X, Y : Integer; BitmapOption : TglWallpaperOption; DrawState : TglDrawState; ATransparent : Boolean; TransparentColor : TColor; DisabledMaskColor : TColor)');
 CL.AddDelphiFunction('Procedure BringParentWindowToTop( Wnd : TWinControl)');
 CL.AddDelphiFunction('Function GetParentForm( Control : TControl) : TForm');
 CL.AddDelphiFunction('Procedure GetWindowImageFrom( Control : TWinControl; X, Y : Integer; ADrawSelf, ADrawChildWindows : Boolean; DC : HDC)');
 CL.AddDelphiFunction('Procedure GetWindowImage( Control : TWinControl; ADrawSelf, ADrawChildWindows : Boolean; DC : HDC)');
 CL.AddDelphiFunction('Procedure GetParentImageRect( Control : TControl; Rect : TRect; DC : HDC)');
 CL.AddDelphiFunction('Function CreateRotatedFont( F : TFont; Escapement : Integer) : HFONT');
 CL.AddDelphiFunction('Function FindMainWindow( const AWndClass, AWndTitle : string) : THandle');
 CL.AddDelphiFunction('Procedure CalcShadowAndHighlightColors( BaseColor : TColor; Colors : TJvgLabelColors)');
 CL.AddDelphiFunction('Function CalcMathString( AExpression : string) : Single');
 CL.AddDelphiFunction('Function IIFV( AExpression : Boolean; IfTrue, IfFalse : Variant) : Variant;');
 CL.AddDelphiFunction('Function IIF1( AExpression : Boolean; const IfTrue, IfFalse : string) : string;');
 CL.AddDelphiFunction('Function GetTransparentColor( Bitmap : TBitmap; AutoTrColor : TglAutoTransparentColor) : TColor');
 CL.AddDelphiFunction('Procedure TypeStringOnKeyboard( const S : string)');
 CL.AddDelphiFunction('Procedure DrawTextExtAligned( Canvas : TCanvas; const Text : string; R : TRect; Alignment : TglAlignment; WordWrap : Boolean)');
 CL.AddDelphiFunction('Procedure LoadComponentFromTextFile( Component : TComponent; const FileName : string)');
 CL.AddDelphiFunction('Procedure SaveComponentToTextFile( Component : TComponent; const FileName : string)');
 CL.AddDelphiFunction('Function ComponentToString( Component : TComponent) : string');
 CL.AddDelphiFunction('Procedure StringToComponent( Component : TComponent; const Value : string)');
 CL.AddDelphiFunction('Function PlayWaveResource( const ResName : string) : Boolean');
 CL.AddDelphiFunction('Function UserName : string');
 CL.AddDelphiFunction('Function ComputerName : string');
 CL.AddDelphiFunction('Function CreateIniFileName : string');
 CL.AddDelphiFunction('Function ExpandString( const Str : string; Len : Integer) : string');
 CL.AddDelphiFunction('Function Transliterate( const Str : string; RusToLat : Boolean) : string');
 CL.AddDelphiFunction('Function IsSmallFonts : Boolean');
 CL.AddDelphiFunction('Function SystemColorDepth : Integer');
 CL.AddDelphiFunction('Function GetFileTypeJ( const FileName : string) : TglFileType');
 CL.AddDelphiFunction('Function FindControlAtPt( Control : TWinControl; Pt : TPoint; MinClass : TClass) : TControl');
 CL.AddDelphiFunction('Function StrPosExt( const Str1, Str2 : PChar; Str2Len : DWORD) : PChar');
 //CL.AddDelphiFunction('Function DeleteObject( P1 : HGDIOBJ) : BOOL');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
Function IIF1_P( AExpression : Boolean; const IfTrue, IfFalse : string) : string;
Begin Result := JvgUtils_max.IIF(AExpression, IfTrue, IfFalse); END;

(*----------------------------------------------------------------------------*)
Function IIF_P( AExpression : Boolean; IfTrue, IfFalse : Variant) : Variant;
Begin Result := JvgUtils_max.IIF(AExpression, IfTrue, IfFalse); END;

(*----------------------------------------------------------------------------*)
procedure RIRegister_JvgUtils_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@IsEven, 'IsEven', cdRegister);
 S.RegisterDelphiFunction(@InchesToPixels, 'InchesToPixels', cdRegister);
 S.RegisterDelphiFunction(@CentimetersToPixels, 'CentimetersToPixels', cdRegister);
 //S.RegisterDelphiFunction(@CharInSet, 'CharinSet', cdRegister);

 S.RegisterDelphiFunction(@SwapInt, 'SwapInt2', cdRegister);
 S.RegisterDelphiFunction(@Spaces, 'Spaces', cdRegister);
 S.RegisterDelphiFunction(@DupStr, 'DupStr', cdRegister);
 S.RegisterDelphiFunction(@DupChar, 'DupChar', cdRegister);
 S.RegisterDelphiFunction(@Msg, 'Msg', cdRegister);
 S.RegisterDelphiFunction(@RectW, 'RectW', cdRegister);
 S.RegisterDelphiFunction(@RectH, 'RectH', cdRegister);
 S.RegisterDelphiFunction(@IncColor, 'IncColor', cdRegister);
 S.RegisterDelphiFunction(@DecColor, 'DecColor', cdRegister);
 S.RegisterDelphiFunction(@IsItAFilledBitmap, 'IsItAFilledBitmap', cdRegister);
 S.RegisterDelphiFunction(@DrawTextInRectWithAlign, 'DrawTextInRectWithAlign', cdRegister);
 S.RegisterDelphiFunction(@DrawTextInRect, 'DrawTextInRect', cdRegister);
 S.RegisterDelphiFunction(@ExtTextOutExt, 'ExtTextOutExt', cdRegister);
 S.RegisterDelphiFunction(@DrawBox, 'DrawBox', cdRegister);
 S.RegisterDelphiFunction(@DrawBoxEx, 'DrawBoxEx', cdRegister);
 S.RegisterDelphiFunction(@GradientBox, 'GradientBox', cdRegister);
 S.RegisterDelphiFunction(@ChangeBitmapColor, 'ChangeBitmapColor', cdRegister);
 S.RegisterDelphiFunction(@DrawBitmapExt, 'DrawBitmapExt', cdRegister);
 S.RegisterDelphiFunction(@CreateBitmapExt, 'CreateBitmapExt', cdRegister);
 S.RegisterDelphiFunction(@BringParentWindowToTop, 'BringParentWindowToTop', cdRegister);
 S.RegisterDelphiFunction(@GetParentForm, 'GetParentForm', cdRegister);
 S.RegisterDelphiFunction(@GetWindowImageFrom, 'GetWindowImageFrom', cdRegister);
 S.RegisterDelphiFunction(@GetWindowImage, 'GetWindowImage', cdRegister);
 S.RegisterDelphiFunction(@GetParentImageRect, 'GetParentImageRect', cdRegister);
 S.RegisterDelphiFunction(@CreateRotatedFont, 'CreateRotatedFont', cdRegister);
 S.RegisterDelphiFunction(@FindMainWindow, 'FindMainWindow', cdRegister);
 S.RegisterDelphiFunction(@CalcShadowAndHighlightColors, 'CalcShadowAndHighlightColors', cdRegister);
 S.RegisterDelphiFunction(@CalcMathString, 'CalcMathString', cdRegister);
 S.RegisterDelphiFunction(@IIF_P, 'IIFV', cdRegister);
 S.RegisterDelphiFunction(@IIF1_P, 'IIF1', cdRegister);
 S.RegisterDelphiFunction(@GetTransparentColor, 'GetTransparentColor', cdRegister);
 S.RegisterDelphiFunction(@TypeStringOnKeyboard, 'TypeStringOnKeyboard', cdRegister);
 S.RegisterDelphiFunction(@DrawTextExtAligned, 'DrawTextExtAligned', cdRegister);
 S.RegisterDelphiFunction(@LoadComponentFromTextFile, 'LoadComponentFromTextFile', cdRegister);
 S.RegisterDelphiFunction(@SaveComponentToTextFile, 'SaveComponentToTextFile', cdRegister);
 S.RegisterDelphiFunction(@ComponentToString, 'ComponentToString', cdRegister);
 S.RegisterDelphiFunction(@StringToComponent, 'StringToComponent', cdRegister);
 S.RegisterDelphiFunction(@PlayWaveResource, 'PlayWaveResource', cdRegister);
 S.RegisterDelphiFunction(@UserName, 'UserName', cdRegister);
 S.RegisterDelphiFunction(@ComputerName, 'ComputerName', cdRegister);
 S.RegisterDelphiFunction(@CreateIniFileName, 'CreateIniFileName', cdRegister);
 S.RegisterDelphiFunction(@ExpandString, 'ExpandString', cdRegister);
 S.RegisterDelphiFunction(@Transliterate, 'Transliterate', cdRegister);
 S.RegisterDelphiFunction(@IsSmallFonts, 'IsSmallFonts', cdRegister);
 S.RegisterDelphiFunction(@SystemColorDepth, 'SystemColorDepth', cdRegister);
 S.RegisterDelphiFunction(@GetFileType, 'GetFileTypeJ', cdRegister);
 S.RegisterDelphiFunction(@FindControlAtPt, 'FindControlAtPt', cdRegister);
 S.RegisterDelphiFunction(@StrPosExt, 'StrPosExt', cdRegister);
 //S.RegisterDelphiFunction(@DeleteObject, 'DeleteObject', CdStdCall);
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJvgPublicWinControl(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJvgPublicWinControl) do
  begin
    RegisterMethod(@TJvgPublicWinControl.RecreateWnd, 'RecreateWnd');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_JvgUtils(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TJvgPublicWinControl(CL);
end;



{ TPSImport_JvgUtils }
(*----------------------------------------------------------------------------*)
procedure TPSImport_JvgUtils.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_JvgUtils(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_JvgUtils.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_JvgUtils(ri);
  RIRegister_JvgUtils_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)


end.
