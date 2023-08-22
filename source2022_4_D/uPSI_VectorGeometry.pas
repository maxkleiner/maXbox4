unit uPSI_VectorGeometry;
{
   over tool for GL    less types from another   glSinCos1 fix
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
  TPSImport_VectorGeometry = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_VectorGeometry(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_VectorGeometry_Routines(S: TPSExec);

procedure Register;

implementation


uses
   VectorTypes
  ,VectorGeometry
  ,CurvesAndSurfaces
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_VectorGeometry]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_VectorGeometry(CL: TPSPascalCompiler);
begin
  {CL.AddTypeS('PByte', '^Byte // will not work');
  CL.AddTypeS('PWord', '^Word // will not work');
  CL.AddTypeS('PInteger', '^Integer // will not work');
  CL.AddTypeS('PCardinal', '^Cardinal // will not work');
  CL.AddTypeS('PSingle', '^Single // will not work');
  CL.AddTypeS('PDouble', '^Double // will not work');
  CL.AddTypeS('PExtended', '^Extended // will not work');
  CL.AddTypeS('PPointer', '^Pointer // will not work');
  CL.AddTypeS('PFloat', '^Single // will not work');
  CL.AddTypeS('PTexPoint', '^TTexPoint // will not work');
  CL.AddTypeS('TTexPoint', 'record S : single; T : Single; end');
  CL.AddTypeS('PByteVector', '^TByteVector // will not work');
  CL.AddTypeS('PByteArray', 'PByteVector');
  CL.AddTypeS('PWordVector', '^TWordVector // will not work');
  CL.AddTypeS('PIntegerVector', '^TIntegerVector // will not work');
  CL.AddTypeS('PIntegerArray', 'PIntegerVector');
  CL.AddTypeS('PFloatVector', '^TFloatVector // will not work');
  CL.AddTypeS('PFloatArray', 'PFloatVector');
  CL.AddTypeS('PSingleArray', 'PFloatArray');
  CL.AddTypeS('TSingleArray', 'array of Single');
  CL.AddTypeS('PDoubleVector', '^TDoubleVector // will not work');
  CL.AddTypeS('PDoubleArray', 'PDoubleVector');
  CL.AddTypeS('PExtendedVector', '^TExtendedVector // will not work');
  CL.AddTypeS('PExtendedArray', 'PExtendedVector');
  CL.AddTypeS('PPointerVector', '^TPointerVector // will not work');
  CL.AddTypeS('PPointerArray', 'PPointerVector');
  CL.AddTypeS('PCardinalVector', '^TCardinalVector // will not work');
  CL.AddTypeS('PCardinalArray', 'PCardinalVector');
  CL.AddTypeS('TVector4b', 'THomogeneousByteVector');
  CL.AddTypeS('TVector4w', 'THomogeneousWordVector');
  CL.AddTypeS('TVector', 'THomogeneousFltVector');
  CL.AddTypeS('PHomogeneousVector', '^THomogeneousVector // will not work');
  CL.AddTypeS('THomogeneousVector', 'THomogeneousFltVector');
  CL.AddTypeS('PAffineVector', '^TAffineVector // will not work');
  CL.AddTypeS('TAffineVector', 'TVector3f');
  CL.AddTypeS('PVertex', '^TVertex // will not work');
  CL.AddTypeS('TVertex', 'TAffineVector');
  CL.AddTypeS('PAffineVectorArray', '^TAffineVectorArray // will not work');
  CL.AddTypeS('PVectorArray', '^TVectorArray // will not work');
  CL.AddTypeS('PTexPointArray', '^TTexPointArray // will not work');
  CL.AddTypeS('TMatrix4b', 'THomogeneousByteMatrix');
  CL.AddTypeS('TMatrix4w', 'THomogeneousWordMatrix');
  CL.AddTypeS('THomogeneousIntMatrix', 'TMatrix4i');
  CL.AddTypeS('THomogeneousFltMatrix', 'TMatrix4f');
  CL.AddTypeS('THomogeneousDblMatrix', 'TMatrix4d');
  CL.AddTypeS('TMatrix4e', 'THomogeneousExtMatrix');
  CL.AddTypeS('TMatrix3b', 'TAffineByteMatrix');
  CL.AddTypeS('TMatrix3w', 'TAffineWordMatrix');
  CL.AddTypeS('TAffineIntMatrix', 'TMatrix3i');
  CL.AddTypeS('TAffineFltMatrix', 'TMatrix3f');
  CL.AddTypeS('TAffineDblMatrix', 'TMatrix3d');
  CL.AddTypeS('TMatrix3e', 'TAffineExtMatrix');
  CL.AddTypeS('PMatrix', '^TMatrix // will not work');
  CL.AddTypeS('TMatrix', 'THomogeneousFltMatrix');
  CL.AddTypeS('PMatrixArray', '^TMatrixArray // will not work');
  CL.AddTypeS('PHomogeneousMatrix', '^THomogeneousMatrix // will not work');
  CL.AddTypeS('THomogeneousMatrix', 'THomogeneousFltMatrix');
  CL.AddTypeS('PAffineMatrix', '^TAffineMatrix // will not work');
  CL.AddTypeS('TAffineMatrix', 'TAffineFltMatrix');
  CL.AddTypeS('PQuaternion', '^TQuaternion // will not work');
  CL.AddTypeS('TQuaternion', 'record ImagPart : TAffineVector; RealPart : Single; end');
  CL.AddTypeS('PQuaternionArray', '^TQuaternionArray // will not work');
  CL.AddTypeS('TRenderContextClippingInfo', 'record origin : TVector; clippingD'
   +'irection : TVector; viewPortRadius : Single; farClippingDistance : Single;'
   +' frustum : TFrustum; end');
 CL.AddConstantN('EPSILON','Single').setExtended( 1e-40);
 CL.AddConstantN('EPSILON2','Single').setExtended( 1e-30);  }

 CL.AddTypeS('TRenderContextClippingInfo', 'record origin : TVector; clippingD'
   +'irection : TVector; viewPortRadius : Single; farClippingDistance : Single; frustum : TFrustum; end');

 CL.AddTypeS('THmgPlane', 'TVector');
  CL.AddTypeS('TDoubleHmgPlane', 'THomogeneousDblVector');

 {CL.AddTypeS('TTransType', '( ttScaleX, ttScaleY, ttScaleZ, ttShearXY, ttShear'
   +'XZ, ttShearYZ, ttRotateX, ttRotateY, ttRotateZ, ttTranslateX, ttTranslateY'
   +', ttTranslateZ, ttPerspectiveX, ttPerspectiveY, ttPerspectiveZ, ttPerspectiveW )');}

   CL.AddTypeS('TSingleArray', 'array of Single');
  CL.AddTypeS('TTransformations','array [0..15] of Single)');
  CL.AddTypeS('TPackedRotationMatrix','array [0..2] of Smallint)');
  CL.AddTypeS('TVertex', 'TAffineVector');

  CL.AddTypeS('TAffineVectorArray','array[0..MAXINT shr 4] of TAffineVector');


  //CL.AddTypeS('TVectorGL', 'THomogeneousFltVector');
  //CL.AddTypeS('TMatrixGL', 'THomogeneousFltMatrix');
  //  TPackedRotationMatrix = array [0..2] of SmallInt;

 CL.AddDelphiFunction('Function glTexPointMake( const s, t : Single) : TTexPoint');
 CL.AddDelphiFunction('Function glAffineVectorMake( const x, y, z : Single) : TAffineVector;');
 CL.AddDelphiFunction('Function glAffineVectorMake1( const v : TVectorGL) : TAffineVector;');
 CL.AddDelphiFunction('Procedure glSetAffineVector( var v : TAffineVector; const x, y, z : Single);');
 CL.AddDelphiFunction('Procedure glSetVector( var v : TAffineVector; const x, y, z : Single);');
 CL.AddDelphiFunction('Procedure glSetVector1( var v : TAffineVector; const vSrc : TVectorGL);');
 CL.AddDelphiFunction('Procedure glSetVector2( var v : TAffineVector; const vSrc : TAffineVector);');
 CL.AddDelphiFunction('Procedure glSetVector3( var v : TAffineDblVector; const vSrc : TAffineVector);');
 CL.AddDelphiFunction('Procedure glSetVector4( var v : TAffineDblVector; const vSrc : TVectorGL);');
 CL.AddDelphiFunction('Function glVectorMake( const v : TAffineVector; w : Single) : TVectorGL;');
 CL.AddDelphiFunction('Function glVectorMake1( const x, y, z : Single; w : Single) : TVectorGL;');
 CL.AddDelphiFunction('Function glPointMake( const x, y, z : Single) : TVectorGL;');
 CL.AddDelphiFunction('Function glPointMake1( const v : TAffineVector) : TVectorGL;');
 CL.AddDelphiFunction('Function glPointMake2( const v : TVectorGL) : TVectorGL;');
 CL.AddDelphiFunction('Procedure glSetVector5( var v : TVectorGL; const x, y, z : Single; w : Single);');
 CL.AddDelphiFunction('Procedure glSetVector6( var v : TVectorGL; const av : TAffineVector; w : Single);');
 CL.AddDelphiFunction('Procedure glglSetVector7( var v : TVectorGL; const vSrc : TVectorGL);');
 CL.AddDelphiFunction('Procedure glMakePoint( var v : TVectorGL; const x, y, z : Single);');
 CL.AddDelphiFunction('Procedure glMakePoint1( var v : TVectorGL; const av : TAffineVector);');
 CL.AddDelphiFunction('Procedure glMakePoint2( var v : TVectorGL; const av : TVectorGL);');
 CL.AddDelphiFunction('Procedure glMakeVector( var v : TAffineVector; const x, y, z : Single);');
 CL.AddDelphiFunction('Procedure glMakeVector1( var v : TVectorGL; const x, y, z : Single);');
 CL.AddDelphiFunction('Procedure glMakeVector2( var v : TVectorGL; const av : TAffineVector);');
 CL.AddDelphiFunction('Procedure glMakeVector3( var v : TVectorGL; const av : TVectorGL);');
 CL.AddDelphiFunction('Procedure glRstVector( var v : TAffineVector);');
 CL.AddDelphiFunction('Procedure glRstVector1( var v : TVectorGL);');
 CL.AddDelphiFunction('Function glVectorAdd( const v1, v2 : TAffineVector) : TAffineVector;');
 CL.AddDelphiFunction('Procedure glVectorAdd1( const v1, v2 : TAffineVector; var vr : TAffineVector);');
 //CL.AddDelphiFunction('Procedure VectorAdd2( const v1, v2 : TAffineVector; vr : PAffineVector);');
 CL.AddDelphiFunction('Function glVectorAdd3( const v1, v2 : TVectorGL) : TVectorGL;');
 CL.AddDelphiFunction('Procedure glVectorAdd4( const v1, v2 : TVectorGL; var vr : TVectorGL);');
 CL.AddDelphiFunction('Function glVectorAdd5( const v : TAffineVector; const f : Single) : TAffineVector;');
 CL.AddDelphiFunction('Function glVectorAdd6( const v : TVectorGL; const f : Single) : TVectorGL;');
 CL.AddDelphiFunction('Procedure glAddVector7( var v1 : TAffineVector; const v2 : TAffineVector);');
 CL.AddDelphiFunction('Procedure glAddVector8( var v1 : TAffineVector; const v2 : TVectorGL);');
 CL.AddDelphiFunction('Procedure glAddVector9( var v1 : TVectorGL; const v2 : TVectorGL);');
 CL.AddDelphiFunction('Procedure glAddVector10( var v : TAffineVector; const f : Single);');
 CL.AddDelphiFunction('Procedure glAddVector11( var v : TVectorGL; const f : Single);');
 //CL.AddDelphiFunction('Procedure TexPointArrayAdd( const src : PTexPointArray; const delta : TTexPoint; const nb : Integer; dest : PTexPointArray);');
 //CL.AddDelphiFunction('Procedure TexPointArrayScaleAndAdd( const src : PTexPointArray; const delta : TTexPoint; const nb : Integer; const scale : TTexPoint; dest : PTexPointArray);');
 //CL.AddDelphiFunction('Procedure VectorArrayAdd( const src : PAffineVectorArray; const delta : TAffineVector; const nb : Integer; dest : PAffineVectorArray);');
 CL.AddDelphiFunction('Function glVectorSubtract( const V1, V2 : TAffineVector) : TAffineVector;');
 CL.AddDelphiFunction('Procedure glVectorSubtract1( const v1, v2 : TAffineVector; var result : TAffineVector);');
 CL.AddDelphiFunction('Procedure glVectorSubtract2( const v1, v2 : TAffineVector; var result : TVectorGL);');
 CL.AddDelphiFunction('Procedure glVectorSubtract3( const v1 : TVectorGL; v2 : TAffineVector; var result : TVectorGL);');
 CL.AddDelphiFunction('Function glVectorSubtract4( const V1, V2 : TVectorGL) : TVectorGL;');
 CL.AddDelphiFunction('Procedure glVectorSubtract5( const v1, v2 : TVectorGL; var result : TVectorGL);');
 CL.AddDelphiFunction('Procedure glVectorSubtract6( const v1, v2 : TVectorGL; var result : TAffineVector);');
 CL.AddDelphiFunction('Function glVectorSubtract7( const v1 : TAffineVector; delta : Single) : TAffineVector;');
 CL.AddDelphiFunction('Function glVectorSubtract8( const v1 : TVectorGL; delta : Single) : TVectorGL;');
 CL.AddDelphiFunction('Procedure glSubtractVector9( var V1 : TAffineVector; const V2 : TAffineVector);');
 CL.AddDelphiFunction('Procedure glSubtractVector10( var V1 : TVectorGL; const V2 : TVectorGL);');
 CL.AddDelphiFunction('Procedure glCombineVector( var vr : TAffineVector; const v : TAffineVector; var f : Single);');
 //CL.AddDelphiFunction('Procedure CombineVector1( var vr : TAffineVector; const v : TAffineVector; pf : PFloat);');
 CL.AddDelphiFunction('Function glTexPointCombine( const t1, t2 : TTexPoint; f1, f2 : Single) : TTexPoint');
 CL.AddDelphiFunction('Function glVectorCombine2( const V1, V2 : TAffineVector; const F1, F2 : Single) : TAffineVector;');
 CL.AddDelphiFunction('Function glVectorCombine33( const V1, V2, V3 : TAffineVector; const F1, F2, F3 : Single) : TAffineVector;');
 CL.AddDelphiFunction('Procedure glVectorCombine34( const V1, V2, V3 : TAffineVector; const F1, F2, F3 : Single; var vr : TAffineVector);');
 CL.AddDelphiFunction('Procedure glCombineVector5( var vr : TVectorGL; const v : TVectorGL; var f : Single);');
 CL.AddDelphiFunction('Procedure glCombineVector6( var vr : TVectorGL; const v : TAffineVector; var f : Single);');
 CL.AddDelphiFunction('Function glVectorCombine7( const V1, V2 : TVectorGL; const F1, F2 : Single) : TVectorGL;');
 CL.AddDelphiFunction('Function glVectorCombine8( const V1 : TVectorGL; const V2 : TAffineVector; const F1, F2 : Single) : TVectorGL;');
 CL.AddDelphiFunction('Procedure glVectorCombine9( const V1 : TVectorGL; const V2 : TAffineVector; const F1, F2 : Single; var vr : TVectorGL);');
 CL.AddDelphiFunction('Procedure glVectorCombine10( const V1, V2 : TVectorGL; const F1, F2 : Single; var vr : TVectorGL);');
 CL.AddDelphiFunction('Procedure glVectorCombine11( const V1, V2 : TVectorGL; const F2 : Single; var vr : TVectorGL);');
 CL.AddDelphiFunction('Function glVectorCombine3( const V1, V2, V3 : TVectorGL; const F1, F2, F3 : Single) : TVectorGL;');
 CL.AddDelphiFunction('Procedure glVectorCombine31( const V1, V2, V3 : TVectorGL; const F1, F2, F3 : Single; var vr : TVectorGL);');
 CL.AddDelphiFunction('Function glVectorDotProduct( const V1, V2 : TAffineVector) : Single;');
 CL.AddDelphiFunction('Function glVectorDotProduct1( const V1, V2 : TVectorGL) : Single;');
 CL.AddDelphiFunction('Function glVectorDotProduct2( const V1 : TVectorGL; const V2 : TAffineVector) : Single;');
 CL.AddDelphiFunction('Function glPointProject( const p, origin, direction : TAffineVector) : Single;');
 CL.AddDelphiFunction('Function glPointProject1( const p, origin, direction : TVectorGL) : Single;');
 CL.AddDelphiFunction('Function glVectorCrossProduct( const V1, V2 : TAffineVector) : TAffineVector;');
 CL.AddDelphiFunction('Function glVectorCrossProduct1( const V1, V2 : TVectorGL) : TVectorGL;');
 CL.AddDelphiFunction('Procedure glVectorCrossProduct2( const v1, v2 : TVectorGL; var vr : TVectorGL);');
 CL.AddDelphiFunction('Procedure glVectorCrossProduct3( const v1, v2 : TAffineVector; var vr : TVectorGL);');
 CL.AddDelphiFunction('Procedure glVectorCrossProduct4( const v1, v2 : TVectorGL; var vr : TAffineVector);');
 CL.AddDelphiFunction('Procedure glVectorCrossProduct5( const v1, v2 : TAffineVector; var vr : TAffineVector);');
 CL.AddDelphiFunction('Function glLerp( const start, stop, t : Single) : Single');
 CL.AddDelphiFunction('Function glAngleLerp( start, stop, t : Single) : Single');
 CL.AddDelphiFunction('Function glDistanceBetweenAngles( angle1, angle2 : Single) : Single');
 CL.AddDelphiFunction('Function glTexPointLerp( const t1, t2 : TTexPoint; t : Single) : TTexPoint;');
 CL.AddDelphiFunction('Function glVectorLerp( const v1, v2 : TAffineVector; t : Single) : TAffineVector;');
 CL.AddDelphiFunction('Procedure glVectorLerp1( const v1, v2 : TAffineVector; t : Single; var vr : TAffineVector);');
 CL.AddDelphiFunction('Function glVectorLerp2( const v1, v2 : TVectorGL; t : Single) : TVectorGL;');
 CL.AddDelphiFunction('Procedure glVectorLerp3( const v1, v2 : TVectorGL; t : Single; var vr : TVectorGL);');
 CL.AddDelphiFunction('Function glVectorAngleLerp( const v1, v2 : TAffineVector; t : Single) : TAffineVector;');
 CL.AddDelphiFunction('Function glVectorAngleCombine( const v1, v2 : TAffineVector; f : Single) : TAffineVector;');
// CL.AddDelphiFunction('Procedure VectorArrayLerp( const src1, src2 : PVectorArray; t : Single; n : Integer; dest : PVectorArray);');
// CL.AddDelphiFunction('Procedure VectorArrayLerp1( const src1, src2 : PAffineVectorArray; t : Single; n : Integer; dest : PAffineVectorArray);');
 CL.AddDelphiFunction('Function glVectorLength( const x, y : Single) : Single;');
 CL.AddDelphiFunction('Function glVectorLength1( const x, y, z : Single) : Single;');
 CL.AddDelphiFunction('Function glVectorLength2( const v : TAffineVector) : Single;');
 CL.AddDelphiFunction('Function glVectorLength3( const v : TVectorGL) : Single;');
 CL.AddDelphiFunction('Function glVectorLength4( const v : array of Single) : Single;');
 CL.AddDelphiFunction('Function glVectorNorm( const x, y : Single) : Single;');
 CL.AddDelphiFunction('Function glVectorNorm1( const v : TAffineVector) : Single;');
 CL.AddDelphiFunction('Function glVectorNorm2( const v : TVectorGL) : Single;');
 CL.AddDelphiFunction('Function glVectorNorm3( var V : array of Single) : Single;');
 CL.AddDelphiFunction('Procedure glNormalizeVector( var v : TAffineVector);');
 CL.AddDelphiFunction('Procedure glNormalizeVector1( var v : TVectorGL);');
 CL.AddDelphiFunction('Function glVectorNormalize( const v : TAffineVector) : TAffineVector;');
 CL.AddDelphiFunction('Function glVectorNormalize1( const v : TVectorGL) : TVectorGL;');
// CL.AddDelphiFunction('Procedure NormalizeVectorArray( list : PAffineVectorArray; n : Integer);');
 CL.AddDelphiFunction('Function glVectorAngleCosine( const V1, V2 : TAffineVector) : Single');
 CL.AddDelphiFunction('Function glVectorNegate( const v : TAffineVector) : TAffineVector;');
 CL.AddDelphiFunction('Function glVectorNegate1( const v : TVectorGL) : TVectorGL;');
 CL.AddDelphiFunction('Procedure glNegateVector( var V : TAffineVector);');
 CL.AddDelphiFunction('Procedure glNegateVector2( var V : TVectorGL);');
 CL.AddDelphiFunction('Procedure glNegateVector3( var V : array of Single);');
 CL.AddDelphiFunction('Procedure glScaleVector( var v : TAffineVector; factor : Single);');
 CL.AddDelphiFunction('Procedure glScaleVector1( var v : TAffineVector; const factor : TAffineVector);');
 CL.AddDelphiFunction('Procedure glScaleVector2( var v : TVectorGL; factor : Single);');
 CL.AddDelphiFunction('Procedure glScaleVector3( var v : TVectorGL; const factor : TVectorGL);');
 CL.AddDelphiFunction('Function glVectorScale( const v : TAffineVector; factor : Single) : TAffineVector;');
 CL.AddDelphiFunction('Procedure glVectorScale1( const v : TAffineVector; factor : Single; var vr : TAffineVector);');
 CL.AddDelphiFunction('Function glVectorScale2( const v : TVectorGL; factor : Single) : TVectorGL;');
 CL.AddDelphiFunction('Procedure glVectorScale3( const v : TVectorGL; factor : Single; var vr : TVectorGL);');
 CL.AddDelphiFunction('Procedure glVectorScale4( const v : TVectorGL; factor : Single; var vr : TAffineVector);');
 CL.AddDelphiFunction('Procedure glDivideVector( var v : TVectorGL; const divider : TVectorGL);');
 CL.AddDelphiFunction('Function glVectorEquals( const V1, V2 : TVectorGL) : Boolean;');
 CL.AddDelphiFunction('Function glVectorEquals1( const V1, V2 : TAffineVector) : Boolean;');
 CL.AddDelphiFunction('Function glAffineVectorEquals( const V1, V2 : TVectorGL) : Boolean;');
 CL.AddDelphiFunction('Function glVectorIsNull( const v : TVectorGL) : Boolean;');
 CL.AddDelphiFunction('Function glVectorIsNull1( const v : TAffineVector) : Boolean;');
 CL.AddDelphiFunction('Function glVectorSpacing( const v1, v2 : TTexPoint) : Single;');
 CL.AddDelphiFunction('Function glVectorSpacing1( const v1, v2 : TAffineVector) : Single;');
 CL.AddDelphiFunction('Function glVectorSpacing2( const v1, v2 : TVectorGL) : Single;');
 CL.AddDelphiFunction('Function glVectorDistance( const v1, v2 : TAffineVector) : Single;');
 CL.AddDelphiFunction('Function glVectorDistance1( const v1, v2 : TVectorGL) : Single;');
 CL.AddDelphiFunction('Function glVectorDistance2( const v1, v2 : TAffineVector) : Single;');
 CL.AddDelphiFunction('Function glVectorDistance21( const v1, v2 : TVectorGL) : Single;');
 CL.AddDelphiFunction('Function glVectorPerpendicular( const V, N : TAffineVector) : TAffineVector');
 CL.AddDelphiFunction('Function glVectorReflect( const V, N : TAffineVector) : TAffineVector');
 CL.AddDelphiFunction('Procedure glRotateVector( var vector : TVectorGL; const axis : TAffineVector; angle : Single);');
 CL.AddDelphiFunction('Procedure glRotateVector1( var vector : TVectorGL; const axis : TVectorGL; angle : Single);');
 CL.AddDelphiFunction('Procedure glRotateVectorAroundY( var v : TAffineVector; alpha : Single)');
 CL.AddDelphiFunction('Function glVectorRotateAroundX( const v : TAffineVector; alpha : Single) : TAffineVector;');
 CL.AddDelphiFunction('Function glVectorRotateAroundY( const v : TAffineVector; alpha : Single) : TAffineVector;');
 CL.AddDelphiFunction('Procedure glVectorRotateAroundY1( const v : TAffineVector; alpha : Single; var vr : TAffineVector);');
 CL.AddDelphiFunction('Function glVectorRotateAroundZ( const v : TAffineVector; alpha : Single) : TAffineVector;');
 CL.AddDelphiFunction('Procedure glAbsVector( var v : TVectorGL);');
 CL.AddDelphiFunction('Procedure glAbsVector1( var v : TAffineVector);');
 CL.AddDelphiFunction('Function glVectorAbs( const v : TVectorGL) : TVectorGL;');
 CL.AddDelphiFunction('Function glVectorAbs1( const v : TAffineVector) : TAffineVector;');
 CL.AddDelphiFunction('Procedure glSetMatrix( var dest : THomogeneousDblMatrix; const src : TMatrixGL);');
 CL.AddDelphiFunction('Procedure glSetMatrix1( var dest : TAffineMatrix; const src : TMatrixGL);');
 CL.AddDelphiFunction('Procedure glSetMatrix2( var dest : TMatrixGL; const src : TAffineMatrix);');
 CL.AddDelphiFunction('Procedure glSetMatrixRow( var dest : TMatrixGL; rowNb : Integer; const aRow : TVectorGL);');
 CL.AddDelphiFunction('Function glCreateScaleMatrix( const v : TAffineVector) : TMatrixGL;');
 CL.AddDelphiFunction('Function glCreateScaleMatrix1( const v : TVectorGL) : TMatrixGL;');
 CL.AddDelphiFunction('Function glCreateTranslationMatrix( const V : TAffineVector) : TMatrixGL;');
 CL.AddDelphiFunction('Function glCreateTranslationMatrix1( const V : TVectorGL) : TMatrixGL;');
 CL.AddDelphiFunction('Function glCreateScaleAndTranslationMatrix( const scale, offset : TVectorGL) : TMatrixGL;');
 CL.AddDelphiFunction('Function glCreateRotationMatrixX( const sine, cosine : Single) : TMatrixGL;');
 CL.AddDelphiFunction('Function glCreateRotationMatrixX1( const angle : Single) : TMatrixGL;');
 CL.AddDelphiFunction('Function glCreateRotationMatrixY( const sine, cosine : Single) : TMatrixGL;');
 CL.AddDelphiFunction('Function glCreateRotationMatrixY1( const angle : Single) : TMatrixGL;');
 CL.AddDelphiFunction('Function glCreateRotationMatrixZ( const sine, cosine : Single) : TMatrixGL;');
 CL.AddDelphiFunction('Function glCreateRotationMatrixZ1( const angle : Single) : TMatrixGL;');
 CL.AddDelphiFunction('Function glCreateRotationMatrix( const anAxis : TAffineVector; angle : Single) : TMatrixGL;');
 CL.AddDelphiFunction('Function glCreateRotationMatrix1( const anAxis : TVectorGL; angle : Single) : TMatrixGL;');
 CL.AddDelphiFunction('Function glCreateAffineRotationMatrix( const anAxis : TAffineVector; angle : Single) : TAffineMatrix');
 CL.AddDelphiFunction('Function glMatrixMultiply( const M1, M2 : TAffineMatrix) : TAffineMatrix;');
 CL.AddDelphiFunction('Function glMatrixMultiply1( const M1, M2 : TMatrixGL) : TMatrixGL;');
 CL.AddDelphiFunction('Procedure glMatrixMultiply2( const M1, M2 : TMatrixGL; var MResult : TMatrixGL);');
 CL.AddDelphiFunction('Function glVectorTransform( const V : TVectorGL; const M : TMatrixGL) : TVectorGL;');
 CL.AddDelphiFunction('Function glVectorTransform1( const V : TVectorGL; const M : TAffineMatrix) : TVectorGL;');
 CL.AddDelphiFunction('Function glVectorTransform2( const V : TAffineVector; const M : TMatrixGL) : TAffineVector;');
 CL.AddDelphiFunction('Function glVectorTransform3( const V : TAffineVector; const M : TAffineMatrix) : TAffineVector;');
 CL.AddDelphiFunction('Function glMatrixDeterminant( const M : TAffineMatrix) : Single;');
 CL.AddDelphiFunction('Function glMatrixDeterminant1( const M : TMatrixGL) : Single;');
 CL.AddDelphiFunction('Procedure glAdjointMatrix( var M : TMatrixGL);');
 CL.AddDelphiFunction('Procedure glAdjointMatrix1( var M : TAffineMatrix);');
 CL.AddDelphiFunction('Procedure glScaleMatrix( var M : TAffineMatrix; const factor : Single);');
 CL.AddDelphiFunction('Procedure glScaleMatrix1( var M : TMatrixGL; const factor : Single);');
 CL.AddDelphiFunction('Procedure glTranslateMatrix( var M : TMatrixGL; const v : TAffineVector);');
 CL.AddDelphiFunction('Procedure glTranslateMatrix1( var M : TMatrixGL; const v : TVectorGL);');
 CL.AddDelphiFunction('Procedure glNormalizeMatrix( var M : TMatrixGL)');
 CL.AddDelphiFunction('Procedure glTransposeMatrix( var M : TAffineMatrix);');
 CL.AddDelphiFunction('Procedure glTransposeMatrix1( var M : TMatrixGL);');
 CL.AddDelphiFunction('Procedure glInvertMatrix( var M : TMatrixGL);');
 CL.AddDelphiFunction('Procedure glInvertMatrix1( var M : TAffineMatrix);');
 CL.AddDelphiFunction('Function glAnglePreservingMatrixInvert( const mat : TMatrixGL) : TMatrixGL');
 CL.AddDelphiFunction('Function glMatrixDecompose( const M : TMatrixGL; var Tran : TTransformations) : Boolean');
 CL.AddDelphiFunction('Function glPlaneMake( const p1, p2, p3 : TAffineVector) : THmgPlane;');
 CL.AddDelphiFunction('Function glPlaneMake1( const p1, p2, p3 : TVectorGL) : THmgPlane;');
 CL.AddDelphiFunction('Function glPlaneMake2( const point, normal : TAffineVector) : THmgPlane;');
 CL.AddDelphiFunction('Function glPlaneMake3( const point, normal : TVectorGL) : THmgPlane;');
 CL.AddDelphiFunction('Procedure glSetPlane( var dest : TDoubleHmgPlane; const src : THmgPlane)');
 CL.AddDelphiFunction('Procedure glNormalizePlane( var plane : THmgPlane)');
 CL.AddDelphiFunction('Function glPlaneEvaluatePoint( const plane : THmgPlane; const point : TAffineVector) : Single;');
 CL.AddDelphiFunction('Function glPlaneEvaluatePoint1( const plane : THmgPlane; const point : TVectorGL) : Single;');
 CL.AddDelphiFunction('Function glCalcPlaneNormal( const p1, p2, p3 : TAffineVector) : TAffineVector;');
 CL.AddDelphiFunction('Procedure glCalcPlaneNormal1( const p1, p2, p3 : TAffineVector; var vr : TAffineVector);');
 CL.AddDelphiFunction('Procedure glCalcPlaneNormal2( const p1, p2, p3 : TVectorGL; var vr : TAffineVector);');
 CL.AddDelphiFunction('Function glPointIsInHalfSpace( const point, planePoint, planeNormal : TVectorGL) : Boolean;');
 CL.AddDelphiFunction('Function glPointIsInHalfSpace1( const point, planePoint, planeNormal : TAffineVector) : Boolean;');
 CL.AddDelphiFunction('Function glPointPlaneDistance( const point, planePoint, planeNormal : TVectorGL) : Single;');
 CL.AddDelphiFunction('Function glPointPlaneDistance1( const point, planePoint, planeNormal : TAffineVector) : Single;');
 CL.AddDelphiFunction('Function glPointSegmentClosestPoint( const point, segmentStart, segmentStop : TAffineVector) : TAffineVector');
 CL.AddDelphiFunction('Function glPointSegmentDistance( const point, segmentStart, segmentStop : TAffineVector) : single');
 CL.AddDelphiFunction('Function glPointLineClosestPoint( const point, linePoint, lineDirection : TAffineVector) : TAffineVector');
 CL.AddDelphiFunction('Function glPointLineDistance( const point, linePoint, lineDirection : TAffineVector) : Single');
 CL.AddDelphiFunction('Procedure SglegmentSegmentClosestPoint( const S0Start, S0Stop, S1Start, S1Stop : TAffineVector; var Segment0Closest, Segment1Closest : TAffineVector)');
 CL.AddDelphiFunction('Function glSegmentSegmentDistance( const S0Start, S0Stop, S1Start, S1Stop : TAffineVector) : single');
 CL.AddTypeS('TEulerOrder', '( eulXYZ, eulXZY, eulYXZ, eulYZX, eulZXY, eulZYX)');
 CL.AddDelphiFunction('Function glQuaternionMake( const Imag : array of Single; Real : Single) : TQuaternion');
 CL.AddDelphiFunction('Function glQuaternionConjugate( const Q : TQuaternion) : TQuaternion');
 CL.AddDelphiFunction('Function glQuaternionMagnitude( const Q : TQuaternion) : Single');
 CL.AddDelphiFunction('Procedure glNormalizeQuaternion( var Q : TQuaternion)');
 CL.AddDelphiFunction('Function glQuaternionFromPoints( const V1, V2 : TAffineVector) : TQuaternion');
 CL.AddDelphiFunction('Procedure glQuaternionToPoints( const Q : TQuaternion; var ArcFrom, ArcTo : TAffineVector)');
 CL.AddDelphiFunction('Function glQuaternionFromMatrix( const mat : TMatrixGL) : TQuaternion');
 CL.AddDelphiFunction('Function glQuaternionToMatrix( quat : TQuaternion) : TMatrixGL');
 CL.AddDelphiFunction('Function glQuaternionToAffineMatrix( quat : TQuaternion) : TAffineMatrix');
 CL.AddDelphiFunction('Function glQuaternionFromAngleAxis( const angle : Single; const axis : TAffineVector) : TQuaternion');
 CL.AddDelphiFunction('Function glQuaternionFromRollPitchYaw( const r, p, y : Single) : TQuaternion');
 CL.AddDelphiFunction('Function glQuaternionFromEuler( const x, y, z : Single; eulerOrder : TEulerOrder) : TQuaternion');
 CL.AddDelphiFunction('Function glQuaternionMultiply( const qL, qR : TQuaternion) : TQuaternion');
 CL.AddDelphiFunction('Function glQuaternionSlerp( const QStart, QEnd : TQuaternion; Spin : Integer; t : Single) : TQuaternion;');
 CL.AddDelphiFunction('Function glQuaternionSlerp1( const source, dest : TQuaternion; const t : Single) : TQuaternion;');
 CL.AddDelphiFunction('Function glLnXP1( X : Extended) : Extended');
 CL.AddDelphiFunction('Function glLog10( X : Extended) : Extended');
 CL.AddDelphiFunction('Function glLog2( X : Extended) : Extended;');
 CL.AddDelphiFunction('Function glLog21( X : Single) : Single;');
 CL.AddDelphiFunction('Function glLogN( Base, X : Extended) : Extended');
 CL.AddDelphiFunction('Function glIntPower( Base : Extended; Exponent : Integer) : Extended');
 CL.AddDelphiFunction('Function glPower( const Base, Exponent : Single) : Single;');
 CL.AddDelphiFunction('Function glPower1( Base : Single; Exponent : Integer) : Single;');
 CL.AddDelphiFunction('Function glDegToRad( const Degrees : Extended) : Extended;');
 CL.AddDelphiFunction('Function glDegToRad1( const Degrees : Single) : Single;');
 CL.AddDelphiFunction('Function glRadToDeg( const Radians : Extended) : Extended;');
 CL.AddDelphiFunction('Function glRadToDeg1( const Radians : Single) : Single;');
 CL.AddDelphiFunction('Function glNormalizeAngle( angle : Single) : Single');
 CL.AddDelphiFunction('Function glNormalizeDegAngle( angle : Single) : Single');
 CL.AddDelphiFunction('Procedure glSinCos( const Theta : Extended; var Sin, Cos : Extended);');
 CL.AddDelphiFunction('Procedure glSinCos11( const Theta : Double; var Sin, Cos : Double);');
 CL.AddDelphiFunction('Procedure glSinCos0( const Theta : Single; var Sin, Cos : Single);');
 CL.AddDelphiFunction('Procedure glSinCos1( const theta, radius : Double; var Sin, Cos : Extended);');
 CL.AddDelphiFunction('Procedure glSinCos2( const theta, radius : Double; var Sin, Cos : Double);');
 CL.AddDelphiFunction('Procedure glSinCos3( const theta, radius : Single; var Sin, Cos : Single);');
 CL.AddDelphiFunction('Procedure glPrepareSinCosCache( var s, c : array of Single; startAngle, stopAngle : Single)');
 CL.AddDelphiFunction('Function glArcCos( const X : Extended) : Extended;');
 CL.AddDelphiFunction('Function glArcCos1( const x : Single) : Single;');
 CL.AddDelphiFunction('Function glArcSin( const X : Extended) : Extended;');
 CL.AddDelphiFunction('Function glArcSin1( const X : Single) : Single;');
 CL.AddDelphiFunction('Function glArcTan21( const Y, X : Extended) : Extended;');
 CL.AddDelphiFunction('Function glArcTan21( const Y, X : Single) : Single;');
 CL.AddDelphiFunction('Function glFastArcTan2( y, x : Single) : Single');
 CL.AddDelphiFunction('Function glTan( const X : Extended) : Extended;');
 CL.AddDelphiFunction('Function glTan1( const X : Single) : Single;');
 CL.AddDelphiFunction('Function glCoTan( const X : Extended) : Extended;');
 CL.AddDelphiFunction('Function glCoTan1( const X : Single) : Single;');
 CL.AddDelphiFunction('Function glSinh( const x : Single) : Single;');
 CL.AddDelphiFunction('Function glSinh1( const x : Double) : Double;');
 CL.AddDelphiFunction('Function glCosh( const x : Single) : Single;');
 CL.AddDelphiFunction('Function glCosh1( const x : Double) : Double;');
 CL.AddDelphiFunction('Function glRSqrt( v : Single) : Single');
 CL.AddDelphiFunction('Function glRLength( x, y : Single) : Single');
 CL.AddDelphiFunction('Function glISqrt( i : Integer) : Integer');
 CL.AddDelphiFunction('Function glILength( x, y : Integer) : Integer;');
 CL.AddDelphiFunction('Function glILength1( x, y, z : Integer) : Integer;');
 CL.AddDelphiFunction('Procedure glRegisterBasedExp');
 CL.AddDelphiFunction('Procedure glRandomPointOnSphere( var p : TAffineVector)');
 CL.AddDelphiFunction('Function glRoundInt( v : Single) : Single;');
 CL.AddDelphiFunction('Function glRoundInt1( v : Extended) : Extended;');
 CL.AddDelphiFunction('Function glTrunc( v : Single) : Integer;');
 CL.AddDelphiFunction('Function glTrunc64( v : Extended) : Int64;');
 CL.AddDelphiFunction('Function glInt( v : Single) : Single;');
 CL.AddDelphiFunction('Function glInt1( v : Extended) : Extended;');
 CL.AddDelphiFunction('Function glFrac( v : Single) : Single;');
 CL.AddDelphiFunction('Function glFrac1( v : Extended) : Extended;');
 CL.AddDelphiFunction('Function glRound( v : Single) : Integer;');
 CL.AddDelphiFunction('Function glRound64( v : Single) : Int64;');
 CL.AddDelphiFunction('Function glRound641( v : Extended) : Int64;');
 CL.AddDelphiFunction('Function glTrunc( X : Extended) : Int64');
 CL.AddDelphiFunction('Function glRound( X : Extended) : Int64');
 CL.AddDelphiFunction('Function glFrac( X : Extended) : Extended');
 CL.AddDelphiFunction('Function glCeil( v : Single) : Integer;');
 CL.AddDelphiFunction('Function glCeil64( v : Extended) : Int64;');
 CL.AddDelphiFunction('Function glFloor( v : Single) : Integer;');
 CL.AddDelphiFunction('Function glFloor64( v : Extended) : Int64;');
 CL.AddDelphiFunction('Function glScaleAndRound( i : Integer; var s : Single) : Integer');
 CL.AddDelphiFunction('Function glSign( x : Single) : Integer');
 CL.AddDelphiFunction('Function glIsInRange( const x, a, b : Single) : Boolean;');
 CL.AddDelphiFunction('Function glIsInRange1( const x, a, b : Double) : Boolean;');
 CL.AddDelphiFunction('Function glIsInCube( const p, d : TAffineVector) : Boolean;');
 CL.AddDelphiFunction('Function glIsInCube1( const p, d : TVectorGL) : Boolean;');
 //CL.AddDelphiFunction('Function MinFloat( values : PSingleArray; nbItems : Integer) : Single;');
 //CL.AddDelphiFunction('Function MinFloat1( values : PDoubleArray; nbItems : Integer) : Double;');
 //CL.AddDelphiFunction('Function MinFloat2( values : PExtendedArray; nbItems : Integer) : Extended;');
 CL.AddDelphiFunction('Function glMinFloat3( const v1, v2 : Single) : Single;');
 CL.AddDelphiFunction('Function glMinFloat4( const v : array of Single) : Single;');
 CL.AddDelphiFunction('Function glMinFloat5( const v1, v2 : Double) : Double;');
 CL.AddDelphiFunction('Function glMinFloat6( const v1, v2 : Extended) : Extended;');
 CL.AddDelphiFunction('Function glMinFloat7( const v1, v2, v3 : Single) : Single;');
 CL.AddDelphiFunction('Function glMinFloat8( const v1, v2, v3 : Double) : Double;');
 CL.AddDelphiFunction('Function glMinFloat9( const v1, v2, v3 : Extended) : Extended;');
 //CL.AddDelphiFunction('Function MaxFloat10( values : PSingleArray; nbItems : Integer) : Single;');
 //CL.AddDelphiFunction('Function MaxFloat( values : PDoubleArray; nbItems : Integer) : Double;');
 //CL.AddDelphiFunction('Function MaxFloat1( values : PExtendedArray; nbItems : Integer) : Extended;');
 CL.AddDelphiFunction('Function glMaxFloat2( const v : array of Single) : Single;');
 CL.AddDelphiFunction('Function glMaxFloat3( const v1, v2 : Single) : Single;');
 CL.AddDelphiFunction('Function glMaxFloat4( const v1, v2 : Double) : Double;');
 CL.AddDelphiFunction('Function glMaxFloat5( const v1, v2 : Extended) : Extended;');
 CL.AddDelphiFunction('Function glMaxFloat6( const v1, v2, v3 : Single) : Single;');
 CL.AddDelphiFunction('Function glMaxFloat7( const v1, v2, v3 : Double) : Double;');
 CL.AddDelphiFunction('Function glMaxFloat8( const v1, v2, v3 : Extended) : Extended;');
 CL.AddDelphiFunction('Function glMinInteger9( const v1, v2 : Integer) : Integer;');
 CL.AddDelphiFunction('Function glMinInteger( const v1, v2 : Cardinal) : Cardinal;');
 CL.AddDelphiFunction('Function glMaxInteger( const v1, v2 : Integer) : Integer;');
 CL.AddDelphiFunction('Function glMaxInteger1( const v1, v2 : Cardinal) : Cardinal;');
 CL.AddDelphiFunction('Function glTriangleArea( const p1, p2, p3 : TAffineVector) : Single;');
 //CL.AddDelphiFunction('Function PolygonArea( const p : PAffineVectorArray; nSides : Integer) : Single;');
 CL.AddDelphiFunction('Function glTriangleSignedArea( const p1, p2, p3 : TAffineVector) : Single;');
 //CL.AddDelphiFunction('Function PolygonSignedArea( const p : PAffineVectorArray; nSides : Integer) : Single;');
 //CL.AddDelphiFunction('Procedure ScaleFloatArray( values : PSingleArray; nb : Integer; var factor : Single);');
 CL.AddDelphiFunction('Procedure glScaleFloatArray( var values : TSingleArray; factor : Single);');
 //CL.AddDelphiFunction('Procedure OffsetFloatArray( values : PSingleArray; nb : Integer; var delta : Single);');
 CL.AddDelphiFunction('Procedure glOffsetFloatArray1( var values : array of Single; delta : Single);');
 //CL.AddDelphiFunction('Procedure OffsetFloatArray2( valuesDest, valuesDelta : PSingleArray; nb : Integer);');
 CL.AddDelphiFunction('Function glMaxXYZComponent( const v : TVectorGL) : Single;');
 CL.AddDelphiFunction('Function glMaxXYZComponent1( const v : TAffineVector) : single;');
 CL.AddDelphiFunction('Function glMinXYZComponent( const v : TVectorGL) : Single;');
 CL.AddDelphiFunction('Function glMinXYZComponent1( const v : TAffineVector) : single;');
 CL.AddDelphiFunction('Function glMaxAbsXYZComponent( v : TVectorGL) : Single');
 CL.AddDelphiFunction('Function glMinAbsXYZComponent( v : TVectorGL) : Single');
 CL.AddDelphiFunction('Procedure glMaxVector( var v : TVectorGL; const v1 : TVectorGL);');
 CL.AddDelphiFunction('Procedure glMaxVector1( var v : TAffineVector; const v1 : TAffineVector);');
 CL.AddDelphiFunction('Procedure glMinVector( var v : TVectorGL; const v1 : TVectorGL);');
 CL.AddDelphiFunction('Procedure glMinVector1( var v : TAffineVector; const v1 : TAffineVector);');
 CL.AddDelphiFunction('Procedure glSortArrayAscending( var a : array of Extended)');
 CL.AddDelphiFunction('Function glClampValue( const aValue, aMin, aMax : Single) : Single;');
 CL.AddDelphiFunction('Function glClampValue1( const aValue, aMin : Single) : Single;');
 CL.AddDelphiFunction('Function glGeometryOptimizationMode : String');
 CL.AddDelphiFunction('Procedure glBeginFPUOnlySection');
 CL.AddDelphiFunction('Procedure glEndFPUOnlySection');
 CL.AddDelphiFunction('Function glConvertRotation( const Angles : TAffineVector) : TVectorGL');
 CL.AddDelphiFunction('Function glMakeAffineDblVector( var v : array of Double) : TAffineDblVector');
 CL.AddDelphiFunction('Function glMakeDblVector( var v : array of Double) : THomogeneousDblVector');
 CL.AddDelphiFunction('Function glVectorAffineDblToFlt( const v : TAffineDblVector) : TAffineVector');
 CL.AddDelphiFunction('Function glVectorDblToFlt( const v : THomogeneousDblVector) : THomogeneousVector');
 CL.AddDelphiFunction('Function glVectorAffineFltToDbl( const v : TAffineVector) : TAffineDblVector');
 CL.AddDelphiFunction('Function glVectorFltToDbl( const v : TVectorGL) : THomogeneousDblVector');
 CL.AddDelphiFunction('Function glPointInPolygon( var xp, yp : array of Single; x, y : Single) : Boolean');
 CL.AddDelphiFunction('Procedure glDivMod( Dividend : Integer; Divisor : Word; var Result, Remainder : Word)');
 CL.AddDelphiFunction('Function glTurn( const Matrix : TMatrixGL; angle : Single) : TMatrixGL;');
 CL.AddDelphiFunction('Function glTurn1( const Matrix : TMatrixGL; const MasterUp : TAffineVector; Angle : Single) : TMatrixGL;');
 CL.AddDelphiFunction('Function glPitch( const Matrix : TMatrixGL; Angle : Single) : TMatrixGL;');
 CL.AddDelphiFunction('Function glPitch1( const Matrix : TMatrixGL; const MasterRight : TAffineVector; Angle : Single) : TMatrixGL;');
 CL.AddDelphiFunction('Function glRoll( const Matrix : TMatrixGL; Angle : Single) : TMatrixGL;');
 CL.AddDelphiFunction('Function glRoll1( const Matrix : TMatrixGL; const MasterDirection : TAffineVector; Angle : Single) : TMatrixGL;');
 //CL.AddDelphiFunction('Function IntersectLinePlane( const point, direction : TVectorGL; const plane : THmgPlane; intersectPoint : PVector) : Integer;');
 //CL.AddDelphiFunction('Function RayCastPlaneIntersect( const rayStart, rayVector : TVectorGL; const planePoint, planeNormal : TVectorGL; intersectPoint : PVector) : Boolean;');
 //CL.AddDelphiFunction('Function RayCastPlaneXZIntersect( const rayStart, rayVector : TVectorGL; const planeY : Single; intersectPoint : PVector) : Boolean;');
 //CL.AddDelphiFunction('Function RayCastTriangleIntersect( const rayStart, rayVector : TVectorGL; const p1, p2, p3 : TAffineVector; intersectPoint : PVector; intersectNormal : PVector) : Boolean;');
 CL.AddDelphiFunction('Function glRayCastMinDistToPoint( const rayStart, rayVector : TVectorGL; const point : TVectorGL) : Single');
 CL.AddDelphiFunction('Function glRayCastIntersectsSphere( const rayStart, rayVector : TVectorGL; const sphereCenter : TVectorGL; const sphereRadius : Single) : Boolean;');
 CL.AddDelphiFunction('Function glRayCastSphereIntersect( const rayStart, rayVector : TVectorGL; const sphereCenter : TVectorGL; const sphereRadius : Single; var i1, i2 : TVectorGL) : Integer;');
 CL.AddDelphiFunction('Function glSphereVisibleRadius( distance, radius : Single) : Single');
 CL.AddDelphiFunction('Function glExtractFrustumFromModelViewProjection( const modelViewProj : TMatrixGL) : TFrustum');
 CL.AddDelphiFunction('Function glIsVolumeClipped( const objPos : TVectorGL; const objRadius : Single; const rcci : TRenderContextClippingInfo) : Boolean;');
 CL.AddDelphiFunction('Function glIsVolumeClipped1( const objPos : TAffineVector; const objRadius : Single; const rcci : TRenderContextClippingInfo) : Boolean;');
 CL.AddDelphiFunction('Function glIsVolumeClipped2( const min, max : TAffineVector; const rcci : TRenderContextClippingInfo) : Boolean;');
 CL.AddDelphiFunction('Function glIsVolumeClipped3( const objPos : TAffineVector; const objRadius : Single; const Frustum : TFrustum) : Boolean;');
 CL.AddDelphiFunction('Function glMakeParallelProjectionMatrix( const plane : THmgPlane; const dir : TVectorGL) : TMatrixGL');
 CL.AddDelphiFunction('Function glMakeShadowMatrix( const planePoint, planeNormal, lightPos : TVectorGL) : TMatrixGL');
 CL.AddDelphiFunction('Function glMakeReflectionMatrix( const planePoint, planeNormal : TAffineVector) : TMatrixGL');
 CL.AddDelphiFunction('Function glPackRotationMatrix( const mat : TMatrixGL) : TPackedRotationMatrix');
 CL.AddDelphiFunction('Function glUnPackRotationMatrix( const packedMatrix : TPackedRotationMatrix) : TMatrixGL');
 CL.AddConstantN('cPI','Single').setExtended( 3.141592654);
 CL.AddConstantN('cPIdiv180','Single').setExtended( 0.017453292);
 CL.AddConstantN('c180divPI','Single').setExtended( 57.29577951);
 CL.AddConstantN('c2PI','Single').setExtended( 6.283185307);
 CL.AddConstantN('cPIdiv2','Single').setExtended( 1.570796326);
 CL.AddConstantN('cPIdiv4','Single').setExtended( 0.785398163);
 CL.AddConstantN('c3PIdiv4','Single').setExtended( 2.35619449);
 CL.AddConstantN('cInv2PI','Single').setExtended( 1 / 6.283185307);
 CL.AddConstantN('cInv360','Single').setExtended( 1 / 360);
 CL.AddConstantN('c180','Single').setExtended( 180);
 CL.AddConstantN('c360','Single').setExtended( 360);
 CL.AddConstantN('cOneHalf','Single').setExtended( 0.5);
 CL.AddConstantN('cLn10','Single').setExtended( 2.302585093);
 {CL.AddConstantN('MinSingle','Extended').setExtended( 1.5e-45);
 CL.AddConstantN('MaxSingle','Extended').setExtended( 3.4e+38);
 CL.AddConstantN('MinDouble','Extended').setExtended( 5.0e-324);
 CL.AddConstantN('MaxDouble','Extended').setExtended( 1.7e+308);
 CL.AddConstantN('MinExtended','Extended').setExtended( 3.4e-4932);
 CL.AddConstantN('MaxExtended','Extended').setExtended( 1.1e+4932);
 CL.AddConstantN('MinComp','Extended').setExtended( - 9.223372036854775807e+18);
 CL.AddConstantN('MaxComp','Extended').setExtended( 9.223372036854775807e+18);}
   CL.AddTypeS('TBSplineContinuity', '( bscUniformNonPeriodic, bscUniformPeriodic )');
 CL.AddDelphiFunction('Function BezierCurvePoint( t : single; n : integer; cp : TAffineVectorArray) : TAffineVector');
 CL.AddDelphiFunction('Function BezierSurfacePoint( s, t : single; m, n : integer; cp : TAffineVectorArray) : TAffineVector');
 CL.AddDelphiFunction('Procedure GenerateBezierCurve( Steps : Integer; ControlPoints, Vertices : TAffineVectorList)');
 CL.AddDelphiFunction('Procedure GenerateBezierSurface( Steps, Width, Height : Integer; ControlPoints, Vertices : TAffineVectorList)');
 CL.AddDelphiFunction('Function BSplinePoint( t : single; n, k : integer; knots : TSingleArray; cp : TAffineVectorArray) : TAffineVector');
 CL.AddDelphiFunction('Function BSplineSurfacePoint( s, t : single; m, n, k1, k2 : integer; uknots, vknots : TSingleArray; cp : TAffineVectorArray) : TAffineVector');
 CL.AddDelphiFunction('Procedure GenerateBSpline( Steps, Order : Integer; KnotVector : TSingleList; ControlPoints, Vertices : TAffineVectorList)');
 CL.AddDelphiFunction('Procedure GenerateBSplineSurface( Steps, UOrder, VOrder, Width, Height : Integer; UKnotVector, VKnotVector : TSingleList; ControlPoints, Vertices : TAffineVectorList)');
 CL.AddDelphiFunction('Procedure GenerateKnotVector( KnotVector : TSingleList; NumberOfPoints, Order : Integer; Continuity : TBSplineContinuity)');



end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
Function IsVolumeClipped3_P( const objPos : TAffineVector; const objRadius : Single; const Frustum : TFrustum) : Boolean;
Begin Result := VectorGeometry.IsVolumeClipped(objPos, objRadius, Frustum); END;

(*----------------------------------------------------------------------------*)
Function IsVolumeClipped2_P( const min, max : TAffineVector; const rcci : TRenderContextClippingInfo) : Boolean;
Begin Result := VectorGeometry.IsVolumeClipped(min, max, rcci); END;

(*----------------------------------------------------------------------------*)
Function IsVolumeClipped1_P( const objPos : TAffineVector; const objRadius : Single; const rcci : TRenderContextClippingInfo) : Boolean;
Begin Result := VectorGeometry.IsVolumeClipped(objPos, objRadius, rcci); END;

(*----------------------------------------------------------------------------*)
Function IsVolumeClipped_P( const objPos : TVector; const objRadius : Single; const rcci : TRenderContextClippingInfo) : Boolean;
Begin Result := VectorGeometry.IsVolumeClipped(objPos, objRadius, rcci); END;

(*----------------------------------------------------------------------------*)
Function RayCastSphereIntersect_P( const rayStart, rayVector : TVector; const sphereCenter : TVector; const sphereRadius : Single; var i1, i2 : TVector) : Integer;
Begin Result := VectorGeometry.RayCastSphereIntersect(rayStart, rayVector, sphereCenter, sphereRadius, i1, i2); END;

(*----------------------------------------------------------------------------*)
Function RayCastIntersectsSphere_P( const rayStart, rayVector : TVector; const sphereCenter : TVector; const sphereRadius : Single) : Boolean;
Begin Result := VectorGeometry.RayCastIntersectsSphere(rayStart, rayVector, sphereCenter, sphereRadius); END;

(*----------------------------------------------------------------------------*)
Function RayCastTriangleIntersect_P( const rayStart, rayVector : TVector; const p1, p2, p3 : TAffineVector; intersectPoint : PVector; intersectNormal : PVector) : Boolean;
Begin Result := VectorGeometry.RayCastTriangleIntersect(rayStart, rayVector, p1, p2, p3, intersectPoint, intersectNormal); END;

(*----------------------------------------------------------------------------*)
Function RayCastPlaneXZIntersect_P( const rayStart, rayVector : TVector; const planeY : Single; intersectPoint : PVector) : Boolean;
Begin Result := VectorGeometry.RayCastPlaneXZIntersect(rayStart, rayVector, planeY, intersectPoint); END;

(*----------------------------------------------------------------------------*)
Function RayCastPlaneIntersect_P( const rayStart, rayVector : TVector; const planePoint, planeNormal : TVector; intersectPoint : PVector) : Boolean;
Begin Result := VectorGeometry.RayCastPlaneIntersect(rayStart, rayVector, planePoint, planeNormal, intersectPoint); END;

(*----------------------------------------------------------------------------*)
Function IntersectLinePlane_P( const point, direction : TVector; const plane : THmgPlane; intersectPoint : PVector) : Integer;
Begin Result := VectorGeometry.IntersectLinePlane(point, direction, plane, intersectPoint); END;

(*----------------------------------------------------------------------------*)
Function Roll1_P( const Matrix : TMatrix; const MasterDirection : TAffineVector; Angle : Single) : TMatrix;
Begin Result := VectorGeometry.Roll(Matrix, MasterDirection, Angle); END;

(*----------------------------------------------------------------------------*)
Function Roll_P( const Matrix : TMatrix; Angle : Single) : TMatrix;
Begin Result := VectorGeometry.Roll(Matrix, Angle); END;

(*----------------------------------------------------------------------------*)
Function Pitch1_P( const Matrix : TMatrix; const MasterRight : TAffineVector; Angle : Single) : TMatrix;
Begin Result := VectorGeometry.Pitch(Matrix, MasterRight, Angle); END;

(*----------------------------------------------------------------------------*)
Function Pitch_P( const Matrix : TMatrix; Angle : Single) : TMatrix;
Begin Result := VectorGeometry.Pitch(Matrix, Angle); END;

(*----------------------------------------------------------------------------*)
Function Turn1_P( const Matrix : TMatrix; const MasterUp : TAffineVector; Angle : Single) : TMatrix;
Begin Result := VectorGeometry.Turn(Matrix, MasterUp, Angle); END;

(*----------------------------------------------------------------------------*)
Function Turn_P( const Matrix : TMatrix; angle : Single) : TMatrix;
Begin Result := VectorGeometry.Turn(Matrix, angle); END;

(*----------------------------------------------------------------------------*)
Function ClampValue1_P( const aValue, aMin : Single) : Single;
Begin Result := VectorGeometry.ClampValue(aValue, aMin); END;

(*----------------------------------------------------------------------------*)
Function ClampValue_P( const aValue, aMin, aMax : Single) : Single;
Begin Result := VectorGeometry.ClampValue(aValue, aMin, aMax); END;

(*----------------------------------------------------------------------------*)
Procedure MinVector1_P( var v : TAffineVector; const v1 : TAffineVector);
Begin VectorGeometry.MinVector(v, v1); END;

(*----------------------------------------------------------------------------*)
Procedure MinVector_P( var v : TVector; const v1 : TVector);
Begin VectorGeometry.MinVector(v, v1); END;

(*----------------------------------------------------------------------------*)
Procedure MaxVector1_P( var v : TAffineVector; const v1 : TAffineVector);
Begin VectorGeometry.MaxVector(v, v1); END;

(*----------------------------------------------------------------------------*)
Procedure MaxVector_P( var v : TVector; const v1 : TVector);
Begin VectorGeometry.MaxVector(v, v1); END;

(*----------------------------------------------------------------------------*)
Function MinXYZComponent1_P( const v : TAffineVector) : single;
Begin Result := VectorGeometry.MinXYZComponent(v); END;

(*----------------------------------------------------------------------------*)
Function MinXYZComponent_P( const v : TVector) : Single;
Begin Result := VectorGeometry.MinXYZComponent(v); END;

(*----------------------------------------------------------------------------*)
Function MaxXYZComponent1_P( const v : TAffineVector) : single;
Begin Result := VectorGeometry.MaxXYZComponent(v); END;

(*----------------------------------------------------------------------------*)
Function MaxXYZComponent_P( const v : TVector) : Single;
Begin Result := VectorGeometry.MaxXYZComponent(v); END;

(*----------------------------------------------------------------------------*)
Procedure OffsetFloatArray2_P( valuesDest, valuesDelta : PSingleArray; nb : Integer);
Begin VectorGeometry.OffsetFloatArray(valuesDest, valuesDelta, nb); END;

(*----------------------------------------------------------------------------*)
Procedure OffsetFloatArray1_P( var values : array of Single; delta : Single);
Begin VectorGeometry.OffsetFloatArray(values, delta); END;

(*----------------------------------------------------------------------------*)
Procedure OffsetFloatArray_P( values : PSingleArray; nb : Integer; var delta : Single);
Begin VectorGeometry.OffsetFloatArray(values, nb, delta); END;

(*----------------------------------------------------------------------------*)
Procedure ScaleFloatArray_P( var values : TSingleArray; factor : Single);
Begin VectorGeometry.ScaleFloatArray(values, factor); END;

(*----------------------------------------------------------------------------*)
Procedure ScaleFloatArray( values : PSingleArray; nb : Integer; var factor : Single);
Begin VectorGeometry.ScaleFloatArray(values, nb, factor); END;

(*----------------------------------------------------------------------------*)
Function PolygonSignedArea_P( const p : PAffineVectorArray; nSides : Integer) : Single;
Begin Result := VectorGeometry.PolygonSignedArea(p, nSides); END;

(*----------------------------------------------------------------------------*)
Function TriangleSignedArea_P( const p1, p2, p3 : TAffineVector) : Single;
Begin Result := VectorGeometry.TriangleSignedArea(p1, p2, p3); END;

(*----------------------------------------------------------------------------*)
Function PolygonArea_P( const p : PAffineVectorArray; nSides : Integer) : Single;
Begin Result := VectorGeometry.PolygonArea(p, nSides); END;

(*----------------------------------------------------------------------------*)
Function TriangleArea_P( const p1, p2, p3 : TAffineVector) : Single;
Begin Result := VectorGeometry.TriangleArea(p1, p2, p3); END;

(*----------------------------------------------------------------------------*)
Function MaxInteger1_P( const v1, v2 : Cardinal) : Cardinal;
Begin Result := VectorGeometry.MaxInteger(v1, v2); END;

(*----------------------------------------------------------------------------*)
Function MaxInteger_P( const v1, v2 : Integer) : Integer;
Begin Result := VectorGeometry.MaxInteger(v1, v2); END;

(*----------------------------------------------------------------------------*)
Function MinInteger_P( const v1, v2 : Cardinal) : Cardinal;
Begin Result := VectorGeometry.MinInteger(v1, v2); END;

(*----------------------------------------------------------------------------*)
Function MinInteger9_P( const v1, v2 : Integer) : Integer;
Begin Result := VectorGeometry.MinInteger(v1, v2); END;

(*----------------------------------------------------------------------------*)
Function MaxFloat8_P( const v1, v2, v3 : Extended) : Extended;
Begin Result := VectorGeometry.MaxFloat(v1, v2, v3); END;

(*----------------------------------------------------------------------------*)
Function MaxFloat7_P( const v1, v2, v3 : Double) : Double;
Begin Result := VectorGeometry.MaxFloat(v1, v2, v3); END;

(*----------------------------------------------------------------------------*)
Function MaxFloat6_P( const v1, v2, v3 : Single) : Single;
Begin Result := VectorGeometry.MaxFloat(v1, v2, v3); END;

(*----------------------------------------------------------------------------*)
Function MaxFloat5_P( const v1, v2 : Extended) : Extended;
Begin Result := VectorGeometry.MaxFloat(v1, v2); END;

(*----------------------------------------------------------------------------*)
Function MaxFloat4_P( const v1, v2 : Double) : Double;
Begin Result := VectorGeometry.MaxFloat(v1, v2); END;

(*----------------------------------------------------------------------------*)
Function MaxFloat3_P( const v1, v2 : Single) : Single;
Begin Result := VectorGeometry.MaxFloat(v1, v2); END;

(*----------------------------------------------------------------------------*)
Function MaxFloat2_P( const v : array of Single) : Single;
Begin Result := VectorGeometry.MaxFloat(v); END;

(*----------------------------------------------------------------------------*)
Function MaxFloat1_P( values : PExtendedArray; nbItems : Integer) : Extended;
Begin Result := VectorGeometry.MaxFloat(values, nbItems); END;

(*----------------------------------------------------------------------------*)
Function MaxFloat_P( values : PDoubleArray; nbItems : Integer) : Double;
Begin Result := VectorGeometry.MaxFloat(values, nbItems); END;

(*----------------------------------------------------------------------------*)
Function MaxFloat10_P( values : PSingleArray; nbItems : Integer) : Single;
Begin Result := VectorGeometry.MaxFloat(values, nbItems); END;

(*----------------------------------------------------------------------------*)
Function MinFloat9_P( const v1, v2, v3 : Extended) : Extended;
Begin Result := VectorGeometry.MinFloat(v1, v2, v3); END;

(*----------------------------------------------------------------------------*)
Function MinFloat8_P( const v1, v2, v3 : Double) : Double;
Begin Result := VectorGeometry.MinFloat(v1, v2, v3); END;

(*----------------------------------------------------------------------------*)
Function MinFloat7_P( const v1, v2, v3 : Single) : Single;
Begin Result := VectorGeometry.MinFloat(v1, v2, v3); END;

(*----------------------------------------------------------------------------*)
Function MinFloat6_P( const v1, v2 : Extended) : Extended;
Begin Result := VectorGeometry.MinFloat(v1, v2); END;

(*----------------------------------------------------------------------------*)
Function MinFloat5_P( const v1, v2 : Double) : Double;
Begin Result := VectorGeometry.MinFloat(v1, v2); END;

(*----------------------------------------------------------------------------*)
Function MinFloat4_P( const v : array of Single) : Single;
Begin Result := VectorGeometry.MinFloat(v); END;

(*----------------------------------------------------------------------------*)
Function MinFloat3_P( const v1, v2 : Single) : Single;
Begin Result := VectorGeometry.MinFloat(v1, v2); END;

(*----------------------------------------------------------------------------*)
Function MinFloat2_P( values : PExtendedArray; nbItems : Integer) : Extended;
Begin Result := VectorGeometry.MinFloat(values, nbItems); END;

(*----------------------------------------------------------------------------*)
Function MinFloat1_P( values : PDoubleArray; nbItems : Integer) : Double;
Begin Result := VectorGeometry.MinFloat(values, nbItems); END;

(*----------------------------------------------------------------------------*)
Function MinFloat_P( values : PSingleArray; nbItems : Integer) : Single;
Begin Result := VectorGeometry.MinFloat(values, nbItems); END;

(*----------------------------------------------------------------------------*)
Function IsInCube1_P( const p, d : TVector) : Boolean;
Begin Result := VectorGeometry.IsInCube(p, d); END;

(*----------------------------------------------------------------------------*)
Function IsInCube_P( const p, d : TAffineVector) : Boolean;
Begin Result := VectorGeometry.IsInCube(p, d); END;

(*----------------------------------------------------------------------------*)
Function IsInRange1_P( const x, a, b : Double) : Boolean;
Begin Result := VectorGeometry.IsInRange(x, a, b); END;

(*----------------------------------------------------------------------------*)
Function IsInRange_P( const x, a, b : Single) : Boolean;
Begin Result := VectorGeometry.IsInRange(x, a, b); END;

(*----------------------------------------------------------------------------*)
Function Floor64_P( v : Extended) : Int64;
Begin Result := VectorGeometry.Floor64(v); END;

(*----------------------------------------------------------------------------*)
Function Floor_P( v : Single) : Integer;
Begin Result := VectorGeometry.Floor(v); END;

(*----------------------------------------------------------------------------*)
Function Ceil64_P( v : Extended) : Int64;
Begin Result := VectorGeometry.Ceil64(v); END;

(*----------------------------------------------------------------------------*)
Function Ceil_P( v : Single) : Integer;
Begin Result := VectorGeometry.Ceil(v); END;

(*----------------------------------------------------------------------------*)
Function Round641_P( v : Extended) : Int64;
Begin Result := VectorGeometry.Round64(v); END;

(*----------------------------------------------------------------------------*)
Function Round64_P( v : Single) : Int64;
Begin Result := VectorGeometry.Round64(v); END;

(*----------------------------------------------------------------------------*)
Function Round_P( v : Single) : Integer;
Begin Result := VectorGeometry.Round(v); END;

(*----------------------------------------------------------------------------*)
Function Frac1_P( v : Extended) : Extended;
Begin Result := VectorGeometry.Frac(v); END;

(*----------------------------------------------------------------------------*)
Function Frac_P( v : Single) : Single;
Begin Result := VectorGeometry.Frac(v); END;

(*----------------------------------------------------------------------------*)
Function Int1_P( v : Extended) : Extended;
Begin Result := VectorGeometry.Int(v); END;

(*----------------------------------------------------------------------------*)
Function Int_P( v : Single) : Single;
Begin Result := VectorGeometry.Int(v); END;

(*----------------------------------------------------------------------------*)
Function Trunc64_P( v : Extended) : Int64;
Begin Result := VectorGeometry.Trunc64(v); END;

(*----------------------------------------------------------------------------*)
Function Trunc_P( v : Single) : Integer;
Begin Result := VectorGeometry.Trunc(v); END;

(*----------------------------------------------------------------------------*)
Function RoundInt1_P( v : Extended) : Extended;
Begin Result := VectorGeometry.RoundInt(v); END;

(*----------------------------------------------------------------------------*)
Function RoundInt_P( v : Single) : Single;
Begin Result := VectorGeometry.RoundInt(v); END;

(*----------------------------------------------------------------------------*)
Function ILength1_P( x, y, z : Integer) : Integer;
Begin Result := VectorGeometry.ILength(x, y, z); END;

(*----------------------------------------------------------------------------*)
Function ILength_P( x, y : Integer) : Integer;
Begin Result := VectorGeometry.ILength(x, y); END;

(*----------------------------------------------------------------------------*)
Function Cosh1_P( const x : Double) : Double;
Begin Result := VectorGeometry.Cosh(x); END;

(*----------------------------------------------------------------------------*)
Function Cosh_P( const x : Single) : Single;
Begin Result := VectorGeometry.Cosh(x); END;

(*----------------------------------------------------------------------------*)
Function Sinh1_P( const x : Double) : Double;
Begin Result := VectorGeometry.Sinh(x); END;

(*----------------------------------------------------------------------------*)
Function Sinh_P( const x : Single) : Single;
Begin Result := VectorGeometry.Sinh(x); END;

(*----------------------------------------------------------------------------*)
Function CoTan1_P( const X : Single) : Single;
Begin Result := VectorGeometry.CoTan(X); END;

(*----------------------------------------------------------------------------*)
Function CoTan_P( const X : Extended) : Extended;
Begin Result := VectorGeometry.CoTan(X); END;

(*----------------------------------------------------------------------------*)
Function Tan1_P( const X : Single) : Single;
Begin Result := VectorGeometry.Tan(X); END;

(*----------------------------------------------------------------------------*)
Function Tan_P( const X : Extended) : Extended;
Begin Result := VectorGeometry.Tan(X); END;

(*----------------------------------------------------------------------------*)
Function ArcTan21_P( const Y, X : Single) : Single;
Begin Result := VectorGeometry.ArcTan2(Y, X); END;

(*----------------------------------------------------------------------------*)
Function ArcTan21( const Y, X : Extended) : Extended;
Begin Result := VectorGeometry.ArcTan2(Y, X); END;

(*----------------------------------------------------------------------------*)
Function ArcSin1_P( const X : Single) : Single;
Begin Result := VectorGeometry.ArcSin(X); END;

(*----------------------------------------------------------------------------*)
Function ArcSin_P( const X : Extended) : Extended;
Begin Result := VectorGeometry.ArcSin(X); END;

(*----------------------------------------------------------------------------*)
Function ArcCos1_P( const x : Single) : Single;
Begin Result := VectorGeometry.ArcCos(x); END;

(*----------------------------------------------------------------------------*)
Function ArcCos_P( const X : Extended) : Extended;
Begin Result := VectorGeometry.ArcCos(X); END;

(*----------------------------------------------------------------------------*)
Procedure SinCos3_P( const theta, radius : Single; var Sin, Cos : Single);
Begin VectorGeometry.SinCos(theta, radius, Sin, Cos); END;

(*----------------------------------------------------------------------------*)
Procedure SinCos2_P( const theta, radius : Double; var Sin, Cos : Double);
Begin VectorGeometry.SinCos(theta, radius, Sin, Cos); END;

(*----------------------------------------------------------------------------*)
Procedure SinCos1_P( const theta, radius : Double; var Sin, Cos : Extended);
Begin VectorGeometry.SinCos(theta, radius, Sin, Cos); END;

Procedure SinCos1_P1( const theta : Double; var Sin, Cos : Double);
Begin VectorGeometry.SinCos(theta,Sin, Cos); END;


(*----------------------------------------------------------------------------*)
Procedure SinCos_P( const Theta : Single; var Sin, Cos : Single);
Begin VectorGeometry.SinCos(Theta, Sin, Cos); END;

(*----------------------------------------------------------------------------*)
Procedure SinCos1( const Theta : Double; var Sin, Cos : Double);
Begin VectorGeometry.SinCos(Theta, Sin, Cos); END;

(*----------------------------------------------------------------------------*)
Procedure SinCos( const Theta : Extended; var Sin, Cos : Extended);
Begin VectorGeometry.SinCos(Theta, Sin, Cos); END;

(*----------------------------------------------------------------------------*)
Function RadToDeg1_P( const Radians : Single) : Single;
Begin Result := VectorGeometry.RadToDeg(Radians); END;

(*----------------------------------------------------------------------------*)
Function RadToDeg_P( const Radians : Extended) : Extended;
Begin Result := VectorGeometry.RadToDeg(Radians); END;

(*----------------------------------------------------------------------------*)
Function DegToRad1_P( const Degrees : Single) : Single;
Begin Result := VectorGeometry.DegToRad(Degrees); END;

(*----------------------------------------------------------------------------*)
Function DegToRad_P( const Degrees : Extended) : Extended;
Begin Result := VectorGeometry.DegToRad(Degrees); END;

(*----------------------------------------------------------------------------*)
Function Power1_P( Base : Single; Exponent : Integer) : Single;
Begin Result := VectorGeometry.Power(Base, Exponent); END;

(*----------------------------------------------------------------------------*)
Function Power_P( const Base, Exponent : Single) : Single;
Begin Result := VectorGeometry.Power(Base, Exponent); END;

(*----------------------------------------------------------------------------*)
Function Log21_P( X : Single) : Single;
Begin Result := VectorGeometry.Log2(X); END;

(*----------------------------------------------------------------------------*)
Function Log2_P( X : Extended) : Extended;
Begin Result := VectorGeometry.Log2(X); END;

(*----------------------------------------------------------------------------*)
Function QuaternionSlerp1_P( const source, dest : TQuaternion; const t : Single) : TQuaternion;
Begin Result := VectorGeometry.QuaternionSlerp(source, dest, t); END;

(*----------------------------------------------------------------------------*)
Function QuaternionSlerp_P( const QStart, QEnd : TQuaternion; Spin : Integer; t : Single) : TQuaternion;
Begin Result := VectorGeometry.QuaternionSlerp(QStart, QEnd, Spin, t); END;

(*----------------------------------------------------------------------------*)
Function PointPlaneDistance1_P( const point, planePoint, planeNormal : TAffineVector) : Single;
Begin Result := VectorGeometry.PointPlaneDistance(point, planePoint, planeNormal); END;

(*----------------------------------------------------------------------------*)
Function PointPlaneDistance_P( const point, planePoint, planeNormal : TVector) : Single;
Begin Result := VectorGeometry.PointPlaneDistance(point, planePoint, planeNormal); END;

(*----------------------------------------------------------------------------*)
Function PointIsInHalfSpace1_P( const point, planePoint, planeNormal : TAffineVector) : Boolean;
Begin Result := VectorGeometry.PointIsInHalfSpace(point, planePoint, planeNormal); END;

(*----------------------------------------------------------------------------*)
Function PointIsInHalfSpace_P( const point, planePoint, planeNormal : TVector) : Boolean;
Begin Result := VectorGeometry.PointIsInHalfSpace(point, planePoint, planeNormal); END;

(*----------------------------------------------------------------------------*)
Procedure CalcPlaneNormal2_P( const p1, p2, p3 : TVector; var vr : TAffineVector);
Begin VectorGeometry.CalcPlaneNormal(p1, p2, p3, vr); END;

(*----------------------------------------------------------------------------*)
Procedure CalcPlaneNormal1_P( const p1, p2, p3 : TAffineVector; var vr : TAffineVector);
Begin VectorGeometry.CalcPlaneNormal(p1, p2, p3, vr); END;

(*----------------------------------------------------------------------------*)
Function CalcPlaneNormal_P( const p1, p2, p3 : TAffineVector) : TAffineVector;
Begin Result := VectorGeometry.CalcPlaneNormal(p1, p2, p3); END;

(*----------------------------------------------------------------------------*)
Function PlaneEvaluatePoint1_P( const plane : THmgPlane; const point : TVector) : Single;
Begin Result := VectorGeometry.PlaneEvaluatePoint(plane, point); END;

(*----------------------------------------------------------------------------*)
Function PlaneEvaluatePoint_P( const plane : THmgPlane; const point : TAffineVector) : Single;
Begin Result := VectorGeometry.PlaneEvaluatePoint(plane, point); END;

(*----------------------------------------------------------------------------*)
Function PlaneMake3_P( const point, normal : TVector) : THmgPlane;
Begin Result := VectorGeometry.PlaneMake(point, normal); END;

(*----------------------------------------------------------------------------*)
Function PlaneMake2_P( const point, normal : TAffineVector) : THmgPlane;
Begin Result := VectorGeometry.PlaneMake(point, normal); END;

(*----------------------------------------------------------------------------*)
Function PlaneMake1_P( const p1, p2, p3 : TVector) : THmgPlane;
Begin Result := VectorGeometry.PlaneMake(p1, p2, p3); END;

(*----------------------------------------------------------------------------*)
Function PlaneMake_P( const p1, p2, p3 : TAffineVector) : THmgPlane;
Begin Result := VectorGeometry.PlaneMake(p1, p2, p3); END;

(*----------------------------------------------------------------------------*)
Procedure InvertMatrix1_P( var M : TAffineMatrix);
Begin VectorGeometry.InvertMatrix(M); END;

(*----------------------------------------------------------------------------*)
Procedure InvertMatrix_P( var M : TMatrix);
Begin VectorGeometry.InvertMatrix(M); END;

(*----------------------------------------------------------------------------*)
Procedure TransposeMatrix1_P( var M : TMatrix);
Begin VectorGeometry.TransposeMatrix(M); END;

(*----------------------------------------------------------------------------*)
Procedure TransposeMatrix_P( var M : TAffineMatrix);
Begin VectorGeometry.TransposeMatrix(M); END;

(*----------------------------------------------------------------------------*)
Procedure TranslateMatrix1_P( var M : TMatrix; const v : TVector);
Begin VectorGeometry.TranslateMatrix(M, v); END;

(*----------------------------------------------------------------------------*)
Procedure TranslateMatrix_P( var M : TMatrix; const v : TAffineVector);
Begin VectorGeometry.TranslateMatrix(M, v); END;

(*----------------------------------------------------------------------------*)
Procedure ScaleMatrix1_P( var M : TMatrix; const factor : Single);
Begin VectorGeometry.ScaleMatrix(M, factor); END;

(*----------------------------------------------------------------------------*)
Procedure ScaleMatrix_P( var M : TAffineMatrix; const factor : Single);
Begin VectorGeometry.ScaleMatrix(M, factor); END;

(*----------------------------------------------------------------------------*)
Procedure AdjointMatrix1_P( var M : TAffineMatrix);
Begin VectorGeometry.AdjointMatrix(M); END;

(*----------------------------------------------------------------------------*)
Procedure AdjointMatrix_P( var M : TMatrix);
Begin VectorGeometry.AdjointMatrix(M); END;

(*----------------------------------------------------------------------------*)
Function MatrixDeterminant1_P( const M : TMatrix) : Single;
Begin Result := VectorGeometry.MatrixDeterminant(M); END;

(*----------------------------------------------------------------------------*)
Function MatrixDeterminant_P( const M : TAffineMatrix) : Single;
Begin Result := VectorGeometry.MatrixDeterminant(M); END;

(*----------------------------------------------------------------------------*)
Function VectorTransform3_P( const V : TAffineVector; const M : TAffineMatrix) : TAffineVector;
Begin Result := VectorGeometry.VectorTransform(V, M); END;

(*----------------------------------------------------------------------------*)
Function VectorTransform2_P( const V : TAffineVector; const M : TMatrix) : TAffineVector;
Begin Result := VectorGeometry.VectorTransform(V, M); END;

(*----------------------------------------------------------------------------*)
Function VectorTransform1_P( const V : TVector; const M : TAffineMatrix) : TVector;
Begin Result := VectorGeometry.VectorTransform(V, M); END;

(*----------------------------------------------------------------------------*)
Function VectorTransform_P( const V : TVector; const M : TMatrix) : TVector;
Begin Result := VectorGeometry.VectorTransform(V, M); END;

(*----------------------------------------------------------------------------*)
Procedure MatrixMultiply2_P( const M1, M2 : TMatrix; var MResult : TMatrix);
Begin VectorGeometry.MatrixMultiply(M1, M2, MResult); END;

(*----------------------------------------------------------------------------*)
Function MatrixMultiply1_P( const M1, M2 : TMatrix) : TMatrix;
Begin Result := VectorGeometry.MatrixMultiply(M1, M2); END;

(*----------------------------------------------------------------------------*)
Function MatrixMultiply_P( const M1, M2 : TAffineMatrix) : TAffineMatrix;
Begin Result := VectorGeometry.MatrixMultiply(M1, M2); END;

(*----------------------------------------------------------------------------*)
Function CreateRotationMatrix1_P( const anAxis : TVector; angle : Single) : TMatrix;
Begin Result := VectorGeometry.CreateRotationMatrix(anAxis, angle); END;

(*----------------------------------------------------------------------------*)
Function CreateRotationMatrix_P( const anAxis : TAffineVector; angle : Single) : TMatrix;
Begin Result := VectorGeometry.CreateRotationMatrix(anAxis, angle); END;

(*----------------------------------------------------------------------------*)
Function CreateRotationMatrixZ1_P( const angle : Single) : TMatrix;
Begin Result := VectorGeometry.CreateRotationMatrixZ(angle); END;

(*----------------------------------------------------------------------------*)
Function CreateRotationMatrixZ_P( const sine, cosine : Single) : TMatrix;
Begin Result := VectorGeometry.CreateRotationMatrixZ(sine, cosine); END;

(*----------------------------------------------------------------------------*)
Function CreateRotationMatrixY1_P( const angle : Single) : TMatrix;
Begin Result := VectorGeometry.CreateRotationMatrixY(angle); END;

(*----------------------------------------------------------------------------*)
Function CreateRotationMatrixY_P( const sine, cosine : Single) : TMatrix;
Begin Result := VectorGeometry.CreateRotationMatrixY(sine, cosine); END;

(*----------------------------------------------------------------------------*)
Function CreateRotationMatrixX1_P( const angle : Single) : TMatrix;
Begin Result := VectorGeometry.CreateRotationMatrixX(angle); END;

(*----------------------------------------------------------------------------*)
Function CreateRotationMatrixX_P( const sine, cosine : Single) : TMatrix;
Begin Result := VectorGeometry.CreateRotationMatrixX(sine, cosine); END;

(*----------------------------------------------------------------------------*)
Function CreateScaleAndTranslationMatrix_P( const scale, offset : TVector) : TMatrix;
Begin Result := VectorGeometry.CreateScaleAndTranslationMatrix(scale, offset); END;

(*----------------------------------------------------------------------------*)
Function CreateTranslationMatrix1_P( const V : TVector) : TMatrix;
Begin Result := VectorGeometry.CreateTranslationMatrix(V); END;

(*----------------------------------------------------------------------------*)
Function CreateTranslationMatrix_P( const V : TAffineVector) : TMatrix;
Begin Result := VectorGeometry.CreateTranslationMatrix(V); END;

(*----------------------------------------------------------------------------*)
Function CreateScaleMatrix1_P( const v : TVector) : TMatrix;
Begin Result := VectorGeometry.CreateScaleMatrix(v); END;

(*----------------------------------------------------------------------------*)
Function CreateScaleMatrix_P( const v : TAffineVector) : TMatrix;
Begin Result := VectorGeometry.CreateScaleMatrix(v); END;

(*----------------------------------------------------------------------------*)
Procedure SetMatrixRow_P( var dest : TMatrix; rowNb : Integer; const aRow : TVector);
Begin VectorGeometry.SetMatrixRow(dest, rowNb, aRow); END;

(*----------------------------------------------------------------------------*)
Procedure SetMatrix2_P( var dest : TMatrix; const src : TAffineMatrix);
Begin VectorGeometry.SetMatrix(dest, src); END;

(*----------------------------------------------------------------------------*)
Procedure SetMatrix1_P( var dest : TAffineMatrix; const src : TMatrix);
Begin VectorGeometry.SetMatrix(dest, src); END;

(*----------------------------------------------------------------------------*)
Procedure SetMatrix_P( var dest : THomogeneousDblMatrix; const src : TMatrix);
Begin VectorGeometry.SetMatrix(dest, src); END;

(*----------------------------------------------------------------------------*)
Function VectorAbs1_P( const v : TAffineVector) : TAffineVector;
Begin Result := VectorGeometry.VectorAbs(v); END;

(*----------------------------------------------------------------------------*)
Function VectorAbs_P( const v : TVector) : TVector;
Begin Result := VectorGeometry.VectorAbs(v); END;

(*----------------------------------------------------------------------------*)
Procedure AbsVector1_P( var v : TAffineVector);
Begin VectorGeometry.AbsVector(v); END;

(*----------------------------------------------------------------------------*)
Procedure AbsVector_P( var v : TVector);
Begin VectorGeometry.AbsVector(v); END;

(*----------------------------------------------------------------------------*)
Function VectorRotateAroundZ_P( const v : TAffineVector; alpha : Single) : TAffineVector;
Begin Result := VectorGeometry.VectorRotateAroundZ(v, alpha); END;

(*----------------------------------------------------------------------------*)
Procedure VectorRotateAroundY1_P( const v : TAffineVector; alpha : Single; var vr : TAffineVector);
Begin VectorGeometry.VectorRotateAroundY(v, alpha, vr); END;

(*----------------------------------------------------------------------------*)
Function VectorRotateAroundY_P( const v : TAffineVector; alpha : Single) : TAffineVector;
Begin Result := VectorGeometry.VectorRotateAroundY(v, alpha); END;

(*----------------------------------------------------------------------------*)
Function VectorRotateAroundX_P( const v : TAffineVector; alpha : Single) : TAffineVector;
Begin Result := VectorGeometry.VectorRotateAroundX(v, alpha); END;

(*----------------------------------------------------------------------------*)
Procedure RotateVector1_P( var vector : TVector; const axis : TVector; angle : Single);
Begin VectorGeometry.RotateVector(vector, axis, angle); END;

(*----------------------------------------------------------------------------*)
Procedure RotateVector_P( var vector : TVector; const axis : TAffineVector; angle : Single);
Begin VectorGeometry.RotateVector(vector, axis, angle); END;

(*----------------------------------------------------------------------------*)
Function VectorDistance21_P( const v1, v2 : TVector) : Single;
Begin Result := VectorGeometry.VectorDistance2(v1, v2); END;

(*----------------------------------------------------------------------------*)
Function VectorDistance2_P( const v1, v2 : TAffineVector) : Single;
Begin Result := VectorGeometry.VectorDistance2(v1, v2); END;

(*----------------------------------------------------------------------------*)
Function VectorDistance1_P( const v1, v2 : TVector) : Single;
Begin Result := VectorGeometry.VectorDistance(v1, v2); END;

(*----------------------------------------------------------------------------*)
Function VectorDistance_P( const v1, v2 : TAffineVector) : Single;
Begin Result := VectorGeometry.VectorDistance(v1, v2); END;

(*----------------------------------------------------------------------------*)
Function VectorSpacing2_P( const v1, v2 : TVector) : Single;
Begin Result := VectorGeometry.VectorSpacing(v1, v2); END;

(*----------------------------------------------------------------------------*)
Function VectorSpacing1_P( const v1, v2 : TAffineVector) : Single;
Begin Result := VectorGeometry.VectorSpacing(v1, v2); END;

(*----------------------------------------------------------------------------*)
Function VectorSpacing_P( const v1, v2 : TTexPoint) : Single;
Begin Result := VectorGeometry.VectorSpacing(v1, v2); END;

(*----------------------------------------------------------------------------*)
Function VectorIsNull1_P( const v : TAffineVector) : Boolean;
Begin Result := VectorGeometry.VectorIsNull(v); END;

(*----------------------------------------------------------------------------*)
Function VectorIsNull_P( const v : TVector) : Boolean;
Begin Result := VectorGeometry.VectorIsNull(v); END;

(*----------------------------------------------------------------------------*)
Function AffineVectorEquals_P( const V1, V2 : TVector) : Boolean;
Begin Result := VectorGeometry.AffineVectorEquals(V1, V2); END;

(*----------------------------------------------------------------------------*)
Function VectorEquals1_P( const V1, V2 : TAffineVector) : Boolean;
Begin Result := VectorGeometry.VectorEquals(V1, V2); END;

(*----------------------------------------------------------------------------*)
Function VectorEquals_P( const V1, V2 : TVector) : Boolean;
Begin Result := VectorGeometry.VectorEquals(V1, V2); END;

(*----------------------------------------------------------------------------*)
Procedure DivideVector_P( var v : TVector; const divider : TVector);
Begin VectorGeometry.DivideVector(v, divider); END;

(*----------------------------------------------------------------------------*)
Procedure VectorScale4_P( const v : TVector; factor : Single; var vr : TAffineVector);
Begin VectorGeometry.VectorScale(v, factor, vr); END;

(*----------------------------------------------------------------------------*)
Procedure VectorScale3_P( const v : TVector; factor : Single; var vr : TVector);
Begin VectorGeometry.VectorScale(v, factor, vr); END;

(*----------------------------------------------------------------------------*)
Function VectorScale2_P( const v : TVector; factor : Single) : TVector;
Begin Result := VectorGeometry.VectorScale(v, factor); END;

(*----------------------------------------------------------------------------*)
Procedure VectorScale1_P( const v : TAffineVector; factor : Single; var vr : TAffineVector);
Begin VectorGeometry.VectorScale(v, factor, vr); END;

(*----------------------------------------------------------------------------*)
Function VectorScale_P( const v : TAffineVector; factor : Single) : TAffineVector;
Begin Result := VectorGeometry.VectorScale(v, factor); END;

(*----------------------------------------------------------------------------*)
Procedure ScaleVector3_P( var v : TVector; const factor : TVector);
Begin VectorGeometry.ScaleVector(v, factor); END;

(*----------------------------------------------------------------------------*)
Procedure ScaleVector2_P( var v : TVector; factor : Single);
Begin VectorGeometry.ScaleVector(v, factor); END;

(*----------------------------------------------------------------------------*)
Procedure ScaleVector1_P( var v : TAffineVector; const factor : TAffineVector);
Begin VectorGeometry.ScaleVector(v, factor); END;

(*----------------------------------------------------------------------------*)
Procedure ScaleVector_P( var v : TAffineVector; factor : Single);
Begin VectorGeometry.ScaleVector(v, factor); END;

(*----------------------------------------------------------------------------*)
Procedure NegateVector3_P( var V : array of Single);
Begin VectorGeometry.NegateVector(V); END;

(*----------------------------------------------------------------------------*)
Procedure NegateVector2_P( var V : TVector);
Begin VectorGeometry.NegateVector(V); END;

(*----------------------------------------------------------------------------*)
Procedure NegateVector_P( var V : TAffineVector);
Begin VectorGeometry.NegateVector(V); END;

(*----------------------------------------------------------------------------*)
Function VectorNegate1_P( const v : TVector) : TVector;
Begin Result := VectorGeometry.VectorNegate(v); END;

(*----------------------------------------------------------------------------*)
Function VectorNegate_P( const v : TAffineVector) : TAffineVector;
Begin Result := VectorGeometry.VectorNegate(v); END;

(*----------------------------------------------------------------------------*)
Procedure NormalizeVectorArray_P( list : PAffineVectorArray; n : Integer);
Begin VectorGeometry.NormalizeVectorArray(list, n); END;

(*----------------------------------------------------------------------------*)
Function VectorNormalize1_P( const v : TVector) : TVector;
Begin Result := VectorGeometry.VectorNormalize(v); END;

(*----------------------------------------------------------------------------*)
Function VectorNormalize_P( const v : TAffineVector) : TAffineVector;
Begin Result := VectorGeometry.VectorNormalize(v); END;

(*----------------------------------------------------------------------------*)
Procedure NormalizeVector1_P( var v : TVector);
Begin VectorGeometry.NormalizeVector(v); END;

(*----------------------------------------------------------------------------*)
Procedure NormalizeVector_P( var v : TAffineVector);
Begin VectorGeometry.NormalizeVector(v); END;

(*----------------------------------------------------------------------------*)
Function VectorNorm3_P( var V : array of Single) : Single;
Begin Result := VectorGeometry.VectorNorm(V); END;

(*----------------------------------------------------------------------------*)
Function VectorNorm2_P( const v : TVector) : Single;
Begin Result := VectorGeometry.VectorNorm(v); END;

(*----------------------------------------------------------------------------*)
Function VectorNorm1_P( const v : TAffineVector) : Single;
Begin Result := VectorGeometry.VectorNorm(v); END;

(*----------------------------------------------------------------------------*)
Function VectorNorm_P( const x, y : Single) : Single;
Begin Result := VectorGeometry.VectorNorm(x, y); END;

(*----------------------------------------------------------------------------*)
Function VectorLength4_P( const v : array of Single) : Single;
Begin Result := VectorGeometry.VectorLength(v); END;

(*----------------------------------------------------------------------------*)
Function VectorLength3_P( const v : TVector) : Single;
Begin Result := VectorGeometry.VectorLength(v); END;

(*----------------------------------------------------------------------------*)
Function VectorLength2_P( const v : TAffineVector) : Single;
Begin Result := VectorGeometry.VectorLength(v); END;

(*----------------------------------------------------------------------------*)
Function VectorLength1_P( const x, y, z : Single) : Single;
Begin Result := VectorGeometry.VectorLength(x, y, z); END;

(*----------------------------------------------------------------------------*)
Function VectorLength_P( const x, y : Single) : Single;
Begin Result := VectorGeometry.VectorLength(x, y); END;

(*----------------------------------------------------------------------------*)
Procedure VectorArrayLerp1_P( const src1, src2 : PAffineVectorArray; t : Single; n : Integer; dest : PAffineVectorArray);
Begin VectorGeometry.VectorArrayLerp(src1, src2, t, n, dest); END;

(*----------------------------------------------------------------------------*)
Procedure VectorArrayLerp_P( const src1, src2 : PVectorArray; t : Single; n : Integer; dest : PVectorArray);
Begin VectorGeometry.VectorArrayLerp(src1, src2, t, n, dest); END;

(*----------------------------------------------------------------------------*)
Function VectorAngleCombine_P( const v1, v2 : TAffineVector; f : Single) : TAffineVector;
Begin Result := VectorGeometry.VectorAngleCombine(v1, v2, f); END;

(*----------------------------------------------------------------------------*)
Function VectorAngleLerp_P( const v1, v2 : TAffineVector; t : Single) : TAffineVector;
Begin Result := VectorGeometry.VectorAngleLerp(v1, v2, t); END;

(*----------------------------------------------------------------------------*)
Procedure VectorLerp3_P( const v1, v2 : TVector; t : Single; var vr : TVector);
Begin VectorGeometry.VectorLerp(v1, v2, t, vr); END;

(*----------------------------------------------------------------------------*)
Function VectorLerp2_P( const v1, v2 : TVector; t : Single) : TVector;
Begin Result := VectorGeometry.VectorLerp(v1, v2, t); END;

(*----------------------------------------------------------------------------*)
Procedure VectorLerp1_P( const v1, v2 : TAffineVector; t : Single; var vr : TAffineVector);
Begin VectorGeometry.VectorLerp(v1, v2, t, vr); END;

(*----------------------------------------------------------------------------*)
Function VectorLerp_P( const v1, v2 : TAffineVector; t : Single) : TAffineVector;
Begin Result := VectorGeometry.VectorLerp(v1, v2, t); END;

(*----------------------------------------------------------------------------*)
Function TexPointLerp_P( const t1, t2 : TTexPoint; t : Single) : TTexPoint;
Begin Result := VectorGeometry.TexPointLerp(t1, t2, t); END;

(*----------------------------------------------------------------------------*)
Procedure VectorCrossProduct5_P( const v1, v2 : TAffineVector; var vr : TAffineVector);
Begin VectorGeometry.VectorCrossProduct(v1, v2, vr); END;

(*----------------------------------------------------------------------------*)
Procedure VectorCrossProduct4_P( const v1, v2 : TVector; var vr : TAffineVector);
Begin VectorGeometry.VectorCrossProduct(v1, v2, vr); END;

(*----------------------------------------------------------------------------*)
Procedure VectorCrossProduct3_P( const v1, v2 : TAffineVector; var vr : TVector);
Begin VectorGeometry.VectorCrossProduct(v1, v2, vr); END;

(*----------------------------------------------------------------------------*)
Procedure VectorCrossProduct2_P( const v1, v2 : TVector; var vr : TVector);
Begin VectorGeometry.VectorCrossProduct(v1, v2, vr); END;

(*----------------------------------------------------------------------------*)
Function VectorCrossProduct1_P( const V1, V2 : TVector) : TVector;
Begin Result := VectorGeometry.VectorCrossProduct(V1, V2); END;

(*----------------------------------------------------------------------------*)
Function VectorCrossProduct_P( const V1, V2 : TAffineVector) : TAffineVector;
Begin Result := VectorGeometry.VectorCrossProduct(V1, V2); END;

(*----------------------------------------------------------------------------*)
Function PointProject1_P( const p, origin, direction : TVector) : Single;
Begin Result := VectorGeometry.PointProject(p, origin, direction); END;

(*----------------------------------------------------------------------------*)
Function PointProject_P( const p, origin, direction : TAffineVector) : Single;
Begin Result := VectorGeometry.PointProject(p, origin, direction); END;

(*----------------------------------------------------------------------------*)
Function VectorDotProduct2_P( const V1 : TVector; const V2 : TAffineVector) : Single;
Begin Result := VectorGeometry.VectorDotProduct(V1, V2); END;

(*----------------------------------------------------------------------------*)
Function VectorDotProduct1_P( const V1, V2 : TVector) : Single;
Begin Result := VectorGeometry.VectorDotProduct(V1, V2); END;

(*----------------------------------------------------------------------------*)
Function VectorDotProduct_P( const V1, V2 : TAffineVector) : Single;
Begin Result := VectorGeometry.VectorDotProduct(V1, V2); END;

(*----------------------------------------------------------------------------*)
Procedure VectorCombine31_P( const V1, V2, V3 : TVector; const F1, F2, F3 : Single; var vr : TVector);
Begin VectorGeometry.VectorCombine3(V1, V2, V3, F1, F2, F3, vr); END;

(*----------------------------------------------------------------------------*)
Function VectorCombine3_P( const V1, V2, V3 : TVector; const F1, F2, F3 : Single) : TVector;
Begin Result := VectorGeometry.VectorCombine3(V1, V2, V3, F1, F2, F3); END;

(*----------------------------------------------------------------------------*)
Procedure VectorCombine11_P( const V1, V2 : TVector; const F2 : Single; var vr : TVector);
Begin VectorGeometry.VectorCombine(V1, V2, F2, vr); END;

(*----------------------------------------------------------------------------*)
Procedure VectorCombine10_P( const V1, V2 : TVector; const F1, F2 : Single; var vr : TVector);
Begin VectorGeometry.VectorCombine(V1, V2, F1, F2, vr); END;

(*----------------------------------------------------------------------------*)
Procedure VectorCombine9_P( const V1 : TVector; const V2 : TAffineVector; const F1, F2 : Single; var vr : TVector);
Begin VectorGeometry.VectorCombine(V1, V2, F1, F2, vr); END;

(*----------------------------------------------------------------------------*)
Function VectorCombine8_P( const V1 : TVector; const V2 : TAffineVector; const F1, F2 : Single) : TVector;
Begin Result := VectorGeometry.VectorCombine(V1, V2, F1, F2); END;

(*----------------------------------------------------------------------------*)
Function VectorCombine7_P( const V1, V2 : TVector; const F1, F2 : Single) : TVector;
Begin Result := VectorGeometry.VectorCombine(V1, V2, F1, F2); END;

(*----------------------------------------------------------------------------*)
Procedure CombineVector6_P( var vr : TVector; const v : TAffineVector; var f : Single);
Begin VectorGeometry.CombineVector(vr, v, f); END;

(*----------------------------------------------------------------------------*)
Procedure CombineVector5_P( var vr : TVector; const v : TVector; var f : Single);
Begin VectorGeometry.CombineVector(vr, v, f); END;

(*----------------------------------------------------------------------------*)
Procedure VectorCombine34_P( const V1, V2, V3 : TAffineVector; const F1, F2, F3 : Single; var vr : TAffineVector);
Begin VectorGeometry.VectorCombine3(V1, V2, V3, F1, F2, F3, vr); END;

(*----------------------------------------------------------------------------*)
Function VectorCombine33_P( const V1, V2, V3 : TAffineVector; const F1, F2, F3 : Single) : TAffineVector;
Begin Result := VectorGeometry.VectorCombine3(V1, V2, V3, F1, F2, F3); END;

(*----------------------------------------------------------------------------*)
Function VectorCombine2_P( const V1, V2 : TAffineVector; const F1, F2 : Single) : TAffineVector;
Begin Result := VectorGeometry.VectorCombine(V1, V2, F1, F2); END;

(*----------------------------------------------------------------------------*)
Procedure CombineVector1_P( var vr : TAffineVector; const v : TAffineVector; pf : PFloat);
Begin VectorGeometry.CombineVector(vr, v, pf); END;

(*----------------------------------------------------------------------------*)
Procedure CombineVector_P( var vr : TAffineVector; const v : TAffineVector; var f : Single);
Begin VectorGeometry.CombineVector(vr, v, f); END;

(*----------------------------------------------------------------------------*)
Procedure SubtractVector10_P( var V1 : TVector; const V2 : TVector);
Begin VectorGeometry.SubtractVector(V1, V2); END;

(*----------------------------------------------------------------------------*)
Procedure SubtractVector9_P( var V1 : TAffineVector; const V2 : TAffineVector);
Begin VectorGeometry.SubtractVector(V1, V2); END;

(*----------------------------------------------------------------------------*)
Function VectorSubtract8_P( const v1 : TVector; delta : Single) : TVector;
Begin Result := VectorGeometry.VectorSubtract(v1, delta); END;

(*----------------------------------------------------------------------------*)
Function VectorSubtract7_P( const v1 : TAffineVector; delta : Single) : TAffineVector;
Begin Result := VectorGeometry.VectorSubtract(v1, delta); END;

(*----------------------------------------------------------------------------*)
Procedure VectorSubtract6_P( const v1, v2 : TVector; var result : TAffineVector);
Begin VectorGeometry.VectorSubtract(v1, v2, result); END;

(*----------------------------------------------------------------------------*)
Procedure VectorSubtract5_P( const v1, v2 : TVector; var result : TVector);
Begin VectorGeometry.VectorSubtract(v1, v2, result); END;

(*----------------------------------------------------------------------------*)
Function VectorSubtract4_P( const V1, V2 : TVector) : TVector;
Begin Result := VectorGeometry.VectorSubtract(V1, V2); END;

(*----------------------------------------------------------------------------*)
Procedure VectorSubtract3_P( const v1 : TVector; v2 : TAffineVector; var result : TVector);
Begin VectorGeometry.VectorSubtract(v1, v2, result); END;

(*----------------------------------------------------------------------------*)
Procedure VectorSubtract2_P( const v1, v2 : TAffineVector; var result : TVector);
Begin VectorGeometry.VectorSubtract(v1, v2, result); END;

(*----------------------------------------------------------------------------*)
Procedure VectorSubtract1_P( const v1, v2 : TAffineVector; var result : TAffineVector);
Begin VectorGeometry.VectorSubtract(v1, v2, result); END;

(*----------------------------------------------------------------------------*)
Function VectorSubtract_P( const V1, V2 : TAffineVector) : TAffineVector;
Begin Result := VectorGeometry.VectorSubtract(V1, V2); END;

(*----------------------------------------------------------------------------*)
Procedure VectorArrayAdd_P( const src : PAffineVectorArray; const delta : TAffineVector; const nb : Integer; dest : PAffineVectorArray);
Begin VectorGeometry.VectorArrayAdd(src, delta, nb, dest); END;

(*----------------------------------------------------------------------------*)
Procedure TexPointArrayScaleAndAdd_P( const src : PTexPointArray; const delta : TTexPoint; const nb : Integer; const scale : TTexPoint; dest : PTexPointArray);
Begin VectorGeometry.TexPointArrayScaleAndAdd(src, delta, nb, scale, dest); END;

(*----------------------------------------------------------------------------*)
Procedure TexPointArrayAdd_P( const src : PTexPointArray; const delta : TTexPoint; const nb : Integer; dest : PTexPointArray);
Begin VectorGeometry.TexPointArrayAdd(src, delta, nb, dest); END;

(*----------------------------------------------------------------------------*)
Procedure AddVector11_P( var v : TVector; const f : Single);
Begin VectorGeometry.AddVector(v, f); END;

(*----------------------------------------------------------------------------*)
Procedure AddVector10_P( var v : TAffineVector; const f : Single);
Begin VectorGeometry.AddVector(v, f); END;

(*----------------------------------------------------------------------------*)
Procedure AddVector9_P( var v1 : TVector; const v2 : TVector);
Begin VectorGeometry.AddVector(v1, v2); END;

(*----------------------------------------------------------------------------*)
Procedure AddVector8_P( var v1 : TAffineVector; const v2 : TVector);
Begin VectorGeometry.AddVector(v1, v2); END;

(*----------------------------------------------------------------------------*)
Procedure AddVector7_P( var v1 : TAffineVector; const v2 : TAffineVector);
Begin VectorGeometry.AddVector(v1, v2); END;

(*----------------------------------------------------------------------------*)
Function VectorAdd6_P( const v : TVector; const f : Single) : TVector;
Begin Result := VectorGeometry.VectorAdd(v, f); END;

(*----------------------------------------------------------------------------*)
Function VectorAdd5_P( const v : TAffineVector; const f : Single) : TAffineVector;
Begin Result := VectorGeometry.VectorAdd(v, f); END;

(*----------------------------------------------------------------------------*)
Procedure VectorAdd4_P( const v1, v2 : TVector; var vr : TVector);
Begin VectorGeometry.VectorAdd(v1, v2, vr); END;

(*----------------------------------------------------------------------------*)
Function VectorAdd3_P( const v1, v2 : TVector) : TVector;
Begin Result := VectorGeometry.VectorAdd(v1, v2); END;

(*----------------------------------------------------------------------------*)
Procedure VectorAdd2_P( const v1, v2 : TAffineVector; vr : PAffineVector);
Begin VectorGeometry.VectorAdd(v1, v2, vr); END;

(*----------------------------------------------------------------------------*)
Procedure VectorAdd1_P( const v1, v2 : TAffineVector; var vr : TAffineVector);
Begin VectorGeometry.VectorAdd(v1, v2, vr); END;

(*----------------------------------------------------------------------------*)
Function VectorAdd_P( const v1, v2 : TAffineVector) : TAffineVector;
Begin Result := VectorGeometry.VectorAdd(v1, v2); END;

(*----------------------------------------------------------------------------*)
Procedure RstVector1_P( var v : TVector);
Begin VectorGeometry.RstVector(v); END;

(*----------------------------------------------------------------------------*)
Procedure RstVector_P( var v : TAffineVector);
Begin VectorGeometry.RstVector(v); END;

(*----------------------------------------------------------------------------*)
Procedure MakeVector3_P( var v : TVector; const av : TVector);
Begin VectorGeometry.MakeVector(v, av); END;

(*----------------------------------------------------------------------------*)
Procedure MakeVector2_P( var v : TVector; const av : TAffineVector);
Begin VectorGeometry.MakeVector(v, av); END;

(*----------------------------------------------------------------------------*)
Procedure MakeVector1_P( var v : TVector; const x, y, z : Single);
Begin VectorGeometry.MakeVector(v, x, y, z); END;

(*----------------------------------------------------------------------------*)
Procedure MakeVector_P( var v : TAffineVector; const x, y, z : Single);
Begin VectorGeometry.MakeVector(v, x, y, z); END;

(*----------------------------------------------------------------------------*)
Procedure MakePoint2_P( var v : TVector; const av : TVector);
Begin VectorGeometry.MakePoint(v, av); END;

(*----------------------------------------------------------------------------*)
Procedure MakePoint1_P( var v : TVector; const av : TAffineVector);
Begin VectorGeometry.MakePoint(v, av); END;

(*----------------------------------------------------------------------------*)
Procedure MakePoint_P( var v : TVector; const x, y, z : Single);
Begin VectorGeometry.MakePoint(v, x, y, z); END;

(*----------------------------------------------------------------------------*)
Procedure SetVector2_P( var v : TVector; const vSrc : TVector);
Begin VectorGeometry.SetVector(v, vSrc); END;

(*----------------------------------------------------------------------------*)
Procedure SetVector1_P( var v : TVector; const av : TAffineVector; w : Single);
Begin VectorGeometry.SetVector(v, av, w); END;

(*----------------------------------------------------------------------------*)
Procedure SetVector_P( var v : TVector; const x, y, z : Single; w : Single);
Begin VectorGeometry.SetVector(v, x, y, z, w); END;

(*----------------------------------------------------------------------------*)
Function PointMake2_P( const v : TVector) : TVector;
Begin Result := VectorGeometry.PointMake(v); END;

(*----------------------------------------------------------------------------*)
Function PointMake1_P( const v : TAffineVector) : TVector;
Begin Result := VectorGeometry.PointMake(v); END;

(*----------------------------------------------------------------------------*)
Function PointMake_P( const x, y, z : Single) : TVector;
Begin Result := VectorGeometry.PointMake(x, y, z); END;

(*----------------------------------------------------------------------------*)
Function VectorMake1_P( const x, y, z : Single; w : Single) : TVector;
Begin Result := VectorGeometry.VectorMake(x, y, z, w); END;

(*----------------------------------------------------------------------------*)
Function VectorMake_P( const v : TAffineVector; w : Single) : TVector;
Begin Result := VectorGeometry.VectorMake(v, w); END;

(*----------------------------------------------------------------------------*)
Procedure SetVector4_P( var v : TAffineDblVector; const vSrc : TVector);
Begin VectorGeometry.SetVector(v, vSrc); END;

(*----------------------------------------------------------------------------*)
Procedure SetVector3_P( var v : TAffineDblVector; const vSrc : TAffineVector);
Begin VectorGeometry.SetVector(v, vSrc); END;

(*----------------------------------------------------------------------------*)
Procedure SetVector2( var v : TAffineVector; const vSrc : TAffineVector);
Begin VectorGeometry.SetVector(v, vSrc); END;

(*----------------------------------------------------------------------------*)
Procedure SetVector1( var v : TAffineVector; const vSrc : TVector);
Begin VectorGeometry.SetVector(v, vSrc); END;

(*----------------------------------------------------------------------------*)
Procedure SetVector( var v : TAffineVector; const x, y, z : Single);
Begin VectorGeometry.SetVector(v, x, y, z); END;

(*----------------------------------------------------------------------------*)
Procedure SetAffineVector_P( var v : TAffineVector; const x, y, z : Single);
Begin VectorGeometry.SetAffineVector(v, x, y, z); END;

(*----------------------------------------------------------------------------*)
Function AffineVectorMake1_P( const v : TVector) : TAffineVector;
Begin Result := VectorGeometry.AffineVectorMake(v); END;

(*----------------------------------------------------------------------------*)
Function AffineVectorMake_P( const x, y, z : Single) : TAffineVector;
Begin Result := VectorGeometry.AffineVectorMake(x, y, z); END;

(*----------------------------------------------------------------------------*)
procedure RIRegister_VectorGeometry_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@TexPointMake, 'glTexPointMake', cdRegister);
 S.RegisterDelphiFunction(@AffineVectorMake, 'glAffineVectorMake', cdRegister);
 S.RegisterDelphiFunction(@AffineVectorMake1_P, 'glAffineVectorMake1', cdRegister);
 S.RegisterDelphiFunction(@SetAffineVector, 'glSetAffineVector', cdRegister);
 S.RegisterDelphiFunction(@SetVector, 'glSetVector', cdRegister);
 S.RegisterDelphiFunction(@SetVector1, 'glSetVector1', cdRegister);
 S.RegisterDelphiFunction(@SetVector2, 'glSetVector2', cdRegister);
 S.RegisterDelphiFunction(@SetVector3_P, 'glSetVector3', cdRegister);
 S.RegisterDelphiFunction(@SetVector4_P, 'glSetVector4', cdRegister);
 S.RegisterDelphiFunction(@VectorMake, 'glVectorMake', cdRegister);
 S.RegisterDelphiFunction(@VectorMake1_P, 'glVectorMake1', cdRegister);
 S.RegisterDelphiFunction(@PointMake, 'glPointMake', cdRegister);
 S.RegisterDelphiFunction(@PointMake1_P, 'glPointMake1', cdRegister);
 S.RegisterDelphiFunction(@PointMake2_P, 'glPointMake2', cdRegister);
 S.RegisterDelphiFunction(@SetVector, 'glSetVector5', cdRegister);
 S.RegisterDelphiFunction(@SetVector1_P, 'glSetVector6', cdRegister);
 S.RegisterDelphiFunction(@SetVector2_P, 'glSetVector7', cdRegister);
 S.RegisterDelphiFunction(@MakePoint, 'glMakePoint', cdRegister);
 S.RegisterDelphiFunction(@MakePoint1_P, 'glMakePoint1', cdRegister);
 S.RegisterDelphiFunction(@MakePoint2_P, 'glMakePoint2', cdRegister);
 S.RegisterDelphiFunction(@MakeVector, 'glMakeVector', cdRegister);
 S.RegisterDelphiFunction(@MakeVector1_P, 'glMakeVector1', cdRegister);
 S.RegisterDelphiFunction(@MakeVector2_P, 'glMakeVector2', cdRegister);
 S.RegisterDelphiFunction(@MakeVector3_P, 'glMakeVector3', cdRegister);
 S.RegisterDelphiFunction(@RstVector, 'glRstVector', cdRegister);
 S.RegisterDelphiFunction(@RstVector1_P, 'glRstVector1', cdRegister);
 S.RegisterDelphiFunction(@VectorAdd, 'glVectorAdd', cdRegister);
 S.RegisterDelphiFunction(@VectorAdd1_P, 'glVectorAdd1', cdRegister);
 S.RegisterDelphiFunction(@VectorAdd2_P, 'glVectorAdd2', cdRegister);
 S.RegisterDelphiFunction(@VectorAdd3_P, 'glVectorAdd3', cdRegister);
 S.RegisterDelphiFunction(@VectorAdd4_P, 'glVectorAdd4', cdRegister);
 S.RegisterDelphiFunction(@VectorAdd5_P, 'glVectorAdd5', cdRegister);
 S.RegisterDelphiFunction(@VectorAdd6_P, 'glVectorAdd6', cdRegister);
 S.RegisterDelphiFunction(@AddVector7_P, 'glAddVector7', cdRegister);
 S.RegisterDelphiFunction(@AddVector8_P, 'glAddVector8', cdRegister);
 S.RegisterDelphiFunction(@AddVector9_P, 'glAddVector9', cdRegister);
 S.RegisterDelphiFunction(@AddVector10_P, 'glAddVector10', cdRegister);
 S.RegisterDelphiFunction(@AddVector11_P, 'glAddVector11', cdRegister);
 S.RegisterDelphiFunction(@TexPointArrayAdd, 'glTexPointArrayAdd', cdRegister);
 S.RegisterDelphiFunction(@TexPointArrayScaleAndAdd, 'glTexPointArrayScaleAndAdd', cdRegister);
 S.RegisterDelphiFunction(@VectorArrayAdd, 'glVectorArrayAdd', cdRegister);
 S.RegisterDelphiFunction(@VectorSubtract, 'glVectorSubtract', cdRegister);
 S.RegisterDelphiFunction(@VectorSubtract1_P, 'glVectorSubtract1', cdRegister);
 S.RegisterDelphiFunction(@VectorSubtract2_P, 'glVectorSubtract2', cdRegister);
 S.RegisterDelphiFunction(@VectorSubtract3_P, 'glVectorSubtract3', cdRegister);
 S.RegisterDelphiFunction(@VectorSubtract4_P, 'glVectorSubtract4', cdRegister);
 S.RegisterDelphiFunction(@VectorSubtract5_P, 'glVectorSubtract5', cdRegister);
 S.RegisterDelphiFunction(@VectorSubtract6_P, 'glVectorSubtract6', cdRegister);
 S.RegisterDelphiFunction(@VectorSubtract7_P, 'glVectorSubtract7', cdRegister);
 S.RegisterDelphiFunction(@VectorSubtract8_P, 'glVectorSubtract8', cdRegister);
 S.RegisterDelphiFunction(@SubtractVector9_P, 'glSubtractVector9', cdRegister);
 S.RegisterDelphiFunction(@SubtractVector10_P, 'glSubtractVector10', cdRegister);
 S.RegisterDelphiFunction(@CombineVector, 'glCombineVector', cdRegister);
 S.RegisterDelphiFunction(@CombineVector1_P, 'glCombineVector1', cdRegister);
 S.RegisterDelphiFunction(@TexPointCombine, 'glTexPointCombine', cdRegister);
 S.RegisterDelphiFunction(@VectorCombine2_P, 'glVectorCombine2', cdRegister);
 S.RegisterDelphiFunction(@VectorCombine33_P, 'glVectorCombine33', cdRegister);
 S.RegisterDelphiFunction(@VectorCombine34_P, 'glVectorCombine34', cdRegister);
 S.RegisterDelphiFunction(@CombineVector5_P, 'glCombineVector5', cdRegister);
 S.RegisterDelphiFunction(@CombineVector6_P, 'glCombineVector6', cdRegister);
 S.RegisterDelphiFunction(@VectorCombine7_P, 'glVectorCombine7', cdRegister);
 S.RegisterDelphiFunction(@VectorCombine8_P, 'glVectorCombine8', cdRegister);
 S.RegisterDelphiFunction(@VectorCombine9_P, 'glVectorCombine9', cdRegister);
 S.RegisterDelphiFunction(@VectorCombine10_P, 'glVectorCombine10', cdRegister);
 S.RegisterDelphiFunction(@VectorCombine11_P, 'glVectorCombine11', cdRegister);
 S.RegisterDelphiFunction(@VectorCombine3_P, 'glVectorCombine3', cdRegister);
 S.RegisterDelphiFunction(@VectorCombine31_P, 'glVectorCombine31', cdRegister);
 S.RegisterDelphiFunction(@VectorDotProduct, 'glVectorDotProduct', cdRegister);
 S.RegisterDelphiFunction(@VectorDotProduct1_P, 'glVectorDotProduct1', cdRegister);
 S.RegisterDelphiFunction(@VectorDotProduct2_P, 'glVectorDotProduct2', cdRegister);
 S.RegisterDelphiFunction(@PointProject, 'glPointProject', cdRegister);
 S.RegisterDelphiFunction(@PointProject1_P, 'glPointProject1', cdRegister);
 S.RegisterDelphiFunction(@VectorCrossProduct, 'glVectorCrossProduct', cdRegister);
 S.RegisterDelphiFunction(@VectorCrossProduct1_P, 'glVectorCrossProduct1', cdRegister);
 S.RegisterDelphiFunction(@VectorCrossProduct2_P, 'glVectorCrossProduct2', cdRegister);
 S.RegisterDelphiFunction(@VectorCrossProduct3_P, 'glVectorCrossProduct3', cdRegister);
 S.RegisterDelphiFunction(@VectorCrossProduct4_P, 'glVectorCrossProduct4', cdRegister);
 S.RegisterDelphiFunction(@VectorCrossProduct5_P, 'glVectorCrossProduct5', cdRegister);
 S.RegisterDelphiFunction(@Lerp, 'glLerp', cdRegister);
 S.RegisterDelphiFunction(@AngleLerp, 'glAngleLerp', cdRegister);
 S.RegisterDelphiFunction(@DistanceBetweenAngles, 'glDistanceBetweenAngles', cdRegister);
 S.RegisterDelphiFunction(@TexPointLerp, 'glTexPointLerp', cdRegister);
 S.RegisterDelphiFunction(@VectorLerp, 'glVectorLerp', cdRegister);
 S.RegisterDelphiFunction(@VectorLerp1_P, 'glVectorLerp1', cdRegister);
 S.RegisterDelphiFunction(@VectorLerp2_P, 'glVectorLerp2', cdRegister);
 S.RegisterDelphiFunction(@VectorLerp3_P, 'glVectorLerp3', cdRegister);
 S.RegisterDelphiFunction(@VectorAngleLerp, 'glVectorAngleLerp', cdRegister);
 S.RegisterDelphiFunction(@VectorAngleCombine, 'glVectorAngleCombine', cdRegister);
 S.RegisterDelphiFunction(@VectorArrayLerp, 'glVectorArrayLerp', cdRegister);
 S.RegisterDelphiFunction(@VectorArrayLerp1_P, 'glVectorArrayLerp1', cdRegister);
 S.RegisterDelphiFunction(@VectorLength, 'glVectorLength', cdRegister);
 S.RegisterDelphiFunction(@VectorLength1_P, 'glVectorLength1', cdRegister);
 S.RegisterDelphiFunction(@VectorLength2_P, 'glVectorLength2', cdRegister);
 S.RegisterDelphiFunction(@VectorLength3_P, 'glVectorLength3', cdRegister);
 S.RegisterDelphiFunction(@VectorLength4_P, 'glVectorLength4', cdRegister);
 S.RegisterDelphiFunction(@VectorNorm, 'glVectorNorm', cdRegister);
 S.RegisterDelphiFunction(@VectorNorm1_P, 'glVectorNorm1', cdRegister);
 S.RegisterDelphiFunction(@VectorNorm2_P, 'glVectorNorm2', cdRegister);
 S.RegisterDelphiFunction(@VectorNorm3_P, 'glVectorNorm3', cdRegister);
 S.RegisterDelphiFunction(@NormalizeVector, 'glNormalizeVector', cdRegister);
 S.RegisterDelphiFunction(@NormalizeVector1_P, 'glNormalizeVector1', cdRegister);
 S.RegisterDelphiFunction(@VectorNormalize, 'glVectorNormalize', cdRegister);
 S.RegisterDelphiFunction(@VectorNormalize1_P, 'glVectorNormalize1', cdRegister);
 S.RegisterDelphiFunction(@NormalizeVectorArray, 'glNormalizeVectorArray', cdRegister);
 S.RegisterDelphiFunction(@VectorAngleCosine, 'glVectorAngleCosine', cdRegister);
 S.RegisterDelphiFunction(@VectorNegate, 'glVectorNegate', cdRegister);
 S.RegisterDelphiFunction(@VectorNegate1_P, 'glVectorNegate1', cdRegister);
 S.RegisterDelphiFunction(@NegateVector, 'glNegateVector', cdRegister);
 S.RegisterDelphiFunction(@NegateVector2_P, 'glNegateVector2', cdRegister);
 S.RegisterDelphiFunction(@NegateVector3_P, 'glNegateVector3', cdRegister);
 S.RegisterDelphiFunction(@ScaleVector, 'glScaleVector', cdRegister);
 S.RegisterDelphiFunction(@ScaleVector1_P, 'glScaleVector1', cdRegister);
 S.RegisterDelphiFunction(@ScaleVector2_P, 'glScaleVector2', cdRegister);
 S.RegisterDelphiFunction(@ScaleVector3_P, 'glScaleVector3', cdRegister);
 S.RegisterDelphiFunction(@VectorScale, 'glVectorScale', cdRegister);
 S.RegisterDelphiFunction(@VectorScale1_P, 'glVectorScale1', cdRegister);
 S.RegisterDelphiFunction(@VectorScale2_P, 'glVectorScale2', cdRegister);
 S.RegisterDelphiFunction(@VectorScale3_P, 'glVectorScale3', cdRegister);
 S.RegisterDelphiFunction(@VectorScale4_P, 'glVectorScale4', cdRegister);
 S.RegisterDelphiFunction(@DivideVector, 'glDivideVector', cdRegister);
 S.RegisterDelphiFunction(@VectorEquals, 'glVectorEquals', cdRegister);
 S.RegisterDelphiFunction(@VectorEquals1_P, 'glVectorEquals1', cdRegister);
 S.RegisterDelphiFunction(@AffineVectorEquals, 'glAffineVectorEquals', cdRegister);
 S.RegisterDelphiFunction(@VectorIsNull, 'glVectorIsNull', cdRegister);
 S.RegisterDelphiFunction(@VectorIsNull1_P, 'glVectorIsNull1', cdRegister);
 S.RegisterDelphiFunction(@VectorSpacing, 'glVectorSpacing', cdRegister);
 S.RegisterDelphiFunction(@VectorSpacing1_P, 'glVectorSpacing1', cdRegister);
 S.RegisterDelphiFunction(@VectorSpacing2_P, 'glVectorSpacing2', cdRegister);
 S.RegisterDelphiFunction(@VectorDistance, 'glVectorDistance', cdRegister);
 S.RegisterDelphiFunction(@VectorDistance1_P, 'glVectorDistance1', cdRegister);
 S.RegisterDelphiFunction(@VectorDistance2_P, 'glVectorDistance2', cdRegister);
 S.RegisterDelphiFunction(@VectorDistance21_P, 'glVectorDistance21', cdRegister);
 S.RegisterDelphiFunction(@VectorPerpendicular, 'glVectorPerpendicular', cdRegister);
 S.RegisterDelphiFunction(@VectorReflect, 'glVectorReflect', cdRegister);
 S.RegisterDelphiFunction(@RotateVector, 'glRotateVector', cdRegister);
 S.RegisterDelphiFunction(@RotateVector1_P, 'glRotateVector1', cdRegister);
 S.RegisterDelphiFunction(@RotateVectorAroundY, 'glRotateVectorAroundY', cdRegister);
 S.RegisterDelphiFunction(@VectorRotateAroundX, 'glVectorRotateAroundX', cdRegister);
 S.RegisterDelphiFunction(@VectorRotateAroundY, 'glVectorRotateAroundY', cdRegister);
 S.RegisterDelphiFunction(@VectorRotateAroundY1_P, 'glVectorRotateAroundY1', cdRegister);
 S.RegisterDelphiFunction(@VectorRotateAroundZ, 'glVectorRotateAroundZ', cdRegister);
 S.RegisterDelphiFunction(@AbsVector, 'glAbsVector', cdRegister);
 S.RegisterDelphiFunction(@AbsVector1_P, 'glAbsVector1', cdRegister);
 S.RegisterDelphiFunction(@VectorAbs, 'glVectorAbs', cdRegister);
 S.RegisterDelphiFunction(@VectorAbs1_P, 'glVectorAbs1', cdRegister);
 S.RegisterDelphiFunction(@SetMatrix, 'glSetMatrix', cdRegister);
 S.RegisterDelphiFunction(@SetMatrix1_P, 'glSetMatrix1', cdRegister);
 S.RegisterDelphiFunction(@SetMatrix2_P, 'glSetMatrix2', cdRegister);
 S.RegisterDelphiFunction(@SetMatrixRow, 'glSetMatrixRow', cdRegister);
 S.RegisterDelphiFunction(@CreateScaleMatrix, 'glCreateScaleMatrix', cdRegister);
 S.RegisterDelphiFunction(@CreateScaleMatrix1_P, 'glCreateScaleMatrix1', cdRegister);
 S.RegisterDelphiFunction(@CreateTranslationMatrix, 'glCreateTranslationMatrix', cdRegister);
 S.RegisterDelphiFunction(@CreateTranslationMatrix1_P, 'glCreateTranslationMatrix1', cdRegister);
 S.RegisterDelphiFunction(@CreateScaleAndTranslationMatrix, 'glCreateScaleAndTranslationMatrix', cdRegister);
 S.RegisterDelphiFunction(@CreateRotationMatrixX, 'glCreateRotationMatrixX', cdRegister);
 S.RegisterDelphiFunction(@CreateRotationMatrixX1_P, 'glCreateRotationMatrixX1', cdRegister);
 S.RegisterDelphiFunction(@CreateRotationMatrixY, 'glCreateRotationMatrixY', cdRegister);
 S.RegisterDelphiFunction(@CreateRotationMatrixY1_P, 'glCreateRotationMatrixY1', cdRegister);
 S.RegisterDelphiFunction(@CreateRotationMatrixZ, 'glCreateRotationMatrixZ', cdRegister);
 S.RegisterDelphiFunction(@CreateRotationMatrixZ1_P, 'glCreateRotationMatrixZ1', cdRegister);
 S.RegisterDelphiFunction(@CreateRotationMatrix, 'glCreateRotationMatrix', cdRegister);
 S.RegisterDelphiFunction(@CreateRotationMatrix1_P, 'glCreateRotationMatrix1', cdRegister);
 S.RegisterDelphiFunction(@CreateAffineRotationMatrix, 'glCreateAffineRotationMatrix', cdRegister);
 S.RegisterDelphiFunction(@MatrixMultiply, 'glMatrixMultiply', cdRegister);
 S.RegisterDelphiFunction(@MatrixMultiply1_P, 'glMatrixMultiply1', cdRegister);
 S.RegisterDelphiFunction(@MatrixMultiply2_P, 'glMatrixMultiply2', cdRegister);
 S.RegisterDelphiFunction(@VectorTransform, 'glVectorTransform', cdRegister);
 S.RegisterDelphiFunction(@VectorTransform1_P, 'glVectorTransform1', cdRegister);
 S.RegisterDelphiFunction(@VectorTransform2_P, 'glVectorTransform2', cdRegister);
 S.RegisterDelphiFunction(@VectorTransform3_P, 'glVectorTransform3', cdRegister);
 S.RegisterDelphiFunction(@MatrixDeterminant, 'glMatrixDeterminant', cdRegister);
 S.RegisterDelphiFunction(@MatrixDeterminant1_P, 'glMatrixDeterminant1', cdRegister);
 S.RegisterDelphiFunction(@AdjointMatrix, 'glAdjointMatrix', cdRegister);
 S.RegisterDelphiFunction(@AdjointMatrix1_P, 'glAdjointMatrix1', cdRegister);
 S.RegisterDelphiFunction(@ScaleMatrix, 'glScaleMatrix', cdRegister);
 S.RegisterDelphiFunction(@ScaleMatrix1_P, 'glScaleMatrix1', cdRegister);
 S.RegisterDelphiFunction(@TranslateMatrix, 'glTranslateMatrix', cdRegister);
 S.RegisterDelphiFunction(@TranslateMatrix1_P, 'glTranslateMatrix1', cdRegister);
 S.RegisterDelphiFunction(@NormalizeMatrix, 'glNormalizeMatrix', cdRegister);
 S.RegisterDelphiFunction(@TransposeMatrix, 'glTransposeMatrix', cdRegister);
 S.RegisterDelphiFunction(@TransposeMatrix1_P, 'glTransposeMatrix1', cdRegister);
 S.RegisterDelphiFunction(@InvertMatrix, 'glInvertMatrix', cdRegister);
 S.RegisterDelphiFunction(@InvertMatrix1_P, 'glInvertMatrix1', cdRegister);
 S.RegisterDelphiFunction(@AnglePreservingMatrixInvert, 'glAnglePreservingMatrixInvert', cdRegister);
 S.RegisterDelphiFunction(@MatrixDecompose, 'glMatrixDecompose', cdRegister);
 S.RegisterDelphiFunction(@PlaneMake, 'glPlaneMake', cdRegister);
 S.RegisterDelphiFunction(@PlaneMake1_P, 'glPlaneMake1', cdRegister);
 S.RegisterDelphiFunction(@PlaneMake2_P, 'glPlaneMake2', cdRegister);
 S.RegisterDelphiFunction(@PlaneMake3_P, 'glPlaneMake3', cdRegister);
 S.RegisterDelphiFunction(@SetPlane, 'glSetPlane', cdRegister);
 S.RegisterDelphiFunction(@NormalizePlane, 'glNormalizePlane', cdRegister);
 S.RegisterDelphiFunction(@PlaneEvaluatePoint, 'glPlaneEvaluatePoint', cdRegister);
 S.RegisterDelphiFunction(@PlaneEvaluatePoint1_P, 'glPlaneEvaluatePoint1', cdRegister);
 S.RegisterDelphiFunction(@CalcPlaneNormal, 'glCalcPlaneNormal', cdRegister);
 S.RegisterDelphiFunction(@CalcPlaneNormal1_P, 'glCalcPlaneNormal1', cdRegister);
 S.RegisterDelphiFunction(@CalcPlaneNormal2_P, 'glCalcPlaneNormal2', cdRegister);
 S.RegisterDelphiFunction(@PointIsInHalfSpace, 'glPointIsInHalfSpace', cdRegister);
 S.RegisterDelphiFunction(@PointIsInHalfSpace1_P, 'glPointIsInHalfSpace1', cdRegister);
 S.RegisterDelphiFunction(@PointPlaneDistance, 'glPointPlaneDistance', cdRegister);
 S.RegisterDelphiFunction(@PointPlaneDistance1_P, 'glPointPlaneDistance1', cdRegister);
 S.RegisterDelphiFunction(@PointSegmentClosestPoint, 'glPointSegmentClosestPoint', cdRegister);
 S.RegisterDelphiFunction(@PointSegmentDistance, 'glPointSegmentDistance', cdRegister);
 S.RegisterDelphiFunction(@PointLineClosestPoint, 'glPointLineClosestPoint', cdRegister);
 S.RegisterDelphiFunction(@PointLineDistance, 'glPointLineDistance', cdRegister);
 S.RegisterDelphiFunction(@SegmentSegmentClosestPoint, 'glSegmentSegmentClosestPoint', cdRegister);
 S.RegisterDelphiFunction(@SegmentSegmentDistance, 'glSegmentSegmentDistance', cdRegister);
 S.RegisterDelphiFunction(@QuaternionMake, 'glQuaternionMake', cdRegister);
 S.RegisterDelphiFunction(@QuaternionConjugate, 'glQuaternionConjugate', cdRegister);
 S.RegisterDelphiFunction(@QuaternionMagnitude, 'glQuaternionMagnitude', cdRegister);
 S.RegisterDelphiFunction(@NormalizeQuaternion, 'glNormalizeQuaternion', cdRegister);
 S.RegisterDelphiFunction(@QuaternionFromPoints, 'glQuaternionFromPoints', cdRegister);
 S.RegisterDelphiFunction(@QuaternionToPoints, 'glQuaternionToPoints', cdRegister);
 S.RegisterDelphiFunction(@QuaternionFromMatrix, 'glQuaternionFromMatrix', cdRegister);
 S.RegisterDelphiFunction(@QuaternionToMatrix, 'glQuaternionToMatrix', cdRegister);
 S.RegisterDelphiFunction(@QuaternionToAffineMatrix, 'glQuaternionToAffineMatrix', cdRegister);
 S.RegisterDelphiFunction(@QuaternionFromAngleAxis, 'glQuaternionFromAngleAxis', cdRegister);
 S.RegisterDelphiFunction(@QuaternionFromRollPitchYaw, 'glQuaternionFromRollPitchYaw', cdRegister);
 S.RegisterDelphiFunction(@QuaternionFromEuler, 'glQuaternionFromEuler', cdRegister);
 S.RegisterDelphiFunction(@QuaternionMultiply, 'glQuaternionMultiply', cdRegister);
 S.RegisterDelphiFunction(@QuaternionSlerp, 'glQuaternionSlerp', cdRegister);
 S.RegisterDelphiFunction(@QuaternionSlerp1_P, 'glQuaternionSlerp1', cdRegister);
 S.RegisterDelphiFunction(@LnXP1, 'glLnXP1', cdRegister);
 S.RegisterDelphiFunction(@Log10, 'glLog10', cdRegister);
 S.RegisterDelphiFunction(@Log2, 'glLog2', cdRegister);
 S.RegisterDelphiFunction(@Log21_P, 'glLog21', cdRegister);
 S.RegisterDelphiFunction(@LogN, 'glLogN', cdRegister);
 S.RegisterDelphiFunction(@IntPower, 'glIntPower', cdRegister);
 S.RegisterDelphiFunction(@Power, 'glPower', cdRegister);
 S.RegisterDelphiFunction(@Power1_P, 'glPower1', cdRegister);
 S.RegisterDelphiFunction(@DegToRad, 'glDegToRad', cdRegister);
 S.RegisterDelphiFunction(@DegToRad1_P, 'glDegToRad1', cdRegister);
 S.RegisterDelphiFunction(@RadToDeg, 'glRadToDeg', cdRegister);
 S.RegisterDelphiFunction(@RadToDeg1_P, 'glRadToDeg1', cdRegister);
 S.RegisterDelphiFunction(@NormalizeAngle, 'glNormalizeAngle', cdRegister);
 S.RegisterDelphiFunction(@NormalizeDegAngle, 'glNormalizeDegAngle', cdRegister);
 S.RegisterDelphiFunction(@SinCos, 'glSinCos', cdRegister);
 S.RegisterDelphiFunction(@SinCos1_P1, 'glSinCos11', cdRegister);
 S.RegisterDelphiFunction(@SinCos, 'glSinCos0', cdRegister);
 S.RegisterDelphiFunction(@SinCos1_P, 'glSinCos1', cdRegister);
 S.RegisterDelphiFunction(@SinCos2_P, 'glSinCos2', cdRegister);
 S.RegisterDelphiFunction(@SinCos3_P, 'glSinCos3', cdRegister);
 S.RegisterDelphiFunction(@PrepareSinCosCache, 'glPrepareSinCosCache', cdRegister);
 S.RegisterDelphiFunction(@ArcCos, 'glArcCos', cdRegister);
 S.RegisterDelphiFunction(@ArcCos1_P, 'glArcCos1', cdRegister);
 S.RegisterDelphiFunction(@ArcSin, 'glArcSin', cdRegister);
 S.RegisterDelphiFunction(@ArcSin1_P, 'glArcSin1', cdRegister);
 S.RegisterDelphiFunction(@ArcTan21_P, 'glArcTan21', cdRegister);
 S.RegisterDelphiFunction(@ArcTan21_P, 'glArcTan21', cdRegister);
 S.RegisterDelphiFunction(@FastArcTan2, 'glFastArcTan2', cdRegister);
 S.RegisterDelphiFunction(@Tan, 'glTan', cdRegister);
 S.RegisterDelphiFunction(@Tan1_P, 'glTan1', cdRegister);
 S.RegisterDelphiFunction(@CoTan, 'glCoTan', cdRegister);
 S.RegisterDelphiFunction(@CoTan1_P, 'glCoTan1', cdRegister);
 S.RegisterDelphiFunction(@Sinh, 'glSinh', cdRegister);
 S.RegisterDelphiFunction(@Sinh1_P, 'glSinh1', cdRegister);
 S.RegisterDelphiFunction(@Cosh, 'glCosh', cdRegister);
 S.RegisterDelphiFunction(@Cosh1_P, 'glCosh1', cdRegister);
 S.RegisterDelphiFunction(@RSqrt, 'glRSqrt', cdRegister);
 S.RegisterDelphiFunction(@RLength, 'glRLength', cdRegister);
 S.RegisterDelphiFunction(@ISqrt, 'glISqrt', cdRegister);
 S.RegisterDelphiFunction(@ILength, 'glILength', cdRegister);
 S.RegisterDelphiFunction(@ILength1_P, 'glILength1', cdRegister);
 S.RegisterDelphiFunction(@RegisterBasedExp, 'glRegisterBasedExp', cdRegister);
 S.RegisterDelphiFunction(@RandomPointOnSphere, 'glRandomPointOnSphere', cdRegister);
 S.RegisterDelphiFunction(@RoundInt, 'glRoundInt', cdRegister);
 S.RegisterDelphiFunction(@RoundInt1_P, 'glRoundInt1', cdRegister);
 S.RegisterDelphiFunction(@Trunc, 'glTrunc', cdRegister);
 S.RegisterDelphiFunction(@Trunc64, 'glTrunc64', cdRegister);
 S.RegisterDelphiFunction(@Int, 'glInt', cdRegister);
 S.RegisterDelphiFunction(@Int1_P, 'glInt1', cdRegister);
 S.RegisterDelphiFunction(@Frac, 'glFrac', cdRegister);
 S.RegisterDelphiFunction(@Frac1_P, 'glFrac1', cdRegister);
 S.RegisterDelphiFunction(@Round, 'glRound', cdRegister);
 S.RegisterDelphiFunction(@Round64, 'glRound64', cdRegister);
 S.RegisterDelphiFunction(@Round641_P, 'glRound641', cdRegister);
 S.RegisterDelphiFunction(@Trunc, 'glTrunc', cdRegister);
 S.RegisterDelphiFunction(@Round, 'glRound', cdRegister);
 S.RegisterDelphiFunction(@Frac, 'glFrac', cdRegister);
 S.RegisterDelphiFunction(@Ceil, 'glCeil', cdRegister);
 S.RegisterDelphiFunction(@Ceil64, 'glCeil64', cdRegister);
 S.RegisterDelphiFunction(@Floor, 'glFloor', cdRegister);
 S.RegisterDelphiFunction(@Floor64, 'glFloor64', cdRegister);
 S.RegisterDelphiFunction(@ScaleAndRound, 'glScaleAndRound', cdRegister);
 S.RegisterDelphiFunction(@Sign, 'glSign', cdRegister);
 S.RegisterDelphiFunction(@IsInRange, 'glIsInRange', cdRegister);
 S.RegisterDelphiFunction(@IsInRange1_P, 'glIsInRange1', cdRegister);
 S.RegisterDelphiFunction(@IsInCube, 'glIsInCube', cdRegister);
 S.RegisterDelphiFunction(@IsInCube1_P, 'glIsInCube1', cdRegister);
 S.RegisterDelphiFunction(@MinFloat, 'glMinFloat', cdRegister);
 S.RegisterDelphiFunction(@MinFloat1_P, 'glMinFloat1', cdRegister);
 S.RegisterDelphiFunction(@MinFloat2_P, 'glMinFloat2', cdRegister);
 S.RegisterDelphiFunction(@MinFloat3_P, 'glMinFloat3', cdRegister);
 S.RegisterDelphiFunction(@MinFloat4_P, 'glMinFloat4', cdRegister);
 S.RegisterDelphiFunction(@MinFloat5_P, 'glMinFloat5', cdRegister);
 S.RegisterDelphiFunction(@MinFloat6_P, 'glMinFloat6', cdRegister);
 S.RegisterDelphiFunction(@MinFloat7_P, 'glMinFloat7', cdRegister);
 S.RegisterDelphiFunction(@MinFloat8_P, 'glMinFloat8', cdRegister);
 S.RegisterDelphiFunction(@MinFloat9_P, 'glMinFloat9', cdRegister);
 S.RegisterDelphiFunction(@MaxFloat10_P, 'glMaxFloat10', cdRegister);
 S.RegisterDelphiFunction(@MaxFloat, 'glMaxFloat', cdRegister);
 S.RegisterDelphiFunction(@MaxFloat1_P, 'glMaxFloat1', cdRegister);
 S.RegisterDelphiFunction(@MaxFloat2_P, 'glMaxFloat2', cdRegister);
 S.RegisterDelphiFunction(@MaxFloat3_P, 'glMaxFloat3', cdRegister);
 S.RegisterDelphiFunction(@MaxFloat4_P, 'glMaxFloat4', cdRegister);
 S.RegisterDelphiFunction(@MaxFloat5_P, 'glMaxFloat5', cdRegister);
 S.RegisterDelphiFunction(@MaxFloat6_P, 'glMaxFloat6', cdRegister);
 S.RegisterDelphiFunction(@MaxFloat7_P, 'glMaxFloat7', cdRegister);
 S.RegisterDelphiFunction(@MaxFloat8_P, 'glMaxFloat8', cdRegister);
 S.RegisterDelphiFunction(@MinInteger9_P, 'glMinInteger9', cdRegister);
 S.RegisterDelphiFunction(@MinInteger, 'glMinInteger', cdRegister);
 S.RegisterDelphiFunction(@MaxInteger, 'glMaxInteger', cdRegister);
 S.RegisterDelphiFunction(@MaxInteger1_P, 'glMaxInteger1', cdRegister);
 S.RegisterDelphiFunction(@TriangleArea, 'glTriangleArea', cdRegister);
 S.RegisterDelphiFunction(@PolygonArea, 'glPolygonArea', cdRegister);
 S.RegisterDelphiFunction(@TriangleSignedArea, 'glTriangleSignedArea', cdRegister);
 S.RegisterDelphiFunction(@PolygonSignedArea, 'glPolygonSignedArea', cdRegister);
 S.RegisterDelphiFunction(@ScaleFloatArray, 'glScaleFloatArray', cdRegister);
 S.RegisterDelphiFunction(@ScaleFloatArray, 'glScaleFloatArray', cdRegister);
 S.RegisterDelphiFunction(@OffsetFloatArray, 'glOffsetFloatArray', cdRegister);
 S.RegisterDelphiFunction(@OffsetFloatArray1_P, 'glOffsetFloatArray1', cdRegister);
 S.RegisterDelphiFunction(@OffsetFloatArray2_P, 'glOffsetFloatArray2', cdRegister);
 S.RegisterDelphiFunction(@MaxXYZComponent, 'glMaxXYZComponent', cdRegister);
 S.RegisterDelphiFunction(@MaxXYZComponent1_P, 'glMaxXYZComponent1', cdRegister);
 S.RegisterDelphiFunction(@MinXYZComponent, 'glMinXYZComponent', cdRegister);
 S.RegisterDelphiFunction(@MinXYZComponent1_P, 'glMinXYZComponent1', cdRegister);
 S.RegisterDelphiFunction(@MaxAbsXYZComponent, 'glMaxAbsXYZComponent', cdRegister);
 S.RegisterDelphiFunction(@MinAbsXYZComponent, 'glMinAbsXYZComponent', cdRegister);
 S.RegisterDelphiFunction(@MaxVector, 'glMaxVector', cdRegister);
 S.RegisterDelphiFunction(@MaxVector1_P, 'glMaxVector1', cdRegister);
 S.RegisterDelphiFunction(@MinVector, 'glMinVector', cdRegister);
 S.RegisterDelphiFunction(@MinVector1_P, 'glMinVector1', cdRegister);
 S.RegisterDelphiFunction(@SortArrayAscending, 'glSortArrayAscending', cdRegister);
 S.RegisterDelphiFunction(@ClampValue, 'glClampValue', cdRegister);
 S.RegisterDelphiFunction(@ClampValue1_P, 'glClampValue1', cdRegister);
 S.RegisterDelphiFunction(@GeometryOptimizationMode, 'glGeometryOptimizationMode', cdRegister);
 S.RegisterDelphiFunction(@BeginFPUOnlySection, 'glBeginFPUOnlySection', cdRegister);
 S.RegisterDelphiFunction(@EndFPUOnlySection, 'glEndFPUOnlySection', cdRegister);
 S.RegisterDelphiFunction(@ConvertRotation, 'glConvertRotation', cdRegister);
 S.RegisterDelphiFunction(@MakeAffineDblVector, 'glMakeAffineDblVector', cdRegister);
 S.RegisterDelphiFunction(@MakeDblVector, 'glMakeDblVector', cdRegister);
 S.RegisterDelphiFunction(@VectorAffineDblToFlt, 'glVectorAffineDblToFlt', cdRegister);
 S.RegisterDelphiFunction(@VectorDblToFlt, 'glVectorDblToFlt', cdRegister);
 S.RegisterDelphiFunction(@VectorAffineFltToDbl, 'glVectorAffineFltToDbl', cdRegister);
 S.RegisterDelphiFunction(@VectorFltToDbl, 'glVectorFltToDbl', cdRegister);
 S.RegisterDelphiFunction(@PointInPolygon, 'glPointInPolygon', cdRegister);
 S.RegisterDelphiFunction(@DivMod, 'glDivMod', cdRegister);
 S.RegisterDelphiFunction(@Turn, 'glTurn', cdRegister);
 S.RegisterDelphiFunction(@Turn1_P, 'glTurn1', cdRegister);
 S.RegisterDelphiFunction(@Pitch, 'glPitch', cdRegister);
 S.RegisterDelphiFunction(@Pitch1_P, 'glPitch1', cdRegister);
 S.RegisterDelphiFunction(@Roll, 'glRoll', cdRegister);
 S.RegisterDelphiFunction(@Roll1_P, 'glRoll1', cdRegister);
 S.RegisterDelphiFunction(@IntersectLinePlane, 'glIntersectLinePlane', cdRegister);
 S.RegisterDelphiFunction(@RayCastPlaneIntersect, 'glRayCastPlaneIntersect', cdRegister);
 S.RegisterDelphiFunction(@RayCastPlaneXZIntersect, 'glRayCastPlaneXZIntersect', cdRegister);
 S.RegisterDelphiFunction(@RayCastTriangleIntersect, 'glRayCastTriangleIntersect', cdRegister);
 S.RegisterDelphiFunction(@RayCastMinDistToPoint, 'glRayCastMinDistToPoint', cdRegister);
 S.RegisterDelphiFunction(@RayCastIntersectsSphere, 'glRayCastIntersectsSphere', cdRegister);
 S.RegisterDelphiFunction(@RayCastSphereIntersect, 'glRayCastSphereIntersect', cdRegister);
 S.RegisterDelphiFunction(@SphereVisibleRadius, 'glSphereVisibleRadius', cdRegister);
 S.RegisterDelphiFunction(@ExtractFrustumFromModelViewProjection, 'glExtractFrustumFromModelViewProjection', cdRegister);
 S.RegisterDelphiFunction(@IsVolumeClipped, 'glIsVolumeClipped', cdRegister);
 S.RegisterDelphiFunction(@IsVolumeClipped1_P, 'glIsVolumeClipped1', cdRegister);
 S.RegisterDelphiFunction(@IsVolumeClipped2_P, 'glIsVolumeClipped2', cdRegister);
 S.RegisterDelphiFunction(@IsVolumeClipped3_P, 'glIsVolumeClipped3', cdRegister);
 S.RegisterDelphiFunction(@MakeParallelProjectionMatrix, 'glMakeParallelProjectionMatrix', cdRegister);
 S.RegisterDelphiFunction(@MakeShadowMatrix, 'glMakeShadowMatrix', cdRegister);
 S.RegisterDelphiFunction(@MakeReflectionMatrix, 'glMakeReflectionMatrix', cdRegister);
 S.RegisterDelphiFunction(@PackRotationMatrix, 'glPackRotationMatrix', cdRegister);
 S.RegisterDelphiFunction(@UnPackRotationMatrix, 'glUnPackRotationMatrix', cdRegister);
  S.RegisterDelphiFunction(@BezierCurvePoint, 'BezierCurvePoint', cdRegister);
 S.RegisterDelphiFunction(@BezierSurfacePoint, 'BezierSurfacePoint', cdRegister);
 S.RegisterDelphiFunction(@GenerateBezierCurve, 'GenerateBezierCurve', cdRegister);
 S.RegisterDelphiFunction(@GenerateBezierSurface, 'GenerateBezierSurface', cdRegister);
 S.RegisterDelphiFunction(@BSplinePoint, 'BSplinePoint', cdRegister);
 S.RegisterDelphiFunction(@BSplineSurfacePoint, 'BSplineSurfacePoint', cdRegister);
 S.RegisterDelphiFunction(@GenerateBSpline, 'GenerateBSpline', cdRegister);
 S.RegisterDelphiFunction(@GenerateBSplineSurface, 'GenerateBSplineSurface', cdRegister);
 S.RegisterDelphiFunction(@GenerateKnotVector, 'GenerateKnotVector', cdRegister);

 end;



{ TPSImport_VectorGeometry }
(*----------------------------------------------------------------------------*)
procedure TPSImport_VectorGeometry.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_VectorGeometry(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_VectorGeometry.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  //RIRegister_VectorGeometry(ri);
  RIRegister_VectorGeometry_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
