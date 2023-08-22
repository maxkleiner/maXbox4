unit uPSI_UcomboV2;
{
   int64 lexical
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
  TPSImport_UcomboV2 = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;


{ compile-time registration functions }
procedure SIRegister_TComboSet(CL: TPSPascalCompiler);
procedure SIRegister_UcomboV2(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TComboSet(CL: TPSRuntimeClassImporter);
procedure RIRegister_UcomboV2(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   UcomboV2
  ;


procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_UcomboV2]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TComboSet(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TObject', 'TComboSet') do
  with CL.AddClassN(CL.FindClass('TObject'),'TComboSet') do begin
    //RegisterProperty('Selected', 'TByteArray64 Integer', iptrw);
    RegisterProperty('Selected', 'TByteArray64', iptrw);
    RegisterProperty('RandomRank', 'int64', iptrw);
    RegisterMethod('Procedure Setup( newR, newN : word; NewCtype : TComboType)');
    RegisterMethod('Function Getnext : boolean');
    RegisterMethod('Function GetNextCombo : boolean');
    RegisterMethod('Function GetNextPermute : boolean');
    RegisterMethod('Function GetNextComboWithRep : Boolean');
    RegisterMethod('Function GetNextPermuteWithRep : Boolean');
    RegisterMethod('Function GetCount : int64');
    RegisterMethod('Function GetR : integer');
    RegisterMethod('Function GetN : integer');
    RegisterMethod('Function GetCtype : TCombotype');
    RegisterMethod('Function GetNumberSubsets( const RPick, Number : word; const ACtype : TComboType) : int64');
    RegisterMethod('Function Binomial( const RPick, Number : integer) : int64');
    RegisterMethod('Function Factorial( const Number : integer) : int64');
    RegisterMethod('Function GetRCombo( const RPick, Number : integer) : int64');
    RegisterMethod('Function GetRepRCombo( const RPick, Number : integer) : int64');
    RegisterMethod('Function GetRPermute( const RPick, Number : integer) : int64');
    RegisterMethod('Function GetRepRPermute( const RPick, Number : integer) : int64');
    RegisterMethod('Procedure SetupR( NewR, NewN : word; NewCtype : TComboType)');
    RegisterMethod('Procedure SetupRFirstLast( NewR, NewN : word; NewCType : TComboType)');
    RegisterMethod('Function IsValidRSequence : boolean');
    RegisterMethod('Function ChangeRDirection : boolean');
    RegisterMethod('Function GetNextPrevR : boolean');
    RegisterMethod('Function NextR : boolean');
    RegisterMethod('Function NextLexRPermute : boolean');
    RegisterMethod('Function NextLexRepRPermute : boolean');
    RegisterMethod('Function NextLexRCombo : boolean');
    RegisterMethod('Function NextLexRepRCombo : boolean');
    RegisterMethod('Function NextCoLexRCombo : boolean');
    RegisterMethod('Function PrevR : boolean');
    RegisterMethod('Function PrevCoLexRCombo : boolean');
    RegisterMethod('Function PrevLexRepRPermute : boolean');
    RegisterMethod('Function PrevLexRPermute : boolean');
    RegisterMethod('Function PrevLexRCombo : boolean');
    RegisterMethod('Function PrevLexRepRCombo : boolean');
    RegisterMethod('Function RankR : int64');
    RegisterMethod('Function RankCoLexRCombo : int64');
    RegisterMethod('Function RankLexRCombo : int64');
    RegisterMethod('Function RankLexRepRCombo : int64');
    RegisterMethod('Function RankLexRPermute : int64');
    RegisterMethod('Function RankLexRepRPermute : int64');
    RegisterMethod('Function UnRankR( const Rank : int64) : boolean');
    RegisterMethod('Function UnRankCoLexRCombo( const Rank : int64) : boolean');
    RegisterMethod('Function UnRankLexRCombo( const Rank : int64) : boolean');
    RegisterMethod('Function UnRankLexRepRCombo( const Rank : int64) : boolean');
    RegisterMethod('Function UnRankLexRPermute( const Rank : int64) : boolean');
    RegisterMethod('Function UnRankLexRepRPermute( const Rank : int64) : boolean');
    RegisterMethod('Function RandomR( const RPick, Number : int64; const NewCtype : TComboType) : Boolean');
    RegisterMethod('Function RandomCoLexRCombo( const RPick, Number : int64) : Boolean');
    RegisterMethod('Function RandomLexRCombo( const RPick, Number : int64) : Boolean');
    RegisterMethod('Function RandomLexRepRCombo( const RPick, Number : int64) : Boolean');
    RegisterMethod('Function RandomLexRPermute( const RPick, Number : int64) : Boolean');
    RegisterMethod('Function RandomLexRepRPermute( const RPick, Number : int64) : Boolean');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_UcomboV2(CL: TPSPascalCompiler);
begin
 CL.AddConstantN('UMaxEntries','LongInt').SetInt( 600);
  CL.AddTypeS('TCombotype', '( uCombinations, uPermutations, CombinationsDown, Pe'
   +'rmutationsDown, CombinationsCoLex, CombinationsCoLexDown, PermutationsRepe'
   +'at, PermutationsWithRep, PermutationsRepeatDown, CombinationsWithrep, CombinationsRepeat, CombinationsRepeatDown )');
  CL.AddTypeS('TByteArray64', 'array[0..600 + 1] of int64;');
  SIRegister_TComboSet(CL);
end;

  //type TByteArray64 = ByteArray;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TComboSetRandomRank_W(Self: TComboSet; const T: int64);
Begin Self.RandomRank := T; end;

(*----------------------------------------------------------------------------*)
procedure TComboSetRandomRank_R(Self: TComboSet; var T: int64);
Begin T := Self.RandomRank; end;

//procedure TLinearBitmapPixelColor_W(Self: TLinearBitmap; const T: TColor; const t1: Integer; const t2: Integer);
//begin Self.PixelColor[t1, t2] := T; end;


{
(*----------------------------------------------------------------------------*)
procedure TComboSetSelected_W(Self: TComboSet; const T: ByteArray; const t1: integer);
Begin Self.Selected[t1] := T[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TComboSetSelected_R(Self: TComboSet; var T: ByteArray; const t1: integer);
Begin T[t1] := Self.Selected[t1]; end;
}

procedure TComboSetSelected_W(Self: TComboSet; const T: TByteArray64);
Begin Self.Selected:= T; end;

(*----------------------------------------------------------------------------*)
procedure TComboSetSelected_R(Self: TComboSet; var T: TByteArray64);
Begin T := Self.Selected; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TComboSet(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TComboSet) do begin
    RegisterPropertyHelper(@TComboSetSelected_R,@TComboSetSelected_W,'Selected');
    RegisterPropertyHelper(@TComboSetRandomRank_R,@TComboSetRandomRank_W,'RandomRank');
    RegisterMethod(@TComboSet.Setup, 'Setup');
    RegisterMethod(@TComboSet.Getnext, 'Getnext');
    RegisterMethod(@TComboSet.GetNextCombo, 'GetNextCombo');
    RegisterMethod(@TComboSet.GetNextPermute, 'GetNextPermute');
    RegisterMethod(@TComboSet.GetNextComboWithRep, 'GetNextComboWithRep');
    RegisterMethod(@TComboSet.GetNextPermuteWithRep, 'GetNextPermuteWithRep');
    RegisterMethod(@TComboSet.GetCount, 'GetCount');
    RegisterMethod(@TComboSet.GetR, 'GetR');
    RegisterMethod(@TComboSet.GetN, 'GetN');
    RegisterMethod(@TComboSet.GetCtype, 'GetCtype');
    RegisterMethod(@TComboSet.GetNumberSubsets, 'GetNumberSubsets');
    RegisterMethod(@TComboSet.Binomial, 'Binomial');
    RegisterMethod(@TComboSet.Factorial, 'Factorial');
    RegisterMethod(@TComboSet.GetRCombo, 'GetRCombo');
    RegisterMethod(@TComboSet.GetRepRCombo, 'GetRepRCombo');
    RegisterMethod(@TComboSet.GetRPermute, 'GetRPermute');
    RegisterMethod(@TComboSet.GetRepRPermute, 'GetRepRPermute');
    RegisterMethod(@TComboSet.SetupR, 'SetupR');
    RegisterMethod(@TComboSet.SetupRFirstLast, 'SetupRFirstLast');
    RegisterMethod(@TComboSet.IsValidRSequence, 'IsValidRSequence');
    RegisterMethod(@TComboSet.ChangeRDirection, 'ChangeRDirection');
    RegisterMethod(@TComboSet.GetNextPrevR, 'GetNextPrevR');
    RegisterMethod(@TComboSet.NextR, 'NextR');
    RegisterMethod(@TComboSet.NextLexRPermute, 'NextLexRPermute');
    RegisterMethod(@TComboSet.NextLexRepRPermute, 'NextLexRepRPermute');
    RegisterMethod(@TComboSet.NextLexRCombo, 'NextLexRCombo');
    RegisterMethod(@TComboSet.NextLexRepRCombo, 'NextLexRepRCombo');
    RegisterMethod(@TComboSet.NextCoLexRCombo, 'NextCoLexRCombo');
    RegisterMethod(@TComboSet.PrevR, 'PrevR');
    RegisterMethod(@TComboSet.PrevCoLexRCombo, 'PrevCoLexRCombo');
    RegisterMethod(@TComboSet.PrevLexRepRPermute, 'PrevLexRepRPermute');
    RegisterMethod(@TComboSet.PrevLexRPermute, 'PrevLexRPermute');
    RegisterMethod(@TComboSet.PrevLexRCombo, 'PrevLexRCombo');
    RegisterMethod(@TComboSet.PrevLexRepRCombo, 'PrevLexRepRCombo');
    RegisterMethod(@TComboSet.RankR, 'RankR');
    RegisterMethod(@TComboSet.RankCoLexRCombo, 'RankCoLexRCombo');
    RegisterMethod(@TComboSet.RankLexRCombo, 'RankLexRCombo');
    RegisterMethod(@TComboSet.RankLexRepRCombo, 'RankLexRepRCombo');
    RegisterMethod(@TComboSet.RankLexRPermute, 'RankLexRPermute');
    RegisterMethod(@TComboSet.RankLexRepRPermute, 'RankLexRepRPermute');
    RegisterMethod(@TComboSet.UnRankR, 'UnRankR');
    RegisterMethod(@TComboSet.UnRankCoLexRCombo, 'UnRankCoLexRCombo');
    RegisterMethod(@TComboSet.UnRankLexRCombo, 'UnRankLexRCombo');
    RegisterMethod(@TComboSet.UnRankLexRepRCombo, 'UnRankLexRepRCombo');
    RegisterMethod(@TComboSet.UnRankLexRPermute, 'UnRankLexRPermute');
    RegisterMethod(@TComboSet.UnRankLexRepRPermute, 'UnRankLexRepRPermute');
    RegisterMethod(@TComboSet.RandomR, 'RandomR');
    RegisterMethod(@TComboSet.RandomCoLexRCombo, 'RandomCoLexRCombo');
    RegisterMethod(@TComboSet.RandomLexRCombo, 'RandomLexRCombo');
    RegisterMethod(@TComboSet.RandomLexRepRCombo, 'RandomLexRepRCombo');
    RegisterMethod(@TComboSet.RandomLexRPermute, 'RandomLexRPermute');
    RegisterMethod(@TComboSet.RandomLexRepRPermute, 'RandomLexRepRPermute');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_UcomboV2(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TComboSet(CL);
end;

 
 
{ TPSImport_UcomboV2 }
(*----------------------------------------------------------------------------*)
procedure TPSImport_UcomboV2.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_UcomboV2(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_UcomboV2.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_UcomboV2(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
