unit uPSI_flcComplex;
{
Tafter Rational with tests now complex class

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
  TPSImport_flcComplex = class(TPSPlugin)
  public
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TComplexClass(CL: TPSPascalCompiler);
procedure SIRegister_flcComplex(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_flcComplex_Routines(S: TPSExec);
procedure RIRegister_TComplexClass(CL: TPSRuntimeClassImporter);
procedure RIRegister_flcComplex(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   cFundamentUtils
  ,flcMaths
  ,flcComplex
  ;
 

procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_flcComplex]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TComplexClass(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOBJECT', 'TComplexClass') do
  with CL.AddClassN(CL.FindClass('TOBJECT'),'TComplexClass') do
  begin
    RegisterMethod('Constructor Create( const ARealPart : MFloat; const AImaginaryPart : MFloat)');
    RegisterProperty('RealPart', 'MFloat', iptrw);
    RegisterProperty('ImaginaryPart', 'MFloat', iptrw);
    RegisterProperty('AsString', 'String', iptrw);
    RegisterProperty('AsStringB', 'RawByteString', iptrw);
    RegisterProperty('AsStringU', 'UnicodeString', iptrw);
    RegisterMethod('Procedure Assign( const C : TComplex);');
    RegisterMethod('Procedure Assign1( const V : MFloat);');
    RegisterMethod('Procedure AssignZero');
    RegisterMethod('Procedure AssignI');
    RegisterMethod('Procedure AssignMinI');
    RegisterMethod('Function Duplicate : TComplexClass');
    RegisterMethod('Function IsEqual2( const C : TComplexClass) : Boolean;');
    RegisterMethod('Function IsEqual3( const R, I : MFloat) : Boolean;');
    RegisterMethod('Function IsReal : Boolean');
    RegisterMethod('Function IsZero : Boolean');
    RegisterMethod('Function IsI : Boolean');
    RegisterMethod('Procedure Add4( const C : TComplex);');
    RegisterMethod('Procedure Add5( const V : MFloat);');
    RegisterMethod('Procedure Subtract6( const C : TComplexClass);');
    RegisterMethod('Procedure Subtract7( const V : MFloat);');
    RegisterMethod('Procedure Multiply8( const C : TComplexClass);');
    RegisterMethod('Procedure Multiply9( const V : MFloat);');
    RegisterMethod('Procedure MultiplyI');
    RegisterMethod('Procedure MultiplyMinI');
    RegisterMethod('Procedure Divide10( const C : TComplexClass);');
    RegisterMethod('Procedure Divide11( const V : MFloat);');
    RegisterMethod('Procedure Negate');
    RegisterMethod('Function Modulo : MFloat');
    RegisterMethod('Function Denom : MFloat');
    RegisterMethod('Procedure Conjugate');
    RegisterMethod('Procedure Inverse');
    RegisterMethod('Procedure Sqrt');
    RegisterMethod('Procedure Exp');
    RegisterMethod('Procedure Ln');
    RegisterMethod('Procedure Sin');
    RegisterMethod('Procedure Cos');
    RegisterMethod('Procedure Tan');
    RegisterMethod('Procedure Power( const C : TComplexClass)');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_flcComplex(CL: TPSPascalCompiler);
begin
  CL.AddClassN(CL.FindClass('TOBJECT'),'EComplexClass');
  SIRegister_TComplexClass(CL);
 CL.AddDelphiFunction('Procedure TestComplexClass');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
Procedure TComplexClassDivide11_P(Self: TComplexClass;  const V : MFloat);
Begin Self.Divide(V); END;

(*----------------------------------------------------------------------------*)
Procedure TComplexClassDivide10_P(Self: TComplexClass;  const C : TComplexClass);
Begin Self.Divide(C); END;

(*----------------------------------------------------------------------------*)
Procedure TComplexClassMultiply9_P(Self: TComplexClass;  const V : MFloat);
Begin Self.Multiply(V); END;

(*----------------------------------------------------------------------------*)
Procedure TComplexClassMultiply8_P(Self: TComplexClass;  const C : TComplexClass);
Begin Self.Multiply(C); END;

(*----------------------------------------------------------------------------*)
Procedure TComplexClassSubtract7_P(Self: TComplexClass;  const V : MFloat);
Begin Self.Subtract(V); END;

(*----------------------------------------------------------------------------*)
Procedure TComplexClassSubtract6_P(Self: TComplexClass;  const C : TComplexClass);
Begin Self.Subtract(C); END;

(*----------------------------------------------------------------------------*)
Procedure TComplexClassAdd5_P(Self: TComplexClass;  const V : MFloat);
Begin Self.Add(V); END;

(*----------------------------------------------------------------------------*)
Procedure TComplexClassAdd4_P(Self: TComplexClass;  const C : TComplexClass);
Begin Self.Add(C); END;

(*----------------------------------------------------------------------------*)
Function TComplexClassIsEqual3_P(Self: TComplexClass;  const R, I : MFloat) : Boolean;
Begin Result := Self.IsEqual(R, I); END;

(*----------------------------------------------------------------------------*)
Function TComplexClassIsEqual2_P(Self: TComplexClass;  const C : TComplexClass) : Boolean;
Begin Result := Self.IsEqual(C); END;

(*----------------------------------------------------------------------------*)
Procedure TComplexClassAssign1_P(Self: TComplexClass;  const V : MFloat);
Begin Self.Assign(V); END;

(*----------------------------------------------------------------------------*)
Procedure TComplexClassAssign0_P(Self: TComplexClass;  const C : TComplexClass);
Begin Self.Assign(C); END;

(*----------------------------------------------------------------------------*)
procedure TComplexClassAsStringU_W(Self: TComplexClass; const T: UnicodeString);
begin Self.AsStringU := T; end;

(*----------------------------------------------------------------------------*)
procedure TComplexClassAsStringU_R(Self: TComplexClass; var T: UnicodeString);
begin T := Self.AsStringU; end;

(*----------------------------------------------------------------------------*)
procedure TComplexClassAsStringB_W(Self: TComplexClass; const T: String);
begin //Self.AsStringB := T;
end;

(*----------------------------------------------------------------------------*)
procedure TComplexClassAsStringB_R(Self: TComplexClass; var T: String);
begin //T := Self.AsStringB;
end;

(*----------------------------------------------------------------------------*)
procedure TComplexClassAsString_W(Self: TComplexClass; const T: String);
begin Self.AsString := T; end;

(*----------------------------------------------------------------------------*)
procedure TComplexClassAsString_R(Self: TComplexClass; var T: String);
begin T := Self.AsString; end;

(*----------------------------------------------------------------------------*)
procedure TComplexClassImaginaryPart_W(Self: TComplexClass; const T: MFloat);
begin Self.ImaginaryPart := T; end;

(*----------------------------------------------------------------------------*)
procedure TComplexClassImaginaryPart_R(Self: TComplexClass; var T: MFloat);
begin T := Self.ImaginaryPart; end;

(*----------------------------------------------------------------------------*)
procedure TComplexClassRealPart_W(Self: TComplexClass; const T: MFloat);
begin Self.RealPart := T; end;

(*----------------------------------------------------------------------------*)
procedure TComplexClassRealPart_R(Self: TComplexClass; var T: MFloat);
begin T := Self.RealPart; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_flcComplex_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@TestComplex, 'TestComplexClass', cdRegister);
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TComplexClass(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TComplexClass) do
  begin
    RegisterConstructor(@TComplexClass.Create, 'Create');
    RegisterPropertyHelper(@TComplexClassRealPart_R,@TComplexClassRealPart_W,'RealPart');
    RegisterPropertyHelper(@TComplexClassImaginaryPart_R,@TComplexClassImaginaryPart_W,'ImaginaryPart');
    RegisterPropertyHelper(@TComplexClassAsString_R,@TComplexClassAsString_W,'AsString');
    RegisterPropertyHelper(@TComplexClassAsStringB_R,@TComplexClassAsStringB_W,'AsStringB');
    RegisterPropertyHelper(@TComplexClassAsStringU_R,@TComplexClassAsStringU_W,'AsStringU');
    RegisterMethod(@TComplexClassAssign0_P, 'Assign');
    RegisterMethod(@TComplexClassAssign1_P, 'Assign1');
    RegisterMethod(@TComplexClass.AssignZero, 'AssignZero');
    RegisterMethod(@TComplexClass.AssignI, 'AssignI');
    RegisterMethod(@TComplexClass.AssignMinI, 'AssignMinI');
    RegisterMethod(@TComplexClass.Duplicate, 'Duplicate');
    RegisterMethod(@TComplexClassIsEqual2_P, 'IsEqual2');
    RegisterMethod(@TComplexClassIsEqual3_P, 'IsEqual3');
    RegisterMethod(@TComplexClass.IsReal, 'IsReal');
    RegisterMethod(@TComplexClass.IsZero, 'IsZero');
    RegisterMethod(@TComplexClass.IsI, 'IsI');
    RegisterMethod(@TComplexClassAdd4_P, 'Add4');
    RegisterMethod(@TComplexClassAdd5_P, 'Add5');
    RegisterMethod(@TComplexClassSubtract6_P, 'Subtract6');
    RegisterMethod(@TComplexClassSubtract7_P, 'Subtract7');
    RegisterMethod(@TComplexClassMultiply8_P, 'Multiply8');
    RegisterMethod(@TComplexClassMultiply9_P, 'Multiply9');
    RegisterMethod(@TComplexClass.MultiplyI, 'MultiplyI');
    RegisterMethod(@TComplexClass.MultiplyMinI, 'MultiplyMinI');
    RegisterMethod(@TComplexClassDivide10_P, 'Divide10');
    RegisterMethod(@TComplexClassDivide11_P, 'Divide11');
    RegisterMethod(@TComplexClass.Negate, 'Negate');
    RegisterMethod(@TComplexClass.Modulo, 'Modulo');
    RegisterMethod(@TComplexClass.Denom, 'Denom');
    RegisterMethod(@TComplexClass.Conjugate, 'Conjugate');
    RegisterMethod(@TComplexClass.Inverse, 'Inverse');
    RegisterMethod(@TComplexClass.Sqrt, 'Sqrt');
    RegisterMethod(@TComplexClass.Exp, 'Exp');
    RegisterMethod(@TComplexClass.Ln, 'Ln');
    RegisterMethod(@TComplexClass.Sin, 'Sin');
    RegisterMethod(@TComplexClass.Cos, 'Cos');
    RegisterMethod(@TComplexClass.Tan, 'Tan');
    RegisterMethod(@TComplexClass.Power, 'Power');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_flcComplex(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(EComplexClass) do
  RIRegister_TComplexClass(CL);
end;

 
 
{ TPSImport_flcComplex }
(*----------------------------------------------------------------------------*)
procedure TPSImport_flcComplex.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_flcComplex(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_flcComplex.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_flcComplex(ri);
  RIRegister_flcComplex_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
