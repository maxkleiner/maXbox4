unit uPSI_cyDmmCanvas;
{
   another canvas
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
  TPSImport_cyDmmCanvas = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TcyDMMCanvas(CL: TPSPascalCompiler);
procedure SIRegister_cyDmmCanvas(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TcyDMMCanvas(CL: TPSRuntimeClassImporter);
procedure RIRegister_cyDmmCanvas(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   windows
  ,Graphics
  ,cyDmmCanvas
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_cyDmmCanvas]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TcyDMMCanvas(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'Tcanvas', 'TcyDMMCanvas') do
  with CL.AddClassN(CL.FindClass('Tcanvas'),'TcyDMMCanvas') do begin
    RegisterMethod('Constructor Create');
            RegisterMethod('Procedure Free');
      RegisterMethod('Function PxToDmm_X( x : integer) : integer');
    RegisterMethod('Function PxToDmm_Y( y : integer) : integer');
    RegisterMethod('Function DmmToPx_X( x : integer) : integer');
    RegisterMethod('Function DmmToPx_Y( y : integer) : integer');
    RegisterMethod('Function DmmToPx_Point( pt : TPoint) : TPoint');
    RegisterMethod('Function DmmToPx_Rect( rect : trect) : TRect');
    RegisterMethod('Procedure DMMArc( X1, Y1, X2, Y2, X3, Y3, X4, Y4 : Integer)');
    RegisterMethod('Procedure DMMBrushCopy( const Dest : TRect; Bitmap : TBitmap; const Source : TRect; Color : TColor)');
    RegisterMethod('Procedure DMMChord( X1, Y1, X2, Y2, X3, Y3, X4, Y4 : Integer)');
    RegisterMethod('Procedure DMMCopyRect( const Dest : TRect; Canvas : TCanvas; const Source : TRect)');
    RegisterMethod('Procedure DMMDraw( X, Y : Integer; Graphic : TGraphic)');
    RegisterMethod('Procedure DMMDrawFocusRect( const Rect : TRect)');
    RegisterMethod('Procedure DMMEllipse( X1, Y1, X2, Y2 : Integer);');
    RegisterMethod('Procedure DMMEllipse1( const Rect : TRect);');
    RegisterMethod('Procedure DMMFillRect( const Rect : TRect)');
    RegisterMethod('Procedure DMMFloodFill( X, Y : Integer; Color : TColor; FillStyle : TFillStyle)');
    RegisterMethod('Procedure DMMFrameRect( const Rect : TRect)');
    RegisterMethod('Procedure DMMLineTo( X, Y : Integer)');
    RegisterMethod('Procedure DMMMoveTo( X, Y : Integer)');
    RegisterMethod('Procedure DMMPie( X1, Y1, X2, Y2, X3, Y3, X4, Y4 : Integer)');
    RegisterMethod('Procedure DMMPolygon( const Points : array of TPoint)');
    RegisterMethod('Procedure DMMPolyline( const Points : array of TPoint)');
    RegisterMethod('Procedure DMMPolyBezier( const Points : array of TPoint)');
    RegisterMethod('Procedure DMMPolyBezierTo( const Points : array of TPoint)');
    RegisterMethod('Procedure DMMRectangle( X1, Y1, X2, Y2 : Integer);');
    RegisterMethod('Procedure DMMRectangle1( const Rect : TRect);');
    RegisterMethod('Procedure DMMRoundRect( X1, Y1, X2, Y2, X3, Y3 : Integer)');
    RegisterMethod('Procedure DMMStretchDraw( const Rect : TRect; Graphic : TGraphic)');
    RegisterMethod('Function DMMTextExtent( const Text : string) : TSize');
    RegisterMethod('Function DMMTextHeight( const Text : string) : Integer');
    RegisterMethod('Procedure DMMTextOut( X, Y : Integer; const Text : string)');
    RegisterMethod('Procedure DMMTextRect( Rect : TRect; X, Y : Integer; const Text : string)');
    RegisterMethod('Function DMMTextWidth( const Text : string) : Integer');
    RegisterProperty('DMMFontHeight', 'Integer', iptrw);
    RegisterProperty('DMMPixels', 'TColor Integer Integer', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_cyDmmCanvas(CL: TPSPascalCompiler);
begin
  SIRegister_TcyDMMCanvas(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TcyDMMCanvasDMMPixels_W(Self: TcyDMMCanvas; const T: TColor; const t1: Integer; const t2: Integer);
begin Self.DMMPixels[t1, t2] := T; end;

(*----------------------------------------------------------------------------*)
procedure TcyDMMCanvasDMMPixels_R(Self: TcyDMMCanvas; var T: TColor; const t1: Integer; const t2: Integer);
begin T := Self.DMMPixels[t1, t2]; end;

(*----------------------------------------------------------------------------*)
procedure TcyDMMCanvasDMMFontHeight_W(Self: TcyDMMCanvas; const T: Integer);
begin Self.DMMFontHeight := T; end;

(*----------------------------------------------------------------------------*)
procedure TcyDMMCanvasDMMFontHeight_R(Self: TcyDMMCanvas; var T: Integer);
begin T := Self.DMMFontHeight; end;

(*----------------------------------------------------------------------------*)
Procedure TcyDMMCanvasDMMRectangle1_P(Self: TcyDMMCanvas;  const Rect : TRect);
Begin Self.DMMRectangle(Rect); END;

(*----------------------------------------------------------------------------*)
Procedure TcyDMMCanvasDMMRectangle_P(Self: TcyDMMCanvas;  X1, Y1, X2, Y2 : Integer);
Begin Self.DMMRectangle(X1, Y1, X2, Y2); END;

(*----------------------------------------------------------------------------*)
Procedure TcyDMMCanvasDMMEllipse1_P(Self: TcyDMMCanvas;  const Rect : TRect);
Begin Self.DMMEllipse(Rect); END;

(*----------------------------------------------------------------------------*)
Procedure TcyDMMCanvasDMMEllipse_P(Self: TcyDMMCanvas;  X1, Y1, X2, Y2 : Integer);
Begin Self.DMMEllipse(X1, Y1, X2, Y2); END;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TcyDMMCanvas(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TcyDMMCanvas) do begin
    RegisterConstructor(@TcyDMMCanvas.Create, 'Create');
      RegisterMethod(@TcyDMMCanvas.Destroy, 'Free');
       RegisterMethod(@TcyDMMCanvas.PxToDmm_X, 'PxToDmm_X');
    RegisterMethod(@TcyDMMCanvas.PxToDmm_Y, 'PxToDmm_Y');
    RegisterMethod(@TcyDMMCanvas.DmmToPx_X, 'DmmToPx_X');
    RegisterMethod(@TcyDMMCanvas.DmmToPx_Y, 'DmmToPx_Y');
    RegisterMethod(@TcyDMMCanvas.DmmToPx_Point, 'DmmToPx_Point');
    RegisterMethod(@TcyDMMCanvas.DmmToPx_Rect, 'DmmToPx_Rect');
    RegisterMethod(@TcyDMMCanvas.DMMArc, 'DMMArc');
    RegisterMethod(@TcyDMMCanvas.DMMBrushCopy, 'DMMBrushCopy');
    RegisterMethod(@TcyDMMCanvas.DMMChord, 'DMMChord');
    RegisterMethod(@TcyDMMCanvas.DMMCopyRect, 'DMMCopyRect');
    RegisterMethod(@TcyDMMCanvas.DMMDraw, 'DMMDraw');
    RegisterMethod(@TcyDMMCanvas.DMMDrawFocusRect, 'DMMDrawFocusRect');
    RegisterMethod(@TcyDMMCanvasDMMEllipse_P, 'DMMEllipse');
    RegisterMethod(@TcyDMMCanvasDMMEllipse1_P, 'DMMEllipse1');
    RegisterMethod(@TcyDMMCanvas.DMMFillRect, 'DMMFillRect');
    RegisterMethod(@TcyDMMCanvas.DMMFloodFill, 'DMMFloodFill');
    RegisterMethod(@TcyDMMCanvas.DMMFrameRect, 'DMMFrameRect');
    RegisterMethod(@TcyDMMCanvas.DMMLineTo, 'DMMLineTo');
    RegisterMethod(@TcyDMMCanvas.DMMMoveTo, 'DMMMoveTo');
    RegisterMethod(@TcyDMMCanvas.DMMPie, 'DMMPie');
    RegisterMethod(@TcyDMMCanvas.DMMPolygon, 'DMMPolygon');
    RegisterMethod(@TcyDMMCanvas.DMMPolyline, 'DMMPolyline');
    RegisterMethod(@TcyDMMCanvas.DMMPolyBezier, 'DMMPolyBezier');
    RegisterMethod(@TcyDMMCanvas.DMMPolyBezierTo, 'DMMPolyBezierTo');
    RegisterMethod(@TcyDMMCanvasDMMRectangle_P, 'DMMRectangle');
    RegisterMethod(@TcyDMMCanvasDMMRectangle1_P, 'DMMRectangle1');
    RegisterMethod(@TcyDMMCanvas.DMMRoundRect, 'DMMRoundRect');
    RegisterMethod(@TcyDMMCanvas.DMMStretchDraw, 'DMMStretchDraw');
    RegisterMethod(@TcyDMMCanvas.DMMTextExtent, 'DMMTextExtent');
    RegisterMethod(@TcyDMMCanvas.DMMTextHeight, 'DMMTextHeight');
    RegisterMethod(@TcyDMMCanvas.DMMTextOut, 'DMMTextOut');
    RegisterMethod(@TcyDMMCanvas.DMMTextRect, 'DMMTextRect');
    RegisterMethod(@TcyDMMCanvas.DMMTextWidth, 'DMMTextWidth');
    RegisterPropertyHelper(@TcyDMMCanvasDMMFontHeight_R,@TcyDMMCanvasDMMFontHeight_W,'DMMFontHeight');
    RegisterPropertyHelper(@TcyDMMCanvasDMMPixels_R,@TcyDMMCanvasDMMPixels_W,'DMMPixels');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_cyDmmCanvas(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TcyDMMCanvas(CL);
end;

 
 
{ TPSImport_cyDmmCanvas }
(*----------------------------------------------------------------------------*)
procedure TPSImport_cyDmmCanvas.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_cyDmmCanvas(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_cyDmmCanvas.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_cyDmmCanvas(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
