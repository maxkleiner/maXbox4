unit uPSI_utexplot;
{
  latex
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
  TPSImport_utexplot = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_utexplot(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_utexplot_Routines(S: TPSExec);

procedure Register;

implementation


uses
   utypes
  ,umath
  ,uminmax
  ,uround
  ,ustrings
  ,utexplot
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_utexplot]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_utexplot(CL: TPSPascalCompiler);
begin
 CL.AddDelphiFunction('Function TeX_InitGraphics( FileName : String; PgWidth, PgHeight : Integer; Header : Boolean) : Boolean');
 CL.AddDelphiFunction('Procedure TeX_SetWindow( X1, X2, Y1, Y2 : Integer; GraphBorder : Boolean)');
 CL.AddDelphiFunction('Procedure TeX_LeaveGraphics( Footer : Boolean)');
 CL.AddDelphiFunction('Procedure TeX_SetOxScale( Scale : TScale; OxMin, OxMax, OxStep : Float)');
 CL.AddDelphiFunction('Procedure TeX_SetOyScale( Scale : TScale; OyMin, OyMax, OyStep : Float)');
 CL.AddDelphiFunction('Procedure TeX_SetGraphTitle( Title : String)');
 CL.AddDelphiFunction('Procedure TeX_SetOxTitle( Title : String)');
 CL.AddDelphiFunction('Procedure TeX_SetOyTitle( Title : String)');
 CL.AddDelphiFunction('Procedure TeX_PlotOxAxis');
 CL.AddDelphiFunction('Procedure TeX_PlotOyAxis');
 CL.AddDelphiFunction('Procedure TeX_PlotGrid( Grid : TGrid)');
 CL.AddDelphiFunction('Procedure TeX_WriteGraphTitle');
 CL.AddDelphiFunction('Function TeX_SetMaxCurv( NCurv : Byte) : Boolean');
 CL.AddDelphiFunction('Procedure TeX_SetPointParam( CurvIndex, Symbol, Size : Integer)');
 CL.AddDelphiFunction('Procedure TeX_SetLineParam( CurvIndex, Style : Integer; Width : Float; Smooth : Boolean)');
 CL.AddDelphiFunction('Procedure TeX_SetCurvLegend( CurvIndex : Integer; Legend : String)');
 CL.AddDelphiFunction('Procedure TeX_SetCurvStep( CurvIndex, Step : Integer)');
 CL.AddDelphiFunction('Procedure TeX_PlotCurve( X, Y : TVector; Lb, Ub, CurvIndex : Integer)');
 CL.AddDelphiFunction('Procedure TeX_PlotCurveWithErrorBars( X, Y, S : TVector; Ns, Lb, Ub, CurvIndex : Integer)');
 CL.AddDelphiFunction('Procedure TeX_PlotFunc( Func : TFunc; X1, X2 : Float; Npt : Integer; CurvIndex : Integer)');
 CL.AddDelphiFunction('Procedure TeX_WriteLegend( NCurv : Integer; ShowPoints, ShowLines : Boolean)');
 CL.AddDelphiFunction('Procedure TeX_ConRec( Nx, Ny, Nc : Integer; X, Y, Z : TVector; F : TMatrix)');
 CL.AddDelphiFunction('Function Xcm( X : Float) : Float');
 CL.AddDelphiFunction('Function Ycm( Y : Float) : Float');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure RIRegister_utexplot_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@TeX_InitGraphics, 'TeX_InitGraphics', cdRegister);
 S.RegisterDelphiFunction(@TeX_SetWindow, 'TeX_SetWindow', cdRegister);
 S.RegisterDelphiFunction(@TeX_LeaveGraphics, 'TeX_LeaveGraphics', cdRegister);
 S.RegisterDelphiFunction(@TeX_SetOxScale, 'TeX_SetOxScale', cdRegister);
 S.RegisterDelphiFunction(@TeX_SetOyScale, 'TeX_SetOyScale', cdRegister);
 S.RegisterDelphiFunction(@TeX_SetGraphTitle, 'TeX_SetGraphTitle', cdRegister);
 S.RegisterDelphiFunction(@TeX_SetOxTitle, 'TeX_SetOxTitle', cdRegister);
 S.RegisterDelphiFunction(@TeX_SetOyTitle, 'TeX_SetOyTitle', cdRegister);
 S.RegisterDelphiFunction(@TeX_PlotOxAxis, 'TeX_PlotOxAxis', cdRegister);
 S.RegisterDelphiFunction(@TeX_PlotOyAxis, 'TeX_PlotOyAxis', cdRegister);
 S.RegisterDelphiFunction(@TeX_PlotGrid, 'TeX_PlotGrid', cdRegister);
 S.RegisterDelphiFunction(@TeX_WriteGraphTitle, 'TeX_WriteGraphTitle', cdRegister);
 S.RegisterDelphiFunction(@TeX_SetMaxCurv, 'TeX_SetMaxCurv', cdRegister);
 S.RegisterDelphiFunction(@TeX_SetPointParam, 'TeX_SetPointParam', cdRegister);
 S.RegisterDelphiFunction(@TeX_SetLineParam, 'TeX_SetLineParam', cdRegister);
 S.RegisterDelphiFunction(@TeX_SetCurvLegend, 'TeX_SetCurvLegend', cdRegister);
 S.RegisterDelphiFunction(@TeX_SetCurvStep, 'TeX_SetCurvStep', cdRegister);
 S.RegisterDelphiFunction(@TeX_PlotCurve, 'TeX_PlotCurve', cdRegister);
 S.RegisterDelphiFunction(@TeX_PlotCurveWithErrorBars, 'TeX_PlotCurveWithErrorBars', cdRegister);
 S.RegisterDelphiFunction(@TeX_PlotFunc, 'TeX_PlotFunc', cdRegister);
 S.RegisterDelphiFunction(@TeX_WriteLegend, 'TeX_WriteLegend', cdRegister);
 S.RegisterDelphiFunction(@TeX_ConRec, 'TeX_ConRec', cdRegister);
 S.RegisterDelphiFunction(@Xcm, 'Xcm', cdRegister);
 S.RegisterDelphiFunction(@Ycm, 'Ycm', cdRegister);
end;

 
 
{ TPSImport_utexplot }
(*----------------------------------------------------------------------------*)
procedure TPSImport_utexplot.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_utexplot(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_utexplot.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  //RIRegister_utexplot(ri);
  RIRegister_utexplot_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
