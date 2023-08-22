
unit uPSR_graphics;
{$I PascalScript.inc}

{Date: 2010-05-19 08:24:27 +0200 (Wed, 19 May 2010)
New Revision: 227, tbrush-bitmap, max}
//extended bitmap  transparent mode, mask, new TIcon  and TMetaFile
// override additional  3.9.7  TNotifyEvent onchange in canvas
//onchange onprogess in picture    out loadfromstream in tgraphc abstract  - onprogress


interface
uses
  uPSRuntime, uPSUtils;

{ run-time registration functions }
procedure RIRegister_Graphics_Routines(S: TPSExec);
procedure RIRegisterTGRAPHICSOBJECT(Cl: TPSRuntimeClassImporter);
procedure RIRegisterTGraphic(CL: TPSRuntimeClassImporter);
procedure RIRegisterTFont(Cl: TPSRuntimeClassImporter);
procedure RIRegisterTPEN(Cl: TPSRuntimeClassImporter);
procedure RIRegisterTBRUSH(Cl: TPSRuntimeClassImporter);
procedure RIRegister_TMetafile(CL: TPSRuntimeClassImporter);   //3.6
procedure RIRegister_TIcon(CL: TPSRuntimeClassImporter);
procedure RIRegisterTCanvas(cl: TPSRuntimeClassImporter);
procedure RIRegisterTBitmap(CL: TPSRuntimeClassImporter; Streams: Boolean);
procedure RIRegisterTPicture(CL: TPSRuntimeClassImporter);

//procedure SIRegisterTPicture(CL: TPSPascalCompiler);
procedure RIRegister_Graphics(Cl: TPSRuntimeClassImporter; Streams: Boolean);

implementation
{$IFNDEF FPC}
uses
  Classes{$IFDEF CLX}, QGraphics{$ELSE}, Windows, Graphics, Types{$ENDIF};
{$ELSE}
uses
  Classes, Graphics, LCLType;
{$ENDIF}

{$IFNDEF CLX}
procedure TFontHandleR(Self: TFont; var T: Longint); begin T := Self.Handle; end;
procedure TFontHandleW(Self: TFont; T: Longint); begin Self.Handle := T; end;
{$ENDIF}
procedure TFontPixelsPerInchR(Self: TFont; var T: Longint); begin T := Self.PixelsPerInch; end;
procedure TFontPixelsPerInchW(Self: TFont; T: Longint); begin {$IFNDEF FPC} Self.PixelsPerInch := T;{$ENDIF} end;
procedure TFontStyleR(Self: TFont; var T: TFontStyles); begin T := Self.Style; end;
procedure TFontStyleW(Self: TFont; T: TFontStyles); begin Self.Style:= T; end;

(*----------------------------------------------------------------------------*)
procedure TFontCharset_W(Self: TFont; const T: TFontCharset);
begin Self.Charset := T; end;

(*----------------------------------------------------------------------------*)
procedure TFontCharset_R(Self: TFont; var T: TFontCharset);
begin T := Self.Charset; end;

(*----------------------------------------------------------------------------*)
procedure TFontPitch_W(Self: TFont; const T: TFontPitch);
begin Self.Pitch := T; end;

(*----------------------------------------------------------------------------*)
procedure TFontPitch_R(Self: TFont; var T: TFontPitch);
begin T := Self.Pitch; end;

(*----------------------------------------------------------------------------*)
procedure TFontOrientation_W(Self: TFont; const T: Integer);
begin Self.Orientation := T; end;

(*----------------------------------------------------------------------------*)
procedure TFontOrientation_R(Self: TFont; var T: Integer);
begin T := Self.Orientation; end;

{(*----------------------------------------------------------------------------*)
procedure TFontSize_W(Self: TFont; const T: Integer);
begin Self.Size := T; end;

(*----------------------------------------------------------------------------*)
procedure TFontSize_R(Self: TFont; var T: Integer);
begin T := Self.Size; end;}



procedure RIRegisterTFont(Cl: TPSRuntimeClassImporter);
begin
  with Cl.Add(TFont) do begin
    RegisterConstructor(@TFont.Create, 'CREATE');
    RegisterMethod(@TFont.Destroy, 'Free');
    RegisterMethod(@TFont.Assign, 'Assign');
{$IFNDEF CLX}
    RegisterPropertyHelper(@TFontHandleR, @TFontHandleW, 'HANDLE');
{$ENDIF}
    RegisterPropertyHelper(@TFontPixelsPerInchR, @TFontPixelsPerInchW, 'PIXELSPERINCH');
    RegisterPropertyHelper(@TFontStyleR, @TFontStyleW, 'STYLE');
    RegisterPropertyHelper(@TFontCharset_R,@TFontCharset_W,'Charset');
    RegisterPropertyHelper(@TFontOrientation_R,@TFontOrientation_W,'Orientation');
    RegisterPropertyHelper(@TFontPitch_R,@TFontPitch_W,'Pitch');

    //RegisterPropertyHelper(@TFontSize_R,@TFontSize_W,'Size');  ?
    //RegisterPropertyHelper(@TFontName_R,@TFontName_W,'Name');

  end;
end;
{$IFNDEF CLX}
procedure TCanvasHandleR(Self: TCanvas; var T: Longint); begin T := Self.Handle; end;
procedure TCanvasHandleW(Self: TCanvas; T: Longint); begin Self.Handle:= T; end;

