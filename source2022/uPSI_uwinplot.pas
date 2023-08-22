unit uPSI_uwinplot;
{
  for a graphical universal plotter  - bugfix float to double
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
  TPSImport_uwinplot = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_uwinplot(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_uwinplot_Routines(S: TPSExec);

procedure Register;

implementation


uses
   Graphics
  ,utypes
  ,umath
  ,uround
  ,ustrings
  ,uwinplot
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_uwinplot]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_uwinplot(CL: TPSPascalCompiler);
begin
  //CL.AddTypeS('TFunc', 'function(X : double): double;');

 CL.AddDelphiFunction('Function InitGraphics( Width, Height : Integer) : Boolean');
 CL.AddDelphiFunction('Procedure SetWindow( Canvas : TCanvas; X1, X2, Y1, Y2 : Integer; GraphBorder : Boolean)');
 CL.AddDelphiFunction('Procedure SetOxScale( Scale : TScale; OxMin, OxMax, OxStep : Double)');
 CL.AddDelphiFunction('Procedure SetOyScale( Scale : TScale; OyMin, OyMax, OyStep : Double)');
 CL.AddDelphiFunction('Procedure GetOxScale( var Scale : TScale; var OxMin, OxMax, OxStep : Double)');
 CL.AddDelphiFunction('Procedure GetOyScale( var Scale : TScale; var OyMin, OyMax, OyStep : Double)');
 CL.AddDelphiFunction('Procedure SetGraphTitle( Title : String)');
 CL.AddDelphiFunction('Procedure SetOxTitle( Title : String)');
 CL.AddDelphiFunction('Procedure SetOyTitle( Title : String)');
 CL.AddDelphiFunction('Function GetGraphTitle : String');
 CL.AddDelphiFunction('Function GetOxTitle : String');
 CL.AddDelphiFunction('Function GetOyTitle : String');
 CL.AddDelphiFunction('Procedure PlotOxAxis( Canvas : TCanvas)');
 CL.AddDelphiFunction('Procedure PlotOyAxis( Canvas : TCanvas)');
 CL.AddDelphiFunction('Procedure PlotGrid( Canvas : TCanvas; Grid : TGrid)');
 CL.AddDelphiFunction('Procedure WriteGraphTitle( Canvas : TCanvas)');
 CL.AddDelphiFunction('Function SetMaxCurv( NCurv : Byte) : Boolean');
 CL.AddDelphiFunction('Procedure SetPointParam( CurvIndex, Symbol, Size : Integer; Color : TColor)');
 CL.AddDelphiFunction('Procedure SetLineParam( CurvIndex : Integer; Style : TPenStyle; Width : Integer; Color : TColor)');
 CL.AddDelphiFunction('Procedure SetCurvLegend( CurvIndex : Integer; Legend : String)');
 CL.AddDelphiFunction('Procedure SetCurvStep( CurvIndex, Step : Integer)');
 CL.AddDelphiFunction('Function GetMaxCurv : Byte');
 CL.AddDelphiFunction('Procedure GetPointParam( CurvIndex : Integer; var Symbol, Size : Integer; var Color : TColor)');
 CL.AddDelphiFunction('Procedure GetLineParam( CurvIndex : Integer; var Style : TPenStyle; var Width : Integer; var Color : TColor)');
 CL.AddDelphiFunction('Function GetCurvLegend( CurvIndex : Integer) : String');
 CL.AddDelphiFunction('Function GetCurvStep( CurvIndex : Integer) : Integer');
 CL.AddDelphiFunction('Procedure PlotPoint( Canvas : TCanvas; X, Y : Double; CurvIndex : Integer)');
 CL.AddDelphiFunction('Procedure PlotCurve( Canvas : TCanvas; X, Y : TVector; Lb, Ub, CurvIndex : Integer)');
 CL.AddDelphiFunction('Procedure PlotCurveWithErrorBars( Canvas : TCanvas; X, Y, S : TVector; Ns, Lb, Ub, CurvIndex : Integer)');
 CL.AddDelphiFunction('Procedure PlotFunc( Canvas : TCanvas; Func : TFunc; Xmin, Xmax : Double; Npt, CurvIndex : Integer)');
 CL.AddDelphiFunction('Procedure WriteLegend( Canvas : TCanvas; NCurv : Integer; ShowPoints, ShowLines : Boolean)');
 CL.AddDelphiFunction('Procedure ConRec( Canvas : TCanvas; Nx, Ny, Nc : Integer; X, Y, Z : TVector; F : TMatrix)');
 CL.AddDelphiFunction('Function Xpixel( X : Double) : Integer');
 CL.AddDelphiFunction('Function Ypixel( Y : Double) : Integer');
 CL.AddDelphiFunction('Function Xuser( X : Integer) : Double');
 CL.AddDelphiFunction('Function Yuser( Y : Integer) : Double');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure RIRegister_uwinplot_Routines(S: TPSExec);
begin

//type TFunc = function(X : Float) : Float;

 S.RegisterDelphiFunction(@InitGraphics, 'InitGraphics', cdRegister);
 S.RegisterDelphiFunction(@SetWindow, 'SetWindow', cdRegister);
 S.RegisterDelphiFunction(@SetOxScale, 'SetOxScale', cdRegister);
 S.RegisterDelphiFunction(@SetOyScale, 'SetOyScale', cdRegister);
 S.RegisterDelphiFunction(@GetOxScale, 'GetOxScale', cdRegister);
 S.RegisterDelphiFunction(@GetOyScale, 'GetOyScale', cdRegister);
 S.RegisterDelphiFunction(@SetGraphTitle, 'SetGraphTitle', cdRegister);
 S.RegisterDelphiFunction(@SetOxTitle, 'SetOxTitle', cdRegister);
 S.RegisterDelphiFunction(@SetOyTitle, 'SetOyTitle', cdRegister);
 S.RegisterDelphiFunction(@GetGraphTitle, 'GetGraphTitle', cdRegister);
 S.RegisterDelphiFunction(@GetOxTitle, 'GetOxTitle', cdRegister);
 S.RegisterDelphiFunction(@GetOyTitle, 'GetOyTitle', cdRegister);
 S.RegisterDelphiFunction(@PlotOxAxis, 'PlotOxAxis', cdRegister);
 S.RegisterDelphiFunction(@PlotOyAxis, 'PlotOyAxis', cdRegister);
 S.RegisterDelphiFunction(@PlotGrid, 'PlotGrid', cdRegister);
 S.RegisterDelphiFunction(@WriteGraphTitle, 'WriteGraphTitle', cdRegister);
 S.RegisterDelphiFunction(@SetMaxCurv, 'SetMaxCurv', cdRegister);
 S.RegisterDelphiFunction(@SetPointParam, 'SetPointParam', cdRegister);
 S.RegisterDelphiFunction(@SetLineParam, 'SetLineParam', cdRegister);
 S.RegisterDelphiFunction(@SetCurvLegend, 'SetCurvLegend', cdRegister);
 S.RegisterDelphiFunction(@SetCurvStep, 'SetCurvStep', cdRegister);
 S.RegisterDelphiFunction(@GetMaxCurv, 'GetMaxCurv', cdRegister);
 S.RegisterDelphiFunction(@GetPointParam, 'GetPointParam', cdRegister);
 S.RegisterDelphiFunction(@GetLineParam, 'GetLineParam', cdRegister);
 S.RegisterDelphiFunction(@GetCurvLegend, 'GetCurvLegend', cdRegister);
 S.RegisterDelphiFunction(@GetCurvStep, 'GetCurvStep', cdRegister);
 S.RegisterDelphiFunction(@PlotPoint, 'PlotPoint', cdRegister);
 S.RegisterDelphiFunction(@PlotCurve, 'PlotCurve', cdRegister);
 S.RegisterDelphiFunction(@PlotCurveWithErrorBars, 'PlotCurveWithErrorBars', cdRegister);
 S.RegisterDelphiFunction(@PlotFunc, 'PlotFunc', cdRegister);
 S.RegisterDelphiFunction(@WriteLegend, 'WriteLegend', cdRegister);
 S.RegisterDelphiFunction(@ConRec, 'ConRec', cdRegister);
 S.RegisterDelphiFunction(@Xpixel, 'Xpixel', cdRegister);
 S.RegisterDelphiFunction(@Ypixel, 'Ypixel', cdRegister);
 S.RegisterDelphiFunction(@Xuser, 'Xuser', cdRegister);
 S.RegisterDelphiFunction(@Yuser, 'Yuser', cdRegister);
end;

 
 
{ TPSImport_uwinplot }
(*----------------------------------------------------------------------------*)
procedure TPSImport_uwinplot.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_uwinplot(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_uwinplot.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  //RIRegister_uwinplot(ri);
  RIRegister_uwinplot_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
