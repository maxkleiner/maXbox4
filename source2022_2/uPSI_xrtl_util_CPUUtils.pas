unit uPSI_xrtl_util_CPUUtils;
{
  first of Extendended RTL
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
  TPSImport_xrtl_util_CPUUtils = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;


{ compile-time registration functions }
procedure SIRegister_xrtl_util_CPUUtils(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_xrtl_util_CPUUtils_Routines(S: TPSExec);

procedure Register;

implementation


uses
   Windows
  ,xrtl_util_CPUUtils
  ;


procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_xrtl_util_CPUUtils]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_xrtl_util_CPUUtils(CL: TPSPascalCompiler);
begin
  CL.AddTypeS('TXRTLBitIndex', 'Integer');
  //CL.AddTypeS('PDWORDArray', '^TDWORDArray // will not work');
  (*CL.AddTypeS('PCardinalArray', '^TCardinalArray // will not work');
  CL.AddTypeS('PInt64Array', '^TInt64Array // will not work');
  CL.AddTypeS('PCardinalBytes', '^TCardinalBytes // will not work');
  CL.AddTypeS('PCardinalWords', '^TCardinalWords // will not work');
  CL.AddTypeS('PInt64Bytes', '^TInt64Bytes // will not work');
  CL.AddTypeS('PInt64Words', '^TInt64Words // will not work');
  CL.AddTypeS('PInt64DWords', '^TInt64DWords // will not work'); *)
 CL.AddDelphiFunction('Function XRTLSwapBits( Data : Cardinal; Bit1Index, Bit2Index : TXRTLBitIndex) : Cardinal');
 CL.AddDelphiFunction('Function XRTLBitTest( Data : Cardinal; BitIndex : TXRTLBitIndex) : Boolean');
 CL.AddDelphiFunction('Function XRTLBitSet( Data : Cardinal; BitIndex : TXRTLBitIndex) : Cardinal');
 CL.AddDelphiFunction('Function XRTLBitReset( Data : Cardinal; BitIndex : TXRTLBitIndex) : Cardinal');
 CL.AddDelphiFunction('Function XRTLBitComplement( Data : Cardinal; BitIndex : TXRTLBitIndex) : Cardinal');
 CL.AddDelphiFunction('Function XRTLSwapHiLo16( X : Word) : Word');
 CL.AddDelphiFunction('Function XRTLSwapHiLo32( X : Cardinal) : Cardinal');
 CL.AddDelphiFunction('Function XRTLSwapHiLo64( X : Int64) : Int64');
 CL.AddDelphiFunction('Function XRTLROL32( A, S : Cardinal) : Cardinal');
 CL.AddDelphiFunction('Function XRTLROR32( A, S : Cardinal) : Cardinal');
 CL.AddDelphiFunction('Function XRTLROL16( A : Word; S : Cardinal) : Word');
 CL.AddDelphiFunction('Function XRTLROR16( A : Word; S : Cardinal) : Word');
 CL.AddDelphiFunction('Function XRTLROL8( A : Byte; S : Cardinal) : Byte');
 CL.AddDelphiFunction('Function XRTLROR8( A : Byte; S : Cardinal) : Byte');
 //CL.AddDelphiFunction('Procedure XRTLXorBlock( I1, I2, O1 : PByteArray; Len : integer)');
 //CL.AddDelphiFunction('Procedure XRTLIncBlock( P : PByteArray; Len : integer)');
 CL.AddDelphiFunction('Procedure XRTLUMul64( const A, B : Integer; var MulL, MulH : Integer)');
 //CL.AddDelphiFunction('Function XRTLPointerAdd( Base : Pointer; Offset : Integer) : Pointer');
 //CL.AddDelphiFunction('Function XRTLPointerDist( P1, P2 : Pointer) : Integer');
 CL.AddDelphiFunction('Function XRTLPopulation( A : Cardinal) : Cardinal');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure RIRegister_xrtl_util_CPUUtils_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@XRTLSwapBits, 'XRTLSwapBits', CdStdCall);
 S.RegisterDelphiFunction(@XRTLBitTest, 'XRTLBitTest', CdStdCall);
 S.RegisterDelphiFunction(@XRTLBitSet, 'XRTLBitSet', CdStdCall);
 S.RegisterDelphiFunction(@XRTLBitReset, 'XRTLBitReset', CdStdCall);
 S.RegisterDelphiFunction(@XRTLBitComplement, 'XRTLBitComplement', CdStdCall);
 S.RegisterDelphiFunction(@XRTLSwapHiLo16, 'XRTLSwapHiLo16', cdRegister);
 S.RegisterDelphiFunction(@XRTLSwapHiLo32, 'XRTLSwapHiLo32', cdRegister);
 S.RegisterDelphiFunction(@XRTLSwapHiLo64, 'XRTLSwapHiLo64', cdRegister);
 S.RegisterDelphiFunction(@XRTLROL32, 'XRTLROL32', cdRegister);
 S.RegisterDelphiFunction(@XRTLROR32, 'XRTLROR32', cdRegister);
 S.RegisterDelphiFunction(@XRTLROL16, 'XRTLROL16', cdRegister);
 S.RegisterDelphiFunction(@XRTLROR16, 'XRTLROR16', cdRegister);
 S.RegisterDelphiFunction(@XRTLROL8, 'XRTLROL8', cdRegister);
 S.RegisterDelphiFunction(@XRTLROR8, 'XRTLROR8', cdRegister);
 S.RegisterDelphiFunction(@XRTLXorBlock, 'XRTLXorBlock', cdRegister);
 S.RegisterDelphiFunction(@XRTLIncBlock, 'XRTLIncBlock', cdRegister);
 S.RegisterDelphiFunction(@XRTLUMul64, 'XRTLUMul64', CdStdCall);
 S.RegisterDelphiFunction(@XRTLPointerAdd, 'XRTLPointerAdd', cdRegister);
 S.RegisterDelphiFunction(@XRTLPointerDist, 'XRTLPointerDist', cdRegister);
 S.RegisterDelphiFunction(@XRTLPopulation, 'XRTLPopulation', cdRegister);
end;

 
 
{ TPSImport_xrtl_util_CPUUtils }
(*----------------------------------------------------------------------------*)
procedure TPSImport_xrtl_util_CPUUtils.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_xrtl_util_CPUUtils(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_xrtl_util_CPUUtils.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  //RIRegister_xrtl_util_CPUUtils(ri);
  RIRegister_xrtl_util_CPUUtils_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
