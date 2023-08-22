unit uPSI_JvRle;
{
  to compress
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
  TPSImport_JvRle = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_JvRle(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_JvRle_Routines(S: TPSExec);

procedure Register;

implementation


uses
   JvRle;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_JvRle]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_JvRle(CL: TPSPascalCompiler);
begin
 CL.AddDelphiFunction('Procedure RleCompress2( Stream : TStream)');
 CL.AddDelphiFunction('Procedure RleDecompress2( Stream : TStream)');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure RIRegister_JvRle_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@RleCompress, 'RleCompress2', cdRegister);
 S.RegisterDelphiFunction(@RleDecompress, 'RleDecompress2', cdRegister);
end;

 
 
{ TPSImport_JvRle }
(*----------------------------------------------------------------------------*)
procedure TPSImport_JvRle.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_JvRle(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_JvRle.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  //RIRegister_JvRle(ri);
  RIRegister_JvRle_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
