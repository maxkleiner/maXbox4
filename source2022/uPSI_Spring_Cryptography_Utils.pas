unit uPSI_Spring_Cryptography_Utils;
{
  spring time 
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
  TPSImport_Spring_Cryptography_Utils = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_Spring_Cryptography_Utils(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_Spring_Cryptography_Utils_Routines(S: TPSExec);

procedure Register;

implementation


uses
   Spring_Cryptography_Utils;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_Spring_Cryptography_Utils]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_Spring_Cryptography_Utils(CL: TPSPascalCompiler);
begin
 CL.AddDelphiFunction('Function Endian( x : LongWord) : LongWord');
 CL.AddDelphiFunction('Function Endian64( x : Int64) : Int64');
 CL.AddDelphiFunction('Function spRol( x : LongWord; y : Byte) : LongWord');
 CL.AddDelphiFunction('Function spRor( x : LongWord; y : Byte) : LongWord');
 CL.AddDelphiFunction('Function Ror64( x : Int64; y : Byte) : Int64');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure RIRegister_Spring_Cryptography_Utils_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@Endian, 'Endian', cdRegister);
 S.RegisterDelphiFunction(@Endian64, 'Endian64', cdRegister);
 S.RegisterDelphiFunction(@Rol, 'spRol', cdRegister);
 S.RegisterDelphiFunction(@Ror, 'spRor', cdRegister);
 S.RegisterDelphiFunction(@Ror64, 'Ror64', cdRegister);
end;

 
 
{ TPSImport_Spring_Cryptography_Utils }
(*----------------------------------------------------------------------------*)
procedure TPSImport_Spring_Cryptography_Utils.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_Spring_Cryptography_Utils(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_Spring_Cryptography_Utils.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  //RIRegister_Spring_Cryptography_Utils(ri);
  RIRegister_Spring_Cryptography_Utils_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
