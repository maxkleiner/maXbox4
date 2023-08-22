unit uPSI_cRandom;
{

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
  TPSImport_cRandom = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_cRandom(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_cRandom_Routines(S: TPSExec);

procedure Register;

implementation


uses
   cRandom
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_cRandom]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_cRandom(CL: TPSPascalCompiler);
begin
 CL.AddDelphiFunction('Function RandomSeed : LongWord');
 CL.AddDelphiFunction('Procedure AddEntropy( const Value : LongWord)');
 CL.AddDelphiFunction('Function RandomUniform : LongWord;');
 CL.AddDelphiFunction('Function RandomUniform1( const N : Integer) : Integer;');
 CL.AddDelphiFunction('Function RandomBoolean : Boolean');
 CL.AddDelphiFunction('Function RandomByte : Byte');
 CL.AddDelphiFunction('Function RandomByteNonZero : Byte');
 CL.AddDelphiFunction('Function RandomWord : Word');
 CL.AddDelphiFunction('Function RandomInt64 : Int64;');
 CL.AddDelphiFunction('Function RandomInt641( const N : Int64) : Int64;');
 CL.AddDelphiFunction('Function RandomHex( const Digits : Integer) : String');
 CL.AddDelphiFunction('Function RandomFloat : Extended');
 CL.AddDelphiFunction('Function FRandom : Extended');
 CL.AddDelphiFunction('Function RandomAlphaStr( const Length : Integer) : AnsiString');
 CL.AddDelphiFunction('Function RandomPseudoWord( const Length : Integer) : AnsiString');
 CL.AddDelphiFunction('Function RandomPassword( const MinLength, MaxLength : Integer; const CaseSensitive, UseSymbols, UseNumbers : Boolean) : AnsiString');
 CL.AddDelphiFunction('Function mwcRandomLongWord : LongWord');
 CL.AddDelphiFunction('Function urnRandomLongWord : LongWord');
 CL.AddDelphiFunction('Function moaRandomFloat : Extended');
 CL.AddDelphiFunction('Function mwcRandomFloat : Extended');
 CL.AddDelphiFunction('Function RandomNormalF : Extended');
 CL.AddDelphiFunction('Procedure SelfTestCRandom');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
Function RandomInt641_P( const N : Int64) : Int64;
Begin Result := cRandom.RandomInt64(N); END;

(*----------------------------------------------------------------------------*)
Function RandomInt64_P : Int64;
Begin Result := cRandom.RandomInt64; END;

(*----------------------------------------------------------------------------*)
Function RandomUniform1_P( const N : Integer) : Integer;
Begin Result := cRandom.RandomUniform(N); END;

(*----------------------------------------------------------------------------*)
Function RandomUniform_P : LongWord;
Begin Result := cRandom.RandomUniform; END;

(*----------------------------------------------------------------------------*)
procedure RIRegister_cRandom_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@RandomSeed, 'RandomSeed', cdRegister);
 S.RegisterDelphiFunction(@AddEntropy, 'AddEntropy', cdRegister);
 S.RegisterDelphiFunction(@RandomUniform, 'RandomUniform', cdRegister);
 S.RegisterDelphiFunction(@RandomUniform1_P, 'RandomUniform1', cdRegister);
 S.RegisterDelphiFunction(@RandomBoolean, 'RandomBoolean', cdRegister);
 S.RegisterDelphiFunction(@RandomByte, 'RandomByte', cdRegister);
 S.RegisterDelphiFunction(@RandomByteNonZero, 'RandomByteNonZero', cdRegister);
 S.RegisterDelphiFunction(@RandomWord, 'RandomWord', cdRegister);
 S.RegisterDelphiFunction(@RandomInt64, 'RandomInt64', cdRegister);
 S.RegisterDelphiFunction(@RandomInt641_P, 'RandomInt641', cdRegister);
 S.RegisterDelphiFunction(@RandomHex, 'RandomHex', cdRegister);
 S.RegisterDelphiFunction(@RandomFloat, 'RandomFloat', cdRegister);
 S.RegisterDelphiFunction(@RandomFloat, 'FRandom', cdRegister);
 S.RegisterDelphiFunction(@RandomAlphaStr, 'RandomAlphaStr', cdRegister);
 S.RegisterDelphiFunction(@RandomPseudoWord, 'RandomPseudoWord', cdRegister);
 S.RegisterDelphiFunction(@RandomPassword, 'RandomPassword', cdRegister);
 S.RegisterDelphiFunction(@mwcRandomLongWord, 'mwcRandomLongWord', cdRegister);
 S.RegisterDelphiFunction(@urnRandomLongWord, 'urnRandomLongWord', cdRegister);
 S.RegisterDelphiFunction(@moaRandomFloat, 'moaRandomFloat', cdRegister);
 S.RegisterDelphiFunction(@mwcRandomFloat, 'mwcRandomFloat', cdRegister);
 S.RegisterDelphiFunction(@RandomNormalF, 'RandomNormalF', cdRegister);
 S.RegisterDelphiFunction(@SelfTest, 'SelfTestCRandom', cdRegister);
end;

 
 
{ TPSImport_cRandom }
(*----------------------------------------------------------------------------*)
procedure TPSImport_cRandom.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_cRandom(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_cRandom.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  //RIRegister_cRandom(ri);
  RIRegister_cRandom_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
