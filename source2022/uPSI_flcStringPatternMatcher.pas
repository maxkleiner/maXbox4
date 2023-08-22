unit uPSI_flcStringPatternMatcher;
{
Tmatch the pattern for Recognition

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
  TPSImport_flcStringPatternMatcher = class(TPSPlugin)
  public
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_flcStringPatternMatcher(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_flcStringPatternMatcher_Routines(S: TPSExec);

procedure Register;

implementation


uses
   flcStdTypes
  ,flcStringPatternMatcher
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_flcStringPatternMatcher]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_flcStringPatternMatcher(CL: TPSPascalCompiler);
begin
  CL.AddTypeS('TMatchPatternGreed', '( mpgLazy, mpgGreedy, mpgGreedyNoBacktrack)');
 //CL.AddDelphiFunction('Function StrZMatchPatternA( M, S : PAnsiChar; const G : TMatchPatternGreed) : Integer');
 //CL.AddDelphiFunction('Function StrZMatchPatternW( M, S : PWideChar; const G : TMatchPatternGreed) : Integer');
 CL.AddDelphiFunction('Function StrEqualPatternA( const M, S : RawByteString; const G : TMatchPatternGreed) : Boolean');
 CL.AddDelphiFunction('Function StrEqualPatternU( const M, S : UnicodeString; const G : TMatchPatternGreed) : Boolean');
 CL.AddDelphiFunction('Function StrEqualPattern( const M, S : String; const G : TMatchPatternGreed) : Boolean');
 CL.AddDelphiFunction('Function StrPosPatternA( const F, S : RawByteString; var Len : Integer; const StartIndex : Integer; const G : TMatchPatternGreed) : Integer');
 CL.AddDelphiFunction('Function StrPosPatternU( const F, S : UnicodeString; var Len : Integer; const StartIndex : Integer; const G : TMatchPatternGreed) : Integer');
 CL.AddDelphiFunction('Function MatchFileMaskB( const Mask, Key : RawByteString; const AsciiCaseSensitive : Boolean) : Boolean');
  CL.AddTypeS('TMatchQuantifier', '( mqOnce, mqAny, mqLeastOnce, mqOptional )');
  CL.AddTypeS('TMatchQuantSeqOptions', '(moDeterministic, moNonGreedy )');
 //CL.AddDelphiFunction('Function MatchQuantSeqB( var MatchPos : Integer; const MatchSeq : array of ByteCharSet; const Quant : array of TMatchQuantifier; const S : RawByteString; const MatchOptions : TMatchQuantSeqOptions; const StartIndex : Integer; const StopIndex : Integer) : Boolean');
 CL.AddDelphiFunction('Procedure TestPatternmatcher');
 CL.AddDelphiFunction('function CharMatch(const A, B: Char; const AsciiCaseSensitive: Boolean): Boolean;');

end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure RIRegister_flcStringPatternMatcher_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@StrZMatchPatternA, 'StrZMatchPatternA', cdRegister);
 S.RegisterDelphiFunction(@StrZMatchPatternW, 'StrZMatchPatternW', cdRegister);
 S.RegisterDelphiFunction(@StrEqualPatternA, 'StrEqualPatternA', cdRegister);
 S.RegisterDelphiFunction(@StrEqualPatternU, 'StrEqualPatternU', cdRegister);
 S.RegisterDelphiFunction(@StrEqualPattern, 'StrEqualPattern', cdRegister);
 S.RegisterDelphiFunction(@StrPosPatternA, 'StrPosPatternA', cdRegister);
 S.RegisterDelphiFunction(@StrPosPatternU, 'StrPosPatternU', cdRegister);
 S.RegisterDelphiFunction(@MatchFileMaskB, 'MatchFileMaskB', cdRegister);
 S.RegisterDelphiFunction(@MatchQuantSeqB, 'MatchQuantSeqB', cdRegister);
 S.RegisterDelphiFunction(@TestPatternmatcher, 'TestPatternmatcher', cdRegister);
 S.RegisterDelphiFunction(@CharMatch, 'CharMatch', cdRegister);

end;

 
 
{ TPSImport_flcStringPatternMatcher }
(*----------------------------------------------------------------------------*)
procedure TPSImport_flcStringPatternMatcher.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_flcStringPatternMatcher(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_flcStringPatternMatcher.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_flcStringPatternMatcher_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
