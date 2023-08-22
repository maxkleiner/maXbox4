unit uPSI_cyImage;
{
   i forget that
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
  TPSImport_cyImage = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_cyImage(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_cyImage_Routines(S: TPSExec);

procedure Register;

implementation


uses
   Windows
  ,Graphics
  ,Math
  ,Jpeg
  ,cyImage
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_cyImage]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_cyImage(CL: TPSPascalCompiler);
begin
 // CL.AddTypeS('pRGBQuadArray', '^TRGBQuadArray // will not work');
 CL.AddDelphiFunction('Function BitmapsCompare( Bmp1 : TBitmap; Bmp2 : TBitmap; FirstCol, LastCol, FirstRow, LastRow : Integer) : Integer');
 CL.AddDelphiFunction('Procedure BitmapSetPercentBrightness( Bmp : TBitmap; IncPercent : Integer; RefreshBmp : Boolean)');
 CL.AddDelphiFunction('Procedure BitmapSetPixelsBrightness( Bmp : TBitmap; IncPixels : Integer; RefreshBmp : Boolean)');
 CL.AddDelphiFunction('Procedure BitmapSetPercentContrast( Bmp : TBitmap; IncPercent : Integer; RefreshBmp : Boolean)');
 CL.AddDelphiFunction('Procedure BitmapSetPixelsContrast( Bmp : TBitmap; IncPixels : Integer; RefreshBmp : Boolean)');
 CL.AddDelphiFunction('Procedure BitmapNegative( Bmp : TBitmap; RefreshBmp : Boolean)');
 CL.AddDelphiFunction('Procedure BitmapModifyRGB( Bmp : TBitmap; IncRed : Integer; IncGreen : Integer; IncBlue : Integer; RefreshBmp : Boolean)');
 CL.AddDelphiFunction('Procedure BitmapReplaceColor( Bmp : TBitmap; OldColor : TColor; NewColor : TColor; RangeRed, RangeGreen, RangeBlue : Word; SingleDestinationColor : Boolean; RefreshBmp : Boolean);');
 CL.AddDelphiFunction('Procedure BitmapReplaceColor1( Bmp : TBitmap; OldColor : TColor; NewColor : TColor; PercentRange1Red, PercentRange1Green, PercentRange1Blue : Extended; PercentRange2Red, PercentRange2Green,'+
                         ' PercentRange2Blue : Double; SingleDestinationColor : Boolean; RefreshBmp : Boolean);');
 CL.AddDelphiFunction('Procedure BitmapReplaceColors( Bmp : TBitmap; Array_OldPalette, Array_NewPalette : array of TColor; SingleDestinationColor, RefreshBmp : Boolean)');
 CL.AddDelphiFunction('Procedure BitmapResize( SourceBmp : TBitmap; DestinationBmp : TBitmap; Percent : Extended; RefreshBmp : Boolean)');
 CL.AddDelphiFunction('Procedure BitmapRotate( Bmp : TBitmap; AngleDegree : Word; AdjustSize : Boolean; BkColor : TColor)');
 CL.AddDelphiFunction('Procedure BitmapBlur( SourceBmp : TBitmap; DestinationBmp : TBitmap; Pixels : Word; Percent : Integer; RefreshBmp : Boolean)');
 CL.AddDelphiFunction('Procedure GraphicMirror( Source : TGraphic; Destination : TCanvas; Left, Top : Integer; Horizontal, Vertical : Boolean);');
 CL.AddDelphiFunction('Procedure GraphicMirror1( Source : TGraphic; Destination : TBitmap; Horizontal : Boolean; Vertical : Boolean);');
 CL.AddDelphiFunction('Function BitmapCreate( BmpWidth : Integer; BmpHeight : Integer; BgColor : TColor; PixelFormat : TPixelFormat) : TBitmap');
 CL.AddDelphiFunction('Procedure BitmapSaveToJpegFile( Bmp : TBitmap; FileName : String; QualityPercent : Word)');
 CL.AddDelphiFunction('Procedure JpegSaveToBitmapFile( JPEG : TJPEGImage; FileName : String)');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
Procedure GraphicMirror1_P( Source : TGraphic; Destination : TBitmap; Horizontal : Boolean; Vertical : Boolean);
Begin cyImage.GraphicMirror(Source, Destination, Horizontal, Vertical); END;

(*----------------------------------------------------------------------------*)
Procedure GraphicMirror_P( Source : TGraphic; Destination : TCanvas; Left, Top : Integer; Horizontal, Vertical : Boolean);
Begin cyImage.GraphicMirror(Source, Destination, Left, Top, Horizontal, Vertical); END;

(*----------------------------------------------------------------------------*)
Procedure BitmapReplaceColor1_P( Bmp : TBitmap; OldColor : TColor; NewColor : TColor; PercentRange1Red, PercentRange1Green, PercentRange1Blue : Extended; PercentRange2Red, PercentRange2Green, PercentRange2Blue : Double; SingleDestinationColor : Boolean; RefreshBmp : Boolean);
Begin cyImage.BitmapReplaceColor(Bmp, OldColor, NewColor, PercentRange1Red, PercentRange1Green, PercentRange1Blue, PercentRange2Red, PercentRange2Green, PercentRange2Blue, SingleDestinationColor, RefreshBmp); END;

(*----------------------------------------------------------------------------*)
Procedure BitmapReplaceColor_P( Bmp : TBitmap; OldColor : TColor; NewColor : TColor; RangeRed, RangeGreen, RangeBlue : Word; SingleDestinationColor : Boolean; RefreshBmp : Boolean);
Begin cyImage.BitmapReplaceColor(Bmp, OldColor, NewColor, RangeRed, RangeGreen, RangeBlue, SingleDestinationColor, RefreshBmp); END;

(*----------------------------------------------------------------------------*)
procedure RIRegister_cyImage_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@BitmapsCompare, 'BitmapsCompare', cdRegister);
 S.RegisterDelphiFunction(@BitmapSetPercentBrightness, 'BitmapSetPercentBrightness', cdRegister);
 S.RegisterDelphiFunction(@BitmapSetPixelsBrightness, 'BitmapSetPixelsBrightness', cdRegister);
 S.RegisterDelphiFunction(@BitmapSetPercentContrast, 'BitmapSetPercentContrast', cdRegister);
 S.RegisterDelphiFunction(@BitmapSetPixelsContrast, 'BitmapSetPixelsContrast', cdRegister);
 S.RegisterDelphiFunction(@BitmapNegative, 'BitmapNegative', cdRegister);
 S.RegisterDelphiFunction(@BitmapModifyRGB, 'BitmapModifyRGB', cdRegister);
 S.RegisterDelphiFunction(@BitmapReplaceColor, 'BitmapReplaceColor', cdRegister);
 S.RegisterDelphiFunction(@BitmapReplaceColor1_P, 'BitmapReplaceColor1', cdRegister);
 S.RegisterDelphiFunction(@BitmapReplaceColors, 'BitmapReplaceColors', cdRegister);
 S.RegisterDelphiFunction(@BitmapResize, 'BitmapResize', cdRegister);
 S.RegisterDelphiFunction(@BitmapRotate, 'BitmapRotate', cdRegister);
 S.RegisterDelphiFunction(@BitmapBlur, 'BitmapBlur', cdRegister);
 S.RegisterDelphiFunction(@GraphicMirror, 'GraphicMirror', cdRegister);
 S.RegisterDelphiFunction(@GraphicMirror1_P, 'GraphicMirror1', cdRegister);
 S.RegisterDelphiFunction(@BitmapCreate, 'BitmapCreate', cdRegister);
 S.RegisterDelphiFunction(@BitmapSaveToJpegFile, 'BitmapSaveToJpegFile', cdRegister);
 S.RegisterDelphiFunction(@JpegSaveToBitmapFile, 'JpegSaveToBitmapFile', cdRegister);
end;

 
 
{ TPSImport_cyImage }
(*----------------------------------------------------------------------------*)
procedure TPSImport_cyImage.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_cyImage(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_cyImage.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  //RIRegister_cyImage(ri);
  RIRegister_cyImage_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
