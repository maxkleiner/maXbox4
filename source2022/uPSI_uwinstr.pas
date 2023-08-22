unit uPSI_uwinstr;
{
   smart string
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
  TPSImport_uwinstr = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_uwinstr(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_uwinstr_Routines(S: TPSExec);

procedure Register;

implementation


uses
   utypes
  ,ustrings
  ,StdCtrls
  ,uwinstr
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_uwinstr]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_uwinstr(CL: TPSPascalCompiler);
begin
 CL.AddDelphiFunction('Function StrDec( S : String) : String');
 CL.AddDelphiFunction('Function uIsNumeric( var S : String; var X : Float) : Boolean');
 CL.AddDelphiFunction('Function ReadNumFromEdit( Edit : TEdit) : Float');
 CL.AddDelphiFunction('Procedure WriteNumToFile( var F : Text; X : Float)');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure RIRegister_uwinstr_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@StrDec, 'StrDec', cdRegister);
 S.RegisterDelphiFunction(@IsNumeric, 'uIsNumeric', cdRegister);
 S.RegisterDelphiFunction(@ReadNumFromEdit, 'ReadNumFromEdit', cdRegister);
 S.RegisterDelphiFunction(@WriteNumToFile, 'WriteNumToFile', cdRegister);
end;

 
 
{ TPSImport_uwinstr }
(*----------------------------------------------------------------------------*)
procedure TPSImport_uwinstr.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_uwinstr(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_uwinstr.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  //RIRegister_uwinstr(ri);
  RIRegister_uwinstr_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
