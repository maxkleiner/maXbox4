unit uPSI_SynEditWildcardSearch;
{
  from regex inherit
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
  TPSImport_SynEditWildcardSearch = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TSynEditWildcardSearch(CL: TPSPascalCompiler);
procedure SIRegister_SynEditWildcardSearch(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TSynEditWildcardSearch(CL: TPSRuntimeClassImporter);
procedure RIRegister_SynEditWildcardSearch(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   SynEdit
  ,SynEditTypes
  ,SynRegExpr
  ,SynEditRegexSearch
  ,SynEditWildcardSearch
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_SynEditWildcardSearch]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TSynEditWildcardSearch(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TSynEditRegexSearch', 'TSynEditWildcardSearch') do
  with CL.AddClassN(CL.FindClass('TSynEditRegexSearch'),'TSynEditWildcardSearch') do
  begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
    RegisterMethod('Function FindAll( const NewText : string) : integer');
    RegisterMethod('Function Replace( const aOccurrence, aReplacement : string) : string');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_SynEditWildcardSearch(CL: TPSPascalCompiler);
begin
  SIRegister_TSynEditWildcardSearch(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure RIRegister_TSynEditWildcardSearch(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TSynEditWildcardSearch) do
  begin
    RegisterConstructor(@TSynEditWildcardSearch.Create, 'Create');
    RegisterMethod(@TSynEditWildcardSearch.FindAll, 'FindAll');
    RegisterMethod(@TSynEditWildcardSearch.Replace, 'Replace');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_SynEditWildcardSearch(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TSynEditWildcardSearch(CL);
end;

 
 
{ TPSImport_SynEditWildcardSearch }
(*----------------------------------------------------------------------------*)
procedure TPSImport_SynEditWildcardSearch.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_SynEditWildcardSearch(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_SynEditWildcardSearch.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_SynEditWildcardSearch(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