{$ENDIF}

procedure TCanvasPixelsR(Self: TCanvas; var T: Longint; X,Y: Longint); begin T := Self.Pixels[X,Y]; end;
procedure TCanvasPixelsW(Self: TCanvas; T, X, Y: Longint); begin Self.Pixels[X,Y]:= T; end;

procedure TCanvasOnChangeR(Self: TCanvas; var T: TNotifyEvent); begin T := Self.OnChange; end;
procedure TCanvasOnChangeW(Self: TCanvas; T: TNotifyEvent); begin Self.OnChange:= T; end;

procedure TCanvasOnChangingR(Self: TCanvas; var T: TNotifyEvent); begin T := Self.OnChanging; end;
procedure TCanvasOnChangingW(Self: TCanvas; T: TNotifyEvent); begin Self.OnChanging:= T; end;


procedure TCanvasClipRectR(Self: TCanvas; var T: TRect); begin T := Self.ClipRect; end;


{$IFDEF FPC}
procedure TCanvasArc(Self : TCanvas; X1, Y1, X2, Y2, X3, Y3, X4, Y4: Integer); begin Self.Arc(X1, Y1, X2, Y2, X3, Y3, X4, Y4); end;
procedure TCanvasChord(Self : TCanvas; X1, Y1, X2, Y2, X3, Y3, X4, Y4: Integer); begin self.Chord(X1, Y1, X2, Y2, X3, Y3, X4, Y4); end;
procedure TCanvasRectangle(Self : TCanvas; X1,Y1,X2,Y2 : integer); begin self.Rectangle(x1,y1,x2,y2); end;
procedure TCanvasRoundRect(Self : TCanvas; X1, Y1, X2, Y2, X3, Y3 : integer); begin self.RoundRect(X1, Y1, X2, Y2, X3, Y3); end;
procedure TCanvasEllipse(Self : TCanvas;X1, Y1, X2, Y2: Integer); begin self.Ellipse(X1, Y1, X2, Y2); end;
procedure TCanvasFillRect(Self : TCanvas; const Rect: TRect); begin self.FillRect(rect); end;
procedure TCanvasFloodFill(Self : TCanvas; X, Y: Integer; Color: TColor; FillStyle: TFillStyle); begin self.FloodFill(x,y,color,fillstyle); end;
{$ENDIF}

Procedure TCanvasEllipse1_P(Self: TCanvas;  const Rect : TRect);
Begin Self.Ellipse(Rect); END;

Procedure TCanvasRectangle1_P(Self: TCanvas;  const Rect : TRect);
Begin Self.Rectangle(Rect); END;

(*----------------------------------------------------------------------------*)
procedure TCanvasPenPos_W(Self: TCanvas; const T: TPoint);
begin Self.PenPos := T; end;

(*----------------------------------------------------------------------------*)
procedure TCanvasPenPos_R(Self: TCanvas; var T: TPoint);
begin T := Self.PenPos; end;

(*----------------------------------------------------------------------------*)
procedure TCanvasCanvasOrientation_R(Self: TCanvas; var T: TCanvasOrientation);
begin T := Self.CanvasOrientation; end;

(*----------------------------------------------------------------------------*)
procedure TCanvasLockCount_R(Self: TCanvas; var T: Integer);
begin T := Self.LockCount; end;

(*----------------------------------------------------------------------------*)
procedure TCanvasTextFlags_W(Self: TCanvas; const T: Longint);
begin Self.TextFlags := T; end;

(*----------------------------------------------------------------------------*)
procedure TCanvasTextFlags_R(Self: TCanvas; var T: Longint);
begin T := Self.TextFlags; end;

(*----------------------------------------------------------------------------*)
procedure TCanvasPen_W(Self: TCanvas; const T: TPen);
begin Self.Pen := T; end;

(*----------------------------------------------------------------------------*)
procedure TCanvasPen_R(Self: TCanvas; var T: TPen);
begin T := Self.Pen; end;

(*----------------------------------------------------------------------------*)
procedure TCanvasFont_W(Self: TCanvas; const T: TFont);
begin Self.Font := T; end;

(*----------------------------------------------------------------------------*)
procedure TCanvasFont_R(Self: TCanvas; var T: TFont);
begin T := Self.Font; end;

(*----------------------------------------------------------------------------*)
procedure TCanvasCopyMode_W(Self: TCanvas; const T: TCopyMode);
begin Self.CopyMode := T; end;

(*----------------------------------------------------------------------------*)
procedure TCanvasCopyMode_R(Self: TCanvas; var T: TCopyMode);
begin T := Self.CopyMode; end;

(*----------------------------------------------------------------------------*)
procedure TCanvasBrush_W(Self: TCanvas; const T: TBrush);
begin Self.Brush := T; end;

(*----------------------------------------------------------------------------*)
procedure TCanvasBrush_R(Self: TCanvas; var T: TBrush);
begin T := Self.Brush; end;

Procedure TCanvasTextRect1_P(Self: TCanvas;  var Rect : TRect; var Text : string; TextFormat : TTextFormat);
Begin Self.TextRect(Rect, Text, TextFormat); END;




