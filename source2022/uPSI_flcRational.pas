unit uPSI_flcRational;
{
Ratio

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
  TPSImport_flcRational = class(TPSPlugin)
  public
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TRationalClass(CL: TPSPascalCompiler);
procedure SIRegister_flcRational(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_flcRational_Routines(S: TPSExec);
procedure RIRegister_TRationalClass(CL: TPSRuntimeClassImporter);
procedure RIRegister_flcRational(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   flcStdTypes
  ,flcMaths
  ,flcRational
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_flcRational]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TRationalClass(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOBJECT', 'TRationalClass') do
  with CL.AddClassN(CL.FindClass('TOBJECT'),'TRationalClass') do
  begin
    RegisterMethod('Constructor Create;');
    RegisterMethod('Constructor Create1( const Numerator : Int64; const Denominator : Int64);');
    RegisterMethod('Constructor Create2( const R : Extended);');
    RegisterProperty('Numerator', 'Int64', iptrw);
    RegisterProperty('Denominator', 'Int64', iptrw);
    RegisterProperty('AsString', 'String', iptrw);
    RegisterProperty('AsStringB', 'RawByteString', iptrw);
    RegisterProperty('AsStringU', 'UnicodeString', iptrw);
    RegisterProperty('AsFloat', 'MFloat', iptrw);
    RegisterMethod('Function Duplicate : TRationalClass');
    RegisterMethod('Procedure Assign( const R : TRationalClass);');
    RegisterMethod('Procedure Assign1( const R : MFloat);');
    RegisterMethod('Procedure Assign2( const Numerator : Int64; const Denominator : Int64);');
    RegisterMethod('Procedure AssignZero');
    RegisterMethod('Procedure AssignOne');
    RegisterMethod('Function IsEqual( const R : TRationalClass) : Boolean;');
    RegisterMethod('Function IsEqual1( const Numerator : Int64; const Denominator : Int64) : Boolean;');
    RegisterMethod('Function IsEqual2( const R : Extended) : Boolean;');
    RegisterMethod('Function IsZero : Boolean');
    RegisterMethod('Function IsOne : Boolean');
    RegisterMethod('Procedure Add( const R : TRationalClass);');
    RegisterMethod('Procedure Add1( const V : Extended);');
    RegisterMethod('Procedure Add2( const V : Int64);');
    RegisterMethod('Procedure Subtract( const R : TRationalClass);');
    RegisterMethod('Procedure Subtract1( const V : Extended);');
    RegisterMethod('Procedure Subtract2( const V : Int64);');
    RegisterMethod('Procedure Negate');
    RegisterMethod('Procedure Abs');
    RegisterMethod('Function Sgn : Integer');
    RegisterMethod('Procedure Multiply( const R : TRationalClass);');
    RegisterMethod('Procedure Multiply1( const V : Extended);');
    RegisterMethod('Procedure Multiply2( const V : Int64);');
    RegisterMethod('Procedure Divide( const R : TRationalClass);');
    RegisterMethod('Procedure Divide1( const V : Extended);');
    RegisterMethod('Procedure Divide2( const V : Int64);');
    RegisterMethod('Procedure Reciprocal');
    RegisterMethod('Procedure Sqrt');
    RegisterMethod('Procedure Sqr');
    RegisterMethod('Procedure Power( const R : TRationalClass);');
    RegisterMethod('Procedure Power1( const V : Int64);');
    RegisterMethod('Procedure Power2( const V : Extended);');
    RegisterMethod('Procedure Exp');
    RegisterMethod('Procedure Ln');
    RegisterMethod('Procedure Sin');
    RegisterMethod('Procedure Cos');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_flcRational(CL: TPSPascalCompiler);
begin
  SIRegister_TRationalClass(CL);
  CL.AddClassN(CL.FindClass('TOBJECT'),'ERational');
  CL.AddClassN(CL.FindClass('TOBJECT'),'ERationalDivByZero');
 CL.AddDelphiFunction('Procedure TestRationalClass');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
Procedure TRationalClassPower23_P(Self: TRationalClass;  const V : Extended);
Begin Self.Power(V); END;

(*----------------------------------------------------------------------------*)
Procedure TRationalClassPower22_P(Self: TRationalClass;  const V : Int64);
Begin Self.Power(V); END;

(*----------------------------------------------------------------------------*)
Procedure TRationalClassPower_P(Self: TRationalClass;  const R : TRationalClass);
Begin Self.Power(R); END;

(*----------------------------------------------------------------------------*)
Procedure TRationalClassDivide20_P(Self: TRationalClass;  const V : Int64);
Begin Self.Divide(V); END;

(*----------------------------------------------------------------------------*)
Procedure TRationalClassDivide19_P(Self: TRationalClass;  const V : Extended);
Begin Self.Divide(V); END;

(*----------------------------------------------------------------------------*)
Procedure TRationalClassDivide_P(Self: TRationalClass;  const R : TRationalClass);
Begin Self.Divide(R); END;

(*----------------------------------------------------------------------------*)
Procedure TRationalClassMultiply17_P(Self: TRationalClass;  const V : Int64);
Begin Self.Multiply(V); END;

(*----------------------------------------------------------------------------*)
Procedure TRationalClassMultiply16_P(Self: TRationalClass;  const V : Extended);
Begin Self.Multiply(V); END;

(*----------------------------------------------------------------------------*)
Procedure TRationalClassMultiply_P(Self: TRationalClass;  const R : TRationalClass);
Begin Self.Multiply(R); END;

(*----------------------------------------------------------------------------*)
Procedure TRationalClassSubtract14_P(Self: TRationalClass;  const V : Int64);
Begin Self.Subtract(V); END;

(*----------------------------------------------------------------------------*)
Procedure TRationalClassSubtract13_P(Self: TRationalClass;  const V : Extended);
Begin Self.Subtract(V); END;

(*----------------------------------------------------------------------------*)
Procedure TRationalClassSubtract_P(Self: TRationalClass;  const R : TRationalClass);
Begin Self.Subtract(R); END;

(*----------------------------------------------------------------------------*)
Procedure TRationalClassAdd11_P(Self: TRationalClass;  const V : Int64);
Begin Self.Add(V); END;

(*----------------------------------------------------------------------------*)
Procedure TRationalClassAdd10_P(Self: TRationalClass;  const V : Extended);
Begin Self.Add(V); END;

(*----------------------------------------------------------------------------*)
Procedure TRationalClassAdd_P(Self: TRationalClass;  const R : TRationalclass);
Begin Self.Add(R); END;

(*----------------------------------------------------------------------------*)
Function TRationalClassIsEqual8_P(Self: TRationalClass;  const R : Extended) : Boolean;
Begin Result := Self.IsEqual(R); END;

(*----------------------------------------------------------------------------*)
Function TRationalClassIsEqual7_P(Self: TRationalClass;  const Numerator : Int64; const Denominator : Int64) : Boolean;
Begin Result := Self.IsEqual(Numerator, Denominator); END;

(*----------------------------------------------------------------------------*)
Function TRationalClassIsEqual_P(Self: TRationalClass;  const R : TRationalClass) : Boolean;
Begin Result := Self.IsEqual(R); END;

(*----------------------------------------------------------------------------*)
Procedure TRationalClassAssign5_P(Self: TRationalClass;  const Numerator : Int64; const Denominator : Int64);
Begin Self.Assign(Numerator, Denominator); END;

(*----------------------------------------------------------------------------*)
Procedure TRationalClassAssign4_P(Self: TRationalClass;  const R : MFloat);
Begin Self.Assign(R); END;

(*----------------------------------------------------------------------------*)
Procedure TRationalClassAssign_P(Self: TRationalClass;  const R : TRationalClass);
Begin Self.Assign(R); END;

(*----------------------------------------------------------------------------*)
procedure TRationalClassAsFloat_W(Self: TRationalClass; const T: MFloat);
begin Self.AsFloat := T; end;

(*----------------------------------------------------------------------------*)
procedure TRationalClassAsFloat_R(Self: TRationalClass; var T: MFloat);
begin T := Self.AsFloat; end;

(*----------------------------------------------------------------------------*)
procedure TRationalClassAsStringU_W(Self: TRationalClass; const T: UnicodeString);
begin Self.AsStringU := T; end;

(*----------------------------------------------------------------------------*)
procedure TRationalClassAsStringU_R(Self: TRationalClass; var T: UnicodeString);
begin T := Self.AsStringU; end;

(*----------------------------------------------------------------------------*)
procedure TRationalClassAsStringB_W(Self: TRationalClass; const T: RawByteString);
begin //Self.AsStringB := T;
end;

(*----------------------------------------------------------------------------*)
procedure TRationalClassAsStringB_R(Self: TRationalClass; var T: RawByteString);
begin //T := Self.AsStringB;
end;

(*----------------------------------------------------------------------------*)
procedure TRationalClassAsString_W(Self: TRationalClass; const T: String);
begin Self.AsString := T; end;

(*----------------------------------------------------------------------------*)
procedure TRationalClassAsString_R(Self: TRationalClass; var T: String);
begin T := Self.AsString; end;

(*----------------------------------------------------------------------------*)
procedure TRationalClassDenominator_W(Self: TRationalClass; const T: Int64);
begin Self.Denominator := T; end;

(*----------------------------------------------------------------------------*)
procedure TRationalClassDenominator_R(Self: TRationalClass; var T: Int64);
begin T := Self.Denominator; end;

(*----------------------------------------------------------------------------*)
procedure TRationalClassNumerator_W(Self: TRationalClass; const T: Int64);
begin Self.Numerator := T; end;

(*----------------------------------------------------------------------------*)
procedure TRationalClassNumerator_R(Self: TRationalClass; var T: Int64);
begin T := Self.Numerator; end;

(*----------------------------------------------------------------------------*)
Function TRationalClassCreate2_P(Self: TClass; CreateNewInstance: Boolean;  const R : Extended):TObject;
Begin Result := TRationalClass.Create(R); END;

(*----------------------------------------------------------------------------*)
Function TRationalClassCreate1_P(Self: TClass; CreateNewInstance: Boolean;  const Numerator : Int64; const Denominator : Int64):TObject;
Begin Result := TRationalClass.Create(Numerator, Denominator); END;

(*----------------------------------------------------------------------------*)
Function TRationalClassCreate_P(Self: TClass; CreateNewInstance: Boolean):TObject;
Begin Result := TRationalClass.Create; END;

(*----------------------------------------------------------------------------*)
procedure RIRegister_flcRational_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@TestRational, 'TestRationalClass', cdRegister);
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TRationalClass(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TRationalClass) do
  begin
    RegisterConstructor(@TRationalClassCreate_P, 'Create');
    RegisterConstructor(@TRationalClassCreate1_P, 'Create1');
    RegisterConstructor(@TRationalClassCreate2_P, 'Create2');
    RegisterPropertyHelper(@TRationalClassNumerator_R,@TRationalClassNumerator_W,'Numerator');
    RegisterPropertyHelper(@TRationalClassDenominator_R,@TRationalClassDenominator_W,'Denominator');
    RegisterPropertyHelper(@TRationalClassAsString_R,@TRationalClassAsString_W,'AsString');
    RegisterPropertyHelper(@TRationalClassAsStringB_R,@TRationalClassAsStringB_W,'AsStringB');
    RegisterPropertyHelper(@TRationalClassAsStringU_R,@TRationalClassAsStringU_W,'AsStringU');
    RegisterPropertyHelper(@TRationalClassAsFloat_R,@TRationalClassAsFloat_W,'AsFloat');
    RegisterMethod(@TRationalClass.Duplicate, 'Duplicate');
    RegisterMethod(@TRationalClassAssign_P, 'Assign');
    RegisterMethod(@TRationalClassAssign4_P, 'Assign1');
    RegisterMethod(@TRationalClassAssign5_P, 'Assign2');
    RegisterMethod(@TRationalClass.AssignZero, 'AssignZero');
    RegisterMethod(@TRationalClass.AssignOne, 'AssignOne');
    RegisterMethod(@TRationalClassIsEqual_P, 'IsEqual');
    RegisterMethod(@TRationalClassIsEqual7_P, 'IsEqual1');
    RegisterMethod(@TRationalClassIsEqual8_P, 'IsEqual2');
    RegisterMethod(@TRationalClass.IsZero, 'IsZero');
    RegisterMethod(@TRationalClass.IsOne, 'IsOne');
    RegisterMethod(@TRationalClassAdd_P, 'Add');
    RegisterMethod(@TRationalClassAdd10_P, 'Add1');
    RegisterMethod(@TRationalClassAdd11_P, 'Add2');
    RegisterMethod(@TRationalClassSubtract_P, 'Subtract');
    RegisterMethod(@TRationalClassSubtract13_P, 'Subtract1');
    RegisterMethod(@TRationalClassSubtract14_P, 'Subtract2');
    RegisterMethod(@TRationalClass.Negate, 'Negate');
    RegisterMethod(@TRationalClass.Abs, 'Abs');
    RegisterMethod(@TRationalClass.Sgn, 'Sgn');
    RegisterMethod(@TRationalClassMultiply_P, 'Multiply');
    RegisterMethod(@TRationalClassMultiply16_P, 'Multiply1');
    RegisterMethod(@TRationalClassMultiply17_P, 'Multiply2');
    RegisterMethod(@TRationalClassDivide_P, 'Divide');
    RegisterMethod(@TRationalClassDivide19_P, 'Divide1');
    RegisterMethod(@TRationalClassDivide20_P, 'Divide2');
    RegisterMethod(@TRationalClass.Reciprocal, 'Reciprocal');
    RegisterMethod(@TRationalClass.Sqrt, 'Sqrt');
    RegisterMethod(@TRationalClass.Sqr, 'Sqr');
    RegisterMethod(@TRationalClassPower_P, 'Power');
    RegisterMethod(@TRationalClassPower22_P, 'Power1');
    RegisterMethod(@TRationalClassPower23_P, 'Power2');
    RegisterMethod(@TRationalClass.Exp, 'Exp');
    RegisterMethod(@TRationalClass.Ln, 'Ln');
    RegisterMethod(@TRationalClass.Sin, 'Sin');
    RegisterMethod(@TRationalClass.Cos, 'Cos');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_flcRational(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TRationalClass(CL);
  with CL.Add(ERational) do
  with CL.Add(ERationalDivByZero) do
end;

 
 
{ TPSImport_flcRational }
(*----------------------------------------------------------------------------*)
procedure TPSImport_flcRational.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_flcRational(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_flcRational.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_flcRational(ri);
  RIRegister_flcRational_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
