unit uPSI_uTPLb_BinaryUtils;
{
   bin lock box   to get maxcoin

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
  TPSImport_uTPLb_BinaryUtils = class(TPSPlugin)
  public
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_uTPLb_BinaryUtils(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_uTPLb_BinaryUtils_Routines(S: TPSExec);

procedure Register;

implementation


uses
   uTPLb_IntegerUtils
  ,uTPLb_BinaryUtils
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_uTPLb_BinaryUtils]);
end;

const HexSymbols = '0123456789ABCDEF';  

 function ByteArraytostring(const bin: array of byte): string;
var i: integer;
begin
  SetLength(Result, 2*Length(bin));
  //writeln('length: '+itoa(length(bin)));
  for i :=  0 to Length(bin)-1 do begin
    Result[1 + 2*i + 0] := HexSymbols[1 + bin[i] shr 4];
    Result[1 + 2*i + 1] := HexSymbols[1 + bin[i] and $0F];
  end;
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_uTPLb_BinaryUtils(CL: TPSPascalCompiler);
begin
 CL.AddDelphiFunction('Function SwapEndien_u32( Value : uint32) : uint32');
 CL.AddDelphiFunction('Function SwapEndien_s64( Value : int64) : int64');
 CL.AddDelphiFunction('Function SwapEndien_u64( Value : uint64) : uint64');
 CL.AddDelphiFunction('Function RotateLeft1Bit_u32( Value : uint32) : uint32');
 CL.AddDelphiFunction('Procedure Read_BigEndien_u32_Hex( const Value : string; BinaryOut : TStream)');
 CL.AddDelphiFunction('Function Get_TP_LockBox3_HINSTANCE : HMODULE');
 CL.AddDelphiFunction('function ByteArraytostring(const bin: array of byte): string');
 CL.AddDelphiFunction('function ByteArraytoHex(const bin: array of byte): string');

end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure RIRegister_uTPLb_BinaryUtils_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@SwapEndien_u32, 'SwapEndien_u32', cdRegister);
 S.RegisterDelphiFunction(@SwapEndien_s64, 'SwapEndien_s64', cdRegister);
 S.RegisterDelphiFunction(@SwapEndien_u64, 'SwapEndien_u64', cdRegister);
 S.RegisterDelphiFunction(@RotateLeft1Bit_u32, 'RotateLeft1Bit_u32', cdRegister);
 S.RegisterDelphiFunction(@Read_BigEndien_u32_Hex, 'Read_BigEndien_u32_Hex', cdRegister);
 S.RegisterDelphiFunction(@Get_TP_LockBox3_HINSTANCE, 'Get_TP_LockBox3_HINSTANCE', cdRegister);
 S.RegisterDelphiFunction(@ByteArraytostring, 'ByteArraytostring', cdRegister);
 S.RegisterDelphiFunction(@ByteArraytostring, 'ByteArraytoHex', cdRegister);

 end;

 
 
{ TPSImport_uTPLb_BinaryUtils }
(*----------------------------------------------------------------------------*)
procedure TPSImport_uTPLb_BinaryUtils.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_uTPLb_BinaryUtils(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_uTPLb_BinaryUtils.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_uTPLb_BinaryUtils_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