procedure RIRegisterTCanvas(cl: TPSRuntimeClassImporter); // requires TPersistent
begin
  with Cl.Add(TCanvas) do begin
{$IFNDEF FPC}
    RegisterConstructor(@TCanvas.Create, 'CREATE');
    RegisterMethod(@TCanvas.Destroy, 'Free');
    RegisterMethod(@TCanvas.Arc, 'ARC');
    RegisterMethod(@TCanvas.Chord, 'CHORD');
    RegisterMethod(@TCanvas.Rectangle, 'RECTANGLE');
    RegisterMethod(@TCanvas.RoundRect, 'ROUNDRECT');
    RegisterMethod(@TCanvas.Ellipse, 'ELLIPSE');
    RegisterMethod(@TCanvas.FillRect, 'FILLRECT');
    RegisterMethod(@TCanvas.Draw, 'DRAW');
    RegisterMethod(@TCanvas.DrawFocusRect, 'DRAWFOCUSRECT');
    RegisterMethod(@TCanvas.FrameRect, 'FRAMERECT');
    RegisterMethod(@TCanvas.CopyRect, 'COPYRECT');
    RegisterMethod(@TCanvas.StretchDraw, 'STRETCHDRAW');
    RegisterMethod(@TCanvas.Polyline, 'POLYLINE');
    RegisterMethod(@TCanvas.Polygon, 'POLYGON');
    RegisterMethod(@TCanvas.PolyBezier, 'POLYBEZIER');
    RegisterMethod(@TCanvas.PolyBezierTo, 'POLYBEZIERTO');

    RegisterMethod(@TCanvas.Pie, 'PIE');
    RegisterMethod(@TCanvas.Refresh, 'REFRESH');
    RegisterMethod(@TCanvas.TextRect, 'TEXTRECT');
    //3.6
    RegisterMethod(@TCanvas.BrushCopy, 'BrushCopy');
      RegisterMethod(@TCanvasEllipse1_P, 'Ellipse1');
    RegisterMethod(@TCanvas.FloodFill, 'FloodFill');
    RegisterMethod(@TCanvas.HandleAllocated, 'HandleAllocated');
    RegisterMethod(@TCanvas.Lock, 'Lock');
    RegisterMethod(@TCanvas.PolyBezierTo, 'PolyBezierTo');
    RegisterMethod(@TCanvasRectangle1_P, 'Rectangle1');
    RegisterMethod(@TCanvas.TextExtent, 'TextExtent');
    RegisterMethod(@TCanvasTextRect1_P, 'TextRect1');
    RegisterMethod(@TCanvas.TryLock, 'TryLock');
    RegisterMethod(@TCanvas.Unlock, 'Unlock');
    RegisterPropertyHelper(@TCanvasLockCount_R,nil,'LockCount');
    RegisterPropertyHelper(@TCanvasCanvasOrientation_R,nil,'CanvasOrientation');
    RegisterPropertyHelper(@TCanvasPenPos_R,@TCanvasPenPos_W,'PenPos');
    RegisterPropertyHelper(@TCanvasCopyMode_R,@TCanvasCopyMode_W,'CopyMode');
    RegisterPropertyHelper(@TCanvasTextFlags_R,@TCanvasTextFlags_W,'TextFlags');
   RegisterPropertyHelper(@TCanvasFont_R,@TCanvasFont_W,'Font');
    RegisterPropertyHelper(@TCanvasPen_R,@TCanvasPen_W,'Pen');
    RegisterPropertyHelper(@TCanvasBrush_R,@TCanvasBrush_W,'Brush');

{$ENDIF}
   RegisterMethod(@TCanvas{$IFNDEF FPC}.{$ENDIF}Arc, 'ARC');
   RegisterMethod(@TCanvas{$IFNDEF FPC}.{$ENDIF}Chord, 'CHORD');
   RegisterMethod(@TCanvas{$IFNDEF FPC}.{$ENDIF}Rectangle, 'RECTANGLE');
   RegisterMethod(@TCanvas{$IFNDEF FPC}.{$ENDIF}RoundRect, 'ROUNDRECT');
   RegisterMethod(@TCanvas{$IFNDEF FPC}.{$ENDIF}Ellipse, 'ELLIPSE');
   RegisterMethod(@TCanvas{$IFNDEF FPC}.{$ENDIF}FillRect, 'FILLRECT');
   RegisterMethod(@TCanvas{$IFNDEF FPC}.{$ENDIF}Draw, 'DRAW');
{$IFNDEF CLX}
    RegisterMethod(@TCanvas.FloodFill, 'FLOODFILL');
    RegisterMethod(@TCanvas{$IFNDEF FPC}.{$ENDIF}FloodFill, 'FLOODFILL');
{$ENDIF}
    RegisterMethod(@TCanvas.Draw, 'DRAW');
    RegisterMethod(@TCanvas.Lineto, 'LINETO');
    RegisterMethod(@TCanvas.Moveto, 'MOVETO');
    RegisterMethod(@TCanvas.Pie, 'PIE');
    RegisterMethod(@TCanvas.Refresh, 'REFRESH');
    RegisterMethod(@TCanvas.TextHeight, 'TEXTHEIGHT');
    RegisterMethod(@TCanvas.TextOut, 'TEXTOUT');
    RegisterMethod(@TCanvas.TextWidth, 'TEXTWIDTH');
    RegisterMethod(@TCanvas.Polyline, 'POLYLINE');
    RegisterMethod(@TCanvas.Polygon, 'POLYGON');

