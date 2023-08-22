unit uPSI_ufft;
{
    fast fourier transformation
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
  TPSImport_ufft = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_ufft(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_ufft_Routines(S: TPSExec);

procedure Register;

implementation


uses
   utypes
  ,umath
  ,ufft
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_ufft]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_ufft(CL: TPSPascalCompiler);
begin
 CL.AddDelphiFunction('Procedure FFT( NumSamples : Integer; InArray, OutArray : TCompVector)');
 CL.AddDelphiFunction('Procedure IFFT( NumSamples : Integer; InArray, OutArray : TCompVector)');
 CL.AddDelphiFunction('Procedure FFT_Integer( NumSamples : Integer; RealIn, ImagIn : TIntVector; OutArray : TCompVector)');
 CL.AddDelphiFunction('Procedure FFT_Integer_Cleanup');
 CL.AddDelphiFunction('Procedure CalcFrequency( NumSamples, FrequencyIndex : Integer; InArray : TCompVector; var FT : Complex)');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure RIRegister_ufft_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@FFT, 'FFT', cdRegister);
 S.RegisterDelphiFunction(@IFFT, 'IFFT', cdRegister);
 S.RegisterDelphiFunction(@FFT_Integer, 'FFT_Integer', cdRegister);
 S.RegisterDelphiFunction(@FFT_Integer_Cleanup, 'FFT_Integer_Cleanup', cdRegister);
 S.RegisterDelphiFunction(@CalcFrequency, 'CalcFrequency', cdRegister);
end;

 
 
{ TPSImport_ufft }
(*----------------------------------------------------------------------------*)
procedure TPSImport_ufft.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_ufft(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_ufft.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  //RIRegister_ufft(ri);
  RIRegister_ufft_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
