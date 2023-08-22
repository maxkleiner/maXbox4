unit uPSI_uTPLb_HugeCardinalUtils;
{
  TurboPower Crypto
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
  TPSImport_uTPLb_HugeCardinalUtils = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;


{ compile-time registration functions }
procedure SIRegister_uTPLb_HugeCardinalUtils(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_uTPLb_HugeCardinalUtils_Routines(S: TPSExec);

procedure Register;

implementation


uses
   uTPLb_HugeCardinal
  ,uTPLb_MemoryStreamPool
  ,uTPLb_HugeCardinalUtils
  ;


procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_uTPLb_HugeCardinalUtils]);
end;


function GetBytesInt(value: Smallint): TBytes;
begin
  SetLength(Result, SizeOf(value));
  Move(value, Result[0], SizeOf(value));
end;

function GetBytes(value: string): TBytes;
begin
  SetLength(Result, SizeOf(value));
  Move(value, Result[0], SizeOf(value));
end;

function GetBytesStream(value: string): TMemoryStream;
begin
  //SetLength((Result.Memory), SizeOf(value));
  //Move(value, Result[0], SizeOf(value));
end;

function AnsiBytesOf(const S: string): TBytes;
begin
  //Result := TEncoding.ANSI.GetBytes(S);
  Result := GetBytes(S);
end;

function AnsiBytesOfStream(const S: string): TBytes;
begin
  //Result := TEncoding.ANSI.GetBytes(S);
  //Result := GetBytesStream(S);
end;


function HugeToBase10(const AHuge: THugeCardinal): string;
var
  s: string;
  tmp: THugeCardinal;
  divisor, rem: THugeCardinal;
begin
  Result := '';
  tmp := THugeCardinal.CreateAsClone(AHuge, AHuge.FPool);
  divisor := THugeCardinal.CreateSimple(10000);
  rem := THugeCardinal.CreateSimple(0);
  try
    while not tmp.isZero do begin
      tmp.Divide(divisor, tmp, rem);
      //s := rem.ExtractSmall.ToString;
      s := inttostr(rem.ExtractSmall);

      while Length(s) < 4 do
        s := '0' + s;
      Result := s + Result;
    end;
    Result := '0' + Result;
    // while (Result.Length > 1) And (Result.Chars[0] = '0') do
    while (Length(result) > 1) And (Result[1] = '0') do
      delete(Result, 1, 1);
      //Result := Remove(result, 0, 1);
  finally
    tmp.Free;
    rem.Free;
    divisor.Free;
  end;
end;


(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_uTPLb_HugeCardinalUtils(CL: TPSPascalCompiler);
begin
  CL.AddTypeS('TPrimalityTestNoticeProc', 'Procedure ( CountPrimalityTests : integer)');
 CL.AddDelphiFunction('Function gcd( a, b : THugeCardinal) : THugeCardinal');
 CL.AddDelphiFunction('Function lcm( a, b : THugeCardinal) : THugeCardinal');
 CL.AddDelphiFunction('Function isCoPrime( a, b : THugeCardinal) : boolean');
 CL.AddDelphiFunction('Function isProbablyPrime( p : THugeCardinal; OnProgress : TProgress; var wasAborted : boolean) : boolean');
 CL.AddDelphiFunction('Function hasSmallFactor( p : THugeCardinal) : boolean');
 CL.AddDelphiFunction('Function GeneratePrime( NumBits : integer; OnProgress : TProgress; OnPrimalityTest: TPrimalityTestNoticeProc; PassCount: integer; Pool1: TMemoryStreamPool; var Prime : THugeCardinal; var NumbersTested : integer) : boolean');
 CL.AddDelphiFunction('Function Inverse( Prime, Modulus : THugeCardinal) : THugeCardinal');
 CL.AddConstantN('StandardExponent','LongInt').SetInt( 65537);
 CL.AddDelphiFunction('Procedure Compute_RSA_Fundamentals_2Factors( RequiredBitLengthOfN : integer; Fixed_e : uint64; var N, e, d, Totient : THugeCardinal;'+
       'OnProgress : TProgress; OnPrimalityTest : TPrimalityTestNoticeProc; GeneratePrimePassCount : integer; Pool1 : TMemoryStreamPool; var NumbersTested : integer; var wasAborted : boolean)');
 CL.AddDelphiFunction('Function Validate_RSA_Fundamentals( var N, e, d, Totient : THugeCardinal) : boolean');
 CL.AddDelphiFunction('function AnsiBytesOf(const S: string): TBytes;');
 CL.AddDelphiFunction('function GetBytes(value: string): TBytes;');
 CL.AddDelphiFunction('function GetBytesInt(value: Smallint): TBytes;');
 CL.AddDelphiFunction('function HugeToBase10(const AHuge: THugeCardinal): string;');


end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure RIRegister_uTPLb_HugeCardinalUtils_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@gcd, 'gcdhuge', cdRegister);
 S.RegisterDelphiFunction(@lcm, 'lcmhuge', cdRegister);
 S.RegisterDelphiFunction(@isCoPrime, 'isCoPrime', cdRegister);
 S.RegisterDelphiFunction(@isProbablyPrime, 'isProbablyPrime', cdRegister);
 S.RegisterDelphiFunction(@hasSmallFactor, 'hasSmallFactor', cdRegister);
 S.RegisterDelphiFunction(@GeneratePrime, 'GeneratePrime', cdRegister);
 S.RegisterDelphiFunction(@Inverse, 'Inverse', cdRegister);
 S.RegisterDelphiFunction(@Compute_RSA_Fundamentals_2Factors, 'Compute_RSA_Fundamentals_2Factors', cdRegister);
 S.RegisterDelphiFunction(@Validate_RSA_Fundamentals, 'Validate_RSA_Fundamentals', cdRegister);

 S.RegisterDelphiFunction(@AnsiBytesOf, 'AnsiBytesOf', cdRegister);
 S.RegisterDelphiFunction(@GetBytes, 'GetBytes', cdRegister);
 S.RegisterDelphiFunction(@GetBytesInt, 'GetBytesInt', cdRegister);
 S.RegisterDelphiFunction(@HugeToBase10, 'HugeToBase10', cdRegister);

 //function HugeToBase10(const AHuge: THugeCardinal): string;

 //CL.AddDelphiFunction('function AnsiBytesOf(const S: string): TBytes;');
 //CL.AddDelphiFunction('function GetBytes(value: string): TBytes;');
 //CL.AddDelphiFunction('function GetBytesInt(value: Smallint): TBytes;');


end;



{ TPSImport_uTPLb_HugeCardinalUtils }
(*----------------------------------------------------------------------------*)
procedure TPSImport_uTPLb_HugeCardinalUtils.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_uTPLb_HugeCardinalUtils(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_uTPLb_HugeCardinalUtils.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  //RIRegister_uTPLb_HugeCardinalUtils(ri);
  RIRegister_uTPLb_HugeCardinalUtils_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