{$IFNDEF CLX}
    RegisterPropertyHelper(@TCanvasHandleR, @TCanvasHandleW, 'HANDLE');
{$ENDIF}
    RegisterPropertyHelper(@TCanvasPixelsR, @TCanvasPixelsW, 'PIXELS');
    RegisterPropertyHelper(@TCanvasClipRectR, NIL, 'CLIPRECT');
    RegisterPropertyHelper(@TCanvasOnChangeR, @TCanvasOnChangeW, 'OnChange');
    RegisterPropertyHelper(@TCanvasOnChangingR, @TCanvasOnChangingW, 'OnChanging');

  end;
end;

procedure TGRAPHICSOBJECTONCHANGE_W(Self: TGraphicsObject; T: TNotifyEvent); begin Self.OnChange := t; end;
procedure TGRAPHICSOBJECTONCHANGE_R(Self: TGraphicsObject; var T: TNotifyEvent); begin T :=Self.OnChange; end;

procedure RIRegisterTGRAPHICSOBJECT(Cl: TPSRuntimeClassImporter);
begin
  with Cl.Add(TGRAPHICSOBJECT) do begin
    RegisterPropertyHelper(@TGRAPHICSOBJECTONCHANGE_R, @TGRAPHICSOBJECTONCHANGE_W, 'ONCHANGE');
    RegisterMethod(@TGRAPHICSOBJECT.HandleAllocated, 'HandleAllocated')
    //function HandleAllocated: Boolean;
  end;
end;

(*----------------------------------------------------------------------------*)
procedure TPenHandle_W(Self: TPen; const T: HPen);
begin Self.Handle := T; end;

(*----------------------------------------------------------------------------*)
procedure TPenHandle_R(Self: TPen; var T: HPen);
begin T := Self.Handle; end;



procedure RIRegisterTPEN(Cl: TPSRuntimeClassImporter);
begin
  with Cl.Add(TPEN) do begin
    RegisterConstructor(@TPEN.CREATE, 'CREATE');
    RegisterMethod(@TPen.Destroy, 'Free');
    RegisterMethod(@TPen.Assign, 'Assign');
    RegisterPropertyHelper(@TPenHandle_R,@TPenHandle_W,'Handle');
    {RegisterPropertyHelper(@TPenColor_R,@TPenColor_W,'Color');
    RegisterPropertyHelper(@TPenMode_R,@TPenMode_W,'Mode');
    RegisterPropertyHelper(@TPenStyle_R,@TPenStyle_W,'Style');
    RegisterPropertyHelper(@TPenWidth_R,@TPenWidth_W,'Width');}

  end;
end;

procedure TBrushBitmap_W(Self: TBrush; const T: TBitmap); begin Self.Bitmap:= T; end;
procedure TBrushBitmap_R(Self: TBrush; var T: TBitmap); begin T := Self.Bitmap; end;

(*----------------------------------------------------------------------------*)
procedure TBrushHandle_W(Self: TBrush; const T: HBrush);
begin Self.Handle := T; end;

(*----------------------------------------------------------------------------*)
procedure TBrushHandle_R(Self: TBrush; var T: HBrush);
begin T := Self.Handle; end;

procedure TBrushColor_R(Self: TBrush; const T: TColor); begin Self.Color:= T; end;
procedure TBrushColor_W(Self: TBrush; var T: TColor); begin T := Self.Color; end;

procedure TBrushStyle_R(Self: TBrush; const T: TBrushStyle); begin Self.Style:= T; end;
procedure TBrushStyle_W(Self: TBrush; var T: TBrushStyle); begin T := Self.Style; end;

procedure RIRegisterTBRUSH(Cl: TPSRuntimeClassImporter);
begin
  with Cl.Add(TBRUSH) do begin
    RegisterConstructor(@TBRUSH.CREATE, 'CREATE');
    RegisterMethod(@TBrush.Destroy, 'Free');
    RegisterMethod(@TBrush.Assign, 'Assign');
    RegisterPropertyHelper(@TBrushBitmap_R,@TBrushBitmap_W,'BITMAP');
    RegisterPropertyHelper(@TBrushHandle_R,@TBrushHandle_W,'Handle');
    //RegisterPropertyHelper(@TBrushColor_R,@TBrushColor_W,'Color');
    //RegisterPropertyHelper(@TBrushStyle_R,@TBrushStyle_W,'Style');

  end;
end;

procedure TGraphicOnChange_W(Self: TGraphic; const T: TNotifyEvent); begin Self.OnChange := T; end;
procedure TGraphicOnChange_R(Self: TGraphic; var T: TNotifyEvent); begin T := Self.OnChange; end;
procedure TGraphicOnProgress_W(Self: TGraphic; const T: TProgressEvent); begin Self.OnProgress := T; end;
procedure TGraphicOnProgress_R(Self: TGraphic; var T: TProgressEvent); begin T := Self.OnProgress; end;

procedure TGraphicWidth_W(Self: TGraphic; const T: Integer); begin Self.Width := T; end;
procedure TGraphicWidth_R(Self: TGraphic; var T: Integer); begin T := Self.Width; end;
procedure TGraphicModified_W(Self: TGraphic; const T: Boolean); begin Self.Modified := T; end;
procedure TGraphicModified_R(Self: TGraphic; var T: Boolean); begin T := Self.Modified; end;
procedure TGraphicHeight_W(Self: TGraphic; const T: Integer); begin Self.Height := T; end;
procedure TGraphicHeight_R(Self: TGraphic; var T: Integer); begin T := Self.Height; end;
procedure TGraphicEmpty_R(Self: TGraphic; var T: Boolean); begin T := Self.Empty; end;
(*----------------------------------------------------------------------------*)
procedure TGraphicTransparent_W(Self: TGraphic; const T: Boolean);
begin Self.Transparent := T; end;

