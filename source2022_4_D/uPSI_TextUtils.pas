unit uPSI_TextUtils;
{
  test for regex
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
  TPSImport_TextUtils = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TextUtils(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TextUtils_Routines(S: TPSExec);

procedure Register;

implementation


uses
   TextUtils
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_TextUtils]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TextUtils(CL: TPSPascalCompiler);
begin
 CL.AddConstantN('UWhitespace','String').SetString( '(?:\s*)');
 CL.AddDelphiFunction('Function StripSpaces( const AText : string) : string');
 CL.AddDelphiFunction('Function CharCount( const AText : string; Ch : Char) : Integer');
 CL.AddDelphiFunction('Function BalancedText( const AText : string; const Ch1, Ch2 : Char; const Count : Integer) : string');
 CL.AddDelphiFunction('Function BalancedTextReg( const AText : string; const Ch1, Ch2 : Char; const Count : Integer) : string');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure RIRegister_TextUtils_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@StripSpaces, 'StripSpaces', cdRegister);
 S.RegisterDelphiFunction(@CharCount, 'CharCount', cdRegister);
 S.RegisterDelphiFunction(@BalancedText, 'BalancedText', cdRegister);
 S.RegisterDelphiFunction(@BalancedTextReg, 'BalancedTextReg', cdRegister);
end;

 
 
{ TPSImport_TextUtils }
(*----------------------------------------------------------------------------*)
procedure TPSImport_TextUtils.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_TextUtils(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_TextUtils.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  //RIRegister_TextUtils(ri);
  RIRegister_TextUtils_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
