unit uPSI_JclGraphics;
{
   add more override
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
  TPSImport_JclGraphics = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TJclLinearTransformation(CL: TPSPascalCompiler);
procedure SIRegister_TJclTransformation(CL: TPSPascalCompiler);
procedure SIRegister_TJclByteMap(CL: TPSPascalCompiler);
procedure SIRegister_TJclBitmap32(CL: TPSPascalCompiler);
procedure SIRegister_TJclCustomMap(CL: TPSPascalCompiler);
procedure SIRegister_TJclThreadPersistent(CL: TPSPascalCompiler);
procedure SIRegister_TJclRegion(CL: TPSPascalCompiler);
procedure SIRegister_TJclRegionInfo(CL: TPSPascalCompiler);
procedure SIRegister_TJclDesktopCanvas(CL: TPSPascalCompiler);
procedure SIRegister_JclGraphics(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_JclGraphics_Routines(S: TPSExec);
procedure RIRegister_TJclLinearTransformation(CL: TPSRuntimeClassImporter);
procedure RIRegister_TJclTransformation(CL: TPSRuntimeClassImporter);
procedure RIRegister_TJclByteMap(CL: TPSRuntimeClassImporter);
procedure RIRegister_TJclBitmap32(CL: TPSRuntimeClassImporter);
procedure RIRegister_TJclCustomMap(CL: TPSRuntimeClassImporter);
procedure RIRegister_TJclThreadPersistent(CL: TPSRuntimeClassImporter);
procedure RIRegister_TJclRegion(CL: TPSRuntimeClassImporter);
procedure RIRegister_TJclRegionInfo(CL: TPSRuntimeClassImporter);
procedure RIRegister_TJclDesktopCanvas(CL: TPSRuntimeClassImporter);
procedure RIRegister_JclGraphics(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   Windows
  ,Graphics
  ,JclBase
  ,JclGraphUtils
  ,JclSynch
  ,JclGraphics
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_JclGraphics]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TJclLinearTransformation(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TJclTransformation', 'TJclLinearTransformation') do
  with CL.AddClassN(CL.FindClass('TJclTransformation'),'TJclLinearTransformation') do
  begin
    RegisterMethod('Constructor Create');
    RegisterMethod('Procedure Clear');
    RegisterMethod('Procedure Rotate( Cx, Cy, Alpha : Extended)');
    RegisterMethod('Procedure Skew( Fx, Fy : Extended)');
    RegisterMethod('Procedure Scale( Sx, Sy : Extended)');
    RegisterMethod('Procedure Translate( Dx, Dy : Extended)');
    RegisterProperty('Matrix', 'TMatrix3d', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TJclTransformation(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TObject', 'TJclTransformation') do
  with CL.AddClassN(CL.FindClass('TObject'),'TJclTransformation') do
  begin
    RegisterMethod('Function GetTransformedBounds( const Src : TRect) : TRect');
    RegisterMethod('Procedure PrepareTransform');
    RegisterMethod('Procedure Transform( DstX, DstY : Integer; out SrcX, SrcY : Integer)');
    RegisterMethod('Procedure Transform256( DstX, DstY : Integer; out SrcX256, SrcY256 : Integer)');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TJclByteMap(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TJclCustomMap', 'TJclByteMap') do
  with CL.AddClassN(CL.FindClass('TJclCustomMap'),'TJclByteMap') do begin
    RegisterMethod('Procedure Clear( FillValue : Byte)');
     RegisterMethod('Procedure Assign( Source : TPersistent)');
    RegisterMethod('Procedure SetSize( NewWidth, NewHeight : Integer)');
    RegisterMethod('Function Empty : Boolean');
    RegisterMethod('Procedure ReadFrom( Source : TJclBitmap32; Conversion : TConversionKind)');
    RegisterMethod('Procedure WriteTo( Dest : TJclBitmap32; Conversion : TConversionKind);');
    RegisterMethod('Procedure WriteTo1( Dest : TJclBitmap32; const Palette : TPalette32);');
    RegisterProperty('Bytes', 'TDynByteArray', iptr);
    RegisterProperty('ValPtr', 'PByte Integer Integer', iptr);
    RegisterProperty('Value', 'Byte Integer Integer', iptrw);
    SetDefaultPropery('Value');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TJclBitmap32(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TJclCustomMap', 'TJclBitmap32') do
  with CL.AddClassN(CL.FindClass('TJclCustomMap'),'TJclBitmap32') do begin
    RegisterMethod('Constructor Create');
    RegisterMethod('Procedure Free');
    RegisterMethod('Procedure Assign( Source : TPersistent)');
    RegisterMethod('Procedure SetSize( NewWidth, NewHeight : Integer)');
    RegisterMethod('Function Empty : Boolean');
    RegisterMethod('Procedure Clear');
    RegisterMethod('Procedure Clear1( FillColor : TColor32)');
    RegisterMethod('Procedure Delete');
    RegisterMethod('Procedure LoadFromStream( Stream : TStream)');
    RegisterMethod('Procedure SaveToStream( Stream : TStream)');
    RegisterMethod('Procedure LoadFromFile( const FileName : string)');
    RegisterMethod('Procedure SaveToFile( const FileName : string)');
    RegisterMethod('Procedure ResetAlpha');
    RegisterMethod('Procedure Draw( DstX, DstY : Integer; Src : TJclBitmap32);');
    RegisterMethod('Procedure Draw1( DstRect, SrcRect : TRect; Src : TJclBitmap32);');
    RegisterMethod('Procedure Draw2( DstRect, SrcRect : TRect; hSrc : HDC);');
    RegisterMethod('Procedure DrawTo( Dst : TJclBitmap32);');
    RegisterMethod('Procedure DrawTo1( Dst : TJclBitmap32; DstX, DstY : Integer);');
    RegisterMethod('Procedure DrawTo2( Dst : TJclBitmap32; DstRect : TRect);');
    RegisterMethod('Procedure DrawTo3( Dst : TJclBitmap32; DstRect, SrcRect : TRect);');
    RegisterMethod('Procedure DrawTo4( hDst : HDC; DstX, DstY : Integer);');
    RegisterMethod('Procedure DrawTo5( hDst : HDC; DstRect, SrcRect : TRect);');
    RegisterMethod('Function GetPixelB( X, Y : Integer) : TColor32');
    RegisterMethod('Procedure SetPixelT( X, Y : Integer; Value : TColor32);');
    RegisterMethod('Procedure SetPixelT1( var Ptr : PColor32; Value : TColor32);');
    RegisterMethod('Procedure SetPixelTS( X, Y : Integer; Value : TColor32)');
    RegisterMethod('Procedure SetPixelF( X, Y : Single; Value : TColor32)');
    RegisterMethod('Procedure SetPixelFS( X, Y : Single; Value : TColor32)');
    RegisterMethod('Procedure SetStipple( NewStipple : TArrayOfColor32);');
    RegisterMethod('Procedure SetStipple1( NewStipple : array of TColor32);');
    RegisterMethod('Procedure SetStippleStep( Value : Single)');
    RegisterMethod('Procedure ResetStippleCounter');
    RegisterMethod('Function GetStippleColor : TColor32');
    RegisterMethod('Procedure DrawHorzLine( X1, Y, X2 : Integer; Value : TColor32)');
    RegisterMethod('Procedure DrawHorzLineS( X1, Y, X2 : Integer; Value : TColor32)');
    RegisterMethod('Procedure DrawHorzLineT( X1, Y, X2 : Integer; Value : TColor32)');
    RegisterMethod('Procedure DrawHorzLineTS( X1, Y, X2 : Integer; Value : TColor32)');
    RegisterMethod('Procedure DrawHorzLineTSP( X1, Y, X2 : Integer)');
    RegisterMethod('Procedure DrawVertLine( X, Y1, Y2 : Integer; Value : TColor32)');
    RegisterMethod('Procedure DrawVertLineS( X, Y1, Y2 : Integer; Value : TColor32)');
    RegisterMethod('Procedure DrawVertLineT( X, Y1, Y2 : Integer; Value : TColor32)');
    RegisterMethod('Procedure DrawVertLineTS( X, Y1, Y2 : Integer; Value : TColor32)');
    RegisterMethod('Procedure DrawVertLineTSP( X, Y1, Y2 : Integer)');
    RegisterMethod('Procedure DrawLine( X1, Y1, X2, Y2 : Integer; Value : TColor32; L : Boolean)');
    RegisterMethod('Procedure DrawLineS( X1, Y1, X2, Y2 : Integer; Value : TColor32; L : Boolean)');
    RegisterMethod('Procedure DrawLineT( X1, Y1, X2, Y2 : Integer; Value : TColor32; L : Boolean)');
    RegisterMethod('Procedure DrawLineTS( X1, Y1, X2, Y2 : Integer; Value : TColor32; L : Boolean)');
    RegisterMethod('Procedure DrawLineA( X1, Y1, X2, Y2 : Integer; Value : TColor32; L : Boolean)');
    RegisterMethod('Procedure DrawLineAS( X1, Y1, X2, Y2 : Integer; Value : TColor32; L : Boolean)');
    RegisterMethod('Procedure DrawLineF( X1, Y1, X2, Y2 : Single; Value : TColor32; L : Boolean)');
    RegisterMethod('Procedure DrawLineFS( X1, Y1, X2, Y2 : Single; Value : TColor32; L : Boolean)');
    RegisterMethod('Procedure DrawLineFP( X1, Y1, X2, Y2 : Single; L : Boolean)');
    RegisterMethod('Procedure DrawLineFSP( X1, Y1, X2, Y2 : Single; L : Boolean)');
    RegisterMethod('Procedure MoveTo( X, Y : Integer)');
    RegisterMethod('Procedure LineToS( X, Y : Integer)');
    RegisterMethod('Procedure LineToTS( X, Y : Integer)');
    RegisterMethod('Procedure LineToAS( X, Y : Integer)');
    RegisterMethod('Procedure MoveToF( X, Y : Single)');
    RegisterMethod('Procedure LineToFS( X, Y : Single)');
    RegisterMethod('Procedure FillRect( X1, Y1, X2, Y2 : Integer; Value : TColor32)');
    RegisterMethod('Procedure FillRectS( X1, Y1, X2, Y2 : Integer; Value : TColor32)');
    RegisterMethod('Procedure FillRectT( X1, Y1, X2, Y2 : Integer; Value : TColor32)');
    RegisterMethod('Procedure FillRectTS( X1, Y1, X2, Y2 : Integer; Value : TColor32)');
    RegisterMethod('Procedure FrameRectS( X1, Y1, X2, Y2 : Integer; Value : TColor32)');
    RegisterMethod('Procedure FrameRectTS( X1, Y1, X2, Y2 : Integer; Value : TColor32);');
    RegisterMethod('Procedure FrameRectTSP( X1, Y1, X2, Y2 : Integer);');
    RegisterMethod('Procedure RaiseRectTS( X1, Y1, X2, Y2 : Integer; Contrast : Integer)');
    RegisterMethod('Procedure UpdateFont');
    RegisterMethod('Procedure TextOut( X, Y : Integer; const Text : string);');
    RegisterMethod('Procedure TextOut1( X, Y : Integer; const ClipRect : TRect; const Text : string);');
    RegisterMethod('Procedure TextOut2( ClipRect : TRect; const Flags : Cardinal; const Text : string);');
    RegisterMethod('Function TextExtent( const Text : string) : TSize');
    RegisterMethod('Function TextHeight( const Text : string) : Integer');
    RegisterMethod('Function TextWidth( const Text : string) : Integer');
    RegisterMethod('Procedure RenderText( X, Y : Integer; const Text : string; AALevel : Integer; Color : TColor32)');
    RegisterProperty('BitmapHandle', 'HBITMAP', iptr);
    RegisterProperty('BitmapInfo', 'TBitmapInfo', iptr);
    RegisterProperty('Bits', 'PColor32Array', iptr);
    RegisterProperty('Font', 'TFont', iptrw);
    RegisterProperty('Handle', 'HDC', iptr);
    RegisterProperty('PenColor', 'TColor32', iptrw);
    RegisterProperty('Pixel', 'TColor32 Integer Integer', iptrw);
    SetDefaultPropery('Pixel');
    RegisterProperty('PixelS', 'TColor32 Integer Integer', iptrw);
    RegisterProperty('PixelPtr', 'PColor32 Integer Integer', iptr);
    RegisterProperty('ScanLine', 'PColor32Array Integer', iptr);
    RegisterProperty('DrawMode', 'TDrawMode', iptrw);
    RegisterProperty('MasterAlpha', 'Byte', iptrw);
    RegisterProperty('OuterColor', 'TColor32', iptrw);
    RegisterProperty('StretchFilter', 'TStretchFilter', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TJclCustomMap(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TJclThreadPersistent', 'TJclCustomMap') do
  with CL.AddClassN(CL.FindClass('TJclThreadPersistent'),'TJclCustomMap') do begin
    RegisterMethod('Procedure Delete');
    RegisterMethod('Function Empty : Boolean');
    RegisterMethod('Procedure SetSize( Source : TPersistent);');
    RegisterMethod('Procedure SetSize1( NewWidth, NewHeight : Integer);');
    RegisterProperty('Height', 'Integer', iptrw);
    RegisterProperty('Width', 'Integer', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TJclThreadPersistent(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TPersistent', 'TJclThreadPersistent') do
  with CL.AddClassN(CL.FindClass('TPersistent'),'TJclThreadPersistent') do begin
    RegisterMethod('Constructor Create');
    RegisterMethod('Procedure Changing');
    RegisterMethod('Procedure Changed');
    RegisterMethod('Procedure BeginUpdate');
    RegisterMethod('Procedure EndUpdate');
    RegisterMethod('Procedure Lock');
    RegisterMethod('Procedure Unlock');
    RegisterProperty('OnChanging', 'TNotifyEvent', iptrw);
    RegisterProperty('OnChange', 'TNotifyEvent', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TJclRegion(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TObject', 'TJclRegion') do
  with CL.AddClassN(CL.FindClass('TObject'),'TJclRegion') do begin
    RegisterMethod('Constructor Create( RegionHandle : HRGN)');
    RegisterMethod('Procedure Free');
    RegisterMethod('Constructor CreateElliptic( const ARect : TRect);');
    RegisterMethod('Constructor CreateElliptic1( Top, Left, Bottom, Right : Integer);');
    RegisterMethod('Constructor CreatePoly( const Points : TDynPointArray; Count : Integer; FillMode : TPolyFillMode)');
    RegisterMethod('Constructor CreatePolyPolygon( const Points : TDynPointArray; const Vertex : TDynIntegerArray; Count : Integer; FillMode : TPolyFillMode)');
    RegisterMethod('Constructor CreateRect( const Top, Left, Bottom, Right : Integer);');
    RegisterMethod('Constructor CreateRect1( ARect : TRect);');
    RegisterMethod('Constructor CreateRoundRect( const ARect : TRect; CornerWidth, CornerHeight : Integer);');
    RegisterMethod('Constructor CreateRoundRect1( Top, Left, Bottom, Right : Integer; CornerWidth, CornerHeight : Integer);');
    RegisterMethod('Constructor CreateBitmap( Bitmap : TBitmap; RegionColor : TColor; RegionBitmapMode : TJclRegionBitmapMode)');
    RegisterMethod('Constructor CreatePath( Canvas : TCanvas)');
    RegisterMethod('Constructor CreateRegionInfo( RegionInfo : TJclRegionInfo)');
    RegisterMethod('Procedure Clip( Canvas : TCanvas)');
    RegisterMethod('Procedure Combine( DestRegion, SrcRegion : TJclRegion; CombineOp : TJclRegionCombineOperator);');
    RegisterMethod('Procedure Combine1( SrcRegion : TJclRegion; CombineOp : TJclRegionCombineOperator);');
    RegisterMethod('Function Copy : TJclRegion');
    RegisterMethod('Function Equals( CompareRegion : TJclRegion) : Boolean');
    RegisterMethod('Procedure Fill( Canvas : TCanvas)');
    RegisterMethod('Procedure FillGradient( Canvas : TCanvas; ColorCount : Integer; StartColor, EndColor : TColor; ADirection : TGradientDirection)');
    RegisterMethod('Procedure Frame( Canvas : TCanvas; FrameWidth, FrameHeight : Integer)');
    RegisterMethod('Procedure Invert( Canvas : TCanvas)');
    RegisterMethod('Procedure Offset( X, Y : Integer)');
    RegisterMethod('Procedure Paint( Canvas : TCanvas)');
    RegisterMethod('Function PointIn( X, Y : Integer) : Boolean;');
    RegisterMethod('Function PointIn1( const Point : TPoint) : Boolean;');
    RegisterMethod('Function RectIn( const ARect : TRect) : Boolean;');
    RegisterMethod('Function RectIn1( Top, Left, Bottom, Right : Integer) : Boolean;');
    RegisterMethod('Procedure SetWindow( Window : HWND; Redraw : Boolean)');
    RegisterMethod('Function GetRegionInfo : TJclRegionInfo');
    RegisterProperty('Box', 'TRect', iptr);
    RegisterProperty('Handle', 'HRGN', iptr);
    RegisterProperty('RegionType', 'TJclRegionKind', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TJclRegionInfo(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TObject', 'TJclRegionInfo') do
  with CL.AddClassN(CL.FindClass('TObject'),'TJclRegionInfo') do begin
    RegisterMethod('Constructor Create( Region : TJclRegion)');
    RegisterMethod('Procedure Free');
    RegisterProperty('Box', 'TRect', iptr);
    RegisterProperty('Rectangles', 'TRect Integer', iptr);
    RegisterProperty('Count', 'Integer', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TJclDesktopCanvas(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TCanvas', 'TJclDesktopCanvas') do
  with CL.AddClassN(CL.FindClass('TCanvas'),'TJclDesktopCanvas') do begin
    RegisterMethod('Constructor Create');
    RegisterMethod('Procedure Free');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_JclGraphics(CL: TPSPascalCompiler);
begin
  CL.AddClassN(CL.FindClass('TOBJECT'),'EJclGraphicsError');
  CL.AddTypeS('TDynDynIntegerArrayArray', 'array of TDynIntegerArray');
  CL.AddTypeS('TDynPointArray', 'array of TPoint');
  CL.AddTypeS('TDynDynPointArrayArray', 'array of TDynPointArray');
  CL.AddTypeS('TPointF', 'record X : Single; Y : Single; end');
  CL.AddTypeS('TDynPointArrayF', 'array of TPointF');
  CL.AddTypeS('TDrawMode2', '( dmOpaque, dmBlend )');
  CL.AddTypeS('TStretchFilter2', '( sfNearest, sfLinear, sfSpline )');
  CL.AddTypeS('TConversionKind', '( ckRed, ckGreen, ckBlue, ckAlpha, ckUniformRGB, ckWeightedRGB )');
  CL.AddTypeS('TResamplingFilter', '( rfBox, rfTriangle, rfHermite, rfBell, rfS'
   +'pline, rfLanczos3, rfMitchell )');
   //A: array [0..2][0..2] of Extended;
  CL.AddTypeS('TMatrix3d2', 'array[0..2] of extended;');

  CL.AddTypeS('TMatrix3d', 'record A: array[0..2] of TMatrix3d2; end');
  CL.AddTypeS('TDynDynPointArrayArrayF', 'array of TDynPointArrayF');
  CL.AddTypeS('TScanLine', 'array of Integer');
  CL.AddTypeS('TScanLines', 'array of TScanLine');
  CL.AddTypeS('TColorChannel', '( ccRed, ccGreen, ccBlue, ccAlpha )');
  CL.AddTypeS('TGradientDirection', '( gdVertical, gdHorizontal )');
  CL.AddTypeS('TPolyFillMode', '( fmAlternate, fmWinding )');
  CL.AddTypeS('TJclRegionCombineOperator', '( coAnd, coDiff, coOr, coXor )');
  CL.AddTypeS('TJclRegionBitmapMode', '( rmInclude, rmExclude )');
  CL.AddTypeS('TJclRegionKind', '( rkNull, rkSimple, rkComplex, rkError )');
  CL.AddTypeS('TLUT8', 'array[0..255] of Byte');
  CL.AddTypeS('TGamma', 'array[0..255] of Byte');

  // TLUT8 = array [Byte] of Byte;
  //TGamma = array [Byte] of Byte;

  SIRegister_TJclDesktopCanvas(CL);
  CL.AddClassN(CL.FindClass('TOBJECT'),'TJclRegion');
  SIRegister_TJclRegionInfo(CL);
  SIRegister_TJclRegion(CL);
  SIRegister_TJclThreadPersistent(CL);
  SIRegister_TJclCustomMap(CL);
  SIRegister_TJclBitmap32(CL);
  SIRegister_TJclByteMap(CL);
  SIRegister_TJclTransformation(CL);
  SIRegister_TJclLinearTransformation(CL);
 CL.AddDelphiFunction('Procedure Stretch( NewWidth, NewHeight : Cardinal; Filter : TResamplingFilter; Radius : Single; Source : TGraphic; Target : TBitmap);');
 CL.AddDelphiFunction('Procedure Stretch1( NewWidth, NewHeight : Cardinal; Filter : TResamplingFilter; Radius : Single; Bitmap : TBitmap);');
 CL.AddDelphiFunction('Procedure DrawBitmap( DC : HDC; Bitmap : HBitMap; X, Y, Width, Height : Integer)');
 CL.AddDelphiFunction('Function GetAntialiasedBitmap( const Bitmap : TBitmap) : TBitmap');
 CL.AddDelphiFunction('Procedure BitmapToJPeg( const FileName : string)');
 CL.AddDelphiFunction('Procedure JPegToBitmap( const FileName : string)');
 CL.AddDelphiFunction('Function ExtractIconCount( const FileName : string) : Integer');
 CL.AddDelphiFunction('Function BitmapToIconJ( Bitmap : HBITMAP; cx, cy : Integer) : HICON');
 CL.AddDelphiFunction('Function IconToBitmapJ( Icon : HICON) : HBITMAP');
 CL.AddDelphiFunction('Procedure BlockTransfer( Dst : TJclBitmap32; DstX : Integer; DstY : Integer; Src : TJclBitmap32; SrcRect : TRect; CombineOp : TDrawMode2)');
 CL.AddDelphiFunction('Procedure StretchTransfer( Dst : TJclBitmap32; DstRect : TRect; Src : TJclBitmap32; SrcRect : TRect; StretchFilter : TStretchFilter2; CombineOp : TDrawMode2)');
 CL.AddDelphiFunction('Procedure Transform( Dst, Src : TJclBitmap32; SrcRect : TRect; Transformation : TJclTransformation)');
 CL.AddDelphiFunction('Procedure SetBorderTransparent( ABitmap : TJclBitmap32; ARect : TRect)');
 CL.AddDelphiFunction('Function FillGradient( DC : HDC; ARect : TRect; ColorCount : Integer; StartColor, EndColor : TColor; ADirection : TGradientDirection) : Boolean;');
 CL.AddDelphiFunction('Function CreateRegionFromBitmap( Bitmap : TBitmap; RegionColor : TColor; RegionBitmapMode : TJclRegionBitmapMode) : HRGN');
 CL.AddDelphiFunction('Procedure ScreenShot( bm : TBitmap; Left, Top, Width, Height : Integer; Window : HWND);');
 CL.AddDelphiFunction('Procedure ScreenShot1( bm : TBitmap);');
 CL.AddDelphiFunction('Procedure PolyLineTS( Bitmap : TJclBitmap32; const Points : TDynPointArray; Color : TColor32)');
 CL.AddDelphiFunction('Procedure PolyLineAS( Bitmap : TJclBitmap32; const Points : TDynPointArray; Color : TColor32)');
 CL.AddDelphiFunction('Procedure PolyLineFS( Bitmap : TJclBitmap32; const Points : TDynPointArrayF; Color : TColor32)');
 CL.AddDelphiFunction('Procedure PolygonTS( Bitmap : TJclBitmap32; const Points : TDynPointArray; Color : TColor32)');
 CL.AddDelphiFunction('Procedure PolygonAS( Bitmap : TJclBitmap32; const Points : TDynPointArray; Color : TColor32)');
 CL.AddDelphiFunction('Procedure PolygonFS( Bitmap : TJclBitmap32; const Points : TDynPointArrayF; Color : TColor32)');
 CL.AddDelphiFunction('Procedure PolyPolygonTS( Bitmap : TJclBitmap32; const Points : TDynDynPointArrayArray; Color : TColor32)');
 CL.AddDelphiFunction('Procedure PolyPolygonAS( Bitmap : TJclBitmap32; const Points : TDynDynPointArrayArray; Color : TColor32)');
 CL.AddDelphiFunction('Procedure PolyPolygonFS( Bitmap : TJclBitmap32; const Points : TDynDynPointArrayArrayF; Color : TColor32)');
 CL.AddDelphiFunction('Procedure AlphaToGrayscale( Dst, Src : TJclBitmap32)');
 CL.AddDelphiFunction('Procedure IntensityToAlpha( Dst, Src : TJclBitmap32)');
 CL.AddDelphiFunction('Procedure Invert( Dst, Src : TJclBitmap32)');
 CL.AddDelphiFunction('Procedure InvertRGB( Dst, Src : TJclBitmap32)');
 CL.AddDelphiFunction('Procedure ColorToGrayscale( Dst, Src : TJclBitmap32)');
 CL.AddDelphiFunction('Procedure ApplyLUT( Dst, Src : TJclBitmap32; const LUT : TLUT8)');
 CL.AddDelphiFunction('Procedure SetGamma( Gamma : Single)');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
Procedure ScreenShot1_P( bm : TBitmap);
Begin JclGraphics.ScreenShot(bm); END;

(*----------------------------------------------------------------------------*)
Procedure ScreenShot_P( bm : TBitmap; Left, Top, Width, Height : Integer; Window : HWND);
Begin JclGraphics.ScreenShot(bm, Left, Top, Width, Height, Window); END;

(*----------------------------------------------------------------------------*)
Function FillGradient_P( DC : HDC; ARect : TRect; ColorCount : Integer; StartColor, EndColor : TColor; ADirection : TGradientDirection) : Boolean;
Begin Result := JclGraphics.FillGradient(DC, ARect, ColorCount, StartColor, EndColor, ADirection); END;

(*----------------------------------------------------------------------------*)
Procedure Stretch1_P( NewWidth, NewHeight : Cardinal; Filter : TResamplingFilter; Radius : Single; Bitmap : TBitmap);
Begin JclGraphics.Stretch(NewWidth, NewHeight, Filter, Radius, Bitmap); END;

(*----------------------------------------------------------------------------*)
Procedure Stretch_P( NewWidth, NewHeight : Cardinal; Filter : TResamplingFilter; Radius : Single; Source : TGraphic; Target : TBitmap);
Begin JclGraphics.Stretch(NewWidth, NewHeight, Filter, Radius, Source, Target); END;

(*----------------------------------------------------------------------------*)
procedure TJclLinearTransformationMatrix_W(Self: TJclLinearTransformation; const T: TMatrix3d);
begin Self.Matrix := T; end;

(*----------------------------------------------------------------------------*)
procedure TJclLinearTransformationMatrix_R(Self: TJclLinearTransformation; var T: TMatrix3d);
begin T := Self.Matrix; end;

(*----------------------------------------------------------------------------*)
procedure TJclByteMapValue_W(Self: TJclByteMap; const T: Byte; const t1: Integer; const t2: Integer);
begin Self.Value[t1, t2] := T; end;

(*----------------------------------------------------------------------------*)
procedure TJclByteMapValue_R(Self: TJclByteMap; var T: Byte; const t1: Integer; const t2: Integer);
begin T := Self.Value[t1, t2]; end;

(*----------------------------------------------------------------------------*)
procedure TJclByteMapValPtr_R(Self: TJclByteMap; var T: PByte; const t1: Integer; const t2: Integer);
begin T := Self.ValPtr[t1, t2]; end;

(*----------------------------------------------------------------------------*)
procedure TJclByteMapBytes_R(Self: TJclByteMap; var T: TDynByteArray);
begin T := Self.Bytes; end;

(*----------------------------------------------------------------------------*)
Procedure TJclByteMapWriteTo1_P(Self: TJclByteMap;  Dest : TJclBitmap32; const Palette : TPalette32);
Begin Self.WriteTo(Dest, Palette); END;

(*----------------------------------------------------------------------------*)
Procedure TJclByteMapWriteTo_P(Self: TJclByteMap;  Dest : TJclBitmap32; Conversion : TConversionKind);
Begin Self.WriteTo(Dest, Conversion); END;

(*----------------------------------------------------------------------------*)
procedure TJclBitmap32StretchFilter_W(Self: TJclBitmap32; const T: TStretchFilter);
begin Self.StretchFilter := T; end;

(*----------------------------------------------------------------------------*)
procedure TJclBitmap32StretchFilter_R(Self: TJclBitmap32; var T: TStretchFilter);
begin T := Self.StretchFilter; end;

(*----------------------------------------------------------------------------*)
procedure TJclBitmap32OuterColor_W(Self: TJclBitmap32; const T: TColor32);
begin Self.OuterColor := T; end;

(*----------------------------------------------------------------------------*)
procedure TJclBitmap32OuterColor_R(Self: TJclBitmap32; var T: TColor32);
begin T := Self.OuterColor; end;

(*----------------------------------------------------------------------------*)
procedure TJclBitmap32MasterAlpha_W(Self: TJclBitmap32; const T: Byte);
begin Self.MasterAlpha := T; end;

(*----------------------------------------------------------------------------*)
procedure TJclBitmap32MasterAlpha_R(Self: TJclBitmap32; var T: Byte);
begin T := Self.MasterAlpha; end;

(*----------------------------------------------------------------------------*)
procedure TJclBitmap32DrawMode_W(Self: TJclBitmap32; const T: TDrawMode);
begin Self.DrawMode := T; end;

(*----------------------------------------------------------------------------*)
procedure TJclBitmap32DrawMode_R(Self: TJclBitmap32; var T: TDrawMode);
begin T := Self.DrawMode; end;

(*----------------------------------------------------------------------------*)
procedure TJclBitmap32ScanLine_R(Self: TJclBitmap32; var T: PColor32Array; const t1: Integer);
begin T := Self.ScanLine[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TJclBitmap32PixelPtr_R(Self: TJclBitmap32; var T: PColor32; const t1: Integer; const t2: Integer);
begin T := Self.PixelPtr[t1, t2]; end;

(*----------------------------------------------------------------------------*)
procedure TJclBitmap32PixelS_W(Self: TJclBitmap32; const T: TColor32; const t1: Integer; const t2: Integer);
begin Self.PixelS[t1, t2] := T; end;

(*----------------------------------------------------------------------------*)
procedure TJclBitmap32PixelS_R(Self: TJclBitmap32; var T: TColor32; const t1: Integer; const t2: Integer);
begin T := Self.PixelS[t1, t2]; end;

(*----------------------------------------------------------------------------*)
procedure TJclBitmap32Pixel_W(Self: TJclBitmap32; const T: TColor32; const t1: Integer; const t2: Integer);
begin Self.Pixel[t1, t2] := T; end;

(*----------------------------------------------------------------------------*)
procedure TJclBitmap32Pixel_R(Self: TJclBitmap32; var T: TColor32; const t1: Integer; const t2: Integer);
begin T := Self.Pixel[t1, t2]; end;

(*----------------------------------------------------------------------------*)
procedure TJclBitmap32PenColor_W(Self: TJclBitmap32; const T: TColor32);
begin Self.PenColor := T; end;

(*----------------------------------------------------------------------------*)
procedure TJclBitmap32PenColor_R(Self: TJclBitmap32; var T: TColor32);
begin T := Self.PenColor; end;

(*----------------------------------------------------------------------------*)
procedure TJclBitmap32Handle_R(Self: TJclBitmap32; var T: HDC);
begin T := Self.Handle; end;

(*----------------------------------------------------------------------------*)
procedure TJclBitmap32Font_W(Self: TJclBitmap32; const T: TFont);
begin Self.Font := T; end;

(*----------------------------------------------------------------------------*)
procedure TJclBitmap32Font_R(Self: TJclBitmap32; var T: TFont);
begin T := Self.Font; end;

(*----------------------------------------------------------------------------*)
procedure TJclBitmap32Bits_R(Self: TJclBitmap32; var T: PColor32Array);
begin T := Self.Bits; end;

(*----------------------------------------------------------------------------*)
procedure TJclBitmap32BitmapInfo_R(Self: TJclBitmap32; var T: TBitmapInfo);
begin T := Self.BitmapInfo; end;

(*----------------------------------------------------------------------------*)
procedure TJclBitmap32BitmapHandle_R(Self: TJclBitmap32; var T: HBITMAP);
begin T := Self.BitmapHandle; end;

(*----------------------------------------------------------------------------*)
Procedure TJclBitmap32TextOut2_P(Self: TJclBitmap32;  ClipRect : TRect; const Flags : Cardinal; const Text : string);
Begin Self.TextOut(ClipRect, Flags, Text); END;

(*----------------------------------------------------------------------------*)
Procedure TJclBitmap32TextOut1_P(Self: TJclBitmap32;  X, Y : Integer; const ClipRect : TRect; const Text : string);
Begin Self.TextOut(X, Y, ClipRect, Text); END;

(*----------------------------------------------------------------------------*)
Procedure TJclBitmap32TextOut_P(Self: TJclBitmap32;  X, Y : Integer; const Text : string);
Begin Self.TextOut(X, Y, Text); END;

(*----------------------------------------------------------------------------*)
Procedure TJclBitmap32FrameRectTSP_P(Self: TJclBitmap32;  X1, Y1, X2, Y2 : Integer);
Begin Self.FrameRectTSP(X1, Y1, X2, Y2); END;

(*----------------------------------------------------------------------------*)
Procedure TJclBitmap32FrameRectTS_P(Self: TJclBitmap32;  X1, Y1, X2, Y2 : Integer; Value : TColor32);
Begin Self.FrameRectTS(X1, Y1, X2, Y2, Value); END;

(*----------------------------------------------------------------------------*)
Procedure TJclBitmap32SetStipple1_P(Self: TJclBitmap32;  NewStipple : array of TColor32);
Begin Self.SetStipple(NewStipple); END;

(*----------------------------------------------------------------------------*)
Procedure TJclBitmap32SetStipple_P(Self: TJclBitmap32;  NewStipple : TArrayOfColor32);
Begin Self.SetStipple(NewStipple); END;

(*----------------------------------------------------------------------------*)
Procedure TJclBitmap32SetPixelT1_P(Self: TJclBitmap32;  var Ptr : PColor32; Value : TColor32);
Begin Self.SetPixelT(Ptr, Value); END;

(*----------------------------------------------------------------------------*)
Procedure TJclBitmap32SetPixelT_P(Self: TJclBitmap32;  X, Y : Integer; Value : TColor32);
Begin Self.SetPixelT(X, Y, Value); END;

(*----------------------------------------------------------------------------*)
Procedure TJclBitmap32DrawTo5_P(Self: TJclBitmap32;  hDst : HDC; DstRect, SrcRect : TRect);
Begin Self.DrawTo(hDst, DstRect, SrcRect); END;

(*----------------------------------------------------------------------------*)
Procedure TJclBitmap32DrawTo4_P(Self: TJclBitmap32;  hDst : HDC; DstX, DstY : Integer);
Begin Self.DrawTo(hDst, DstX, DstY); END;

(*----------------------------------------------------------------------------*)
Procedure TJclBitmap32DrawTo3_P(Self: TJclBitmap32;  Dst : TJclBitmap32; DstRect, SrcRect : TRect);
Begin Self.DrawTo(Dst, DstRect, SrcRect); END;

(*----------------------------------------------------------------------------*)
Procedure TJclBitmap32DrawTo2_P(Self: TJclBitmap32;  Dst : TJclBitmap32; DstRect : TRect);
Begin Self.DrawTo(Dst, DstRect); END;

(*----------------------------------------------------------------------------*)
Procedure TJclBitmap32DrawTo1_P(Self: TJclBitmap32;  Dst : TJclBitmap32; DstX, DstY : Integer);
Begin Self.DrawTo(Dst, DstX, DstY); END;

(*----------------------------------------------------------------------------*)
Procedure TJclBitmap32DrawTo_P(Self: TJclBitmap32;  Dst : TJclBitmap32);
Begin Self.DrawTo(Dst); END;

(*----------------------------------------------------------------------------*)
Procedure TJclBitmap32Draw2_P(Self: TJclBitmap32;  DstRect, SrcRect : TRect; hSrc : HDC);
Begin Self.Draw(DstRect, SrcRect, hSrc); END;

(*----------------------------------------------------------------------------*)
Procedure TJclBitmap32Draw1_P(Self: TJclBitmap32;  DstRect, SrcRect : TRect; Src : TJclBitmap32);
Begin Self.Draw(DstRect, SrcRect, Src); END;

(*----------------------------------------------------------------------------*)
Procedure TJclBitmap32Draw_P(Self: TJclBitmap32;  DstX, DstY : Integer; Src : TJclBitmap32);
Begin Self.Draw(DstX, DstY, Src); END;

(*----------------------------------------------------------------------------*)
procedure TJclCustomMapWidth_W(Self: TJclCustomMap; const T: Integer);
begin Self.Width := T; end;

(*----------------------------------------------------------------------------*)
procedure TJclCustomMapWidth_R(Self: TJclCustomMap; var T: Integer);
begin T := Self.Width; end;

(*----------------------------------------------------------------------------*)
procedure TJclCustomMapHeight_W(Self: TJclCustomMap; const T: Integer);
begin Self.Height := T; end;

(*----------------------------------------------------------------------------*)
procedure TJclCustomMapHeight_R(Self: TJclCustomMap; var T: Integer);
begin T := Self.Height; end;

(*----------------------------------------------------------------------------*)
Procedure TJclCustomMapSetSize1_P(Self: TJclCustomMap;  NewWidth, NewHeight : Integer);
Begin Self.SetSize(NewWidth, NewHeight); END;

(*----------------------------------------------------------------------------*)
Procedure TJclCustomMapSetSize_P(Self: TJclCustomMap;  Source : TPersistent);
Begin Self.SetSize(Source); END;

(*----------------------------------------------------------------------------*)
procedure TJclThreadPersistentOnChange_W(Self: TJclThreadPersistent; const T: TNotifyEvent);
begin Self.OnChange := T; end;

(*----------------------------------------------------------------------------*)
procedure TJclThreadPersistentOnChange_R(Self: TJclThreadPersistent; var T: TNotifyEvent);
begin T := Self.OnChange; end;

(*----------------------------------------------------------------------------*)
procedure TJclThreadPersistentOnChanging_W(Self: TJclThreadPersistent; const T: TNotifyEvent);
begin Self.OnChanging := T; end;

(*----------------------------------------------------------------------------*)
procedure TJclThreadPersistentOnChanging_R(Self: TJclThreadPersistent; var T: TNotifyEvent);
begin T := Self.OnChanging; end;

(*----------------------------------------------------------------------------*)
procedure TJclRegionRegionType_R(Self: TJclRegion; var T: TJclRegionKind);
begin T := Self.RegionType; end;

(*----------------------------------------------------------------------------*)
procedure TJclRegionHandle_R(Self: TJclRegion; var T: HRGN);
begin T := Self.Handle; end;

(*----------------------------------------------------------------------------*)
procedure TJclRegionBox_R(Self: TJclRegion; var T: TRect);
begin T := Self.Box; end;

(*----------------------------------------------------------------------------*)
Function TJclRegionRectIn1_P(Self: TJclRegion;  Top, Left, Bottom, Right : Integer) : Boolean;
Begin Result := Self.RectIn(Top, Left, Bottom, Right); END;

(*----------------------------------------------------------------------------*)
Function TJclRegionRectIn_P(Self: TJclRegion;  const ARect : TRect) : Boolean;
Begin Result := Self.RectIn(ARect); END;

(*----------------------------------------------------------------------------*)
Function TJclRegionPointIn1_P(Self: TJclRegion;  const Point : TPoint) : Boolean;
Begin Result := Self.PointIn(Point); END;

(*----------------------------------------------------------------------------*)
Function TJclRegionPointIn_P(Self: TJclRegion;  X, Y : Integer) : Boolean;
Begin Result := Self.PointIn(X, Y); END;

(*----------------------------------------------------------------------------*)
Procedure TJclRegionCombine1_P(Self: TJclRegion;  SrcRegion : TJclRegion; CombineOp : TJclRegionCombineOperator);
Begin Self.Combine(SrcRegion, CombineOp); END;

(*----------------------------------------------------------------------------*)
Procedure TJclRegionCombine_P(Self: TJclRegion;  DestRegion, SrcRegion : TJclRegion; CombineOp : TJclRegionCombineOperator);
Begin Self.Combine(DestRegion, SrcRegion, CombineOp); END;

(*----------------------------------------------------------------------------*)
Function TJclRegionCreateRoundRect1_P(Self: TClass; CreateNewInstance: Boolean;  Top, Left, Bottom, Right : Integer; CornerWidth, CornerHeight : Integer):TObject;
Begin Result := TJclRegion.CreateRoundRect(Top, Left, Bottom, Right, CornerWidth, CornerHeight); END;

(*----------------------------------------------------------------------------*)
Function TJclRegionCreateRoundRect_P(Self: TClass; CreateNewInstance: Boolean;  const ARect : TRect; CornerWidth, CornerHeight : Integer):TObject;
Begin Result := TJclRegion.CreateRoundRect(ARect, CornerWidth, CornerHeight); END;

(*----------------------------------------------------------------------------*)
Function TJclRegionCreateRect1_P(Self: TClass; CreateNewInstance: Boolean;  ARect : TRect):TObject;
Begin Result := TJclRegion.CreateRect(ARect); END;

(*----------------------------------------------------------------------------*)
Function TJclRegionCreateRect_P(Self: TClass; CreateNewInstance: Boolean;  const Top, Left, Bottom, Right : Integer):TObject;
Begin Result := TJclRegion.CreateRect(Top, Left, Bottom, Right); END;

(*----------------------------------------------------------------------------*)
Function TJclRegionCreateElliptic1_P(Self: TClass; CreateNewInstance: Boolean;  Top, Left, Bottom, Right : Integer):TObject;
Begin Result := TJclRegion.CreateElliptic(Top, Left, Bottom, Right); END;

(*----------------------------------------------------------------------------*)
Function TJclRegionCreateElliptic_P(Self: TClass; CreateNewInstance: Boolean;  const ARect : TRect):TObject;
Begin Result := TJclRegion.CreateElliptic(ARect); END;

(*----------------------------------------------------------------------------*)
procedure TJclRegionInfoCount_R(Self: TJclRegionInfo; var T: Integer);
begin T := Self.Count; end;

(*----------------------------------------------------------------------------*)
procedure TJclRegionInfoRectangles_R(Self: TJclRegionInfo; var T: TRect; const t1: Integer);
begin T := Self.Rectangles[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TJclRegionInfoBox_R(Self: TJclRegionInfo; var T: TRect);
begin T := Self.Box; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_JclGraphics_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@Stretch, 'Stretch', cdRegister);
 S.RegisterDelphiFunction(@Stretch1_P, 'Stretch1', cdRegister);
 S.RegisterDelphiFunction(@DrawBitmap, 'DrawBitmap', cdRegister);
 S.RegisterDelphiFunction(@GetAntialiasedBitmap, 'GetAntialiasedBitmap', cdRegister);
 //S.RegisterDelphiFunction(@BitmapToJPeg, 'BitmapToJPeg', cdRegister);
 //S.RegisterDelphiFunction(@JPegToBitmap, 'JPegToBitmap', cdRegister);
 S.RegisterDelphiFunction(@ExtractIconCount, 'ExtractIconCount', cdRegister);
 S.RegisterDelphiFunction(@BitmapToIcon, 'BitmapToIconJ', cdRegister);
 S.RegisterDelphiFunction(@IconToBitmap, 'IconToBitmapJ', cdRegister);
 S.RegisterDelphiFunction(@BlockTransfer, 'BlockTransfer', cdRegister);
 S.RegisterDelphiFunction(@StretchTransfer, 'StretchTransfer', cdRegister);
 S.RegisterDelphiFunction(@Transform, 'Transform', cdRegister);
 S.RegisterDelphiFunction(@SetBorderTransparent, 'SetBorderTransparent', cdRegister);
 S.RegisterDelphiFunction(@FillGradient, 'FillGradient', cdRegister);
 S.RegisterDelphiFunction(@CreateRegionFromBitmap, 'CreateRegionFromBitmap', cdRegister);
 S.RegisterDelphiFunction(@ScreenShot, 'ScreenShot', cdRegister);
 S.RegisterDelphiFunction(@ScreenShot1_P, 'ScreenShot1', cdRegister);
 S.RegisterDelphiFunction(@PolyLineTS, 'PolyLineTS', cdRegister);
 S.RegisterDelphiFunction(@PolyLineAS, 'PolyLineAS', cdRegister);
 S.RegisterDelphiFunction(@PolyLineFS, 'PolyLineFS', cdRegister);
 S.RegisterDelphiFunction(@PolygonTS, 'PolygonTS', cdRegister);
 S.RegisterDelphiFunction(@PolygonAS, 'PolygonAS', cdRegister);
 S.RegisterDelphiFunction(@PolygonFS, 'PolygonFS', cdRegister);
 S.RegisterDelphiFunction(@PolyPolygonTS, 'PolyPolygonTS', cdRegister);
 S.RegisterDelphiFunction(@PolyPolygonAS, 'PolyPolygonAS', cdRegister);
 S.RegisterDelphiFunction(@PolyPolygonFS, 'PolyPolygonFS', cdRegister);
 S.RegisterDelphiFunction(@AlphaToGrayscale, 'AlphaToGrayscale', cdRegister);
 S.RegisterDelphiFunction(@IntensityToAlpha, 'IntensityToAlpha', cdRegister);
 S.RegisterDelphiFunction(@Invert, 'Invert', cdRegister);
 S.RegisterDelphiFunction(@InvertRGB, 'InvertRGB', cdRegister);
 S.RegisterDelphiFunction(@ColorToGrayscale, 'ColorToGrayscale', cdRegister);
 S.RegisterDelphiFunction(@ApplyLUT, 'ApplyLUT', cdRegister);
 S.RegisterDelphiFunction(@SetGamma, 'SetGamma', cdRegister);
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJclLinearTransformation(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJclLinearTransformation) do begin
    RegisterVirtualConstructor(@TJclLinearTransformation.Create, 'Create');
    RegisterMethod(@TJclLinearTransformation.Clear, 'Clear');
    RegisterMethod(@TJclLinearTransformation.Rotate, 'Rotate');
    RegisterMethod(@TJclLinearTransformation.Skew, 'Skew');
    RegisterMethod(@TJclLinearTransformation.Scale, 'Scale');
    RegisterMethod(@TJclLinearTransformation.Translate, 'Translate');
    RegisterPropertyHelper(@TJclLinearTransformationMatrix_R,@TJclLinearTransformationMatrix_W,'Matrix');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJclTransformation(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJclTransformation) do begin
    //RegisterVirtualAbstractMethod(@TJclTransformation, @!.GetTransformedBounds, 'GetTransformedBounds');
    //RegisterVirtualAbstractMethod(@TJclTransformation, @!.PrepareTransform, 'PrepareTransform');
    //RegisterVirtualAbstractMethod(@TJclTransformation, @!.Transform, 'Transform');
    //RegisterVirtualAbstractMethod(@TJclTransformation, @!.Transform256, 'Transform256');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJclByteMap(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJclByteMap) do begin
    RegisterMethod(@TJclByteMap.Clear, 'Clear');
    RegisterMethod(@TJclByteMap.Assign, 'Assign');
    RegisterMethod(@TJclByteMap.SetSize, 'SetSize');
    RegisterMethod(@TJclByteMap.Empty, 'Empty');
    RegisterMethod(@TJclByteMap.ReadFrom, 'ReadFrom');
    RegisterMethod(@TJclByteMapWriteTo_P, 'WriteTo');
    RegisterMethod(@TJclByteMapWriteTo1_P, 'WriteTo1');
    RegisterPropertyHelper(@TJclByteMapBytes_R,nil,'Bytes');
    RegisterPropertyHelper(@TJclByteMapValPtr_R,nil,'ValPtr');
    RegisterPropertyHelper(@TJclByteMapValue_R,@TJclByteMapValue_W,'Value');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJclBitmap32(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJclBitmap32) do begin
    RegisterConstructor(@TJclBitmap32.Create, 'Create');
    RegisterMethod(@TJclBitmap32.Destroy, 'Free');

    RegisterMethod(@TJclBitmap32.Assign, 'Assign');
    RegisterMethod(@TJclBitmap32.SetSize, 'SetSize');
    RegisterMethod(@TJclBitmap32.Empty, 'Empty');
    RegisterMethod(@TJclBitmap32.Clear, 'Clear');
    RegisterMethod(@TJclBitmap32.Clear, 'Clear1');
    RegisterMethod(@TJclBitmap32.Delete, 'Delete');
    RegisterMethod(@TJclBitmap32.LoadFromStream, 'LoadFromStream');
    RegisterMethod(@TJclBitmap32.SaveToStream, 'SaveToStream');
    RegisterMethod(@TJclBitmap32.LoadFromFile, 'LoadFromFile');
    RegisterMethod(@TJclBitmap32.SaveToFile, 'SaveToFile');
    RegisterMethod(@TJclBitmap32.ResetAlpha, 'ResetAlpha');
    RegisterMethod(@TJclBitmap32Draw_P, 'Draw');
    RegisterMethod(@TJclBitmap32Draw1_P, 'Draw1');
    RegisterMethod(@TJclBitmap32Draw2_P, 'Draw2');
    RegisterMethod(@TJclBitmap32DrawTo_P, 'DrawTo');
    RegisterMethod(@TJclBitmap32DrawTo1_P, 'DrawTo1');
    RegisterMethod(@TJclBitmap32DrawTo2_P, 'DrawTo2');
    RegisterMethod(@TJclBitmap32DrawTo3_P, 'DrawTo3');
    RegisterMethod(@TJclBitmap32DrawTo4_P, 'DrawTo4');
    RegisterMethod(@TJclBitmap32DrawTo5_P, 'DrawTo5');
    RegisterMethod(@TJclBitmap32.GetPixelB, 'GetPixelB');
    RegisterMethod(@TJclBitmap32SetPixelT_P, 'SetPixelT');
    RegisterMethod(@TJclBitmap32SetPixelT1_P, 'SetPixelT1');
    RegisterMethod(@TJclBitmap32.SetPixelTS, 'SetPixelTS');
    RegisterMethod(@TJclBitmap32.SetPixelF, 'SetPixelF');
    RegisterMethod(@TJclBitmap32.SetPixelFS, 'SetPixelFS');
    RegisterMethod(@TJclBitmap32SetStipple_P, 'SetStipple');
    RegisterMethod(@TJclBitmap32SetStipple1_P, 'SetStipple1');
    RegisterMethod(@TJclBitmap32.SetStippleStep, 'SetStippleStep');
    RegisterMethod(@TJclBitmap32.ResetStippleCounter, 'ResetStippleCounter');
    RegisterMethod(@TJclBitmap32.GetStippleColor, 'GetStippleColor');
    RegisterMethod(@TJclBitmap32.DrawHorzLine, 'DrawHorzLine');
    RegisterMethod(@TJclBitmap32.DrawHorzLineS, 'DrawHorzLineS');
    RegisterMethod(@TJclBitmap32.DrawHorzLineT, 'DrawHorzLineT');
    RegisterMethod(@TJclBitmap32.DrawHorzLineTS, 'DrawHorzLineTS');
    RegisterMethod(@TJclBitmap32.DrawHorzLineTSP, 'DrawHorzLineTSP');
    RegisterMethod(@TJclBitmap32.DrawVertLine, 'DrawVertLine');
    RegisterMethod(@TJclBitmap32.DrawVertLineS, 'DrawVertLineS');
    RegisterMethod(@TJclBitmap32.DrawVertLineT, 'DrawVertLineT');
    RegisterMethod(@TJclBitmap32.DrawVertLineTS, 'DrawVertLineTS');
    RegisterMethod(@TJclBitmap32.DrawVertLineTSP, 'DrawVertLineTSP');
    RegisterMethod(@TJclBitmap32.DrawLine, 'DrawLine');
    RegisterMethod(@TJclBitmap32.DrawLineS, 'DrawLineS');
    RegisterMethod(@TJclBitmap32.DrawLineT, 'DrawLineT');
    RegisterMethod(@TJclBitmap32.DrawLineTS, 'DrawLineTS');
    RegisterMethod(@TJclBitmap32.DrawLineA, 'DrawLineA');
    RegisterMethod(@TJclBitmap32.DrawLineAS, 'DrawLineAS');
    RegisterMethod(@TJclBitmap32.DrawLineF, 'DrawLineF');
    RegisterMethod(@TJclBitmap32.DrawLineFS, 'DrawLineFS');
    RegisterMethod(@TJclBitmap32.DrawLineFP, 'DrawLineFP');
    RegisterMethod(@TJclBitmap32.DrawLineFSP, 'DrawLineFSP');
    RegisterMethod(@TJclBitmap32.MoveTo, 'MoveTo');
    RegisterMethod(@TJclBitmap32.LineToS, 'LineToS');
    RegisterMethod(@TJclBitmap32.LineToTS, 'LineToTS');
    RegisterMethod(@TJclBitmap32.LineToAS, 'LineToAS');
    RegisterMethod(@TJclBitmap32.MoveToF, 'MoveToF');
    RegisterMethod(@TJclBitmap32.LineToFS, 'LineToFS');
    RegisterMethod(@TJclBitmap32.FillRect, 'FillRect');
    RegisterMethod(@TJclBitmap32.FillRectS, 'FillRectS');
    RegisterMethod(@TJclBitmap32.FillRectT, 'FillRectT');
    RegisterMethod(@TJclBitmap32.FillRectTS, 'FillRectTS');
    RegisterMethod(@TJclBitmap32.FrameRectS, 'FrameRectS');
    RegisterMethod(@TJclBitmap32FrameRectTS_P, 'FrameRectTS');
    RegisterMethod(@TJclBitmap32FrameRectTSP_P, 'FrameRectTSP');
    RegisterMethod(@TJclBitmap32.RaiseRectTS, 'RaiseRectTS');
    RegisterMethod(@TJclBitmap32.UpdateFont, 'UpdateFont');
    RegisterMethod(@TJclBitmap32TextOut_P, 'TextOut');
    RegisterMethod(@TJclBitmap32TextOut1_P, 'TextOut1');
    RegisterMethod(@TJclBitmap32TextOut2_P, 'TextOut2');
    RegisterMethod(@TJclBitmap32.TextExtent, 'TextExtent');
    RegisterMethod(@TJclBitmap32.TextHeight, 'TextHeight');
    RegisterMethod(@TJclBitmap32.TextWidth, 'TextWidth');
    RegisterMethod(@TJclBitmap32.RenderText, 'RenderText');
    RegisterPropertyHelper(@TJclBitmap32BitmapHandle_R,nil,'BitmapHandle');
    RegisterPropertyHelper(@TJclBitmap32BitmapInfo_R,nil,'BitmapInfo');
    RegisterPropertyHelper(@TJclBitmap32Bits_R,nil,'Bits');
    RegisterPropertyHelper(@TJclBitmap32Font_R,@TJclBitmap32Font_W,'Font');
    RegisterPropertyHelper(@TJclBitmap32Handle_R,nil,'Handle');
    RegisterPropertyHelper(@TJclBitmap32PenColor_R,@TJclBitmap32PenColor_W,'PenColor');
    RegisterPropertyHelper(@TJclBitmap32Pixel_R,@TJclBitmap32Pixel_W,'Pixel');
    RegisterPropertyHelper(@TJclBitmap32PixelS_R,@TJclBitmap32PixelS_W,'PixelS');
    RegisterPropertyHelper(@TJclBitmap32PixelPtr_R,nil,'PixelPtr');
    RegisterPropertyHelper(@TJclBitmap32ScanLine_R,nil,'ScanLine');
    RegisterPropertyHelper(@TJclBitmap32DrawMode_R,@TJclBitmap32DrawMode_W,'DrawMode');
    RegisterPropertyHelper(@TJclBitmap32MasterAlpha_R,@TJclBitmap32MasterAlpha_W,'MasterAlpha');
    RegisterPropertyHelper(@TJclBitmap32OuterColor_R,@TJclBitmap32OuterColor_W,'OuterColor');
    RegisterPropertyHelper(@TJclBitmap32StretchFilter_R,@TJclBitmap32StretchFilter_W,'StretchFilter');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJclCustomMap(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJclCustomMap) do begin
    RegisterVirtualMethod(@TJclCustomMap.Delete, 'Delete');
    RegisterVirtualMethod(@TJclCustomMap.Empty, 'Empty');
    RegisterMethod(@TJclCustomMapSetSize_P, 'SetSize');
    RegisterVirtualMethod(@TJclCustomMapSetSize1_P, 'SetSize1');
    RegisterPropertyHelper(@TJclCustomMapHeight_R,@TJclCustomMapHeight_W,'Height');
    RegisterPropertyHelper(@TJclCustomMapWidth_R,@TJclCustomMapWidth_W,'Width');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJclThreadPersistent(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJclThreadPersistent) do
  begin
    RegisterVirtualConstructor(@TJclThreadPersistent.Create, 'Create');
    RegisterVirtualMethod(@TJclThreadPersistent.Changing, 'Changing');
    RegisterVirtualMethod(@TJclThreadPersistent.Changed, 'Changed');
    RegisterMethod(@TJclThreadPersistent.BeginUpdate, 'BeginUpdate');
    RegisterMethod(@TJclThreadPersistent.EndUpdate, 'EndUpdate');
    RegisterMethod(@TJclThreadPersistent.Lock, 'Lock');
    RegisterMethod(@TJclThreadPersistent.Unlock, 'Unlock');
    RegisterPropertyHelper(@TJclThreadPersistentOnChanging_R,@TJclThreadPersistentOnChanging_W,'OnChanging');
    RegisterPropertyHelper(@TJclThreadPersistentOnChange_R,@TJclThreadPersistentOnChange_W,'OnChange');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJclRegion(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJclRegion) do begin
    RegisterConstructor(@TJclRegion.Create, 'Create');
    RegisterMethod(@TJclRegion.Destroy, 'Free');
    RegisterConstructor(@TJclRegionCreateElliptic_P, 'CreateElliptic');
    RegisterConstructor(@TJclRegionCreateElliptic1_P, 'CreateElliptic1');
    RegisterConstructor(@TJclRegion.CreatePoly, 'CreatePoly');
    RegisterConstructor(@TJclRegion.CreatePolyPolygon, 'CreatePolyPolygon');
    RegisterConstructor(@TJclRegionCreateRect_P, 'CreateRect');
    RegisterConstructor(@TJclRegionCreateRect1_P, 'CreateRect1');
    RegisterConstructor(@TJclRegionCreateRoundRect_P, 'CreateRoundRect');
    RegisterConstructor(@TJclRegionCreateRoundRect1_P, 'CreateRoundRect1');
    RegisterConstructor(@TJclRegion.CreateBitmap, 'CreateBitmap');
    RegisterConstructor(@TJclRegion.CreatePath, 'CreatePath');
    RegisterConstructor(@TJclRegion.CreateRegionInfo, 'CreateRegionInfo');
    RegisterMethod(@TJclRegion.Clip, 'Clip');
    RegisterMethod(@TJclRegionCombine_P, 'Combine');
    RegisterMethod(@TJclRegionCombine1_P, 'Combine1');
    RegisterMethod(@TJclRegion.Copy, 'Copy');
    RegisterMethod(@TJclRegion.Equals, 'Equals');
    RegisterMethod(@TJclRegion.Fill, 'Fill');
    RegisterMethod(@TJclRegion.FillGradient, 'FillGradient');
    RegisterMethod(@TJclRegion.Frame, 'Frame');
    RegisterMethod(@TJclRegion.Invert, 'Invert');
    RegisterMethod(@TJclRegion.Offset, 'Offset');
    RegisterMethod(@TJclRegion.Paint, 'Paint');
    RegisterMethod(@TJclRegionPointIn_P, 'PointIn');
    RegisterMethod(@TJclRegionPointIn1_P, 'PointIn1');
    RegisterMethod(@TJclRegionRectIn_P, 'RectIn');
    RegisterMethod(@TJclRegionRectIn1_P, 'RectIn1');
    RegisterMethod(@TJclRegion.SetWindow, 'SetWindow');
    RegisterMethod(@TJclRegion.GetRegionInfo, 'GetRegionInfo');
    RegisterPropertyHelper(@TJclRegionBox_R,nil,'Box');
    RegisterPropertyHelper(@TJclRegionHandle_R,nil,'Handle');
    RegisterPropertyHelper(@TJclRegionRegionType_R,nil,'RegionType');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJclRegionInfo(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJclRegionInfo) do begin
    RegisterConstructor(@TJclRegionInfo.Create, 'Create');
    RegisterMethod(@TJclRegionInfo.Destroy, 'Free');

    RegisterPropertyHelper(@TJclRegionInfoBox_R,nil,'Box');
    RegisterPropertyHelper(@TJclRegionInfoRectangles_R,nil,'Rectangles');
    RegisterPropertyHelper(@TJclRegionInfoCount_R,nil,'Count');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJclDesktopCanvas(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJclDesktopCanvas) do begin
    RegisterConstructor(@TJclDesktopCanvas.Create, 'Create');
    RegisterMethod(@TJclDesktopCanvas.Destroy, 'Free');

  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_JclGraphics(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(EJclGraphicsError) do
  RIRegister_TJclDesktopCanvas(CL);
  with CL.Add(TJclRegion) do
  RIRegister_TJclRegionInfo(CL);
  RIRegister_TJclRegion(CL);
  RIRegister_TJclThreadPersistent(CL);
  RIRegister_TJclCustomMap(CL);
  RIRegister_TJclBitmap32(CL);
  RIRegister_TJclByteMap(CL);
  RIRegister_TJclTransformation(CL);
  RIRegister_TJclLinearTransformation(CL);
end;

 
 
{ TPSImport_JclGraphics }
(*----------------------------------------------------------------------------*)
procedure TPSImport_JclGraphics.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_JclGraphics(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_JclGraphics.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_JclGraphics(ri);
  RIRegister_JclGraphics_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