(*----------------------------------------------------------------------------*)
procedure TGraphicTransparent_R(Self: TGraphic; var T: Boolean);
begin T := Self.Transparent; end;

(*----------------------------------------------------------------------------*)
procedure TGraphicPaletteModified_W(Self: TGraphic; const T: Boolean);
begin Self.PaletteModified := T; end;

(*----------------------------------------------------------------------------*)
procedure TGraphicPaletteModified_R(Self: TGraphic; var T: Boolean);
begin T := Self.PaletteModified; end;

(*----------------------------------------------------------------------------*)
procedure TGraphicPalette_W(Self: TGraphic; const T: HPALETTE);
begin Self.Palette := T; end;

(*----------------------------------------------------------------------------*)
procedure TGraphicPalette_R(Self: TGraphic; var T: HPALETTE);
begin T := Self.Palette; end;




procedure RIRegisterTGraphic(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TGraphic) do begin
    RegisterVirtualConstructor(@TGraphic.Create, 'Create');
    RegisterVirtualMethod(@TGraphic.LoadFromFile, 'LoadFromFile');
    RegisterVirtualMethod(@TGraphic.SaveToFile, 'SaveToFile');
    RegisterVirtualMethod(@TGraphic.SetSize, 'SetSize');
   { RegisterVirtualAbstractMethod(@TGraphic.LoadFromStream, 'LoadFromStream');
    RegisterVirtualAbstractMethod(@TGraphic.SaveToStream, 'SaveToStream');
    RegisterVirtualAbstractMethod(@TGraphic.LoadFromClipboardFormat, 'LoadFromClipboardFormat');
    RegisterVirtualAbstractMethod(@TGraphic.SaveToClipboardFormat, 'SaveToClipboardFormat');}

    RegisterPropertyHelper(@TGraphicEmpty_R,nil,'Empty');
    RegisterPropertyHelper(@TGraphicHeight_R,@TGraphicHeight_W,'Height');
    RegisterPropertyHelper(@TGraphicWidth_R,@TGraphicWidth_W,'Width');
    RegisterPropertyHelper(@TGraphicOnChange_R,@TGraphicOnChange_W,'OnChange');
    RegisterPropertyHelper(@TGraphicOnProgress_R,@TGraphicOnProgress_W,'OnProgress');

    RegisterPropertyHelper(@TGraphicPalette_R,@TGraphicPalette_W,'Palette');
    RegisterPropertyHelper(@TGraphicPaletteModified_R,@TGraphicPaletteModified_W,'PaletteModified');
    RegisterPropertyHelper(@TGraphicTransparent_R,@TGraphicTransparent_W,'Transparent');

    {$IFNDEF PS_MINIVCL}
    RegisterPropertyHelper(@TGraphicModified_R,@TGraphicModified_W,'Modified');
    {$ENDIF}
  end;
end;

procedure TBitmapTransparentColor_R(Self: TBitmap; var T: TColor); begin T := Self.TransparentColor; end;
procedure TBitmapTransparentColor_W(Self: TBitmap; const T:TColor); begin Self.TransparentColor:= T; end;

{$IFNDEF CLX}
{$IFNDEF FPC}
procedure TBitmapIgnorePalette_W(Self: TBitmap; const T: Boolean); begin Self.IgnorePalette := T; end;
procedure TBitmapIgnorePalette_R(Self: TBitmap; var T: Boolean); begin T := Self.IgnorePalette; end;
{$ENDIF}
procedure TBitmapPalette_W(Self: TBitmap; const T: HPALETTE); begin Self.Palette := T; end;
procedure TBitmapPalette_R(Self: TBitmap; var T: HPALETTE); begin T := Self.Palette; end;
{$ENDIF}
procedure TBitmapMonochrome_W(Self: TBitmap; const T: Boolean); begin Self.Monochrome := T; end;
procedure TBitmapMonochrome_R(Self: TBitmap; var T: Boolean); begin T := Self.Monochrome; end;
{$IFNDEF CLX}
procedure TBitmapHandle_W(Self: TBitmap; const T: HBITMAP); begin Self.Handle := T; end;
procedure TBitmapHandle_R(Self: TBitmap; var T: HBITMAP); begin T := Self.Handle; end;
{$ENDIF}
procedure TBitmapCanvas_R(Self: TBitmap; var T: TCanvas); begin T := Self.Canvas; end;

(*----------------------------------------------------------------------------*)
procedure TBitmapTransparentMode_W(Self: TBitmap; const T: TTransparentMode);
begin Self.TransparentMode := T; end;

(*----------------------------------------------------------------------------*)
procedure TBitmapTransparentMode_R(Self: TBitmap; var T: TTransparentMode);
begin T := Self.TransparentMode; end;

(*----------------------------------------------------------------------------*)
procedure TBitmapMaskHandle_W(Self: TBitmap; const T: HBITMAP);
begin Self.MaskHandle := T; end;

