unit uPSI_ubigFloatV3;
{
   in the end bigdecimal
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
  TPSImport_ubigFloatV3 = class(TPSPlugin)
  public
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;


{ compile-time registration functions }
procedure SIRegister_TBigFloat(CL: TPSPascalCompiler);
procedure SIRegister_TFloatInt(CL: TPSPascalCompiler);
procedure SIRegister_ubigFloatV3(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TBigFloat(CL: TPSRuntimeClassImporter);
procedure RIRegister_TFloatInt(CL: TPSRuntimeClassImporter);
procedure RIRegister_ubigFloatV3(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   Dialogs
  ,Forms
  ,UBigIntsForFloatV4
  ,Windows
  ,ubigFloatV3
  ;


procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_ubigFloatV3]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TBigFloat(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TObject', 'TBigFloat') do
  with CL.AddClassN(CL.FindClass('TObject'),'TBigFloat') do begin
    RegisterProperty('decpart', 'TFloatInt', iptrw);
    RegisterProperty('sigdigits', 'word', iptrw);
    RegisterProperty('exponent', 'integer', iptrw);
    RegisterMethod('Constructor Create;');
    RegisterMethod('Constructor Create1( const MaxSig : TMaxSig);');
    RegisterMethod('Procedure Free');
    RegisterMethod('Procedure Assign( A : TBigFloat);');
    RegisterMethod('Procedure Assign3( A : TBigFloat; SigDig : word);');
    RegisterMethod('Procedure Assign4( A : TInteger);');
    RegisterMethod('Procedure Assign5( N : int64);');
    RegisterMethod('Procedure Assign6( N : int64; SigDig : integer);');
    RegisterMethod('Procedure Assign7( d : extended);');
    RegisterMethod('Procedure Assign8( S : string);');
    RegisterMethod('Procedure Assign9( S : string; SigDig : word);');
    RegisterMethod('Procedure AssignZero');
    RegisterMethod('Procedure AssignOne');
    RegisterMethod('Procedure Add( B : TBigFloat);');
    RegisterMethod('Procedure Add1( B : int64);');
    RegisterMethod('Procedure AbsAdd( B : TBigFloat)');
    RegisterMethod('Procedure Subtract( B : TBigFloat);');
    RegisterMethod('Procedure Subtract1( B : int64);');
    RegisterMethod('Procedure Mult( B : TBigFloat);');
    RegisterMethod('Procedure Mult1( B : TBigfloat; const MaxSig : TMaxSig);');
    RegisterMethod('Procedure Mult2( B : TInteger);');
    RegisterMethod('Procedure Mult3( B : int64);');
    RegisterMethod('Procedure MultRaw( B : TBigFloat)');
    RegisterMethod('Procedure Reciprocal( const MaxSig : TMaxSig)');
    RegisterMethod('Procedure Divide( B : TBigFloat; const MaxSig : TMaxSig);');
    RegisterMethod('Procedure Divide1( B : TInteger; const MaxSig : TMaxSig);');
    RegisterMethod('Procedure Divide2( B : int64; const MaxSig : TMaxSig);');
    RegisterMethod('Procedure Square( const MaxSig : TMaxSig)');
    RegisterMethod('Function Compare( B : TBigFloat) : integer');
    RegisterMethod('Function IsZero : boolean');
    RegisterMethod('Procedure MaxBigFloat( B : TBigFloat)');
    RegisterMethod('Procedure MinBigFloat( B : TBigFloat)');
    RegisterMethod('Procedure Sqrt;');
    RegisterMethod('Procedure Sqrt1( const MaxSig : TMaxSig);');
    RegisterMethod('Procedure NRoot( N : integer; const MaxSig : TMaxSig)');
    RegisterMethod('Procedure IntPower( intpower : integer; const MaxSig : TMaxSig)');
    RegisterMethod('Procedure Power( power : TBigfloat; const MaxSig : TMaxSig)');
    RegisterMethod('Procedure Log( const MaxSig : TMaxSig)');
    RegisterMethod('Procedure Log10( const MaxSig : TMaxSig)');
    RegisterMethod('Procedure Exp( const MaxSig : TMaxSig)');
    RegisterMethod('Procedure PiConst( const MaxSig : TMaxSig)');
    RegisterMethod('Procedure Log2Const( const MaxSig : TMaxSig)');
    RegisterMethod('Procedure RoundToPrec( const MaxSig : TMaxSig);');
    RegisterMethod('Procedure RoundToPrec1;');
    RegisterMethod('Procedure Trunc( const x : integer)');
    RegisterMethod('Procedure Floor( const x : integer)');
    RegisterMethod('Procedure Ceiling( const x : integer)');
    RegisterMethod('Procedure Round( const x : integer);');
    RegisterMethod('Procedure AbsoluteValue');
    RegisterMethod('Procedure Negate');
    RegisterMethod('Procedure SetSigDigits( const newsigdigits : integer)');
    RegisterMethod('Function ConvertToString( const View : TView) : string');
    RegisterMethod('Function ToString( const View : TView) : string');
    RegisterMethod('Function ConvertToExtended( var num : extended) : boolean');
    RegisterMethod('Function ConvertToInt64( var N : int64) : boolean');
    RegisterMethod('Function IntPart : int64');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TFloatInt(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TInteger', 'TFloatInt') do
  with CL.AddClassN(CL.FindClass('TInteger'),'TFloatInt') do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_ubigFloatV3(CL: TPSPascalCompiler);
begin
  CL.AddTypeS('TMaxSig', 'integer');
  CL.AddTypeS('TView', '( normal, Scientific )');
  CL.AddClassN(CL.FindClass('TOBJECT'),'TInteger');
  SIRegister_TFloatInt(CL);
  SIRegister_TBigFloat(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
Procedure TBigFloatRound_P(Self: TBigFloat;  const x : integer);
Begin Self.Round(x); END;

(*----------------------------------------------------------------------------*)
Procedure TBigFloatRoundToPrec1_P(Self: TBigFloat);
Begin Self.RoundToPrec; END;

(*----------------------------------------------------------------------------*)
Procedure TBigFloatRoundToPrec_P(Self: TBigFloat;  const MaxSig : TMaxSig);
Begin Self.RoundToPrec(MaxSig); END;

(*----------------------------------------------------------------------------*)
Procedure TBigFloatSqrt1_P(Self: TBigFloat;  const MaxSig : TMaxSig);
Begin Self.Sqrt(MaxSig); END;

(*----------------------------------------------------------------------------*)
Procedure TBigFloatSqrt_P(Self: TBigFloat);
Begin Self.Sqrt; END;

(*----------------------------------------------------------------------------*)
Procedure TBigFloatDivide2_P(Self: TBigFloat;  B : int64; const MaxSig : TMaxSig);
Begin Self.Divide(B, MaxSig); END;

(*----------------------------------------------------------------------------*)
Procedure TBigFloatDivide1_P(Self: TBigFloat;  B : TInteger; const MaxSig : TMaxSig);
Begin Self.Divide(B, MaxSig); END;

(*----------------------------------------------------------------------------*)
Procedure TBigFloatDivide_P(Self: TBigFloat;  B : TBigFloat; const MaxSig : TMaxSig);
Begin Self.Divide(B, MaxSig); END;

(*----------------------------------------------------------------------------*)
Procedure TBigFloatMult3_P(Self: TBigFloat;  B : int64);
Begin Self.Mult(B); END;

(*----------------------------------------------------------------------------*)
Procedure TBigFloatMult2_P(Self: TBigFloat;  B : TInteger);
Begin Self.Mult(B); END;

(*----------------------------------------------------------------------------*)
Procedure TBigFloatMult1_P(Self: TBigFloat;  B : TBigfloat; const MaxSig : TMaxSig);
Begin Self.Mult(B, MaxSig); END;

(*----------------------------------------------------------------------------*)
Procedure TBigFloatMult_P(Self: TBigFloat;  B : TBigFloat);
Begin Self.Mult(B); END;

(*----------------------------------------------------------------------------*)
Procedure TBigFloatSubtract1_P(Self: TBigFloat;  B : int64);
Begin Self.Subtract(B); END;

(*----------------------------------------------------------------------------*)
Procedure TBigFloatSubtract_P(Self: TBigFloat;  B : TBigFloat);
Begin Self.Subtract(B); END;

(*----------------------------------------------------------------------------*)
Procedure TBigFloatAdd1_P(Self: TBigFloat;  B : int64);
Begin Self.Add(B); END;

(*----------------------------------------------------------------------------*)
Procedure TBigFloatAdd_P(Self: TBigFloat;  B : TBigFloat);
Begin Self.Add(B); END;

(*----------------------------------------------------------------------------*)
Procedure TBigFloatAssign9_P(Self: TBigFloat;  S : string; SigDig : word);
Begin Self.Assign(S, SigDig); END;

(*----------------------------------------------------------------------------*)
Procedure TBigFloatAssign8_P(Self: TBigFloat;  S : string);
Begin Self.Assign(S); END;

(*----------------------------------------------------------------------------*)
Procedure TBigFloatAssign7_P(Self: TBigFloat;  d : extended);
Begin Self.Assign(d); END;

(*----------------------------------------------------------------------------*)
Procedure TBigFloatAssign6_P(Self: TBigFloat;  N : int64; SigDig : integer);
Begin Self.Assign(N, SigDig); END;

(*----------------------------------------------------------------------------*)
Procedure TBigFloatAssign5_P(Self: TBigFloat;  N : int64);
Begin Self.Assign(N); END;

(*----------------------------------------------------------------------------*)
Procedure TBigFloatAssign4_P(Self: TBigFloat;  A : TInteger);
Begin Self.Assign(A); END;

(*----------------------------------------------------------------------------*)
Procedure TBigFloatAssign3_P(Self: TBigFloat;  A : TBigFloat; SigDig : word);
Begin Self.Assign(A, SigDig); END;

(*----------------------------------------------------------------------------*)
Procedure TBigFloatAssign_P(Self: TBigFloat;  A : TBigFloat);
Begin Self.Assign(A); END;

(*----------------------------------------------------------------------------*)
Function TBigFloatCreate1_P(Self: TClass; CreateNewInstance: Boolean;  const MaxSig : TMaxSig):TObject;
Begin Result := TBigFloat.Create(MaxSig); END;

(*----------------------------------------------------------------------------*)
Function TBigFloatCreate_P(Self: TClass; CreateNewInstance: Boolean):TObject;
Begin Result := TBigFloat.Create; END;

(*----------------------------------------------------------------------------*)
procedure TBigFloatexponent_W(Self: TBigFloat; const T: integer);
Begin Self.exponent := T; end;

(*----------------------------------------------------------------------------*)
procedure TBigFloatexponent_R(Self: TBigFloat; var T: integer);
Begin T := Self.exponent; end;

(*----------------------------------------------------------------------------*)
procedure TBigFloatsigdigits_W(Self: TBigFloat; const T: word);
Begin Self.sigdigits := T; end;

(*----------------------------------------------------------------------------*)
procedure TBigFloatsigdigits_R(Self: TBigFloat; var T: word);
Begin T := Self.sigdigits; end;

(*----------------------------------------------------------------------------*)
procedure TBigFloatdecpart_W(Self: TBigFloat; const T: TFloatInt);
Begin Self.decpart := T; end;

(*----------------------------------------------------------------------------*)
procedure TBigFloatdecpart_R(Self: TBigFloat; var T: TFloatInt);
Begin T := Self.decpart; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TBigFloat(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TBigFloat) do
  begin
    RegisterPropertyHelper(@TBigFloatdecpart_R,@TBigFloatdecpart_W,'decpart');
    RegisterPropertyHelper(@TBigFloatsigdigits_R,@TBigFloatsigdigits_W,'sigdigits');
    RegisterPropertyHelper(@TBigFloatexponent_R,@TBigFloatexponent_W,'exponent');
    RegisterConstructor(@TBigFloatCreate_P, 'Create');
    RegisterConstructor(@TBigFloatCreate1_P, 'Create1');
    RegisterMethod(@TBigFloat.Free, 'Free');
    RegisterMethod(@TBigFloatAssign_P, 'Assign');
    RegisterMethod(@TBigFloatAssign3_P, 'Assign3');
    RegisterMethod(@TBigFloatAssign4_P, 'Assign4');
    RegisterMethod(@TBigFloatAssign5_P, 'Assign5');
    RegisterMethod(@TBigFloatAssign6_P, 'Assign6');
    RegisterMethod(@TBigFloatAssign7_P, 'Assign7');
    RegisterMethod(@TBigFloatAssign8_P, 'Assign8');
    RegisterMethod(@TBigFloatAssign9_P, 'Assign9');
    RegisterMethod(@TBigFloat.AssignZero, 'AssignZero');
    RegisterMethod(@TBigFloat.AssignOne, 'AssignOne');
    RegisterMethod(@TBigFloatAdd_P, 'Add');
    RegisterMethod(@TBigFloatAdd1_P, 'Add1');
    RegisterMethod(@TBigFloat.AbsAdd, 'AbsAdd');
    RegisterMethod(@TBigFloatSubtract_P, 'Subtract');
    RegisterMethod(@TBigFloatSubtract1_P, 'Subtract1');
    RegisterMethod(@TBigFloatMult_P, 'Mult');
    RegisterMethod(@TBigFloatMult1_P, 'Mult1');
    RegisterMethod(@TBigFloatMult2_P, 'Mult2');
    RegisterMethod(@TBigFloatMult3_P, 'Mult3');
    RegisterMethod(@TBigFloat.MultRaw, 'MultRaw');
    RegisterMethod(@TBigFloat.Reciprocal, 'Reciprocal');
    RegisterMethod(@TBigFloatDivide_P, 'Divide');
    RegisterMethod(@TBigFloatDivide1_P, 'Divide1');
    RegisterMethod(@TBigFloatDivide2_P, 'Divide2');
    RegisterMethod(@TBigFloat.Square, 'Square');
    RegisterMethod(@TBigFloat.Compare, 'Compare');
    RegisterMethod(@TBigFloat.IsZero, 'IsZero');
    RegisterMethod(@TBigFloat.MaxBigFloat, 'MaxBigFloat');
    RegisterMethod(@TBigFloat.MinBigFloat, 'MinBigFloat');
    RegisterMethod(@TBigFloatSqrt_P, 'Sqrt');
    RegisterMethod(@TBigFloatSqrt1_P, 'Sqrt1');
    RegisterMethod(@TBigFloat.NRoot, 'NRoot');
    RegisterMethod(@TBigFloat.IntPower, 'IntPower');
    RegisterMethod(@TBigFloat.Power, 'Power');
    RegisterMethod(@TBigFloat.Log, 'Log');
    RegisterMethod(@TBigFloat.Log10, 'Log10');
    RegisterMethod(@TBigFloat.Exp, 'Exp');
    RegisterMethod(@TBigFloat.PiConst, 'PiConst');
    RegisterMethod(@TBigFloat.Log2Const, 'Log2Const');
    RegisterMethod(@TBigFloatRoundToPrec_P, 'RoundToPrec');
    RegisterMethod(@TBigFloatRoundToPrec1_P, 'RoundToPrec1');
    RegisterMethod(@TBigFloat.Trunc, 'Trunc');
    RegisterMethod(@TBigFloat.Floor, 'Floor');
    RegisterMethod(@TBigFloat.Ceiling, 'Ceiling');
    RegisterMethod(@TBigFloatRound_P, 'Round');
    RegisterMethod(@TBigFloat.AbsoluteValue, 'AbsoluteValue');
    RegisterMethod(@TBigFloat.Negate, 'Negate');
    RegisterMethod(@TBigFloat.SetSigDigits, 'SetSigDigits');
    RegisterMethod(@TBigFloat.ConvertToString, 'ConvertToString');
    RegisterMethod(@TBigFloat.ConvertToString, 'ToString');      //alias
    RegisterMethod(@TBigFloat.ConvertToExtended, 'ConvertToExtended');
    RegisterMethod(@TBigFloat.ConvertToInt64, 'ConvertToInt64');
    RegisterMethod(@TBigFloat.IntPart, 'IntPart');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TFloatInt(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TFloatInt) do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_ubigFloatV3(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TFloatInt(CL);
  RIRegister_TBigFloat(CL);
end;

 
 
{ TPSImport_ubigFloatV3 }
(*----------------------------------------------------------------------------*)
procedure TPSImport_ubigFloatV3.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_ubigFloatV3(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_ubigFloatV3.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_ubigFloatV3(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
