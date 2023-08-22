unit uPSI_JclMath;
{
  free method and all virtual methods add
  register only classes
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
  TPSImport_JclMath = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_EJclNaNSignal(CL: TPSPascalCompiler);
procedure SIRegister_TJclRational(CL: TPSPascalCompiler);
procedure SIRegister_TJclSparseFlatSet(CL: TPSPascalCompiler);
procedure SIRegister_TJclFlatSet(CL: TPSPascalCompiler);
procedure SIRegister_TJclASet(CL: TPSPascalCompiler);
procedure SIRegister_JclMath(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_EJclNaNSignal(CL: TPSRuntimeClassImporter);
procedure RIRegister_TJclRational(CL: TPSRuntimeClassImporter);
procedure RIRegister_TJclSparseFlatSet(CL: TPSRuntimeClassImporter);
procedure RIRegister_TJclFlatSet(CL: TPSRuntimeClassImporter);
procedure RIRegister_TJclASet(CL: TPSRuntimeClassImporter);
procedure RIRegister_JclMath(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
  // JclUnitVersioning
  JclBase
  ,JclMath
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_JclMath]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_EJclNaNSignal(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'EJclMathError', 'EJclNaNSignal') do
  with CL.AddClassN(CL.FindClass('EJclMathError'),'EJclNaNSignal') do begin
    RegisterMethod('Constructor Create( ATag : TNaNTag; Dummy : Boolean)');
    RegisterProperty('Tag', 'TNaNTag', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TJclRational(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TObject', 'TJclRational') do
  with CL.AddClassN(CL.FindClass('TObject'),'TJclRational') do begin
    RegisterMethod('Constructor Create;');
    RegisterMethod('Constructor Create1( const R : Float);');
    RegisterMethod('Constructor Create2( const Numerator : Integer; const Denominator : Integer);');
    RegisterProperty('Numerator', 'Integer', iptr);
    RegisterProperty('Denominator', 'Integer', iptr);
    RegisterProperty('AsString', 'string', iptrw);
    RegisterProperty('AsFloat', 'Float', iptrw);
    RegisterMethod('Procedure Assign( const R : TJclRational);');
    RegisterMethod('Procedure Assign1( const R : Float);');
    RegisterMethod('Procedure Assign2( const Numerator : Integer; const Denominator : Integer);');
    RegisterMethod('Procedure AssignZero');
    RegisterMethod('Procedure AssignOne');
    RegisterMethod('Function Duplicate : TJclRational');
    RegisterMethod('Function IsEqual( const R : TJclRational) : Boolean;');
    RegisterMethod('Function IsEqual1( const Numerator : Integer; const Denominator : Integer) : Boolean;');
    RegisterMethod('Function IsEqual2( const R : Float) : Boolean;');
    RegisterMethod('Function IsZero : Boolean');
    RegisterMethod('Function IsOne : Boolean');
    RegisterMethod('Procedure Add( const R : TJclRational);');
    RegisterMethod('Procedure Add1( const V : Float);');
    RegisterMethod('Procedure Add2( const V : Integer);');
    RegisterMethod('Procedure Subtract( const R : TJclRational);');
    RegisterMethod('Procedure Subtract1( const V : Float);');
    RegisterMethod('Procedure Subtract2( const V : Integer);');
    RegisterMethod('Procedure Negate');
    RegisterMethod('Procedure Abs');
    RegisterMethod('Function Sgn : Integer');
    RegisterMethod('Procedure Multiply( const R : TJclRational);');
    RegisterMethod('Procedure Multiply1( const V : Float);');
    RegisterMethod('Procedure Multiply2( const V : Integer);');
    RegisterMethod('Procedure Reciprocal');
    RegisterMethod('Procedure Divide( const R : TJclRational);');
    RegisterMethod('Procedure Divide1( const V : Float);');
    RegisterMethod('Procedure Divide2( const V : Integer);');
    RegisterMethod('Procedure Sqrt');
    RegisterMethod('Procedure Sqr');
    RegisterMethod('Procedure Power( const R : TJclRational);');
    RegisterMethod('Procedure Power1( const V : Integer);');
    RegisterMethod('Procedure Power2( const V : Float);');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TJclSparseFlatSet(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TJclASet', 'TJclSparseFlatSet') do
  with CL.AddClassN(CL.FindClass('TJclASet'),'TJclSparseFlatSet') do begin
    RegisterMethod('Constructor Create');
   RegisterMethod('Procedure Free');
    RegisterMethod('procedure Clear');
    RegisterMethod('procedure Invert');
    RegisterMethod('procedure SetRange(const Low, High: Integer; const Value: Boolean)');
    RegisterMethod('function GetBit(const Idx: Integer): Boolean');
    RegisterMethod('function GetRange(const Low, High: Integer; const Value: Boolean): Boolean');
    RegisterMethod('procedure SetBit(const Idx: Integer; const Value: Boolean)');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TJclFlatSet(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TJclASet', 'TJclFlatSet') do
  with CL.AddClassN(CL.FindClass('TJclASet'),'TJclFlatSet') do begin
    RegisterMethod('Constructor Create');
   RegisterMethod('Procedure Free');
    RegisterMethod('procedure Clear');
    RegisterMethod('procedure Invert');
    RegisterMethod('procedure SetRange(const Low, High: Integer; const Value: Boolean)');
    RegisterMethod('function GetBit(const Idx: Integer): Boolean');
    RegisterMethod('function GetRange(const Low, High: Integer; const Value: Boolean): Boolean');
    RegisterMethod('procedure SetBit(const Idx: Integer; const Value: Boolean)');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TJclASet(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TObject', 'TJclASet') do
  with CL.AddClassN(CL.FindClass('TObject'),'TJclASet') do begin
    RegisterMethod('Function GetBit( const Idx : Integer) : Boolean');
    RegisterMethod('Procedure SetBit( const Idx : Integer; const Value : Boolean)');
    RegisterMethod('Procedure Clear');
    RegisterMethod('Procedure Invert');
    RegisterMethod('Function GetRange( const Low, High : Integer; const Value : Boolean) : Boolean');
    RegisterMethod('Procedure SetRange( const Low, High : Integer; const Value : Boolean)');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_JclMath(CL: TPSPascalCompiler);
begin
{ CL.AddConstantN('Bernstein','Float').SetString( 0.2801694990238691330364364912307);
 CL.AddConstantN('Cbrt2','Float').SetString( 1.2599210498948731647672106072782);
 CL.AddConstantN('Cbrt3','Float').SetString( 1.4422495703074083823216383107801);
 CL.AddConstantN('Cbrt10','Float').SetString( 2.1544346900318837217592935665194);
 CL.AddConstantN('Cbrt100','Float').SetString( 4.6415888336127788924100763509194);
 CL.AddConstantN('CbrtPi','Float').SetString( 1.4645918875615232630201425272638);
 CL.AddConstantN('Catalan','Float').SetString( 0.9159655941772190150546035149324);
 CL.AddConstantN('Pi','Float').SetString( 3.1415926535897932384626433832795);
 CL.AddConstantN('PiOn2','Float').SetString( 1.5707963267948966192313216916398);
 CL.AddConstantN('PiOn3','Float').SetString( 1.0471975511965977461542144610932);
 CL.AddConstantN('PiOn4','Float').SetString( 0.78539816339744830961566084581988);
 CL.AddConstantN('Sqrt2','Float').SetString( 1.4142135623730950488016887242097);
 CL.AddConstantN('Sqrt3','Float').SetString( 1.7320508075688772935274463415059);
 CL.AddConstantN('Sqrt5','Float').SetString( 2.2360679774997896964091736687313);
 CL.AddConstantN('Sqrt10','Float').SetString( 3.1622776601683793319988935444327);
 CL.AddConstantN('SqrtPi','Float').SetString( 1.7724538509055160272981674833411);
 CL.AddConstantN('Sqrt2Pi','Float').SetString( 2.506628274631000502415765284811);
 CL.AddConstantN('TwoPi','Float').SetString( 6.283185307179586476925286766559);
 CL.AddConstantN('ThreePi','Float').SetString( 9.4247779607693797153879301498385);
 CL.AddConstantN('Ln2','Float').SetString( 0.69314718055994530941723212145818);
 CL.AddConstantN('Ln10','Float').SetString( 2.3025850929940456840179914546844);
 CL.AddConstantN('LnPi','Float').SetString( 1.1447298858494001741434273513531);
 CL.AddConstantN('Log2','Float').SetString( 0.30102999566398119521373889472449);
 CL.AddConstantN('Log3','Float').SetString( 0.47712125471966243729502790325512);
 CL.AddConstantN('LogPi','Float').SetString( 0.4971498726941338543512682882909);
 CL.AddConstantN('LogE','Float').SetString( 0.43429448190325182765112891891661);
 CL.AddConstantN('E','Float').SetString( 2.7182818284590452353602874713527);
 CL.AddConstantN('hLn2Pi','Float').SetString( 0.91893853320467274178032973640562);
 CL.AddConstantN('inv2Pi','Float').SetString( 0.15915494309189533576888376337251436203445964574046);
 CL.AddConstantN('TwoToPower63','Float').SetString( 9223372036854775808.0);
 CL.AddConstantN('GoldenMean','Float').SetString( 1.618033988749894848204586834365638);
 CL.AddConstantN('EulerMascheroni','Float').SetString( 0.5772156649015328606065120900824);
 CL.AddConstantN('MaxAngle','Float').SetString( 9223372036854775808.0);
 CL.AddConstantN('MaxTanH','Float').SetString( 5678.2617031470719747459655389854);
 CL.AddConstantN('MaxFactorial','LongInt').SetInt( 1754);
 CL.AddConstantN('MaxFloatingPoint','Float').SetString( 1.189731495357231765085759326628E+4932);
 CL.AddConstantN('MinFloatingPoint','Float').SetString( 3.3621031431120935062626778173218E-4932);
 CL.AddConstantN('MaxTanH','Float').SetString( 354.89135644669199842162284618659);
 CL.AddConstantN('MaxFactorial','LongInt').SetInt( 170);
 CL.AddConstantN('MaxFloatingPoint','Float').SetString( 1.797693134862315907729305190789E+308);
 CL.AddConstantN('MinFloatingPoint','Float').SetString( 2.2250738585072013830902327173324E-308);
 CL.AddConstantN('MaxTanH','Float').SetString( 44.361419555836499802702855773323);
 CL.AddConstantN('MaxFactorial','LongInt').SetInt( 33);
 CL.AddConstantN('MaxFloatingPoint','Float').SetString( 3.4028236692093846346337460743177E+38);
 CL.AddConstantN('MinFloatingPoint','Float').SetString( 1.1754943508222875079687365372222E-38);
 CL.AddConstantN('PiExt','Extended').setExtended( 3.1415926535897932384626433832795);
 CL.AddConstantN('RatioDegToRad','Extended').setExtended( PiExt / 180.0);
 CL.AddConstantN('RatioGradToRad','Extended').setExtended( PiExt / 200.0);
 CL.AddConstantN('RatioDegToGrad','Extended').setExtended( 200.0 / 180.0);
 CL.AddConstantN('RatioGradToDeg','Extended').setExtended( 180.0 / 200.0);
  CL.AddTypeS('TPrimalityTestMethod', '( ptTrialDivision, ptRabinMiller )');
 CL.AddDelphiFunction('Procedure SwapOrd( var X, Y : Integer)');
 CL.AddDelphiFunction('Function DoubleToHex( const D : Double) : string');
 CL.AddDelphiFunction('Function HexToDouble( const Hex : string) : Double');
 CL.AddDelphiFunction('Function DegToRad( const Value : Extended) : Extended;');
 CL.AddDelphiFunction('Function DegToRad1( const Value : Double) : Double;');
 CL.AddDelphiFunction('Function DegToRad2( const Value : Single) : Single;');
 CL.AddDelphiFunction('Procedure FastDegToRad');
 CL.AddDelphiFunction('Function RadToDeg( const Value : Extended) : Extended;');
 CL.AddDelphiFunction('Function RadToDeg1( const Value : Double) : Double;');
 CL.AddDelphiFunction('Function RadToDeg2( const Value : Single) : Single;');
 CL.AddDelphiFunction('Procedure FastRadToDeg');
 CL.AddDelphiFunction('Function GradToRad( const Value : Extended) : Extended;');
 CL.AddDelphiFunction('Function GradToRad1( const Value : Double) : Double;');
 CL.AddDelphiFunction('Function GradToRad2( const Value : Single) : Single;');
 CL.AddDelphiFunction('Procedure FastGradToRad');
 CL.AddDelphiFunction('Function RadToGrad( const Value : Extended) : Extended;');
 CL.AddDelphiFunction('Function RadToGrad1( const Value : Double) : Double;');
 CL.AddDelphiFunction('Function RadToGrad2( const Value : Single) : Single;');
 CL.AddDelphiFunction('Procedure FastRadToGrad');
 CL.AddDelphiFunction('Function DegToGrad( const Value : Extended) : Extended;');
 CL.AddDelphiFunction('Function DegToGrad1( const Value : Double) : Double;');
 CL.AddDelphiFunction('Function DegToGrad2( const Value : Single) : Single;');
 CL.AddDelphiFunction('Procedure FastDegToGrad');
 CL.AddDelphiFunction('Function GradToDeg( const Value : Extended) : Extended;');
 CL.AddDelphiFunction('Function GradToDeg1( const Value : Double) : Double;');
 CL.AddDelphiFunction('Function GradToDeg2( const Value : Single) : Single;');
 CL.AddDelphiFunction('Procedure FastGradToDeg');
 CL.AddDelphiFunction('Function LogBase10( X : Float) : Float');
 CL.AddDelphiFunction('Function LogBase2( X : Float) : Float');
 CL.AddDelphiFunction('Function LogBaseN( Base, X : Float) : Float');
 CL.AddDelphiFunction('Function ArcCos( X : Float) : Float');
 CL.AddDelphiFunction('Function ArcCot( X : Float) : Float');
 CL.AddDelphiFunction('Function ArcCsc( X : Float) : Float');
 CL.AddDelphiFunction('Function ArcSec( X : Float) : Float');
 CL.AddDelphiFunction('Function ArcSin( X : Float) : Float');
 CL.AddDelphiFunction('Function ArcTan( X : Float) : Float');
 CL.AddDelphiFunction('Function ArcTan2( Y, X : Float) : Float');
 CL.AddDelphiFunction('Function Cos( X : Float) : Float');
 CL.AddDelphiFunction('Function Cot( X : Float) : Float');
 CL.AddDelphiFunction('Function Coversine( X : Float) : Float');
 CL.AddDelphiFunction('Function Csc( X : Float) : Float');
 CL.AddDelphiFunction('Function Exsecans( X : Float) : Float');
 CL.AddDelphiFunction('Function Haversine( X : Float) : Float');
 CL.AddDelphiFunction('Function Sec( X : Float) : Float');
 CL.AddDelphiFunction('Function Sin( X : Float) : Float');
 CL.AddDelphiFunction('Procedure SinCos( X : Double; out Sin, Cos : Double)');
 CL.AddDelphiFunction('Procedure SinCosE( X : Extended; out Sin, Cos : Extended)');
 CL.AddDelphiFunction('Function Tan( X : Float) : Float');
 CL.AddDelphiFunction('Function Versine( X : Float) : Float');
 CL.AddDelphiFunction('Function DegMinSecToFloat( const Degs, Mins, Secs : Float) : Float');
 CL.AddDelphiFunction('Procedure FloatToDegMinSec( const X : Float; var Degs, Mins, Secs : Float)');
 CL.AddDelphiFunction('Function Exp( const X : Float) : Float;');
 CL.AddDelphiFunction('Function Power( const Base, Exponent : Float) : Float;');
 CL.AddDelphiFunction('Function PowerInt( const X : Float; N : Integer) : Float;');
 CL.AddDelphiFunction('Function TenToY( const Y : Float) : Float');
 CL.AddDelphiFunction('Function TruncPower( const Base, Exponent : Float) : Float');
 CL.AddDelphiFunction('Function TwoToY( const Y : Float) : Float');
 CL.AddDelphiFunction('Function IsFloatZero( const X : Float) : Boolean');
 CL.AddDelphiFunction('Function FloatsEqual( const X, Y : Float) : Boolean');
 CL.AddDelphiFunction('Function MaxFloat( const X, Y : Float) : Float');
 CL.AddDelphiFunction('Function MinFloat( const X, Y : Float) : Float');
 CL.AddDelphiFunction('Function ModFloat( const X, Y : Float) : Float');
 CL.AddDelphiFunction('Function RemainderFloat( const X, Y : Float) : Float');
 CL.AddDelphiFunction('Function SetPrecisionTolerance( NewTolerance : Float) : Float');
 CL.AddDelphiFunction('Procedure SwapFloats( var X, Y : Float)');
 CL.AddDelphiFunction('Procedure CalcMachineEpsSingle');
 CL.AddDelphiFunction('Procedure CalcMachineEpsDouble');
 CL.AddDelphiFunction('Procedure CalcMachineEpsExtended');
 CL.AddDelphiFunction('Procedure CalcMachineEps');
 CL.AddDelphiFunction('Procedure SetPrecisionToleranceToEpsilon');
 CL.AddDelphiFunction('Function Ackermann( const A, B : Integer) : Integer');
 CL.AddDelphiFunction('Function Ceiling( const X : Float) : Integer');
 CL.AddDelphiFunction('Function CommercialRound( const X : Float) : Int64');
 CL.AddDelphiFunction('Function Factorial( const N : Integer) : Float');
 CL.AddDelphiFunction('Function Fibonacci( const N : Integer) : Integer');
 CL.AddDelphiFunction('Function Floor( const X : Float) : Integer');
 CL.AddDelphiFunction('Function GCD( X, Y : Cardinal) : Cardinal');
 CL.AddDelphiFunction('Function ISqrt( const I : Smallint) : Smallint');
 CL.AddDelphiFunction('Function LCM( const X, Y : Cardinal) : Cardinal');
 CL.AddDelphiFunction('Function NormalizeAngle( const Angle : Float) : Float');
 CL.AddDelphiFunction('Function Pythagoras( const X, Y : Float) : Float');
 CL.AddDelphiFunction('Function Sgn( const X : Float) : Integer');
 CL.AddDelphiFunction('Function Signe( const X, Y : Float) : Float');
 CL.AddDelphiFunction('Function EnsureRange( const AValue, AMin, AMax : Integer) : Integer;');
 CL.AddDelphiFunction('Function EnsureRange1( const AValue, AMin, AMax : Int64) : Int64;');
 CL.AddDelphiFunction('Function EnsureRange2( const AValue, AMin, AMax : Double) : Double;');
 CL.AddDelphiFunction('Function IsRelativePrime( const X, Y : Cardinal) : Boolean');
 CL.AddDelphiFunction('Function IsPrimeTD( N : Cardinal) : Boolean');
 CL.AddDelphiFunction('Function IsPrimeRM( N : Cardinal) : Boolean');
 CL.AddDelphiFunction('Function IsPrimeFactor( const F, N : Cardinal) : Boolean');
 CL.AddDelphiFunction('Function PrimeFactors( N : Cardinal) : TDynCardinalArray');
 CL.AddDelphiFunction('Procedure SetPrimalityTest( const Method : TPrimalityTestMethod)');
  CL.AddTypeS('TFloatingPointClass', '( fpZero, fpNormal, fpDenormal, fpInfinit'
   +'e, fpNaN, fpInvalid, fpEmpty )');
 CL.AddConstantN('Infinity','LongInt').SetInt( 1 / 0);
 CL.AddConstantN('NaN','LongInt').SetInt( 0 / 0);
 CL.AddDelphiFunction('Function FloatingPointClass( const Value : Single) : TFloatingPointClass;');
 CL.AddDelphiFunction('Function FloatingPointClass1( const Value : Double) : TFloatingPointClass;');
 CL.AddDelphiFunction('Function FloatingPointClass2( const Value : Extended) : TFloatingPointClass;');
  CL.AddTypeS('TNaNTag', 'Integer');
 CL.AddConstantN('LowValidNaNTag','LongWord').SetUInt( - $3FFFFF);
 CL.AddConstantN('HighValidNaNTag','LongWord').SetUInt( $3FFFFE);
 CL.AddDelphiFunction('Function IsInfinite( const Value : Single) : Boolean;');
 CL.AddDelphiFunction('Function IsInfinite1( const Value : Double) : Boolean;');
 CL.AddDelphiFunction('Function IsInfinite2( const Value : Extended) : Boolean;');
 CL.AddDelphiFunction('Function IsNaN( const Value : Single) : Boolean;');
 CL.AddDelphiFunction('Function IsNaN1( const Value : Double) : Boolean;');
 CL.AddDelphiFunction('Function IsNaN2( const Value : Extended) : Boolean;');
 CL.AddDelphiFunction('Function IsSpecialValue( const X : Float) : Boolean');
 CL.AddDelphiFunction('Procedure MakeQuietNaN( var X : Single; Tag : TNaNTag);');
 CL.AddDelphiFunction('Procedure MakeQuietNaN1( var X : Double; Tag : TNaNTag);');
 CL.AddDelphiFunction('Procedure MakeQuietNaN2( var X : Extended; Tag : TNaNTag);');
 CL.AddDelphiFunction('Procedure MakeSignalingNaN( var X : Single; Tag : TNaNTag);');
 CL.AddDelphiFunction('Procedure MakeSignalingNaN1( var X : Double; Tag : TNaNTag);');
 CL.AddDelphiFunction('Procedure MakeSignalingNaN2( var X : Extended; Tag : TNaNTag);');
 CL.AddDelphiFunction('Procedure MineSingleBuffer( var Buffer, Count : Integer; StartTag : TNaNTag)');
 CL.AddDelphiFunction('Procedure MineDoubleBuffer( var Buffer, Count : Integer; StartTag : TNaNTag)');
 CL.AddDelphiFunction('Function MinedSingleArray( Length : Integer) : TDynSingleArray');
 CL.AddDelphiFunction('Function MinedDoubleArray( Length : Integer) : TDynDoubleArray');
 CL.AddDelphiFunction('Function GetNaNTag( const NaN : Single) : TNaNTag;');
 CL.AddDelphiFunction('Function GetNaNTag1( const NaN : Double) : TNaNTag;');
 CL.AddDelphiFunction('Function GetNaNTag2( const NaN : Extended) : TNaNTag;'); }
  SIRegister_TJclASet(CL);
  SIRegister_TJclFlatSet(CL);
  //CL.AddTypeS('PPointerArray', '^TPointerArray // will not work');
  //CL.AddTypeS('TDelphiSet', 'set of Byte');
  //CL.AddTypeS('PDelphiSet', '^TDelphiSet // will not work');
 //CL.AddConstantN('EmptyDelphiSet','TDelphiSet').SetString();
  SIRegister_TJclSparseFlatSet(CL);
  SIRegister_TJclRational(CL);
  CL.AddClassN(CL.FindClass('TOBJECT'),'EJclMathError');
  SIRegister_EJclNaNSignal(CL);
 {CL.AddDelphiFunction('Procedure DomainCheck( Err : Boolean)');
 CL.AddDelphiFunction('Function GetParity( Buffer : TDynByteArray; Len : Integer) : Boolean;');
 CL.AddDelphiFunction('Function GetParity1( Buffer : PByte; Len : Integer) : Boolean;');
 CL.AddConstantN('Crc16PolynomCCITT','LongWord').SetUInt( $1021);
 CL.AddConstantN('Crc16PolynomIBM','LongWord').SetUInt( $8005);
 CL.AddConstantN('Crc16Bits','LongInt').SetInt( 16);
 CL.AddConstantN('Crc16Bytes','LongInt').SetInt( 2);
 CL.AddConstantN('Crc16HighBit','LongWord').SetUInt( $8000);
 CL.AddConstantN('NotCrc16HighBit','LongWord').SetUInt( $7FFF);
 CL.AddDelphiFunction('Function Crc16_P( X : PJclByteArray; N : Integer; Crc : Word) : Word;');
 CL.AddDelphiFunction('Function Crc16( const X : array of Byte; N : Integer; Crc : Word) : Word;');
 CL.AddDelphiFunction('Function Crc16_A( const X : array of Byte; Crc : Word) : Word;');
 CL.AddDelphiFunction('Function CheckCrc16_P( X : PJclByteArray; N : Integer; Crc : Word) : Integer;');
 CL.AddDelphiFunction('Function CheckCrc16( var X : array of Byte; N : Integer; Crc : Word) : Integer;');
 CL.AddDelphiFunction('Function CheckCrc16_A( var X : array of Byte; Crc : Word) : Integer;');
 CL.AddDelphiFunction('Procedure InitCrc16( Polynom, Start : Word);');
 CL.AddDelphiFunction('Function Crc16_P( const Crc16Table : TCrc16Table; X : PJclByteArray; N : Integer; Crc : Word) : Word;');
 CL.AddDelphiFunction('Function Crc16( const Crc16Table : TCrc16Table; const X : array of Byte; N : Integer; Crc : Word) : Word;');
 CL.AddDelphiFunction('Function Crc16_A( const Crc16Table : TCrc16Table; const X : array of Byte; Crc : Word) : Word;');
 CL.AddDelphiFunction('Function CheckCrc16_P( const Crc16Table : TCrc16Table; X : PJclByteArray; N : Integer; Crc : Word) : Integer;');
 CL.AddDelphiFunction('Function CheckCrc16( const Crc16Table : TCrc16Table; var X : array of Byte; N : Integer; Crc : Word) : Integer;');
 CL.AddDelphiFunction('Function CheckCrc16_A( const Crc16Table : TCrc16Table; var X : array of Byte; Crc : Word) : Integer;');
 CL.AddDelphiFunction('Procedure InitCrc16( Polynom, Start : Word; out Crc16Table : TCrc16Table);');
 CL.AddConstantN('Crc32PolynomIEEE','LongWord').SetUInt( $04C11DB7);
 CL.AddConstantN('Crc32PolynomCastagnoli','LongWord').SetUInt( $1EDC6F41);
 CL.AddConstantN('Crc32Koopman','LongWord').SetUInt( $741B8CD7);
 CL.AddConstantN('Crc32Bits','LongInt').SetInt( 32);
 CL.AddConstantN('Crc32Bytes','LongInt').SetInt( 4);
 CL.AddConstantN('Crc32HighBit','LongWord').SetUInt( $80000000);
 CL.AddConstantN('NotCrc32HighBit','LongWord').SetUInt( $7FFFFFFF);
 CL.AddDelphiFunction('Function Crc32_P( X : PJclByteArray; N : Integer; Crc : Cardinal) : Cardinal;');
 CL.AddDelphiFunction('Function Crc32( const X : array of Byte; N : Integer; Crc : Cardinal) : Cardinal;');
 CL.AddDelphiFunction('Function Crc32_A( const X : array of Byte; Crc : Cardinal) : Cardinal;');
 CL.AddDelphiFunction('Function CheckCrc32_P( X : PJclByteArray; N : Integer; Crc : Cardinal) : Integer;');
 CL.AddDelphiFunction('Function CheckCrc32( var X : array of Byte; N : Integer; Crc : Cardinal) : Integer;');
 CL.AddDelphiFunction('Function CheckCrc32_A( var X : array of Byte; Crc : Cardinal) : Integer;');
 CL.AddDelphiFunction('Procedure InitCrc32( Polynom, Start : Cardinal);');
 CL.AddDelphiFunction('Function Crc32_P( const Crc32Table : TCrc32Table; X : PJclByteArray; N : Integer; Crc : Cardinal) : Cardinal;');
 CL.AddDelphiFunction('Function Crc32( const Crc32Table : TCrc32Table; const X : array of Byte; N : Integer; Crc : Cardinal) : Cardinal;');
 CL.AddDelphiFunction('Function Crc32_A( const Crc32Table : TCrc32Table; const X : array of Byte; Crc : Cardinal) : Cardinal;');
 CL.AddDelphiFunction('Function CheckCrc32_P( const Crc32Table : TCrc32Table; X : PJclByteArray; N : Integer; Crc : Cardinal) : Integer;');
 CL.AddDelphiFunction('Function CheckCrc32( const Crc32Table : TCrc32Table; var X : array of Byte; N : Integer; Crc : Cardinal) : Integer;');
 CL.AddDelphiFunction('Function CheckCrc32_A( const Crc32Table : TCrc32Table; var X : array of Byte; Crc : Cardinal) : Integer;');
 CL.AddDelphiFunction('Procedure InitCrc32( Polynom, Start : Cardinal; out Crc32Table : TCrc32Table);');
 CL.AddDelphiFunction('Procedure SetRectComplexFormatStr( const S : string)');
 CL.AddDelphiFunction('Procedure SetPolarComplexFormatStr( const S : string)');
 CL.AddDelphiFunction('Function ComplexToStr( const Z : TRectComplex) : string;');
 CL.AddDelphiFunction('Function ComplexToStr1( const Z : TPolarComplex) : string;');
 CL.AddDelphiFunction('Function RectComplex( const Re : Float; const Im : Float) : TRectComplex;');
 CL.AddDelphiFunction('Function RectComplex1( const Z : TPolarComplex) : TRectComplex;');
 CL.AddDelphiFunction('Function PolarComplex( const Radius : Float; const Angle : Float) : TPolarComplex;');
 CL.AddDelphiFunction('Function PolarComplex1( const Z : TRectComplex) : TPolarComplex;');
 CL.AddDelphiFunction('Function Equal( const Z1, Z2 : TRectComplex) : Boolean;');
 CL.AddDelphiFunction('Function Equal1( const Z1, Z2 : TPolarComplex) : Boolean;');
 CL.AddDelphiFunction('Function IsZero( const Z : TRectComplex) : Boolean;');
 CL.AddDelphiFunction('Function IsZero1( const Z : TPolarComplex) : Boolean;');
 CL.AddDelphiFunction('Function IsInfinite( const Z : TRectComplex) : Boolean;');
 CL.AddDelphiFunction('Function IsInfinite1( const Z : TPolarComplex) : Boolean;');
 CL.AddDelphiFunction('Function Norm( const Z : TRectComplex) : Float;');
 CL.AddDelphiFunction('Function Norm1( const Z : TPolarComplex) : Float;');
 CL.AddDelphiFunction('Function AbsSqr( const Z : TRectComplex) : Float;');
 CL.AddDelphiFunction('Function AbsSqr1( const Z : TPolarComplex) : Float;');
 CL.AddDelphiFunction('Function Conjugate( const Z : TRectComplex) : TRectComplex;');
 CL.AddDelphiFunction('Function Conjugate1( const Z : TPolarComplex) : TPolarComplex;');
 CL.AddDelphiFunction('Function Inv( const Z : TRectComplex) : TRectComplex;');
 CL.AddDelphiFunction('Function Inv1( const Z : TPolarComplex) : TPolarComplex;');
 CL.AddDelphiFunction('Function Neg( const Z : TRectComplex) : TRectComplex;');
 CL.AddDelphiFunction('Function Neg1( const Z : TPolarComplex) : TPolarComplex;');
 CL.AddDelphiFunction('Function Sum( const Z1, Z2 : TRectComplex) : TRectComplex;');
 CL.AddDelphiFunction('Function Sum1( const Z : array of TRectComplex) : TRectComplex;');
 CL.AddDelphiFunction('Function Diff( const Z1, Z2 : TRectComplex) : TRectComplex');
 CL.AddDelphiFunction('Function Product( const Z1, Z2 : TRectComplex) : TRectComplex;');
 CL.AddDelphiFunction('Function Product1( const Z1, Z2 : TPolarComplex) : TPolarComplex;');
 CL.AddDelphiFunction('Function Product2( const Z : array of TPolarComplex) : TPolarComplex;');
 CL.AddDelphiFunction('Function Quotient( const Z1, Z2 : TRectComplex) : TRectComplex;');
 CL.AddDelphiFunction('Function Quotient1( const Z1, Z2 : TPolarComplex) : TPolarComplex;');
 CL.AddDelphiFunction('Function Ln( const Z : TPolarComplex) : TRectComplex');
 CL.AddDelphiFunction('Function Exp( const Z : TRectComplex) : TPolarComplex;');
 CL.AddDelphiFunction('Function Power( const Z : TPolarComplex; const Exponent : TRectComplex) : TPolarComplex;');
 CL.AddDelphiFunction('Function Power1( const Z : TPolarComplex; const Exponent : Float) : TPolarComplex;');
 CL.AddDelphiFunction('Function PowerInt( const Z : TPolarComplex; const Exponent : Integer) : TPolarComplex;');
 CL.AddDelphiFunction('Function Root( const Z : TPolarComplex; const K, N : Cardinal) : TPolarComplex');
 CL.AddDelphiFunction('Function Cos( const Z : TRectComplex) : TRectComplex;');
 CL.AddDelphiFunction('Function Sin( const Z : TRectComplex) : TRectComplex;');
 CL.AddDelphiFunction('Function Tan( const Z : TRectComplex) : TRectComplex;');
 CL.AddDelphiFunction('Function Cot( const Z : TRectComplex) : TRectComplex;');
 CL.AddDelphiFunction('Function Sec( const Z : TRectComplex) : TRectComplex;');
 CL.AddDelphiFunction('Function Csc( const Z : TRectComplex) : TRectComplex;');
 CL.AddDelphiFunction('Function CosH( const Z : TFloat) : TFloat;');
 CL.AddDelphiFunction('Function SinH( const Z : TFloat) : TFloat;');
 CL.AddDelphiFunction('Function TanH( const Z : TFloat) : TFloat;');
 CL.AddDelphiFunction('Function CotH( const Z : TRectComplex) : TRectComplex;');
 CL.AddDelphiFunction('Function SecH( const Z : TRectComplex) : TRectComplex;');
 CL.AddDelphiFunction('Function CscH( const Z : TRectComplex) : TRectComplex;');
end;      }
 end;
{
(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
Function CscH_P( const Z : TRectComplex) : TRectComplex;
Begin Result := JclMath.CscH(Z); END;

(*----------------------------------------------------------------------------*)
Function SecH_P( const Z : TRectComplex) : TRectComplex;
Begin Result := JclMath.SecH(Z); END;

(*----------------------------------------------------------------------------*)
Function CotH_P( const Z : TRectComplex) : TRectComplex;
Begin Result := JclMath.CotH(Z); END;

(*----------------------------------------------------------------------------*)
Function TanH_P( const Z : TRectComplex) : TRectComplex;
Begin Result := JclMath.TanH(Z); END;

(*----------------------------------------------------------------------------*)
Function SinH_P( const Z : TRectComplex) : TRectComplex;
Begin Result := JclMath.SinH(Z); END;

(*----------------------------------------------------------------------------*)
Function CosH_P( const Z : TRectComplex) : TRectComplex;
Begin Result := JclMath.CosH(Z); END;

(*----------------------------------------------------------------------------*)
Function Csc_P( const Z : TRectComplex) : TRectComplex;
Begin Result := JclMath.Csc(Z); END;

(*----------------------------------------------------------------------------*)
Function Sec_P( const Z : TRectComplex) : TRectComplex;
Begin Result := JclMath.Sec(Z); END;

(*----------------------------------------------------------------------------*)
Function Cot_P( const Z : TRectComplex) : TRectComplex;
Begin Result := JclMath.Cot(Z); END;

(*----------------------------------------------------------------------------*)
Function Tan_P( const Z : TRectComplex) : TRectComplex;
Begin Result := JclMath.Tan(Z); END;

(*----------------------------------------------------------------------------*)
Function Sin_P( const Z : TRectComplex) : TRectComplex;
Begin Result := JclMath.Sin(Z); END;

(*----------------------------------------------------------------------------*)
Function Cos_P( const Z : TRectComplex) : TRectComplex;
Begin Result := JclMath.Cos(Z); END;

(*----------------------------------------------------------------------------*)
Function PowerInt_P( const Z : TPolarComplex; const Exponent : Integer) : TPolarComplex;
Begin Result := JclMath.PowerInt(Z, Exponent); END;

(*----------------------------------------------------------------------------*)
Function Power1_P( const Z : TPolarComplex; const Exponent : Float) : TPolarComplex;
Begin Result := JclMath.Power(Z, Exponent); END;

(*----------------------------------------------------------------------------*)
Function Power_P( const Z : TPolarComplex; const Exponent : TRectComplex) : TPolarComplex;
Begin Result := JclMath.Power(Z, Exponent); END;

(*----------------------------------------------------------------------------*)
Function Exp_P( const Z : TRectComplex) : TPolarComplex;
Begin Result := JclMath.Exp(Z); END;

(*----------------------------------------------------------------------------*)
Function Quotient1_P( const Z1, Z2 : TPolarComplex) : TPolarComplex;
Begin Result := JclMath.Quotient(Z1, Z2); END;

(*----------------------------------------------------------------------------*)
Function Quotient_P( const Z1, Z2 : TRectComplex) : TRectComplex;
Begin Result := JclMath.Quotient(Z1, Z2); END;

(*----------------------------------------------------------------------------*)
Function Product2_P( const Z : array of TPolarComplex) : TPolarComplex;
Begin Result := JclMath.Product(Z); END;

(*----------------------------------------------------------------------------*)
Function Product1_P( const Z1, Z2 : TPolarComplex) : TPolarComplex;
Begin Result := JclMath.Product(Z1, Z2); END;

(*----------------------------------------------------------------------------*)
Function Product_P( const Z1, Z2 : TRectComplex) : TRectComplex;
Begin Result := JclMath.Product(Z1, Z2); END;

(*----------------------------------------------------------------------------*)
Function Sum1_P( const Z : array of TRectComplex) : TRectComplex;
Begin Result := JclMath.Sum(Z); END;

(*----------------------------------------------------------------------------*)
Function Sum_P( const Z1, Z2 : TRectComplex) : TRectComplex;
Begin Result := JclMath.Sum(Z1, Z2); END;

(*----------------------------------------------------------------------------*)
Function Neg1_P( const Z : TPolarComplex) : TPolarComplex;
Begin Result := JclMath.Neg(Z); END;

(*----------------------------------------------------------------------------*)
Function Neg_P( const Z : TRectComplex) : TRectComplex;
Begin Result := JclMath.Neg(Z); END;

(*----------------------------------------------------------------------------*)
Function Inv1_P( const Z : TPolarComplex) : TPolarComplex;
Begin Result := JclMath.Inv(Z); END;

(*----------------------------------------------------------------------------*)
Function Inv_P( const Z : TRectComplex) : TRectComplex;
Begin Result := JclMath.Inv(Z); END;

(*----------------------------------------------------------------------------*)
Function Conjugate1_P( const Z : TPolarComplex) : TPolarComplex;
Begin Result := JclMath.Conjugate(Z); END;

(*----------------------------------------------------------------------------*)
Function Conjugate_P( const Z : TRectComplex) : TRectComplex;
Begin Result := JclMath.Conjugate(Z); END;

(*----------------------------------------------------------------------------*)
Function AbsSqr1_P( const Z : TPolarComplex) : Float;
Begin Result := JclMath.AbsSqr(Z); END;

(*----------------------------------------------------------------------------*)
Function AbsSqr_P( const Z : TRectComplex) : Float;
Begin Result := JclMath.AbsSqr(Z); END;

(*----------------------------------------------------------------------------*)
Function Norm1_P( const Z : TPolarComplex) : Float;
Begin Result := JclMath.Norm(Z); END;

(*----------------------------------------------------------------------------*)
Function Norm_P( const Z : TRectComplex) : Float;
Begin Result := JclMath.Norm(Z); END;

(*----------------------------------------------------------------------------*)
Function IsInfinite1_P( const Z : TPolarComplex) : Boolean;
Begin Result := JclMath.IsInfinite(Z); END;

(*----------------------------------------------------------------------------*)
Function IsInfinite_P( const Z : TRectComplex) : Boolean;
Begin Result := JclMath.IsInfinite(Z); END;

(*----------------------------------------------------------------------------*)
Function IsZero1_P( const Z : TPolarComplex) : Boolean;
Begin Result := JclMath.IsZero(Z); END;

(*----------------------------------------------------------------------------*)
Function IsZero_P( const Z : TRectComplex) : Boolean;
Begin Result := JclMath.IsZero(Z); END;

(*----------------------------------------------------------------------------*)
Function Equal1_P( const Z1, Z2 : TPolarComplex) : Boolean;
Begin Result := JclMath.Equal(Z1, Z2); END;

(*----------------------------------------------------------------------------*)
Function Equal_P( const Z1, Z2 : TRectComplex) : Boolean;
Begin Result := JclMath.Equal(Z1, Z2); END;

(*----------------------------------------------------------------------------*)
Function PolarComplex1_P( const Z : TRectComplex) : TPolarComplex;
Begin Result := JclMath.PolarComplex(Z); END;

(*----------------------------------------------------------------------------*)
Function PolarComplex_P( const Radius : Float; const Angle : Float) : TPolarComplex;
Begin Result := JclMath.PolarComplex(Radius, Angle); END;

(*----------------------------------------------------------------------------*)
Function RectComplex1_P( const Z : TPolarComplex) : TRectComplex;
Begin Result := JclMath.RectComplex(Z); END;

(*----------------------------------------------------------------------------*)
Function RectComplex_P( const Re : Float; const Im : Float) : TRectComplex;
Begin Result := JclMath.RectComplex(Re, Im); END;

(*----------------------------------------------------------------------------*)
Function ComplexToStr1_P( const Z : TPolarComplex) : string;
Begin Result := JclMath.ComplexToStr(Z); END;

(*----------------------------------------------------------------------------*)
Function ComplexToStr_P( const Z : TRectComplex) : string;
Begin Result := JclMath.ComplexToStr(Z); END;

(*----------------------------------------------------------------------------*)
Procedure InitCrc32_P( Polynom, Start : Cardinal; out Crc32Table : TCrc32Table);
Begin JclMath.InitCrc32(Polynom, Start, Crc32Table); END;

(*----------------------------------------------------------------------------*)
Function CheckCrc32_A_P( const Crc32Table : TCrc32Table; var X : array of Byte; Crc : Cardinal) : Integer;
Begin Result := JclMath.CheckCrc32_A(Crc32Table, X, Crc); END;

(*----------------------------------------------------------------------------*)
Function CheckCrc32_P( const Crc32Table : TCrc32Table; var X : array of Byte; N : Integer; Crc : Cardinal) : Integer;
Begin Result := JclMath.CheckCrc32(Crc32Table, X, N, Crc); END;

(*----------------------------------------------------------------------------*)
Function CheckCrc32_P_P( const Crc32Table : TCrc32Table; X : PJclByteArray; N : Integer; Crc : Cardinal) : Integer;
Begin Result := JclMath.CheckCrc32_P(Crc32Table, X, N, Crc); END;

(*----------------------------------------------------------------------------*)
Function Crc32_A_P( const Crc32Table : TCrc32Table; const X : array of Byte; Crc : Cardinal) : Cardinal;
Begin Result := JclMath.Crc32_A(Crc32Table, X, Crc); END;

(*----------------------------------------------------------------------------*)
Function Crc32_P( const Crc32Table : TCrc32Table; const X : array of Byte; N : Integer; Crc : Cardinal) : Cardinal;
Begin Result := JclMath.Crc32(Crc32Table, X, N, Crc); END;

(*----------------------------------------------------------------------------*)
Function Crc32_P_P( const Crc32Table : TCrc32Table; X : PJclByteArray; N : Integer; Crc : Cardinal) : Cardinal;
Begin Result := JclMath.Crc32_P(Crc32Table, X, N, Crc); END;

(*----------------------------------------------------------------------------*)
Procedure InitCrc32_P( Polynom, Start : Cardinal);
Begin JclMath.InitCrc32(Polynom, Start); END;

(*----------------------------------------------------------------------------*)
Function CheckCrc32_A_P( var X : array of Byte; Crc : Cardinal) : Integer;
Begin Result := JclMath.CheckCrc32_A(X, Crc); END;

(*----------------------------------------------------------------------------*)
Function CheckCrc32_P( var X : array of Byte; N : Integer; Crc : Cardinal) : Integer;
Begin Result := JclMath.CheckCrc32(X, N, Crc); END;

(*----------------------------------------------------------------------------*)
Function CheckCrc32_P_P( X : PJclByteArray; N : Integer; Crc : Cardinal) : Integer;
Begin Result := JclMath.CheckCrc32_P(X, N, Crc); END;

(*----------------------------------------------------------------------------*)
Function Crc32_A_P( const X : array of Byte; Crc : Cardinal) : Cardinal;
Begin Result := JclMath.Crc32_A(X, Crc); END;

(*----------------------------------------------------------------------------*)
Function Crc32_P( const X : array of Byte; N : Integer; Crc : Cardinal) : Cardinal;
Begin Result := JclMath.Crc32(X, N, Crc); END;

(*----------------------------------------------------------------------------*)
Function Crc32_P_P( X : PJclByteArray; N : Integer; Crc : Cardinal) : Cardinal;
Begin Result := JclMath.Crc32_P(X, N, Crc); END;

(*----------------------------------------------------------------------------*)
Procedure InitCrc16_P( Polynom, Start : Word; out Crc16Table : TCrc16Table);
Begin JclMath.InitCrc16(Polynom, Start, Crc16Table); END;

(*----------------------------------------------------------------------------*)
Function CheckCrc16_A_P( const Crc16Table : TCrc16Table; var X : array of Byte; Crc : Word) : Integer;
Begin Result := JclMath.CheckCrc16_A(Crc16Table, X, Crc); END;

(*----------------------------------------------------------------------------*)
Function CheckCrc16_P( const Crc16Table : TCrc16Table; var X : array of Byte; N : Integer; Crc : Word) : Integer;
Begin Result := JclMath.CheckCrc16(Crc16Table, X, N, Crc); END;

(*----------------------------------------------------------------------------*)
Function CheckCrc16_P_P( const Crc16Table : TCrc16Table; X : PJclByteArray; N : Integer; Crc : Word) : Integer;
Begin Result := JclMath.CheckCrc16_P(Crc16Table, X, N, Crc); END;

(*----------------------------------------------------------------------------*)
Function Crc16_A_P( const Crc16Table : TCrc16Table; const X : array of Byte; Crc : Word) : Word;
Begin Result := JclMath.Crc16_A(Crc16Table, X, Crc); END;

(*----------------------------------------------------------------------------*)
Function Crc16_P( const Crc16Table : TCrc16Table; const X : array of Byte; N : Integer; Crc : Word) : Word;
Begin Result := JclMath.Crc16(Crc16Table, X, N, Crc); END;

(*----------------------------------------------------------------------------*)
Function Crc16_P_P( const Crc16Table : TCrc16Table; X : PJclByteArray; N : Integer; Crc : Word) : Word;
Begin Result := JclMath.Crc16_P(Crc16Table, X, N, Crc); END;

(*----------------------------------------------------------------------------*)
Procedure InitCrc16_P( Polynom, Start : Word);
Begin JclMath.InitCrc16(Polynom, Start); END;

(*----------------------------------------------------------------------------*)
Function CheckCrc16_A_P( var X : array of Byte; Crc : Word) : Integer;
Begin Result := JclMath.CheckCrc16_A(X, Crc); END;

(*----------------------------------------------------------------------------*)
Function CheckCrc16_P( var X : array of Byte; N : Integer; Crc : Word) : Integer;
Begin Result := JclMath.CheckCrc16(X, N, Crc); END;

(*----------------------------------------------------------------------------*)
Function CheckCrc16_P_P( X : PJclByteArray; N : Integer; Crc : Word) : Integer;
Begin Result := JclMath.CheckCrc16_P(X, N, Crc); END;

(*----------------------------------------------------------------------------*)
Function Crc16_A_P( const X : array of Byte; Crc : Word) : Word;
Begin Result := JclMath.Crc16_A(X, Crc); END;

(*----------------------------------------------------------------------------*)
Function Crc16_P( const X : array of Byte; N : Integer; Crc : Word) : Word;
Begin Result := JclMath.Crc16(X, N, Crc); END;

(*----------------------------------------------------------------------------*)
Function Crc16_P_P( X : PJclByteArray; N : Integer; Crc : Word) : Word;
Begin Result := JclMath.Crc16_P(X, N, Crc); END;

(*----------------------------------------------------------------------------*)
Function GetParity1_P( Buffer : PByte; Len : Integer) : Boolean;
Begin Result := JclMath.GetParity(Buffer, Len); END;

(*----------------------------------------------------------------------------*)
Function GetParity_P( Buffer : TDynByteArray; Len : Integer) : Boolean;
Begin Result := JclMath.GetParity(Buffer, Len); END;   }

(*----------------------------------------------------------------------------*)
procedure EJclNaNSignalTag_R(Self: EJclNaNSignal; var T: TNaNTag);
begin T := Self.Tag; end;

(*----------------------------------------------------------------------------*)
Procedure TJclRationalPower2_P(Self: TJclRational;  const V : Float);
Begin Self.Power(V); END;

(*----------------------------------------------------------------------------*)
Procedure TJclRationalPower1_P(Self: TJclRational;  const V : Integer);
Begin Self.Power(V); END;

(*----------------------------------------------------------------------------*)
Procedure TJclRationalPower_P(Self: TJclRational;  const R : TJclRational);
Begin Self.Power(R); END;

(*----------------------------------------------------------------------------*)
Procedure TJclRationalDivide2_P(Self: TJclRational;  const V : Integer);
Begin Self.Divide(V); END;

(*----------------------------------------------------------------------------*)
Procedure TJclRationalDivide1_P(Self: TJclRational;  const V : Float);
Begin Self.Divide(V); END;

(*----------------------------------------------------------------------------*)
Procedure TJclRationalDivide_P(Self: TJclRational;  const R : TJclRational);
Begin Self.Divide(R); END;

(*----------------------------------------------------------------------------*)
Procedure TJclRationalMultiply2_P(Self: TJclRational;  const V : Integer);
Begin Self.Multiply(V); END;

(*----------------------------------------------------------------------------*)
Procedure TJclRationalMultiply1_P(Self: TJclRational;  const V : Float);
Begin Self.Multiply(V); END;

(*----------------------------------------------------------------------------*)
Procedure TJclRationalMultiply_P(Self: TJclRational;  const R : TJclRational);
Begin Self.Multiply(R); END;

(*----------------------------------------------------------------------------*)
Procedure TJclRationalSubtract2_P(Self: TJclRational;  const V : Integer);
Begin Self.Subtract(V); END;

(*----------------------------------------------------------------------------*)
Procedure TJclRationalSubtract1_P(Self: TJclRational;  const V : Float);
Begin Self.Subtract(V); END;

(*----------------------------------------------------------------------------*)
Procedure TJclRationalSubtract_P(Self: TJclRational;  const R : TJclRational);
Begin Self.Subtract(R); END;

(*----------------------------------------------------------------------------*)
Procedure TJclRationalAdd2_P(Self: TJclRational;  const V : Integer);
Begin Self.Add(V); END;

(*----------------------------------------------------------------------------*)
Procedure TJclRationalAdd1_P(Self: TJclRational;  const V : Float);
Begin Self.Add(V); END;

(*----------------------------------------------------------------------------*)
Procedure TJclRationalAdd_P(Self: TJclRational;  const R : TJclRational);
Begin Self.Add(R); END;

(*----------------------------------------------------------------------------*)
Function TJclRationalIsEqual2_P(Self: TJclRational;  const R : Float) : Boolean;
Begin Result := Self.IsEqual(R); END;

(*----------------------------------------------------------------------------*)
Function TJclRationalIsEqual1_P(Self: TJclRational;  const Numerator : Integer; const Denominator : Integer) : Boolean;
Begin Result := Self.IsEqual(Numerator, Denominator); END;

(*----------------------------------------------------------------------------*)
Function TJclRationalIsEqual_P(Self: TJclRational;  const R : TJclRational) : Boolean;
Begin Result := Self.IsEqual(R); END;

(*----------------------------------------------------------------------------*)
Procedure TJclRationalAssign2_P(Self: TJclRational;  const Numerator : Integer; const Denominator : Integer);
Begin Self.Assign(Numerator, Denominator); END;

(*----------------------------------------------------------------------------*)
Procedure TJclRationalAssign1_P(Self: TJclRational;  const R : Float);
Begin Self.Assign(R); END;

(*----------------------------------------------------------------------------*)
Procedure TJclRationalAssign_P(Self: TJclRational;  const R : TJclRational);
Begin Self.Assign(R); END;

(*----------------------------------------------------------------------------*)
procedure TJclRationalAsFloat_W(Self: TJclRational; const T: Float);
begin Self.AsFloat := T; end;

(*----------------------------------------------------------------------------*)
procedure TJclRationalAsFloat_R(Self: TJclRational; var T: Float);
begin T := Self.AsFloat; end;

(*----------------------------------------------------------------------------*)
procedure TJclRationalAsString_W(Self: TJclRational; const T: string);
begin Self.AsString := T; end;

(*----------------------------------------------------------------------------*)
procedure TJclRationalAsString_R(Self: TJclRational; var T: string);
begin T := Self.AsString; end;

(*----------------------------------------------------------------------------*)
procedure TJclRationalDenominator_R(Self: TJclRational; var T: Integer);
begin T := Self.Denominator; end;

(*----------------------------------------------------------------------------*)
procedure TJclRationalNumerator_R(Self: TJclRational; var T: Integer);
begin T := Self.Numerator; end;

(*----------------------------------------------------------------------------*)
Function TJclRationalCreate2_P(Self: TClass; CreateNewInstance: Boolean;  const Numerator : Integer; const Denominator : Integer):TObject;
Begin Result := TJclRational.Create(Numerator, Denominator); END;

(*----------------------------------------------------------------------------*)
Function TJclRationalCreate1_P(Self: TClass; CreateNewInstance: Boolean;  const R : Float):TObject;
Begin Result := TJclRational.Create(R); END;

(*----------------------------------------------------------------------------*)
Function TJclRationalCreate_P(Self: TClass; CreateNewInstance: Boolean):TObject;
Begin Result := TJclRational.Create; END;

{
(*----------------------------------------------------------------------------*)
Function GetNaNTag2_P( const NaN : Extended) : TNaNTag;
Begin Result := JclMath.GetNaNTag(NaN); END;

(*----------------------------------------------------------------------------*)
Function GetNaNTag1_P( const NaN : Double) : TNaNTag;
Begin Result := JclMath.GetNaNTag(NaN); END;

(*----------------------------------------------------------------------------*)
Function GetNaNTag_P( const NaN : Single) : TNaNTag;
Begin Result := JclMath.GetNaNTag(NaN); END;

(*----------------------------------------------------------------------------*)
Procedure MakeSignalingNaN2_P( var X : Extended; Tag : TNaNTag);
Begin JclMath.MakeSignalingNaN(X, Tag); END;

(*----------------------------------------------------------------------------*)
Procedure MakeSignalingNaN1_P( var X : Double; Tag : TNaNTag);
Begin JclMath.MakeSignalingNaN(X, Tag); END;

(*----------------------------------------------------------------------------*)
Procedure MakeSignalingNaN_P( var X : Single; Tag : TNaNTag);
Begin JclMath.MakeSignalingNaN(X, Tag); END;

(*----------------------------------------------------------------------------*)
Procedure MakeQuietNaN2_P( var X : Extended; Tag : TNaNTag);
Begin JclMath.MakeQuietNaN(X, Tag); END;

(*----------------------------------------------------------------------------*)
Procedure MakeQuietNaN1_P( var X : Double; Tag : TNaNTag);
Begin JclMath.MakeQuietNaN(X, Tag); END;

(*----------------------------------------------------------------------------*)
Procedure MakeQuietNaN_P( var X : Single; Tag : TNaNTag);
Begin JclMath.MakeQuietNaN(X, Tag); END;

(*----------------------------------------------------------------------------*)
Function IsNaN2_P( const Value : Extended) : Boolean;
Begin Result := JclMath.IsNaN(Value); END;

(*----------------------------------------------------------------------------*)
Function IsNaN1_P( const Value : Double) : Boolean;
Begin Result := JclMath.IsNaN(Value); END;

(*----------------------------------------------------------------------------*)
Function IsNaN_P( const Value : Single) : Boolean;
Begin Result := JclMath.IsNaN(Value); END;

(*----------------------------------------------------------------------------*)
Function IsInfinite2_P( const Value : Extended) : Boolean;
Begin Result := JclMath.IsInfinite(Value); END;

(*----------------------------------------------------------------------------*)
Function IsInfinite1_P( const Value : Double) : Boolean;
Begin Result := JclMath.IsInfinite(Value); END;

(*----------------------------------------------------------------------------*)
Function IsInfinite_P( const Value : Single) : Boolean;
Begin Result := JclMath.IsInfinite(Value); END;

(*----------------------------------------------------------------------------*)
Function FloatingPointClass2_P( const Value : Extended) : TFloatingPointClass;
Begin Result := JclMath.FloatingPointClass(Value); END;

(*----------------------------------------------------------------------------*)
Function FloatingPointClass1_P( const Value : Double) : TFloatingPointClass;
Begin Result := JclMath.FloatingPointClass(Value); END;

(*----------------------------------------------------------------------------*)
Function FloatingPointClass_P( const Value : Single) : TFloatingPointClass;
Begin Result := JclMath.FloatingPointClass(Value); END;

(*----------------------------------------------------------------------------*)
Function EnsureRange2_P( const AValue, AMin, AMax : Double) : Double;
Begin Result := JclMath.EnsureRange(AValue, AMin, AMax); END;

(*----------------------------------------------------------------------------*)
Function EnsureRange1_P( const AValue, AMin, AMax : Int64) : Int64;
Begin Result := JclMath.EnsureRange(AValue, AMin, AMax); END;

(*----------------------------------------------------------------------------*)
Function EnsureRange_P( const AValue, AMin, AMax : Integer) : Integer;
Begin Result := JclMath.EnsureRange(AValue, AMin, AMax); END;

(*----------------------------------------------------------------------------*)
Function PowerInt_P( const X : Float; N : Integer) : Float;
Begin Result := JclMath.PowerInt(X, N); END;

(*----------------------------------------------------------------------------*)
Function Power_P( const Base, Exponent : Float) : Float;
Begin Result := JclMath.Power(Base, Exponent); END;

(*----------------------------------------------------------------------------*)
Function Exp_P( const X : Float) : Float;
Begin Result := JclMath.Exp(X); END;

(*----------------------------------------------------------------------------*)
Function GradToDeg2_P( const Value : Single) : Single;
Begin Result := JclMath.GradToDeg(Value); END;

(*----------------------------------------------------------------------------*)
Function GradToDeg1_P( const Value : Double) : Double;
Begin Result := JclMath.GradToDeg(Value); END;

(*----------------------------------------------------------------------------*)
Function GradToDeg_P( const Value : Extended) : Extended;
Begin Result := JclMath.GradToDeg(Value); END;

(*----------------------------------------------------------------------------*)
Function DegToGrad2_P( const Value : Single) : Single;
Begin Result := JclMath.DegToGrad(Value); END;

(*----------------------------------------------------------------------------*)
Function DegToGrad1_P( const Value : Double) : Double;
Begin Result := JclMath.DegToGrad(Value); END;

(*----------------------------------------------------------------------------*)
Function DegToGrad_P( const Value : Extended) : Extended;
Begin Result := JclMath.DegToGrad(Value); END;

(*----------------------------------------------------------------------------*)
Function RadToGrad2_P( const Value : Single) : Single;
Begin Result := JclMath.RadToGrad(Value); END;

(*----------------------------------------------------------------------------*)
Function RadToGrad1_P( const Value : Double) : Double;
Begin Result := JclMath.RadToGrad(Value); END;

(*----------------------------------------------------------------------------*)
Function RadToGrad_P( const Value : Extended) : Extended;
Begin Result := JclMath.RadToGrad(Value); END;

(*----------------------------------------------------------------------------*)
Function GradToRad2_P( const Value : Single) : Single;
Begin Result := JclMath.GradToRad(Value); END;

(*----------------------------------------------------------------------------*)
Function GradToRad1_P( const Value : Double) : Double;
Begin Result := JclMath.GradToRad(Value); END;

(*----------------------------------------------------------------------------*)
Function GradToRad_P( const Value : Extended) : Extended;
Begin Result := JclMath.GradToRad(Value); END;

(*----------------------------------------------------------------------------*)
Function RadToDeg2_P( const Value : Single) : Single;
Begin Result := JclMath.RadToDeg(Value); END;

(*----------------------------------------------------------------------------*)
Function RadToDeg1_P( const Value : Double) : Double;
Begin Result := JclMath.RadToDeg(Value); END;

(*----------------------------------------------------------------------------*)
Function RadToDeg_P( const Value : Extended) : Extended;
Begin Result := JclMath.RadToDeg(Value); END;

(*----------------------------------------------------------------------------*)
Function DegToRad2_P( const Value : Single) : Single;
Begin Result := JclMath.DegToRad(Value); END;

(*----------------------------------------------------------------------------*)
Function DegToRad1_P( const Value : Double) : Double;
Begin Result := JclMath.DegToRad(Value); END;

(*----------------------------------------------------------------------------*)
Function DegToRad_P( const Value : Extended) : Extended;
Begin Result := JclMath.DegToRad(Value); END;    }

//(*----------------------------------------------------------------------------*)
procedure RIRegister_EJclNaNSignal(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(EJclNaNSignal) do begin
    RegisterConstructor(@EJclNaNSignal.Create, 'Create');
    RegisterPropertyHelper(@EJclNaNSignalTag_R,nil,'Tag');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJclRational(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJclRational) do begin
    RegisterConstructor(@TJclRationalCreate_P, 'Create');
    RegisterConstructor(@TJclRationalCreate1_P, 'Create1');
    RegisterConstructor(@TJclRationalCreate2_P, 'Create2');
    RegisterPropertyHelper(@TJclRationalNumerator_R,nil,'Numerator');
    RegisterPropertyHelper(@TJclRationalDenominator_R,nil,'Denominator');
    RegisterPropertyHelper(@TJclRationalAsString_R,@TJclRationalAsString_W,'AsString');
    RegisterPropertyHelper(@TJclRationalAsFloat_R,@TJclRationalAsFloat_W,'AsFloat');
    RegisterMethod(@TJclRationalAssign_P, 'Assign');
    RegisterMethod(@TJclRationalAssign1_P, 'Assign1');
    RegisterMethod(@TJclRationalAssign2_P, 'Assign2');
    RegisterMethod(@TJclRational.AssignZero, 'AssignZero');
    RegisterMethod(@TJclRational.AssignOne, 'AssignOne');
    RegisterMethod(@TJclRational.Duplicate, 'Duplicate');
    RegisterMethod(@TJclRationalIsEqual_P, 'IsEqual');
    RegisterMethod(@TJclRationalIsEqual1_P, 'IsEqual1');
    RegisterMethod(@TJclRationalIsEqual2_P, 'IsEqual2');
    RegisterMethod(@TJclRational.IsZero, 'IsZero');
    RegisterMethod(@TJclRational.IsOne, 'IsOne');
    RegisterMethod(@TJclRationalAdd_P, 'Add');
    RegisterMethod(@TJclRationalAdd1_P, 'Add1');
    RegisterMethod(@TJclRationalAdd2_P, 'Add2');
    RegisterMethod(@TJclRationalSubtract_P, 'Subtract');
    RegisterMethod(@TJclRationalSubtract1_P, 'Subtract1');
    RegisterMethod(@TJclRationalSubtract2_P, 'Subtract2');
    RegisterMethod(@TJclRational.Negate, 'Negate');
    RegisterMethod(@TJclRational.Abs, 'Abs');
    RegisterMethod(@TJclRational.Sgn, 'Sgn');
    RegisterMethod(@TJclRationalMultiply_P, 'Multiply');
    RegisterMethod(@TJclRationalMultiply1_P, 'Multiply1');
    RegisterMethod(@TJclRationalMultiply2_P, 'Multiply2');
    RegisterMethod(@TJclRational.Reciprocal, 'Reciprocal');
    RegisterMethod(@TJclRationalDivide_P, 'Divide');
    RegisterMethod(@TJclRationalDivide1_P, 'Divide1');
    RegisterMethod(@TJclRationalDivide2_P, 'Divide2');
    RegisterMethod(@TJclRational.Sqrt, 'Sqrt');
    RegisterMethod(@TJclRational.Sqr, 'Sqr');
    RegisterMethod(@TJclRationalPower_P, 'Power');
    RegisterMethod(@TJclRationalPower1_P, 'Power1');
    RegisterMethod(@TJclRationalPower2_P, 'Power2');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJclSparseFlatSet(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJclSparseFlatSet) do begin
    RegisterConstructor(@TJclSparseFlatSet.Create, 'Create');
    RegisterMethod(@TJclSparseFlatSet.Destroy, 'Free');
    RegisterMethod(@TJclSparseFlatSet.GetBit, 'GetBit');
    RegisterMethod(@TJclSparseFlatSet.SetBit, 'SetBit');
    RegisterMethod(@TJclSparseFlatSet.Clear, 'Clear');
    RegisterMethod(@TJclSparseFlatSet.Invert, 'Invert');
    RegisterMethod(@TJclSparseFlatSet.GetRange, 'GetRange');
    RegisterMethod(@TJclSparseFlatSet.SetRange, 'SetRange');

  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJclFlatSet(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJclFlatSet) do begin
    RegisterConstructor(@TJclFlatSet.Create, 'Create');
    RegisterMethod(@TJclFlatSet.Destroy, 'Free');
    RegisterMethod(@TJclFlatSet.GetBit, 'GetBit');
    RegisterMethod(@TJclFlatSet.SetBit, 'SetBit');
    RegisterMethod(@TJclFlatSet.Clear, 'Clear');
    RegisterMethod(@TJclFlatSet.Invert, 'Invert');
    RegisterMethod(@TJclFlatSet.GetRange, 'GetRange');
    RegisterMethod(@TJclFlatSet.SetRange, 'SetRange');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJclASet(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJclASet) do begin
    {RegisterVirtualAbstractMethod(@TJclASet, @GetBit, 'GetBit');
    RegisterVirtualAbstractMethod(@TJclASet, @SetBit, 'SetBit');
    RegisterVirtualAbstractMethod(@TJclASet, @!.Clear, 'Clear');
    RegisterVirtualAbstractMethod(@TJclASet, @!.Invert, 'Invert');
    RegisterVirtualAbstractMethod(@TJclASet, @!.GetRange, 'GetRange');
    RegisterVirtualAbstractMethod(@TJclASet, @!.SetRange, 'SetRange');}
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_JclMath(CL: TPSRuntimeClassImporter);
begin
 {S.RegisterDelphiFunction(@SwapOrd, 'SwapOrd', cdRegister);
 S.RegisterDelphiFunction(@DoubleToHex, 'DoubleToHex', cdRegister);
 S.RegisterDelphiFunction(@HexToDouble, 'HexToDouble', cdRegister);
 S.RegisterDelphiFunction(@DegToRad, 'DegToRad', cdRegister);
 S.RegisterDelphiFunction(@DegToRad1, 'DegToRad1', cdRegister);
 S.RegisterDelphiFunction(@DegToRad2, 'DegToRad2', cdRegister);
 S.RegisterDelphiFunction(@FastDegToRad, 'FastDegToRad', cdRegister);
 S.RegisterDelphiFunction(@RadToDeg, 'RadToDeg', cdRegister);
 S.RegisterDelphiFunction(@RadToDeg1, 'RadToDeg1', cdRegister);
 S.RegisterDelphiFunction(@RadToDeg2, 'RadToDeg2', cdRegister);
 S.RegisterDelphiFunction(@FastRadToDeg, 'FastRadToDeg', cdRegister);
 S.RegisterDelphiFunction(@GradToRad, 'GradToRad', cdRegister);
 S.RegisterDelphiFunction(@GradToRad1, 'GradToRad1', cdRegister);
 S.RegisterDelphiFunction(@GradToRad2, 'GradToRad2', cdRegister);
 S.RegisterDelphiFunction(@FastGradToRad, 'FastGradToRad', cdRegister);
 S.RegisterDelphiFunction(@RadToGrad, 'RadToGrad', cdRegister);
 S.RegisterDelphiFunction(@RadToGrad1, 'RadToGrad1', cdRegister);
 S.RegisterDelphiFunction(@RadToGrad2, 'RadToGrad2', cdRegister);
 S.RegisterDelphiFunction(@FastRadToGrad, 'FastRadToGrad', cdRegister);
 S.RegisterDelphiFunction(@DegToGrad, 'DegToGrad', cdRegister);
 S.RegisterDelphiFunction(@DegToGrad1, 'DegToGrad1', cdRegister);
 S.RegisterDelphiFunction(@DegToGrad2, 'DegToGrad2', cdRegister);
 S.RegisterDelphiFunction(@FastDegToGrad, 'FastDegToGrad', cdRegister);
 S.RegisterDelphiFunction(@GradToDeg, 'GradToDeg', cdRegister);
 S.RegisterDelphiFunction(@GradToDeg1, 'GradToDeg1', cdRegister);
 S.RegisterDelphiFunction(@GradToDeg2, 'GradToDeg2', cdRegister);
 S.RegisterDelphiFunction(@FastGradToDeg, 'FastGradToDeg', cdRegister);
 S.RegisterDelphiFunction(@LogBase10, 'LogBase10', cdRegister);
 S.RegisterDelphiFunction(@LogBase2, 'LogBase2', cdRegister);
 S.RegisterDelphiFunction(@LogBaseN, 'LogBaseN', cdRegister);
 S.RegisterDelphiFunction(@ArcCos, 'ArcCos', cdRegister);
 S.RegisterDelphiFunction(@ArcCot, 'ArcCot', cdRegister);
 S.RegisterDelphiFunction(@ArcCsc, 'ArcCsc', cdRegister);
 S.RegisterDelphiFunction(@ArcSec, 'ArcSec', cdRegister);
 S.RegisterDelphiFunction(@ArcSin, 'ArcSin', cdRegister);
 S.RegisterDelphiFunction(@ArcTan, 'ArcTan', cdRegister);
 S.RegisterDelphiFunction(@ArcTan2, 'ArcTan2', cdRegister);
 S.RegisterDelphiFunction(@Cos, 'Cos', cdRegister);
 S.RegisterDelphiFunction(@Cot, 'Cot', cdRegister);
 S.RegisterDelphiFunction(@Coversine, 'Coversine', cdRegister);
 S.RegisterDelphiFunction(@Csc, 'Csc', cdRegister);
 S.RegisterDelphiFunction(@Exsecans, 'Exsecans', cdRegister);
 S.RegisterDelphiFunction(@Haversine, 'Haversine', cdRegister);
 S.RegisterDelphiFunction(@Sec, 'Sec', cdRegister);
 S.RegisterDelphiFunction(@Sin, 'Sin', cdRegister);
 S.RegisterDelphiFunction(@SinCos, 'SinCos', cdRegister);
 S.RegisterDelphiFunction(@SinCosE, 'SinCosE', cdRegister);
 S.RegisterDelphiFunction(@Tan, 'Tan', cdRegister);
 S.RegisterDelphiFunction(@Versine, 'Versine', cdRegister);
 S.RegisterDelphiFunction(@DegMinSecToFloat, 'DegMinSecToFloat', cdRegister);
 S.RegisterDelphiFunction(@FloatToDegMinSec, 'FloatToDegMinSec', cdRegister);
 S.RegisterDelphiFunction(@Exp, 'Exp', cdRegister);
 S.RegisterDelphiFunction(@Power, 'Power', cdRegister);
 S.RegisterDelphiFunction(@PowerInt, 'PowerInt', cdRegister);
 S.RegisterDelphiFunction(@TenToY, 'TenToY', cdRegister);
 S.RegisterDelphiFunction(@TruncPower, 'TruncPower', cdRegister);
 S.RegisterDelphiFunction(@TwoToY, 'TwoToY', cdRegister);
 S.RegisterDelphiFunction(@IsFloatZero, 'IsFloatZero', cdRegister);
 S.RegisterDelphiFunction(@FloatsEqual, 'FloatsEqual', cdRegister);
 S.RegisterDelphiFunction(@MaxFloat, 'MaxFloat', cdRegister);
 S.RegisterDelphiFunction(@MinFloat, 'MinFloat', cdRegister);
 S.RegisterDelphiFunction(@ModFloat, 'ModFloat', cdRegister);
 S.RegisterDelphiFunction(@RemainderFloat, 'RemainderFloat', cdRegister);
 S.RegisterDelphiFunction(@SetPrecisionTolerance, 'SetPrecisionTolerance', cdRegister);
 S.RegisterDelphiFunction(@SwapFloats, 'SwapFloats', cdRegister);
 S.RegisterDelphiFunction(@CalcMachineEpsSingle, 'CalcMachineEpsSingle', cdRegister);
 S.RegisterDelphiFunction(@CalcMachineEpsDouble, 'CalcMachineEpsDouble', cdRegister);
 S.RegisterDelphiFunction(@CalcMachineEpsExtended, 'CalcMachineEpsExtended', cdRegister);
 S.RegisterDelphiFunction(@CalcMachineEps, 'CalcMachineEps', cdRegister);
 S.RegisterDelphiFunction(@SetPrecisionToleranceToEpsilon, 'SetPrecisionToleranceToEpsilon', cdRegister);
 S.RegisterDelphiFunction(@Ackermann, 'Ackermann', cdRegister);
 S.RegisterDelphiFunction(@Ceiling, 'Ceiling', cdRegister);
 S.RegisterDelphiFunction(@CommercialRound, 'CommercialRound', cdRegister);
 S.RegisterDelphiFunction(@Factorial, 'Factorial', cdRegister);
 S.RegisterDelphiFunction(@Fibonacci, 'Fibonacci', cdRegister);
 S.RegisterDelphiFunction(@Floor, 'Floor', cdRegister);
 S.RegisterDelphiFunction(@GCD, 'GCD', cdRegister);
 S.RegisterDelphiFunction(@ISqrt, 'ISqrt', cdRegister);
 S.RegisterDelphiFunction(@LCM, 'LCM', cdRegister);
 S.RegisterDelphiFunction(@NormalizeAngle, 'NormalizeAngle', cdRegister);
 S.RegisterDelphiFunction(@Pythagoras, 'Pythagoras', cdRegister);
 S.RegisterDelphiFunction(@Sgn, 'Sgn', cdRegister);
 S.RegisterDelphiFunction(@Signe, 'Signe', cdRegister);
 S.RegisterDelphiFunction(@EnsureRange, 'EnsureRange', cdRegister);
 S.RegisterDelphiFunction(@EnsureRange1, 'EnsureRange1', cdRegister);
 S.RegisterDelphiFunction(@EnsureRange2, 'EnsureRange2', cdRegister);
 S.RegisterDelphiFunction(@IsRelativePrime, 'IsRelativePrime', cdRegister);
 S.RegisterDelphiFunction(@IsPrimeTD, 'IsPrimeTD', cdRegister);
 S.RegisterDelphiFunction(@IsPrimeRM, 'IsPrimeRM', cdRegister);
 S.RegisterDelphiFunction(@IsPrimeFactor, 'IsPrimeFactor', cdRegister);
 S.RegisterDelphiFunction(@PrimeFactors, 'PrimeFactors', cdRegister);
 S.RegisterDelphiFunction(@SetPrimalityTest, 'SetPrimalityTest', cdRegister);
 S.RegisterDelphiFunction(@FloatingPointClass, 'FloatingPointClass', cdRegister);
 S.RegisterDelphiFunction(@FloatingPointClass1, 'FloatingPointClass1', cdRegister);
 S.RegisterDelphiFunction(@FloatingPointClass2, 'FloatingPointClass2', cdRegister);
 S.RegisterDelphiFunction(@IsInfinite, 'IsInfinite', cdRegister);
 S.RegisterDelphiFunction(@IsInfinite1, 'IsInfinite1', cdRegister);
 S.RegisterDelphiFunction(@IsInfinite2, 'IsInfinite2', cdRegister);
 S.RegisterDelphiFunction(@IsNaN, 'IsNaN', cdRegister);
 S.RegisterDelphiFunction(@IsNaN1, 'IsNaN1', cdRegister);
 S.RegisterDelphiFunction(@IsNaN2, 'IsNaN2', cdRegister);
 S.RegisterDelphiFunction(@IsSpecialValue, 'IsSpecialValue', cdRegister);
 S.RegisterDelphiFunction(@MakeQuietNaN, 'MakeQuietNaN', cdRegister);
 S.RegisterDelphiFunction(@MakeQuietNaN1, 'MakeQuietNaN1', cdRegister);
 S.RegisterDelphiFunction(@MakeQuietNaN2, 'MakeQuietNaN2', cdRegister);
 S.RegisterDelphiFunction(@MakeSignalingNaN, 'MakeSignalingNaN', cdRegister);
 S.RegisterDelphiFunction(@MakeSignalingNaN1, 'MakeSignalingNaN1', cdRegister);
 S.RegisterDelphiFunction(@MakeSignalingNaN2, 'MakeSignalingNaN2', cdRegister);
 S.RegisterDelphiFunction(@MineSingleBuffer, 'MineSingleBuffer', cdRegister);
 S.RegisterDelphiFunction(@MineDoubleBuffer, 'MineDoubleBuffer', cdRegister);
 S.RegisterDelphiFunction(@MinedSingleArray, 'MinedSingleArray', cdRegister);
 S.RegisterDelphiFunction(@MinedDoubleArray, 'MinedDoubleArray', cdRegister);
 S.RegisterDelphiFunction(@GetNaNTag, 'GetNaNTag', cdRegister);
 S.RegisterDelphiFunction(@GetNaNTag1, 'GetNaNTag1', cdRegister);
 S.RegisterDelphiFunction(@GetNaNTag2, 'GetNaNTag2', cdRegister);  }
  RIRegister_TJclASet(CL);
  RIRegister_TJclFlatSet(CL);
  RIRegister_TJclSparseFlatSet(CL);
  RIRegister_TJclRational(CL);
  with CL.Add(EJclMathError) do
  RIRegister_EJclNaNSignal(CL);
{ S.RegisterDelphiFunction(@DomainCheck, 'DomainCheck', cdRegister);
 S.RegisterDelphiFunction(@GetParity, 'GetParity', cdRegister);
 S.RegisterDelphiFunction(@GetParity1, 'GetParity1', cdRegister);
 S.RegisterDelphiFunction(@Crc16_P, 'Crc16_P', cdRegister);
 S.RegisterDelphiFunction(@Crc16, 'Crc16', cdRegister);
 S.RegisterDelphiFunction(@Crc16_A, 'Crc16_A', cdRegister);
 S.RegisterDelphiFunction(@CheckCrc16_P, 'CheckCrc16_P', cdRegister);
 S.RegisterDelphiFunction(@CheckCrc16, 'CheckCrc16', cdRegister);
 S.RegisterDelphiFunction(@CheckCrc16_A, 'CheckCrc16_A', cdRegister);
 S.RegisterDelphiFunction(@InitCrc16, 'InitCrc16', cdRegister);
 S.RegisterDelphiFunction(@Crc16_P, 'Crc16_P', cdRegister);
 S.RegisterDelphiFunction(@Crc16, 'Crc16', cdRegister);
 S.RegisterDelphiFunction(@Crc16_A, 'Crc16_A', cdRegister);
 S.RegisterDelphiFunction(@CheckCrc16_P, 'CheckCrc16_P', cdRegister);
 S.RegisterDelphiFunction(@CheckCrc16, 'CheckCrc16', cdRegister);
 S.RegisterDelphiFunction(@CheckCrc16_A, 'CheckCrc16_A', cdRegister);
 S.RegisterDelphiFunction(@InitCrc16, 'InitCrc16', cdRegister);
 S.RegisterDelphiFunction(@Crc32_P, 'Crc32_P', cdRegister);
 S.RegisterDelphiFunction(@Crc32, 'Crc32', cdRegister);
 S.RegisterDelphiFunction(@Crc32_A, 'Crc32_A', cdRegister);
 S.RegisterDelphiFunction(@CheckCrc32_P, 'CheckCrc32_P', cdRegister);
 S.RegisterDelphiFunction(@CheckCrc32, 'CheckCrc32', cdRegister);
 S.RegisterDelphiFunction(@CheckCrc32_A, 'CheckCrc32_A', cdRegister);
 S.RegisterDelphiFunction(@InitCrc32, 'InitCrc32', cdRegister);
 S.RegisterDelphiFunction(@Crc32_P, 'Crc32_P', cdRegister);
 S.RegisterDelphiFunction(@Crc32, 'Crc32', cdRegister);
 S.RegisterDelphiFunction(@Crc32_A, 'Crc32_A', cdRegister);
 S.RegisterDelphiFunction(@CheckCrc32_P, 'CheckCrc32_P', cdRegister);
 S.RegisterDelphiFunction(@CheckCrc32, 'CheckCrc32', cdRegister);
 S.RegisterDelphiFunction(@CheckCrc32_A, 'CheckCrc32_A', cdRegister);
 S.RegisterDelphiFunction(@InitCrc32, 'InitCrc32', cdRegister);
 S.RegisterDelphiFunction(@SetRectComplexFormatStr, 'SetRectComplexFormatStr', cdRegister);
 S.RegisterDelphiFunction(@SetPolarComplexFormatStr, 'SetPolarComplexFormatStr', cdRegister);
 S.RegisterDelphiFunction(@ComplexToStr, 'ComplexToStr', cdRegister);
 S.RegisterDelphiFunction(@ComplexToStr1, 'ComplexToStr1', cdRegister);
 S.RegisterDelphiFunction(@RectComplex, 'RectComplex', cdRegister);
 S.RegisterDelphiFunction(@RectComplex1, 'RectComplex1', cdRegister);
 S.RegisterDelphiFunction(@PolarComplex, 'PolarComplex', cdRegister);
 S.RegisterDelphiFunction(@PolarComplex1, 'PolarComplex1', cdRegister);
 S.RegisterDelphiFunction(@Equal, 'Equal', cdRegister);
 S.RegisterDelphiFunction(@Equal1, 'Equal1', cdRegister);
 S.RegisterDelphiFunction(@IsZero, 'IsZero', cdRegister);
 S.RegisterDelphiFunction(@IsZero1, 'IsZero1', cdRegister);
 S.RegisterDelphiFunction(@IsInfinite, 'IsInfinite', cdRegister);
 S.RegisterDelphiFunction(@IsInfinite1, 'IsInfinite1', cdRegister);
 S.RegisterDelphiFunction(@Norm, 'Norm', cdRegister);
 S.RegisterDelphiFunction(@Norm1, 'Norm1', cdRegister);
 S.RegisterDelphiFunction(@AbsSqr, 'AbsSqr', cdRegister);
 S.RegisterDelphiFunction(@AbsSqr1, 'AbsSqr1', cdRegister);
 S.RegisterDelphiFunction(@Conjugate, 'Conjugate', cdRegister);
 S.RegisterDelphiFunction(@Conjugate1, 'Conjugate1', cdRegister);
 S.RegisterDelphiFunction(@Inv, 'Inv', cdRegister);
 S.RegisterDelphiFunction(@Inv1, 'Inv1', cdRegister);
 S.RegisterDelphiFunction(@Neg, 'Neg', cdRegister);
 S.RegisterDelphiFunction(@Neg1, 'Neg1', cdRegister);
 S.RegisterDelphiFunction(@Sum, 'Sum', cdRegister);
 S.RegisterDelphiFunction(@Sum1, 'Sum1', cdRegister);
 S.RegisterDelphiFunction(@Diff, 'Diff', cdRegister);
 S.RegisterDelphiFunction(@Product, 'Product', cdRegister);
 S.RegisterDelphiFunction(@Product1, 'Product1', cdRegister);
 S.RegisterDelphiFunction(@Product2, 'Product2', cdRegister);
 S.RegisterDelphiFunction(@Quotient, 'Quotient', cdRegister);
 S.RegisterDelphiFunction(@Quotient1, 'Quotient1', cdRegister);
 S.RegisterDelphiFunction(@Ln, 'Ln', cdRegister);
 S.RegisterDelphiFunction(@Exp, 'Exp', cdRegister);
 S.RegisterDelphiFunction(@Power, 'Power', cdRegister);
 S.RegisterDelphiFunction(@Power1, 'Power1', cdRegister);
 S.RegisterDelphiFunction(@PowerInt, 'PowerInt', cdRegister);
 S.RegisterDelphiFunction(@Root, 'Root', cdRegister);
 S.RegisterDelphiFunction(@Cos, 'Cos', cdRegister);
 S.RegisterDelphiFunction(@Sin, 'Sin', cdRegister);
 S.RegisterDelphiFunction(@Tan, 'Tan', cdRegister);
 S.RegisterDelphiFunction(@Cot, 'Cot', cdRegister);
 S.RegisterDelphiFunction(@Sec, 'Sec', cdRegister);
 S.RegisterDelphiFunction(@Csc, 'Csc', cdRegister);
 S.RegisterDelphiFunction(@jclmath.CosH, 'CosH', cdRegister);
 S.RegisterDelphiFunction(@SinH, 'SinH', cdRegister);
 S.RegisterDelphiFunction(@TanH, 'TanH', cdRegister);
 S.RegisterDelphiFunction(@CotH, 'CotH', cdRegister);
 S.RegisterDelphiFunction(@SecH, 'SecH', cdRegister);
 S.RegisterDelphiFunction(@CscH, 'CscH', cdRegister);   }
end;

 
 
{ TPSImport_JclMath }
(*----------------------------------------------------------------------------*)
procedure TPSImport_JclMath.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_JclMath(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_JclMath.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_JclMath(ri);
  //RIRegister_JclMath_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
