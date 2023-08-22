unit uPSI_crc_checks;
{
checks and tests

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
  TPSImport_crc = class(TPSPlugin)
  public
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_crc(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_crc_Routines(S: TPSExec);

procedure Register;

implementation


uses
   xutils
  {,tpautils
  ,vpautils
  ,fpautils
  ,dpautils
  ,gpautils }
  ,crc_checks
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_crc]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_crc(CL: TPSPascalCompiler);
begin
 CL.AddDelphiFunction('Function UpdateCrc32_2( InitCrc : longword; b : byte) : longword');
 CL.AddDelphiFunction('Function UpdateCrc16_2( InitCrc : word; b : byte) : word');
 CL.AddDelphiFunction('Function UpdateAdler32( InitAdler : longword; b : byte) : longword');
 CL.AddDelphiFunction('Function UpdateFletcher8( InitFletcher : word; b : byte) : word');
 CL.AddDelphiFunction('Function UpdateCRC( InitCrc : word; b : byte) : word');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure RIRegister_crc_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@UpdateCrc32, 'UpdateCrc32_2', cdRegister);
 S.RegisterDelphiFunction(@UpdateCrc16, 'UpdateCrc16_2', cdRegister);
 S.RegisterDelphiFunction(@UpdateAdler32, 'UpdateAdler32', cdRegister);
 S.RegisterDelphiFunction(@UpdateFletcher8, 'UpdateFletcher8', cdRegister);
 S.RegisterDelphiFunction(@UpdateCRC, 'UpdateCRC', cdRegister);
end;

 
 
{ TPSImport_crc }
(*----------------------------------------------------------------------------*)
procedure TPSImport_crc.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_crc(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_crc.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_crc_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