(*----------------------------------------------------------------------------*)
procedure TBitmapMaskHandle_R(Self: TBitmap; var T: HBITMAP);
begin T := Self.MaskHandle; end;

(*----------------------------------------------------------------------------*)
procedure TBitmapHandleType_R(Self: TBitmap; var T: TBitmapHandleType);
begin T := Self.HandleType; end;

(*----------------------------------------------------------------------------*)
procedure TBitmapHandleType_W(Self: TBitmap; const T: TBitmapHandleType);
begin Self.HandleType := T; end;


procedure TBitmapPixelF_R(Self: TBitmap; var T: TPixelFormat);
begin T := Self.PixelFormat; end;

(*----------------------------------------------------------------------------*)
procedure TBitmapPixelF_W(Self: TBitmap; const T: TPixelFormat);
begin Self.PixelFormat:= T; end;


procedure RIRegisterTBitmap(CL: TPSRuntimeClassImporter; Streams: Boolean);
begin
  with CL.Add(TBitmap) do begin
    RegisterConstructor(@TBitmap.Create, 'Create');
    //RegisterMethod(@TBitmap.Clear, 'Clear');
    RegisterMethod(@TBitmap.Destroy, 'Free');
    RegisterMethod(@TBitmap.Assign, 'Assign');
    RegisterMethod(@TBitmap.SetSize, 'SetSize');
    if Streams then begin
      RegisterMethod(@TBitmap.LoadFromStream, 'LoadFromStream');
      RegisterMethod(@TBitmap.SaveToStream, 'SaveToStream');
    end;
    RegisterMethod(@TBitmap.FreeImage, 'FreeImage');
    RegisterMethod(@TBitmap.ReleaseMaskHandle, 'ReleaseMaskHandle');

    RegisterPropertyHelper(@TBitmapCanvas_R,nil,'Canvas');
{$IFNDEF CLX}
    RegisterPropertyHelper(@TBitmapHandle_R,@TBitmapHandle_W,'Handle');
{$ENDIF}

    {$IFNDEF PS_MINIVCL}
{$IFNDEF FPC}
    RegisterMethod(@TBitmap.Dormant, 'Dormant');
{$ENDIF}
    RegisterMethod(@TBitmap.FreeImage, 'FreeImage');
    RegisterMethod(@TBitmap.Mask, 'Mask');
  
{$IFNDEF CLX}
    RegisterMethod(@TBitmap.LoadFromClipboardFormat, 'LoadFromClipboardFormat');
{$ENDIF}
    RegisterMethod(@TBitmap.LoadFromResourceName, 'LoadFromResourceName');
    RegisterMethod(@TBitmap.LoadFromResourceName, 'LoadFromRes');
    RegisterMethod(@TBitmap.LoadFromResourceID, 'LoadFromResourceID');
{$IFNDEF CLX}
    RegisterMethod(@TBitmap.ReleaseHandle, 'ReleaseHandle');
    RegisterMethod(@TBitmap.ReleasePalette, 'ReleasePalette');
    RegisterMethod(@TBitmap.SaveToClipboardFormat, 'SaveToClipboardFormat');
    RegisterPropertyHelper(@TBitmapMonochrome_R,@TBitmapMonochrome_W,'Monochrome');
    RegisterPropertyHelper(@TBitmapPalette_R,@TBitmapPalette_W,'Palette');
{$IFNDEF FPC}
    RegisterPropertyHelper(@TBitmapIgnorePalette_R,@TBitmapIgnorePalette_W,'IgnorePalette');
{$ENDIF}
{$ENDIF}
    RegisterPropertyHelper(@TBitmapTransparentColor_R,@TBitmapTransparentColor_W,'TransparentColor');
    RegisterPropertyHelper(@TBitmapTransparentMode_R,@TBitmapTransparentMode_W,'TransparentMode');
    RegisterPropertyHelper(@TBitmapMaskHandle_R,@TBitmapMaskHandle_W,'MaskHandle');
    RegisterPropertyHelper(@TBitmapHandleType_R,@TBitmapHandleType_W,'HandleType');
    RegisterPropertyHelper(@TBitmapPixelF_R,@TBitmapPixelF_W,'pixelFormat');

    {$ENDIF}
  end;
end;

procedure TPictureBitmap_W(Self: TPicture; const T: TBitmap); begin Self.Bitmap := T; end;
procedure TPictureBitmap_R(Self: TPicture; var T: TBitmap); begin T := Self.Bitmap; end;
procedure TPictureGraphic_W(Self: TPicture; const T: TGraphic); begin Self.Graphic:= T; end;
procedure TPictureGraphic_R(Self: TPicture; var T: TGraphic); begin T := Self.Graphic; end;
procedure TPictureIcon_W(Self: TPicture; const T: TIcon); begin Self.Icon:= T; end;
procedure TPictureIcon_R(Self: TPicture; var T: TIcon); begin T := Self.Icon; end;

procedure TPictureMetafile_W(Self: TPicture; const T: TMetafile); begin Self.Metafile:= T; end;
procedure TPictureMetafile_R(Self: TPicture; var T: TMetafile); begin T:= Self.Metafile; end;
procedure TPictureHeight_R(Self: TPicture; var T: Integer); begin T:= Self.Height; end;
procedure TPictureWidth_R(Self: TPicture; var T: Integer); begin T:= Self.Width; end;

