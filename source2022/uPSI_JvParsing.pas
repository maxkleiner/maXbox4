unit uPSI_JvParsing;
{
   the home of maXcalc()  , added keyword in synpas!
   new logn, gcd
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
  TPSImport_JvParsing = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TJvMathParser(CL: TPSPascalCompiler);
procedure SIRegister_JvParsing(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_JvParsing_Routines(S: TPSExec);
procedure RIRegister_TJvMathParser(CL: TPSRuntimeClassImporter);
procedure RIRegister_JvParsing(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   JvTypes
  ,JvParsing
  ,fMain
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_JvParsing]);
end;

procedure MyWriteln2(const sln: string);
begin
  maxForm1.memo2.Lines.Add(sln);
end;

procedure maxcalcF(const acalcformat: String);
begin
  MyWriteln2(floatToStr(getFormulavalue(acalcformat)));    //also FormatLn
end;

function maxcalcS(const acalcformat: String): string;
begin
  result:= floatToStr(getFormulavalue(acalcformat));    //get back FormatLn
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TJvMathParser(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TObject', 'TJvMathParser') do
  with CL.AddClassN(CL.FindClass('TObject'),'TJvMathParser') do begin
    RegisterMethod('Function Execute( const AFormula : string) : Extended');
    RegisterMethod('Procedure RegisterUserFunction( const Name : string; Proc : TUserFunction)');
    RegisterMethod('Procedure UnregisterUserFunction( const Name : string)');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_JvParsing(CL: TPSPascalCompiler);
begin
  CL.AddTypeS('TUserFunction','function(Value: Extended): Extended;');
  CL.AddTypeS('TParserFunc', '( pfArcTan, pfCos, pfSin, pfTan, pfAbs, pfExp, pf'
   +'Ln, pfLog, pfSqrt, pfSqr, pfInt, pfFrac, pfTrunc, pfRound, pfArcSin, pfArc'
   +'Cos, pfSign, pfNot )');
  CL.AddClassN(CL.FindClass('TOBJECT'),'EJvParserError');
 // CL.AddTypeS('TUserFunction', '___Pointer');
  SIRegister_TJvMathParser(CL);
 CL.AddDelphiFunction('Function GetFormulaValue( const Formula : string) : Extended');
 //CL.AddDelphiFunction('Function JPower( Base, Exponent : Extended) : Extended');
  CL.AddDelphiFunction('Function MaxCalc( const Formula : string) : Extended');
  CL.AddDelphiFunction('procedure MCF( const Formula : string)');
 CL.AddDelphiFunction('Function FormulaValue( const Formula : string) : Extended');
  CL.AddDelphiFunction('procedure MaxCalcF( const Formula : string)');
  CL.AddDelphiFunction('function MaxCalcS( const Formula : string): string');

 end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure RIRegister_JvParsing_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@GetFormulaValue, 'GetFormulaValue', cdRegister);
 S.RegisterDelphiFunction(@GetFormulaValue, 'MaxCalc', cdRegister);
 S.RegisterDelphiFunction(@GetFormulaValue, 'FormulaValue', cdRegister);
 S.RegisterDelphiFunction(@maxCalcF, 'MCF', cdRegister);
 S.RegisterDelphiFunction(@maxCalcF, 'MaxCalcF', cdRegister);
 S.RegisterDelphiFunction(@maxCalcS, 'MaxCalcS', cdRegister);

 //S.RegisterDelphiFunction(@Power, 'JPower', cdRegister);
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJvMathParser(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJvMathParser) do begin
    RegisterMethod(@TJvMathParser.Execute, 'Execute');
    RegisterMethod(@TJvMathParser.RegisterUserFunction, 'RegisterUserFunction');
    RegisterMethod(@TJvMathParser.UnregisterUserFunction, 'UnregisterUserFunction');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_JvParsing(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(EJvParserError) do
  RIRegister_TJvMathParser(CL);
end;

 
 
{ TPSImport_JvParsing }
(*----------------------------------------------------------------------------*)
procedure TPSImport_JvParsing.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_JvParsing(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_JvParsing.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_JvParsing(ri);
  RIRegister_JvParsing_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
