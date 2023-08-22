unit uPSI_JvPaintFX;
{
  widgets in search of android 
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
  TPSImport_JvPaintFX = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TJvPaintFX(CL: TPSPascalCompiler);
procedure SIRegister_JvPaintFX(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_JvPaintFX_Routines(S: TPSExec);
procedure RIRegister_TJvPaintFX(CL: TPSRuntimeClassImporter);
procedure RIRegister_JvPaintFX(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
  // JclUnitVersioning
  //Windows
  //Messages
  Graphics
  ,Controls
  ,Forms
  ,JvPaintFX
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_JvPaintFX]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TJvPaintFX(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TComponent', 'TJvPaintFX') do
  with CL.AddClassN(CL.FindClass('TComponent'),'TJvPaintFX') do begin
    RegisterMethod('Procedure Solarize( const Src : TBitmap; var Dst : TBitmap; Amount : Integer)');
    RegisterMethod('Procedure Posterize( const Src : TBitmap; var Dst : TBitmap; Amount : Integer)');
    RegisterMethod('Procedure Blend( const Src1, Src2 : TBitmap; var Dst : TBitmap; Amount : Single)');
    RegisterMethod('Procedure Blend2( const Src1, Src2 : TBitmap; var Dst : TBitmap; Amount : Single)');
    RegisterMethod('Procedure ExtractColor( const Dst : TBitmap; AColor : TColor)');
    RegisterMethod('Procedure ExcludeColor( const Dst : TBitmap; AColor : TColor)');
    RegisterMethod('Procedure Turn( Src, Dst : TBitmap)');
    RegisterMethod('Procedure TurnRight( Src, Dst : TBitmap)');
    RegisterMethod('Procedure HeightMap( const Dst : TBitmap; Amount : Integer)');
    RegisterMethod('Procedure TexturizeTile( const Dst : TBitmap; Amount : Integer)');
    RegisterMethod('Procedure TexturizeOverlap( const Dst : TBitmap; Amount : Integer)');
    RegisterMethod('Procedure RippleRandom( const Dst : TBitmap; Amount : Integer)');
    RegisterMethod('Procedure RippleTooth( const Dst : TBitmap; Amount : Integer)');
    RegisterMethod('Procedure RippleTriangle( const Dst : TBitmap; Amount : Integer)');
    RegisterMethod('Procedure Triangles( const Dst : TBitmap; Amount : Integer)');
    RegisterMethod('Procedure DrawMandelJulia( const Dst : TBitmap; x0, y0, x1, y1 : Single; Niter : Integer; Mandel : Boolean)');
    RegisterMethod('Procedure FilterXBlue( const Dst : TBitmap; Min, Max : Integer)');
    RegisterMethod('Procedure FilterXGreen( const Dst : TBitmap; Min, Max : Integer)');
    RegisterMethod('Procedure FilterXRed( const Dst : TBitmap; Min, Max : Integer)');
    RegisterMethod('Procedure FilterBlue( const Dst : TBitmap; Min, Max : Integer)');
    RegisterMethod('Procedure FilterGreen( const Dst : TBitmap; Min, Max : Integer)');
    RegisterMethod('Procedure FilterRed( const Dst : TBitmap; Min, Max : Integer)');
    RegisterMethod('Procedure Emboss( var Bmp : TBitmap)');
    RegisterMethod('Procedure Plasma( Src1, Src2, Dst : TBitmap; Scale, Turbulence : Single)');
    RegisterMethod('Procedure Shake( Src, Dst : TBitmap; Factor : Single)');
    RegisterMethod('Procedure ShakeDown( Src, Dst : TBitmap; Factor : Single)');
    RegisterMethod('Procedure KeepBlue( const Dst : TBitmap; Factor : Single)');
    RegisterMethod('Procedure KeepGreen( const Dst : TBitmap; Factor : Single)');
    RegisterMethod('Procedure KeepRed( const Dst : TBitmap; Factor : Single)');
    RegisterMethod('Procedure Mandelbrot( const Dst : TBitmap; Factor : Integer)');
    RegisterMethod('Procedure MaskMandelbrot( const Dst : TBitmap; Factor : Integer)');
    RegisterMethod('Procedure FoldRight( Src1, Src2, Dst : TBitmap; Amount : Single)');
    RegisterMethod('Procedure QuartoOpaque( Src, Dst : TBitmap)');
    RegisterMethod('Procedure SemiOpaque( Src, Dst : TBitmap)');
    RegisterMethod('Procedure ShadowDownLeft( const Dst : TBitmap)');
    RegisterMethod('Procedure ShadowDownRight( const Dst : TBitmap)');
    RegisterMethod('Procedure ShadowUpLeft( const Dst : TBitmap)');
    RegisterMethod('Procedure ShadowUpRight( const Dst : TBitmap)');
    RegisterMethod('Procedure Darkness( const Dst : TBitmap; Amount : Integer)');
    RegisterMethod('Procedure Trace( const Dst : TBitmap; Intensity : Integer)');
    RegisterMethod('Procedure FlipRight( const Dst : TBitmap)');
    RegisterMethod('Procedure FlipDown( const Dst : TBitmap)');
    RegisterMethod('Procedure SpotLight( const Dst : TBitmap; Amount : Integer; Spot : TRect)');
    RegisterMethod('Procedure SplitLight( const Dst : TBitmap; Amount : Integer)');
    RegisterMethod('Procedure MakeSeamlessClip( var Dst : TBitmap; Seam : Integer)');
    RegisterMethod('Procedure Wave( const Dst : TBitmap; Amount, Inference, Style : Integer)');
    RegisterMethod('Procedure Mosaic( const Bm : TBitmap; Size : Integer)');
    RegisterMethod('Procedure SmoothRotate( var Src, Dst : TBitmap; CX, CY : Integer; Angle : Single)');
    RegisterMethod('Procedure SmoothResize( var Src, Dst : TBitmap)');
    RegisterMethod('Procedure Twist( var Bmp, Dst : TBitmap; Amount : Integer)');
    RegisterMethod('Procedure SplitBlur( const Dst : TBitmap; Amount : Integer)');
    RegisterMethod('Procedure GaussianBlur( const Dst : TBitmap; Amount : Integer)');
    RegisterMethod('Procedure Smooth( const Dst : TBitmap; Weight : Integer)');
    RegisterMethod('Procedure GrayScale( const Dst : TBitmap)');
    RegisterMethod('Procedure AddColorNoise( const Dst : TBitmap; Amount : Integer)');
    RegisterMethod('Procedure AddMonoNoise( const Dst : TBitmap; Amount : Integer)');
    RegisterMethod('Procedure Contrast( const Dst : TBitmap; Amount : Integer)');
    RegisterMethod('Procedure Lightness( const Dst : TBitmap; Amount : Integer)');
    RegisterMethod('Procedure Saturation( const Dst : TBitmap; Amount : Integer)');
    RegisterMethod('Procedure Spray( const Dst : TBitmap; Amount : Integer)');
    RegisterMethod('Procedure AntiAlias( const Dst : TBitmap)');
    RegisterMethod('Procedure AntiAliasRect( const Dst : TBitmap; XOrigin, YOrigin, XFinal, YFinal : Integer)');
    RegisterMethod('Procedure SmoothPoint( const Dst : TBitmap; XK, YK : Integer)');
    RegisterMethod('Procedure FishEye( var Bmp, Dst : TBitmap; Amount : Single)');
    RegisterMethod('Procedure Marble( const Src : TBitmap; var Dst : TBitmap; Scale : Single; Turbulence : Integer)');
    RegisterMethod('Procedure Marble2( const Src : TBitmap; var Dst : TBitmap; Scale : Single; Turbulence : Integer)');
    RegisterMethod('Procedure Marble3( const Src : TBitmap; var Dst : TBitmap; Scale : Single; Turbulence : Integer)');
    RegisterMethod('Procedure Marble4( const Src : TBitmap; var Dst : TBitmap; Scale : Single; Turbulence : Integer)');
    RegisterMethod('Procedure Marble5( const Src : TBitmap; var Dst : TBitmap; Scale : Single; Turbulence : Integer)');
    RegisterMethod('Procedure Marble6( const Src : TBitmap; var Dst : TBitmap; Scale : Single; Turbulence : Integer)');
    RegisterMethod('Procedure Marble7( const Src : TBitmap; var Dst : TBitmap; Scale : Single; Turbulence : Integer)');
    RegisterMethod('Procedure Marble8( const Src : TBitmap; var Dst : TBitmap; Scale : Single; Turbulence : Integer)');
    RegisterMethod('Procedure SqueezeHor( Src, Dst : TBitmap; Amount : Integer; Style : TLightBrush)');
    RegisterMethod('Procedure SplitRound( Src, Dst : TBitmap; Amount : Integer; Style : TLightBrush)');
    RegisterMethod('Procedure Tile( Src, Dst : TBitmap; Amount : Integer)');
    RegisterMethod('Procedure Stretch( Src, Dst : TBitmap; Filter : TFilterProc; AWidth : Single)');
    RegisterMethod('Procedure Grow( Src1, Src2, Dst : TBitmap; Amount : Single; X, Y : Integer)');
    RegisterMethod('Procedure Invert( Src : TBitmap)');
    RegisterMethod('Procedure MirrorRight( Src : TBitmap)');
    RegisterMethod('Procedure MirrorDown( Src : TBitmap)');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_JvPaintFX(CL: TPSPascalCompiler);
begin
  CL.AddTypeS('TLightBrush', '( lbBrightness, lbContrast, lbSaturation, lbFishe'
   +'ye, lbrotate, lbtwist, lbrimple, mbHor, mbTop, mbBottom, mbDiamond, mbWast'
   +'e, mbRound, mbRound2, mbSplitRound, mbSplitWaste )');
  SIRegister_TJvPaintFX(CL);
 CL.AddDelphiFunction('Function SplineFilter( Value : Single) : Single');
 CL.AddDelphiFunction('Function BellFilter( Value : Single) : Single');
 CL.AddDelphiFunction('Function TriangleFilter( Value : Single) : Single');
 CL.AddDelphiFunction('Function BoxFilter( Value : Single) : Single');
 CL.AddDelphiFunction('Function HermiteFilter( Value : Single) : Single');
 CL.AddDelphiFunction('Function Lanczos3Filter( Value : Single) : Single');
 CL.AddDelphiFunction('Function MitchellFilter( Value : Single) : Single');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure RIRegister_JvPaintFX_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@SplineFilter, 'SplineFilter', cdRegister);
 S.RegisterDelphiFunction(@BellFilter, 'BellFilter', cdRegister);
 S.RegisterDelphiFunction(@TriangleFilter, 'TriangleFilter', cdRegister);
 S.RegisterDelphiFunction(@BoxFilter, 'BoxFilter', cdRegister);
 S.RegisterDelphiFunction(@HermiteFilter, 'HermiteFilter', cdRegister);
 S.RegisterDelphiFunction(@Lanczos3Filter, 'Lanczos3Filter', cdRegister);
 S.RegisterDelphiFunction(@MitchellFilter, 'MitchellFilter', cdRegister);
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJvPaintFX(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJvPaintFX) do begin
    RegisterMethod(@TJvPaintFX.Solarize, 'Solarize');
    RegisterMethod(@TJvPaintFX.Posterize, 'Posterize');
    RegisterMethod(@TJvPaintFX.Blend, 'Blend');
    RegisterMethod(@TJvPaintFX.Blend2, 'Blend2');
    RegisterMethod(@TJvPaintFX.ExtractColor, 'ExtractColor');
    RegisterMethod(@TJvPaintFX.ExcludeColor, 'ExcludeColor');
    RegisterMethod(@TJvPaintFX.Turn, 'Turn');
    RegisterMethod(@TJvPaintFX.TurnRight, 'TurnRight');
    RegisterMethod(@TJvPaintFX.HeightMap, 'HeightMap');
    RegisterMethod(@TJvPaintFX.TexturizeTile, 'TexturizeTile');
    RegisterMethod(@TJvPaintFX.TexturizeOverlap, 'TexturizeOverlap');
    RegisterMethod(@TJvPaintFX.RippleRandom, 'RippleRandom');
    RegisterMethod(@TJvPaintFX.RippleTooth, 'RippleTooth');
    RegisterMethod(@TJvPaintFX.RippleTriangle, 'RippleTriangle');
    RegisterMethod(@TJvPaintFX.Triangles, 'Triangles');
    RegisterMethod(@TJvPaintFX.DrawMandelJulia, 'DrawMandelJulia');
    RegisterMethod(@TJvPaintFX.FilterXBlue, 'FilterXBlue');
    RegisterMethod(@TJvPaintFX.FilterXGreen, 'FilterXGreen');
    RegisterMethod(@TJvPaintFX.FilterXRed, 'FilterXRed');
    RegisterMethod(@TJvPaintFX.FilterBlue, 'FilterBlue');
    RegisterMethod(@TJvPaintFX.FilterGreen, 'FilterGreen');
    RegisterMethod(@TJvPaintFX.FilterRed, 'FilterRed');
    RegisterMethod(@TJvPaintFX.Emboss, 'Emboss');
    RegisterMethod(@TJvPaintFX.Plasma, 'Plasma');
    RegisterMethod(@TJvPaintFX.Shake, 'Shake');
    RegisterMethod(@TJvPaintFX.ShakeDown, 'ShakeDown');
    RegisterMethod(@TJvPaintFX.KeepBlue, 'KeepBlue');
    RegisterMethod(@TJvPaintFX.KeepGreen, 'KeepGreen');
    RegisterMethod(@TJvPaintFX.KeepRed, 'KeepRed');
    RegisterMethod(@TJvPaintFX.Mandelbrot, 'Mandelbrot');
    RegisterMethod(@TJvPaintFX.MaskMandelbrot, 'MaskMandelbrot');
    RegisterMethod(@TJvPaintFX.FoldRight, 'FoldRight');
    RegisterMethod(@TJvPaintFX.QuartoOpaque, 'QuartoOpaque');
    RegisterMethod(@TJvPaintFX.SemiOpaque, 'SemiOpaque');
    RegisterMethod(@TJvPaintFX.ShadowDownLeft, 'ShadowDownLeft');
    RegisterMethod(@TJvPaintFX.ShadowDownRight, 'ShadowDownRight');
    RegisterMethod(@TJvPaintFX.ShadowUpLeft, 'ShadowUpLeft');
    RegisterMethod(@TJvPaintFX.ShadowUpRight, 'ShadowUpRight');
    RegisterMethod(@TJvPaintFX.Darkness, 'Darkness');
    RegisterMethod(@TJvPaintFX.Trace, 'Trace');
    RegisterMethod(@TJvPaintFX.FlipRight, 'FlipRight');
    RegisterMethod(@TJvPaintFX.FlipDown, 'FlipDown');
    RegisterMethod(@TJvPaintFX.SpotLight, 'SpotLight');
    RegisterMethod(@TJvPaintFX.SplitLight, 'SplitLight');
    RegisterMethod(@TJvPaintFX.MakeSeamlessClip, 'MakeSeamlessClip');
    RegisterMethod(@TJvPaintFX.Wave, 'Wave');
    RegisterMethod(@TJvPaintFX.Mosaic, 'Mosaic');
    RegisterMethod(@TJvPaintFX.SmoothRotate, 'SmoothRotate');
    RegisterMethod(@TJvPaintFX.SmoothResize, 'SmoothResize');
    RegisterMethod(@TJvPaintFX.Twist, 'Twist');
    RegisterMethod(@TJvPaintFX.SplitBlur, 'SplitBlur');
    RegisterMethod(@TJvPaintFX.GaussianBlur, 'GaussianBlur');
    RegisterMethod(@TJvPaintFX.Smooth, 'Smooth');
    RegisterMethod(@TJvPaintFX.GrayScale, 'GrayScale');
    RegisterMethod(@TJvPaintFX.AddColorNoise, 'AddColorNoise');
    RegisterMethod(@TJvPaintFX.AddMonoNoise, 'AddMonoNoise');
    RegisterMethod(@TJvPaintFX.Contrast, 'Contrast');
    RegisterMethod(@TJvPaintFX.Lightness, 'Lightness');
    RegisterMethod(@TJvPaintFX.Saturation, 'Saturation');
    RegisterMethod(@TJvPaintFX.Spray, 'Spray');
    RegisterMethod(@TJvPaintFX.AntiAlias, 'AntiAlias');
    RegisterMethod(@TJvPaintFX.AntiAliasRect, 'AntiAliasRect');
    RegisterMethod(@TJvPaintFX.SmoothPoint, 'SmoothPoint');
    RegisterMethod(@TJvPaintFX.FishEye, 'FishEye');
    RegisterMethod(@TJvPaintFX.Marble, 'Marble');
    RegisterMethod(@TJvPaintFX.Marble2, 'Marble2');
    RegisterMethod(@TJvPaintFX.Marble3, 'Marble3');
    RegisterMethod(@TJvPaintFX.Marble4, 'Marble4');
    RegisterMethod(@TJvPaintFX.Marble5, 'Marble5');
    RegisterMethod(@TJvPaintFX.Marble6, 'Marble6');
    RegisterMethod(@TJvPaintFX.Marble7, 'Marble7');
    RegisterMethod(@TJvPaintFX.Marble8, 'Marble8');
    RegisterMethod(@TJvPaintFX.SqueezeHor, 'SqueezeHor');
    RegisterMethod(@TJvPaintFX.SplitRound, 'SplitRound');
    RegisterMethod(@TJvPaintFX.Tile, 'Tile');
    RegisterMethod(@TJvPaintFX.Stretch, 'Stretch');
    RegisterMethod(@TJvPaintFX.Grow, 'Grow');
    RegisterMethod(@TJvPaintFX.Invert, 'Invert');
    RegisterMethod(@TJvPaintFX.MirrorRight, 'MirrorRight');
    RegisterMethod(@TJvPaintFX.MirrorDown, 'MirrorDown');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_JvPaintFX(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TJvPaintFX(CL);
end;

 
 
{ TPSImport_JvPaintFX }
(*----------------------------------------------------------------------------*)
procedure TPSImport_JvPaintFX.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_JvPaintFX(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_JvPaintFX.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_JvPaintFX(ri);
  RIRegister_JvPaintFX_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
