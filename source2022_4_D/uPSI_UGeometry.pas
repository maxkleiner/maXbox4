unit uPSI_UGeometry;
{
   ekliptisch     EUKLID
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
  TPSImport_UGeometry = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_UGeometry(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_UGeometry_Routines(S: TPSExec);

procedure Register;

implementation


uses
   Windows
  ,Dialogs
  ,Types
  ,UGeometry
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_UGeometry]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_UGeometry(CL: TPSPascalCompiler);
begin
  CL.AddTypeS('TrealPoint', 'record x : extended; y : extended; end');
  CL.AddTypeS('Tline', 'record p1 : TPoint; p2 : TPoint; end');
  CL.AddTypeS('TRealLine', 'record p1 : TRealPoint; p2 : TRealPoint; end');
  CL.AddTypeS('TCircle', 'record cx : integer; cy : integer; r : integer; end');
  CL.AddTypeS('TRealCircle', 'record cx : extended; cy : extended; r : extended; end');
  CL.AddTypeS('PPResult', '( PPoutside, PPInside, PPVertex, PPEdge, PPError )');
 CL.AddDelphiFunction('Function realpoint( x, y : extended) : TRealPoint');
 CL.AddDelphiFunction('Function dist( const p1, p2 : TrealPoint) : extended');
 CL.AddDelphiFunction('Function intdist( const p1, p2 : TPoint) : integer');
 CL.AddDelphiFunction('Function dffLine( const p1, p2 : TPoint) : Tline;');
 CL.AddDelphiFunction('Function Line1( const p1, p2 : TRealPoint) : TRealline;');
 CL.AddDelphiFunction('Function dffCircle( const cx, cy, R : integer) : TCircle;');
 CL.AddDelphiFunction('Function Circle1( const cx, cy, R : extended) : TRealCircle;');
 CL.AddDelphiFunction('Function GetTheta( const L : TLine) : extended;');
 CL.AddDelphiFunction('Function GetTheta1( const p1, p2 : TPoint) : extended;');
 CL.AddDelphiFunction('Function GetTheta2( const p1, p2 : TRealPoint) : extended;');
 CL.AddDelphiFunction('Procedure Extendline( var L : TLine; dist : integer);');
 CL.AddDelphiFunction('Procedure Extendline1( var L : TRealLine; dist : extended);');
 CL.AddDelphiFunction('Function Linesintersect( line1, line2 : TLine) : boolean');
 CL.AddDelphiFunction('Function ExtendedLinesIntersect( Line1, Line2 : TLine; const extendlines : boolean; var IP : TPoint) : boolean;');
 CL.AddDelphiFunction('Function ExtendedLinesIntersect1( const Line1, Line2 : TLine; const extendlines : boolean; var IP : TRealPoint) : boolean;');
 CL.AddDelphiFunction('Function Intersect( L1, L2 : TLine; var pointonborder : boolean; var IP : TPoint) : boolean');
 CL.AddDelphiFunction('Function PointPerpendicularLine( L : TLine; P : TPoint) : TLine');
 CL.AddDelphiFunction('Function PerpDistance( L : TLine; P : TPoint) : Integer');
 CL.AddDelphiFunction('Function AngledLineFromLine( L : TLine; P : TPoint; Dist : extended; alpha : extended) : TLine;');
 CL.AddDelphiFunction('Function AngledLineFromLine1( L : TLine; P : TPoint; Dist : extended; alpha : extended; useScreenCoordinates : boolean) : TLine;');
 CL.AddDelphiFunction('Function PointInPoly( const p : TPoint; Points : array of TPoint) : PPResult');
 CL.AddDelphiFunction('Function PolygonArea( const points : array of TPoint; const screencoordinates : boolean; var Clockwise : boolean) : integer');
 CL.AddDelphiFunction('Procedure InflatePolygon( const points : array of Tpoint; var points2 : array of TPoint; var area : integer; const screenCoordinates : boolean; const inflateby : integer)');
 CL.AddDelphiFunction('Function PolyBuiltClockwise( const points : array of TPoint; const screencoordinates : boolean) : boolean');
 CL.AddDelphiFunction('Function dffDegtoRad( d : extended) : extended');
 CL.AddDelphiFunction('Function dffRadtoDeg( r : extended) : extended');
 CL.AddDelphiFunction('Procedure TranslateLeftTo( var L : TLine; newend : TPoint);');
 CL.AddDelphiFunction('Procedure TranslateLeftTo1( var L : TrealLine; newend : TrealPoint);');
 CL.AddDelphiFunction('Procedure RotateRightEndBy( var L : TLine; alpha : extended)');
 CL.AddDelphiFunction('Procedure RotateRightEndTo( var L : TLine; alpha : extended);');
 CL.AddDelphiFunction('Procedure RotateRightEndTo1( var p1, p2 : Trealpoint; alpha : extended);');
 CL.AddDelphiFunction('Function CircleCircleIntersect( c1, c2 : TCircle; var IP1, Ip2 : TPoint) : boolean;');
 CL.AddDelphiFunction('Function CircleCircleIntersect1( c1, c2 : TRealCircle; var IP1, Ip2 : TRealPoint) : boolean;');
 CL.AddDelphiFunction('Function PointCircleTangentLines( const C : TCircle; const P : TPoint; var L1, L2 : TLine) : boolean');
 CL.AddDelphiFunction('Function CircleCircleExtTangentLines( C1, C2 : TCircle; var C3 : TCircle; var L1, L2, PL1, PL2, TL1, Tl2 : TLine) : Boolean');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
Function CircleCircleIntersect1_P( c1, c2 : TRealCircle; var IP1, Ip2 : TRealPoint) : boolean;
Begin Result := UGeometry.CircleCircleIntersect(c1, c2, IP1, Ip2); END;

(*----------------------------------------------------------------------------*)
Function CircleCircleIntersect_P( c1, c2 : TCircle; var IP1, Ip2 : TPoint) : boolean;
Begin Result := UGeometry.CircleCircleIntersect(c1, c2, IP1, Ip2); END;

(*----------------------------------------------------------------------------*)
Procedure RotateRightEndTo1_P( var p1, p2 : Trealpoint; alpha : extended);
Begin UGeometry.RotateRightEndTo(p1, p2, alpha); END;

(*----------------------------------------------------------------------------*)
Procedure RotateRightEndTo_P( var L : TLine; alpha : extended);
Begin UGeometry.RotateRightEndTo(L, alpha); END;

(*----------------------------------------------------------------------------*)
Procedure TranslateLeftTo1_P( var L : TrealLine; newend : TrealPoint);
Begin UGeometry.TranslateLeftTo(L, newend); END;

(*----------------------------------------------------------------------------*)
Procedure TranslateLeftTo_P( var L : TLine; newend : TPoint);
Begin UGeometry.TranslateLeftTo(L, newend); END;

(*----------------------------------------------------------------------------*)
Function AngledLineFromLine1_P( L : TLine; P : TPoint; Dist : extended; alpha : extended; useScreenCoordinates : boolean) : TLine;
Begin Result := UGeometry.AngledLineFromLine(L, P, Dist, alpha, useScreenCoordinates); END;

(*----------------------------------------------------------------------------*)
Function AngledLineFromLine_P( L : TLine; P : TPoint; Dist : extended; alpha : extended) : TLine;
Begin Result := UGeometry.AngledLineFromLine(L, P, Dist, alpha); END;

(*----------------------------------------------------------------------------*)
Function ExtendedLinesIntersect1_P( const Line1, Line2 : TLine; const extendlines : boolean; var IP : TRealPoint) : boolean;
Begin Result := UGeometry.ExtendedLinesIntersect(Line1, Line2, extendlines, IP); END;

(*----------------------------------------------------------------------------*)
Function ExtendedLinesIntersect_P( Line1, Line2 : TLine; const extendlines : boolean; var IP : TPoint) : boolean;
Begin Result := UGeometry.ExtendedLinesIntersect(Line1, Line2, extendlines, IP); END;

(*----------------------------------------------------------------------------*)
Procedure Extendline1_P( var L : TRealLine; dist : extended);
Begin UGeometry.Extendline(L, dist); END;

(*----------------------------------------------------------------------------*)
Procedure Extendline_P( var L : TLine; dist : integer);
Begin UGeometry.Extendline(L, dist); END;

(*----------------------------------------------------------------------------*)
Function GetTheta2_P( const p1, p2 : TRealPoint) : extended;
Begin Result := UGeometry.GetTheta(p1, p2); END;

(*----------------------------------------------------------------------------*)
Function GetTheta1_P( const p1, p2 : TPoint) : extended;
Begin Result := UGeometry.GetTheta(p1, p2); END;

(*----------------------------------------------------------------------------*)
Function GetTheta_P( const L : TLine) : extended;
Begin Result := UGeometry.GetTheta(L); END;

(*----------------------------------------------------------------------------*)
Function Circle1_P( const cx, cy, R : extended) : TRealCircle;
Begin Result := UGeometry.Circle(cx, cy, R); END;

(*----------------------------------------------------------------------------*)
Function Circle_P( const cx, cy, R : integer) : TCircle;
Begin Result := UGeometry.Circle(cx, cy, R); END;

(*----------------------------------------------------------------------------*)
Function Line1_P( const p1, p2 : TRealPoint) : TRealline;
Begin Result := UGeometry.Line(p1, p2); END;

(*----------------------------------------------------------------------------*)
Function Line_P( const p1, p2 : TPoint) : Tline;
Begin Result := UGeometry.Line(p1, p2); END;

(*----------------------------------------------------------------------------*)
procedure RIRegister_UGeometry_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@realpoint, 'realpoint', cdRegister);
 S.RegisterDelphiFunction(@dist, 'dist', cdRegister);
 S.RegisterDelphiFunction(@intdist, 'intdist', cdRegister);
 S.RegisterDelphiFunction(@Line, 'dffLine', cdRegister);
 S.RegisterDelphiFunction(@Line1_P, 'Line1', cdRegister);
 S.RegisterDelphiFunction(@Circle, 'dffCircle', cdRegister);
 S.RegisterDelphiFunction(@Circle1_P, 'Circle1', cdRegister);
 S.RegisterDelphiFunction(@GetTheta, 'GetTheta', cdRegister);
 S.RegisterDelphiFunction(@GetTheta1_P, 'GetTheta1', cdRegister);
 S.RegisterDelphiFunction(@GetTheta2_P, 'GetTheta2', cdRegister);
 S.RegisterDelphiFunction(@Extendline, 'Extendline', cdRegister);
 S.RegisterDelphiFunction(@Extendline1_P, 'Extendline1', cdRegister);
 S.RegisterDelphiFunction(@Linesintersect, 'Linesintersect', cdRegister);
 S.RegisterDelphiFunction(@ExtendedLinesIntersect, 'ExtendedLinesIntersect', cdRegister);
 S.RegisterDelphiFunction(@ExtendedLinesIntersect1_P, 'ExtendedLinesIntersect1', cdRegister);
 S.RegisterDelphiFunction(@Intersect, 'Intersect', cdRegister);
 S.RegisterDelphiFunction(@PointPerpendicularLine, 'PointPerpendicularLine', cdRegister);
 S.RegisterDelphiFunction(@PerpDistance, 'PerpDistance', cdRegister);
 S.RegisterDelphiFunction(@AngledLineFromLine, 'AngledLineFromLine', cdRegister);
 S.RegisterDelphiFunction(@AngledLineFromLine1_P, 'AngledLineFromLine1', cdRegister);
 S.RegisterDelphiFunction(@PointInPoly, 'PointInPoly', cdRegister);
 S.RegisterDelphiFunction(@PolygonArea, 'PolygonArea', cdRegister);
 S.RegisterDelphiFunction(@InflatePolygon, 'InflatePolygon', cdRegister);
 S.RegisterDelphiFunction(@PolyBuiltClockwise, 'PolyBuiltClockwise', cdRegister);
 S.RegisterDelphiFunction(@DegtoRad, 'dffDegtoRad', cdRegister);
 S.RegisterDelphiFunction(@RadtoDeg, 'dffRadtoDeg', cdRegister);
 S.RegisterDelphiFunction(@TranslateLeftTo, 'TranslateLeftTo', cdRegister);
 S.RegisterDelphiFunction(@TranslateLeftTo1_P, 'TranslateLeftTo1', cdRegister);
 S.RegisterDelphiFunction(@RotateRightEndBy, 'RotateRightEndBy', cdRegister);
 S.RegisterDelphiFunction(@RotateRightEndTo, 'RotateRightEndTo', cdRegister);
 S.RegisterDelphiFunction(@RotateRightEndTo1_P, 'RotateRightEndTo1', cdRegister);
 S.RegisterDelphiFunction(@CircleCircleIntersect, 'CircleCircleIntersect', cdRegister);
 S.RegisterDelphiFunction(@CircleCircleIntersect1_P, 'CircleCircleIntersect1', cdRegister);
 S.RegisterDelphiFunction(@PointCircleTangentLines, 'PointCircleTangentLines', cdRegister);
 S.RegisterDelphiFunction(@CircleCircleExtTangentLines, 'CircleCircleExtTangentLines', cdRegister);
end;

 
 
{ TPSImport_UGeometry }
(*----------------------------------------------------------------------------*)
procedure TPSImport_UGeometry.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_UGeometry(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_UGeometry.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  //RIRegister_UGeometry(ri);
  RIRegister_UGeometry_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
