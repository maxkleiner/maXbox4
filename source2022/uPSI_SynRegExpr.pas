unit uPSI_SynRegExpr;
{
  regEx second unit  , alias of grep
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
  TPSImport_SynRegExpr = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_ERegExpr(CL: TPSPascalCompiler);
procedure SIRegister_TRegExpr(CL: TPSPascalCompiler);
procedure SIRegister_SynRegExpr(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_SynRegExpr_Routines(S: TPSExec);
procedure RIRegister_ERegExpr(CL: TPSRuntimeClassImporter);
procedure RIRegister_TRegExpr(CL: TPSRuntimeClassImporter);
procedure RIRegister_SynRegExpr(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   SynRegExpr
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_SynRegExpr]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
Function BoolToStr(value : boolean) : string;
Begin If value then Result := 'TRUE' else Result := 'FALSE' End;

(*----------------------------------------------------------------------------*)
procedure SIRegister_ERegExpr(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'Exception', 'ERegExpr') do
  with CL.AddClassN(CL.FindClass('Exception'),'ERegExpr') do begin
    RegisterProperty('ErrorCode', 'integer', iptrw);
    RegisterProperty('CompilerErrorPos', 'integer', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TRegExpr(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOBJECT', 'TRegExpr') do
  with CL.AddClassN(CL.FindClass('TOBJECT'),'TRegExpr') do begin
    RegisterMethod('Constructor Create');
     RegisterMethod('Procedure Free');
      RegisterMethod('Function VersionMajor : integer');
    RegisterMethod('Function VersionMinor : integer');
    RegisterProperty('Expression', 'RegExprString', iptrw);
    RegisterProperty('ModifierStr', 'RegExprString', iptrw);
    RegisterProperty('ModifierI', 'boolean', iptrw);
    RegisterProperty('ModifierR', 'boolean', iptrw);
    RegisterProperty('ModifierS', 'boolean', iptrw);
    RegisterProperty('ModifierG', 'boolean', iptrw);
    RegisterProperty('ModifierM', 'boolean', iptrw);
    RegisterProperty('ModifierX', 'boolean', iptrw);
    RegisterMethod('Function Exec( const AInputString : RegExprString) : boolean;');
    //RegisterMethod('Function Exec1 : boolean;');
    RegisterMethod('Function Exec1( AOffset : integer) : boolean;');
    RegisterMethod('Function ExecNext : boolean');
    RegisterMethod('Function ExecPos( AOffset : integer) : boolean');
    RegisterProperty('InputString', 'RegExprString', iptrw);
    RegisterMethod('Function Substitute( const ATemplate : RegExprString) : RegExprString');
    RegisterMethod('Procedure Split( AInputStr : RegExprString; APieces : TStrings)');
    RegisterMethod('Function Replace( AInputStr : RegExprString; const AReplaceStr : RegExprString; AUseSubstitution : boolean) : RegExprString;');
    RegisterMethod('Function Replace1( AInputStr : RegExprString; AReplaceFunc : TRegExprReplaceFunction) : RegExprString;');
    RegisterMethod('Function ReplaceEx( AInputStr : RegExprString; AReplaceFunc : TRegExprReplaceFunction) : RegExprString');
    RegisterProperty('SubExprMatchCount', 'integer', iptr);
    RegisterProperty('MatchPos', 'integer integer', iptr);
    RegisterProperty('MatchLen', 'integer integer', iptr);
    RegisterProperty('Match', 'RegExprString integer', iptr);
    RegisterMethod('Function LastError : integer');
    RegisterMethod('Function ErrorMsg( AErrorID : integer) : RegExprString');
    RegisterProperty('CompilerErrorPos', 'integer', iptr);
    RegisterProperty('SpaceChars', 'RegExprString', iptrw);
    RegisterProperty('WordChars', 'RegExprString', iptrw);
    RegisterProperty('LineSeparators', 'RegExprString', iptrw);
    RegisterProperty('LinePairedSeparator', 'RegExprString', iptrw);
    RegisterMethod('Function InvertCaseFunction( const Ch : REChar) : REChar');
    RegisterProperty('InvertCase', 'TRegExprInvertCaseFunction', iptrw);
    RegisterMethod('Procedure Compile');
    RegisterMethod('Function Dump : RegExprString');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_SynRegExpr(CL: TPSPascalCompiler);
begin
  //CL.AddTypeS('PRegExprChar', 'PWideChar');
  //CL.AddTypeS('RegExprString', 'WideString');
  CL.AddTypeS('REChar', 'WideChar');
  CL.AddTypeS('PRegExprChar', 'PChar');
  CL.AddTypeS('RegExprString', 'AnsiString');
  CL.AddTypeS('REChar', 'Char');
  CL.AddTypeS('TREOp', 'REChar');
  //CL.AddTypeS('PREOp', '^TREOp // will not work');
  CL.AddTypeS('TRENextOff', 'integer');
  //CL.AddTypeS('PRENextOff', '^TRENextOff // will not work');
  CL.AddTypeS('TREBracesArg', 'integer');
  //CL.AddTypeS('PREBracesArg', '^TREBracesArg // will not work');
  CL.AddTypeS('TRegExprInvertCaseFunction','Function( const Ch : REChar):REChar');
 CL.AddConstantN('EscChar','String').SetString( '\');
 {CL.AddConstantN('RegExprModifierI','boolean').BoolToStr( False);
 CL.AddConstantN('RegExprModifierR','boolean')BoolToStr( False);
 CL.AddConstantN('RegExprModifierS','boolean')BoolToStr( False);
 CL.AddConstantN('RegExprModifierG','boolean')BoolToStr( False);
 CL.AddConstantN('RegExprModifierM','boolean')BoolToStr( False);
 CL.AddConstantN('RegExprModifierX','boolean')BoolToStr( False); }
 CL.AddConstantN('RegExprSpaceChars','RegExprString').SetString( ' '+ #$9#$A#$D#$C);
 CL.AddConstantN('RegExprWordChars','RegExprString').SetString( '0123456789' + 'abcdefghijklmnopqrstuvwxyz' + 'ABCDEFGHIJKLMNOPQRSTUVWXYZ_');
 CL.AddConstantN('RegExprLineSeparators','RegExprString').SetString( #$d#$a + #$b#$c#$2028#$2029#$85);
 CL.AddConstantN('RegExprLinePairedSeparator','RegExprString').SetString( #$d#$a);
 CL.AddConstantN('NSUBEXP','LongInt').SetInt( 15);
 CL.AddConstantN('NSUBEXPMAX','LongInt').SetInt( 255);
 CL.AddConstantN('MaxBracesArg','LongInt').SetInt( $7FFFFFFF - 1);
 CL.AddConstantN('LoopStackMax','LongInt').SetInt( 10);
 CL.AddConstantN('TinySetLen','LongInt').SetInt( 3);
  //CL.AddTypeS('PSetOfREChar', '^TSetOfREChar // will not work');
  CL.AddTypeS('TSetOfREChar', 'set of REChar');
  CL.AddClassN(CL.FindClass('TOBJECT'),'TRegExpr');
  CL.AddTypeS('TRegExprReplaceFunction', 'Function ( ARegExpr : TRegExpr) : string');
  SIRegister_TRegExpr(CL);
  SIRegister_ERegExpr(CL);
 CL.AddDelphiFunction('Function ExecRegExpr( const ARegExpr, AInputStr : RegExprString) : boolean');
 CL.AddDelphiFunction('Procedure SplitRegExpr( const ARegExpr, AInputStr : RegExprString; APieces : TStrings)');
 CL.AddDelphiFunction('Function ReplaceRegExpr( const ARegExpr, AInputStr, AReplaceStr : RegExprString; AUseSubstitution : boolean) : RegExprString');
 CL.AddDelphiFunction('Function gsub( const ARegExpr, AInputStr, AReplaceStr : RegExprString; AUseSubstitution : boolean): RegExprString');
 CL.AddDelphiFunction('Function QuoteRegExprMetaChars( const AStr : RegExprString) : RegExprString');
 CL.AddDelphiFunction('Function RegExprSubExpressions( const ARegExpr : string; ASubExprs : TStrings; AExtendedSyntax : boolean) : integer');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure ERegExprCompilerErrorPos_W(Self: ERegExpr; const T: integer);
Begin Self.CompilerErrorPos := T; end;

(*----------------------------------------------------------------------------*)
procedure ERegExprCompilerErrorPos_R(Self: ERegExpr; var T: integer);
Begin T := Self.CompilerErrorPos; end;

(*----------------------------------------------------------------------------*)
procedure ERegExprErrorCode_W(Self: ERegExpr; const T: integer);
Begin Self.ErrorCode := T; end;

(*----------------------------------------------------------------------------*)
procedure ERegExprErrorCode_R(Self: ERegExpr; var T: integer);
Begin T := Self.ErrorCode; end;

(*----------------------------------------------------------------------------*)
procedure TRegExprInvertCase_W(Self: TRegExpr; const T: TRegExprInvertCaseFunction);
begin Self.InvertCase := T; end;

(*----------------------------------------------------------------------------*)
procedure TRegExprInvertCase_R(Self: TRegExpr; var T: TRegExprInvertCaseFunction);
begin T := Self.InvertCase; end;

(*----------------------------------------------------------------------------*)
procedure TRegExprLinePairedSeparator_W(Self: TRegExpr; const T: RegExprString);
begin Self.LinePairedSeparator := T; end;

(*----------------------------------------------------------------------------*)
procedure TRegExprLinePairedSeparator_R(Self: TRegExpr; var T: RegExprString);
begin T := Self.LinePairedSeparator; end;

(*----------------------------------------------------------------------------*)
procedure TRegExprLineSeparators_W(Self: TRegExpr; const T: RegExprString);
begin Self.LineSeparators := T; end;

(*----------------------------------------------------------------------------*)
procedure TRegExprLineSeparators_R(Self: TRegExpr; var T: RegExprString);
begin T := Self.LineSeparators; end;

(*----------------------------------------------------------------------------*)
procedure TRegExprWordChars_W(Self: TRegExpr; const T: RegExprString);
begin Self.WordChars := T; end;

(*----------------------------------------------------------------------------*)
procedure TRegExprWordChars_R(Self: TRegExpr; var T: RegExprString);
begin T := Self.WordChars; end;

(*----------------------------------------------------------------------------*)
procedure TRegExprSpaceChars_W(Self: TRegExpr; const T: RegExprString);
begin Self.SpaceChars := T; end;

(*----------------------------------------------------------------------------*)
procedure TRegExprSpaceChars_R(Self: TRegExpr; var T: RegExprString);
begin T := Self.SpaceChars; end;

(*----------------------------------------------------------------------------*)
procedure TRegExprCompilerErrorPos_R(Self: TRegExpr; var T: integer);
begin T := Self.CompilerErrorPos; end;

(*----------------------------------------------------------------------------*)
procedure TRegExprMatch_R(Self: TRegExpr; var T: RegExprString; const t1: integer);
begin T := Self.Match[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TRegExprMatchLen_R(Self: TRegExpr; var T: integer; const t1: integer);
begin T := Self.MatchLen[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TRegExprMatchPos_R(Self: TRegExpr; var T: integer; const t1: integer);
begin T := Self.MatchPos[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TRegExprSubExprMatchCount_R(Self: TRegExpr; var T: integer);
begin T := Self.SubExprMatchCount; end;

(*----------------------------------------------------------------------------*)
Function TRegExprReplace1_P(Self: TRegExpr;  AInputStr : RegExprString; AReplaceFunc : TRegExprReplaceFunction) : RegExprString;
Begin Result := Self.Replace(AInputStr, AReplaceFunc); END;

(*----------------------------------------------------------------------------*)
Function TRegExprReplace_P(Self: TRegExpr;  AInputStr : RegExprString; const AReplaceStr : RegExprString; AUseSubstitution : boolean) : RegExprString;
Begin Result := Self.Replace(AInputStr, AReplaceStr, AUseSubstitution); END;

(*----------------------------------------------------------------------------*)
procedure TRegExprInputString_W(Self: TRegExpr; const T: RegExprString);
begin Self.InputString := T; end;

(*----------------------------------------------------------------------------*)
procedure TRegExprInputString_R(Self: TRegExpr; var T: RegExprString);
begin T := Self.InputString; end;

(*----------------------------------------------------------------------------*)
Function TRegExprExec_P(Self: TRegExpr;  AOffset : integer) : boolean;
Begin Result := Self.Exec(AOffset); END;

(*----------------------------------------------------------------------------*)
Function TRegExprExec1_P(Self: TRegExpr) : boolean;
Begin Result := Self.Exec; END;

(*----------------------------------------------------------------------------*)
Function TRegExprExec(Self: TRegExpr;  const AInputString : RegExprString) : boolean;
Begin Result := Self.Exec(AInputString); END;

(*----------------------------------------------------------------------------*)
procedure TRegExprModifierX_W(Self: TRegExpr; const T: boolean);
begin Self.ModifierX := T; end;

(*----------------------------------------------------------------------------*)
procedure TRegExprModifierX_R(Self: TRegExpr; var T: boolean);
begin T := Self.ModifierX; end;

(*----------------------------------------------------------------------------*)
procedure TRegExprModifierM_W(Self: TRegExpr; const T: boolean);
begin Self.ModifierM := T; end;

(*----------------------------------------------------------------------------*)
procedure TRegExprModifierM_R(Self: TRegExpr; var T: boolean);
begin T := Self.ModifierM; end;

(*----------------------------------------------------------------------------*)
procedure TRegExprModifierG_W(Self: TRegExpr; const T: boolean);
begin Self.ModifierG := T; end;

(*----------------------------------------------------------------------------*)
procedure TRegExprModifierG_R(Self: TRegExpr; var T: boolean);
begin T := Self.ModifierG; end;

(*----------------------------------------------------------------------------*)
procedure TRegExprModifierS_W(Self: TRegExpr; const T: boolean);
begin Self.ModifierS := T; end;

(*----------------------------------------------------------------------------*)
procedure TRegExprModifierS_R(Self: TRegExpr; var T: boolean);
begin T := Self.ModifierS; end;

(*----------------------------------------------------------------------------*)
procedure TRegExprModifierR_W(Self: TRegExpr; const T: boolean);
begin Self.ModifierR := T; end;

(*----------------------------------------------------------------------------*)
procedure TRegExprModifierR_R(Self: TRegExpr; var T: boolean);
begin T := Self.ModifierR; end;

(*----------------------------------------------------------------------------*)
procedure TRegExprModifierI_W(Self: TRegExpr; const T: boolean);
begin Self.ModifierI := T; end;

(*----------------------------------------------------------------------------*)
procedure TRegExprModifierI_R(Self: TRegExpr; var T: boolean);
begin T := Self.ModifierI; end;

(*----------------------------------------------------------------------------*)
procedure TRegExprModifierStr_W(Self: TRegExpr; const T: RegExprString);
begin Self.ModifierStr := T; end;

(*----------------------------------------------------------------------------*)
procedure TRegExprModifierStr_R(Self: TRegExpr; var T: RegExprString);
begin T := Self.ModifierStr; end;

(*----------------------------------------------------------------------------*)
procedure TRegExprExpression_W(Self: TRegExpr; const T: RegExprString);
begin Self.Expression := T; end;

(*----------------------------------------------------------------------------*)
procedure TRegExprExpression_R(Self: TRegExpr; var T: RegExprString);
begin T := Self.Expression; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_SynRegExpr_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@ExecRegExpr, 'ExecRegExpr', cdRegister);
 S.RegisterDelphiFunction(@SplitRegExpr, 'SplitRegExpr', cdRegister);
 S.RegisterDelphiFunction(@ReplaceRegExpr, 'ReplaceRegExpr', cdRegister);
 S.RegisterDelphiFunction(@ReplaceRegExpr, 'gsub', cdRegister);
 S.RegisterDelphiFunction(@QuoteRegExprMetaChars, 'QuoteRegExprMetaChars', cdRegister);
 S.RegisterDelphiFunction(@RegExprSubExpressions, 'RegExprSubExpressions', cdRegister);
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_ERegExpr(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(ERegExpr) do begin
    RegisterPropertyHelper(@ERegExprErrorCode_R,@ERegExprErrorCode_W,'ErrorCode');
    RegisterPropertyHelper(@ERegExprCompilerErrorPos_R,@ERegExprCompilerErrorPos_W,'CompilerErrorPos');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TRegExpr(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TRegExpr) do begin
    RegisterConstructor(@TRegExpr.Create, 'Create');
     RegisterMethod(@TRegExpr.Destroy, 'Free');
      RegisterMethod(@TRegExpr.VersionMajor, 'VersionMajor');
    RegisterMethod(@TRegExpr.VersionMinor, 'VersionMinor');
    RegisterPropertyHelper(@TRegExprExpression_R,@TRegExprExpression_W,'Expression');
    RegisterPropertyHelper(@TRegExprModifierStr_R,@TRegExprModifierStr_W,'ModifierStr');
    RegisterPropertyHelper(@TRegExprModifierI_R,@TRegExprModifierI_W,'ModifierI');
    RegisterPropertyHelper(@TRegExprModifierR_R,@TRegExprModifierR_W,'ModifierR');
    RegisterPropertyHelper(@TRegExprModifierS_R,@TRegExprModifierS_W,'ModifierS');
    RegisterPropertyHelper(@TRegExprModifierG_R,@TRegExprModifierG_W,'ModifierG');
    RegisterPropertyHelper(@TRegExprModifierM_R,@TRegExprModifierM_W,'ModifierM');
    RegisterPropertyHelper(@TRegExprModifierX_R,@TRegExprModifierX_W,'ModifierX');
    RegisterMethod(@TRegExprExec, 'Exec');
    RegisterMethod(@TRegExprExec1_P, 'Exec1');
    //RegisterMethod(@TRegExprExec_P, 'Exec');
    RegisterMethod(@TRegExpr.ExecNext, 'ExecNext');
    RegisterMethod(@TRegExpr.ExecPos, 'ExecPos');
    RegisterPropertyHelper(@TRegExprInputString_R,@TRegExprInputString_W,'InputString');
    RegisterMethod(@TRegExpr.Substitute, 'Substitute');
    RegisterMethod(@TRegExpr.Split, 'Split');
    RegisterMethod(@TRegExprReplace_P, 'Replace');
    RegisterMethod(@TRegExprReplace1_P, 'Replace1');
    RegisterMethod(@TRegExpr.ReplaceEx, 'ReplaceEx');
    RegisterPropertyHelper(@TRegExprSubExprMatchCount_R,nil,'SubExprMatchCount');
    RegisterPropertyHelper(@TRegExprMatchPos_R,nil,'MatchPos');
    RegisterPropertyHelper(@TRegExprMatchLen_R,nil,'MatchLen');
    RegisterPropertyHelper(@TRegExprMatch_R,nil,'Match');
    RegisterMethod(@TRegExpr.LastError, 'LastError');
    RegisterVirtualMethod(@TRegExpr.ErrorMsg, 'ErrorMsg');
    RegisterPropertyHelper(@TRegExprCompilerErrorPos_R,nil,'CompilerErrorPos');
    RegisterPropertyHelper(@TRegExprSpaceChars_R,@TRegExprSpaceChars_W,'SpaceChars');
    RegisterPropertyHelper(@TRegExprWordChars_R,@TRegExprWordChars_W,'WordChars');
    RegisterPropertyHelper(@TRegExprLineSeparators_R,@TRegExprLineSeparators_W,'LineSeparators');
    RegisterPropertyHelper(@TRegExprLinePairedSeparator_R,@TRegExprLinePairedSeparator_W,'LinePairedSeparator');
    RegisterMethod(@TRegExpr.InvertCaseFunction, 'InvertCaseFunction');
    RegisterPropertyHelper(@TRegExprInvertCase_R,@TRegExprInvertCase_W,'InvertCase');
    RegisterMethod(@TRegExpr.Compile, 'Compile');
    RegisterMethod(@TRegExpr.Dump, 'Dump');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_SynRegExpr(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TRegExpr) do
  RIRegister_TRegExpr(CL);
  RIRegister_ERegExpr(CL);
end;



{ TPSImport_SynRegExpr }
(*----------------------------------------------------------------------------*)
procedure TPSImport_SynRegExpr.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_SynRegExpr(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_SynRegExpr.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_SynRegExpr(ri);
  RIRegister_SynRegExpr_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
