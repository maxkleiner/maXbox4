unit uPSI_Jcl8087;
{
  from 8087 to ardu
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
  TPSImport_Jcl8087 = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_Jcl8087(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_Jcl8087_Routines(S: TPSExec);

procedure Register;

implementation


uses
   Jcl8087
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_Jcl8087]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_Jcl8087(CL: TPSPascalCompiler);
begin
  CL.AddTypeS('T8087Precision', '( pcSingle, pcReserved, pcDouble, pcExtended )');
  CL.AddTypeS('T8087Rounding', '( rcNearestOrEven, rcDownInfinity, rcUpInfinity, rcChopOrTruncate )');
  CL.AddTypeS('T8087Infinity', '( icProjective, icAffine )');
  CL.AddTypeS('T8087Exception', '( emInvalidOp, emDenormalizedOperand, emZeroDivide, emOverflow, emUnderflow, emPrecision )');
  CL.AddTypeS('T8087Exceptions', 'set of T8087Exception');
 CL.AddDelphiFunction('Function Get8087ControlWord : Word');
 CL.AddDelphiFunction('Function Get8087Infinity : T8087Infinity');
 CL.AddDelphiFunction('Function Get8087Precision : T8087Precision');
 CL.AddDelphiFunction('Function Get8087Rounding : T8087Rounding');
 CL.AddDelphiFunction('Function Get8087StatusWord( ClearExceptions : Boolean) : Word');
 CL.AddDelphiFunction('Function Set8087Infinity( const Infinity : T8087Infinity) : T8087Infinity');
 CL.AddDelphiFunction('Function Set8087Precision( const Precision : T8087Precision) : T8087Precision');
 CL.AddDelphiFunction('Function Set8087Rounding( const Rounding : T8087Rounding) : T8087Rounding');
 CL.AddDelphiFunction('Function Set8087ControlWord( const Control : Word) : Word');
 CL.AddDelphiFunction('Function ClearPending8087Exceptions : T8087Exceptions');
 CL.AddDelphiFunction('Function GetPending8087Exceptions : T8087Exceptions');
 CL.AddDelphiFunction('Function GetMasked8087Exceptions : T8087Exceptions');
 CL.AddDelphiFunction('Function SetMasked8087Exceptions( Exceptions : T8087Exceptions; ClearBefore : Boolean) : T8087Exceptions');
 CL.AddDelphiFunction('Function Mask8087Exceptions( Exceptions : T8087Exceptions) : T8087Exceptions');
 CL.AddDelphiFunction('Function Unmask8087Exceptions( Exceptions : T8087Exceptions; ClearBefore : Boolean) : T8087Exceptions');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure RIRegister_Jcl8087_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@Get8087ControlWord, 'Get8087ControlWord', cdRegister);
 S.RegisterDelphiFunction(@Get8087Infinity, 'Get8087Infinity', cdRegister);
 S.RegisterDelphiFunction(@Get8087Precision, 'Get8087Precision', cdRegister);
 S.RegisterDelphiFunction(@Get8087Rounding, 'Get8087Rounding', cdRegister);
 S.RegisterDelphiFunction(@Get8087StatusWord, 'Get8087StatusWord', cdRegister);
 S.RegisterDelphiFunction(@Set8087Infinity, 'Set8087Infinity', cdRegister);
 S.RegisterDelphiFunction(@Set8087Precision, 'Set8087Precision', cdRegister);
 S.RegisterDelphiFunction(@Set8087Rounding, 'Set8087Rounding', cdRegister);
 S.RegisterDelphiFunction(@Set8087ControlWord, 'Set8087ControlWord', cdRegister);
 S.RegisterDelphiFunction(@ClearPending8087Exceptions, 'ClearPending8087Exceptions', cdRegister);
 S.RegisterDelphiFunction(@GetPending8087Exceptions, 'GetPending8087Exceptions', cdRegister);
 S.RegisterDelphiFunction(@GetMasked8087Exceptions, 'GetMasked8087Exceptions', cdRegister);
 S.RegisterDelphiFunction(@SetMasked8087Exceptions, 'SetMasked8087Exceptions', cdRegister);
 S.RegisterDelphiFunction(@Mask8087Exceptions, 'Mask8087Exceptions', cdRegister);
 S.RegisterDelphiFunction(@Unmask8087Exceptions, 'Unmask8087Exceptions', cdRegister);
end;

 
 
{ TPSImport_Jcl8087 }
(*----------------------------------------------------------------------------*)
procedure TPSImport_Jcl8087.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_Jcl8087(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_Jcl8087.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  //RIRegister_Jcl8087(ri);
  RIRegister_Jcl8087_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
