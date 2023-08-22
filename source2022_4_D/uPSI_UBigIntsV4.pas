unit uPSI_UBigIntsV4;
{
  another real bigint with operators and class operator   , bigdiv!
  see also unit uPSI_xrtl_math_Integer;
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
  TPSImport_UBigIntsV4 = class(TPSPlugin)
  public
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TInteger(CL: TPSPascalCompiler);
procedure SIRegister_UBigIntsV4(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_UBigIntsV4_Routines(S: TPSExec);
procedure RIRegister_TInteger(CL: TPSRuntimeClassImporter);
procedure RIRegister_UBigIntsV4(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   Forms
  ,Dialogs
  ,Windows
  ,UBigIntsV4
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_UBigIntsV4]);
end;

function BigDiv(aone, atwo: string): string;
var tbig1, tbig2: TInteger;
begin
  tbig1:= TInteger.create(10);
  tbig2:= TInteger.create(10);
  try
    tbig1.assign(atwo);
    tbig2.assign(aone);
    tbig2.Divide(tbig1)
  finally
    result:= tbig2.ConvertToDecimalString(false);
    tbig1.Free;
    tbig2.free;
  end;
end;

function bigdiv2(aval1: string; aval2: integer): string;
var atbig: TInteger;
begin
  atbig:= TInteger.create(1);
  atbig.assign(aval1);
  //atbig.pow(234);
  atbig.divide(aval2);
  //atbig.getnextprime;
  //atbig.ModPow(atbig,atbig);
  result:= atbig.ConvertToDecimalString(false);
  atbig.free;
end;

function modbig(aval: string; amod: integer): integer;   //bigmod
var atbig: TInteger;
begin
  atbig:= TInteger.create(1);
  atbig.assign(aval);
  //atbig.pow(234);
  atbig.modulo(amod);
  //atbig.getnextprime;
  //atbig.ModPow(atbig,atbig);
  result:= strtoint(atbig.ConvertToDecimalString(false));
  atbig.free;
end;

function modPowBig3(aval, apow, amod: string): string;    //bigpowmod()
var atbig, atbig2, atbig3: TInteger;
begin
  atbig:= TInteger.create(1);
  atbig.assign(aval);
  atbig2:= TInteger.create(1);
  atbig2.assign(apow);
  atbig3:= TInteger.create(1);
  atbig3.assign(amod);
  atbig.ModPow(atbig2,atbig3);
  //atbig.invmod(10);
  result:= atbig.ConvertToDecimalString(false);
  atbig.free;
  atbig2.free;
  atbig3.free;
end; 




function BigFib(n: integer): string;
  var tbig1, tbig2, tbig3: TInteger;
     i: integer;
  begin
    result:= '0';
    tbig1:= TInteger.create(1);  //temp
    tbig2:= TInteger.create(0);  //result (a)
    tbig3:= Tinteger.create(1);  //b
    for i:= 1 to n do begin
    	tbig1.assign(tbig2);
	   tbig2.assign(tbig3);
	   tbig1.add(tbig3);
	   tbig3.assign(tbig1);
	 end;
    result:= tbig2.ConvertToDecimalString(false);
    tbig3.free;
    tbig2.free;
    tbig1.free;
  end;

  function BigFac(n: integer): string;
  var tbig1: TInteger;
  begin
    result:= '0';
    tbig1:= TInteger.create(n);  //temp
    //tbig1.assign(tbig2)
	   tbig1.factorial;
    result:= tbig1.ConvertToDecimalString(false);
    tbig1.free; 
  end; 

  function BigPow(aone, atwo: integer): string;
  var tbig1, tbig2: TInteger;
  begin
    tbig1:= TInteger.create(aone);
  //tbig2:= TInteger.create(10);
  try
    tbig1.pow(atwo);
  finally
    result:= tbig1.ConvertToDecimalString(false);
    tbig1.Free;
  end;
end;



(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TInteger(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TObject', 'TInteger') do
  with CL.AddClassN(CL.FindClass('TObject'),'TInteger') do begin
    RegisterMethod('Constructor Create( const initialValue : int64)');
    RegisterMethod('Constructor Create1');
    RegisterMethod('Procedure Free');
    RegisterProperty('Digits', 'TDigits', iptr);
    RegisterMethod('Procedure Assign( const I2 : TInteger);');
    RegisterMethod('Procedure Assign1( const I2 : int64);');
    RegisterMethod('Procedure Assign2( const I2 : string);');
    RegisterMethod('Procedure AbsoluteValue');
    RegisterMethod('Procedure Add( const I2 : TInteger);');
    RegisterMethod('Procedure Add1( const I2 : int64);');
    RegisterMethod('Procedure AssignZero');
    RegisterMethod('Procedure AssignOne');
    RegisterMethod('Procedure Subtract( const I2 : TInteger);');
    RegisterMethod('Procedure Subtract1( const I2 : int64);');
    RegisterMethod('Procedure Mult( const I2 : TInteger);');
    RegisterMethod('Procedure Mult1( const I2 : int64);');
    RegisterMethod('Procedure FastMult( const I2 : TInteger)');
    RegisterMethod('Procedure Divide( const I2 : TInteger);');
    RegisterMethod('Procedure Divide1( const I2 : int64);');
    RegisterMethod('Procedure Modulo( const I2 : TInteger);');
    RegisterMethod('Procedure Modulo1( const N : int64);');
    RegisterMethod('Procedure ModPow( const I2, m : TInteger)');
    RegisterMethod('Procedure InvMod( I2 : TInteger)');
    RegisterMethod('Procedure DivideRem( const I2 : TInteger; var remain : TInteger)');
    RegisterMethod('Procedure DivideRemTrunc( const I2 : TInteger; var remain : TInteger)');
    RegisterMethod('Procedure DivideRemFloor( const I2 : TInteger; var remain : TInteger)');
    RegisterMethod('Procedure DivideRemEuclidean( const I2 : TInteger; var remain : TInteger)');
    RegisterMethod('Function Compare( I2 : TInteger) : integer;');
    RegisterMethod('Function Compare1( I2 : int64) : integer;');
    RegisterMethod('Procedure Factorial');
    RegisterMethod('Function ConvertToDecimalString( commas : boolean) : string');
    RegisterMethod('Function ToString( commas : boolean) : string');
    RegisterMethod('Function ConvertToInt64( var N : int64) : boolean');
    RegisterMethod('Function DigitCount : integer');
    RegisterMethod('Procedure SetSign( s : integer)');
    RegisterMethod('Function GetSign : integer');
    RegisterMethod('Function IsOdd : boolean');
    RegisterMethod('Function IsPositive : boolean');
    RegisterMethod('Function IsNegative : boolean');
    RegisterMethod('Function IsProbablyPrime : boolean');
    RegisterMethod('Function IsZero : boolean');
    RegisterMethod('Procedure ChangeSign');
    RegisterMethod('Procedure Pow( const exponent : int64);');
    RegisterMethod('Procedure Sqroot');
    RegisterMethod('Procedure Square');
    RegisterMethod('Procedure FastSquare');
    RegisterMethod('Procedure Gcd( const I2 : TInteger);');
    RegisterMethod('Procedure Gcd1( const I2 : int64);');
    RegisterMethod('Procedure NRoot( const Root : int64);');
    RegisterMethod('Function GetBase : integer');
    RegisterMethod('Function BitCount : integer');
    RegisterMethod('Function ConvertToHexString : String');
    RegisterMethod('Function AssignRandomPrime( BitLength : integer; seed : String; mustMatchBitLength : boolean) : boolean');
    RegisterMethod('Function AssignHex( HexStr : String) : boolean');
    RegisterMethod('Procedure RandomOfSize( size : integer)');
    RegisterMethod('Procedure Random( maxint : TInteger)');
    RegisterMethod('Procedure Getnextprime');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_UBigIntsV4(CL: TPSPascalCompiler);
begin
  CL.AddTypeS('TDigits', 'array of int64');
  SIRegister_TInteger(CL);
 CL.AddDelphiFunction('Procedure SetBaseVal( const newbase : integer)');
 CL.AddDelphiFunction('Function GetBasePower : integer');
 CL.AddDelphiFunction('Function GetBase : integer');
 CL.AddDelphiFunction('Procedure SetThreadSafe( newval : boolean)');
 CL.AddDelphiFunction('function BigDiv(aone, atwo: string): string;');
 CL.AddDelphiFunction('function BigFib(n: integer): string;');
 CL.AddDelphiFunction('function BigFac(n: integer): string;');
 CL.AddDelphiFunction('function BigFibo(n: integer): string;');
 CL.AddDelphiFunction('function BigFact(n: integer): string;');
 CL.AddDelphiFunction('function BigPow(aone, atwo: integer): string;');
 CL.AddDelphiFunction('function BigPower(aone, atwo: integer): string;');

 CL.AddDelphiFunction('function bigdiv2(aval1: string; aval2: integer): string;');
CL.AddDelphiFunction('function modbig(aval: string; amod: integer): integer; ');
CL.AddDelphiFunction('function bigmod(aval: string; amod: integer): integer; ');

CL.AddDelphiFunction('function modPowBig3(aval, apow, amod: string): string;');
CL.AddDelphiFunction('function BigPowMod(aval, apow, amod: string): string;');
CL.AddDelphiFunction('function RSAEncrypt(aval, apow, amod: string): string;');
CL.AddDelphiFunction('function RSADecrypt(aval, apow, amod: string): string;');
CL.AddDelphiFunction('function EncryptRSA(aval, apow, amod: string): string;');
CL.AddDelphiFunction('function DecryptRSA(aval, apow, amod: string): string;');

 //function bigdiv2(aval1: string; aval2: integer): string;
//function modbig(aval: string; amod: integer): integer;   //bigmod
//function modPowBig3(aval, apow, amod: string): string;    //bigpowmod()


 //function BigFac(n: integer): string;


 end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
Procedure TIntegerNRoot_P(Self: TInteger;  const Root : int64);
Begin Self.NRoot(Root); END;

(*----------------------------------------------------------------------------*)
Procedure TIntegerGcd1_P(Self: TInteger;  const I2 : int64);
Begin Self.Gcd(I2); END;

(*----------------------------------------------------------------------------*)
Procedure TIntegerGcd_P(Self: TInteger;  const I2 : TInteger);
Begin Self.Gcd(I2); END;

(*----------------------------------------------------------------------------*)
Procedure TIntegerPow_P(Self: TInteger;  const exponent : int64);
Begin Self.Pow(exponent); END;

(*----------------------------------------------------------------------------*)
Function TIntegerCompare1_P(Self: TInteger;  I2 : int64) : integer;
Begin Result := Self.Compare(I2); END;

(*----------------------------------------------------------------------------*)
Function TIntegerCompare_P(Self: TInteger;  I2 : TInteger) : integer;
Begin Result := Self.Compare(I2); END;

(*----------------------------------------------------------------------------*)
Procedure TIntegerModulo1_P(Self: TInteger;  const N : int64);
Begin Self.Modulo(N); END;

(*----------------------------------------------------------------------------*)
Procedure TIntegerModulo_P(Self: TInteger;  const I2 : TInteger);
Begin Self.Modulo(I2); END;

(*----------------------------------------------------------------------------*)
Procedure TIntegerDivide1_P(Self: TInteger;  const I2 : int64);
Begin Self.Divide(I2); END;

(*----------------------------------------------------------------------------*)
Procedure TIntegerDivide_P(Self: TInteger;  const I2 : TInteger);
Begin Self.Divide(I2); END;

(*----------------------------------------------------------------------------*)
Procedure TIntegerMult1_P(Self: TInteger;  const I2 : int64);
Begin Self.Mult(I2); END;

(*----------------------------------------------------------------------------*)
Procedure TIntegerMult_P(Self: TInteger;  const I2 : TInteger);
Begin Self.Mult(I2); END;

(*----------------------------------------------------------------------------*)
Procedure TIntegerSubtract1_P(Self: TInteger;  const I2 : int64);
Begin Self.Subtract(I2); END;

(*----------------------------------------------------------------------------*)
Procedure TIntegerSubtract_P(Self: TInteger;  const I2 : TInteger);
Begin Self.Subtract(I2); END;

(*----------------------------------------------------------------------------*)
Procedure TIntegerAdd1_P(Self: TInteger;  const I2 : int64);
Begin Self.Add(I2); END;

(*----------------------------------------------------------------------------*)
Procedure TIntegerAdd_P(Self: TInteger;  const I2 : TInteger);
Begin Self.Add(I2); END;

(*----------------------------------------------------------------------------*)
Procedure TIntegerAssign2_P(Self: TInteger;  const I2 : string);
Begin Self.Assign(I2); END;

(*----------------------------------------------------------------------------*)
Procedure TIntegerAssign1_P(Self: TInteger;  const I2 : int64);
Begin Self.Assign(I2); END;

(*----------------------------------------------------------------------------*)
Procedure TIntegerAssign_P(Self: TInteger;  const I2 : TInteger);
Begin Self.Assign(I2); END;

(*----------------------------------------------------------------------------*)
procedure TIntegerDigits_R(Self: TInteger; var T: TDigits);
begin T := Self.Digits; end;

(*----------------------------------------------------------------------------*)
Function TIntegerAbsCompare1_P(Self: TInteger;  I2 : int64) : integer;
Begin //Result := Self.AbsCompare(I2);
END;

(*----------------------------------------------------------------------------*)
Function TIntegerAbsCompare_P(Self: TInteger;  I2 : TInteger) : integer;
Begin //Result := Self.AbsCompare(I2);
END;

(*----------------------------------------------------------------------------*)
procedure RIRegister_UBigIntsV4_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@SetBaseVal, 'SetBaseVal', cdRegister);
 S.RegisterDelphiFunction(@GetBasePower, 'GetBasePower', cdRegister);
 S.RegisterDelphiFunction(@GetBase, 'GetBase', cdRegister);
 S.RegisterDelphiFunction(@SetThreadSafe, 'SetThreadSafe', cdRegister);
 S.RegisterDelphiFunction(@BigDiv, 'BigDiv', cdRegister);
 S.RegisterDelphiFunction(@BigFib, 'BigFib', cdRegister);
 S.RegisterDelphiFunction(@BigFac, 'BigFac', cdRegister);
 S.RegisterDelphiFunction(@BigFib, 'BigFibo', cdRegister);
 S.RegisterDelphiFunction(@BigFac, 'BigFact', cdRegister);
 S.RegisterDelphiFunction(@BigPow, 'BigPow', cdRegister);
 S.RegisterDelphiFunction(@BigPow, 'BigPower', cdRegister);

 S.RegisterDelphiFunction(@bigdiv2, 'bigdiv2', cdRegister);
 S.RegisterDelphiFunction(@modbig, 'modbig', cdRegister);
S.RegisterDelphiFunction(@modbig, 'bigmod', cdRegister);
S.RegisterDelphiFunction(@modPowBig3, 'modPowBig3', cdRegister);
S.RegisterDelphiFunction(@modPowBig3, 'BigPowMod', cdRegister);
S.RegisterDelphiFunction(@modPowBig3, 'RSAEncrypt', cdRegister);
S.RegisterDelphiFunction(@modPowBig3, 'RSADecrypt', cdRegister);
S.RegisterDelphiFunction(@modPowBig3, 'EncryptRSA', cdRegister);
S.RegisterDelphiFunction(@modPowBig3, 'DecryptRSA', cdRegister);


 { CL.AddDelphiFunction('function bigdiv2(aval1: string; aval2: integer): string;');
CL.AddDelphiFunction('function modbig(aval: string; amod: integer): integer; ');
CL.AddDelphiFunction('function bigmod(aval: string; amod: integer): integer; ');

CL.AddDelphiFunction('function modPowBig3(aval, apow, amod: string): string;');
CL.AddDelphiFunction('function BigPowMod(aval, apow, amod: string): string;');
 }

 // function BigPow(aone, atwo: integer): string;



end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TInteger(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TInteger) do begin
   // RegisterConstructor(@TInteger.Create1, 'Create1');
    RegisterConstructor(@TInteger.Create, 'Create');
    RegisterMethod(@TInteger.Free, 'Free');
    RegisterConstructor(@TInteger.Create1, 'Create1');
    RegisterPropertyHelper(@TIntegerDigits_R,nil,'Digits');
    RegisterMethod(@TIntegerAssign_P, 'Assign');
    RegisterMethod(@TIntegerAssign1_P, 'Assign1');
    RegisterMethod(@TIntegerAssign2_P, 'Assign2');
    RegisterMethod(@TInteger.AbsoluteValue, 'AbsoluteValue');
    RegisterMethod(@TIntegerAdd_P, 'Add');
    RegisterMethod(@TIntegerAdd1_P, 'Add1');
    RegisterMethod(@TInteger.AssignZero, 'AssignZero');
    RegisterMethod(@TInteger.AssignOne, 'AssignOne');
    RegisterMethod(@TIntegerSubtract_P, 'Subtract');
    RegisterMethod(@TIntegerSubtract1_P, 'Subtract1');
    RegisterMethod(@TIntegerMult_P, 'Mult');
    RegisterMethod(@TIntegerMult1_P, 'Mult1');
    RegisterMethod(@TInteger.FastMult, 'FastMult');
    RegisterMethod(@TIntegerDivide_P, 'Divide');
    RegisterMethod(@TIntegerDivide1_P, 'Divide1');
    RegisterMethod(@TIntegerModulo_P, 'Modulo');
    RegisterMethod(@TIntegerModulo1_P, 'Modulo1');
    RegisterMethod(@TInteger.ModPow, 'ModPow');
    RegisterMethod(@TInteger.InvMod, 'InvMod');
    RegisterMethod(@TInteger.DivideRem, 'DivideRem');
    RegisterMethod(@TInteger.DivideRemTrunc, 'DivideRemTrunc');
    RegisterMethod(@TInteger.DivideRemFloor, 'DivideRemFloor');
    RegisterMethod(@TInteger.DivideRemEuclidean, 'DivideRemEuclidean');
    RegisterMethod(@TIntegerCompare_P, 'Compare');
    RegisterMethod(@TIntegerCompare1_P, 'Compare1');
    RegisterMethod(@TInteger.Factorial, 'Factorial');
    RegisterMethod(@TInteger.ConvertToDecimalString, 'ConvertToDecimalString');
    RegisterMethod(@TInteger.ConvertToDecimalString, 'ToString');
    RegisterMethod(@TInteger.ConvertToInt64, 'ConvertToInt64');
    RegisterMethod(@TInteger.DigitCount, 'DigitCount');
    RegisterMethod(@TInteger.SetSign, 'SetSign');
    RegisterMethod(@TInteger.GetSign, 'GetSign');
    RegisterMethod(@TInteger.IsOdd, 'IsOdd');
    RegisterMethod(@TInteger.IsPositive, 'IsPositive');
    RegisterMethod(@TInteger.IsNegative, 'IsNegative');
    RegisterMethod(@TInteger.IsProbablyPrime, 'IsProbablyPrime');
    RegisterMethod(@TInteger.IsZero, 'IsZero');
    RegisterMethod(@TInteger.ChangeSign, 'ChangeSign');
    RegisterMethod(@TIntegerPow_P, 'Pow');
    RegisterMethod(@TInteger.Sqroot, 'Sqroot');
    RegisterMethod(@TInteger.Square, 'Square');
    RegisterMethod(@TInteger.FastSquare, 'FastSquare');
    RegisterMethod(@TIntegerGcd_P, 'Gcd');
    RegisterMethod(@TIntegerGcd1_P, 'Gcd1');
    RegisterMethod(@TIntegerNRoot_P, 'NRoot');
    RegisterMethod(@TInteger.GetBase, 'GetBase');
    RegisterMethod(@TInteger.BitCount, 'BitCount');
    RegisterMethod(@TInteger.ConvertToHexString, 'ConvertToHexString');
    RegisterMethod(@TInteger.AssignRandomPrime, 'AssignRandomPrime');
    RegisterMethod(@TInteger.AssignHex, 'AssignHex');
    RegisterMethod(@TInteger.RandomOfSize, 'RandomOfSize');
    RegisterMethod(@TInteger.Random, 'Random');
    RegisterMethod(@TInteger.Getnextprime, 'Getnextprime');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_UBigIntsV4(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TInteger(CL);
end;

 
 
{ TPSImport_UBigIntsV4 }
(*----------------------------------------------------------------------------*)
procedure TPSImport_UBigIntsV4.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_UBigIntsV4(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_UBigIntsV4.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_UBigIntsV4(ri);
  RIRegister_UBigIntsV4_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
