unit uPSI_KGraphics;
{
coolcode of alpha channnel wit png!

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
  TPSImport_KGraphics = class(TPSPlugin)
  public
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TKGraphicHint(CL: TPSPascalCompiler);
procedure SIRegister_TKTextHint(CL: TPSPascalCompiler);
procedure SIRegister_TKHintWindow(CL: TPSPascalCompiler);
procedure SIRegister_TKDragWindow(CL: TPSPascalCompiler);
procedure SIRegister_TKTextBox(CL: TPSPascalCompiler);
procedure SIRegister_TKMetafile(CL: TPSPascalCompiler);
procedure SIRegister_TKAlphaBitmap(CL: TPSPascalCompiler);
procedure SIRegister_TKGraphic(CL: TPSPascalCompiler);
procedure SIRegister_KGraphics(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_KGraphics_Routines(S: TPSExec);
procedure RIRegister_TKGraphicHint(CL: TPSRuntimeClassImporter);
procedure RIRegister_TKTextHint(CL: TPSRuntimeClassImporter);
procedure RIRegister_TKHintWindow(CL: TPSRuntimeClassImporter);
procedure RIRegister_TKDragWindow(CL: TPSRuntimeClassImporter);
procedure RIRegister_TKTextBox(CL: TPSRuntimeClassImporter);
procedure RIRegister_TKMetafile(CL: TPSRuntimeClassImporter);
procedure RIRegister_TKAlphaBitmap(CL: TPSRuntimeClassImporter);
procedure RIRegister_TKGraphic(CL: TPSRuntimeClassImporter);
procedure RIRegister_KGraphics(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   Windows
 { ,GraphType
  ,IntfGraphics
  ,LCLType
  ,LCLIntf
  ,LMessages
  ,LResources }
  ,Messages
  //,PngImage
  ,Forms
  ,Graphics
  ,Controls
  ,Types
  ,KFunctions
  ,Themes
  ,UxTheme
  ,KGraphics
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_KGraphics]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TKGraphicHint(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TKHintWindow', 'TKGraphicHint') do
  with CL.AddClassN(CL.FindClass('TKHintWindow'),'TKGraphicHint') do
  begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
    RegisterProperty('Graphic', 'TGraphic', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TKTextHint(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TKHintWindow', 'TKTextHint') do
  with CL.AddClassN(CL.FindClass('TKHintWindow'),'TKTextHint') do
  begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
    RegisterProperty('Text', 'TKString', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TKHintWindow(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'THintWindow', 'TKHintWindow') do
  with CL.AddClassN(CL.FindClass('THintWindow'),'TKHintWindow') do
  begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
    RegisterMethod('Procedure ShowAt( const Origin : TPoint)');
    RegisterMethod('Procedure Hide');
    RegisterProperty('Extent', 'TPoint', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TKDragWindow(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TObject', 'TKDragWindow') do
  with CL.AddClassN(CL.FindClass('TObject'),'TKDragWindow') do begin
    RegisterMethod('Constructor Create');
      RegisterMethod('Procedure Free');
     RegisterMethod('Procedure Init( IniCtrl : TCustomControl; const ARect : TRect; const AInitialPos : TPoint; AMasterAlpha : Byte; AGradient : Boolean)');
    RegisterMethod('Procedure Move( ARect : PRect; const ACurrentPos : TPoint; AShowAlways : Boolean)');
    RegisterMethod('Procedure Hide');
    RegisterProperty('Active', 'Boolean', iptr);
    RegisterProperty('Bitmap', 'TKAlphaBitmap', iptr);
    RegisterProperty('BitmapFilled', 'Boolean', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TKTextBox(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TObject', 'TKTextBox') do
  with CL.AddClassN(CL.FindClass('TObject'),'TKTextBox') do
  begin
    RegisterMethod('Constructor Create');
    RegisterMethod('Procedure Draw( ACanvas : TCanvas; const ARect : TRect)');
    RegisterMethod('Function IndexToRect( ACanvas : TCanvas; const ARect : TRect; AIndex : Integer) : TRect');
    RegisterMethod('Procedure Measure( ACanvas : TCanvas; const ARect : TRect; var AWidth, AHeight : Integer)');
    RegisterMethod('Function PointToIndex( ACanvas : TCanvas; const ARect : TRect; APoint : TPoint) : Integer');
    RegisterMethod('Function TextExtent( ACanvas : TCanvas; const AText : TKString; AStart, ALen : Integer; AExpandTabs : Boolean; ASpacesForTab : Integer) : TSize');
    RegisterMethod('Procedure TextOutput( ACanvas : TCanvas; X, Y : Integer; const AText : TKString; AStart, ALen : Integer; AExpandTabs : Boolean; ASpacesForTab : Integer)');
    RegisterProperty('Attributes', 'TKTextAttributes', iptrw);
    RegisterProperty('BackColor', 'TColor', iptrw);
    RegisterProperty('HAlign', 'TKHAlign', iptrw);
    RegisterProperty('HPadding', 'Integer', iptrw);
    RegisterProperty('SelBkgnd', 'TColor', iptrw);
    RegisterProperty('SelColor', 'TColor', iptrw);
    RegisterProperty('SelEnd', 'Integer', iptrw);
    RegisterProperty('SelStart', 'Integer', iptrw);
    RegisterProperty('SpacesForTab', 'Integer', iptrw);
    RegisterProperty('Text', 'TKString', iptrw);
    RegisterProperty('VAlign', 'TKVAlign', iptrw);
    RegisterProperty('VPadding', 'Integer', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TKMetafile(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TGraphic', 'TKMetafile') do
  with CL.AddClassN(CL.FindClass('TGraphic'),'TKMetafile') do begin
    RegisterMethod('Constructor Create');
        RegisterMethod('Procedure Free');
     RegisterMethod('Procedure Assign( Source : TPersistent)');
    RegisterMethod('Procedure Clear');
    RegisterMethod('Procedure LoadFromStream( Stream : TStream)');
    RegisterMethod('Procedure Release( out AWmfHandle : HMETAFILE; out AEmfHandle : HENHMETAFILE)');
    RegisterMethod('Procedure SaveToStream( Stream : TStream)');
    RegisterProperty('CopyOnAssign', 'Boolean', iptrw);
    RegisterProperty('EMFHandle', 'HENHMETAFILE', iptrw);
    RegisterProperty('Enhanced', 'Boolean', iptrw);
    RegisterProperty('WMFHandle', 'HMETAFILE', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TKAlphaBitmap(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TKGraphic', 'TKAlphaBitmap') do
  with CL.AddClassN(CL.FindClass('TKGraphic'),'TKAlphaBitmap') do begin
    RegisterMethod('Constructor Create');
      RegisterMethod('Procedure Free');
      RegisterMethod('Constructor CreateFromRes( const ResName : string)');
    RegisterMethod('Procedure AlphaDrawTo( ACanvas : TCanvas; X, Y : Integer)');
    RegisterMethod('Procedure AlphaStretchDrawTo( ACanvas : TCanvas; const ARect : TRect)');
    RegisterMethod('Procedure AlphaFill( Alpha : Byte; IfEmpty : Boolean);');
    RegisterMethod('Procedure AlphaFill1( Alpha : Byte; BlendColor : TColor; Gradient, Translucent : Boolean);');
    RegisterMethod('Procedure AlphaFillOnColorMatch( AColor : TColor; AAlpha : Byte)');
    RegisterMethod('Procedure AlphaFillPercent( Percent : Integer; IfEmpty : Boolean)');
    RegisterMethod('Procedure CombinePixel( X, Y : Integer; Color : TKColorRec)');
    RegisterMethod('Procedure CopyFrom( ABitmap : TKAlphaBitmap)');
    RegisterMethod('Procedure CopyFromRotated( ABitmap : TKAlphaBitmap)');
    RegisterMethod('Procedure CopyFromXY( X, Y : Integer; ABitmap : TKAlphaBitmap)');
    RegisterMethod('Procedure DrawFrom( ACanvas : TCanvas; const ARect : TRect);');
    RegisterMethod('Procedure DrawFrom3( AGraphic : TGraphic; X, Y : Integer);');
    RegisterMethod('Procedure DrawTo( ACanvas : TCanvas; const ARect : TRect)');
    RegisterMethod('Procedure Fill( Color : TKColorRec)');
    RegisterMethod('Procedure GrayScale');
    RegisterMethod('Procedure LoadFromFile( const Filename : string)');
    RegisterMethod('Procedure LoadFromGraphic( Image : TGraphic)');
    RegisterMethod('Procedure LoadFromStream( Stream : TStream)');
    RegisterMethod('Procedure LockUpdate');
    RegisterMethod('Procedure MirrorHorz');
    RegisterMethod('Procedure MirrorVert');
    RegisterMethod('Procedure SaveToStream( Stream : TStream)');
    RegisterMethod('Procedure SetSize( AWidth, AHeight : Integer)');
    RegisterMethod('Procedure UnlockUpdate');
    RegisterMethod('Procedure UpdateHandle');
    RegisterMethod('Procedure UpdatePixels');
    RegisterMethod('procedure Assign(Source: TPersistent);');
    RegisterMethod('procedure AssignTo(Dest: TPersistent);');

   // procedure Assign(Source: TPersistent); override;
    { Copies shareable properties of this instance into another instance of TKAlphaBitmap. }
   // procedure AssignTo(Dest: TPersistent); override;

    RegisterProperty('AutoMirror', 'Boolean', iptrw);
    RegisterProperty('Canvas', 'TCanvas', iptr);
    RegisterProperty('DirectCopy', 'Boolean', iptrw);
    RegisterProperty('Handle', 'HBITMAP', iptr);
    RegisterProperty('Pixel', 'TKColorRec Integer Integer', iptrw);
    RegisterProperty('Pixels', 'PKColorRecs', iptr);
    RegisterProperty('PixelsChanged', 'Boolean', iptrw);
    RegisterProperty('ScanLine', 'PKColorRecs Integer', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TKGraphic(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TGraphic', 'TKGraphic') do
  with CL.AddClassN(CL.FindClass('TGraphic'),'TKGraphic') do
  begin
    RegisterMethod('Constructor Create');
    RegisterProperty('Description', 'string', iptr);
    RegisterProperty('FileFilter', 'string', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_KGraphics(CL: TPSPascalCompiler);
begin
 CL.AddConstantN('PNGHeader','String').SetString(' #137 ''PNG'' #13#10#26#10');
 CL.AddConstantN('MNGHeader','String').SetString( '#138 ''MNG'' #13#10#26#10');
  CL.AddTypeS('TKBrightMode', '( bsAbsolute, bsOfBottom, bsOfTop )');
  CL.AddTypeS('TKColorRec', 'record R : byte; G : byte; B : byte; A : Byte; Value : Cardinal; end');
  //CL.AddTypeS('PKColorRec', '^TKColorRec // will not work');
  CL.AddTypeS('TKDynColorRecs', 'array of TKColorRec');
  CL.AddTypeS('TKImageHeaderString', 'string');
  //CL.AddTypeS('TKPngImage', 'TPortableNetworkGraphic');
   with CL.AddClassN(CL.FindClass('TLinarGraphic'),'TPNGGraphic') do
      CL.AddTypeS('TKPngImage', 'TPNGGraphic');
      CL.AddTypeS('TKKString', 'WideString');

    //    TKString = WideString;
    //CL.AddTypeS('TKPngImage', 'TPngImage');
  //CL.AddTypeS('TKPngImage', 'TPngObject');
  CL.AddTypeS('TKTextAttribute', '( taCalcRect, taClip, taEndEllipsis, taFillRe'
   +'ct, taFillText, taIncludePadding, taLineBreak, taPathEllipsis, taWordBreak'
   +', taWrapText, taTrimWhiteSpaces, taStartEllipsis )');
  CL.AddTypeS('TKTextAttributes', 'set of TKTextAttribute');
  CL.AddTypeS('TKHAlign', '( halLeft, halCenter, halRight, halJustify )');
  CL.AddTypeS('TKStretchMode', '( stmNone, stmZoomOutOnly, stmZoomInOnly, stmZoom )');
  CL.AddTypeS('TKTextHAlign', 'TKHAlign');
  CL.AddTypeS('TKVAlign', '( valTop, valCenter, valBottom )');
  CL.AddTypeS('TKTextVAlign', 'TKVAlign');
  CL.AddTypeS('TKButtonDrawState', '( bsUseThemes, bsDisabled, bsPressed, bsFocused, bsHot )');
  CL.AddTypeS('TKButtonDrawStates', 'set of TKButtonDrawState');
  SIRegister_TKGraphic(CL);
  SIRegister_TKAlphaBitmap(CL);
  SIRegister_TKMetafile(CL);
  CL.AddTypeS('TKTextBoxFunction', '( tbfMeasure, tbfGetIndex, tbfGetRect, tbfDraw )');
  SIRegister_TKTextBox(CL);
  SIRegister_TKDragWindow(CL);
  SIRegister_TKHintWindow(CL);
  SIRegister_TKTextHint(CL);
  SIRegister_TKGraphicHint(CL);
 //CL.AddDelphiFunction('Procedure BlendLine( Src, Dest : PKColorRecs; Count : Integer)');
 CL.AddDelphiFunction('Function TKBrightColor( Color : TColor; Percent : Single; Mode : TKBrightMode) : TColor');
 CL.AddDelphiFunction('Procedure CanvasGetScale( ACanvas : TCanvas; out MulX, MulY, DivX, DivY : Integer)');
 CL.AddDelphiFunction('Procedure CanvasResetScale( ACanvas : TCanvas)');
 CL.AddDelphiFunction('Function CanvasScaled( ACanvas : TCanvas) : Boolean');
 CL.AddDelphiFunction('Procedure CanvasSetScale( ACanvas : TCanvas; MulX, MulY, DivX, DivY : Integer)');
 CL.AddDelphiFunction('Procedure CanvasSetOffset( ACanvas : TCanvas; OfsX, OfsY : Integer)');
 CL.AddDelphiFunction('Function ColorRecToColor( Color : TKColorRec) : TColor');
 CL.AddDelphiFunction('Function ColorToColorRec( Color : TColor) : TKColorRec');
 CL.AddDelphiFunction('Function TKColorToGrayScale( Color : TColor) : TColor');
 CL.AddDelphiFunction('Function CompareBrushes( ABrush1, ABrush2 : TBrush) : Boolean');
 CL.AddDelphiFunction('Function CompareFonts( AFont1, AFont2 : TFont) : Boolean');
 CL.AddDelphiFunction('Procedure CopyBitmap( DestDC : HDC; DestRect : TRect; SrcDC : HDC; SrcX, SrcY : Integer)');
 CL.AddDelphiFunction('Function CreateEmptyPoint : TPoint');
 CL.AddDelphiFunction('Function CreateEmptyRect : TRect');
 CL.AddDelphiFunction('Function CreateEmptyRgn : HRGN');
 CL.AddDelphiFunction('Procedure DrawAlignedText( Canvas : TCanvas; var ARect : TRect; HAlign : TKHAlign; VAlign : TKVAlign; HPadding, VPadding : Integer; const AText : TKKString; BackColor : TColor; Attributes : TKTextAttributes)');
 CL.AddDelphiFunction('Procedure TKDrawButtonFrame( ACanvas : TCanvas; const ARect : TRect; AStates : TKButtonDrawStates)');
 CL.AddDelphiFunction('Procedure DrawEdges( Canvas : TCanvas; const R : TRect; HighlightColor, ShadowColor : TColor; Flags : Cardinal)');
 CL.AddDelphiFunction('Procedure DrawFilledRectangle( Canvas : TCanvas; const ARect : TRect; BackColor : TColor)');
 CL.AddDelphiFunction('Procedure DrawGradientRect( Canvas : TCanvas; const ARect : TRect; AStartColor, AEndColor : TColor; AColorStep : Integer; AHorizontal : Boolean)');
 CL.AddDelphiFunction('Procedure ExcludeShapeFromBaseRect( var BaseRect : TRect; ShapeWidth, ShapeHeight : Integer; HAlign : TKHAlign; VAlign : TKVAlign; HPadding, VPadding : Integer; StretchMode : TKStretchMode; out Bounds, Interior : TRect)');
 CL.AddDelphiFunction('Function ExtSelectClipRect( DC : HDC; ARect : TRect; Mode : Integer; var PrevRgn : HRGN) : Boolean');
 CL.AddDelphiFunction('Function ExtSelectClipRectEx( DC : HDC; ARect : TRect; Mode : Integer; CurRgn, PrevRgn : HRGN) : Boolean');
 CL.AddDelphiFunction('Procedure FillAroundRect( ACanvas : TCanvas; const Boundary, Interior : TRect; BackColor : TColor)');
 CL.AddDelphiFunction('Function GetFontHeight( DC : HDC) : Integer');
 CL.AddDelphiFunction('Function GetFontAscent( DC : HDC) : Integer');
 CL.AddDelphiFunction('Function GetFontDescent( DC : HDC) : Integer');
 CL.AddDelphiFunction('Function GDICheck( Value : Integer) : Integer');
 CL.AddDelphiFunction('Function HorizontalShapePosition( AAlignment : TKHAlign; const ABoundary : TRect; const AShapeSize : TPoint) : Integer');
 CL.AddDelphiFunction('Function ImageByType( const Header : TKImageHeaderString) : TGraphic');
 CL.AddDelphiFunction('Function IntersectClipRectIndirect( DC : HDC; ARect : TRect) : Boolean');
 CL.AddDelphiFunction('Function IsBrightColor( Color : TColor) : Boolean');
 CL.AddDelphiFunction('Procedure LoadCustomCursor( Cursor : TCursor; const ResName : string)');
 CL.AddDelphiFunction('Procedure TKLoadGraphicFromResource( Graphic : TGraphic; const ResName : string; ResType : PChar)');
 CL.AddDelphiFunction('Function MakeColorRec( R, G, B, A : Byte) : TKColorRec;');
 CL.AddDelphiFunction('Function MakeColorRec5( Value : LongWord) : TKColorRec;');
 CL.AddDelphiFunction('Function PixelFormatFromBpp( Bpp : Cardinal) : TPixelFormat');
 CL.AddDelphiFunction('Function TKRectInRegion( Rgn : HRGN; ARect : TRect) : Boolean');
 CL.AddDelphiFunction('Function RgnCreateAndGet( DC : HDC) : HRGN');
 CL.AddDelphiFunction('Procedure RgnSelectAndDelete( DC : HDC; Rgn : HRGN)');
 CL.AddDelphiFunction('Procedure RoundRectangle( ACanvas : TCanvas; const ARect : TRect; AXRadius, AYRadius : Integer)');
 CL.AddDelphiFunction('Procedure SafeStretchDraw( ACanvas : TCanvas; ARect : TRect; AGraphic : TGraphic; ABackColor : TColor)');
 CL.AddDelphiFunction('Procedure SelectClipRect( DC : HDC; const ARect : TRect)');
 CL.AddDelphiFunction('Procedure TKStretchBitmap( DestDC : HDC; DestRect : TRect; SrcDC : HDC; SrcRect : TRect)');
 CL.AddDelphiFunction('Function SwitchRGBToBGR( Value : TColor) : TColor');
 CL.AddDelphiFunction('Procedure TranslateRectToDevice( DC : HDC; var ARect : TRect)');
 CL.AddDelphiFunction('Function VerticalShapePosition( AAlignment : TKVAlign; const ABoundary : TRect; const AShapeSize : TPoint) : Integer');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
Function MakeColorRec5_P( Value : LongWord) : TKColorRec;
Begin Result := KGraphics.MakeColorRec(Value); END;

(*----------------------------------------------------------------------------*)
Function MakeColorRec_P( R, G, B, A : Byte) : TKColorRec;
Begin Result := KGraphics.MakeColorRec(R, G, B, A); END;

(*----------------------------------------------------------------------------*)
procedure TKGraphicHintGraphic_W(Self: TKGraphicHint; const T: TGraphic);
begin Self.Graphic := T; end;

(*----------------------------------------------------------------------------*)
procedure TKGraphicHintGraphic_R(Self: TKGraphicHint; var T: TGraphic);
begin T := Self.Graphic; end;

(*----------------------------------------------------------------------------*)
procedure TKTextHintText_W(Self: TKTextHint; const T: TKString);
begin Self.Text := T; end;

(*----------------------------------------------------------------------------*)
procedure TKTextHintText_R(Self: TKTextHint; var T: TKString);
begin T := Self.Text; end;

(*----------------------------------------------------------------------------*)
procedure TKHintWindowExtent_R(Self: TKHintWindow; var T: TPoint);
begin T := Self.Extent; end;

(*----------------------------------------------------------------------------*)
procedure TKDragWindowBitmapFilled_R(Self: TKDragWindow; var T: Boolean);
begin T := Self.BitmapFilled; end;

(*----------------------------------------------------------------------------*)
procedure TKDragWindowBitmap_R(Self: TKDragWindow; var T: TKAlphaBitmap);
begin T := Self.Bitmap; end;

(*----------------------------------------------------------------------------*)
procedure TKDragWindowActive_R(Self: TKDragWindow; var T: Boolean);
begin T := Self.Active; end;

(*----------------------------------------------------------------------------*)
procedure TKTextBoxVPadding_W(Self: TKTextBox; const T: Integer);
begin Self.VPadding := T; end;

(*----------------------------------------------------------------------------*)
procedure TKTextBoxVPadding_R(Self: TKTextBox; var T: Integer);
begin T := Self.VPadding; end;

(*----------------------------------------------------------------------------*)
procedure TKTextBoxVAlign_W(Self: TKTextBox; const T: TKVAlign);
begin Self.VAlign := T; end;

(*----------------------------------------------------------------------------*)
procedure TKTextBoxVAlign_R(Self: TKTextBox; var T: TKVAlign);
begin T := Self.VAlign; end;

(*----------------------------------------------------------------------------*)
procedure TKTextBoxText_W(Self: TKTextBox; const T: TKString);
begin Self.Text := T; end;

(*----------------------------------------------------------------------------*)
procedure TKTextBoxText_R(Self: TKTextBox; var T: TKString);
begin T := Self.Text; end;

(*----------------------------------------------------------------------------*)
procedure TKTextBoxSpacesForTab_W(Self: TKTextBox; const T: Integer);
begin Self.SpacesForTab := T; end;

(*----------------------------------------------------------------------------*)
procedure TKTextBoxSpacesForTab_R(Self: TKTextBox; var T: Integer);
begin T := Self.SpacesForTab; end;

(*----------------------------------------------------------------------------*)
procedure TKTextBoxSelStart_W(Self: TKTextBox; const T: Integer);
begin Self.SelStart := T; end;

(*----------------------------------------------------------------------------*)
procedure TKTextBoxSelStart_R(Self: TKTextBox; var T: Integer);
begin T := Self.SelStart; end;

(*----------------------------------------------------------------------------*)
procedure TKTextBoxSelEnd_W(Self: TKTextBox; const T: Integer);
begin Self.SelEnd := T; end;

(*----------------------------------------------------------------------------*)
procedure TKTextBoxSelEnd_R(Self: TKTextBox; var T: Integer);
begin T := Self.SelEnd; end;

(*----------------------------------------------------------------------------*)
procedure TKTextBoxSelColor_W(Self: TKTextBox; const T: TColor);
begin Self.SelColor := T; end;

(*----------------------------------------------------------------------------*)
procedure TKTextBoxSelColor_R(Self: TKTextBox; var T: TColor);
begin T := Self.SelColor; end;

(*----------------------------------------------------------------------------*)
procedure TKTextBoxSelBkgnd_W(Self: TKTextBox; const T: TColor);
begin Self.SelBkgnd := T; end;

(*----------------------------------------------------------------------------*)
procedure TKTextBoxSelBkgnd_R(Self: TKTextBox; var T: TColor);
begin T := Self.SelBkgnd; end;

(*----------------------------------------------------------------------------*)
procedure TKTextBoxHPadding_W(Self: TKTextBox; const T: Integer);
begin Self.HPadding := T; end;

(*----------------------------------------------------------------------------*)
procedure TKTextBoxHPadding_R(Self: TKTextBox; var T: Integer);
begin T := Self.HPadding; end;

(*----------------------------------------------------------------------------*)
procedure TKTextBoxHAlign_W(Self: TKTextBox; const T: TKHAlign);
begin Self.HAlign := T; end;

(*----------------------------------------------------------------------------*)
procedure TKTextBoxHAlign_R(Self: TKTextBox; var T: TKHAlign);
begin T := Self.HAlign; end;

(*----------------------------------------------------------------------------*)
procedure TKTextBoxBackColor_W(Self: TKTextBox; const T: TColor);
begin Self.BackColor := T; end;

(*----------------------------------------------------------------------------*)
procedure TKTextBoxBackColor_R(Self: TKTextBox; var T: TColor);
begin T := Self.BackColor; end;

(*----------------------------------------------------------------------------*)
procedure TKTextBoxAttributes_W(Self: TKTextBox; const T: TKTextAttributes);
begin Self.Attributes := T; end;

(*----------------------------------------------------------------------------*)
procedure TKTextBoxAttributes_R(Self: TKTextBox; var T: TKTextAttributes);
begin T := Self.Attributes; end;

(*----------------------------------------------------------------------------*)
procedure TKMetafileWMFHandle_W(Self: TKMetafile; const T: HMETAFILE);
begin Self.WMFHandle := T; end;

(*----------------------------------------------------------------------------*)
procedure TKMetafileWMFHandle_R(Self: TKMetafile; var T: HMETAFILE);
begin T := Self.WMFHandle; end;

(*----------------------------------------------------------------------------*)
procedure TKMetafileEnhanced_W(Self: TKMetafile; const T: Boolean);
begin Self.Enhanced := T; end;

(*----------------------------------------------------------------------------*)
procedure TKMetafileEnhanced_R(Self: TKMetafile; var T: Boolean);
begin T := Self.Enhanced; end;

(*----------------------------------------------------------------------------*)
procedure TKMetafileEMFHandle_W(Self: TKMetafile; const T: HENHMETAFILE);
begin Self.EMFHandle := T; end;

(*----------------------------------------------------------------------------*)
procedure TKMetafileEMFHandle_R(Self: TKMetafile; var T: HENHMETAFILE);
begin T := Self.EMFHandle; end;

(*----------------------------------------------------------------------------*)
procedure TKMetafileCopyOnAssign_W(Self: TKMetafile; const T: Boolean);
begin Self.CopyOnAssign := T; end;

(*----------------------------------------------------------------------------*)
procedure TKMetafileCopyOnAssign_R(Self: TKMetafile; var T: Boolean);
begin T := Self.CopyOnAssign; end;

(*----------------------------------------------------------------------------*)
procedure TKAlphaBitmapScanLine_R(Self: TKAlphaBitmap; var T: PKColorRecs; const t1: Integer);
begin T := Self.ScanLine[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TKAlphaBitmapPixelsChanged_W(Self: TKAlphaBitmap; const T: Boolean);
begin Self.PixelsChanged := T; end;

(*----------------------------------------------------------------------------*)
procedure TKAlphaBitmapPixelsChanged_R(Self: TKAlphaBitmap; var T: Boolean);
begin T := Self.PixelsChanged; end;

(*----------------------------------------------------------------------------*)
procedure TKAlphaBitmapPixels_R(Self: TKAlphaBitmap; var T: PKColorRecs);
begin T := Self.Pixels; end;

(*----------------------------------------------------------------------------*)
procedure TKAlphaBitmapPixel_W(Self: TKAlphaBitmap; const T: TKColorRec; const t1: Integer; const t2: Integer);
begin Self.Pixel[t1, t2] := T; end;

(*----------------------------------------------------------------------------*)
procedure TKAlphaBitmapPixel_R(Self: TKAlphaBitmap; var T: TKColorRec; const t1: Integer; const t2: Integer);
begin T := Self.Pixel[t1, t2]; end;

(*----------------------------------------------------------------------------*)
procedure TKAlphaBitmapHandle_R(Self: TKAlphaBitmap; var T: HBITMAP);
begin T := Self.Handle; end;

(*----------------------------------------------------------------------------*)
procedure TKAlphaBitmapDirectCopy_W(Self: TKAlphaBitmap; const T: Boolean);
begin Self.DirectCopy := T; end;

(*----------------------------------------------------------------------------*)
procedure TKAlphaBitmapDirectCopy_R(Self: TKAlphaBitmap; var T: Boolean);
begin T := Self.DirectCopy; end;

(*----------------------------------------------------------------------------*)
procedure TKAlphaBitmapCanvas_R(Self: TKAlphaBitmap; var T: TCanvas);
begin T := Self.Canvas; end;

(*----------------------------------------------------------------------------*)
procedure TKAlphaBitmapAutoMirror_W(Self: TKAlphaBitmap; const T: Boolean);
begin Self.AutoMirror := T; end;

(*----------------------------------------------------------------------------*)
procedure TKAlphaBitmapAutoMirror_R(Self: TKAlphaBitmap; var T: Boolean);
begin T := Self.AutoMirror; end;

(*----------------------------------------------------------------------------*)
Procedure TKAlphaBitmapDrawFrom3_P(Self: TKAlphaBitmap;  AGraphic : TGraphic; X, Y : Integer);
Begin Self.DrawFrom(AGraphic, X, Y); END;

(*----------------------------------------------------------------------------*)
Procedure TKAlphaBitmapDrawFrom_P(Self: TKAlphaBitmap;  ACanvas : TCanvas; const ARect : TRect);
Begin Self.DrawFrom(ACanvas, ARect); END;

(*----------------------------------------------------------------------------*)
Procedure TKAlphaBitmapAlphaFill1_P(Self: TKAlphaBitmap;  Alpha : Byte; BlendColor : TColor; Gradient, Translucent : Boolean);
Begin Self.AlphaFill(Alpha, BlendColor, Gradient, Translucent); END;

(*----------------------------------------------------------------------------*)
Procedure TKAlphaBitmapAlphaFill_P(Self: TKAlphaBitmap;  Alpha : Byte; IfEmpty : Boolean);
Begin Self.AlphaFill(Alpha, IfEmpty); END;

(*----------------------------------------------------------------------------*)
procedure TKGraphicFileFilter_R(Self: TKGraphic; var T: string);
begin T := Self.FileFilter; end;

(*----------------------------------------------------------------------------*)
procedure TKGraphicDescription_R(Self: TKGraphic; var T: string);
begin T := Self.Description; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_KGraphics_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@BlendLine, 'BlendLine', cdRegister);
 S.RegisterDelphiFunction(@BrightColor, 'TKBrightColor', cdRegister);
 S.RegisterDelphiFunction(@CanvasGetScale, 'CanvasGetScale', cdRegister);
 S.RegisterDelphiFunction(@CanvasResetScale, 'CanvasResetScale', cdRegister);
 S.RegisterDelphiFunction(@CanvasScaled, 'CanvasScaled', cdRegister);
 S.RegisterDelphiFunction(@CanvasSetScale, 'CanvasSetScale', cdRegister);
 S.RegisterDelphiFunction(@CanvasSetOffset, 'CanvasSetOffset', cdRegister);
 S.RegisterDelphiFunction(@ColorRecToColor, 'ColorRecToColor', cdRegister);
 S.RegisterDelphiFunction(@ColorToColorRec, 'ColorToColorRec', cdRegister);
 S.RegisterDelphiFunction(@ColorToGrayScale, 'TKColorToGrayScale', cdRegister);
 S.RegisterDelphiFunction(@CompareBrushes, 'CompareBrushes', cdRegister);
 S.RegisterDelphiFunction(@CompareFonts, 'CompareFonts', cdRegister);
 S.RegisterDelphiFunction(@CopyBitmap, 'CopyBitmap', cdRegister);
 S.RegisterDelphiFunction(@CreateEmptyPoint, 'CreateEmptyPoint', cdRegister);
 S.RegisterDelphiFunction(@CreateEmptyRect, 'CreateEmptyRect', cdRegister);
 S.RegisterDelphiFunction(@CreateEmptyRgn, 'CreateEmptyRgn', cdRegister);
 S.RegisterDelphiFunction(@DrawAlignedText, 'DrawAlignedText', cdRegister);
 S.RegisterDelphiFunction(@DrawButtonFrame, 'TKDrawButtonFrame', cdRegister);
 S.RegisterDelphiFunction(@DrawEdges, 'DrawEdges', cdRegister);
 S.RegisterDelphiFunction(@DrawFilledRectangle, 'DrawFilledRectangle', cdRegister);
 S.RegisterDelphiFunction(@DrawGradientRect, 'DrawGradientRect', cdRegister);
 S.RegisterDelphiFunction(@ExcludeShapeFromBaseRect, 'ExcludeShapeFromBaseRect', cdRegister);
 S.RegisterDelphiFunction(@ExtSelectClipRect, 'ExtSelectClipRect', cdRegister);
 S.RegisterDelphiFunction(@ExtSelectClipRectEx, 'ExtSelectClipRectEx', cdRegister);
 S.RegisterDelphiFunction(@FillAroundRect, 'FillAroundRect', cdRegister);
 S.RegisterDelphiFunction(@GetFontHeight, 'GetFontHeight', cdRegister);
 S.RegisterDelphiFunction(@GetFontAscent, 'GetFontAscent', cdRegister);
 S.RegisterDelphiFunction(@GetFontDescent, 'GetFontDescent', cdRegister);
 S.RegisterDelphiFunction(@GDICheck, 'GDICheck', cdRegister);
 S.RegisterDelphiFunction(@HorizontalShapePosition, 'HorizontalShapePosition', cdRegister);
 S.RegisterDelphiFunction(@ImageByType, 'ImageByType', cdRegister);
 S.RegisterDelphiFunction(@IntersectClipRectIndirect, 'IntersectClipRectIndirect', cdRegister);
 S.RegisterDelphiFunction(@IsBrightColor, 'IsBrightColor', cdRegister);
 S.RegisterDelphiFunction(@LoadCustomCursor, 'LoadCustomCursor', cdRegister);
 S.RegisterDelphiFunction(@LoadGraphicFromResource, 'TKLoadGraphicFromResource', cdRegister);
 S.RegisterDelphiFunction(@MakeColorRec, 'MakeColorRec', cdRegister);
 //S.RegisterDelphiFunction(@MakeColorRec5, 'MakeColorRec5', cdRegister);
 S.RegisterDelphiFunction(@PixelFormatFromBpp, 'PixelFormatFromBpp', cdRegister);
 S.RegisterDelphiFunction(@RectInRegion, 'TKRectInRegion', cdRegister);
 S.RegisterDelphiFunction(@RgnCreateAndGet, 'RgnCreateAndGet', cdRegister);
 S.RegisterDelphiFunction(@RgnSelectAndDelete, 'RgnSelectAndDelete', cdRegister);
 S.RegisterDelphiFunction(@RoundRectangle, 'RoundRectangle', cdRegister);
 S.RegisterDelphiFunction(@SafeStretchDraw, 'SafeStretchDraw', cdRegister);
 S.RegisterDelphiFunction(@SelectClipRect, 'SelectClipRect', cdRegister);
 S.RegisterDelphiFunction(@StretchBitmap, 'TKStretchBitmap', cdRegister);
 S.RegisterDelphiFunction(@SwitchRGBToBGR, 'SwitchRGBToBGR', cdRegister);
 S.RegisterDelphiFunction(@TranslateRectToDevice, 'TranslateRectToDevice', cdRegister);
 S.RegisterDelphiFunction(@VerticalShapePosition, 'VerticalShapePosition', cdRegister);
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TKGraphicHint(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TKGraphicHint) do
  begin
    RegisterConstructor(@TKGraphicHint.Create, 'Create');
    RegisterPropertyHelper(@TKGraphicHintGraphic_R,@TKGraphicHintGraphic_W,'Graphic');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TKTextHint(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TKTextHint) do
  begin
    RegisterConstructor(@TKTextHint.Create, 'Create');
    RegisterPropertyHelper(@TKTextHintText_R,@TKTextHintText_W,'Text');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TKHintWindow(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TKHintWindow) do
  begin
    RegisterConstructor(@TKHintWindow.Create, 'Create');
    RegisterMethod(@TKHintWindow.ShowAt, 'ShowAt');
    RegisterMethod(@TKHintWindow.Hide, 'Hide');
    RegisterPropertyHelper(@TKHintWindowExtent_R,nil,'Extent');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TKDragWindow(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TKDragWindow) do begin
    RegisterConstructor(@TKDragWindow.Create, 'Create');
         RegisterMethod(@TKDragWindow.Destroy, 'Free');
        RegisterMethod(@TKDragWindow.Init, 'Init');
    RegisterMethod(@TKDragWindow.Move, 'Move');
    RegisterMethod(@TKDragWindow.Hide, 'Hide');
    RegisterPropertyHelper(@TKDragWindowActive_R,nil,'Active');
    RegisterPropertyHelper(@TKDragWindowBitmap_R,nil,'Bitmap');
    RegisterPropertyHelper(@TKDragWindowBitmapFilled_R,nil,'BitmapFilled');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TKTextBox(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TKTextBox) do
  begin
    RegisterConstructor(@TKTextBox.Create, 'Create');
    RegisterVirtualMethod(@TKTextBox.Draw, 'Draw');
    RegisterVirtualMethod(@TKTextBox.IndexToRect, 'IndexToRect');
    RegisterVirtualMethod(@TKTextBox.Measure, 'Measure');
    RegisterVirtualMethod(@TKTextBox.PointToIndex, 'PointToIndex');
    RegisterMethod(@TKTextBox.TextExtent, 'TextExtent');
    RegisterMethod(@TKTextBox.TextOutput, 'TextOutput');
    RegisterPropertyHelper(@TKTextBoxAttributes_R,@TKTextBoxAttributes_W,'Attributes');
    RegisterPropertyHelper(@TKTextBoxBackColor_R,@TKTextBoxBackColor_W,'BackColor');
    RegisterPropertyHelper(@TKTextBoxHAlign_R,@TKTextBoxHAlign_W,'HAlign');
    RegisterPropertyHelper(@TKTextBoxHPadding_R,@TKTextBoxHPadding_W,'HPadding');
    RegisterPropertyHelper(@TKTextBoxSelBkgnd_R,@TKTextBoxSelBkgnd_W,'SelBkgnd');
    RegisterPropertyHelper(@TKTextBoxSelColor_R,@TKTextBoxSelColor_W,'SelColor');
    RegisterPropertyHelper(@TKTextBoxSelEnd_R,@TKTextBoxSelEnd_W,'SelEnd');
    RegisterPropertyHelper(@TKTextBoxSelStart_R,@TKTextBoxSelStart_W,'SelStart');
    RegisterPropertyHelper(@TKTextBoxSpacesForTab_R,@TKTextBoxSpacesForTab_W,'SpacesForTab');
    RegisterPropertyHelper(@TKTextBoxText_R,@TKTextBoxText_W,'Text');
    RegisterPropertyHelper(@TKTextBoxVAlign_R,@TKTextBoxVAlign_W,'VAlign');
    RegisterPropertyHelper(@TKTextBoxVPadding_R,@TKTextBoxVPadding_W,'VPadding');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TKMetafile(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TKMetafile) do begin
    RegisterConstructor(@TKMetafile.Create, 'Create');
       RegisterMethod(@TKMetafile.Destroy, 'Free');
       RegisterMethod(@TKMetafile.Assign, 'Assign');
    RegisterVirtualMethod(@TKMetafile.Clear, 'Clear');
    RegisterMethod(@TKMetafile.LoadFromStream, 'LoadFromStream');
    RegisterMethod(@TKMetafile.Release, 'Release');
    RegisterMethod(@TKMetafile.SaveToStream, 'SaveToStream');
    RegisterPropertyHelper(@TKMetafileCopyOnAssign_R,@TKMetafileCopyOnAssign_W,'CopyOnAssign');
    RegisterPropertyHelper(@TKMetafileEMFHandle_R,@TKMetafileEMFHandle_W,'EMFHandle');
    RegisterPropertyHelper(@TKMetafileEnhanced_R,@TKMetafileEnhanced_W,'Enhanced');
    RegisterPropertyHelper(@TKMetafileWMFHandle_R,@TKMetafileWMFHandle_W,'WMFHandle');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TKAlphaBitmap(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TKAlphaBitmap) do begin
    RegisterConstructor(@TKAlphaBitmap.Create, 'Create');
    RegisterMethod(@TKAlphaBitmap.Destroy, 'Free');
    RegisterConstructor(@TKAlphaBitmap.CreateFromRes, 'CreateFromRes');
    RegisterMethod(@TKAlphaBitmap.AlphaDrawTo, 'AlphaDrawTo');
    RegisterMethod(@TKAlphaBitmap.Assign, 'Assign');
    RegisterMethod(@TKAlphaBitmap.AssignTo, 'AssignTo');

    RegisterMethod(@TKAlphaBitmap.AlphaStretchDrawTo, 'AlphaStretchDrawTo');
    RegisterMethod(@TKAlphaBitmapAlphaFill_P, 'AlphaFill');
    RegisterMethod(@TKAlphaBitmapAlphaFill1_P, 'AlphaFill1');
    RegisterMethod(@TKAlphaBitmap.AlphaFillOnColorMatch, 'AlphaFillOnColorMatch');
    RegisterMethod(@TKAlphaBitmap.AlphaFillPercent, 'AlphaFillPercent');
    RegisterMethod(@TKAlphaBitmap.CombinePixel, 'CombinePixel');
    RegisterMethod(@TKAlphaBitmap.CopyFrom, 'CopyFrom');
    RegisterMethod(@TKAlphaBitmap.CopyFromRotated, 'CopyFromRotated');
    RegisterMethod(@TKAlphaBitmap.CopyFromXY, 'CopyFromXY');
    RegisterMethod(@TKAlphaBitmapDrawFrom_P, 'DrawFrom');
    RegisterMethod(@TKAlphaBitmapDrawFrom3_P, 'DrawFrom3');
    RegisterMethod(@TKAlphaBitmap.DrawTo, 'DrawTo');
    RegisterMethod(@TKAlphaBitmap.Fill, 'Fill');
    RegisterMethod(@TKAlphaBitmap.GrayScale, 'GrayScale');
    RegisterMethod(@TKAlphaBitmap.LoadFromFile, 'LoadFromFile');
    RegisterVirtualMethod(@TKAlphaBitmap.LoadFromGraphic, 'LoadFromGraphic');
    RegisterMethod(@TKAlphaBitmap.LoadFromStream, 'LoadFromStream');
    RegisterVirtualMethod(@TKAlphaBitmap.LockUpdate, 'LockUpdate');
    RegisterMethod(@TKAlphaBitmap.MirrorHorz, 'MirrorHorz');
    RegisterMethod(@TKAlphaBitmap.MirrorVert, 'MirrorVert');
    RegisterMethod(@TKAlphaBitmap.SaveToStream, 'SaveToStream');
    RegisterMethod(@TKAlphaBitmap.SetSize, 'SetSize');
    RegisterVirtualMethod(@TKAlphaBitmap.UnlockUpdate, 'UnlockUpdate');
    RegisterVirtualMethod(@TKAlphaBitmap.UpdateHandle, 'UpdateHandle');
    RegisterVirtualMethod(@TKAlphaBitmap.UpdatePixels, 'UpdatePixels');
    RegisterPropertyHelper(@TKAlphaBitmapAutoMirror_R,@TKAlphaBitmapAutoMirror_W,'AutoMirror');
    RegisterPropertyHelper(@TKAlphaBitmapCanvas_R,nil,'Canvas');
    RegisterPropertyHelper(@TKAlphaBitmapDirectCopy_R,@TKAlphaBitmapDirectCopy_W,'DirectCopy');
    RegisterPropertyHelper(@TKAlphaBitmapHandle_R,nil,'Handle');
    RegisterPropertyHelper(@TKAlphaBitmapPixel_R,@TKAlphaBitmapPixel_W,'Pixel');
    RegisterPropertyHelper(@TKAlphaBitmapPixels_R,nil,'Pixels');
    RegisterPropertyHelper(@TKAlphaBitmapPixelsChanged_R,@TKAlphaBitmapPixelsChanged_W,'PixelsChanged');
    RegisterPropertyHelper(@TKAlphaBitmapScanLine_R,nil,'ScanLine');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TKGraphic(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TKGraphic) do
  begin
    RegisterConstructor(@TKGraphic.Create, 'Create');
    RegisterPropertyHelper(@TKGraphicDescription_R,nil,'Description');
    RegisterPropertyHelper(@TKGraphicFileFilter_R,nil,'FileFilter');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_KGraphics(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TKGraphic(CL);
  RIRegister_TKAlphaBitmap(CL);
  RIRegister_TKMetafile(CL);
  RIRegister_TKTextBox(CL);
  RIRegister_TKDragWindow(CL);
  RIRegister_TKHintWindow(CL);
  RIRegister_TKTextHint(CL);
  RIRegister_TKGraphicHint(CL);
end;

 
 
{ TPSImport_KGraphics }
(*----------------------------------------------------------------------------*)
procedure TPSImport_KGraphics.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_KGraphics(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_KGraphics.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_KGraphics(ri);
  RIRegister_KGraphics_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
