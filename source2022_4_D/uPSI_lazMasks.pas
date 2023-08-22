unit uPSI_lazMasks;
{
  the mask
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
  TPSImport_lazMasks = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TMaskList(CL: TPSPascalCompiler);
procedure SIRegister_TParseStringList(CL: TPSPascalCompiler);
procedure SIRegister_TMask(CL: TPSPascalCompiler);
procedure SIRegister_lazMasks(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_lazMasks_Routines(S: TPSExec);
procedure RIRegister_TMaskList(CL: TPSRuntimeClassImporter);
procedure RIRegister_TParseStringList(CL: TPSRuntimeClassImporter);
procedure RIRegister_TMask(CL: TPSRuntimeClassImporter);
procedure RIRegister_lazMasks(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   Contnrs
  ,StrUtils
  ,lazMasks
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_lazMasks]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TMaskList(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOBJECT', 'TMaskList') do
  with CL.AddClassN(CL.FindClass('TOBJECT'),'TMaskList') do begin
    RegisterMethod('Constructor Create( const AValue : String; ASeparator : Char; const CaseSensitive : Boolean)');
      RegisterMethod('Procedure Free');
      RegisterMethod('Function Matches( const AFileName : String) : Boolean');
    RegisterMethod('Function MatchesWindowsMask( const AFileName : String) : Boolean');
    RegisterProperty('Count', 'Integer', iptr);
    RegisterProperty('Items', 'TMask Integer', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TParseStringList(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TStringList', 'TParseStringList') do
  with CL.AddClassN(CL.FindClass('TStringList'),'TParseStringList') do
  begin
    RegisterMethod('Constructor Create( const AText, ASeparators : String)');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TMask(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOBJECT', 'TMask') do
  with CL.AddClassN(CL.FindClass('TOBJECT'),'TMask') do begin
    RegisterMethod('Constructor Create( const AValue : String; const CaseSensitive : Boolean)');
      RegisterMethod('Procedure Free');
      RegisterMethod('Function Matches( const AFileName : String) : Boolean');
    RegisterMethod('Function MatchesWindowsMask( const AFileName : String) : Boolean');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_lazMasks(CL: TPSPascalCompiler);
begin
  CL.AddTypeS('TMaskCharType', '( mcChar, mcCharSet, mcAnyChar, mcAnyText )');
  //CL.AddTypeS('TCharSet', 'set of Char');
 // CL.AddTypeS('TMaskString', 'record MinLength : Integer; MaxLength : Integer; '
   //+'Chars : array of TMaskChar; end');
  SIRegister_TMask(CL);
  SIRegister_TParseStringList(CL);
  SIRegister_TMaskList(CL);
 CL.AddDelphiFunction('Function MatchesMask( const FileName, Mask : String; const CaseSensitive : Boolean) : Boolean');
 CL.AddDelphiFunction('Function MatchesWindowsMask( const FileName, Mask : String; const CaseSensitive : Boolean) : Boolean');
 CL.AddDelphiFunction('Function MatchesMaskList( const FileName, Mask : String; Separator : Char; const CaseSensitive : Boolean) : Boolean');
 CL.AddDelphiFunction('Function MatchesWindowsMaskList( const FileName, Mask : String; Separator : Char; const CaseSensitive : Boolean) : Boolean');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TMaskListItems_R(Self: TMaskList; var T: TMask; const t1: Integer);
begin T := Self.Items[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TMaskListCount_R(Self: TMaskList; var T: Integer);
begin T := Self.Count; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_lazMasks_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@MatchesMask, 'MatchesMask', cdRegister);
 S.RegisterDelphiFunction(@MatchesWindowsMask, 'MatchesWindowsMask', cdRegister);
 S.RegisterDelphiFunction(@MatchesMaskList, 'MatchesMaskList', cdRegister);
 S.RegisterDelphiFunction(@MatchesWindowsMaskList, 'MatchesWindowsMaskList', cdRegister);
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TMaskList(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TMaskList) do begin
    RegisterConstructor(@TMaskList.Create, 'Create');
    RegisterMethod(@TMaskList.Destroy, 'Free');
    RegisterMethod(@TMaskList.Matches, 'Matches');
    RegisterMethod(@TMaskList.MatchesWindowsMask, 'MatchesWindowsMask');
    RegisterPropertyHelper(@TMaskListCount_R,nil,'Count');
    RegisterPropertyHelper(@TMaskListItems_R,nil,'Items');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TParseStringList(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TParseStringList) do
  begin
    RegisterConstructor(@TParseStringList.Create, 'Create');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TMask(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TMask) do begin
    RegisterConstructor(@TMask.Create, 'Create');
      RegisterMethod(@TMaskList.Destroy, 'Free');
    RegisterMethod(@TMask.Matches, 'Matches');
    RegisterMethod(@TMask.MatchesWindowsMask, 'MatchesWindowsMask');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_lazMasks(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TMask(CL);
  RIRegister_TParseStringList(CL);
  RIRegister_TMaskList(CL);
end;

 
 
{ TPSImport_lazMasks }
(*----------------------------------------------------------------------------*)
procedure TPSImport_lazMasks.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_lazMasks(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_lazMasks.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_lazMasks(ri);
  RIRegister_lazMasks_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