procedure TPictureOnChange_W(Self: TPicture; const T: TNotifyEvent); begin Self.OnChange := T; end;
procedure TPictureOnChange_R(Self: TPicture; var T: TNotifyEvent); begin T := Self.OnChange; end;
procedure TPictureOnProgress_W(Self: TPicture; const T: TProgressEvent); begin Self.onProgress:= T; end;
procedure TPictureOnProgress_R(Self: TPicture; var T: TProgressEvent); begin T := Self.OnProgress; end;


procedure RIRegisterTPicture(CL: TPSRuntimeClassImporter);
begin
 with CL.Add(TPicture) do begin
    RegisterConstructor(@TPicture.Create, 'CREATE');
    RegisterMethod(@TPicture.Destroy, 'Free');
    RegisterMethod(@TPicture.Assign, 'Assign');
    RegisterPropertyHelper(@TPictureBitmap_R,@TPictureBitmap_W,'Bitmap');
    RegisterPropertyHelper(@TPictureGraphic_R,@TPictureGraphic_W,'Graphic');
    RegisterPropertyHelper(@TPictureIcon_R,@TPictureIcon_W,'Icon');
    RegisterPropertyHelper(@TPictureHeight_R,NIL, 'Height');
    RegisterPropertyHelper(@TPictureWidth_R,NIL,'Width');
      RegisterPropertyHelper(@TPictureOnChange_R,@TPictureOnChange_W,'OnChange');
      RegisterPropertyHelper(@TPictureOnProgress_R,@TPictureOnProgress_W,'OnProgress');


    RegisterPropertyHelper(@TPictureMetafile_R,@TPictureMetafile_W,'Metafile');
    RegisterMethod(@TPicture.LoadFromFile, 'LoadFromFile');
    RegisterMethod(@TPicture.SaveToFile, 'SaveToFile');
    RegisterMethod(@TPicture.LoadFromClipboardFormat, 'LoadFromClipboardFormat');
    RegisterMethod(@TPicture.SaveToClipboardFormat, 'SaveToClipboardFormat');
    RegisterMethod(@TPicture.SupportsClipboardFormat, 'SupportsClipboardFormat');
    RegisterMethod(@TPicture.RegisterFileFormat, 'RegisterFileFormat');

 end;

 end;


(*----------------------------------------------------------------------------*)
procedure TMetafileInch_W(Self: TMetafile; const T: Word);
begin Self.Inch := T; end;

(*----------------------------------------------------------------------------*)
procedure TMetafileInch_R(Self: TMetafile; var T: Word);
begin T := Self.Inch; end;

(*----------------------------------------------------------------------------*)
procedure TMetafileMMHeight_W(Self: TMetafile; const T: Integer);
begin Self.MMHeight := T; end;

(*----------------------------------------------------------------------------*)
procedure TMetafileMMHeight_R(Self: TMetafile; var T: Integer);
begin T := Self.MMHeight; end;

(*----------------------------------------------------------------------------*)
procedure TMetafileMMWidth_W(Self: TMetafile; const T: Integer);
begin Self.MMWidth := T; end;

(*----------------------------------------------------------------------------*)
procedure TMetafileMMWidth_R(Self: TMetafile; var T: Integer);
begin T := Self.MMWidth; end;

(*----------------------------------------------------------------------------*)
procedure TMetafileHandle_W(Self: TMetafile; const T: HENHMETAFILE);
begin Self.Handle := T; end;

(*----------------------------------------------------------------------------*)
procedure TMetafileHandle_R(Self: TMetafile; var T: HENHMETAFILE);
begin T := Self.Handle; end;

(*----------------------------------------------------------------------------*)
procedure TMetafileEnhanced_W(Self: TMetafile; const T: Boolean);
begin Self.Enhanced := T; end;

(*----------------------------------------------------------------------------*)
procedure TMetafileEnhanced_R(Self: TMetafile; var T: Boolean);
begin T := Self.Enhanced; end;

(*----------------------------------------------------------------------------*)
procedure TMetafileDescription_R(Self: TMetafile; var T: String);
begin T := Self.Description; end;

(*----------------------------------------------------------------------------*)
procedure TMetafileCreatedBy_R(Self: TMetafile; var T: String);
begin T := Self.CreatedBy; end;




