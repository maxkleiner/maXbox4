unit uPSI_Simpat;
{
simultor australia  patterns

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
  TPSImport_Simpat = class(TPSPlugin)
  public
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_ESimpatEmptyCharClass(CL: TPSPascalCompiler);
procedure SIRegister_ESimpatBadCharClass(CL: TPSPascalCompiler);
procedure SIRegister_ESimpatHasEmptyChoice(CL: TPSPascalCompiler);
procedure SIRegister_ESimpat(CL: TPSPascalCompiler);
procedure SIRegister_TSimpatRange(CL: TPSPascalCompiler);
procedure SIRegister_TSimpatStr(CL: TPSPascalCompiler);
procedure SIRegister_TSimpatRepeatOneOrNone(CL: TPSPascalCompiler);
procedure SIRegister_TSimpatRepeatOneOrMore(CL: TPSPascalCompiler);
procedure SIRegister_TSimpatRepeatAny(CL: TPSPascalCompiler);
procedure SIRegister_TSimpatRepeat(CL: TPSPascalCompiler);
procedure SIRegister_TSimpatItem(CL: TPSPascalCompiler);
procedure SIRegister_TLinearSimpat(CL: TPSPascalCompiler);
procedure SIRegister_TSimpatPattern(CL: TPSPascalCompiler);
procedure SIRegister_TSimpatRangeBytes(CL: TPSPascalCompiler);
procedure SIRegister_Simpat(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_ESimpatEmptyCharClass(CL: TPSRuntimeClassImporter);
procedure RIRegister_ESimpatBadCharClass(CL: TPSRuntimeClassImporter);
procedure RIRegister_ESimpatHasEmptyChoice(CL: TPSRuntimeClassImporter);
procedure RIRegister_ESimpat(CL: TPSRuntimeClassImporter);
procedure RIRegister_TSimpatRange(CL: TPSRuntimeClassImporter);
procedure RIRegister_TSimpatStr(CL: TPSRuntimeClassImporter);
procedure RIRegister_TSimpatRepeatOneOrNone(CL: TPSRuntimeClassImporter);
procedure RIRegister_TSimpatRepeatOneOrMore(CL: TPSRuntimeClassImporter);
procedure RIRegister_TSimpatRepeatAny(CL: TPSRuntimeClassImporter);
procedure RIRegister_TSimpatRepeat(CL: TPSRuntimeClassImporter);
procedure RIRegister_TSimpatItem(CL: TPSRuntimeClassImporter);
procedure RIRegister_TLinearSimpat(CL: TPSRuntimeClassImporter);
procedure RIRegister_TSimpatPattern(CL: TPSRuntimeClassImporter);
procedure RIRegister_TSimpatRangeBytes(CL: TPSRuntimeClassImporter);
procedure RIRegister_Simpat(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   Windows
  ,Math
  ,Contnrs
  ,StringsW
  ,Simpat
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_Simpat]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_ESimpatEmptyCharClass(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'ESimpat', 'ESimpatEmptyCharClass') do
  with CL.AddClassN(CL.FindClass('ESimpat'),'ESimpatEmptyCharClass') do
  begin
    RegisterProperty('Simpat', 'TLinearSimpat', iptrw);
    RegisterMethod('Constructor Create( Simpat : TLinearSimpat; CharClass : SimpatString)');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_ESimpatBadCharClass(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'ESimpat', 'ESimpatBadCharClass') do
  with CL.AddClassN(CL.FindClass('ESimpat'),'ESimpatBadCharClass') do
  begin
    RegisterProperty('Simpat', 'TLinearSimpat', iptrw);
    RegisterMethod('Constructor Create( Simpat : TLinearSimpat; CharClass : SimpatString)');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_ESimpatHasEmptyChoice(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'ESimpat', 'ESimpatHasEmptyChoice') do
  with CL.AddClassN(CL.FindClass('ESimpat'),'ESimpatHasEmptyChoice') do
  begin
    RegisterMethod('Constructor Create( Pattern : SimpatString)');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_ESimpat(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'Exception', 'ESimpat') do
  with CL.AddClassN(CL.FindClass('Exception'),'ESimpat') do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TSimpatRange(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TSimpatItem', 'TSimpatRange') do
  with CL.AddClassN(CL.FindClass('TSimpatItem'),'TSimpatRange') do
  begin
    RegisterMethod('Constructor Create( Bytes : TSimpatRangeBytes)');
    RegisterMethod('Function EndsRepeat( const Context : TSimpatContext; RepeatCount : Integer) : Boolean');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TSimpatStr(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TSimpatItem', 'TSimpatStr') do
  with CL.AddClassN(CL.FindClass('TSimpatItem'),'TSimpatStr') do begin
    RegisterProperty('Str', 'SimpatString', iptrw);
    RegisterMethod('Constructor Create( const Str : SimpatString)');
                RegisterMethod('Procedure Free');

  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TSimpatRepeatOneOrNone(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TSimpatRepeat', 'TSimpatRepeatOneOrNone') do
  with CL.AddClassN(CL.FindClass('TSimpatRepeat'),'TSimpatRepeatOneOrNone') do
  begin
    RegisterMethod('Function IsRepeated( RepeatCount : Integer) : Boolean');
    RegisterMethod('Function IsRepeatOptional( RepeatCount : Integer) : Boolean');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TSimpatRepeatOneOrMore(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TSimpatRepeat', 'TSimpatRepeatOneOrMore') do
  with CL.AddClassN(CL.FindClass('TSimpatRepeat'),'TSimpatRepeatOneOrMore') do
  begin
    RegisterMethod('Function IsRepeatOptional( RepeatCount : Integer) : Boolean');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TSimpatRepeatAny(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TSimpatRepeat', 'TSimpatRepeatAny') do
  with CL.AddClassN(CL.FindClass('TSimpatRepeat'),'TSimpatRepeatAny') do
  begin
    RegisterMethod('Function IsRepeatOptional( RepeatCount : Integer) : Boolean');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TSimpatRepeat(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TSimpatItem', 'TSimpatRepeat') do
  with CL.AddClassN(CL.FindClass('TSimpatItem'),'TSimpatRepeat') do
  begin
    RegisterMethod('Function IsRepeated( RepeatCount : Integer) : Boolean');
    RegisterMethod('Function IsRepeatOptional( RepeatCount : Integer) : Boolean');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TSimpatItem(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOBJECT', 'TSimpatItem') do
  with CL.AddClassN(CL.FindClass('TOBJECT'),'TSimpatItem') do
  begin
    RegisterMethod('Function MatchAgainst( const Context : TSimpatContext) : Boolean');
    RegisterMethod('Function EndsRepeat( const Context : TSimpatContext; RepeatCount : Integer) : Boolean');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TLinearSimpat(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOBJECT', 'TLinearSimpat') do
  with CL.AddClassN(CL.FindClass('TOBJECT'),'TLinearSimpat') do begin
    RegisterMethod('Constructor Create( const Context : TSimpatContext; const Pattern : SimpatString)');
             RegisterMethod('Procedure Free');
    RegisterMethod('Procedure AddCharClass( Name : SimpatString; Bytes : TSimpatRangeBytes)');
    RegisterMethod('Procedure AddDefaultCharClasses');
    RegisterMethod('Function MatchAgainst( Input : TStream; ContextSync : TSimpatPattern) : Boolean');
    RegisterMethod('Function Debug : SimpatString');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TSimpatPattern(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOBJECT', 'TSimpatPattern') do
  with CL.AddClassN(CL.FindClass('TOBJECT'),'TSimpatPattern') do begin
    RegisterMethod('Function Match( const Pattern : SimpatString; Input : TStream; const EOLN : SimpatString) : Boolean;');
    RegisterMethod('Function Match1( const Pattern : SimpatString; const Input : SimpatString; const EOLN : SimpatString) : Boolean;');
    RegisterMethod('Constructor Create( const Pattern : SimpatString)');
             RegisterMethod('Procedure Free');
    RegisterMethod('Function Debug : SimpatString');
    RegisterProperty('AsString', 'SimpatString', iptr);
    RegisterProperty('Context', 'TSimpatContext', iptrw);
    RegisterMethod('Function MatchAgainst( Input : TStream) : Boolean');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TSimpatRangeBytes(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOBJECT', 'TSimpatRangeBytes') do
  with CL.AddClassN(CL.FindClass('TOBJECT'),'TSimpatRangeBytes') do
  begin
    RegisterMethod('Constructor Create');
    RegisterMethod('Procedure FillRange( AStart, AEnd : Byte; State : Boolean)');
    RegisterMethod('Procedure Add( AByte : Byte; State : Boolean)');
    RegisterMethod('Procedure MergeWith( Other : TSimpatRangeBytes)');
    RegisterMethod('Procedure Invert');
    RegisterMethod('Procedure MatchAll');
    RegisterMethod('Function Contains( AByte : Byte) : Boolean');
    RegisterProperty('MatchesAllFast', 'Boolean', iptr);
    RegisterMethod('Function MatchesAny : Boolean');
    RegisterMethod('Function HasSingleValue : Boolean');
    RegisterMethod('Function FirstValue : SmallInt');
    RegisterProperty('IsInverted', 'Boolean', iptrw);
    RegisterProperty('MatchesEOLN', 'Boolean', iptrw);
    RegisterProperty('MatchesEOF', 'Boolean', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_Simpat(CL: TPSPascalCompiler);
begin
 CL.AddConstantN('SimpatDefaultEOLN','Char').SetString( #10);
  CL.AddTypeS('SimpatString', 'AnsiString');
  CL.AddClassN(CL.FindClass('TOBJECT'),'TLinearSimpat');
  CL.AddClassN(CL.FindClass('TOBJECT'),'TSimpatPattern');
  CL.AddTypeS('TSimpatContext', 'record Input : TStream; EOLN : SimpatString; P'
   +'attern : TSimpatPattern; Linear : TLinearSimpat; Custom : ___Pointer; end');
  SIRegister_TSimpatRangeBytes(CL);
  SIRegister_TSimpatPattern(CL);
  SIRegister_TLinearSimpat(CL);
  SIRegister_TSimpatItem(CL);
  SIRegister_TSimpatRepeat(CL);
  SIRegister_TSimpatRepeatAny(CL);
  SIRegister_TSimpatRepeatOneOrMore(CL);
  SIRegister_TSimpatRepeatOneOrNone(CL);
  SIRegister_TSimpatStr(CL);
  SIRegister_TSimpatRange(CL);
  CL.AddTypeS('TSimpat', 'TSimpatPattern');
  SIRegister_ESimpat(CL);
  SIRegister_ESimpatHasEmptyChoice(CL);
  SIRegister_ESimpatBadCharClass(CL);
  SIRegister_ESimpatEmptyCharClass(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure ESimpatEmptyCharClassSimpat_W(Self: ESimpatEmptyCharClass; const T: TLinearSimpat);
Begin Self.Simpat := T; end;

(*----------------------------------------------------------------------------*)
procedure ESimpatEmptyCharClassSimpat_R(Self: ESimpatEmptyCharClass; var T: TLinearSimpat);
Begin T := Self.Simpat; end;

(*----------------------------------------------------------------------------*)
procedure ESimpatBadCharClassSimpat_W(Self: ESimpatBadCharClass; const T: TLinearSimpat);
Begin Self.Simpat := T; end;

(*----------------------------------------------------------------------------*)
procedure ESimpatBadCharClassSimpat_R(Self: ESimpatBadCharClass; var T: TLinearSimpat);
Begin T := Self.Simpat; end;

(*----------------------------------------------------------------------------*)
procedure TSimpatStrStr_W(Self: TSimpatStr; const T: SimpatString);
Begin Self.Str := T; end;

(*----------------------------------------------------------------------------*)
procedure TSimpatStrStr_R(Self: TSimpatStr; var T: SimpatString);
Begin T := Self.Str; end;

(*----------------------------------------------------------------------------*)
procedure TSimpatPatternContext_W(Self: TSimpatPattern; const T: TSimpatContext);
begin Self.Context := T; end;

(*----------------------------------------------------------------------------*)
procedure TSimpatPatternContext_R(Self: TSimpatPattern; var T: TSimpatContext);
begin T := Self.Context; end;

(*----------------------------------------------------------------------------*)
procedure TSimpatPatternAsString_R(Self: TSimpatPattern; var T: SimpatString);
begin T := Self.AsString; end;

(*----------------------------------------------------------------------------*)
Function TSimpatPatternMatch1_P(Self: TSimpatPattern;  const Pattern : SimpatString; const Input : SimpatString; const EOLN : SimpatString) : Boolean;
Begin Result := Self.Match(Pattern, Input, EOLN); END;

(*----------------------------------------------------------------------------*)
Function TSimpatPatternMatch_P(Self: TSimpatPattern;  const Pattern : SimpatString; Input : TStream; const EOLN : SimpatString) : Boolean;
Begin Result := Self.Match(Pattern, Input, EOLN); END;

(*----------------------------------------------------------------------------*)
procedure TSimpatRangeBytesMatchesEOF_W(Self: TSimpatRangeBytes; const T: Boolean);
begin Self.MatchesEOF := T; end;

(*----------------------------------------------------------------------------*)
procedure TSimpatRangeBytesMatchesEOF_R(Self: TSimpatRangeBytes; var T: Boolean);
begin T := Self.MatchesEOF; end;

(*----------------------------------------------------------------------------*)
procedure TSimpatRangeBytesMatchesEOLN_W(Self: TSimpatRangeBytes; const T: Boolean);
begin Self.MatchesEOLN := T; end;

(*----------------------------------------------------------------------------*)
procedure TSimpatRangeBytesMatchesEOLN_R(Self: TSimpatRangeBytes; var T: Boolean);
begin T := Self.MatchesEOLN; end;

(*----------------------------------------------------------------------------*)
procedure TSimpatRangeBytesIsInverted_W(Self: TSimpatRangeBytes; const T: Boolean);
begin Self.IsInverted := T; end;

(*----------------------------------------------------------------------------*)
procedure TSimpatRangeBytesIsInverted_R(Self: TSimpatRangeBytes; var T: Boolean);
begin T := Self.IsInverted; end;

(*----------------------------------------------------------------------------*)
procedure TSimpatRangeBytesMatchesAllFast_R(Self: TSimpatRangeBytes; var T: Boolean);
begin T := Self.MatchesAllFast; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_ESimpatEmptyCharClass(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(ESimpatEmptyCharClass) do
  begin
    RegisterPropertyHelper(@ESimpatEmptyCharClassSimpat_R,@ESimpatEmptyCharClassSimpat_W,'Simpat');
    RegisterConstructor(@ESimpatEmptyCharClass.Create, 'Create');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_ESimpatBadCharClass(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(ESimpatBadCharClass) do
  begin
    RegisterPropertyHelper(@ESimpatBadCharClassSimpat_R,@ESimpatBadCharClassSimpat_W,'Simpat');
    RegisterConstructor(@ESimpatBadCharClass.Create, 'Create');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_ESimpatHasEmptyChoice(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(ESimpatHasEmptyChoice) do
  begin
    RegisterConstructor(@ESimpatHasEmptyChoice.Create, 'Create');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_ESimpat(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(ESimpat) do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TSimpatRange(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TSimpatRange) do begin
    RegisterConstructor(@TSimpatRange.Create, 'Create');
        RegisterMethod(@TSimpatRange.Destroy, 'Free');

    RegisterMethod(@TSimpatRange.EndsRepeat, 'EndsRepeat');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TSimpatStr(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TSimpatStr) do
  begin
    RegisterPropertyHelper(@TSimpatStrStr_R,@TSimpatStrStr_W,'Str');
    RegisterConstructor(@TSimpatStr.Create, 'Create');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TSimpatRepeatOneOrNone(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TSimpatRepeatOneOrNone) do
  begin
    RegisterMethod(@TSimpatRepeatOneOrNone.IsRepeated, 'IsRepeated');
    RegisterMethod(@TSimpatRepeatOneOrNone.IsRepeatOptional, 'IsRepeatOptional');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TSimpatRepeatOneOrMore(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TSimpatRepeatOneOrMore) do
  begin
    RegisterMethod(@TSimpatRepeatOneOrMore.IsRepeatOptional, 'IsRepeatOptional');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TSimpatRepeatAny(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TSimpatRepeatAny) do
  begin
    RegisterMethod(@TSimpatRepeatAny.IsRepeatOptional, 'IsRepeatOptional');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TSimpatRepeat(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TSimpatRepeat) do
  begin
    RegisterVirtualMethod(@TSimpatRepeat.IsRepeated, 'IsRepeated');
    //RegisterVirtualAbstractMethod(@TSimpatRepeat, @!.IsRepeatOptional, 'IsRepeatOptional');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TSimpatItem(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TSimpatItem) do
  begin
    RegisterMethod(@TSimpatItem.MatchAgainst, 'MatchAgainst');
    RegisterVirtualMethod(@TSimpatItem.EndsRepeat, 'EndsRepeat');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TLinearSimpat(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TLinearSimpat) do begin
    RegisterConstructor(@TLinearSimpat.Create, 'Create');
        RegisterMethod(@TLinearSimpat.Destroy, 'Free');

    RegisterMethod(@TLinearSimpat.AddCharClass, 'AddCharClass');
    RegisterMethod(@TLinearSimpat.AddDefaultCharClasses, 'AddDefaultCharClasses');
    RegisterMethod(@TLinearSimpat.MatchAgainst, 'MatchAgainst');
    RegisterMethod(@TLinearSimpat.Debug, 'Debug');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TSimpatPattern(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TSimpatPattern) do begin
    RegisterMethod(@TSimpatPatternMatch_P, 'Match');
    RegisterMethod(@TSimpatPatternMatch1_P, 'Match1');
    RegisterConstructor(@TSimpatPattern.Create, 'Create');
        RegisterMethod(@TSimpatPattern.Destroy, 'Free');

    RegisterMethod(@TSimpatPattern.Debug, 'Debug');
    RegisterPropertyHelper(@TSimpatPatternAsString_R,nil,'AsString');
    RegisterPropertyHelper(@TSimpatPatternContext_R,@TSimpatPatternContext_W,'Context');
    RegisterMethod(@TSimpatPattern.MatchAgainst, 'MatchAgainst');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TSimpatRangeBytes(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TSimpatRangeBytes) do
  begin
    RegisterConstructor(@TSimpatRangeBytes.Create, 'Create');
    RegisterMethod(@TSimpatRangeBytes.FillRange, 'FillRange');
    RegisterMethod(@TSimpatRangeBytes.Add, 'Add');
    RegisterMethod(@TSimpatRangeBytes.MergeWith, 'MergeWith');
    RegisterMethod(@TSimpatRangeBytes.Invert, 'Invert');
    RegisterMethod(@TSimpatRangeBytes.MatchAll, 'MatchAll');
    RegisterMethod(@TSimpatRangeBytes.Contains, 'Contains');
    RegisterPropertyHelper(@TSimpatRangeBytesMatchesAllFast_R,nil,'MatchesAllFast');
    RegisterMethod(@TSimpatRangeBytes.MatchesAny, 'MatchesAny');
    RegisterMethod(@TSimpatRangeBytes.HasSingleValue, 'HasSingleValue');
    RegisterMethod(@TSimpatRangeBytes.FirstValue, 'FirstValue');
    RegisterPropertyHelper(@TSimpatRangeBytesIsInverted_R,@TSimpatRangeBytesIsInverted_W,'IsInverted');
    RegisterPropertyHelper(@TSimpatRangeBytesMatchesEOLN_R,@TSimpatRangeBytesMatchesEOLN_W,'MatchesEOLN');
    RegisterPropertyHelper(@TSimpatRangeBytesMatchesEOF_R,@TSimpatRangeBytesMatchesEOF_W,'MatchesEOF');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_Simpat(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TLinearSimpat) do
  with CL.Add(TSimpatPattern) do
  RIRegister_TSimpatRangeBytes(CL);
  RIRegister_TSimpatPattern(CL);
  RIRegister_TLinearSimpat(CL);
  RIRegister_TSimpatItem(CL);
  RIRegister_TSimpatRepeat(CL);
  RIRegister_TSimpatRepeatAny(CL);
  RIRegister_TSimpatRepeatOneOrMore(CL);
  RIRegister_TSimpatRepeatOneOrNone(CL);
  RIRegister_TSimpatStr(CL);
  RIRegister_TSimpatRange(CL);
  RIRegister_ESimpat(CL);
  RIRegister_ESimpatHasEmptyChoice(CL);
  RIRegister_ESimpatBadCharClass(CL);
  RIRegister_ESimpatEmptyCharClass(CL);
end;

 
 
{ TPSImport_Simpat }
(*----------------------------------------------------------------------------*)
procedure TPSImport_Simpat.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_Simpat(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_Simpat.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_Simpat(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
