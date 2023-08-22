unit uPSI_GeometryBB;
{
   space invaders
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
  TPSImport_GeometryBB = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_GeometryBB(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_GeometryBB_Routines(S: TPSExec);

procedure Register;

implementation


uses
   VectorGeometry
  ,GeometryBB
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_GeometryBB]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_GeometryBB(CL: TPSPascalCompiler);
begin
  CL.AddTypeS('TAABB', 'record min : TAffineVector; max : TAffineVector; end');
  //CL.AddTypeS('PAABB', '^TAABB // will not work');
 CL.AddTypeS('THmgBoundingBox', 'array [0..7] of TVector');
 CL.AddTypeS('THmgPlane', 'TVector');

 //THmgPlane = TVector;

 CL.AddTypeS('TAABBCorners', 'array [0..7] of TAffineVector');
  CL.AddTypeS('TFrustum', 'record pLeft, pTop, pRight, pBottom, pNear, pFar: THmgPlane; end');

 { TFrustum = record
      pLeft, pTop, pRight, pBottom, pNear, pFar : THmgPlane;
   end;}

 //TAABBCorners = array[0..7] of TAffineVector;
 // THmgBoundingBox = array [0..7] of TVector; {JT}
     {: Structure for storing Axis Aligned Bounding Boxes }
   //TAABB = record   min, max : TAffineVector;    end;
 CL.AddTypeS('TBSphere', 'record Center : TAffineVector; Radius : single; end');
 CL.AddTypeS('TClipRect', 'record Left : Single; Top : Single; Right : Single; Bottom : Single; end');
 CL.AddTypeS('TSpaceContains', '(scNoOverlap, scContainsFully, scContainsPartially )');
 CL.AddDelphiFunction('Function AddBB( var c1 : THmgBoundingBox; const c2 : THmgBoundingBox) : THmgBoundingBox');
 CL.AddDelphiFunction('Procedure AddAABB( var aabb : TAABB; const aabb1 : TAABB)');
 CL.AddDelphiFunction('Procedure SetBB( var c : THmgBoundingBox; const v : TVector)');
 CL.AddDelphiFunction('Procedure SetAABB( var bb : TAABB; const v : TVector)');
 CL.AddDelphiFunction('Procedure BBTransform( var c : THmgBoundingBox; const m : TMatrix)');
 CL.AddDelphiFunction('Procedure AABBTransform( var bb : TAABB; const m : TMatrix)');
 CL.AddDelphiFunction('Procedure AABBScale( var bb : TAABB; const v : TAffineVector)');
 CL.AddDelphiFunction('Function BBMinX( const c : THmgBoundingBox) : Single');
 CL.AddDelphiFunction('Function BBMaxX( const c : THmgBoundingBox) : Single');
 CL.AddDelphiFunction('Function BBMinY( const c : THmgBoundingBox) : Single');
 CL.AddDelphiFunction('Function BBMaxY( const c : THmgBoundingBox) : Single');
 CL.AddDelphiFunction('Function BBMinZ( const c : THmgBoundingBox) : Single');
 CL.AddDelphiFunction('Function BBMaxZ( const c : THmgBoundingBox) : Single');
 CL.AddDelphiFunction('Procedure AABBInclude( var bb : TAABB; const p : TAffineVector)');
 CL.AddDelphiFunction('Procedure AABBFromSweep( var SweepAABB : TAABB; const Start, Dest : TVector; const Radius : Single)');
 CL.AddDelphiFunction('Function AABBIntersection( const aabb1, aabb2 : TAABB) : TAABB');
 CL.AddDelphiFunction('Function BBToAABB( const aBB : THmgBoundingBox) : TAABB');
 CL.AddDelphiFunction('Function AABBToBB( const anAABB : TAABB) : THmgBoundingBox;');
 CL.AddDelphiFunction('Function AABBToBB1( const anAABB : TAABB; const m : TMatrix) : THmgBoundingBox;');
 CL.AddDelphiFunction('Procedure OffsetAABB( var aabb : TAABB; const delta : TAffineVector);');
 CL.AddDelphiFunction('Procedure OffsetAABB1( var aabb : TAABB; const delta : TVector);');
 CL.AddDelphiFunction('Function IntersectAABBs( const aabb1, aabb2 : TAABB; const m1To2, m2To1 : TMatrix) : Boolean;');
 CL.AddDelphiFunction('Function IntersectAABBsAbsoluteXY( const aabb1, aabb2 : TAABB) : Boolean');
 CL.AddDelphiFunction('Function IntersectAABBsAbsoluteXZ( const aabb1, aabb2 : TAABB) : Boolean');
 CL.AddDelphiFunction('Function IntersectAABBsAbsolute( const aabb1, aabb2 : TAABB) : Boolean');
 CL.AddDelphiFunction('Function AABBFitsInAABBAbsolute( const aabb1, aabb2 : TAABB) : Boolean');
 CL.AddDelphiFunction('Function PointInAABB( const p : TAffineVector; const aabb : TAABB) : Boolean;');
 CL.AddDelphiFunction('Function PointInAABB1( const p : TVector; const aabb : TAABB) : Boolean;');
 CL.AddDelphiFunction('Function PlaneIntersectAABB( Normal : TAffineVector; d : single; aabb : TAABB) : boolean');
 CL.AddDelphiFunction('Function TriangleIntersectAABB( const aabb : TAABB; v1, v2, v3 : TAffineVector) : boolean');
 CL.AddDelphiFunction('Procedure ExtractAABBCorners( const AABB : TAABB; var AABBCorners : TAABBCorners)');
 CL.AddDelphiFunction('Procedure AABBToBSphere( const AABB : TAABB; var BSphere : TBSphere)');
 CL.AddDelphiFunction('Procedure BSphereToAABB( const BSphere : TBSphere; var AABB : TAABB);');
 CL.AddDelphiFunction('Function BSphereToAABB1( const center : TAffineVector; radius : Single) : TAABB;');
 CL.AddDelphiFunction('Function BSphereToAABB2( const center : TVector; radius : Single) : TAABB;');
 CL.AddDelphiFunction('Function AABBContainsAABB( const mainAABB, testAABB : TAABB) : TSpaceContains');
 CL.AddDelphiFunction('Function BSphereContainsAABB( const mainBSphere : TBSphere; const testAABB : TAABB) : TSpaceContains');
 CL.AddDelphiFunction('Function BSphereContainsBSphere( const mainBSphere, testBSphere : TBSphere) : TSpaceContains');
 CL.AddDelphiFunction('Function AABBContainsBSphere( const mainAABB : TAABB; const testBSphere : TBSphere) : TSpaceContains');
 CL.AddDelphiFunction('Function PlaneContainsBSphere( const Location, Normal : TAffineVector; const testBSphere : TBSphere) : TSpaceContains');
 CL.AddDelphiFunction('Function FrustumContainsBSphere( const Frustum : TFrustum; const testBSphere : TBSphere) : TSpaceContains');
 CL.AddDelphiFunction('Function FrustumContainsAABB( const Frustum : TFrustum; const testAABB : TAABB) : TSpaceContains');
 CL.AddDelphiFunction('Function ClipToAABB( const v : TAffineVector; const AABB : TAABB) : TAffineVector');
 CL.AddDelphiFunction('Function BSphereIntersectsBSphere( const mainBSphere, testBSphere : TBSphere) : boolean');
 CL.AddDelphiFunction('Procedure IncludeInClipRect( var clipRect : TClipRect; x, y : Single)');
 CL.AddDelphiFunction('Function AABBToClipRect( const aabb : TAABB; modelViewProjection : TMatrix; viewportSizeX, viewportSizeY : Integer) : TClipRect');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
Function BSphereToAABB2_P( const center : TVector; radius : Single) : TAABB;
Begin Result := GeometryBB.BSphereToAABB(center, radius); END;

(*----------------------------------------------------------------------------*)
Function BSphereToAABB1_P( const center : TAffineVector; radius : Single) : TAABB;
Begin Result := GeometryBB.BSphereToAABB(center, radius); END;

(*----------------------------------------------------------------------------*)
Procedure BSphereToAABB_P( const BSphere : TBSphere; var AABB : TAABB);
Begin GeometryBB.BSphereToAABB(BSphere, AABB); END;

(*----------------------------------------------------------------------------*)
Function PointInAABB1_P( const p : TVector; const aabb : TAABB) : Boolean;
Begin Result := GeometryBB.PointInAABB(p, aabb); END;

(*----------------------------------------------------------------------------*)
Function PointInAABB_P( const p : TAffineVector; const aabb : TAABB) : Boolean;
Begin Result := GeometryBB.PointInAABB(p, aabb); END;

(*----------------------------------------------------------------------------*)
Function IntersectAABBs_P( const aabb1, aabb2 : TAABB; const m1To2, m2To1 : TMatrix) : Boolean;
Begin Result := GeometryBB.IntersectAABBs(aabb1, aabb2, m1To2, m2To1); END;

(*----------------------------------------------------------------------------*)
Procedure OffsetAABB1_P( var aabb : TAABB; const delta : TVector);
Begin GeometryBB.OffsetAABB(aabb, delta); END;

(*----------------------------------------------------------------------------*)
Procedure OffsetAABB_P( var aabb : TAABB; const delta : TAffineVector);
Begin GeometryBB.OffsetAABB(aabb, delta); END;

(*----------------------------------------------------------------------------*)
Function AABBToBB1_P( const anAABB : TAABB; const m : TMatrix) : THmgBoundingBox;
Begin Result := GeometryBB.AABBToBB(anAABB, m); END;

(*----------------------------------------------------------------------------*)
Function AABBToBB_P( const anAABB : TAABB) : THmgBoundingBox;
Begin Result := GeometryBB.AABBToBB(anAABB); END;

(*----------------------------------------------------------------------------*)
procedure RIRegister_GeometryBB_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@AddBB, 'AddBB', cdRegister);
 S.RegisterDelphiFunction(@AddAABB, 'AddAABB', cdRegister);
 S.RegisterDelphiFunction(@SetBB, 'SetBB', cdRegister);
 S.RegisterDelphiFunction(@SetAABB, 'SetAABB', cdRegister);
 S.RegisterDelphiFunction(@BBTransform, 'BBTransform', cdRegister);
 S.RegisterDelphiFunction(@AABBTransform, 'AABBTransform', cdRegister);
 S.RegisterDelphiFunction(@AABBScale, 'AABBScale', cdRegister);
 S.RegisterDelphiFunction(@BBMinX, 'BBMinX', cdRegister);
 S.RegisterDelphiFunction(@BBMaxX, 'BBMaxX', cdRegister);
 S.RegisterDelphiFunction(@BBMinY, 'BBMinY', cdRegister);
 S.RegisterDelphiFunction(@BBMaxY, 'BBMaxY', cdRegister);
 S.RegisterDelphiFunction(@BBMinZ, 'BBMinZ', cdRegister);
 S.RegisterDelphiFunction(@BBMaxZ, 'BBMaxZ', cdRegister);
 S.RegisterDelphiFunction(@AABBInclude, 'AABBInclude', cdRegister);
 S.RegisterDelphiFunction(@AABBFromSweep, 'AABBFromSweep', cdRegister);
 S.RegisterDelphiFunction(@AABBIntersection, 'AABBIntersection', cdRegister);
 S.RegisterDelphiFunction(@BBToAABB, 'BBToAABB', cdRegister);
 S.RegisterDelphiFunction(@AABBToBB, 'AABBToBB', cdRegister);
 S.RegisterDelphiFunction(@AABBToBB1_P,'ABBToBB1', cdRegister);
 S.RegisterDelphiFunction(@OffsetAABB, 'OffsetAABB', cdRegister);
 S.RegisterDelphiFunction(@OffsetAABB1_P, 'OffsetAABB1', cdRegister);
 S.RegisterDelphiFunction(@IntersectAABBs, 'IntersectAABBs', cdRegister);
 S.RegisterDelphiFunction(@IntersectAABBsAbsoluteXY, 'IntersectAABBsAbsoluteXY', cdRegister);
 S.RegisterDelphiFunction(@IntersectAABBsAbsoluteXZ, 'IntersectAABBsAbsoluteXZ', cdRegister);
 S.RegisterDelphiFunction(@IntersectAABBsAbsolute, 'IntersectAABBsAbsolute', cdRegister);
 S.RegisterDelphiFunction(@AABBFitsInAABBAbsolute, 'AABBFitsInAABBAbsolute', cdRegister);
 S.RegisterDelphiFunction(@PointInAABB, 'PointInAABB', cdRegister);
 S.RegisterDelphiFunction(@PointInAABB1_P, 'PointInAABB1', cdRegister);
 S.RegisterDelphiFunction(@PlaneIntersectAABB, 'PlaneIntersectAABB', cdRegister);
 S.RegisterDelphiFunction(@TriangleIntersectAABB, 'TriangleIntersectAABB', cdRegister);
 S.RegisterDelphiFunction(@ExtractAABBCorners, 'ExtractAABBCorners', cdRegister);
 S.RegisterDelphiFunction(@AABBToBSphere, 'AABBToBSphere', cdRegister);
 S.RegisterDelphiFunction(@BSphereToAABB, 'BSphereToAABB', cdRegister);
 S.RegisterDelphiFunction(@BSphereToAABB1_P, 'BSphereToAABB1', cdRegister);
 S.RegisterDelphiFunction(@BSphereToAABB2_P, 'BSphereToAABB2', cdRegister);
 S.RegisterDelphiFunction(@AABBContainsAABB, 'AABBContainsAABB', cdRegister);
 S.RegisterDelphiFunction(@BSphereContainsAABB, 'BSphereContainsAABB', cdRegister);
 S.RegisterDelphiFunction(@BSphereContainsBSphere, 'BSphereContainsBSphere', cdRegister);
 S.RegisterDelphiFunction(@AABBContainsBSphere, 'AABBContainsBSphere', cdRegister);
 S.RegisterDelphiFunction(@PlaneContainsBSphere, 'PlaneContainsBSphere', cdRegister);
 S.RegisterDelphiFunction(@FrustumContainsBSphere, 'FrustumContainsBSphere', cdRegister);
 S.RegisterDelphiFunction(@FrustumContainsAABB, 'FrustumContainsAABB', cdRegister);
 S.RegisterDelphiFunction(@ClipToAABB, 'ClipToAABB', cdRegister);
 S.RegisterDelphiFunction(@BSphereIntersectsBSphere, 'BSphereIntersectsBSphere', cdRegister);
 S.RegisterDelphiFunction(@IncludeInClipRect, 'IncludeInClipRect', cdRegister);
 S.RegisterDelphiFunction(@AABBToClipRect, 'AABBToClipRect', cdRegister);
end;



{ TPSImport_GeometryBB }
(*----------------------------------------------------------------------------*)
procedure TPSImport_GeometryBB.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_GeometryBB(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_GeometryBB.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  //RIRegister_GeometryBB(ri);
  RIRegister_GeometryBB_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
