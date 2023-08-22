unit uPSI_MathUtils;
{
from BCD
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
  TPSImport_MathUtils = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_MathUtils(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_MathUtils_Routines(S: TPSExec);

procedure Register;

implementation


uses
   Windows
  ,Math
  ,MathUtils
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_MathUtils]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_MathUtils(CL: TPSPascalCompiler);
begin
  //CL.AddTypeS('Float', 'Single');
 //CL.AddConstantN('MaxFloat','').SetString( MaxSingle);
 // CL.AddTypeS('Float', 'Double');
 //CL.AddConstantN('MaxFloat','').SetString( MaxDouble);
 // CL.AddTypeS('PFloat', '^Float // will not work');
 // CL.AddTypeS('PFloatArray', '^TFloatArray // will not work');
  CL.AddTypeS('TFloatDynArray', 'array of Float');
 // CL.AddTypeS('PSingleArray', '^TSingleArray // will not work');
 // CL.AddTypeS('PDoubleArray', '^TDoubleArray // will not work');
  CL.AddTypeS('TFloatPoint', 'record X : Float; Y : Float; end');

  CL.AddTypeS('TFloatRect','record Left, Top, Right, Bottom : Float; end');

  CL.AddTypeS('TFloatPointArray', 'array of TFloatPoint');
 //CL.AddDelphiFunction('Procedure TridiagonalSolve( var T : array of TTriDiagRec; var y : array of Double; N : Integer)');
 CL.AddDelphiFunction('Procedure ShuffleList( var List : array of Integer; Count : Integer)');
 CL.AddDelphiFunction('Function Ceil4( X : Integer) : Integer');
 CL.AddDelphiFunction('Function Ceil8( X : Integer) : Integer');
 CL.AddDelphiFunction('Function Ceil16( X : Integer) : Integer');
 CL.AddDelphiFunction('Function FloorInt( Value : Integer; StepSize : Integer) : Integer');
 CL.AddDelphiFunction('Function RoundInt( Value : Integer; StepSize : Integer) : Integer');
 CL.AddDelphiFunction('Procedure Diff( var X : array of Double)');
 CL.AddDelphiFunction('Function InRangeR( const A, Min, Max : Double) : Boolean');
 CL.AddDelphiFunction('Function ForceInRange( A, Min, Max : Integer) : Integer');
 CL.AddDelphiFunction('Function ForceInRangeR( const A, Min, Max : Double) : Double');
 CL.AddDelphiFunction('Function ForceInBox( const Point : TPoint; const Box : TRect) : TPoint');
 CL.AddDelphiFunction('Function RoundPoint( const X, Y : Double) : TPoint');
 CL.AddDelphiFunction('Function FloatPoint( const X, Y : Float) : TFloatPoint;');
 CL.AddDelphiFunction('Function FloatPoint1( const P : TPoint) : TFloatPoint;');
 CL.AddDelphiFunction('Function OffsetPoint( const P, Offset : TPoint) : TPoint');
 CL.AddDelphiFunction('Function LineInRect( const P1, P2 : TPoint; const Rect : TRect) : Boolean;');
 CL.AddDelphiFunction('Function LineInRect1( const P1, P2 : TFloatPoint; const Rect : TFloatRect) : Boolean;');
 CL.AddDelphiFunction('Function ClipLineToRect( var P1, P2 : TFloatPoint; const Rect : TFloatRect) : Boolean');
 CL.AddDelphiFunction('Function LineSegmentIntersection( const L1P1 : TFloatPoint; L1P2 : TFloatPoint; const L2P1 : TFloatPoint; L2P2 : TFloatPoint; var P : TFloatPoint) : Boolean');
 CL.AddDelphiFunction('Function PointToLineSegmentDist( const Point, LineP1, LineP2 : TFloatPoint) : Double');
 CL.AddDelphiFunction('Function PointDist( const P1, P2 : TPoint) : Double;');
 CL.AddDelphiFunction('Function PointDist1( const P1, P2 : TFloatPoint) : Double;');
 CL.AddDelphiFunction('Function NormalizeRect( const Rect : TRect) : TRect');
 CL.AddDelphiFunction('Function RoundRect( const ALeft, ATop, ARight, ABottom : Double) : TRect');
 CL.AddDelphiFunction('Function FloatRect( const ALeft, ATop, ARight, ABottom : Double) : TFloatRect;');
 CL.AddDelphiFunction('Function FloatRect1( const Rect : TRect) : TFloatRect;');
 CL.AddDelphiFunction('Function FloatPtInRect( const Rect : TFloatRect; const P : TFloatPoint) : Boolean');
 CL.AddDelphiFunction('Function sinc( const x : Double) : Double');
 CL.AddDelphiFunction('Function Gauss( const x, Spread : Double) : Double');
 CL.AddDelphiFunction('Function VectorAdd( const V1, V2 : TFloatPoint) : TFloatPoint');
 CL.AddDelphiFunction('Function VectorSubtract( const V1, V2 : TFloatPoint) : TFloatPoint');
 CL.AddDelphiFunction('Function VectorDot( const V1, V2 : TFloatPoint) : Double');
 CL.AddDelphiFunction('Function VectorLengthSqr( const V : TFloatPoint) : Double');
 CL.AddDelphiFunction('Function VectorMult( const V : TFloatPoint; const s : Double) : TFloatPoint');
 CL.AddDelphiFunction('Function RotatePoint( Point : TFloatPoint; const Center : TFloatPoint; const Angle : Float) : TFloatPoint');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
Function FloatRect1_P( const Rect : TRect) : TFloatRect;
Begin Result := MathUtils.FloatRect(Rect); END;

(*----------------------------------------------------------------------------*)
Function FloatRect_P( const ALeft, ATop, ARight, ABottom : Double) : TFloatRect;
Begin Result := MathUtils.FloatRect(ALeft, ATop, ARight, ABottom); END;

(*----------------------------------------------------------------------------*)
Function PointDist1_P( const P1, P2 : TFloatPoint) : Double;
Begin Result := MathUtils.PointDist(P1, P2); END;

(*----------------------------------------------------------------------------*)
Function PointDist_P( const P1, P2 : TPoint) : Double;
Begin Result := MathUtils.PointDist(P1, P2); END;

(*----------------------------------------------------------------------------*)
Function LineInRect1_P( const P1, P2 : TFloatPoint; const Rect : TFloatRect) : Boolean;
Begin Result := MathUtils.LineInRect(P1, P2, Rect); END;

(*----------------------------------------------------------------------------*)
Function LineInRect_P( const P1, P2 : TPoint; const Rect : TRect) : Boolean;
Begin Result := MathUtils.LineInRect(P1, P2, Rect); END;

(*----------------------------------------------------------------------------*)
Function FloatPoint1_P( const P : TPoint) : TFloatPoint;
Begin Result := MathUtils.FloatPoint(P); END;

(*----------------------------------------------------------------------------*)
Function FloatPoint_P( const X, Y : Float) : TFloatPoint;
Begin Result := MathUtils.FloatPoint(X, Y); END;

(*----------------------------------------------------------------------------*)
procedure RIRegister_MathUtils_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@TridiagonalSolve, 'TridiagonalSolve', cdRegister);
 S.RegisterDelphiFunction(@ShuffleList, 'ShuffleList', cdRegister);
 S.RegisterDelphiFunction(@Ceil4, 'Ceil4', cdRegister);
 S.RegisterDelphiFunction(@Ceil8, 'Ceil8', cdRegister);
 S.RegisterDelphiFunction(@Ceil16, 'Ceil16', cdRegister);
 S.RegisterDelphiFunction(@FloorInt, 'FloorInt', cdRegister);
 S.RegisterDelphiFunction(@RoundInt, 'RoundInt', cdRegister);
 S.RegisterDelphiFunction(@Diff, 'Diff', cdRegister);
 S.RegisterDelphiFunction(@InRangeR, 'InRangeR', cdRegister);
 S.RegisterDelphiFunction(@ForceInRange, 'ForceInRange', cdRegister);
 S.RegisterDelphiFunction(@ForceInRangeR, 'ForceInRangeR', cdRegister);
 S.RegisterDelphiFunction(@ForceInBox, 'ForceInBox', cdRegister);
 S.RegisterDelphiFunction(@RoundPoint, 'RoundPoint', cdRegister);
 S.RegisterDelphiFunction(@FloatPoint, 'FloatPoint', cdRegister);
 S.RegisterDelphiFunction(@FloatPoint1_P, 'FloatPoint1', cdRegister);
 S.RegisterDelphiFunction(@OffsetPoint, 'OffsetPoint', cdRegister);
 S.RegisterDelphiFunction(@LineInRect, 'LineInRect', cdRegister);
 S.RegisterDelphiFunction(@LineInRect1_P, 'LineInRect1', cdRegister);
 S.RegisterDelphiFunction(@ClipLineToRect, 'ClipLineToRect', cdRegister);
 S.RegisterDelphiFunction(@LineSegmentIntersection, 'LineSegmentIntersection', cdRegister);
 S.RegisterDelphiFunction(@PointToLineSegmentDist, 'PointToLineSegmentDist', cdRegister);
 S.RegisterDelphiFunction(@PointDist, 'PointDist', cdRegister);
 S.RegisterDelphiFunction(@PointDist1_P, 'PointDist1', cdRegister);
 S.RegisterDelphiFunction(@NormalizeRect, 'NormalizeRect', cdRegister);
 S.RegisterDelphiFunction(@RoundRect, 'RoundRect', cdRegister);
 S.RegisterDelphiFunction(@FloatRect, 'FloatRect', cdRegister);
 S.RegisterDelphiFunction(@FloatRect1_P, 'FloatRect1', cdRegister);
 S.RegisterDelphiFunction(@FloatPtInRect, 'FloatPtInRect', cdRegister);
 S.RegisterDelphiFunction(@sinc, 'sinc', cdRegister);
 S.RegisterDelphiFunction(@Gauss, 'Gauss', cdRegister);
 S.RegisterDelphiFunction(@VectorAdd, 'VectorAdd', cdRegister);
 S.RegisterDelphiFunction(@VectorSubtract, 'VectorSubtract', cdRegister);
 S.RegisterDelphiFunction(@VectorDot, 'VectorDot', cdRegister);
 S.RegisterDelphiFunction(@VectorLengthSqr, 'VectorLengthSqr', cdRegister);
 S.RegisterDelphiFunction(@VectorMult, 'VectorMult', cdRegister);
 S.RegisterDelphiFunction(@RotatePoint, 'RotatePoint', cdRegister);
end;



{ TPSImport_MathUtils }
(*----------------------------------------------------------------------------*)
procedure TPSImport_MathUtils.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_MathUtils(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_MathUtils.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  //RIRegister_MathUtils(ri);
  RIRegister_MathUtils_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
