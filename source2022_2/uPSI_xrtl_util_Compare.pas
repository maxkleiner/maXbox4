unit uPSI_xrtl_util_Compare;
{
  for values
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
  TPSImport_xrtl_util_Compare = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_IXRTLComparator(CL: TPSPascalCompiler);
procedure SIRegister_IXRTLComparable(CL: TPSPascalCompiler);
procedure SIRegister_xrtl_util_Compare(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_xrtl_util_Compare_Routines(S: TPSExec);

procedure Register;

implementation


uses
   xrtl_util_Type
  ,xrtl_util_Compat
  ,xrtl_util_Compare
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_xrtl_util_Compare]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_IXRTLComparator(CL: TPSPascalCompiler);
begin
  //with RegInterfaceS(CL,'IUNKNOWN', 'IXRTLComparator') do
  with CL.AddInterface(CL.FindInterface('IUNKNOWN'),IXRTLComparator, 'IXRTLComparator') do
  begin
    RegisterMethod('Function Compare( const LValue, RValue : IInterface) : TXRTLValueRelationship', cdRegister);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_IXRTLComparable(CL: TPSPascalCompiler);
begin
  //with RegInterfaceS(CL,'IUNKNOWN', 'IXRTLComparable') do
  with CL.AddInterface(CL.FindInterface('IUNKNOWN'),IXRTLComparable, 'IXRTLComparable') do
  begin
    RegisterMethod('Function Compare( const IValue : IInterface) : TXRTLValueRelationship', cdRegister);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_xrtl_util_Compare(CL: TPSPascalCompiler);
begin
 CL.AddConstantN('XRTLLessThanValue','LongInt').SetInt( - 1);
 CL.AddConstantN('XRTLEqualsValue','LongInt').SetInt( 0);
 CL.AddConstantN('XRTLGreaterThanValue','LongInt').SetInt( 1);
  SIRegister_IXRTLComparable(CL);
  SIRegister_IXRTLComparator(CL);
 //CL.AddDelphiFunction('Function XRTLInvertNonEqualRelationship( const AValue : TXRTLValueRelationship) : TXRTLValueRelationship');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure RIRegister_xrtl_util_Compare_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@XRTLInvertNonEqualRelationship, 'XRTLInvertNonEqualRelationship', cdRegister);
end;

 
 
{ TPSImport_xrtl_util_Compare }
(*----------------------------------------------------------------------------*)
procedure TPSImport_xrtl_util_Compare.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_xrtl_util_Compare(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_xrtl_util_Compare.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_xrtl_util_Compare_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
