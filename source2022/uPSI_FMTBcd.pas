unit uPSI_FMTBcd;
{
This file has been generated by UnitParser v0.7, written by M. Knight
and updated by NP. v/d Spek and George Birbilis. 
Source Code from Carlo Kok has been used to implement various sections of
UnitParser. Components of ROPS are used in the construction of UnitParser,
code implementing the class wrapper is taken from Carlo Kok's conv utility

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
  TPSImport_FMTBcd = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_FMTBcd(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_FMTBcd_Routines(S: TPSExec);
procedure RIRegister_FMTBcd(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   Variants
  ,FMTBcd
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_FMTBcd]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_FMTBcd(CL: TPSPascalCompiler);
begin
 CL.AddConstantN('MaxStringDigits','LongInt').SetInt( 100);
 CL.AddConstantN('_NoDecimal','LongInt').SetInt( - 255);
 CL.AddConstantN('_DefaultDecimals','LongInt').SetInt( 10);
 CL.AddConstantN('MaxFMTBcdFractionSize','LongInt').SetInt( 64);
 CL.AddConstantN('MaxFMTBcdDigits','LongInt').SetInt( 32);
 CL.AddConstantN('DefaultFMTBcdScale','LongInt').SetInt( 6);
 CL.AddConstantN('MaxBcdPrecision','LongInt').SetInt( 18);
 CL.AddConstantN('MaxBcdScale','LongInt').SetInt( 4);
 CL.AddConstantN('SizeOfFraction','LongInt').SetInt( 32);
  //CL.AddTypeS('PBcd', '^TBcd // will not work');
  CL.AddTypeS('TBcd', 'record Precision: Byte; SignSpecialPlaces: Byte; Fraction: array [0..31] of Byte; end');
 // CL.AddTypeS('TBytes','array of Byte');
  CL.AddClassN(CL.FindClass('TOBJECT'),'EBcdException');
  CL.AddClassN(CL.FindClass('TOBJECT'),'EBcdOverflowException');
 CL.AddDelphiFunction('Function BcdFromBytes( const AValue : TBytes) : TBcd');
 CL.AddDelphiFunction('Function BcdToBytes( const Value : TBcd) : TBytes');
 CL.AddDelphiFunction('Function BcdPrecision( const Bcd : TBcd) : Word');
 CL.AddDelphiFunction('Function BcdScale( const Bcd : TBcd) : Word');
 CL.AddDelphiFunction('Function IsBcdNegative( const Bcd : TBcd) : Boolean');
 CL.AddDelphiFunction('Procedure BcdAdd( const bcdIn1, bcdIn2 : TBcd; var bcdOut : TBcd)');
 CL.AddDelphiFunction('Procedure BcdSubtract( const bcdIn1, bcdIn2 : TBcd; var bcdOut : TBcd)');
 CL.AddDelphiFunction('Function NormalizeBcd( const InBcd : TBcd; var OutBcd : TBcd; const Prec, Scale : Word) : Boolean');
 CL.AddDelphiFunction('Procedure BcdMultiply( const bcdIn1, bcdIn2 : TBcd; var bcdOut : TBcd);');
 CL.AddDelphiFunction('Procedure BcdMultiply1( const bcdIn : TBcd; const DoubleIn : Double; var bcdOut : TBcd);');
 CL.AddDelphiFunction('Procedure BcdMultiply2( const bcdIn : TBcd; const StringIn : string; var bcdOut : TBcd);');
 CL.AddDelphiFunction('Procedure BcdMultiply3( StringIn1, StringIn2 : string; var bcdOut : TBcd);');
 CL.AddDelphiFunction('Procedure BcdDivide( Dividend, Divisor : string; var bcdOut : TBcd);');
 CL.AddDelphiFunction('Procedure BcdDivide1( const Dividend, Divisor : TBcd; var bcdOut : TBcd);');
 CL.AddDelphiFunction('Procedure BcdDivide2( const Dividend : TBcd; const Divisor : Double; var bcdOut : TBcd);');
 CL.AddDelphiFunction('Procedure BcdDivide3( const Dividend : TBcd; const Divisor : string; var bcdOut : TBcd);');
 CL.AddDelphiFunction('Procedure VarFMTBcdCreate( var ADest : Variant; const ABcd : TBcd);');
 CL.AddDelphiFunction('Function VarFMTBcdCreate1 : Variant;');
 CL.AddDelphiFunction('Function VarFMTBcdCreate2( const AValue : string; Precision, Scale : Word) : Variant;');
 CL.AddDelphiFunction('Function VarFMTBcdCreate3( const AValue : Double; Precision : Word; Scale : Word) : Variant;');
 CL.AddDelphiFunction('Function VarFMTBcdCreate4( const ABcd : TBcd) : Variant;');
 CL.AddDelphiFunction('Function VarIsFMTBcd( const AValue : Variant) : Boolean;');
 CL.AddDelphiFunction('Function VarFMTBcd : TVarType');
 CL.AddDelphiFunction('Function StrToBcd( const AValue : string) : TBcd');
 CL.AddDelphiFunction('Function TryStrToBcd( const AValue : string; var Bcd : TBcd) : Boolean');
 CL.AddDelphiFunction('Function DoubleToBcd( const AValue : Double) : TBcd;');
 CL.AddDelphiFunction('Procedure DoubleToBcd1( const AValue : Double; var bcd : TBcd);');
 CL.AddDelphiFunction('Function IntegerToBcd( const AValue : Integer) : TBcd');
 CL.AddDelphiFunction('Function VarToBcd( const AValue : Variant) : TBcd');
 CL.AddDelphiFunction('Function CurrToBCD( const Curr : Currency; var BCD : TBcd; Precision : Integer; Decimals : Integer) : Boolean');
 CL.AddDelphiFunction('Function OldCurrToBCD( const Curr : Currency; var BCD : TBcd; Precision : Integer; Decimals : Integer) : Boolean');
 CL.AddDelphiFunction('Function BcdToStr( const Bcd : TBcd) : string;');
 CL.AddDelphiFunction('Function BcdToDouble( const Bcd : TBcd) : Double');
 CL.AddDelphiFunction('Function BcdToInteger( const Bcd : TBcd; Truncate : Boolean) : Integer');
 CL.AddDelphiFunction('Function OldBCDToCurr( const BCD : TBcd; var Curr : Currency) : Boolean');
 CL.AddDelphiFunction('Function BCDToCurr( const BCD : TBcd; var Curr : Currency) : Boolean');
 CL.AddDelphiFunction('Function BcdToStrF( const Bcd : TBcd; Format : TFloatFormat; const Precision, Digits : Integer) : string');
 CL.AddDelphiFunction('Function FormatBcd( const Format : string; Bcd : TBcd) : string');
 CL.AddDelphiFunction('Function BcdCompare( const bcd1, bcd2 : TBcd) : Integer');
 CL.AddDelphiFunction('Function RoundAt( const Value : string; Position : SmallInt) : string');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
Function BcdToStr_P( const Bcd : TBcd) : string;
Begin Result := FMTBcd.BcdToStr(Bcd); END;

(*----------------------------------------------------------------------------*)
Procedure DoubleToBcd1_P( const AValue : Double; var bcd : TBcd);
Begin FMTBcd.DoubleToBcd(AValue, bcd); END;

(*----------------------------------------------------------------------------*)
Function DoubleToBcd_P( const AValue : Double) : TBcd;
Begin Result := FMTBcd.DoubleToBcd(AValue); END;

(*----------------------------------------------------------------------------*)
Function VarIsFMTBcd_P( const AValue : Variant) : Boolean;
Begin Result := FMTBcd.VarIsFMTBcd(AValue); END;

(*----------------------------------------------------------------------------*)
Function VarFMTBcdCreate4_P( const ABcd : TBcd) : Variant;
Begin Result := FMTBcd.VarFMTBcdCreate(ABcd); END;

(*----------------------------------------------------------------------------*)
Function VarFMTBcdCreate3_P( const AValue : Double; Precision : Word; Scale : Word) : Variant;
Begin Result := FMTBcd.VarFMTBcdCreate(AValue, Precision, Scale); END;

(*----------------------------------------------------------------------------*)
Function VarFMTBcdCreate2_P( const AValue : string; Precision, Scale : Word) : Variant;
Begin Result := FMTBcd.VarFMTBcdCreate(AValue, Precision, Scale); END;

(*----------------------------------------------------------------------------*)
Function VarFMTBcdCreate1_P : Variant;
Begin Result := FMTBcd.VarFMTBcdCreate; END;

(*----------------------------------------------------------------------------*)
Procedure VarFMTBcdCreate_P( var ADest : Variant; const ABcd : TBcd);
Begin FMTBcd.VarFMTBcdCreate(ADest, ABcd); END;

(*----------------------------------------------------------------------------*)
Procedure BcdDivide3_P( const Dividend : TBcd; const Divisor : string; var bcdOut : TBcd);
Begin FMTBcd.BcdDivide(Dividend, Divisor, bcdOut); END;

(*----------------------------------------------------------------------------*)
Procedure BcdDivide2_P( const Dividend : TBcd; const Divisor : Double; var bcdOut : TBcd);
Begin FMTBcd.BcdDivide(Dividend, Divisor, bcdOut); END;

(*----------------------------------------------------------------------------*)
Procedure BcdDivide1_P( const Dividend, Divisor : TBcd; var bcdOut : TBcd);
Begin FMTBcd.BcdDivide(Dividend, Divisor, bcdOut); END;

(*----------------------------------------------------------------------------*)
Procedure BcdDivide_P( Dividend, Divisor : string; var bcdOut : TBcd);
Begin FMTBcd.BcdDivide(Dividend, Divisor, bcdOut); END;

(*----------------------------------------------------------------------------*)
Procedure BcdMultiply3_P( StringIn1, StringIn2 : string; var bcdOut : TBcd);
Begin FMTBcd.BcdMultiply(StringIn1, StringIn2, bcdOut); END;

(*----------------------------------------------------------------------------*)
Procedure BcdMultiply2_P( const bcdIn : TBcd; const StringIn : string; var bcdOut : TBcd);
Begin FMTBcd.BcdMultiply(bcdIn, StringIn, bcdOut); END;

(*----------------------------------------------------------------------------*)
Procedure BcdMultiply1_P( const bcdIn : TBcd; const DoubleIn : Double; var bcdOut : TBcd);
Begin FMTBcd.BcdMultiply(bcdIn, DoubleIn, bcdOut); END;

(*----------------------------------------------------------------------------*)
Procedure BcdMultiply_P( const bcdIn1, bcdIn2 : TBcd; var bcdOut : TBcd);
Begin FMTBcd.BcdMultiply(bcdIn1, bcdIn2, bcdOut); END;

(*----------------------------------------------------------------------------*)
procedure RIRegister_FMTBcd_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@BcdFromBytes, 'BcdFromBytes', cdRegister);
 S.RegisterDelphiFunction(@BcdToBytes, 'BcdToBytes', cdRegister);
 S.RegisterDelphiFunction(@BcdPrecision, 'BcdPrecision', cdRegister);
 S.RegisterDelphiFunction(@BcdScale, 'BcdScale', cdRegister);
 S.RegisterDelphiFunction(@IsBcdNegative, 'IsBcdNegative', cdRegister);
 S.RegisterDelphiFunction(@BcdAdd, 'BcdAdd', cdRegister);
 S.RegisterDelphiFunction(@BcdSubtract, 'BcdSubtract', cdRegister);
 S.RegisterDelphiFunction(@NormalizeBcd, 'NormalizeBcd', cdRegister);
 S.RegisterDelphiFunction(@BcdMultiply, 'BcdMultiply', cdRegister);
 S.RegisterDelphiFunction(@BcdMultiply1_P, 'BcdMultiply1', cdRegister);
 S.RegisterDelphiFunction(@BcdMultiply2_P, 'BcdMultiply2', cdRegister);
 S.RegisterDelphiFunction(@BcdMultiply3_P, 'BcdMultiply3', cdRegister);
 S.RegisterDelphiFunction(@BcdDivide, 'BcdDivide', cdRegister);
 S.RegisterDelphiFunction(@BcdDivide1_P, 'BcdDivide1', cdRegister);
 S.RegisterDelphiFunction(@BcdDivide2_P, 'BcdDivide2', cdRegister);
 S.RegisterDelphiFunction(@BcdDivide3_P, 'BcdDivide3', cdRegister);
 S.RegisterDelphiFunction(@VarFMTBcdCreate, 'VarFMTBcdCreate', cdRegister);
 S.RegisterDelphiFunction(@VarFMTBcdCreate1_P, 'VarFMTBcdCreate1', cdRegister);
 S.RegisterDelphiFunction(@VarFMTBcdCreate2_P, 'VarFMTBcdCreate2', cdRegister);
 S.RegisterDelphiFunction(@VarFMTBcdCreate3_P, 'VarFMTBcdCreate3', cdRegister);
 S.RegisterDelphiFunction(@VarFMTBcdCreate4_P, 'VarFMTBcdCreate4', cdRegister);
 S.RegisterDelphiFunction(@VarIsFMTBcd, 'VarIsFMTBcd', cdRegister);
 S.RegisterDelphiFunction(@VarFMTBcd, 'VarFMTBcd', cdRegister);
 S.RegisterDelphiFunction(@StrToBcd, 'StrToBcd', cdRegister);
 S.RegisterDelphiFunction(@TryStrToBcd, 'TryStrToBcd', cdRegister);
 S.RegisterDelphiFunction(@DoubleToBcd, 'DoubleToBcd', cdRegister);
 S.RegisterDelphiFunction(@DoubleToBcd1_P, 'DoubleToBcd1', cdRegister);
 S.RegisterDelphiFunction(@IntegerToBcd, 'IntegerToBcd', cdRegister);
 S.RegisterDelphiFunction(@VarToBcd, 'VarToBcd', cdRegister);
 S.RegisterDelphiFunction(@CurrToBCD, 'CurrToBCD', cdRegister);
 S.RegisterDelphiFunction(@OldCurrToBCD, 'OldCurrToBCD', cdRegister);
 S.RegisterDelphiFunction(@BcdToStr, 'BcdToStr', cdRegister);
 S.RegisterDelphiFunction(@BcdToDouble, 'BcdToDouble', cdRegister);
 S.RegisterDelphiFunction(@BcdToInteger, 'BcdToInteger', cdRegister);
 S.RegisterDelphiFunction(@OldBCDToCurr, 'OldBCDToCurr', cdRegister);
 S.RegisterDelphiFunction(@BCDToCurr, 'BCDToCurr', cdRegister);
 S.RegisterDelphiFunction(@BcdToStrF, 'BcdToStrF', cdRegister);
 S.RegisterDelphiFunction(@FormatBcd, 'FormatBcd', cdRegister);
 S.RegisterDelphiFunction(@BcdCompare, 'BcdCompare', cdRegister);
 S.RegisterDelphiFunction(@RoundAt, 'RoundAt', cdRegister);
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_FMTBcd(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(EBcdException) do
  with CL.Add(EBcdOverflowException) do
end;

 
 
{ TPSImport_FMTBcd }
(*----------------------------------------------------------------------------*)
procedure TPSImport_FMTBcd.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_FMTBcd(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_FMTBcd.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_FMTBcd(ri);
  RIRegister_FMTBcd_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
