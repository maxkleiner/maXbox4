unit uPSI_GR32_Geometry;
{
  of graphics
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
  TPSImport_GR32_Geometry = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;


{ compile-time registration functions }
procedure SIRegister_GR32_Geometry(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_GR32_Geometry_Routines(S: TPSExec);

procedure Register;

implementation


uses
   Math
  ,GR32
  ,GR32_Math
  ,GR32_Geometry
  ;


procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_GR32_Geometry]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_GR32_Geometry(CL: TPSPascalCompiler);
begin
  //CL.AddTypeS('PFixedVector', '^TFixedVector // will not work');
  //CL.AddTypeS('TFixedVector', 'TFixedPoint');
  //CL.AddTypeS('PFloatVector', '^TFloatVector // will not work');
  //CL.AddTypeS('TFloatVector', 'TFloatPoint');
 CL.AddDelphiFunction('Function gr32Add( const V1, V2 : TFloatVector) : TFloatVector;');
 CL.AddDelphiFunction('Function gr32Add1( const V : TFloatVector; Value : TFloat) : TFloatVector;');
 CL.AddDelphiFunction('Function gr32Sub( const V1, V2 : TFloatVector) : TFloatVector;');
 CL.AddDelphiFunction('Function gr32Sub1( const V : TFloatVector; Value : TFloat) : TFloatVector;');
 CL.AddDelphiFunction('Function gr32Mul( const V1, V2 : TFloatVector) : TFloatVector;');
 CL.AddDelphiFunction('Function gr32Mul1( const V : TFloatVector; Multiplier : TFloat) : TFloatVector;');
 CL.AddDelphiFunction('Function gr32Divide( const V : TFloatVector; Divisor : TFloat) : TFloatVector;');
 CL.AddDelphiFunction('Function gr32Divide1( const V1, V2 : TFloatVector) : TFloatVector;');
 CL.AddDelphiFunction('Function gr32Combine( const V1, V2 : TFloatVector; W : TFloat) : TFloatVector;');
 CL.AddDelphiFunction('Function gr32AbsV( const V : TFloatVector) : TFloatVector;');
 CL.AddDelphiFunction('Function gr32Neg( const V : TFloatVector) : TFloatVector;');
 CL.AddDelphiFunction('Function gr32Average( const V1, V2 : TFloatVector) : TFloatVector;');
 CL.AddDelphiFunction('Function gr32Max( const V1, V2 : TFloatVector) : TFloatVector;');
 CL.AddDelphiFunction('Function gr32Min( const V1, V2 : TFloatVector) : TFloatVector;');
 CL.AddDelphiFunction('Function gr32Dot( const V1, V2 : TFloatVector) : TFloat;');
 CL.AddDelphiFunction('Function gr32Distance( const V1, V2 : TFloatVector) : TFloat;');
 CL.AddDelphiFunction('Function gr32SqrDistance( const V1, V2 : TFloatVector) : TFloat;');
 CL.AddDelphiFunction('Function gr32Add2( const V1, V2 : TFixedVector) : TFixedVector;');
 CL.AddDelphiFunction('Function gr32Add3( const V : TFixedVector; Value : TFixed) : TFixedVector;');
 CL.AddDelphiFunction('Function gr32Sub2( const V1, V2 : TFixedVector) : TFixedVector;');
 CL.AddDelphiFunction('Function gr32Sub3( const V : TFixedVector; Value : TFixed) : TFixedVector;');
 CL.AddDelphiFunction('Function gr32Mul2( const V1, V2 : TFixedVector) : TFixedVector;');
 CL.AddDelphiFunction('Function gr32Mul3( const V : TFixedVector; Multiplier : TFixed) : TFixedVector;');
 CL.AddDelphiFunction('Function gr32Divide2( const V : TFixedVector; Divisor : TFixed) : TFixedVector;');
 CL.AddDelphiFunction('Function gr32Divide3( const V1, V2 : TFixedVector) : TFixedVector;');
 CL.AddDelphiFunction('Function gr32Combine1( const V1, V2 : TFixedVector; W : TFixed) : TFixedVector;');
 CL.AddDelphiFunction('Function gr32AbsV( const V : TFixedVector) : TFixedVector;');
 CL.AddDelphiFunction('Function gr32Neg2( const V : TFixedVector) : TFixedVector;');
 CL.AddDelphiFunction('Function gr32Average1( const V1, V2 : TFixedVector) : TFixedVector;');
 CL.AddDelphiFunction('Function gr32Max2( const V1, V2 : TFixedVector) : TFixedVector;');
 CL.AddDelphiFunction('Function gr32Min2( const V1, V2 : TFixedVector) : TFixedVector;');
 CL.AddDelphiFunction('Function gr32Dot2( const V1, V2 : TFixedVector) : TFixed;');
 CL.AddDelphiFunction('Function gr32Distance2( const V1, V2 : TFixedVector) : TFixed;');
 CL.AddDelphiFunction('Function gr32SqrDistance( const V1, V2 : TFixedVector) : TFixed;');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
Function SqrDistance_P( const V1, V2 : TFixedVector) : TFixed;
Begin Result := GR32_Geometry.SqrDistance(V1, V2); END;

(*----------------------------------------------------------------------------*)
Function Distance2_P( const V1, V2 : TFixedVector) : TFixed;
Begin Result := GR32_Geometry.Distance(V1, V2); END;

(*----------------------------------------------------------------------------*)
Function Dot2_P( const V1, V2 : TFixedVector) : TFixed;
Begin Result := GR32_Geometry.Dot(V1, V2); END;

(*----------------------------------------------------------------------------*)
Function Min2_P( const V1, V2 : TFixedVector) : TFixedVector;
Begin Result := GR32_Geometry.Min(V1, V2); END;

(*----------------------------------------------------------------------------*)
Function Max2_P( const V1, V2 : TFixedVector) : TFixedVector;
Begin Result := GR32_Geometry.Max(V1, V2); END;

(*----------------------------------------------------------------------------*)
Function Average_P( const V1, V2 : TFixedVector) : TFixedVector;
Begin Result := GR32_Geometry.Average(V1, V2); END;

(*----------------------------------------------------------------------------*)
Function Neg2_P( const V : TFixedVector) : TFixedVector;
Begin Result := GR32_Geometry.Neg(V); END;

(*----------------------------------------------------------------------------*)
Function AbsV_P( const V : TFixedVector) : TFixedVector;
Begin Result := GR32_Geometry.AbsV(V); END;

(*----------------------------------------------------------------------------*)
Function Combine_P( const V1, V2 : TFixedVector; W : TFixed) : TFixedVector;
Begin Result := GR32_Geometry.Combine(V1, V2, W); END;

(*----------------------------------------------------------------------------*)
Function Divide3_P( const V1, V2 : TFixedVector) : TFixedVector;
Begin Result := GR32_Geometry.Divide(V1, V2); END;

(*----------------------------------------------------------------------------*)
Function Divide2_P( const V : TFixedVector; Divisor : TFixed) : TFixedVector;
Begin Result := GR32_Geometry.Divide(V, Divisor); END;

(*----------------------------------------------------------------------------*)
Function Mul3_P( const V : TFixedVector; Multiplier : TFixed) : TFixedVector;
Begin Result := GR32_Geometry.Mul(V, Multiplier); END;

(*----------------------------------------------------------------------------*)
Function Mul2_P( const V1, V2 : TFixedVector) : TFixedVector;
Begin Result := GR32_Geometry.Mul(V1, V2); END;

(*----------------------------------------------------------------------------*)
Function Sub3_P( const V : TFixedVector; Value : TFixed) : TFixedVector;
Begin Result := GR32_Geometry.Sub(V, Value); END;

(*----------------------------------------------------------------------------*)
Function Sub2_P( const V1, V2 : TFixedVector) : TFixedVector;
Begin Result := GR32_Geometry.Sub(V1, V2); END;

(*----------------------------------------------------------------------------*)
Function Add3_P( const V : TFixedVector; Value : TFixed) : TFixedVector;
Begin Result := GR32_Geometry.Add(V, Value); END;

(*----------------------------------------------------------------------------*)
Function Add2_P( const V1, V2 : TFixedVector) : TFixedVector;
Begin Result := GR32_Geometry.Add(V1, V2); END;

(*----------------------------------------------------------------------------*)
Function SqrDistance_P1( const V1, V2 : TFloatVector) : TFloat;
Begin Result := GR32_Geometry.SqrDistance(V1, V2); END;

(*----------------------------------------------------------------------------*)
Function Distance_P( const V1, V2 : TFloatVector) : TFloat;
Begin Result := GR32_Geometry.Distance(V1, V2); END;

(*----------------------------------------------------------------------------*)
Function Dot_P( const V1, V2 : TFloatVector) : TFloat;
Begin Result := GR32_Geometry.Dot(V1, V2); END;

(*----------------------------------------------------------------------------*)
Function Min_P( const V1, V2 : TFloatVector) : TFloatVector;
Begin Result := GR32_Geometry.Min(V1, V2); END;

(*----------------------------------------------------------------------------*)
Function Max_P( const V1, V2 : TFloatVector) : TFloatVector;
Begin Result := GR32_Geometry.Max(V1, V2); END;

(*----------------------------------------------------------------------------*)
Function Average_P1( const V1, V2 : TFloatVector) : TFloatVector;
Begin Result := GR32_Geometry.Average(V1, V2); END;

(*----------------------------------------------------------------------------*)
Function Neg_P( const V : TFloatVector) : TFloatVector;
Begin Result := GR32_Geometry.Neg(V); END;

(*----------------------------------------------------------------------------*)
Function AbsV_P1( const V : TFloatVector) : TFloatVector;
Begin Result := GR32_Geometry.AbsV(V); END;

(*----------------------------------------------------------------------------*)
Function Combine_P1( const V1, V2 : TFloatVector; W : TFloat) : TFloatVector;
Begin Result := GR32_Geometry.Combine(V1, V2, W); END;

(*----------------------------------------------------------------------------*)
Function Divide1_P( const V1, V2 : TFloatVector) : TFloatVector;
Begin Result := GR32_Geometry.Divide(V1, V2); END;

(*----------------------------------------------------------------------------*)
Function Divide_P( const V : TFloatVector; Divisor : TFloat) : TFloatVector;
Begin Result := GR32_Geometry.Divide(V, Divisor); END;

(*----------------------------------------------------------------------------*)
Function Mul1_P( const V : TFloatVector; Multiplier : TFloat) : TFloatVector;
Begin Result := GR32_Geometry.Mul(V, Multiplier); END;

(*----------------------------------------------------------------------------*)
Function Mul_P( const V1, V2 : TFloatVector) : TFloatVector;
Begin Result := GR32_Geometry.Mul(V1, V2); END;

(*----------------------------------------------------------------------------*)
Function Sub1_P( const V : TFloatVector; Value : TFloat) : TFloatVector;
Begin Result := GR32_Geometry.Sub(V, Value); END;

(*----------------------------------------------------------------------------*)
Function Sub_P( const V1, V2 : TFloatVector) : TFloatVector;
Begin Result := GR32_Geometry.Sub(V1, V2); END;

(*----------------------------------------------------------------------------*)
Function Add1_P( const V : TFloatVector; Value : TFloat) : TFloatVector;
Begin Result := GR32_Geometry.Add(V, Value); END;

(*----------------------------------------------------------------------------*)
Function Add_P( const V1, V2 : TFloatVector) : TFloatVector;
Begin Result := GR32_Geometry.Add(V1, V2); END;

(*----------------------------------------------------------------------------*)
procedure RIRegister_GR32_Geometry_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@Add, 'gr32Add', cdRegister);
 S.RegisterDelphiFunction(@Add1_P, 'gr32Add1', cdRegister);
 S.RegisterDelphiFunction(@Sub, 'gr32Sub', cdRegister);
 S.RegisterDelphiFunction(@Sub1_P, 'gr32Sub1', cdRegister);
 S.RegisterDelphiFunction(@Mul, 'gr32Mul', cdRegister);
 S.RegisterDelphiFunction(@Mul1_P, 'gr32Mul1', cdRegister);
 S.RegisterDelphiFunction(@Divide, 'gr32Divide', cdRegister);
 S.RegisterDelphiFunction(@Divide1_P, 'gr32Divide1', cdRegister);
 S.RegisterDelphiFunction(@Combine, 'gr32Combine', cdRegister);
 S.RegisterDelphiFunction(@AbsV, 'gr32AbsV', cdRegister);
 S.RegisterDelphiFunction(@Neg, 'gr32Neg', cdRegister);
 S.RegisterDelphiFunction(@Average, 'gr32Average', cdRegister);
 //S.RegisterDelphiFunction(@Max, 'gr32Max', cdRegister);
 //S.RegisterDelphiFunction(@Min, 'gr32Min', cdRegister);
 S.RegisterDelphiFunction(@Dot, 'gr32Dot', cdRegister);
 S.RegisterDelphiFunction(@Distance, 'gr32Distance', cdRegister);
 S.RegisterDelphiFunction(@SqrDistance, 'gr32SqrDistance', cdRegister);

  S.RegisterDelphiFunction(@Add2_P, 'gr32Add2', cdRegister);
 S.RegisterDelphiFunction(@Add3_P, 'gr32Add3', cdRegister);
 S.RegisterDelphiFunction(@Sub2_P, 'gr32Sub2', cdRegister);
 S.RegisterDelphiFunction(@Sub3_P, 'gr32Sub3', cdRegister);
 S.RegisterDelphiFunction(@Mul2_P, 'gr32Mul2', cdRegister);
 S.RegisterDelphiFunction(@Mul3_P, 'gr32Mul3', cdRegister);
 S.RegisterDelphiFunction(@Divide2_P, 'gr32Divide2', cdRegister);
 S.RegisterDelphiFunction(@Divide3_P, 'gr32Divide3', cdRegister);
 S.RegisterDelphiFunction(@Combine_P1, 'gr32Combine', cdRegister);
 S.RegisterDelphiFunction(@AbsV, 'gr32AbsV', cdRegister);
 S.RegisterDelphiFunction(@Neg2_P, 'gr32Neg2', cdRegister);
 S.RegisterDelphiFunction(@Average_P1, 'gr32Average', cdRegister);
// S.RegisterDelphiFunction(@Max2_P, 'gr32Max2', cdRegister);
// S.RegisterDelphiFunction(@Min2_P, 'gr32Min2', cdRegister);
 S.RegisterDelphiFunction(@Dot2_P, 'gr32Dot2', cdRegister);
 S.RegisterDelphiFunction(@Distance2_P, 'gr32Distance2', cdRegister);
 S.RegisterDelphiFunction(@SqrDistance_P1, 'gr32SqrDistance', cdRegister);
end;


 
{ TPSImport_GR32_Geometry }
(*----------------------------------------------------------------------------*)
procedure TPSImport_GR32_Geometry.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_GR32_Geometry(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_GR32_Geometry.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  //RIRegister_GR32_Geometry(ri);
  RIRegister_GR32_Geometry_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
