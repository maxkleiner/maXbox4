unit uPSI_JvExprParser;
{
  lex, scan and parse
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
  TPSImport_JvExprParser = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TExprParser(CL: TPSPascalCompiler);
procedure SIRegister_JvExprParser(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TExprParser(CL: TPSRuntimeClassImporter);
procedure RIRegister_JvExprParser(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   Contnrs
  ,JvExprParser
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_JvExprParser]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TExprParser(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOBJECT', 'TExprParser') do
  with CL.AddClassN(CL.FindClass('TOBJECT'),'TExprParser') do begin
    RegisterMethod('Constructor Create( )');
    RegisterMethod('Function Eval : Boolean;');
    RegisterMethod('Function Eval1( const AExpression : string) : Boolean;');
    RegisterProperty('ErrorMessage', 'string', iptr);
    RegisterProperty('Expression', 'string', iptrw);
    RegisterProperty('OnGetVariable', 'TOnGetVariableValue', iptrw);
    RegisterProperty('OnExecuteFunction', 'TOnExecuteFunction', iptrw);
    RegisterProperty('Value', 'Variant', iptr);
    RegisterProperty('EnableWildcardMatching', 'Boolean', iptrw);
    RegisterProperty('CaseInsensitive', 'Boolean', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_JvExprParser(CL: TPSPascalCompiler);
begin
  CL.AddTypeS('TOnGetVariableValue', 'Function ( Sender : TObject; const VarNam'
   +'e : string; var Value : Variant) : Boolean');
  CL.AddTypeS('TOnExecuteFunction', 'Function ( Sender : TObject; const FuncNam'
   +'e : string; const Args : Variant; var ResVal : Variant) : Boolean');
  SIRegister_TExprParser(CL);
  CL.AddClassN(CL.FindClass('TOBJECT'),'EExprParserError');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TExprParserCaseInsensitive_W(Self: TExprParser; const T: Boolean);
begin Self.CaseInsensitive := T; end;

(*----------------------------------------------------------------------------*)
procedure TExprParserCaseInsensitive_R(Self: TExprParser; var T: Boolean);
begin T := Self.CaseInsensitive; end;

(*----------------------------------------------------------------------------*)
procedure TExprParserEnableWildcardMatching_W(Self: TExprParser; const T: Boolean);
begin Self.EnableWildcardMatching := T; end;

(*----------------------------------------------------------------------------*)
procedure TExprParserEnableWildcardMatching_R(Self: TExprParser; var T: Boolean);
begin T := Self.EnableWildcardMatching; end;

(*----------------------------------------------------------------------------*)
procedure TExprParserValue_R(Self: TExprParser; var T: Variant);
begin T := Self.Value; end;

(*----------------------------------------------------------------------------*)
procedure TExprParserOnExecuteFunction_W(Self: TExprParser; const T: TOnExecuteFunction);
begin Self.OnExecuteFunction := T; end;

(*----------------------------------------------------------------------------*)
procedure TExprParserOnExecuteFunction_R(Self: TExprParser; var T: TOnExecuteFunction);
begin T := Self.OnExecuteFunction; end;

(*----------------------------------------------------------------------------*)
procedure TExprParserOnGetVariable_W(Self: TExprParser; const T: TOnGetVariableValue);
begin Self.OnGetVariable := T; end;

(*----------------------------------------------------------------------------*)
procedure TExprParserOnGetVariable_R(Self: TExprParser; var T: TOnGetVariableValue);
begin T := Self.OnGetVariable; end;

(*----------------------------------------------------------------------------*)
procedure TExprParserExpression_W(Self: TExprParser; const T: string);
begin Self.Expression := T; end;

(*----------------------------------------------------------------------------*)
procedure TExprParserExpression_R(Self: TExprParser; var T: string);
begin T := Self.Expression; end;

(*----------------------------------------------------------------------------*)
procedure TExprParserErrorMessage_R(Self: TExprParser; var T: string);
begin T := Self.ErrorMessage; end;

(*----------------------------------------------------------------------------*)
Function TExprParserEval1_P(Self: TExprParser;  const AExpression : string) : Boolean;
Begin Result := Self.Eval(AExpression); END;

(*----------------------------------------------------------------------------*)
Function TExprParserEval_P(Self: TExprParser) : Boolean;
Begin Result := Self.Eval; END;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TExprParser(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TExprParser) do begin
    RegisterConstructor(@TExprParser.Create, 'Create');
    RegisterMethod(@TExprParserEval_P, 'Eval');
    RegisterMethod(@TExprParserEval1_P, 'Eval1');
    RegisterPropertyHelper(@TExprParserErrorMessage_R,nil,'ErrorMessage');
    RegisterPropertyHelper(@TExprParserExpression_R,@TExprParserExpression_W,'Expression');
    RegisterPropertyHelper(@TExprParserOnGetVariable_R,@TExprParserOnGetVariable_W,'OnGetVariable');
    RegisterPropertyHelper(@TExprParserOnExecuteFunction_R,@TExprParserOnExecuteFunction_W,'OnExecuteFunction');
    RegisterPropertyHelper(@TExprParserValue_R,nil,'Value');
    RegisterPropertyHelper(@TExprParserEnableWildcardMatching_R,@TExprParserEnableWildcardMatching_W,'EnableWildcardMatching');
    RegisterPropertyHelper(@TExprParserCaseInsensitive_R,@TExprParserCaseInsensitive_W,'CaseInsensitive');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_JvExprParser(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TExprParser(CL);
  with CL.Add(EExprParserError) do
end;

 
 
{ TPSImport_JvExprParser }
(*----------------------------------------------------------------------------*)
procedure TPSImport_JvExprParser.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_JvExprParser(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_JvExprParser.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_JvExprParser(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
