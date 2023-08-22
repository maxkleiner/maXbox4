unit uPSI_GraphicsPrimitivesLibrary;
{
 for pantograph and draw figures

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
  TPSImport_GraphicsPrimitivesLibrary = class(TPSPlugin)
  public
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TPantoGraph(CL: TPSPascalCompiler);
procedure SIRegister_GraphicsPrimitivesLibrary(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TPantoGraph(CL: TPSRuntimeClassImporter);
procedure RIRegister_GraphicsPrimitivesLibrary(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   Graphics
  ,ExtCtrls
  ,GraphicsMathLibrary
  ,WinTypes
  ,GraphicsPrimitivesLibrary
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_GraphicsPrimitivesLibrary]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TPantoGraph(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TObject', 'TPantoGraph') do
  with CL.AddClassN(CL.FindClass('TObject'),'TPantoGraph') do begin
    RegisterProperty('Canvas', 'TCanvas', iptrw);
    RegisterMethod('Constructor Create( const PantoCanvas : TCanvas)');
       RegisterMethod('Procedure Free');
     RegisterMethod('Procedure LineToIJ( const i, j : INTEGER)');
    RegisterMethod('Procedure MoveToIJ( const i, j : INTEGER)');
    RegisterMethod('Procedure PointAtIJ( const i, j : INTEGER)');
    RegisterMethod('Procedure RectangleIJ( const i1, i2, j1, j2 : INTEGER)');
    RegisterMethod('Procedure SetColor( const color : TColor)');
    RegisterMethod('Procedure LineTo( const v : TVector)');
    RegisterMethod('Procedure MoveTo( const v : TVector)');
    RegisterMethod('Procedure PointAt( const v : TVector)');
    RegisterMethod('Procedure Rectangle( const v1, v2 : TVector)');
    RegisterMethod('Procedure TextOutIJ( const i, j : INTEGER; const Text : STRING)');
    RegisterMethod('Procedure TextOut( const v : TVector; const Text : STRING)');
    RegisterMethod('Procedure SetPositioning( const p : TPositioning)');
    RegisterMethod('Procedure SetRelativeBase( const v : TVector)');
    RegisterMethod('Procedure Clip( var u1, u2 : TVector; var visible : BOOLEAN)');
    RegisterMethod('Procedure SetClipping( const flag : BOOLEAN)');
    RegisterMethod('Procedure Project( const u : TVector; var v : TVector)');
    RegisterMethod('Procedure SetProjection( const PrjType : TProjection)');
    RegisterMethod('Procedure ClearTransform( const d : Tdimension)');
    RegisterMethod('Procedure GetTransform( const d : Tdimension; var a : TMatrix)');
    RegisterMethod('Procedure SetTransform( const a : TMatrix)');
    RegisterMethod('Procedure VectorTransform( const u : TVector; var v : TVector)');
    RegisterMethod('Procedure WorldCoordinatesRange( const xMin, xMax, yMin, yMax : DOUBLE)');
    RegisterMethod('Procedure ViewPort( const xFractionMin, xFractionMax, yFractionMin, yFractionMax : DOUBLE)');
    RegisterMethod('Procedure ShowViewPortOutline');
    RegisterMethod('Procedure WorldToPixel( const v : TVector; var i, j : INTEGER)');
    RegisterMethod('Procedure PixelToWorld( const i, j : INTEGER; var visible : BOOLEAN; var x, y : DOUBLE)');
    RegisterMethod('Procedure SetCoordinateType( const c : Tcoordinate)');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_GraphicsPrimitivesLibrary(CL: TPSPascalCompiler);
begin
  CL.AddClassN(CL.FindClass('TOBJECT'),'EGraphicsError');
  CL.AddTypeS('TProjection', '( pOrthoXY, pOrthoXZ, pOrthoYZ, pPerspective )');
  CL.AddTypeS('TPositioning', '( positionAbsolute, positionRelative )');
  SIRegister_TPantoGraph(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TPantoGraphCanvas_W(Self: TPantoGraph; const T: TCanvas);
Begin Self.Canvas := T; end;

(*----------------------------------------------------------------------------*)
procedure TPantoGraphCanvas_R(Self: TPantoGraph; var T: TCanvas);
Begin T := Self.Canvas; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TPantoGraph(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TPantoGraph) do begin
    RegisterPropertyHelper(@TPantoGraphCanvas_R,@TPantoGraphCanvas_W,'Canvas');
    RegisterConstructor(@TPantoGraph.Create, 'Create');
       RegisterMethod(@TPantoGraph.Destroy, 'Free');
        RegisterMethod(@TPantoGraph.LineToIJ, 'LineToIJ');
    RegisterMethod(@TPantoGraph.MoveToIJ, 'MoveToIJ');
    RegisterMethod(@TPantoGraph.PointAtIJ, 'PointAtIJ');
    RegisterMethod(@TPantoGraph.RectangleIJ, 'RectangleIJ');
    RegisterMethod(@TPantoGraph.SetColor, 'SetColor');
    RegisterMethod(@TPantoGraph.LineTo, 'LineTo');
    RegisterMethod(@TPantoGraph.MoveTo, 'MoveTo');
    RegisterMethod(@TPantoGraph.PointAt, 'PointAt');
    RegisterMethod(@TPantoGraph.Rectangle, 'Rectangle');
    RegisterMethod(@TPantoGraph.TextOutIJ, 'TextOutIJ');
    RegisterMethod(@TPantoGraph.TextOut, 'TextOut');
    RegisterMethod(@TPantoGraph.SetPositioning, 'SetPositioning');
    RegisterMethod(@TPantoGraph.SetRelativeBase, 'SetRelativeBase');
    RegisterMethod(@TPantoGraph.Clip, 'Clip');
    RegisterMethod(@TPantoGraph.SetClipping, 'SetClipping');
    RegisterMethod(@TPantoGraph.Project, 'Project');
    RegisterMethod(@TPantoGraph.SetProjection, 'SetProjection');
    RegisterMethod(@TPantoGraph.ClearTransform, 'ClearTransform');
    RegisterMethod(@TPantoGraph.GetTransform, 'GetTransform');
    RegisterMethod(@TPantoGraph.SetTransform, 'SetTransform');
    RegisterMethod(@TPantoGraph.VectorTransform, 'VectorTransform');
    RegisterMethod(@TPantoGraph.WorldCoordinatesRange, 'WorldCoordinatesRange');
    RegisterMethod(@TPantoGraph.ViewPort, 'ViewPort');
    RegisterMethod(@TPantoGraph.ShowViewPortOutline, 'ShowViewPortOutline');
    RegisterMethod(@TPantoGraph.WorldToPixel, 'WorldToPixel');
    RegisterMethod(@TPantoGraph.PixelToWorld, 'PixelToWorld');
    RegisterMethod(@TPantoGraph.SetCoordinateType, 'SetCoordinateType');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_GraphicsPrimitivesLibrary(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(EGraphicsError) do
  RIRegister_TPantoGraph(CL);
end;

 
 
{ TPSImport_GraphicsPrimitivesLibrary }
(*----------------------------------------------------------------------------*)
procedure TPSImport_GraphicsPrimitivesLibrary.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_GraphicsPrimitivesLibrary(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_GraphicsPrimitivesLibrary.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_GraphicsPrimitivesLibrary(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
