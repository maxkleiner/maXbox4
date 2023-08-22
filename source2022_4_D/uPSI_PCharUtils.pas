unit uPSI_PCharUtils;
{
  pchar function block
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
  TPSImport_PCharUtils = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;


{ compile-time registration functions }
procedure SIRegister_PCharUtils(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_PCharUtils_Routines(S: TPSExec);

procedure Register;

implementation


uses
   PCharUtils
  ;


procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_PCharUtils]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_PCharUtils(CL: TPSPascalCompiler);
begin
 CL.AddDelphiFunction('Function SkipWhite( cp : PChar) : PChar');
 CL.AddDelphiFunction('Function ReadStringDoubleQuotedMaybe( cp : PChar; var AStr : string) : PChar');
 CL.AddDelphiFunction('Function ReadStringSingleQuotedMaybe( cp : PChar; var AStr : string) : PChar');
 CL.AddDelphiFunction('Function ReadIdent( cp : PChar; var ident : string) : PChar');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure RIRegister_PCharUtils_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@SkipWhite, 'SkipWhite', cdRegister);
 S.RegisterDelphiFunction(@ReadStringDoubleQuotedMaybe, 'ReadStringDoubleQuotedMaybe', cdRegister);
 S.RegisterDelphiFunction(@ReadStringSingleQuotedMaybe, 'ReadStringSingleQuotedMaybe', cdRegister);
 S.RegisterDelphiFunction(@ReadIdent, 'ReadIdent', cdRegister);
end;



{ TPSImport_PCharUtils }
(*----------------------------------------------------------------------------*)
procedure TPSImport_PCharUtils.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_PCharUtils(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_PCharUtils.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  //RIRegister_PCharUtils(ri);
  RIRegister_PCharUtils_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
