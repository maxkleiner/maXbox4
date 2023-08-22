unit uPSI_HSLUtils;
{
another graph math path

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
  TPSImport_HSLUtils = class(TPSPlugin)
  public
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_HSLUtils(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_HSLUtils_Routines(S: TPSExec);

procedure Register;

implementation


uses
   Windows
  ,Graphics
  ,HSLUtils
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_HSLUtils]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_HSLUtils(CL: TPSPascalCompiler);
begin
 CL.AddDelphiFunction('Function ARGB( a, r, g, b : Byte) : Cardinal');
 CL.AddDelphiFunction('Function GetAValue2( argb : DWORD) : Byte');
 CL.AddDelphiFunction('Function GetRValue2( argb : DWORD) : Byte');
 CL.AddDelphiFunction('Function GetGValue2( argb : DWORD) : Byte');
 CL.AddDelphiFunction('Function GetBValue2( argb : DWORD) : Byte');
 CL.AddDelphiFunction('Function GetABGRAValue( abgr : DWORD) : Byte');
 CL.AddDelphiFunction('Function GetABGRRValue( abgr : DWORD) : Byte');
 CL.AddDelphiFunction('Function GetABGRGValue( abgr : DWORD) : Byte');
 CL.AddDelphiFunction('Function GetABGRBValue( abgr : DWORD) : Byte');
 CL.AddDelphiFunction('Function HSLtoRGB2( H, S, L : double) : TColor');
 CL.AddDelphiFunction('Function AHSLtoARGB( A, H, S, L : double) : Cardinal');
 CL.AddDelphiFunction('Function HSLRangeToRGB( H, S, L : integer) : TColor');
 CL.AddDelphiFunction('Procedure ARGBtoAHSL( ARGB : TColor; var A, H, S, L : double)');
 CL.AddDelphiFunction('Procedure ABGRtoAHSL( ABGR : TColor; var A, H, S, L : double)');
 CL.AddDelphiFunction('Procedure RGBtoHSLRange( RGB : TColor; var H, S, L : integer)');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure RIRegister_HSLUtils_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@ARGB, 'ARGB', cdRegister);
 S.RegisterDelphiFunction(@GetAValue, 'GetAValue2', cdRegister);
 S.RegisterDelphiFunction(@GetRValue, 'GetRValue2', cdRegister);
 S.RegisterDelphiFunction(@GetGValue, 'GetGValue2', cdRegister);
 S.RegisterDelphiFunction(@GetBValue, 'GetBValue2', cdRegister);
 S.RegisterDelphiFunction(@GetABGRAValue, 'GetABGRAValue', cdRegister);
 S.RegisterDelphiFunction(@GetABGRRValue, 'GetABGRRValue', cdRegister);
 S.RegisterDelphiFunction(@GetABGRGValue, 'GetABGRGValue', cdRegister);
 S.RegisterDelphiFunction(@GetABGRBValue, 'GetABGRBValue', cdRegister);
 S.RegisterDelphiFunction(@HSLtoRGB, 'HSLtoRGB2', cdRegister);
 S.RegisterDelphiFunction(@AHSLtoARGB, 'AHSLtoARGB', cdRegister);
 S.RegisterDelphiFunction(@HSLRangeToRGB, 'HSLRangeToRGB', cdRegister);
 S.RegisterDelphiFunction(@ARGBtoAHSL, 'ARGBtoAHSL', cdRegister);
 S.RegisterDelphiFunction(@ABGRtoAHSL, 'ABGRtoAHSL', cdRegister);
 S.RegisterDelphiFunction(@RGBtoHSLRange, 'RGBtoHSLRange', cdRegister);
end;

 
 
{ TPSImport_HSLUtils }
(*----------------------------------------------------------------------------*)
procedure TPSImport_HSLUtils.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_HSLUtils(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_HSLUtils.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_HSLUtils_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
