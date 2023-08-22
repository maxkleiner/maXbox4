unit uPSI_GraphicsMathLibrary;
{
chekc types of tvector and tmareix      gml prefix

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
  TPSImport_GraphicsMathLibrary = class(TPSPlugin)
  public
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_GraphicsMathLibrary(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_GraphicsMathLibrary_Routines(S: TPSExec);
procedure RIRegister_GraphicsMathLibrary(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   GraphicsMathLibrary
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_GraphicsMathLibrary]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_GraphicsMathLibrary(CL: TPSPascalCompiler);
begin
 CL.AddConstantN('gmlsizeUndefined','LongInt').SetInt( 1);
 CL.AddConstantN('gmlsize2D','LongInt').SetInt( 3);
 CL.AddConstantN('gmlsize3D','LongInt').SetInt( 4);
  CL.AddClassN(CL.FindClass('TOBJECT'),'EVectorError');
  CL.AddClassN(CL.FindClass('TOBJECT'),'EMatrixError');
  CL.AddTypeS('gmlTAxis', '( axisX, axisY, axisZ )');
  CL.AddTypeS('gmlTCoordinate', '( coordCartesian, coordSpherical, coordCylindrical )');
  CL.AddTypeS('gmlTDimension', '( dimen2D, dimen3D )');
  CL.AddTypeS('gmlTIndex', 'Integer');
  CL.AddTypeS('gmlTrotation', '( rotateClockwise, rotateCounterClockwise )');
   CL.AddTypeS('gmlTVector', 'record size: gmlTIndex; vector: ARRAY[1..4] OF DOUBLE; x: double; y: double; z:double; h:double; end;');
  CL.AddTypeS('gmlTMatrix', 'record size: gmlTIndex; matrix: ARRAY[1..4] of Array[1..4] OF DOUBLE; end;');

 CL.AddDelphiFunction('Function gmlVector2D( const xValue, yValue : DOUBLE) : gmlTVector');
 CL.AddDelphiFunction('Function gmlVector3D( const xValue, yValue, zValue : DOUBLE) : gmlTVector');
 CL.AddDelphiFunction('Function gmlAddVectors( const u, v : gmlTVector) : gmlTVector');
 CL.AddDelphiFunction('Function gmlTransform( const u : gmlTVector; const a : gmlTMatrix) : gmlTVector');
 CL.AddDelphiFunction('Function gmlDotProduct( const u, v : gmlTVector) : DOUBLE');
 CL.AddDelphiFunction('Function gmlCrossProduct( const u, v : gmlTVector) : gmlTVector');
 CL.AddDelphiFunction('Function gmlMatrix2D( const m11, m12, m13, m21, m22, m23, m31, m32, m33 : DOUBLE) : gmlTMatrix');
 CL.AddDelphiFunction('Function gmlMatrix3D( const m11, m12, m13, m14, m21, m22, m23, m24, m31, m32, m33, m34, m41, m42, m43, m44 : DOUBLE) : gmlTMatrix');
 CL.AddDelphiFunction('Function gmlMultiplyMatrices( const a, b : gmlTMatrix) : gmlTMatrix');
 CL.AddDelphiFunction('Function gmlInvertMatrix( const a, b : gmlTMatrix; var determinant : DOUBLE) : gmlTMatrix');
 CL.AddDelphiFunction('Function gmlRotateMatrix( const dimension : gmlTDimension; const xyz : gmlTAxis; const angle : DOUBLE; const rotation : gmlTrotation) : gmlTMatrix');
 CL.AddDelphiFunction('Function gmlScaleMatrix( const s : gmlTVector) : gmlTMatrix');
 CL.AddDelphiFunction('Function gmlTranslateMatrix( const t : gmlTVector) : gmlTMatrix');
 CL.AddDelphiFunction('Function gmlViewTransformMatrix( const coordinate : gmlTCoordinate; const azimuth, elevation, distance : DOUBLE; const ScreenX, ScreenY, ScreenDistance : DOUBLE) : gmlTMatrix');
 CL.AddDelphiFunction('Function gmlFromCartesian( const ToCoordinate : gmlTCoordinate; const u : gmlTVector) : gmlTVector');
 CL.AddDelphiFunction('Function gmlToCartesian( const FromCoordinate : gmlTCoordinate; const u : gmlTVector) : gmlTVector');
 CL.AddDelphiFunction('Function gmlToDegrees( const angle : DOUBLE) : DOUBLE');
 CL.AddDelphiFunction('Function gmlToRadians( const angle : DOUBLE) : DOUBLE');
 CL.AddDelphiFunction('Function gmlDefuzz( const x : DOUBLE) : DOUBLE');
 CL.AddDelphiFunction('Function gmlGetFuzz : DOUBLE');
 CL.AddDelphiFunction('Procedure gmlSetFuzz( const x : DOUBLE)');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure RIRegister_GraphicsMathLibrary_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@Vector2D, 'gmlVector2D', cdRegister);
 S.RegisterDelphiFunction(@Vector3D, 'gmlVector3D', cdRegister);
 S.RegisterDelphiFunction(@AddVectors, 'gmlAddVectors', cdRegister);
 S.RegisterDelphiFunction(@Transform, 'gmlTransform', cdRegister);
 S.RegisterDelphiFunction(@DotProduct, 'gmlDotProduct', cdRegister);
 S.RegisterDelphiFunction(@CrossProduct, 'gmlCrossProduct', cdRegister);
 S.RegisterDelphiFunction(@Matrix2D, 'gmlMatrix2D', cdRegister);
 S.RegisterDelphiFunction(@Matrix3D, 'gmlMatrix3D', cdRegister);
 S.RegisterDelphiFunction(@MultiplyMatrices, 'gmlMultiplyMatrices', cdRegister);
 S.RegisterDelphiFunction(@InvertMatrix, 'gmlInvertMatrix', cdRegister);
 S.RegisterDelphiFunction(@RotateMatrix, 'gmlRotateMatrix', cdRegister);
 S.RegisterDelphiFunction(@ScaleMatrix, 'gmlScaleMatrix', cdRegister);
 S.RegisterDelphiFunction(@TranslateMatrix, 'gmlTranslateMatrix', cdRegister);
 S.RegisterDelphiFunction(@ViewTransformMatrix, 'gmlViewTransformMatrix', cdRegister);
 S.RegisterDelphiFunction(@FromCartesian, 'gmlFromCartesian', cdRegister);
 S.RegisterDelphiFunction(@ToCartesian, 'gmlToCartesian', cdRegister);
 S.RegisterDelphiFunction(@ToDegrees, 'gmlToDegrees', cdRegister);
 S.RegisterDelphiFunction(@ToRadians, 'gmlToRadians', cdRegister);
 S.RegisterDelphiFunction(@Defuzz, 'gmlDefuzz', cdRegister);
 S.RegisterDelphiFunction(@GetFuzz, 'gmlGetFuzz', cdRegister);
 S.RegisterDelphiFunction(@SetFuzz, 'gmlSetFuzz', cdRegister);
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_GraphicsMathLibrary(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(EVectorError) do
  with CL.Add(EMatrixError) do
end;

 
 
{ TPSImport_GraphicsMathLibrary }
(*----------------------------------------------------------------------------*)
procedure TPSImport_GraphicsMathLibrary.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_GraphicsMathLibrary(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_GraphicsMathLibrary.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_GraphicsMathLibrary(ri);
  RIRegister_GraphicsMathLibrary_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
