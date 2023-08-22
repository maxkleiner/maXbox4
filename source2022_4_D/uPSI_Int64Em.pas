unit uPSI_Int64Em;
{
   belongs to inno
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
  TPSImport_Int64Em = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_Int64Em(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_Int64Em_Routines(S: TPSExec);

procedure Register;

implementation


uses
   Int64Em
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_Int64Em]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_Int64Em(CL: TPSPascalCompiler);
begin
  //CL.AddTypeS('LongWord', 'Cardinal');
  CL.AddTypeS('Integer64', 'record Lo : LongWord; Hi : LongWord; end');
 CL.AddDelphiFunction('Function Compare64( const N1, N2 : Integer64) : Integer');
 CL.AddDelphiFunction('Procedure Dec64( var X : Integer64; N : LongWord)');
 CL.AddDelphiFunction('Procedure Dec6464( var X : Integer64; const N : Integer64)');
 CL.AddDelphiFunction('Function Div64( var X : Integer64; const Divisor : LongWord) : LongWord');
 CL.AddDelphiFunction('Function Inc64( var X : Integer64; N : LongWord) : Boolean');
 CL.AddDelphiFunction('Function Inc6464( var X : Integer64; const N : Integer64) : Boolean');
 CL.AddDelphiFunction('Function Integer64ToStr( X : Integer64) : String');
 CL.AddDelphiFunction('Function Mod64( const X : Integer64; const Divisor : LongWord) : LongWord');
 CL.AddDelphiFunction('Function Mul64( var X : Integer64; N : LongWord) : Boolean');
 CL.AddDelphiFunction('Procedure Multiply32x32to64( N1, N2 : LongWord; var X : Integer64)');
 CL.AddDelphiFunction('Procedure Shr64( var X : Integer64; Count : LongWord)');
 CL.AddDelphiFunction('Function StrToInteger64( const S : String; var X : Integer64) : Boolean');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure RIRegister_Int64Em_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@Compare64, 'Compare64', cdRegister);
 S.RegisterDelphiFunction(@Dec64, 'Dec64', cdRegister);
 S.RegisterDelphiFunction(@Dec6464, 'Dec6464', cdRegister);
 S.RegisterDelphiFunction(@Div64, 'Div64', cdRegister);
 S.RegisterDelphiFunction(@Inc64, 'Inc64', cdRegister);
 S.RegisterDelphiFunction(@Inc6464, 'Inc6464', cdRegister);
 S.RegisterDelphiFunction(@Integer64ToStr, 'Integer64ToStr', cdRegister);
 S.RegisterDelphiFunction(@Mod64, 'Mod64', cdRegister);
 S.RegisterDelphiFunction(@Mul64, 'Mul64', cdRegister);
 S.RegisterDelphiFunction(@Multiply32x32to64, 'Multiply32x32to64', cdRegister);
 S.RegisterDelphiFunction(@Shr64, 'Shr64', cdRegister);
 S.RegisterDelphiFunction(@StrToInteger64, 'StrToInteger64', cdRegister);
end;

 
 
{ TPSImport_Int64Em }
(*----------------------------------------------------------------------------*)
procedure TPSImport_Int64Em.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_Int64Em(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_Int64Em.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  //RIRegister_Int64Em(ri);
  RIRegister_Int64Em_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
