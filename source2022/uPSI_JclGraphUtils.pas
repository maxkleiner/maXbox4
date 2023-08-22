unit uPSI_JclGraphUtils;
{
 no pointers
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
  TPSImport_JclGraphUtils = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;


{ compile-time registration functions }
procedure SIRegister_JclGraphUtils(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_JclGraphUtils_Routines(S: TPSExec);

procedure Register;

implementation


uses
   Types
  //,Windows
  ,Graphics
  ,Forms
  //,Qt
  //,QGraphics
  ,JclBase
  ,JclGraphUtils
  ;


procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_JclGraphUtils]);
end;


procedure drawPlot(vPoints: TPointArray; cFrm: TForm; vcolor: integer);
var
  i, hsize: integer;
begin
  with cFrm.canvas do begin
    hsize:= cFrm.Height -1 div 2;
    Pen.Color:= vcolor;
    MoveTo(0, hsize -((round(vPoints[0].Y))));
    for i:= 0 to High(vPoints) do
      LineTo(i, round(vPoints[i].Y));
  end;
end;


(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_JclGraphUtils(CL: TPSPascalCompiler);
begin
  //CL.AddTypeS('PColor32', '^TColor32 // will not work');
  CL.AddTypeS('TColor32', 'Longword');
  //CL.AddTypeS('PColor32Array', '^TColor32Array // will not work');
  //CL.AddTypeS('PPalette32', '^TPalette32 // will not work');
  CL.AddTypeS('TArrayOfColor32', 'array of TColor32');
  //CL.AddTypeS('TPointArray', 'array of TPoint');
  //CL.AddTypeS('PPointArray', '^TPointArray // will not work');
  CL.AddTypeS('TClipCode', '( ccLeft, ccRight, ccAbove, ccBelow )');
  CL.AddTypeS('TClipCodes', 'set of TClipCode');
  CL.AddTypeS('TPalette32','array [0..255] of TColor32');

  //CL.AddTypeS('PClipCodes', '^TClipCodes // will not work');
 CL.AddConstantN('clBlack32','LongWord').SetUInt( TColor32 ( $FF000000 ));
 CL.AddConstantN('clDimGray32','LongWord').SetUInt( TColor32 ( $FF3F3F3F ));
 CL.AddConstantN('clGray32','LongWord').SetUInt( TColor32 ( $FF7F7F7F ));
 CL.AddConstantN('clLightGray32','LongWord').SetUInt( TColor32 ( $FFBFBFBF ));
 CL.AddConstantN('clWhite32','LongWord').SetUInt( TColor32 ( $FFFFFFFF ));
 CL.AddConstantN('clMaroon32','LongWord').SetUInt( TColor32 ( $FF7F0000 ));
 CL.AddConstantN('clGreen32','LongWord').SetUInt( TColor32 ( $FF007F00 ));
 CL.AddConstantN('clOlive32','LongWord').SetUInt( TColor32 ( $FF7F7F00 ));
 CL.AddConstantN('clNavy32','LongWord').SetUInt( TColor32 ( $FF00007F ));
 CL.AddConstantN('clPurple32','LongWord').SetUInt( TColor32 ( $FF7F007F ));
 CL.AddConstantN('clTeal32','LongWord').SetUInt( TColor32 ( $FF007F7F ));
 CL.AddConstantN('clRed32','LongWord').SetUInt( TColor32 ( $FFFF0000 ));
 CL.AddConstantN('clLime32','LongWord').SetUInt( TColor32 ( $FF00FF00 ));
 CL.AddConstantN('clYellow32','LongWord').SetUInt( TColor32 ( $FFFFFF00 ));
 CL.AddConstantN('clBlue32','LongWord').SetUInt( TColor32 ( $FF0000FF ));
 CL.AddConstantN('clFuchsia32','LongWord').SetUInt( TColor32 ( $FFFF00FF ));
 CL.AddConstantN('clAqua32','LongWord').SetUInt( TColor32 ( $FF00FFFF ));
 CL.AddConstantN('clTrWhite32','LongWord').SetUInt( TColor32 ( $7FFFFFFF ));
 CL.AddConstantN('clTrBlack32','LongWord').SetUInt( TColor32 ( $7F000000 ));
 CL.AddConstantN('clTrRed32','LongWord').SetUInt( TColor32 ( $7FFF0000 ));
 CL.AddConstantN('clTrGreen32','LongWord').SetUInt( TColor32 ( $7F00FF00 ));
 CL.AddConstantN('clTrBlue32','LongWord').SetUInt( TColor32 ( $7F0000FF ));
 CL.AddDelphiFunction('Procedure EMMS');
 CL.AddDelphiFunction('Function DialogUnitsToPixelsX( const DialogUnits : Word) : Word');
 CL.AddDelphiFunction('Function DialogUnitsToPixelsY( const DialogUnits : Word) : Word');
 CL.AddDelphiFunction('Function PixelsToDialogUnitsX( const PixelUnits : Word) : Word');
 CL.AddDelphiFunction('Function PixelsToDialogUnitsY( const PixelUnits : Word) : Word');
 CL.AddDelphiFunction('Function NullPoint : TPoint');
 CL.AddDelphiFunction('Function PointAssign( const X, Y : Integer) : TPoint');
 CL.AddDelphiFunction('Procedure PointCopy( var Dest : TPoint; const Source : TPoint)');
 CL.AddDelphiFunction('Function PointEqual( const P1, P2 : TPoint) : Boolean');
 CL.AddDelphiFunction('Function PointIsNull( const P : TPoint) : Boolean');
 CL.AddDelphiFunction('Procedure PointMove( var P : TPoint; const DeltaX, DeltaY : Integer)');
 CL.AddDelphiFunction('Function NullRect : TRect');
 CL.AddDelphiFunction('Function RectAssign( const Left, Top, Right, Bottom : Integer) : TRect');
 CL.AddDelphiFunction('Function RectAssignPoints( const TopLeft, BottomRight : TPoint) : TRect');
 CL.AddDelphiFunction('Function RectBounds( const Left, Top, Width, Height : Integer) : TRect');
 CL.AddDelphiFunction('Function RectCenter( const R : TRect) : TPoint');
 CL.AddDelphiFunction('Procedure RectCopy( var Dest : TRect; const Source : TRect)');
 CL.AddDelphiFunction('Procedure RectFitToScreen( var R : TRect)');
 CL.AddDelphiFunction('Procedure RectGrow( var R : TRect; const Delta : Integer)');
 CL.AddDelphiFunction('Procedure RectGrowX( var R : TRect; const Delta : Integer)');
 CL.AddDelphiFunction('Procedure RectGrowY( var R : TRect; const Delta : Integer)');
 CL.AddDelphiFunction('Function RectEqual( const R1, R2 : TRect) : Boolean');
 CL.AddDelphiFunction('Function RectHeight( const R : TRect) : Integer');
 CL.AddDelphiFunction('Function RectIncludesPoint( const R : TRect; const Pt : TPoint) : Boolean');
 CL.AddDelphiFunction('Function RectIncludesRect( const R1, R2 : TRect) : Boolean');
 CL.AddDelphiFunction('Function RectIntersection( const R1, R2 : TRect) : TRect');
 CL.AddDelphiFunction('Function RectIntersectRect( const R1, R2 : TRect) : Boolean');
 CL.AddDelphiFunction('Function RectIsEmpty( const R : TRect) : Boolean');
 CL.AddDelphiFunction('Function RectIsNull( const R : TRect) : Boolean');
 CL.AddDelphiFunction('Function RectIsSquare( const R : TRect) : Boolean');
 CL.AddDelphiFunction('Function RectIsValid( const R : TRect) : Boolean');
 CL.AddDelphiFunction('Procedure RectMove( var R : TRect; const DeltaX, DeltaY : Integer)');
 CL.AddDelphiFunction('Procedure RectMoveTo( var R : TRect; const X, Y : Integer)');
 CL.AddDelphiFunction('Procedure RectNormalize( var R : TRect)');
 CL.AddDelphiFunction('Function RectsAreValid( R : array of TRect) : Boolean');
 CL.AddDelphiFunction('Function RectUnion( const R1, R2 : TRect) : TRect');
 CL.AddDelphiFunction('Function RectWidth( const R : TRect) : Integer');
 CL.AddDelphiFunction('Function ClipCodes( const X, Y, MinX, MinY, MaxX, MaxY : Float) : TClipCodes;');
 CL.AddDelphiFunction('Function ClipCodes1( const X, Y : Float; const ClipRect : TRect) : TClipCodes;');
 CL.AddDelphiFunction('Function ClipLine( var X1, Y1, X2, Y2 : Integer; const ClipRect : TRect) : Boolean;');
 //CL.AddDelphiFunction('Function ClipLine1( var X1, Y1, X2, Y2 : Double; const MinX, MinY, MaxX, MaxY : Float; const Codes : PClipCodes) : Boolean;');
 CL.AddDelphiFunction('Procedure DrawPolyLine( const Canvas : TCanvas; var Points : TPointArray; const ClipRect : TRect)');
 CL.AddDelphiFunction('procedure drawPlot(vPoints: TPointArray; cFrm: TForm; vcolor: integer)');
 CL.AddDelphiFunction('Procedure GetRGBValue( const Color : TColor; out Red, Green, Blue : Byte)');
 CL.AddDelphiFunction('Function SetRGBValue( const Red, Green, Blue : Byte) : TColor');
 CL.AddDelphiFunction('Function GetColorBlue( const Color : TColor) : Byte');
 CL.AddDelphiFunction('Function GetColorFlag( const Color : TColor) : Byte');
 CL.AddDelphiFunction('Function GetColorGreen( const Color : TColor) : Byte');
 CL.AddDelphiFunction('Function GetColorRed( const Color : TColor) : Byte');
 CL.AddDelphiFunction('Function SetColorBlue( const Color : TColor; const Blue : Byte) : TColor');
 CL.AddDelphiFunction('Function SetColorFlag( const Color : TColor; const Flag : Byte) : TColor');
 CL.AddDelphiFunction('Function SetColorGreen( const Color : TColor; const Green : Byte) : TColor');
 CL.AddDelphiFunction('Function SetColorRed( const Color : TColor; const Red : Byte) : TColor');
 CL.AddDelphiFunction('Function BrightColor( const Color : TColor; const Pct : Single) : TColor');
 CL.AddDelphiFunction('Function BrightColorChannel( const Channel : Byte; const Pct : Single) : Byte');
 CL.AddDelphiFunction('Function DarkColor( const Color : TColor; const Pct : Single) : TColor');
 CL.AddDelphiFunction('Function DarkColorChannel( const Channel : Byte; const Pct : Single) : Byte');
 CL.AddDelphiFunction('Procedure CIED65ToCIED50( var X, Y, Z : Extended)');
 //CL.AddDelphiFunction('Procedure CMYKToBGR( const Source, Target : ___Pointer; const BitsPerSample : Byte; Count : Cardinal);');
 //CL.AddDelphiFunction('Procedure CMYKToBGR1( const C, M, Y, K, Target : ___Pointer; const BitsPerSample : Byte; Count : Cardinal);');
 //CL.AddDelphiFunction('Procedure CIELABToBGR( const Source, Target : ___Pointer; const Count : Cardinal);');
 //CL.AddDelphiFunction('Procedure CIELABToBGR1( LSource, aSource, bSource : PByte; const Target : Pointer; const Count : Cardinal);');
 //CL.AddDelphiFunction('Procedure RGBToBGR( const Source, Target : ___Pointer; const BitsPerSample : Byte; Count : Cardinal);');
 //CL.AddDelphiFunction('Procedure RGBToBGR1( const R, G, B, Target : ___Pointer; const BitsPerSample : Byte; Count : Cardinal);');
 //CL.AddDelphiFunction('Procedure RGBAToBGRA( const Source, Target : ___Pointer; const BitsPerSample : Byte; Count : Cardinal)');
 CL.AddDelphiFunction('Procedure WinColorToOpenGLColor( const Color : TColor; out Red, Green, Blue : Float)');
 CL.AddDelphiFunction('Function OpenGLColorToWinColor( const Red, Green, Blue : Float) : TColor');
 CL.AddDelphiFunction('Function Color32( WinColor : TColor) : TColor32;');
 CL.AddDelphiFunction('Function Color32( const R, G, B : Byte; const A : Byte) : TColor32;');
 CL.AddDelphiFunction('Function Color321( const Index : Byte; const Palette : TPalette32) : TColor32;');
 CL.AddDelphiFunction('Function Gray32( const Intensity : Byte; const Alpha : Byte) : TColor32');
 CL.AddDelphiFunction('Function WinColor( const Color32 : TColor32) : TColor');
 CL.AddDelphiFunction('Function RedComponent( const Color32 : TColor32) : Integer');
 CL.AddDelphiFunction('Function GreenComponent( const Color32 : TColor32) : Integer');
 CL.AddDelphiFunction('Function BlueComponent( const Color32 : TColor32) : Integer');
 CL.AddDelphiFunction('Function AlphaComponent( const Color32 : TColor32) : Integer');
 CL.AddDelphiFunction('Function Intensity( const R, G, B : Single) : Single;');
 CL.AddDelphiFunction('Function Intensity( const Color32 : TColor32) : Integer;');
 CL.AddDelphiFunction('Function SetAlpha( const Color32 : TColor32; NewAlpha : Integer) : TColor32');
 CL.AddDelphiFunction('Procedure HSLToRGB( const H, S, L : Single; out R, G, B : Single);');
 CL.AddDelphiFunction('Function HSLToRGB1( const H, S, L : Single) : TColor32;');
 CL.AddDelphiFunction('Procedure RGBToHSL( const R, G, B : Single; out H, S, L : Single);');
 CL.AddDelphiFunction('Procedure RGBToHSL1( const RGB : TColor32; out H, S, L : Single);');
 CL.AddDelphiFunction('Function ColorToHTML( const Color : TColor) : String');
 CL.AddDelphiFunction('Function DottedLineTo( const Canvas : TCanvas; const X, Y : Integer) : Boolean;');
 CL.AddDelphiFunction('Function ShortenString( const DC : HDC; const S : WideString; const Width : Integer; const RTL : Boolean; EllipsisWidth : Integer) : WideString');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
Function DottedLineTo_P( const Canvas : TCanvas; const X, Y : Integer) : Boolean;
Begin Result := JclGraphUtils.DottedLineTo(Canvas, X, Y); END;

(*----------------------------------------------------------------------------*)
Procedure RGBToHSL1_P( const RGB : TColor32; out H, S, L : Single);
Begin JclGraphUtils.RGBToHSL(RGB, H, S, L); END;

(*----------------------------------------------------------------------------*)
Procedure RGBToHSL_P( const R, G, B : Single; out H, S, L : Single);
Begin JclGraphUtils.RGBToHSL(R, G, B, H, S, L); END;

(*----------------------------------------------------------------------------*)
Function HSLToRGB1_P( const H, S, L : Single) : TColor32;
Begin Result := JclGraphUtils.HSLToRGB(H, S, L); END;

(*----------------------------------------------------------------------------*)
Procedure HSLToRGB_P( const H, S, L : Single; out R, G, B : Single);
Begin JclGraphUtils.HSLToRGB(H, S, L, R, G, B); END;

(*----------------------------------------------------------------------------*)
Function Intensity_P( const Color32 : TColor32) : Integer;
Begin Result := JclGraphUtils.Intensity(Color32); END;

(*----------------------------------------------------------------------------*)
Function Intensity_P_1( const R, G, B : Single) : Single;
Begin Result := JclGraphUtils.Intensity(R, G, B); END;

(*----------------------------------------------------------------------------*)
Function Color321_P( const Index : Byte; const Palette : TPalette32) : TColor32;
Begin Result := JclGraphUtils.Color32(Index, Palette); END;

(*----------------------------------------------------------------------------*)
Function Color32_P( const R, G, B : Byte; const A : Byte) : TColor32;
Begin Result := JclGraphUtils.Color32(R, G, B, A); END;

(*----------------------------------------------------------------------------*)
Function Color32_P_1( WinColor : TColor) : TColor32;
Begin Result := JclGraphUtils.Color32(WinColor); END;

(*----------------------------------------------------------------------------*)
Procedure RGBToBGR1_P( const R, G, B, Target : Pointer; const BitsPerSample : Byte; Count : Cardinal);
Begin JclGraphUtils.RGBToBGR(R, G, B, Target, BitsPerSample, Count); END;

(*----------------------------------------------------------------------------*)
Procedure RGBToBGR_P( const Source, Target : Pointer; const BitsPerSample : Byte; Count : Cardinal);
Begin JclGraphUtils.RGBToBGR(Source, Target, BitsPerSample, Count); END;

(*----------------------------------------------------------------------------*)
Procedure CIELABToBGR1_P( LSource, aSource, bSource : PByte; const Target : Pointer; const Count : Cardinal);
Begin JclGraphUtils.CIELABToBGR(LSource, aSource, bSource, Target, Count); END;

(*----------------------------------------------------------------------------*)
Procedure CIELABToBGR_P( const Source, Target : Pointer; const Count : Cardinal);
Begin JclGraphUtils.CIELABToBGR(Source, Target, Count); END;

(*----------------------------------------------------------------------------*)
Procedure CMYKToBGR1_P( const C, M, Y, K, Target : Pointer; const BitsPerSample : Byte; Count : Cardinal);
Begin JclGraphUtils.CMYKToBGR(C, M, Y, K, Target, BitsPerSample, Count); END;

(*----------------------------------------------------------------------------*)
Procedure CMYKToBGR_P( const Source, Target : Pointer; const BitsPerSample : Byte; Count : Cardinal);
Begin JclGraphUtils.CMYKToBGR(Source, Target, BitsPerSample, Count); END;

(*----------------------------------------------------------------------------*)
Function ClipLine1_P( var X1, Y1, X2, Y2 : Float; const MinX, MinY, MaxX, MaxY : Float; const Codes : PClipCodes) : Boolean;
Begin Result := JclGraphUtils.ClipLine(X1, Y1, X2, Y2, MinX, MinY, MaxX, MaxY, Codes); END;

(*----------------------------------------------------------------------------*)
Function ClipLine_P( var X1, Y1, X2, Y2 : Integer; const ClipRect : TRect) : Boolean;
Begin Result := JclGraphUtils.ClipLine(X1, Y1, X2, Y2, ClipRect); END;

(*----------------------------------------------------------------------------*)
Function ClipCodes1_P( const X, Y : Float; const ClipRect : TRect) : TClipCodes;
Begin Result := JclGraphUtils.ClipCodes(X, Y, ClipRect); END;

(*----------------------------------------------------------------------------*)
Function ClipCodes_P( const X, Y, MinX, MinY, MaxX, MaxY : Float) : TClipCodes;
Begin Result := JclGraphUtils.ClipCodes(X, Y, MinX, MinY, MaxX, MaxY); END;

(*----------------------------------------------------------------------------*)
procedure RIRegister_JclGraphUtils_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@EMMS, 'EMMS', cdRegister);
 S.RegisterDelphiFunction(@DialogUnitsToPixelsX, 'DialogUnitsToPixelsX', cdRegister);
 S.RegisterDelphiFunction(@DialogUnitsToPixelsY, 'DialogUnitsToPixelsY', cdRegister);
 S.RegisterDelphiFunction(@PixelsToDialogUnitsX, 'PixelsToDialogUnitsX', cdRegister);
 S.RegisterDelphiFunction(@PixelsToDialogUnitsY, 'PixelsToDialogUnitsY', cdRegister);
 S.RegisterDelphiFunction(@NullPoint, 'NullPoint', cdRegister);
 S.RegisterDelphiFunction(@PointAssign, 'PointAssign', cdRegister);
 S.RegisterDelphiFunction(@PointCopy, 'PointCopy', cdRegister);
 S.RegisterDelphiFunction(@PointEqual, 'PointEqual', cdRegister);
 S.RegisterDelphiFunction(@PointIsNull, 'PointIsNull', cdRegister);
 S.RegisterDelphiFunction(@PointMove, 'PointMove', cdRegister);
 S.RegisterDelphiFunction(@NullRect, 'NullRect', cdRegister);
 S.RegisterDelphiFunction(@RectAssign, 'RectAssign', cdRegister);
 S.RegisterDelphiFunction(@RectAssignPoints, 'RectAssignPoints', cdRegister);
 S.RegisterDelphiFunction(@RectBounds, 'RectBounds', cdRegister);
 S.RegisterDelphiFunction(@RectCenter, 'RectCenter', cdRegister);
 S.RegisterDelphiFunction(@RectCopy, 'RectCopy', cdRegister);
 S.RegisterDelphiFunction(@RectFitToScreen, 'RectFitToScreen', cdRegister);
 S.RegisterDelphiFunction(@RectGrow, 'RectGrow', cdRegister);
 S.RegisterDelphiFunction(@RectGrowX, 'RectGrowX', cdRegister);
 S.RegisterDelphiFunction(@RectGrowY, 'RectGrowY', cdRegister);
 S.RegisterDelphiFunction(@RectEqual, 'RectEqual', cdRegister);
 S.RegisterDelphiFunction(@RectHeight, 'RectHeight', cdRegister);
 S.RegisterDelphiFunction(@RectIncludesPoint, 'RectIncludesPoint', cdRegister);
 S.RegisterDelphiFunction(@RectIncludesRect, 'RectIncludesRect', cdRegister);
 S.RegisterDelphiFunction(@RectIntersection, 'RectIntersection', cdRegister);
 S.RegisterDelphiFunction(@RectIntersectRect, 'RectIntersectRect', cdRegister);
 S.RegisterDelphiFunction(@RectIsEmpty, 'RectIsEmpty', cdRegister);
 S.RegisterDelphiFunction(@RectIsNull, 'RectIsNull', cdRegister);
 S.RegisterDelphiFunction(@RectIsSquare, 'RectIsSquare', cdRegister);
 S.RegisterDelphiFunction(@RectIsValid, 'RectIsValid', cdRegister);
 S.RegisterDelphiFunction(@RectMove, 'RectMove', cdRegister);
 S.RegisterDelphiFunction(@RectMoveTo, 'RectMoveTo', cdRegister);
 S.RegisterDelphiFunction(@RectNormalize, 'RectNormalize', cdRegister);
 S.RegisterDelphiFunction(@RectsAreValid, 'RectsAreValid', cdRegister);
 S.RegisterDelphiFunction(@RectUnion, 'RectUnion', cdRegister);
 S.RegisterDelphiFunction(@RectWidth, 'RectWidth', cdRegister);
 S.RegisterDelphiFunction(@ClipCodes, 'ClipCodes', cdRegister);
 S.RegisterDelphiFunction(@ClipCodes1_P, 'ClipCodes1', cdRegister);
 S.RegisterDelphiFunction(@ClipLine, 'ClipLine', cdRegister);
 S.RegisterDelphiFunction(@ClipLine1_P, 'ClipLine1', cdRegister);
 S.RegisterDelphiFunction(@DrawPolyLine, 'DrawPolyLine', cdRegister);
 S.RegisterDelphiFunction(@DrawPlot, 'DrawPlot', cdRegister);
 S.RegisterDelphiFunction(@GetRGBValue, 'GetRGBValue', cdRegister);
 S.RegisterDelphiFunction(@SetRGBValue, 'SetRGBValue', cdRegister);
 S.RegisterDelphiFunction(@GetColorBlue, 'GetColorBlue', cdRegister);
 S.RegisterDelphiFunction(@GetColorFlag, 'GetColorFlag', cdRegister);
 S.RegisterDelphiFunction(@GetColorGreen, 'GetColorGreen', cdRegister);
 S.RegisterDelphiFunction(@GetColorRed, 'GetColorRed', cdRegister);
 S.RegisterDelphiFunction(@SetColorBlue, 'SetColorBlue', cdRegister);
 S.RegisterDelphiFunction(@SetColorFlag, 'SetColorFlag', cdRegister);
 S.RegisterDelphiFunction(@SetColorGreen, 'SetColorGreen', cdRegister);
 S.RegisterDelphiFunction(@SetColorRed, 'SetColorRed', cdRegister);
 S.RegisterDelphiFunction(@BrightColor, 'BrightColor', cdRegister);
 S.RegisterDelphiFunction(@BrightColorChannel, 'BrightColorChannel', cdRegister);
 S.RegisterDelphiFunction(@DarkColor, 'DarkColor', cdRegister);
 S.RegisterDelphiFunction(@DarkColorChannel, 'DarkColorChannel', cdRegister);
 S.RegisterDelphiFunction(@CIED65ToCIED50, 'CIED65ToCIED50', cdRegister);
 {S.RegisterDelphiFunction(@CMYKToBGR, 'CMYKToBGR', cdRegister);
 S.RegisterDelphiFunction(@CMYKToBGR1_P, 'CMYKToBGR1', cdRegister);
 S.RegisterDelphiFunction(@CIELABToBGR, 'CIELABToBGR', cdRegister);
 S.RegisterDelphiFunction(@CIELABToBGR1_P, 'CIELABToBGR1', cdRegister);
 S.RegisterDelphiFunction(@RGBToBGR, 'RGBToBGR', cdRegister);
 S.RegisterDelphiFunction(@RGBToBGR1_P, 'RGBToBGR1', cdRegister);
 S.RegisterDelphiFunction(@RGBAToBGRA, 'RGBAToBGRA', cdRegister); }
 S.RegisterDelphiFunction(@WinColorToOpenGLColor, 'WinColorToOpenGLColor', cdRegister);
 S.RegisterDelphiFunction(@OpenGLColorToWinColor, 'OpenGLColorToWinColor', cdRegister);
 S.RegisterDelphiFunction(@Color32, 'Color32', cdRegister);
 S.RegisterDelphiFunction(@Color32, 'Color32', cdRegister);
 S.RegisterDelphiFunction(@Color321_P, 'Color321', cdRegister);
 S.RegisterDelphiFunction(@Gray32, 'Gray32', cdRegister);
 S.RegisterDelphiFunction(@WinColor, 'WinColor', cdRegister);
 S.RegisterDelphiFunction(@RedComponent, 'RedComponent', cdRegister);
 S.RegisterDelphiFunction(@GreenComponent, 'GreenComponent', cdRegister);
 S.RegisterDelphiFunction(@BlueComponent, 'BlueComponent', cdRegister);
 S.RegisterDelphiFunction(@AlphaComponent, 'AlphaComponent', cdRegister);
 S.RegisterDelphiFunction(@Intensity, 'Intensity', cdRegister);
 S.RegisterDelphiFunction(@Intensity, 'Intensity', cdRegister);
 S.RegisterDelphiFunction(@SetAlpha, 'SetAlpha', cdRegister);
 S.RegisterDelphiFunction(@HSLToRGB, 'HSLToRGB', cdRegister);
 S.RegisterDelphiFunction(@HSLToRGB1_P, 'HSLToRGB1', cdRegister);
 S.RegisterDelphiFunction(@RGBToHSL, 'RGBToHSL', cdRegister);
 S.RegisterDelphiFunction(@RGBToHSL1_P, 'RGBToHSL1', cdRegister);
 S.RegisterDelphiFunction(@ColorToHTML, 'ColorToHTML', cdRegister);
 S.RegisterDelphiFunction(@DottedLineTo, 'DottedLineTo', cdRegister);
 S.RegisterDelphiFunction(@ShortenString, 'ShortenString', cdRegister);
end;

 
 
{ TPSImport_JclGraphUtils }
(*----------------------------------------------------------------------------*)
procedure TPSImport_JclGraphUtils.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_JclGraphUtils(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_JclGraphUtils.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  //RIRegister_JclGraphUtils(ri);
  RIRegister_JclGraphUtils_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
