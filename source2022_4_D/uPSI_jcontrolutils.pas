unit uPSI_jcontrolutils;
{
   just j
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
  TPSImport_jcontrolutils = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_jcontrolutils(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_jcontrolutils_Routines(S: TPSExec);

procedure Register;

implementation


uses
   Dialogs
  ,jcontrolutils
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_jcontrolutils]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_jcontrolutils(CL: TPSPascalCompiler);
begin
 CL.AddDelphiFunction('Function jCountChar( const s : string; ch : char) : integer');
 CL.AddDelphiFunction('Procedure jSplit( const Delimiter : char; Input : string; Strings : TStrings)');
 CL.AddDelphiFunction('Function jNormalizeDate( const Value : string; theValue : TDateTime; const theFormat : string) : string');
 CL.AddDelphiFunction('Function jNormalizeTime( const Value : string; theValue : TTime; const theFormat : string) : string');
 CL.AddDelphiFunction('Function jNormalizeDateTime( const Value : string; theValue : TDateTime; const theFormat : string) : string');
 CL.AddDelphiFunction('Function jNormalizeDateSeparator( const s : string) : string');
 CL.AddDelphiFunction('Function jIsValidDateString( const Value : string) : boolean');
 CL.AddDelphiFunction('Function jIsValidTimeString( const Value : string) : boolean');
 CL.AddDelphiFunction('Function jIsValidDateTimeString( const Value : string) : boolean');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure RIRegister_jcontrolutils_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@CountChar, 'jCountChar', cdRegister);
 S.RegisterDelphiFunction(@Split, 'jSplit', cdRegister);
 S.RegisterDelphiFunction(@NormalizeDate, 'jNormalizeDate', cdRegister);
 S.RegisterDelphiFunction(@NormalizeTime, 'jNormalizeTime', cdRegister);
 S.RegisterDelphiFunction(@NormalizeDateTime, 'jNormalizeDateTime', cdRegister);
 S.RegisterDelphiFunction(@NormalizeDateSeparator, 'jNormalizeDateSeparator', cdRegister);
 S.RegisterDelphiFunction(@IsValidDateString, 'jIsValidDateString', cdRegister);
 S.RegisterDelphiFunction(@IsValidTimeString, 'jIsValidTimeString', cdRegister);
 S.RegisterDelphiFunction(@IsValidDateTimeString, 'jIsValidDateTimeString', cdRegister);
end;

 
 
{ TPSImport_jcontrolutils }
(*----------------------------------------------------------------------------*)
procedure TPSImport_jcontrolutils.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_jcontrolutils(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_jcontrolutils.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  //RIRegister_jcontrolutils(ri);
  RIRegister_jcontrolutils_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
