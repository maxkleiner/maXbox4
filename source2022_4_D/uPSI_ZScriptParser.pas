unit uPSI_ZScriptParser;
{
   SQLParse
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
  TPSImport_ZScriptParser = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TZSQLScriptParser(CL: TPSPascalCompiler);
procedure SIRegister_ZScriptParser(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TZSQLScriptParser(CL: TPSRuntimeClassImporter);
procedure RIRegister_ZScriptParser(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   ZTokenizer
  ,ZScriptParser
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_ZScriptParser]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TZSQLScriptParser(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOBJECT', 'TZSQLScriptParser') do
  with CL.AddClassN(CL.FindClass('TOBJECT'),'TZSQLScriptParser') do begin
    RegisterMethod('Constructor Create');
       RegisterMethod('Procedure Free');
     RegisterMethod('Constructor CreateWithTokenizer( Tokenizer : IZTokenizer)');
    RegisterMethod('Procedure Clear');
    RegisterMethod('Procedure ClearCompleted');
    RegisterMethod('Procedure ClearUncompleted');
    RegisterMethod('Procedure ParseText( const Text : string)');
    RegisterMethod('Procedure ParseLine( const Line : string)');
    RegisterProperty('Delimiter', 'string', iptrw);
    RegisterProperty('DelimiterType', 'TZDelimiterType', iptrw);
    RegisterProperty('CleanupStatements', 'Boolean', iptrw);
    RegisterProperty('Tokenizer', 'IZTokenizer', iptrw);
    RegisterProperty('UncompletedStatement', 'string', iptr);
    RegisterProperty('StatementCount', 'Integer', iptr);
    RegisterProperty('Statements', 'string Integer', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_ZScriptParser(CL: TPSPascalCompiler);
begin
  CL.AddTypeS('TZDelimiterType', '( dtDefault, dtDelimiter, dtGo, dtSetTerm, dtEmptyLine )');
  SIRegister_TZSQLScriptParser(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TZSQLScriptParserStatements_R(Self: TZSQLScriptParser; var T: string; const t1: Integer);
begin T := Self.Statements[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TZSQLScriptParserStatementCount_R(Self: TZSQLScriptParser; var T: Integer);
begin T := Self.StatementCount; end;

(*----------------------------------------------------------------------------*)
procedure TZSQLScriptParserUncompletedStatement_R(Self: TZSQLScriptParser; var T: string);
begin T := Self.UncompletedStatement; end;

(*----------------------------------------------------------------------------*)
procedure TZSQLScriptParserTokenizer_W(Self: TZSQLScriptParser; const T: IZTokenizer);
begin Self.Tokenizer := T; end;

(*----------------------------------------------------------------------------*)
procedure TZSQLScriptParserTokenizer_R(Self: TZSQLScriptParser; var T: IZTokenizer);
begin T := Self.Tokenizer; end;

(*----------------------------------------------------------------------------*)
procedure TZSQLScriptParserCleanupStatements_W(Self: TZSQLScriptParser; const T: Boolean);
begin Self.CleanupStatements := T; end;

(*----------------------------------------------------------------------------*)
procedure TZSQLScriptParserCleanupStatements_R(Self: TZSQLScriptParser; var T: Boolean);
begin T := Self.CleanupStatements; end;

(*----------------------------------------------------------------------------*)
procedure TZSQLScriptParserDelimiterType_W(Self: TZSQLScriptParser; const T: TZDelimiterType);
begin Self.DelimiterType := T; end;

(*----------------------------------------------------------------------------*)
procedure TZSQLScriptParserDelimiterType_R(Self: TZSQLScriptParser; var T: TZDelimiterType);
begin T := Self.DelimiterType; end;

(*----------------------------------------------------------------------------*)
procedure TZSQLScriptParserDelimiter_W(Self: TZSQLScriptParser; const T: string);
begin Self.Delimiter := T; end;

(*----------------------------------------------------------------------------*)
procedure TZSQLScriptParserDelimiter_R(Self: TZSQLScriptParser; var T: string);
begin T := Self.Delimiter; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TZSQLScriptParser(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TZSQLScriptParser) do begin
    RegisterConstructor(@TZSQLScriptParser.Create, 'Create');
     RegisterMethod(@TZSQLScriptParser.Destroy, 'Free');
     RegisterConstructor(@TZSQLScriptParser.CreateWithTokenizer, 'CreateWithTokenizer');
    RegisterMethod(@TZSQLScriptParser.Clear, 'Clear');
    RegisterMethod(@TZSQLScriptParser.ClearCompleted, 'ClearCompleted');
    RegisterMethod(@TZSQLScriptParser.ClearUncompleted, 'ClearUncompleted');
    RegisterMethod(@TZSQLScriptParser.ParseText, 'ParseText');
    RegisterMethod(@TZSQLScriptParser.ParseLine, 'ParseLine');
    RegisterPropertyHelper(@TZSQLScriptParserDelimiter_R,@TZSQLScriptParserDelimiter_W,'Delimiter');
    RegisterPropertyHelper(@TZSQLScriptParserDelimiterType_R,@TZSQLScriptParserDelimiterType_W,'DelimiterType');
    RegisterPropertyHelper(@TZSQLScriptParserCleanupStatements_R,@TZSQLScriptParserCleanupStatements_W,'CleanupStatements');
    RegisterPropertyHelper(@TZSQLScriptParserTokenizer_R,@TZSQLScriptParserTokenizer_W,'Tokenizer');
    RegisterPropertyHelper(@TZSQLScriptParserUncompletedStatement_R,nil,'UncompletedStatement');
    RegisterPropertyHelper(@TZSQLScriptParserStatementCount_R,nil,'StatementCount');
    RegisterPropertyHelper(@TZSQLScriptParserStatements_R,nil,'Statements');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_ZScriptParser(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TZSQLScriptParser(CL);
end;

 
 
{ TPSImport_ZScriptParser }
(*----------------------------------------------------------------------------*)
procedure TPSImport_ZScriptParser.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_ZScriptParser(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_ZScriptParser.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_ZScriptParser(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
