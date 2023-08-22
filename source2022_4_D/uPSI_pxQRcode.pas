unit uPSI_pxQRcode;
{
Tqr everywhre

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
  TPSImport_pxQRcode = class(TPSPlugin)
  public
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_pxQRcode(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_pxQRcode_Routines(S: TPSExec);

procedure Register;

implementation


uses
   Windows
  ,Graphics
  ,pxQRcode
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_pxQRcode]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_pxQRcode(CL: TPSPascalCompiler);
begin
 CL.AddConstantN('QR_ECLEVEL_L','LongInt').SetInt( 0);
 CL.AddConstantN('QR_ECLEVEL_M','LongInt').SetInt( 1);
 CL.AddConstantN('QR_ECLEVEL_Q','LongInt').SetInt( 2);
 CL.AddConstantN('QR_ECLEVEL_H','LongInt').SetInt( 3);
 CL.AddDelphiFunction('Procedure CreateQRCodeBMP( const AText : string; const ABitmapStream : TStream; const ALevel : Byte; const ASize : Integer)');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure RIRegister_pxQRcode_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@CreateQRCodeBMP, 'CreateQRCodeBMP', cdRegister);
end;

 
 
{ TPSImport_pxQRcode }
(*----------------------------------------------------------------------------*)
procedure TPSImport_pxQRcode.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_pxQRcode(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_pxQRcode.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_pxQRcode_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
