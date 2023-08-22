unit uPSI_Geometry;
{
  of OpenGL
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
  TPSImport_Geometry = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_Geometry(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_Geometry_Routines(S: TPSExec);

procedure Register;

implementation


uses
   Geometry
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_Geometry]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_Geometry(CL: TPSPascalCompiler);
begin
  //CL.AddTypeS('PByte', '^Byte // will not work');
  //CL.AddTypeS('PWord', '^Word // will not work');
  //CL.AddTypeS('PInteger', '^Integer // will not work');
  //CL.AddTypeS('PFloat', '^Single // will not work');
  //CL.AddTypeS('PDouble', '^Double // will not work');
  //CL.AddTypeS('PExtended', '^Extended // will not work');
  //CL.AddTypeS('PPointer', '^Pointer // will not work');
  //CL.AddTypeS('PByteVector', '^TByteVector // will not work');
  //CL.AddTypeS('PByteArray', 'PByteVector');
  //CL.AddTypeS('PWordVector', '^TWordVector // will not work');
  //CL.AddTypeS('PWordArray', 'PWordVector');
  //CL.AddTypeS('PIntegerVector', '^TIntegerVector // will not work');
  CL.AddTypeS('THomogeneousByteVector', 'array[0..3] of Byte');
  CL.AddTypeS('THomogeneousWordVector', 'array[0..3] of Word');
  CL.AddTypeS('THomogeneousIntVector', 'array[0..3] of Integer');
   CL.AddTypeS('THomogeneousFltVector', 'array[0..3] of single');
   CL.AddTypeS('THomogeneousDblVector', 'array[0..3] of double');
   CL.AddTypeS('THomogeneousExtVector', 'array[0..3] of extended');
   CL.AddTypeS('TAffineByteVector', 'array[0..2] of Byte');
  CL.AddTypeS('TAffineWordVector', 'array[0..2] of Word');
  CL.AddTypeS('TAffineIntVector', 'array[0..2] of Integer');
   CL.AddTypeS('TAffineFltVector', 'array[0..2] of single');
   CL.AddTypeS('TAffineDblVector', 'array[0..2] of double');
   CL.AddTypeS('TAffineExtVector', 'array[0..2] of extended');

  CL.AddTypeS('THomogeneousByteMatrix', 'array[0..3] of THomogeneousByteVector');
  CL.AddTypeS('THomogeneousWordMatrix', 'array[0..3] of THomogeneousWordVector');
  CL.AddTypeS('THomogeneousIntMatrix', 'array[0..3] of THomogeneousIntVector');
  CL.AddTypeS('THomogeneousFltMatrix', 'array[0..3] of THomogeneousFltVector');
  CL.AddTypeS('THomogeneousDblMatrix', 'array[0..3] of THomogeneousDblVector');
  CL.AddTypeS('THomogeneousExtMatrix', 'array[0..3] of THomogeneousExtVector');

  CL.AddTypeS('TAffineByteMatrix', 'array[0..2] of TAffineByteVector');
  CL.AddTypeS('TAffineWordMatrix', 'array[0..2] of TAffineWordVector');
  CL.AddTypeS('TAffineIntMatrix', 'array[0..2] of TAffineIntVector');
  CL.AddTypeS('TAffineFltMatrix', 'array[0..3] of TAffineFltVector');
  CL.AddTypeS('TAffineDblMatrix', 'array[0..3] of TAffineDblVector');
  CL.AddTypeS('TAffineExtMatrix', 'array[0..3] of TAffineExtVector');

   //THomogeneousByteMatrix = array[0..3] of THomogeneousByteVector;
    //THomogeneousByteVector = array[0..3] of Byte;
    //THomogeneousWordVector = array[0..3] of Word;
      // THomogeneousFltVector = array[0..3] of Single;
     //   TAffineByteVector = array[0..2] of Byte;

  CL.AddTypeS('TVector4b', 'THomogeneousByteVector');
  CL.AddTypeS('TVector4w', 'THomogeneousWordVector');
  //CL.AddTypeS('PHomogeneousIntVector', '^THomogeneousIntVector // will not work');
  CL.AddTypeS('TVector4i', 'THomogeneousIntVector');
  //CL.AddTypeS('PHomogeneousFltVector', '^THomogeneousFltVector // will not work');
  CL.AddTypeS('TVector4f', 'THomogeneousFltVector');
  //CL.AddTypeS('PHomogeneousDblVector', '^THomogeneousDblVector // will not work');
  CL.AddTypeS('TVector4d', 'THomogeneousDblVector');
  //CL.AddTypeS('PHomogeneousExtVector', '^THomogeneousExtVector // will not work');
  CL.AddTypeS('TVector4e', 'THomogeneousExtVector');
  //CL.AddTypeS('PHomogeneousPtrVector', '^THomogeneousPtrVector // will not work');
  //CL.AddTypeS('TVector4p', 'THomogeneousPtrVector');
  //CL.AddTypeS('PAffineByteVector', '^TAffineByteVector // will not work');
  CL.AddTypeS('TVector3b', 'TAffineByteVector');
  //CL.AddTypeS('PAffineWordVector', '^TAffineWordVector // will not work');
  CL.AddTypeS('TVector3w', 'TAffineWordVector');
  //CL.AddTypeS('PAffineIntVector', '^TAffineIntVector // will not work');
  CL.AddTypeS('TVector3i', 'TAffineIntVector');
  //CL.AddTypeS('PAffineFltVector', '^TAffineFltVector // will not work');
  CL.AddTypeS('TVector3f', 'TAffineFltVector');
  //CL.AddTypeS('PAffineDblVector', '^TAffineDblVector // will not work');
  CL.AddTypeS('TVector3d', 'TAffineDblVector');
  //CL.AddTypeS('PAffineExtVector', '^TAffineExtVector // will not work');
  CL.AddTypeS('TVector3e', 'TAffineExtVector');
  //CL.AddTypeS('PAffinePtrVector', '^TAffinePtrVector // will not work');
  //CL.AddTypeS('TVector3p', 'TAffinePtrVector');
  //CL.AddTypeS('PVector', '^TVector // will not work');
  CL.AddTypeS('TVectorGL', 'THomogeneousFltVector');
  //CL.AddTypeS('PHomogeneousVector', '^THomogeneousVector // will not work');
  CL.AddTypeS('THomogeneousVector', 'THomogeneousFltVector');
  //CL.AddTypeS('PAffineVector', '^TAffineVector // will not work');
  CL.AddTypeS('TAffineVector', 'TAffineFltVector');
  //CL.AddTypeS('PVectorArray', '^TVectorArray // will not work');
  CL.AddTypeS('TMatrix4b', 'THomogeneousByteMatrix');
  CL.AddTypeS('TMatrix4w', 'THomogeneousWordMatrix');
  CL.AddTypeS('TMatrix4i', 'THomogeneousIntMatrix');
  CL.AddTypeS('TMatrix4f', 'THomogeneousFltMatrix');
  CL.AddTypeS('TMatrix4d', 'THomogeneousDblMatrix');
  CL.AddTypeS('TMatrix4e', 'THomogeneousExtMatrix');
  CL.AddTypeS('TMatrix3b', 'TAffineByteMatrix');
  CL.AddTypeS('TMatrix3w', 'TAffineWordMatrix');
  CL.AddTypeS('TMatrix3i', 'TAffineIntMatrix');
  CL.AddTypeS('TMatrix3f', 'TAffineFltMatrix');
  CL.AddTypeS('TMatrix3d', 'TAffineDblMatrix');
  CL.AddTypeS('TMatrix3e', 'TAffineExtMatrix');
  //CL.AddTypeS('PMatrix', '^TMatrix // will not work');
  CL.AddTypeS('TMatrixGL', 'THomogeneousFltMatrix');
  //CL.AddTypeS('PHomogeneousMatrix', '^THomogeneousMatrix // will not work');
  CL.AddTypeS('THomogeneousMatrix', 'THomogeneousFltMatrix');
  //CL.AddTypeS('PAffineMatrix', '^TAffineMatrix // will not work');
  CL.AddTypeS('TAffineMatrix', 'TAffineFltMatrix');
  CL.AddTypeS('TQuaternion', 'record Vector : TVector4f; end');
  CL.AddTypeS('TRectangle', 'record Left : integer; Top : integer; Width : inte'
   +'ger; Height : Integer; end');
  CL.AddTypeS('TTransType', '( ttScaleX, ttScaleY, ttScaleZ, ttShearXY, ttShear'
   +'XZ, ttShearYZ, ttRotateX, ttRotateY, ttRotateZ, ttTranslateX, ttTranslateY'
   +', ttTranslateZ, ttPerspectiveX, ttPerspectiveY, ttPerspectiveZ, ttPerspectiveW )');
 CL.AddConstantN('EPSILON','Extended').setExtended( 1E-100);
 CL.AddConstantN('EPSILON2','Extended').setExtended( 1E-50);
 CL.AddDelphiFunction('Function VectorAddGL( V1, V2 : TVectorGL) : TVectorGL');
 CL.AddDelphiFunction('Function VectorAffineAdd( V1, V2 : TAffineVector) : TAffineVector');
 CL.AddDelphiFunction('Function VectorAffineCombine( V1, V2 : TAffineVector; F1, F2 : Single) : TAffineVector');
 CL.AddDelphiFunction('Function VectorAffineDotProduct( V1, V2 : TAffineVector) : Single');
 CL.AddDelphiFunction('Function VectorAffineLerp( V1, V2 : TAffineVector; t : Single) : TAffineVector');
 CL.AddDelphiFunction('Function VectorAffineSubtract( V1, V2 : TAffineVector) : TAffineVector');
 CL.AddDelphiFunction('Function VectorAngle( V1, V2 : TAffineVector) : Single');
 CL.AddDelphiFunction('Function VectorCombine( V1, V2 : TVector; F1, F2 : Single) : TVectorGL');
 CL.AddDelphiFunction('Function VectorCrossProduct( V1, V2 : TAffineVector) : TAffineVector');
 CL.AddDelphiFunction('Function VectorDotProduct( V1, V2 : TVectorGL) : Single');
 CL.AddDelphiFunction('Function VectorLength( V : array of Single) : Single');
 CL.AddDelphiFunction('Function VectorLerp( V1, V2 : TVectorGL; t : Single) : TVectorGL');
 CL.AddDelphiFunction('Procedure VectorNegate( V : array of Single)');
 CL.AddDelphiFunction('Function VectorNorm( V : array of Single) : Single');
 CL.AddDelphiFunction('Function VectorNormalize( V : array of Single) : Single');
 CL.AddDelphiFunction('Function VectorPerpendicular( V, N : TAffineVector) : TAffineVector');
 CL.AddDelphiFunction('Function VectorReflect( V, N : TAffineVector) : TAffineVector');
 CL.AddDelphiFunction('Procedure VectorRotate( var Vector : TVector4f; Axis : TVector3f; Angle : Single)');
 CL.AddDelphiFunction('Procedure VectorScale( V : array of Single; Factor : Single)');
 CL.AddDelphiFunction('Function VectorSubtractGL( V1, V2 : TVectorGL) : TVectorGL');
 CL.AddDelphiFunction('Function CreateRotationMatrixX( Sine, Cosine : Single) : TMatrixGL');
 CL.AddDelphiFunction('Function CreateRotationMatrixY( Sine, Cosine : Single) : TMatrixGL');
 CL.AddDelphiFunction('Function CreateRotationMatrixZ( Sine, Cosine : Single) : TMatrixGL');
 CL.AddDelphiFunction('Function CreateScaleMatrix( V : TAffineVector) : TMatrixGL');
 CL.AddDelphiFunction('Function CreateTranslationMatrix( V : TVectorGL) : TMatrixGL');
 CL.AddDelphiFunction('Procedure MatrixAdjoint( var M : TMatrixGL)');
 CL.AddDelphiFunction('Function MatrixAffineDeterminant( M : TAffineMatrix) : Single');
 CL.AddDelphiFunction('Procedure MatrixAffineTranspose( var M : TAffineMatrix)');
 CL.AddDelphiFunction('Function MatrixDeterminant( M : TMatrixGL) : Single');
 CL.AddDelphiFunction('Procedure MatrixInvert( var M : TMatrixGL)');
 CL.AddDelphiFunction('Function MatrixMultiply( M1, M2 : TMatrixGL) : TMatrixGL');
 CL.AddDelphiFunction('Procedure MatrixScale( var M : TMatrixGL; Factor : Single)');
 CL.AddDelphiFunction('Procedure MatrixTranspose( var M : TMatrixGL)');
 CL.AddDelphiFunction('Function QuaternionConjugate( Q : TQuaternion) : TQuaternion');
 CL.AddDelphiFunction('Function QuaternionFromPoints( V1, V2 : TAffineVector) : TQuaternion');
 CL.AddDelphiFunction('Function QuaternionMultiply( qL, qR : TQuaternion) : TQuaternion');
 CL.AddDelphiFunction('Function QuaternionSlerp( QStart, QEnd : TQuaternion; Spin : Integer; t : Single) : TQuaternion');
 CL.AddDelphiFunction('Function QuaternionToMatrix( Q : TQuaternion) : TMatrixGL');
 CL.AddDelphiFunction('Procedure QuaternionToPoints( Q : TQuaternion; var ArcFrom, ArcTo : TAffineVector)');
 CL.AddDelphiFunction('Function ConvertRotation( Angles : TAffineVector) : TVectorGL');
 CL.AddDelphiFunction('Function CreateRotationMatrix( Axis : TVector3f; Angle : Single) : TMatrixGL');
 //CL.AddDelphiFunction('Function MatrixDecompose( M : TMatrixGL; var Tran : TTransformations) : Boolean');
 CL.AddDelphiFunction('Function VectorAffineTransform( V : TAffineVector; M : TAffineMatrix) : TAffineVector');
 CL.AddDelphiFunction('Function VectorTransform( V : TVector4f; M : TMatrixGL) : TVector4f;');
 CL.AddDelphiFunction('Function VectorTransform1( V : TVector3f; M : TMatrixGL) : TVector3f;');
 CL.AddDelphiFunction('Function MakeAffineDblVector( V : array of Double) : TAffineDblVector');
 CL.AddDelphiFunction('Function MakeDblVector( V : array of Double) : THomogeneousDblVector');
 CL.AddDelphiFunction('Function MakeAffineVector( V : array of Single) : TAffineVector');
 CL.AddDelphiFunction('Function MakeQuaternion( Imag : array of Single; Real : Single) : TQuaternion');
 CL.AddDelphiFunction('Function MakeVector( V : array of Single) : TVectorGL');
 CL.AddDelphiFunction('Function PointInPolygonGL( xp, yp : array of Single; x, y : Single) : Boolean');
 CL.AddDelphiFunction('Function VectorAffineDblToFlt( V : TAffineDblVector) : TAffineVector');
 CL.AddDelphiFunction('Function VectorDblToFlt( V : THomogeneousDblVector) : THomogeneousVector');
 CL.AddDelphiFunction('Function VectorAffineFltToDbl( V : TAffineVector) : TAffineDblVector');
 CL.AddDelphiFunction('Function VectorFltToDbl( V : TVectorGL) : THomogeneousDblVector');
 CL.AddDelphiFunction('Function ArcCosGL( X : Extended) : Extended');
 CL.AddDelphiFunction('Function ArcSinGL( X : Extended) : Extended');
 CL.AddDelphiFunction('Function ArcTan2GL( Y, X : Extended) : Extended');
 CL.AddDelphiFunction('Function CoTanGL( X : Extended) : Extended');
 CL.AddDelphiFunction('Function DegToRadGL( Degrees : Extended) : Extended');
 CL.AddDelphiFunction('Function RadToDegGL( Radians : Extended) : Extended');
 CL.AddDelphiFunction('Procedure SinCosGL( Theta : Extended; var Sin, Cos : Extended)');
 CL.AddDelphiFunction('Function TanGL( X : Extended) : Extended');
 CL.AddDelphiFunction('Function Turn( Matrix : TMatrixGL; Angle : Single) : TMatrixGL;');
 CL.AddDelphiFunction('Function Turn1( Matrix : TMatrixGL; MasterUp : TAffineVector; Angle : Single) : TMatrixGL;');
 CL.AddDelphiFunction('Function Pitch( Matrix : TMatrixGL; Angle : Single) : TMatrixGL;');
 CL.AddDelphiFunction('Function Pitch1( Matrix : TMatrixGL; MasterRight : TAffineVector; Angle : Single) : TMatrixGL;');
 CL.AddDelphiFunction('Function Roll( Matrix : TMatrixGL; Angle : Single) : TMatrixGL;');
 CL.AddDelphiFunction('Function Roll1( Matrix : TMatrixGL; MasterDirection : TAffineVector; Angle : Single) : TMatrixGL;');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
Function Roll1_P( Matrix : TMatrixGL; MasterDirection : TAffineVector; Angle : Single) : TMatrixGL;
Begin Result := Geometry.Roll(Matrix, MasterDirection, Angle); END;

(*----------------------------------------------------------------------------*)
Function Roll_P( Matrix : TMatrixGL; Angle : Single) : TMatrixGL;
Begin Result := Geometry.Roll(Matrix, Angle); END;

(*----------------------------------------------------------------------------*)
Function Pitch1_P( Matrix : TMatrixGL; MasterRight : TAffineVector; Angle : Single) : TMatrixGL;
Begin Result := Geometry.Pitch(Matrix, MasterRight, Angle); END;

(*----------------------------------------------------------------------------*)
Function Pitch_P( Matrix : TMatrixGL; Angle : Single) : TMatrixGL;
Begin Result := Geometry.Pitch(Matrix, Angle); END;

(*----------------------------------------------------------------------------*)
Function Turn1_P( Matrix : TMatrixGL; MasterUp : TAffineVector; Angle : Single) : TMatrixGL;
Begin Result := Geometry.Turn(Matrix, MasterUp, Angle); END;

(*----------------------------------------------------------------------------*)
Function Turn_P( Matrix : TMatrixGL; Angle : Single) : TMatrixGL;
Begin Result := Geometry.Turn(Matrix, Angle); END;

(*----------------------------------------------------------------------------*)
Function VectorTransform1_P( V : TVector3f; M : TMatrixGL) : TVector3f;
Begin Result := Geometry.VectorTransform(V, M); END;

(*----------------------------------------------------------------------------*)
Function VectorTransform_P( V : TVector4f; M : TMatrixGL) : TVector4f;
Begin Result := Geometry.VectorTransform(V, M); END;

(*----------------------------------------------------------------------------*)
procedure RIRegister_Geometry_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@VectorAdd, 'VectorAddGL', cdRegister);
 S.RegisterDelphiFunction(@VectorAffineAdd, 'VectorAffineAdd', cdRegister);
 S.RegisterDelphiFunction(@VectorAffineCombine, 'VectorAffineCombine', cdRegister);
 S.RegisterDelphiFunction(@VectorAffineDotProduct, 'VectorAffineDotProduct', cdRegister);
 S.RegisterDelphiFunction(@VectorAffineLerp, 'VectorAffineLerp', cdRegister);
 S.RegisterDelphiFunction(@VectorAffineSubtract, 'VectorAffineSubtract', cdRegister);
 S.RegisterDelphiFunction(@VectorAngle, 'VectorAngle', cdRegister);
 S.RegisterDelphiFunction(@VectorCombine, 'VectorCombine', cdRegister);
 S.RegisterDelphiFunction(@VectorCrossProduct, 'VectorCrossProduct', cdRegister);
 S.RegisterDelphiFunction(@VectorDotProduct, 'VectorDotProduct', cdRegister);
 S.RegisterDelphiFunction(@VectorLength, 'VectorLength', cdRegister);
 S.RegisterDelphiFunction(@VectorLerp, 'VectorLerp', cdRegister);
 S.RegisterDelphiFunction(@VectorNegate, 'VectorNegate', cdRegister);
 S.RegisterDelphiFunction(@VectorNorm, 'VectorNorm', cdRegister);
 S.RegisterDelphiFunction(@VectorNormalize, 'VectorNormalize', cdRegister);
 S.RegisterDelphiFunction(@VectorPerpendicular, 'VectorPerpendicular', cdRegister);
 S.RegisterDelphiFunction(@VectorReflect, 'VectorReflect', cdRegister);
 S.RegisterDelphiFunction(@VectorRotate, 'VectorRotate', cdRegister);
 S.RegisterDelphiFunction(@VectorScale, 'VectorScale', cdRegister);
 S.RegisterDelphiFunction(@VectorSubtract, 'VectorSubtractGL', cdRegister);
 S.RegisterDelphiFunction(@CreateRotationMatrixX, 'CreateRotationMatrixX', cdRegister);
 S.RegisterDelphiFunction(@CreateRotationMatrixY, 'CreateRotationMatrixY', cdRegister);
 S.RegisterDelphiFunction(@CreateRotationMatrixZ, 'CreateRotationMatrixZ', cdRegister);
 S.RegisterDelphiFunction(@CreateScaleMatrix, 'CreateScaleMatrix', cdRegister);
 S.RegisterDelphiFunction(@CreateTranslationMatrix, 'CreateTranslationMatrix', cdRegister);
 S.RegisterDelphiFunction(@MatrixAdjoint, 'MatrixAdjoint', cdRegister);
 S.RegisterDelphiFunction(@MatrixAffineDeterminant, 'MatrixAffineDeterminant', cdRegister);
 S.RegisterDelphiFunction(@MatrixAffineTranspose, 'MatrixAffineTranspose', cdRegister);
 S.RegisterDelphiFunction(@MatrixDeterminant, 'MatrixDeterminant', cdRegister);
 S.RegisterDelphiFunction(@MatrixInvert, 'MatrixInvert', cdRegister);
 S.RegisterDelphiFunction(@MatrixMultiply, 'MatrixMultiply', cdRegister);
 S.RegisterDelphiFunction(@MatrixScale, 'MatrixScale', cdRegister);
 S.RegisterDelphiFunction(@MatrixTranspose, 'MatrixTranspose', cdRegister);
 S.RegisterDelphiFunction(@QuaternionConjugate, 'QuaternionConjugate', cdRegister);
 S.RegisterDelphiFunction(@QuaternionFromPoints, 'QuaternionFromPoints', cdRegister);
 S.RegisterDelphiFunction(@QuaternionMultiply, 'QuaternionMultiply', cdRegister);
 S.RegisterDelphiFunction(@QuaternionSlerp, 'QuaternionSlerp', cdRegister);
 S.RegisterDelphiFunction(@QuaternionToMatrix, 'QuaternionToMatrix', cdRegister);
 S.RegisterDelphiFunction(@QuaternionToPoints, 'QuaternionToPoints', cdRegister);
 S.RegisterDelphiFunction(@ConvertRotation, 'ConvertRotation', cdRegister);
 S.RegisterDelphiFunction(@CreateRotationMatrix, 'CreateRotationMatrix', cdRegister);
 S.RegisterDelphiFunction(@MatrixDecompose, 'MatrixDecompose', cdRegister);
 S.RegisterDelphiFunction(@VectorAffineTransform, 'VectorAffineTransform', cdRegister);
 S.RegisterDelphiFunction(@VectorTransform, 'VectorTransform', cdRegister);
 S.RegisterDelphiFunction(@VectorTransform1_P, 'VectorTransform1', cdRegister);
 S.RegisterDelphiFunction(@MakeAffineDblVector, 'MakeAffineDblVector', cdRegister);
 S.RegisterDelphiFunction(@MakeDblVector, 'MakeDblVector', cdRegister);
 S.RegisterDelphiFunction(@MakeAffineVector, 'MakeAffineVector', cdRegister);
 S.RegisterDelphiFunction(@MakeQuaternion, 'MakeQuaternion', cdRegister);
 S.RegisterDelphiFunction(@MakeVector, 'MakeVector', cdRegister);
 S.RegisterDelphiFunction(@PointInPolygon, 'PointInPolygonGL', cdRegister);
 S.RegisterDelphiFunction(@VectorAffineDblToFlt, 'VectorAffineDblToFlt', cdRegister);
 S.RegisterDelphiFunction(@VectorDblToFlt, 'VectorDblToFlt', cdRegister);
 S.RegisterDelphiFunction(@VectorAffineFltToDbl, 'VectorAffineFltToDbl', cdRegister);
 S.RegisterDelphiFunction(@VectorFltToDbl, 'VectorFltToDbl', cdRegister);
 S.RegisterDelphiFunction(@ArcCos, 'ArcCosGL', cdRegister);
 S.RegisterDelphiFunction(@ArcSin, 'ArcSinGL', cdRegister);
 S.RegisterDelphiFunction(@ArcTan2, 'ArcTan2GL', cdRegister);
 S.RegisterDelphiFunction(@CoTan, 'CoTanGL', cdRegister);
 S.RegisterDelphiFunction(@DegToRad, 'DegToRadGL', cdRegister);
 S.RegisterDelphiFunction(@RadToDeg, 'RadToDegGL', cdRegister);
 S.RegisterDelphiFunction(@SinCos, 'SinCosGL', cdRegister);
 S.RegisterDelphiFunction(@Tan, 'TanGL', cdRegister);
 S.RegisterDelphiFunction(@Turn, 'Turn', cdRegister);
 S.RegisterDelphiFunction(@Turn1_P, 'Turn1', cdRegister);
 S.RegisterDelphiFunction(@Pitch, 'Pitch', cdRegister);
 S.RegisterDelphiFunction(@Pitch1_P, 'Pitch1', cdRegister);
 S.RegisterDelphiFunction(@Roll, 'Roll', cdRegister);
 S.RegisterDelphiFunction(@Roll1_P, 'Roll1', cdRegister);
end;

 
 
{ TPSImport_Geometry }
(*----------------------------------------------------------------------------*)
procedure TPSImport_Geometry.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_Geometry(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_Geometry.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  //RIRegister_Geometry(ri);
  RIRegister_Geometry_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
