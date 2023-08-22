unit uPSI_flcMatrix;
{
Tmy matrixy       now with the extended vectorclass

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
  TPSImport_flcMatrix = class(TPSPlugin)
  public
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TMatrixClass(CL: TPSPascalCompiler);
procedure SIRegister_flcMatrix(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_flcMatrix_Routines(S: TPSExec);
procedure RIRegister_TMatrixClass(CL: TPSRuntimeClassImporter);
procedure RIRegister_flcMatrix(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
  // flcUtils
  flcMaths,
  flcVectors
  ,flcMatrix
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_flcMatrix]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TMatrixClass(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOBJECT', 'TMatrixClass') do
  with CL.AddClassN(CL.FindClass('TOBJECT'),'TMatrixClass') do begin
    RegisterMethod('Constructor CreateSize( const RowCount, ColCount : Integer)');
    RegisterMethod('Constructor CreateSquare( const N : Integer; const Identity : Boolean)');
    RegisterMethod('Constructor CreateDiagonal( const D : TVectorClass)');
    RegisterProperty('ColCount', 'Integer', iptrw);
    RegisterProperty('RowCount', 'Integer', iptrw);
    RegisterMethod('Procedure SetSize( const RowCount, ColCount : Integer)');
    RegisterMethod('Procedure Clear');
    RegisterProperty('Item', 'MFloat Integer Integer', iptrw);
    SetDefaultPropery('Item');
    RegisterMethod('Procedure AssignZero');
    RegisterMethod('Procedure AssignIdentity');
    RegisterMethod('Procedure Assign( const Value : MFloat);');
    RegisterMethod('Procedure Assign1( const M : TMatrixClass);');
    RegisterMethod('Procedure Assign2( const V : TVectorClass);');
    RegisterMethod('Function Duplicate : TMatrixClass;');
    RegisterMethod('Function DuplicateRange( const R1, C1, R2, C2 : Integer) : TMatrixClass;');
    RegisterMethod('Function DuplicateRow( const Row : Integer) : TVectorClass');
    RegisterMethod('Function DuplicateCol( const Col : Integer) : TVectorClass');
    RegisterMethod('Function DuplicateDiagonal : TVectorClass');
    RegisterMethod('Function IsEqual( const M : TMatrixClass) : Boolean;');
    RegisterMethod('Function IsEqual6( const V : TVectorClass) : Boolean;');
    RegisterMethod('Function IsSquare : Boolean');
    RegisterMethod('Function IsZero : Boolean');
    RegisterMethod('Function IsIdentity : Boolean');
    RegisterProperty('AsString', 'String', iptr);
    RegisterProperty('AsStringB', 'RawByteString', iptr);
    RegisterProperty('AsStringU', 'UnicodeString', iptr);
    RegisterMethod('Function Trace : MFloat');
    RegisterMethod('Procedure SetRow7( const Row : Integer; const V : TVectorClass);');
    RegisterMethod('Procedure SetRow( const Row : Integer; const Values : array of MFloat);');
    RegisterMethod('Procedure SetCol( const Col : Integer; const V : TVectorClass)');
    RegisterMethod('Function Transpose : TMatrixClass');
    RegisterMethod('Procedure TransposeInPlace');
    RegisterMethod('Procedure Add( const M : TMatrixClass)');
    RegisterMethod('Procedure Subtract( const M : TMatrixClass)');
    RegisterMethod('Procedure Negate');
    RegisterMethod('Procedure MultiplyRow( const Row : Integer; const Value : MFloat)');
    RegisterMethod('Procedure Multiply( const Value : MFloat);');
    RegisterMethod('Function Multiply1( const M : TMatrixClass) : TMatrixClass;');
    RegisterMethod('Procedure MultiplyInPlace( const M : TMatrixClass)');
    RegisterMethod('Function IsOrtogonal : Boolean');
    RegisterMethod('Function IsIdempotent : Boolean');
    RegisterMethod('Function Normalise( const M : TMatrixClass) : MFloat');
    RegisterMethod('Function SolveMatrix( var M : TMatrixClass) : MFloat');
    RegisterMethod('Function Determinant : MFloat');
    RegisterMethod('Function Inverse : TMatrixClass');
    RegisterMethod('Procedure InverseInPlace');
    RegisterMethod('Function SolveLinearSystem( const V : TVectorClass) : TVectorClass');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_flcMatrix(CL: TPSPascalCompiler);
begin
  SIRegister_TMatrixClass(CL);
  CL.AddClassN(CL.FindClass('TOBJECT'),'EMatrix');
 CL.AddDelphiFunction('Procedure TestMatrixClass');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
Function TMatrixClassMultiply10_P(Self: TMatrixClass;  const M : TMatrixClass) : TMatrixClass;
Begin Result := Self.Multiply(M); END;

(*----------------------------------------------------------------------------*)
Procedure TMatrixClassMultiply9_P(Self: TMatrixClass;  const Value : MFloat);
Begin Self.Multiply(Value); END;

(*----------------------------------------------------------------------------*)
Procedure TMatrixClassSetRow8_P(Self: TMatrixClass;  const Row : Integer; const Values : array of MFloat);
Begin Self.SetRow(Row, Values); END;

(*----------------------------------------------------------------------------*)
Procedure TMatrixClassSetRow7_P(Self: TMatrixClass;  const Row : Integer; const V : TVectorClass);
Begin Self.SetRow(Row, V); END;    //}

(*----------------------------------------------------------------------------*)
procedure TMatrixClassAsStringU_R(Self: TMatrixClass; var T: String);
begin T := Self.AsStringU; end;

(*----------------------------------------------------------------------------*)
procedure TMatrixClassAsStringB_R(Self: TMatrixClass; var T: String);
begin //T := Self.AsStringB;
end;

(*----------------------------------------------------------------------------*)
procedure TMatrixClassAsString_R(Self: TMatrixClass; var T: String);
begin T := Self.AsString; end;

(*----------------------------------------------------------------------------*)
Function TMatrixClassIsEqual6_P(Self: TMatrixClass;  const V : TVectorClass) : Boolean;
Begin Result := Self.IsEqual(V); END;

(*----------------------------------------------------------------------------*)
Function TMatrixClassIsEqual5_P(Self: TMatrixClass;  const M : TMatrixClass) : Boolean;
Begin Result := Self.IsEqual(M); END;

(*----------------------------------------------------------------------------*)
Function TMatrixClassDuplicateRange4_P(Self: TMatrixClass;  const R1, C1, R2, C2 : Integer) : TMatrixClass;
Begin Result := Self.DuplicateRange(R1, C1, R2, C2); END;

(*----------------------------------------------------------------------------*)
Function TMatrixClassDuplicate3_P(Self: TMatrixClass) : TMatrixClass;
Begin Result := Self.Duplicate; END;

(*----------------------------------------------------------------------------*)
Procedure TMatrixClassAssign2_P(Self: TMatrixClass;  const V : TVectorClass);
Begin Self.Assign(V); END;  // }

(*----------------------------------------------------------------------------*)
Procedure TMatrixClassAssign1_P(Self: TMatrixClass;  const M : TMatrixClass);
Begin Self.Assign(M); END;

(*----------------------------------------------------------------------------*)
Procedure TMatrixClassAssign0_P(Self: TMatrixClass;  const Value : MFloat);
Begin Self.Assign(Value); END;

(*----------------------------------------------------------------------------*)
procedure TMatrixClassItem_W(Self: TMatrixClass; const T: MFloat; const t1: Integer; const t2: Integer);
begin Self.Item[t1, t2] := T; end;

(*----------------------------------------------------------------------------*)
procedure TMatrixClassItem_R(Self: TMatrixClass; var T: MFloat; const t1: Integer; const t2: Integer);
begin T := Self.Item[t1, t2]; end;

(*----------------------------------------------------------------------------*)
procedure TMatrixClassRowCount_W(Self: TMatrixClass; const T: Integer);
begin Self.RowCount := T; end;

(*----------------------------------------------------------------------------*)
procedure TMatrixClassRowCount_R(Self: TMatrixClass; var T: Integer);
begin T := Self.RowCount; end;

(*----------------------------------------------------------------------------*)
procedure TMatrixClassColCount_W(Self: TMatrixClass; const T: Integer);
begin Self.ColCount := T; end;

(*----------------------------------------------------------------------------*)
procedure TMatrixClassColCount_R(Self: TMatrixClass; var T: Integer);
begin T := Self.ColCount; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_flcMatrix_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@TestMatrix, 'TestMatrixClass', cdRegister);
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TMatrixClass(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TMatrixClass) do
  begin
    RegisterConstructor(@TMatrixClass.CreateSize, 'CreateSize');
    RegisterConstructor(@TMatrixClass.CreateSquare, 'CreateSquare');
    RegisterConstructor(@TMatrixClass.CreateDiagonal, 'CreateDiagonal');
    RegisterPropertyHelper(@TMatrixClassColCount_R,@TMatrixClassColCount_W,'ColCount');
    RegisterPropertyHelper(@TMatrixClassRowCount_R,@TMatrixClassRowCount_W,'RowCount');
    RegisterMethod(@TMatrixClass.SetSize, 'SetSize');
    RegisterMethod(@TMatrixClass.Clear, 'Clear');
    RegisterPropertyHelper(@TMatrixClassItem_R,@TMatrixClassItem_W,'Item');
    RegisterMethod(@TMatrixClass.AssignZero, 'AssignZero');
    RegisterMethod(@TMatrixClass.AssignIdentity, 'AssignIdentity');
    RegisterMethod(@TMatrixClassAssign0_P, 'Assign');
    RegisterMethod(@TMatrixClassAssign1_P, 'Assign1');
   RegisterMethod(@TMatrixClassAssign2_P, 'Assign2');
    RegisterMethod(@TMatrixClassDuplicate3_P, 'Duplicate');
    RegisterMethod(@TMatrixClassDuplicateRange4_P, 'DuplicateRange');
    RegisterMethod(@TMatrixClass.DuplicateRow, 'DuplicateRow');
    RegisterMethod(@TMatrixClass.DuplicateCol, 'DuplicateCol');
    RegisterMethod(@TMatrixClass.DuplicateDiagonal, 'DuplicateDiagonal');
    RegisterMethod(@TMatrixClassIsEqual5_P, 'IsEqual');
    RegisterMethod(@TMatrixClassIsEqual6_P, 'IsEqual6');
    RegisterMethod(@TMatrixClass.IsSquare, 'IsSquare');
    RegisterMethod(@TMatrixClass.IsZero, 'IsZero');
    RegisterMethod(@TMatrixClass.IsIdentity, 'IsIdentity');
    RegisterPropertyHelper(@TMatrixClassAsString_R,nil,'AsString');
    RegisterPropertyHelper(@TMatrixClassAsStringB_R,nil,'AsStringB');
    RegisterPropertyHelper(@TMatrixClassAsStringU_R,nil,'AsStringU');
    RegisterMethod(@TMatrixClass.Trace, 'Trace');
    RegisterMethod(@TMatrixClassSetRow7_P, 'SetRow7');
    RegisterMethod(@TMatrixClassSetRow8_P, 'SetRow');
    RegisterMethod(@TMatrixClass.SetCol, 'SetCol');
    RegisterMethod(@TMatrixClass.Transpose, 'Transpose');
    RegisterMethod(@TMatrixClass.TransposeInPlace, 'TransposeInPlace');
    RegisterMethod(@TMatrixClass.Add, 'Add');
    RegisterMethod(@TMatrixClass.Subtract, 'Subtract');
    RegisterMethod(@TMatrixClass.Negate, 'Negate');
    RegisterMethod(@TMatrixClass.MultiplyRow, 'MultiplyRow');
    RegisterMethod(@TMatrixClassMultiply9_P, 'Multiply');
    RegisterMethod(@TMatrixClassMultiply10_P, 'Multiply1');
    RegisterMethod(@TMatrixClass.MultiplyInPlace, 'MultiplyInPlace');
    RegisterMethod(@TMatrixClass.IsOrtogonal, 'IsOrtogonal');
    RegisterMethod(@TMatrixClass.IsIdempotent, 'IsIdempotent');
    RegisterMethod(@TMatrixClass.Normalise, 'Normalise');
    RegisterMethod(@TMatrixClass.SolveMatrix, 'SolveMatrix');
    RegisterMethod(@TMatrixClass.Determinant, 'Determinant');
    RegisterMethod(@TMatrixClass.Inverse, 'Inverse');
    RegisterMethod(@TMatrixClass.InverseInPlace, 'InverseInPlace');
    RegisterMethod(@TMatrixClass.SolveLinearSystem, 'SolveLinearSystem');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_flcMatrix(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TMatrixClass(CL);
  with CL.Add(EMatrix) do
end;

 
 
{ TPSImport_flcMatrix }
(*----------------------------------------------------------------------------*)
procedure TPSImport_flcMatrix.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_flcMatrix(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_flcMatrix.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_flcMatrix(ri);
  RIRegister_flcMatrix_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
