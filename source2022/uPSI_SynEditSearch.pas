unit uPSI_SynEditSearch;
{
  to class filesearch
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
  TPSImport_SynEditSearch = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TSynEditSearch(CL: TPSPascalCompiler);
procedure SIRegister_SynEditSearch(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TSynEditSearch(CL: TPSRuntimeClassImporter);
procedure RIRegister_SynEditSearch(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
  // QSynEditTypes
  //,QSynEditMiscClasses
  SynEditTypes
  ,SynEditMiscClasses
  ,SynEditSearch
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_SynEditSearch]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TSynEditSearch(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TSynEditSearchCustom', 'TSynEditSearch') do
  with CL.AddClassN(CL.FindClass('TSynEditSearchCustom'),'TSynEditSearch') do begin
    RegisterMethod('Constructor Create( aOwner : TComponent)');
    RegisterMethod('Procedure Free');
    RegisterMethod('Function FindAll( const NewText : string) : integer');
    RegisterMethod('Function Replace( const aOccurrence, aReplacement : string) : string');
    RegisterMethod('Function FindFirst( const NewText : string) : Integer');
    RegisterMethod('Procedure FixResults( First, Delta : integer)');
    RegisterMethod('Function Next : Integer');
    RegisterProperty('Count', 'Integer', iptrw);
    RegisterProperty('Finished', 'Boolean', iptr);
    RegisterProperty('Pattern', 'string', iptr);
    RegisterProperty('Sensitive', 'Boolean', iptrw);
    RegisterProperty('Whole', 'Boolean', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_SynEditSearch(CL: TPSPascalCompiler);
begin
  SIRegister_TSynEditSearch(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TSynEditSearchWhole_W(Self: TSynEditSearch; const T: Boolean);
begin Self.Whole := T; end;

(*----------------------------------------------------------------------------*)
procedure TSynEditSearchWhole_R(Self: TSynEditSearch; var T: Boolean);
begin T := Self.Whole; end;

(*----------------------------------------------------------------------------*)
procedure TSynEditSearchSensitive_W(Self: TSynEditSearch; const T: Boolean);
begin Self.Sensitive := T; end;

(*----------------------------------------------------------------------------*)
procedure TSynEditSearchSensitive_R(Self: TSynEditSearch; var T: Boolean);
begin T := Self.Sensitive; end;

(*----------------------------------------------------------------------------*)
procedure TSynEditSearchPattern_R(Self: TSynEditSearch; var T: string);
begin T := Self.Pattern; end;

(*----------------------------------------------------------------------------*)
procedure TSynEditSearchFinished_R(Self: TSynEditSearch; var T: Boolean);
begin T := Self.Finished; end;

(*----------------------------------------------------------------------------*)
procedure TSynEditSearchCount_W(Self: TSynEditSearch; const T: Integer);
begin Self.Count := T; end;

(*----------------------------------------------------------------------------*)
procedure TSynEditSearchCount_R(Self: TSynEditSearch; var T: Integer);
begin T := Self.Count; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TSynEditSearch(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TSynEditSearch) do begin
    RegisterConstructor(@TSynEditSearch.Create, 'Create');
    RegisterMethod(@TSynEditSearch.Destroy, 'Free');
    RegisterMethod(@TSynEditSearch.FindAll, 'FindAll');
    RegisterMethod(@TSynEditSearch.Replace, 'Replace');
    RegisterMethod(@TSynEditSearch.FindFirst, 'FindFirst');
    RegisterMethod(@TSynEditSearch.FixResults, 'FixResults');
    RegisterMethod(@TSynEditSearch.Next, 'Next');
    RegisterPropertyHelper(@TSynEditSearchCount_R,@TSynEditSearchCount_W,'Count');
    RegisterPropertyHelper(@TSynEditSearchFinished_R,nil,'Finished');
    RegisterPropertyHelper(@TSynEditSearchPattern_R,nil,'Pattern');
    RegisterPropertyHelper(@TSynEditSearchSensitive_R,@TSynEditSearchSensitive_W,'Sensitive');
    RegisterPropertyHelper(@TSynEditSearchWhole_R,@TSynEditSearchWhole_W,'Whole');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_SynEditSearch(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TSynEditSearch(CL);
end;



{ TPSImport_SynEditSearch }
(*----------------------------------------------------------------------------*)
procedure TPSImport_SynEditSearch.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_SynEditSearch(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_SynEditSearch.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_SynEditSearch(ri);
end;
(*----------------------------------------------------------------------------*)


end.
