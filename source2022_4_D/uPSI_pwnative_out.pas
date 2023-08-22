unit uPSI_pwnative_out;
{
  for cgi in 2015
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
  TPSImport_pwnative_out = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_pwnative_out(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_pwnative_out_Routines(S: TPSExec);

procedure Register;

implementation


uses
   pwtypes
  ,windows
  ,pwnative_out
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_pwnative_out]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_pwnative_out(CL: TPSPascalCompiler);
begin
 CL.AddConstantN('STDIN','LongInt').SetInt( 0);
 CL.AddConstantN('STDOUT','LongInt').SetInt( 1);
 CL.AddConstantN('STDERR','LongInt').SetInt( 2);
 CL.AddDelphiFunction('Procedure NativeWrite( s : ansistring);');
 CL.AddDelphiFunction('Procedure NativeWrite1( PString : PChar);');
 CL.AddDelphiFunction('Procedure NativeWrite2( Buffer : PChar; NumChars : Cardinal);');
 CL.AddDelphiFunction('Procedure NativeWriteLn( s : ansistring);');
 CL.AddDelphiFunction('Procedure NativeWriteLn1;');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
Procedure NativeWriteLn1_P;
Begin pwnative_out.NativeWriteLn; END;

(*----------------------------------------------------------------------------*)
Procedure NativeWriteLn_P( s : astr);
Begin pwnative_out.NativeWriteLn(s); END;

(*----------------------------------------------------------------------------*)
Procedure NativeWrite2_P( Buffer : PChar; NumChars : Cardinal);
Begin pwnative_out.NativeWrite(Buffer, NumChars); END;

(*----------------------------------------------------------------------------*)
Procedure NativeWrite1_P( PString : PChar);
Begin pwnative_out.NativeWrite(PString); END;

(*----------------------------------------------------------------------------*)
Procedure NativeWrite_P( s : astr);
Begin pwnative_out.NativeWrite(s); END;

(*----------------------------------------------------------------------------*)
procedure RIRegister_pwnative_out_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@NativeWrite, 'NativeWrite', cdRegister);
 S.RegisterDelphiFunction(@NativeWrite1_P, 'NativeWrite1', cdRegister);
 S.RegisterDelphiFunction(@NativeWrite2_P, 'NativeWrite2', cdRegister);
 S.RegisterDelphiFunction(@NativeWriteLn, 'NativeWriteLn', cdRegister);
 S.RegisterDelphiFunction(@NativeWriteLn1_P, 'NativeWriteLn1', cdRegister);
end;

 
 
{ TPSImport_pwnative_out }
(*----------------------------------------------------------------------------*)
procedure TPSImport_pwnative_out.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_pwnative_out(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_pwnative_out.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  //RIRegister_pwnative_out(ri);
  RIRegister_pwnative_out_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
