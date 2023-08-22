unit uPSI_ESBMaths2;
{
   THE MATRIX MAX
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
  TPSImport_ESBMaths2 = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_ESBMaths2(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_ESBMaths2_Routines(S: TPSExec);

procedure Register;

implementation


uses
   ESBMaths
  ,ESBMaths2
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_ESBMaths2]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_ESBMaths2(CL: TPSPascalCompiler);
begin
  //CL.AddTypeS('TDynFloatArray', 'array of Extended');
  CL.AddTypeS('TDynLWordArray', 'array of LongWord');
  CL.AddTypeS('TDynLIntArray', 'array of LongInt');
  CL.AddTypeS('TDynFloatMatrix', 'array of TDynFloatArray');
  CL.AddTypeS('TDynLWordMatrix', 'array of TDynLWordArray');
  CL.AddTypeS('TDynLIntMatrix', 'array of TDynLIntArray');
 CL.AddDelphiFunction('Function SquareAll( const X : TDynFloatArray) : TDynFloatArray');
 CL.AddDelphiFunction('Function InverseAll( const X : TDynFloatArray) : TDynFloatArray');
 CL.AddDelphiFunction('Function LnAll( const X : TDynFloatArray) : TDynFloatArray');
 CL.AddDelphiFunction('Function Log10All( const X : TDynFloatArray) : TDynFloatArray');
 CL.AddDelphiFunction('Function LinearTransform( const X : TDynFloatArray; Offset, Scale : Extended) : TDynFloatArray');
 CL.AddDelphiFunction('Function AddVectors( const X, Y : TDynFloatArray) : TDynFloatArray');
 CL.AddDelphiFunction('Function SubVectors( const X, Y : TDynFloatArray) : TDynFloatArray');
 CL.AddDelphiFunction('Function MultVectors( const X, Y : TDynFloatArray) : TDynFloatArray');
 CL.AddDelphiFunction('Function DotProduct( const X, Y : TDynFloatArray) : Extended');
 CL.AddDelphiFunction('Function MNorm( const X : TDynFloatArray) : Extended');
 CL.AddDelphiFunction('Function MatrixIsRectangular( const X : TDynFloatMatrix) : Boolean');
 CL.AddDelphiFunction('Procedure MatrixDimensions( const X : TDynFloatMatrix; var Rows, Columns : LongWord; var Rectangular : Boolean)');
 CL.AddDelphiFunction('Function MatrixIsSquare( const X : TDynFloatMatrix) : Boolean');
 CL.AddDelphiFunction('Function MatricesSameDimensions( const X, Y : TDynFloatMatrix) : Boolean');
 CL.AddDelphiFunction('Function AddMatrices( const X, Y : TDynFloatMatrix) : TDynFloatMatrix');
 CL.AddDelphiFunction('Procedure AddToMatrix( var X : TDynFloatMatrix; const Y : TDynFloatMatrix)');
 CL.AddDelphiFunction('Function SubtractMatrices( const X, Y : TDynFloatMatrix) : TDynFloatMatrix');
 CL.AddDelphiFunction('Procedure SubtractFromMatrix( var X : TDynFloatMatrix; const Y : TDynFloatMatrix)');
 CL.AddDelphiFunction('Function MultiplyMatrixByConst( const X : TDynFloatMatrix; const K : Extended) : TDynFloatMatrix');
 CL.AddDelphiFunction('Procedure MultiplyMatrixByConst2( var X : TDynFloatMatrix; const K : Extended);');
 CL.AddDelphiFunction('Function MultiplyMatrices( const X, Y : TDynFloatMatrix) : TDynFloatMatrix;');
 CL.AddDelphiFunction('Function TransposeMatrix( const X : TDynFloatMatrix) : TDynFloatMatrix;');
 CL.AddDelphiFunction('Function GrandMean( const X : TDynFloatMatrix; var N : LongWord) : Extended');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
Function TransposeMatrix_P( const X : TDynFloatMatrix) : TDynFloatMatrix;
Begin Result := ESBMaths2.TransposeMatrix(X); END;

(*----------------------------------------------------------------------------*)
Function MultiplyMatrices_P( const X, Y : TDynFloatMatrix) : TDynFloatMatrix;
Begin Result := ESBMaths2.MultiplyMatrices(X, Y); END;

(*----------------------------------------------------------------------------*)
Procedure MultiplyMatrixByConst2_P( var X : TDynFloatMatrix; const K : Extended);
Begin ESBMaths2.MultiplyMatrixByConst2(X, K); END;

(*----------------------------------------------------------------------------*)
procedure RIRegister_ESBMaths2_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@SquareAll, 'SquareAll', cdRegister);
 S.RegisterDelphiFunction(@InverseAll, 'InverseAll', cdRegister);
 S.RegisterDelphiFunction(@LnAll, 'LnAll', cdRegister);
 S.RegisterDelphiFunction(@Log10All, 'Log10All', cdRegister);
 S.RegisterDelphiFunction(@LinearTransform, 'LinearTransform', cdRegister);
 S.RegisterDelphiFunction(@AddVectors, 'AddVectors', cdRegister);
 S.RegisterDelphiFunction(@SubVectors, 'SubVectors', cdRegister);
 S.RegisterDelphiFunction(@MultVectors, 'MultVectors', cdRegister);
 S.RegisterDelphiFunction(@DotProduct, 'DotProduct', cdRegister);
 S.RegisterDelphiFunction(@Norm, 'MNorm', cdRegister);
 S.RegisterDelphiFunction(@MatrixIsRectangular, 'MatrixIsRectangular', cdRegister);
 S.RegisterDelphiFunction(@MatrixDimensions, 'MatrixDimensions', cdRegister);
 S.RegisterDelphiFunction(@MatrixIsSquare, 'MatrixIsSquare', cdRegister);
 S.RegisterDelphiFunction(@MatricesSameDimensions, 'MatricesSameDimensions', cdRegister);
 S.RegisterDelphiFunction(@AddMatrices, 'AddMatrices', cdRegister);
 S.RegisterDelphiFunction(@AddToMatrix, 'AddToMatrix', cdRegister);
 S.RegisterDelphiFunction(@SubtractMatrices, 'SubtractMatrices', cdRegister);
 S.RegisterDelphiFunction(@SubtractFromMatrix, 'SubtractFromMatrix', cdRegister);
 S.RegisterDelphiFunction(@MultiplyMatrixByConst, 'MultiplyMatrixByConst', cdRegister);
 S.RegisterDelphiFunction(@MultiplyMatrixByConst2, 'MultiplyMatrixByConst2', cdRegister);
 S.RegisterDelphiFunction(@MultiplyMatrices, 'MultiplyMatrices', cdRegister);
 S.RegisterDelphiFunction(@TransposeMatrix, 'TransposeMatrix', cdRegister);
 S.RegisterDelphiFunction(@GrandMean, 'GrandMean', cdRegister);
end;

 
 
{ TPSImport_ESBMaths2 }
(*----------------------------------------------------------------------------*)
procedure TPSImport_ESBMaths2.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_ESBMaths2(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_ESBMaths2.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  //RIRegister_ESBMaths2(ri);
  RIRegister_ESBMaths2_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
