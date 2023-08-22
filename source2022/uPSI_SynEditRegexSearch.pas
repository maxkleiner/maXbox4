unit uPSI_SynEditRegexSearch;
{
  no QT left
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
  TPSImport_SynEditRegexSearch = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TSynEditRegexSearch(CL: TPSPascalCompiler);
procedure SIRegister_SynEditRegexSearch(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TSynEditRegexSearch(CL: TPSRuntimeClassImporter);
procedure RIRegister_SynEditRegexSearch(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   {QSynEditTypes
  ,QSynRegExpr
  ,QSynEditMiscClasses}
  SynEditTypes
  ,SynRegExpr
  ,SynEditMiscClasses
  ,SynEditRegexSearch
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_SynEditRegexSearch]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TSynEditRegexSearch(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TSynEditSearchCustom', 'TSynEditRegexSearch') do
  with CL.AddClassN(CL.FindClass('TSynEditSearchCustom'),'TSynEditRegexSearch') do
  begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
    RegisterMethod('Function FindAll( const NewText : string) : integer');
    RegisterMethod('Function Replace( const aOccurrence, aReplacement : string) : string');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_SynEditRegexSearch(CL: TPSPascalCompiler);
begin
  SIRegister_TSynEditRegexSearch(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure RIRegister_TSynEditRegexSearch(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TSynEditRegexSearch) do begin
    RegisterConstructor(@TSynEditRegexSearch.Create, 'Create');
    RegisterMethod(@TSynEditRegexSearch.FindAll, 'FindAll');
    RegisterMethod(@TSynEditRegexSearch.Replace, 'Replace');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_SynEditRegexSearch(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TSynEditRegexSearch(CL);
end;

 
 
{ TPSImport_SynEditRegexSearch }
(*----------------------------------------------------------------------------*)
procedure TPSImport_SynEditRegexSearch.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_SynEditRegexSearch(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_SynEditRegexSearch.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_SynEditRegexSearch(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
