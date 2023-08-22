unit uPSI_cyGraphics;
{
  last in the past
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
  TPSImport_cyGraphics = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_cyGraphics(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_cyGraphics_Routines(S: TPSExec);

procedure Register;

implementation


uses
   Windows
  ,Forms
  ,Graphics
  ,Math
  ,Buttons
  ,Controls
  ,ExtCtrls
  ,Jpeg
  //,pngimage
  ,StdCtrls
  ,cyTypes
  ,cyGraphics
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_cyGraphics]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_cyGraphics(CL: TPSPascalCompiler);
begin
 CL.AddDelphiFunction('Procedure cyGradientFill( aCanvas : TCanvas; aRect : TRect; fromColor, toColor : TColor; adgradOrientation : TdgradOrientation; Balance, AngleDegree : Word; balanceMode : TDgradBalanceMode; Maxdegrade : Byte;'+
 ' SpeedPercent : Integer; const AngleClipRect : Boolean; const AngleBuffer : TBitmap)');
 CL.AddDelphiFunction('Procedure cyGradientFillVertical( aCanvas : TCanvas; aRect : TRect; fromColor, toColor : TColor; MaxDegrad : byte)');
 CL.AddDelphiFunction('Procedure cyGradientFillHorizontal( aCanvas : TCanvas; aRect : TRect; fromColor, toColor : TColor; MaxDegrad : byte)');
 CL.AddDelphiFunction('Procedure cyGradientFillShape( aCanvas : TCanvas; aRect : TRect; fromColor, toColor : TColor; MaxDegrad : Byte; toRect : TRect; OrientationShape : TDgradOrientationShape)');
 CL.AddDelphiFunction('Procedure cyGradientFillAngle( aCanvas : TCanvas; aRect : TRect; fromColor, toColor : TColor; MaxDegrad : Byte; AngleDegree : Word; const ClipRect : Boolean; const Buffer : TBitmap)');
 CL.AddDelphiFunction('Procedure DrawRectangleInside( aCanvas : TCanvas; InsideRect : TRect; FrameWidth : Integer)');
 CL.AddDelphiFunction('Procedure cyFrame( aCanvas : TCanvas; var InsideRect : TRect; Color : TColor; const Width : Integer);');
 CL.AddDelphiFunction('Procedure cyFrame1( Canvas : TCanvas; var InsideRect : TRect; LeftColor, TopColor, RightColor, BottomColor : TColor; const Width : Integer; const RoundRect : boolean);');
 CL.AddDelphiFunction('Procedure cyFrame3D( Canvas : TCanvas; var Rect : TRect; TopLeftColor, BottomRightColor : TColor; Width : Integer; const DrawLeft : Boolean; const DrawTop : Boolean; const DrawRight : Boolean; const DrawBottom : Boolean; const RoundRect : boolean)');
 CL.AddDelphiFunction('Procedure cyDrawButtonFace( Canvas : TCanvas; var Rect : TRect; GradientColor1, GradientColor2 : TColor; aState : TButtonState; Focused, Hot : Boolean)');
 CL.AddDelphiFunction('Procedure cyDrawButton( Canvas : TCanvas; Caption : String; ARect : TRect; GradientColor1, GradientColor2 : TColor; aState : TButtonState; Focused, Hot : Boolean)');
 CL.AddDelphiFunction('Procedure cyDrawSpeedButtonFace( Canvas : TCanvas; var Rect : TRect; GradientColor1, GradientColor2 : TColor; aState : TButtonState; Focused, Hot : Boolean)');
 CL.AddDelphiFunction('Procedure cyDrawSpeedButton( Canvas : TCanvas; Caption : String; ARect : TRect; GradientColor1, GradientColor2 : TColor; aState : TButtonState; Focused, Hot : Boolean)');
 CL.AddDelphiFunction('Procedure cyDrawCheckBox( Canvas : TCanvas; IsChecked : Boolean; ARect : TRect; const BgColor : TColor; const DarkFrameColor : TColor; const LightFrameColor : TColor; const MarkColor : TColor)');
 CL.AddDelphiFunction('Procedure cyDrawSingleLineText( Canvas : TCanvas; Text : String; ARect : TRect; Alignment : TAlignment; TextLayout : TTextLayout; const IndentX : Integer; const IndentY : Integer)');
 CL.AddDelphiFunction('Function DrawTextFormatFlags( aTextFormat : LongInt; Alignment : TAlignment; Layout : TTextLayout; WordWrap : Boolean) : LongInt;');
 CL.AddDelphiFunction('Function DrawTextFormatFlags1( aTextFormat : LongInt; Alignment : TAlignment; Layout : TTextLayout; WordWrap : Boolean; CaptionRender : TCaptionRender) : LongInt;');
 CL.AddDelphiFunction('Procedure cyDrawText( CanvasHandle : Cardinal; Text : String; var Rect : TRect; TextFormat : LongInt)');
 CL.AddDelphiFunction('Function cyCreateFontIndirect( fromFont : TFont; Angle : Double) : TFont;');
 CL.AddDelphiFunction('Function cyCreateFontIndirect1( fromFont : TFont; CaptionOrientation : TCaptionOrientation) : TFont;');
 CL.AddDelphiFunction('Procedure cyDrawVerticalText( Canvas : TCanvas; Text : String; var Rect : TRect; TextFormat : Longint; CaptionOrientation : TCaptionOrientation; Alignment : TAlignment; Layout : TTextLayout)');
 CL.AddDelphiFunction('Function DrawLeftTurnPageEffect( Canvas : TCanvas; PageColor : TColor; PageRect : TRect; PercentDone : Integer; const OnlyCalcFoldLine : Boolean) : TLineCoord');
 CL.AddDelphiFunction('Function DrawRightTurnPageEffect( Canvas : TCanvas; PageColor : TColor; PageRect : TRect; PercentDone : Integer; const OnlyCalcFoldLine : Boolean) : TLineCoord');
 CL.AddDelphiFunction('Function PictureIsTransparentAtPos( aPicture : TPicture; aPoint : TPoint) : boolean');
 CL.AddDelphiFunction('Function IconIsTransparentAtPos( aIcon : TIcon; aPoint : TPoint) : boolean');
 CL.AddDelphiFunction('Function MetafileIsTransparentAtPos( aMetafile : TMetafile; aPoint : TPoint) : boolean');
 //CL.AddDelphiFunction('Function PngImageIsTransparentAtPos( aPngImage : TPngImage; aPoint : TPoint) : boolean');
 CL.AddDelphiFunction('Procedure DrawCanvas( Destination : TCanvas; DestRect : TRect; Source : TCanvas; SourceRect : TRect);');
 CL.AddDelphiFunction('Procedure DrawCanvas1( Destination : TCanvas; DestRect : TRect; Src : TCanvas; SrcRect : TRect; TransparentColor : TColor; const aStyle : TBgStyle; const aPosition : TBgPosition; const IndentX : Integer; const IndentY : Integer;'+
 ' const IntervalX : Integer; const IntervalY : Integer; const RepeatX : Integer; const RepeatY : Integer);');
 CL.AddDelphiFunction('Procedure DrawGraphic( Destination : TCanvas; DestRect : TRect; aGraphic : TGraphic; SrcRect : TRect; TransparentColor : TColor; const aStyle : TBgStyle; const aPosition : TBgPosition; const IndentX : Integer; const IndentY : '+
 'Integer; const IntervalX : Integer; const IntervalY : Integer; const RepeatX : Integer; const RepeatY : Integer);');
 CL.AddDelphiFunction('Procedure DrawGraphic1( Destination : TCanvas; DestRect : TRect; aGraphic : TGraphic; Transparent : Boolean; const aStyle : TBgStyle; const aPosition : TBgPosition; const IndentX : Integer; const IndentY : Integer; const '+
 'IntervalX : Integer; const IntervalY : Integer; const RepeatX : Integer; const RepeatY : Integer);');
 CL.AddDelphiFunction('Procedure DrawMosaicPortion( Destination : TCanvas; Portion : TRect; Pattern : TBitmap)');
 CL.AddDelphiFunction('Function ValidGraphic( aGraphic : TGraphic) : Boolean');
 CL.AddDelphiFunction('Function ColorSetPercentBrightness( Color : TColor; PercentLight : Integer) : TColor');
 CL.AddDelphiFunction('Function ColorModify( Color : TColor; incR, incG, incB : Integer) : TColor');
 CL.AddDelphiFunction('Function ColorSetPercentContrast( Color : TColor; IncPercent : Integer) : TColor');
 CL.AddDelphiFunction('Function ColorSetPercentPale( Color : TColor; IncPercent : integer) : TColor');
 CL.AddDelphiFunction('Function MediumColor( Color1, Color2 : TColor) : TColor');
 CL.AddDelphiFunction('Function ClientToScreenRect( aControl : TControl; aControlRect : TRect) : TRect');
 CL.AddDelphiFunction('Function ScreenToClientRect( aControl : TControl; aScreenRect : TRect) : TRect');
 CL.AddDelphiFunction('Function CombineRectKeepingCenterPosition( RectPos, AddRect : TRect) : TRect');
 CL.AddDelphiFunction('Procedure InflateRectPercent( var aRect : TRect; withPercent : Double)');
 CL.AddDelphiFunction('Function GetIntermediateRect( Rect1, Rect2 : TRect; Percent : Double) : TRect');
 CL.AddDelphiFunction('Function GetProportionalRect( fromRect, InsideRect : TRect) : TRect');
 CL.AddDelphiFunction('Function cyPointInRect( const aPt : TPoint; const aRect : TRect) : boolean');
 CL.AddDelphiFunction('Function PointInEllispe( const aPt : TPoint; const aRect : TRect) : boolean');
 CL.AddDelphiFunction('Function CanvasAcceleratorTextWidth( aCanvas : TCanvas; aText : String) : Integer');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
Procedure DrawGraphic1_P( Destination : TCanvas; DestRect : TRect; aGraphic : TGraphic; Transparent : Boolean; const aStyle : TBgStyle; const aPosition : TBgPosition; const IndentX : Integer; const IndentY : Integer; const IntervalX : Integer; const IntervalY : Integer; const RepeatX : Integer; const RepeatY : Integer);
Begin cyGraphics.DrawGraphic(Destination, DestRect, aGraphic, Transparent, aStyle, aPosition, IndentX, IndentY, IntervalX, IntervalY, RepeatX, RepeatY); END;

(*----------------------------------------------------------------------------*)
Procedure DrawGraphic_P( Destination : TCanvas; DestRect : TRect; aGraphic : TGraphic; SrcRect : TRect; TransparentColor : TColor; const aStyle : TBgStyle; const aPosition : TBgPosition; const IndentX : Integer; const IndentY : Integer; const IntervalX : Integer; const IntervalY : Integer; const RepeatX : Integer; const RepeatY : Integer);
Begin cyGraphics.DrawGraphic(Destination, DestRect, aGraphic, SrcRect, TransparentColor, aStyle, aPosition, IndentX, IndentY, IntervalX, IntervalY, RepeatX, RepeatY); END;

(*----------------------------------------------------------------------------*)
Procedure DrawCanvas1_P( Destination : TCanvas; DestRect : TRect; Src : TCanvas; SrcRect : TRect; TransparentColor : TColor; const aStyle : TBgStyle; const aPosition : TBgPosition; const IndentX : Integer; const IndentY : Integer; const IntervalX : Integer; const IntervalY : Integer; const RepeatX : Integer; const RepeatY : Integer);
Begin cyGraphics.DrawCanvas(Destination, DestRect, Src, SrcRect, TransparentColor, aStyle, aPosition, IndentX, IndentY, IntervalX, IntervalY, RepeatX, RepeatY); END;

(*----------------------------------------------------------------------------*)
Procedure DrawCanvas_P( Destination : TCanvas; DestRect : TRect; Source : TCanvas; SourceRect : TRect);
Begin cyGraphics.DrawCanvas(Destination, DestRect, Source, SourceRect); END;

(*----------------------------------------------------------------------------*)
Function cyCreateFontIndirect1_P( fromFont : TFont; CaptionOrientation : TCaptionOrientation) : TFont;
Begin Result := cyGraphics.cyCreateFontIndirect(fromFont, CaptionOrientation); END;

(*----------------------------------------------------------------------------*)
Function cyCreateFontIndirect_P( fromFont : TFont; Angle : Double) : TFont;
Begin Result := cyGraphics.cyCreateFontIndirect(fromFont, Angle); END;

(*----------------------------------------------------------------------------*)
Function DrawTextFormatFlags1_P( aTextFormat : LongInt; Alignment : TAlignment; Layout : TTextLayout; WordWrap : Boolean; CaptionRender : TCaptionRender) : LongInt;
Begin Result := cyGraphics.DrawTextFormatFlags(aTextFormat, Alignment, Layout, WordWrap, CaptionRender); END;

(*----------------------------------------------------------------------------*)
Function DrawTextFormatFlags_P( aTextFormat : LongInt; Alignment : TAlignment; Layout : TTextLayout; WordWrap : Boolean) : LongInt;
Begin Result := cyGraphics.DrawTextFormatFlags(aTextFormat, Alignment, Layout, WordWrap); END;

(*----------------------------------------------------------------------------*)
Procedure cyFrame1_P( Canvas : TCanvas; var InsideRect : TRect; LeftColor, TopColor, RightColor, BottomColor : TColor; const Width : Integer; const RoundRect : boolean);
Begin cyGraphics.cyFrame(Canvas, InsideRect, LeftColor, TopColor, RightColor, BottomColor, Width, RoundRect); END;

(*----------------------------------------------------------------------------*)
Procedure cyFrame_P( aCanvas : TCanvas; var InsideRect : TRect; Color : TColor; const Width : Integer);
Begin cyGraphics.cyFrame(aCanvas, InsideRect, Color, Width); END;

(*----------------------------------------------------------------------------*)
procedure RIRegister_cyGraphics_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@cyGradientFill, 'cyGradientFill', cdRegister);
 S.RegisterDelphiFunction(@cyGradientFillVertical, 'cyGradientFillVertical', cdRegister);
 S.RegisterDelphiFunction(@cyGradientFillHorizontal, 'cyGradientFillHorizontal', cdRegister);
 S.RegisterDelphiFunction(@cyGradientFillShape, 'cyGradientFillShape', cdRegister);
 S.RegisterDelphiFunction(@cyGradientFillAngle, 'cyGradientFillAngle', cdRegister);
 S.RegisterDelphiFunction(@DrawRectangleInside, 'DrawRectangleInside', cdRegister);
 S.RegisterDelphiFunction(@cyFrame, 'cyFrame', cdRegister);
 S.RegisterDelphiFunction(@cyFrame1_P, 'cyFrame1', cdRegister);
 S.RegisterDelphiFunction(@cyFrame3D, 'cyFrame3D', cdRegister);
 S.RegisterDelphiFunction(@cyDrawButtonFace, 'cyDrawButtonFace', cdRegister);
 S.RegisterDelphiFunction(@cyDrawButton, 'cyDrawButton', cdRegister);
 S.RegisterDelphiFunction(@cyDrawSpeedButtonFace, 'cyDrawSpeedButtonFace', cdRegister);
 S.RegisterDelphiFunction(@cyDrawSpeedButton, 'cyDrawSpeedButton', cdRegister);
 S.RegisterDelphiFunction(@cyDrawCheckBox, 'cyDrawCheckBox', cdRegister);
 S.RegisterDelphiFunction(@cyDrawSingleLineText, 'cyDrawSingleLineText', cdRegister);
 S.RegisterDelphiFunction(@DrawTextFormatFlags, 'DrawTextFormatFlags', cdRegister);
 S.RegisterDelphiFunction(@DrawTextFormatFlags1_P, 'DrawTextFormatFlags1', cdRegister);
 S.RegisterDelphiFunction(@cyDrawText, 'cyDrawText', cdRegister);
 S.RegisterDelphiFunction(@cyCreateFontIndirect, 'cyCreateFontIndirect', cdRegister);
 S.RegisterDelphiFunction(@cyCreateFontIndirect1_P, 'cyCreateFontIndirect1', cdRegister);
 S.RegisterDelphiFunction(@cyDrawVerticalText, 'cyDrawVerticalText', cdRegister);
 S.RegisterDelphiFunction(@DrawLeftTurnPageEffect, 'DrawLeftTurnPageEffect', cdRegister);
 S.RegisterDelphiFunction(@DrawRightTurnPageEffect, 'DrawRightTurnPageEffect', cdRegister);
 S.RegisterDelphiFunction(@PictureIsTransparentAtPos, 'PictureIsTransparentAtPos', cdRegister);
 S.RegisterDelphiFunction(@IconIsTransparentAtPos, 'IconIsTransparentAtPos', cdRegister);
 S.RegisterDelphiFunction(@MetafileIsTransparentAtPos, 'MetafileIsTransparentAtPos', cdRegister);
 //S.RegisterDelphiFunction(@PngImageIsTransparentAtPos, 'PngImageIsTransparentAtPos', cdRegister);
 S.RegisterDelphiFunction(@DrawCanvas, 'DrawCanvas', cdRegister);
 S.RegisterDelphiFunction(@DrawCanvas1_P, 'DrawCanvas1', cdRegister);
 S.RegisterDelphiFunction(@DrawGraphic, 'DrawGraphic', cdRegister);
 S.RegisterDelphiFunction(@DrawGraphic1_P, 'DrawGraphic1', cdRegister);
 S.RegisterDelphiFunction(@DrawMosaicPortion, 'DrawMosaicPortion', cdRegister);
 S.RegisterDelphiFunction(@ValidGraphic, 'ValidGraphic', cdRegister);
 S.RegisterDelphiFunction(@ColorSetPercentBrightness, 'ColorSetPercentBrightness', cdRegister);
 S.RegisterDelphiFunction(@ColorModify, 'ColorModify', cdRegister);
 S.RegisterDelphiFunction(@ColorSetPercentContrast, 'ColorSetPercentContrast', cdRegister);
 S.RegisterDelphiFunction(@ColorSetPercentPale, 'ColorSetPercentPale', cdRegister);
 S.RegisterDelphiFunction(@MediumColor, 'MediumColor', cdRegister);
 S.RegisterDelphiFunction(@ClientToScreenRect, 'ClientToScreenRect', cdRegister);
 S.RegisterDelphiFunction(@ScreenToClientRect, 'ScreenToClientRect', cdRegister);
 S.RegisterDelphiFunction(@CombineRectKeepingCenterPosition, 'CombineRectKeepingCenterPosition', cdRegister);
 S.RegisterDelphiFunction(@InflateRectPercent, 'InflateRectPercent', cdRegister);
 S.RegisterDelphiFunction(@GetIntermediateRect, 'GetIntermediateRect', cdRegister);
 S.RegisterDelphiFunction(@GetProportionalRect, 'GetProportionalRect', cdRegister);
 S.RegisterDelphiFunction(@PointInRect, 'cyPointInRect', cdRegister);
 S.RegisterDelphiFunction(@PointInEllispe, 'PointInEllispe', cdRegister);
 S.RegisterDelphiFunction(@CanvasAcceleratorTextWidth, 'CanvasAcceleratorTextWidth', cdRegister);
end;



{ TPSImport_cyGraphics }
(*----------------------------------------------------------------------------*)
procedure TPSImport_cyGraphics.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_cyGraphics(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_cyGraphics.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  //RIRegister_cyGraphics(ri);
  RIRegister_cyGraphics_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
