unit uPSI_ustrings;
{
   my last strings lastring
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
  TPSImport_ustrings = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_ustrings(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_ustrings_Routines(S: TPSExec);

procedure Register;

implementation


uses
   utypes
  ,ustrings
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_ustrings]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_ustrings(CL: TPSPascalCompiler);
begin
 CL.AddDelphiFunction('Function LTrim( S : String) : String');
 CL.AddDelphiFunction('Function RTrim( S : String) : String');
 CL.AddDelphiFunction('Function uTrim( S : String) : String');
 CL.AddDelphiFunction('Function StrChar( N : Byte; C : Char) : String');
 CL.AddDelphiFunction('Function RFill( S : String; L : Byte) : String');
 CL.AddDelphiFunction('Function LFill( S : String; L : Byte) : String');
 CL.AddDelphiFunction('Function CFill( S : String; L : Byte) : String');
 CL.AddDelphiFunction('Function Replace( S : String; C1, C2 : Char) : String');
 CL.AddDelphiFunction('Function Extract( S : String; var Index : Byte; Delim : Char) : String');
 CL.AddDelphiFunction('Procedure Parse( S : String; Delim : Char; Field : TStrVector; var N : Byte)');
 CL.AddDelphiFunction('Procedure SetFormat( NumLength, MaxDec : Integer; FloatPoint, NSZero : Boolean)');
 CL.AddDelphiFunction('Function FloatStr( X : Float) : String');
 CL.AddDelphiFunction('Function IntStr( N : LongInt) : String');
 CL.AddDelphiFunction('Function uCompStr( Z : Complex) : String');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure RIRegister_ustrings_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@LTrim, 'LTrim', cdRegister);
 S.RegisterDelphiFunction(@RTrim, 'RTrim', cdRegister);
 S.RegisterDelphiFunction(@Trim, 'uTrim', cdRegister);
 S.RegisterDelphiFunction(@StrChar, 'StrChar', cdRegister);
 S.RegisterDelphiFunction(@RFill, 'RFill', cdRegister);
 S.RegisterDelphiFunction(@LFill, 'LFill', cdRegister);
 S.RegisterDelphiFunction(@CFill, 'CFill', cdRegister);
 S.RegisterDelphiFunction(@Replace, 'Replace', cdRegister);
 S.RegisterDelphiFunction(@Extract, 'Extract', cdRegister);
 S.RegisterDelphiFunction(@Parse, 'Parse', cdRegister);
 S.RegisterDelphiFunction(@SetFormat, 'SetFormat', cdRegister);
 S.RegisterDelphiFunction(@FloatStr, 'FloatStr', cdRegister);
 S.RegisterDelphiFunction(@IntStr, 'IntStr', cdRegister);
 S.RegisterDelphiFunction(@CompStr, 'uCompStr', cdRegister);
end;

 
 
{ TPSImport_ustrings }
(*----------------------------------------------------------------------------*)
procedure TPSImport_ustrings.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_ustrings(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_ustrings.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  //RIRegister_ustrings(ri);
  RIRegister_ustrings_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