(*----------------------------------------------------------------------------*)
procedure RIRegister_TMetafile(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TMetafile) do begin
    RegisterConstructor(@TMetafile.Create, 'Create');
    RegisterMethod(@TMetafile.Clear, 'Clear');
    RegisterMethod(@TPicture.Destroy, 'Free');
    RegisterMethod(@TPicture.Assign, 'Assign');
    //RegisterPropertyHelper(@TMetafileBitmap_R,@TMetafileBitmap_W,'Bitmap');
    //RegisterPropertyHelper(@TMetafileGraphic_R,@TMetafileGraphic_W,'Graphic');
    //RegisterPropertyHelper(@TMetafileIcon_R,@TMetafileIcon_W,'Icon');
    //RegisterPropertyHelper(@TPictureHeight_R,NIL, 'Height');
    //RegisterPropertyHelper(@TPictureWidth_R,NIL,'Width');
    //RegisterPropertyHelper(@TPictureMetafile_R,@TPictureMetafile_W,'Metafile');
    RegisterMethod(@TMetafile.LoadFromFile, 'LoadFromFile');
    RegisterMethod(@TMetafile.SaveToFile, 'SaveToFile');
    RegisterMethod(@TMetafile.LoadFromStream, 'LoadFromStream');
    RegisterMethod(@TMetafile.SaveToStream, 'SaveToStream');

    RegisterMethod(@TMetafile.LoadFromClipboardFormat, 'LoadFromClipboardFormat');
    RegisterMethod(@TMetafile.SaveToClipboardFormat, 'SaveToClipboardFormat');
    RegisterMethod(@TMetafile.SetSize, 'SetSize');
    RegisterMethod(@TMetafile.HandleAllocated, 'HandleAllocated');
    RegisterMethod(@TMetafile.ReleaseHandle, 'ReleaseHandle');
    RegisterPropertyHelper(@TMetafileCreatedBy_R,nil,'CreatedBy');
    RegisterPropertyHelper(@TMetafileDescription_R,nil,'Description');
    RegisterPropertyHelper(@TMetafileEnhanced_R,@TMetafileEnhanced_W,'Enhanced');
    RegisterPropertyHelper(@TMetafileHandle_R,@TMetafileHandle_W,'Handle');
    RegisterPropertyHelper(@TMetafileMMWidth_R,@TMetafileMMWidth_W,'MMWidth');
    RegisterPropertyHelper(@TMetafileMMHeight_R,@TMetafileMMHeight_W,'MMHeight');
    RegisterPropertyHelper(@TMetafileInch_R,@TMetafileInch_W,'Inch');
  end;
end;


procedure TIconHandle_W(Self: TIcon; const T: HICON);
begin Self.Handle := T; end;

(*----------------------------------------------------------------------------*)
procedure TIconHandle_R(Self: TIcon; var T: HICON);
begin T := Self.Handle; end;

(*----------------------------------------------------------------------------*)

procedure RIRegister_TIcon(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TIcon) do begin
    RegisterConstructor(@TIcon.Create, 'Create');
    RegisterMethod(@TIcon.Destroy, 'Free');
    RegisterMethod(@TIcon.Assign, 'Assign');
    RegisterMethod(@TIcon.SetSize, 'SetSize');
    RegisterMethod(@TIcon.LoadFromStream, 'LoadFromStream');
    RegisterMethod(@TIcon.SaveToStream, 'SaveToStream');
    RegisterMethod(@TIcon.LoadFromClipboardFormat, 'LoadFromClipboardFormat');
    RegisterMethod(@TIcon.SaveToClipboardFormat, 'SaveToClipboardFormat');
    RegisterMethod(@TIcon.HandleAllocated, 'HandleAllocated');
    RegisterMethod(@TIcon.LoadFromResourceName, 'LoadFromResourceName');
    RegisterMethod(@TIcon.LoadFromResourceID, 'LoadFromResourceID');
    RegisterMethod(@TIcon.ReleaseHandle, 'ReleaseHandle');
    RegisterPropertyHelper(@TIconHandle_R,@TIconHandle_W,'Handle');
  end;
end;


procedure RIRegister_Graphics_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@GetDIBSizes, 'GetDIBSizes', cdRegister);
 S.RegisterDelphiFunction(@CopyPalette, 'CopyPalette', cdRegister);
 S.RegisterDelphiFunction(@PaletteChanged, 'PaletteChanged', cdRegister);
 S.RegisterDelphiFunction(@FreeMemoryContexts, 'FreeMemoryContexts', cdRegister);
 S.RegisterDelphiFunction(@GetDefFontCharSet, 'GetDefFontCharSet', cdRegister);
 S.RegisterDelphiFunction(@TransparentStretchBlt, 'TransparentStretchBlt', cdRegister);
 S.RegisterDelphiFunction(@CreateMappedBmp, 'CreateMappedBmp', cdRegister);
 S.RegisterDelphiFunction(@CreateMappedRes, 'CreateMappedRes', cdRegister);
 S.RegisterDelphiFunction(@CreateGrayMappedBmp, 'CreateGrayMappedBmp', cdRegister);
 S.RegisterDelphiFunction(@CreateGrayMappedRes, 'CreateGrayMappedRes', cdRegister);
 S.RegisterDelphiFunction(@AllocPatternBitmap, 'AllocPatternBitmap', cdRegister);
 S.RegisterDelphiFunction(@BytesPerScanline, 'BytesPerScanline', cdRegister);
 //S.RegisterDelphiFunction(@GetWindowRect,'GetWindowRect', cdRegister); //Win

end;



procedure RIRegister_Graphics(Cl: TPSRuntimeClassImporter; Streams: Boolean);
begin
  with CL.Add(EInvalidGraphic) do
  with CL.Add(EInvalidGraphicOperation) do
  with CL.Add(TGraphic) do        //Test engine 3.6
  with CL.Add(TBitmap) do
  with CL.Add(TIcon) do
  with CL.Add(TMetafile) do


  RIRegisterTGRAPHICSOBJECT(cl);
  RIRegisterTGraphic(CL);
  RIRegisterTFont(Cl);
  RIRegisterTCanvas(cl);
  RIRegisterTPEN(cl);
  RIRegisterTBRUSH(cl);
  //RIRegisterTGraphic(CL);
  RIRegister_TMetafile(CL);
  RIRegister_TIcon(CL);
  RIRegisterTBitmap(CL, Streams);
  RIRegisterTPicture(CL);

end;

// PS_MINIVCL changes by Martijn Laan (mlaan at wintax _dot_ nl)

end.





