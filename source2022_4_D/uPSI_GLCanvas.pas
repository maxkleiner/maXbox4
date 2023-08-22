unit uPSI_GLCanvas;
{
  ath the end unit 800
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
  TPSImport_GLCanvas = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TGLCanvas(CL: TPSPascalCompiler);
procedure SIRegister_GLCanvas(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TGLCanvas(CL: TPSRuntimeClassImporter);
procedure RIRegister_GLCanvas(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   VectorGeometry
  ,GLCrossPlatform
  ,GLCanvas
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_GLCanvas]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TGLCanvas(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOBJECT', 'TGLCanvas') do
  with CL.AddClassN(CL.FindClass('TOBJECT'),'TGLCanvas') do begin
    RegisterMethod('Constructor Create( bufferSizeX, bufferSizeY : Integer; const baseTransform : TMatrix);');
    RegisterMethod('Constructor Create1( bufferSizeX, bufferSizeY : Integer);');
    RegisterMethod('Procedure Free');
    RegisterMethod('Procedure StopPrimitive');
    RegisterMethod('Procedure InvertYAxis');
    RegisterProperty('CanvasSizeX', 'Integer', iptr);
    RegisterProperty('CanvasSizeY', 'Integer', iptr);
    RegisterProperty('PenColor', 'TColor', iptrw);
    RegisterProperty('PenAlpha', 'Single', iptrw);
    RegisterProperty('PenWidth', 'Integer', iptrw);
    RegisterMethod('Procedure MoveTo( const x, y : Integer);');
    RegisterMethod('Procedure MoveTo1( const x, y : Single);');
    RegisterMethod('Procedure MoveToRel( const x, y : Integer);');
    RegisterMethod('Procedure MoveToRel1( const x, y : Single);');
    RegisterMethod('Procedure LineTo( const x, y : Integer);');
    RegisterMethod('Procedure LineTo1( const x, y : Single);');
    RegisterMethod('Procedure LineToRel( const x, y : Integer);');
    RegisterMethod('Procedure LineToRel1( const x, y : Single);');
    RegisterMethod('Procedure Line( const x1, y1, x2, y2 : Integer);');
    RegisterMethod('Procedure Line1( const x1, y1, x2, y2 : Single);');
    RegisterMethod('Procedure Polyline( const points : array of TGLPoint)');
    RegisterMethod('Procedure Polygon( const points : array of TGLPoint)');
    RegisterMethod('Procedure PlotPixel( const x, y : Integer);');
    RegisterMethod('Procedure PlotPixel1( const x, y : Single);');
    RegisterMethod('Procedure FrameRect( const x1, y1, x2, y2 : Integer);');
    RegisterMethod('Procedure FrameRect1( const x1, y1, x2, y2 : Single);');
    RegisterMethod('Procedure FillRect( const x1, y1, x2, y2 : Integer);');
    RegisterMethod('Procedure FillRect1( const x1, y1, x2, y2 : Single);');
    RegisterMethod('Procedure Ellipse( const x1, y1, x2, y2 : Integer);');
    RegisterMethod('Procedure Ellipse1( const x, y : Integer; const xRadius, yRadius : Single);');
    RegisterMethod('Procedure Ellipse2( x, y, xRadius, yRadius : Single);');
    RegisterMethod('Procedure FillEllipse( const x, y : Integer; const xRadius, yRadius : Single);');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_GLCanvas(CL: TPSPascalCompiler);
begin
  //CL.AddTypeS('TColor', 'Integer');
  SIRegister_TGLCanvas(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
Procedure TGLCanvasFillEllipse_P(Self: TGLCanvas;  const x, y : Integer; const xRadius, yRadius : Single);
Begin Self.FillEllipse(x, y, xRadius, yRadius); END;

(*----------------------------------------------------------------------------*)
Procedure TGLCanvasEllipse2_P(Self: TGLCanvas;  x, y, xRadius, yRadius : Single);
Begin Self.Ellipse(x, y, xRadius, yRadius); END;

(*----------------------------------------------------------------------------*)
Procedure TGLCanvasEllipse1_P(Self: TGLCanvas;  const x, y : Integer; const xRadius, yRadius : Single);
Begin Self.Ellipse(x, y, xRadius, yRadius); END;

(*----------------------------------------------------------------------------*)
Procedure TGLCanvasEllipse_P(Self: TGLCanvas;  const x1, y1, x2, y2 : Integer);
Begin Self.Ellipse(x1, y1, x2, y2); END;

(*----------------------------------------------------------------------------*)
Procedure TGLCanvasFillRect1_P(Self: TGLCanvas;  const x1, y1, x2, y2 : Single);
Begin Self.FillRect(x1, y1, x2, y2); END;

(*----------------------------------------------------------------------------*)
Procedure TGLCanvasFillRect_P(Self: TGLCanvas;  const x1, y1, x2, y2 : Integer);
Begin Self.FillRect(x1, y1, x2, y2); END;

(*----------------------------------------------------------------------------*)
Procedure TGLCanvasFrameRect1_P(Self: TGLCanvas;  const x1, y1, x2, y2 : Single);
Begin Self.FrameRect(x1, y1, x2, y2); END;

(*----------------------------------------------------------------------------*)
Procedure TGLCanvasFrameRect_P(Self: TGLCanvas;  const x1, y1, x2, y2 : Integer);
Begin Self.FrameRect(x1, y1, x2, y2); END;

(*----------------------------------------------------------------------------*)
Procedure TGLCanvasPlotPixel1_P(Self: TGLCanvas;  const x, y : Single);
Begin Self.PlotPixel(x, y); END;

(*----------------------------------------------------------------------------*)
Procedure TGLCanvasPlotPixel_P(Self: TGLCanvas;  const x, y : Integer);
Begin Self.PlotPixel(x, y); END;

(*----------------------------------------------------------------------------*)
Procedure TGLCanvasLine1_P(Self: TGLCanvas;  const x1, y1, x2, y2 : Single);
Begin Self.Line(x1, y1, x2, y2); END;

(*----------------------------------------------------------------------------*)
Procedure TGLCanvasLine_P(Self: TGLCanvas;  const x1, y1, x2, y2 : Integer);
Begin Self.Line(x1, y1, x2, y2); END;

(*----------------------------------------------------------------------------*)
Procedure TGLCanvasLineToRel1_P(Self: TGLCanvas;  const x, y : Single);
Begin Self.LineToRel(x, y); END;

(*----------------------------------------------------------------------------*)
Procedure TGLCanvasLineToRel_P(Self: TGLCanvas;  const x, y : Integer);
Begin Self.LineToRel(x, y); END;

(*----------------------------------------------------------------------------*)
Procedure TGLCanvasLineTo1_P(Self: TGLCanvas;  const x, y : Single);
Begin Self.LineTo(x, y); END;

(*----------------------------------------------------------------------------*)
Procedure TGLCanvasLineTo_P(Self: TGLCanvas;  const x, y : Integer);
Begin Self.LineTo(x, y); END;

(*----------------------------------------------------------------------------*)
Procedure TGLCanvasMoveToRel1_P(Self: TGLCanvas;  const x, y : Single);
Begin Self.MoveToRel(x, y); END;

(*----------------------------------------------------------------------------*)
Procedure TGLCanvasMoveToRel_P(Self: TGLCanvas;  const x, y : Integer);
Begin Self.MoveToRel(x, y); END;

(*----------------------------------------------------------------------------*)
Procedure TGLCanvasMoveTo1_P(Self: TGLCanvas;  const x, y : Single);
Begin Self.MoveTo(x, y); END;

(*----------------------------------------------------------------------------*)
Procedure TGLCanvasMoveTo_P(Self: TGLCanvas;  const x, y : Integer);
Begin Self.MoveTo(x, y); END;

(*----------------------------------------------------------------------------*)
procedure TGLCanvasPenWidth_W(Self: TGLCanvas; const T: Integer);
begin Self.PenWidth := T; end;

(*----------------------------------------------------------------------------*)
procedure TGLCanvasPenWidth_R(Self: TGLCanvas; var T: Integer);
begin T := Self.PenWidth; end;

(*----------------------------------------------------------------------------*)
procedure TGLCanvasPenAlpha_W(Self: TGLCanvas; const T: Single);
begin Self.PenAlpha := T; end;

(*----------------------------------------------------------------------------*)
procedure TGLCanvasPenAlpha_R(Self: TGLCanvas; var T: Single);
begin T := Self.PenAlpha; end;

(*----------------------------------------------------------------------------*)
procedure TGLCanvasPenColor_W(Self: TGLCanvas; const T: TColor);
begin Self.PenColor := T; end;

(*----------------------------------------------------------------------------*)
procedure TGLCanvasPenColor_R(Self: TGLCanvas; var T: TColor);
begin T := Self.PenColor; end;

(*----------------------------------------------------------------------------*)
procedure TGLCanvasCanvasSizeY_R(Self: TGLCanvas; var T: Integer);
begin T := Self.CanvasSizeY; end;

(*----------------------------------------------------------------------------*)
procedure TGLCanvasCanvasSizeX_R(Self: TGLCanvas; var T: Integer);
begin T := Self.CanvasSizeX; end;

(*----------------------------------------------------------------------------*)
Function TGLCanvasCreate1_P(Self: TClass; CreateNewInstance: Boolean;  bufferSizeX, bufferSizeY : Integer):TObject;
Begin Result := TGLCanvas.Create(bufferSizeX, bufferSizeY); END;

(*----------------------------------------------------------------------------*)
Function TGLCanvasCreate_P(Self: TClass; CreateNewInstance: Boolean;  bufferSizeX, bufferSizeY : Integer; const baseTransform : TMatrix):TObject;
Begin Result := TGLCanvas.Create(bufferSizeX, bufferSizeY, baseTransform); END;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TGLCanvas(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TGLCanvas) do begin
    RegisterConstructor(@TGLCanvasCreate_P, 'Create');
    RegisterConstructor(@TGLCanvasCreate1_P, 'Create1');
        RegisterMethod(@TGLCanvas.Destroy, 'Free');
       RegisterMethod(@TGLCanvas.StopPrimitive, 'StopPrimitive');
    RegisterMethod(@TGLCanvas.InvertYAxis, 'InvertYAxis');
    RegisterPropertyHelper(@TGLCanvasCanvasSizeX_R,nil,'CanvasSizeX');
    RegisterPropertyHelper(@TGLCanvasCanvasSizeY_R,nil,'CanvasSizeY');
    RegisterPropertyHelper(@TGLCanvasPenColor_R,@TGLCanvasPenColor_W,'PenColor');
    RegisterPropertyHelper(@TGLCanvasPenAlpha_R,@TGLCanvasPenAlpha_W,'PenAlpha');
    RegisterPropertyHelper(@TGLCanvasPenWidth_R,@TGLCanvasPenWidth_W,'PenWidth');
    RegisterMethod(@TGLCanvasMoveTo_P, 'MoveTo');
    RegisterMethod(@TGLCanvasMoveTo1_P, 'MoveTo1');
    RegisterMethod(@TGLCanvasMoveToRel_P, 'MoveToRel');
    RegisterMethod(@TGLCanvasMoveToRel1_P, 'MoveToRel1');
    RegisterMethod(@TGLCanvasLineTo_P, 'LineTo');
    RegisterMethod(@TGLCanvasLineTo1_P, 'LineTo1');
    RegisterMethod(@TGLCanvasLineToRel_P, 'LineToRel');
    RegisterMethod(@TGLCanvasLineToRel1_P, 'LineToRel1');
    RegisterMethod(@TGLCanvasLine_P, 'Line');
    RegisterMethod(@TGLCanvasLine1_P, 'Line1');
    RegisterMethod(@TGLCanvas.Polyline, 'Polyline');
    RegisterMethod(@TGLCanvas.Polygon, 'Polygon');
    RegisterMethod(@TGLCanvasPlotPixel_P, 'PlotPixel');
    RegisterMethod(@TGLCanvasPlotPixel1_P, 'PlotPixel1');
    RegisterMethod(@TGLCanvasFrameRect_P, 'FrameRect');
    RegisterMethod(@TGLCanvasFrameRect1_P, 'FrameRect1');
    RegisterMethod(@TGLCanvasFillRect_P, 'FillRect');
    RegisterMethod(@TGLCanvasFillRect1_P, 'FillRect1');
    RegisterMethod(@TGLCanvasEllipse_P, 'Ellipse');
    RegisterMethod(@TGLCanvasEllipse1_P, 'Ellipse1');
    RegisterMethod(@TGLCanvasEllipse2_P, 'Ellipse2');
    RegisterMethod(@TGLCanvasFillEllipse_P, 'FillEllipse');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_GLCanvas(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TGLCanvas(CL);
end;

 
 
{ TPSImport_GLCanvas }
(*----------------------------------------------------------------------------*)
procedure TPSImport_GLCanvas.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_GLCanvas(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_GLCanvas.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_GLCanvas(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
