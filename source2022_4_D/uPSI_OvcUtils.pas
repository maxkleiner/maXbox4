unit uPSI_OvcUtils;
{
This file has been generated by UnitParser v0.7, written by M. Knight
and updated by NP. v/d Spek and George Birbilis. 
Source Code from Carlo Kok has been used to implement various sections of
UnitParser. Components of ROPS are used in the construction of UnitParser,
code implementing the class wrapper is taken from Carlo Kok's conv utility

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
  TPSImport_OvcUtils = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_OvcUtils(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_OvcUtils_Routines(S: TPSExec);

procedure Register;

implementation


uses
   OvcUtils
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_OvcUtils]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_OvcUtils(CL: TPSPascalCompiler);
begin
 CL.AddDelphiFunction('Procedure StripCharSeq( CharSeq : string; var Str : string)');
 CL.AddDelphiFunction('Procedure StripCharFromEnd( aChr : Char; var Str : string)');
 CL.AddDelphiFunction('Procedure StripCharFromFront( aChr : Char; var Str : string)');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure RIRegister_OvcUtils_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@StripCharSeq, 'StripCharSeq', cdRegister);
 S.RegisterDelphiFunction(@StripCharFromEnd, 'StripCharFromEnd', cdRegister);
 S.RegisterDelphiFunction(@StripCharFromFront, 'StripCharFromFront', cdRegister);
end;

 
 
{ TPSImport_OvcUtils }
(*----------------------------------------------------------------------------*)
procedure TPSImport_OvcUtils.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_OvcUtils(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_OvcUtils.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_OvcUtils(ri);
  RIRegister_OvcUtils_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
