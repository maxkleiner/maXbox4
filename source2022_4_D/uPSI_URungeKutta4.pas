unit uPSI_URungeKutta4;
{
for the catapult simulator    - a second system
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
  TPSImport_URungeKutta4 = class(TPSPlugin)
  public
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_URungeKutta4(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_URungeKutta4_Routines(S: TPSExec);

procedure Register;

implementation


uses
   URungeKutta4
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_URungeKutta4]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_URungeKutta4(CL: TPSPascalCompiler);
begin
 CL.AddConstantN('maxfuncs2','LongInt').SetInt( 10);
  //CL.AddTypeS('float', 'extended');
  CL.AddTypeS('TUserFunction2', 'Function ( T, X, XPrime : double) : double');
  CL.AddTypeS('TUserCallBackFunction2', 'Function ( T, X, XPrime : double) : Boolean');
  CL.AddTypeS('TNData2', 'record X : double; xPrime : double; end');
  CL.AddTypeS('TNvector2', 'array[0..maxfuncs2] of TNData2;');

 // TFuncVect  = array[1..MaxFuncs] of TUserFunctionV;

  // TNvector = array[0..maxfuncs] of TNData;
  CL.AddTypeS('TUserFunctionV2', 'Function ( V : TNVector2) : double');
  CL.AddTypeS('TFuncVect2', 'array[1..MaxFuncs2] of TUserFunctionV2;');
  CL.AddTypeS('TUserCallbackFunctionV2', 'Function ( V : TNVector2) : boolean');
 CL.AddDelphiFunction('Procedure RungeKutta2ndOrderIC2( LowerLimit : double; UpperLimit : double; InitialValue : double; InitialDeriv : double; ReturnInterval : double; CalcInterval : double; var Error : byte; UserFunc:TUserFunctionV2; UserCallBack: TUserCallbackFunctionV2)');
 CL.AddDelphiFunction('Procedure RungeKutta2ndOrderIC_System2(LowerLimit:double; UpperLimit: double; InitialValues : TNVector2; ReturnInterval: double; CalcInterval: double; var Error: byte; NumEquations: Integer; Vector: TFuncVect2; UserCallBack: TUserCallbackFunctionV2)');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure RIRegister_URungeKutta4_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@RungeKutta2ndOrderIC, 'RungeKutta2ndOrderIC2', cdRegister);
 S.RegisterDelphiFunction(@RungeKutta2ndOrderIC_System, 'RungeKutta2ndOrderIC_System2', cdRegister);
end;

 
 
{ TPSImport_URungeKutta4 }
(*----------------------------------------------------------------------------*)
procedure TPSImport_URungeKutta4.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_URungeKutta4(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_URungeKutta4.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_URungeKutta4_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
