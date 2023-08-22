unit uPSI_IBScript;
{
   more scripts
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
  TPSImport_IBScript = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TIBScript(CL: TPSPascalCompiler);
procedure SIRegister_TIBScriptStats(CL: TPSPascalCompiler);
procedure SIRegister_TIBSQLParser(CL: TPSPascalCompiler);
procedure SIRegister_IBScript(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TIBScript(CL: TPSRuntimeClassImporter);
procedure RIRegister_TIBScriptStats(CL: TPSRuntimeClassImporter);
procedure RIRegister_TIBSQLParser(CL: TPSRuntimeClassImporter);
procedure RIRegister_IBScript(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   IBDatabase
  ,IBCustomDataset
  ,IBSQL
  ,IBDatabaseInfo
  ,IBExternals
  ,IBScript
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_IBScript]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TIBScript(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TComponent', 'TIBScript') do
  with CL.AddClassN(CL.FindClass('TComponent'),'TIBScript') do begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
    RegisterMethod('Function ValidateScript : Boolean');
    RegisterMethod('Procedure ExecuteScript');
    RegisterMethod('Function ParamByName( Idx : String) : TIBXSQLVAR');
    RegisterProperty('Paused', 'Boolean', iptrw);
    RegisterProperty('Params', 'TIBXSQLDA', iptr);
    RegisterProperty('Stats', 'TIBScriptStats', iptr);
    RegisterProperty('CurrentTokens', 'TStrings', iptr);
    RegisterProperty('Validating', 'Boolean', iptr);
    RegisterProperty('AutoDDL', 'Boolean', iptrw);
    RegisterProperty('Dataset', 'TIBDataset', iptrw);
    RegisterProperty('Database', 'TIBDatabase', iptrw);
    RegisterProperty('Transaction', 'TIBTransaction', iptrw);
    RegisterProperty('Terminator', 'string', iptrw);
    RegisterProperty('Script', 'TStrings', iptrw);
    RegisterProperty('Statistics', 'boolean', iptrw);
    RegisterProperty('OnParse', 'TIBSQLParseStmt', iptrw);
    RegisterProperty('OnParseError', 'TIBSQLParseError', iptrw);
    RegisterProperty('OnExecuteError', 'TIBSQLExecuteError', iptrw);
    RegisterProperty('OnParamCheck', 'TIBScriptParamCheck', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TIBScriptStats(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOBJECT', 'TIBScriptStats') do
  with CL.AddClassN(CL.FindClass('TOBJECT'),'TIBScriptStats') do begin
    RegisterMethod('Constructor Create');
    RegisterMethod('Procedure Start');
    RegisterMethod('Procedure Clear');
    RegisterMethod('Procedure Stop');
    RegisterProperty('Database', 'TIBDatabase', iptrw);
    RegisterProperty('Buffers', 'int64', iptr);
    RegisterProperty('Reads', 'int64', iptr);
    RegisterProperty('Writes', 'int64', iptr);
    RegisterProperty('SeqReads', 'int64', iptr);
    RegisterProperty('Fetches', 'int64', iptr);
    RegisterProperty('ReadIdx', 'int64', iptr);
    RegisterProperty('DeltaMem', 'int64', iptr);
    RegisterProperty('StartingMem', 'int64', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TIBSQLParser(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TComponent', 'TIBSQLParser') do
  with CL.AddClassN(CL.FindClass('TComponent'),'TIBSQLParser') do begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
    RegisterMethod('Procedure Parse');
    RegisterProperty('CurrentLine', 'Integer', iptr);
    RegisterProperty('CurrentTokens', 'TStrings', iptr);
    RegisterProperty('Finished', 'Boolean', iptr);
    RegisterProperty('Paused', 'Boolean', iptrw);
    RegisterProperty('Script', 'TStrings', iptrw);
    RegisterProperty('Terminator', 'string', iptrw);
    RegisterProperty('OnParse', 'TIBSQLParseStmt', iptrw);
    RegisterProperty('OnError', 'TIBSQLParseError', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_IBScript(CL: TPSPascalCompiler);
begin
  CL.AddClassN(CL.FindClass('TOBJECT'),'TIBScript');
  CL.AddTypeS('TIBParseKind', '( stmtDDL, stmtDML, stmtSET, stmtCONNECT, stmtDr'
   +'op, stmtCREATE, stmtINPUT, stmtUNK, stmtEMPTY, stmtTERM, stmtERR, stmtCOMM'
   +'IT, stmtROLLBACK, stmtReconnect, stmtRollbackSavePoint, stmtReleaseSavePoi'
   +'nt, stmtStartSavepoint, stmtCOMMITRetaining, stmtROLLBACKRetaining, stmtBa'
   +'tchStart, stmtBatchExecute )');
  CL.AddTypeS('TIBSQLParseError', 'Procedure ( Sender : TObject; Error : string'
   +'; SQLText : string; LineIndex : Integer)');
  CL.AddTypeS('TIBSQLExecuteError', 'Procedure ( Sender : TObject; Error : stri'
   +'ng; SQLText : string; LineIndex : Integer; var Ignore : Boolean)');
  CL.AddTypeS('TIBSQLParseStmt', 'Procedure ( Sender : TObject; AKind : TIBParseKind; SQLText : string)');
  CL.AddTypeS('TIBScriptParamCheck', 'Procedure ( Sender : TIBScript; var Pause: Boolean)');
  SIRegister_TIBSQLParser(CL);
  SIRegister_TIBScriptStats(CL);
  SIRegister_TIBScript(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TIBScriptOnParamCheck_W(Self: TIBScript; const T: TIBScriptParamCheck);
begin Self.OnParamCheck := T; end;

(*----------------------------------------------------------------------------*)
procedure TIBScriptOnParamCheck_R(Self: TIBScript; var T: TIBScriptParamCheck);
begin T := Self.OnParamCheck; end;

(*----------------------------------------------------------------------------*)
procedure TIBScriptOnExecuteError_W(Self: TIBScript; const T: TIBSQLExecuteError);
begin Self.OnExecuteError := T; end;

(*----------------------------------------------------------------------------*)
procedure TIBScriptOnExecuteError_R(Self: TIBScript; var T: TIBSQLExecuteError);
begin T := Self.OnExecuteError; end;

(*----------------------------------------------------------------------------*)
procedure TIBScriptOnParseError_W(Self: TIBScript; const T: TIBSQLParseError);
begin Self.OnParseError := T; end;

(*----------------------------------------------------------------------------*)
procedure TIBScriptOnParseError_R(Self: TIBScript; var T: TIBSQLParseError);
begin T := Self.OnParseError; end;

(*----------------------------------------------------------------------------*)
procedure TIBScriptOnParse_W(Self: TIBScript; const T: TIBSQLParseStmt);
begin Self.OnParse := T; end;

(*----------------------------------------------------------------------------*)
procedure TIBScriptOnParse_R(Self: TIBScript; var T: TIBSQLParseStmt);
begin T := Self.OnParse; end;

(*----------------------------------------------------------------------------*)
procedure TIBScriptStatistics_W(Self: TIBScript; const T: boolean);
begin Self.Statistics := T; end;

(*----------------------------------------------------------------------------*)
procedure TIBScriptStatistics_R(Self: TIBScript; var T: boolean);
begin T := Self.Statistics; end;

(*----------------------------------------------------------------------------*)
procedure TIBScriptScript_W(Self: TIBScript; const T: TStrings);
begin Self.Script := T; end;

(*----------------------------------------------------------------------------*)
procedure TIBScriptScript_R(Self: TIBScript; var T: TStrings);
begin T := Self.Script; end;

(*----------------------------------------------------------------------------*)
procedure TIBScriptTerminator_W(Self: TIBScript; const T: string);
begin Self.Terminator := T; end;

(*----------------------------------------------------------------------------*)
procedure TIBScriptTerminator_R(Self: TIBScript; var T: string);
begin T := Self.Terminator; end;

(*----------------------------------------------------------------------------*)
procedure TIBScriptTransaction_W(Self: TIBScript; const T: TIBTransaction);
begin Self.Transaction := T; end;

(*----------------------------------------------------------------------------*)
procedure TIBScriptTransaction_R(Self: TIBScript; var T: TIBTransaction);
begin T := Self.Transaction; end;

(*----------------------------------------------------------------------------*)
procedure TIBScriptDatabase_W(Self: TIBScript; const T: TIBDatabase);
begin Self.Database := T; end;

(*----------------------------------------------------------------------------*)
procedure TIBScriptDatabase_R(Self: TIBScript; var T: TIBDatabase);
begin T := Self.Database; end;

(*----------------------------------------------------------------------------*)
procedure TIBScriptDataset_W(Self: TIBScript; const T: TIBDataset);
begin Self.Dataset := T; end;

(*----------------------------------------------------------------------------*)
procedure TIBScriptDataset_R(Self: TIBScript; var T: TIBDataset);
begin T := Self.Dataset; end;

(*----------------------------------------------------------------------------*)
procedure TIBScriptAutoDDL_W(Self: TIBScript; const T: Boolean);
begin Self.AutoDDL := T; end;

(*----------------------------------------------------------------------------*)
procedure TIBScriptAutoDDL_R(Self: TIBScript; var T: Boolean);
begin T := Self.AutoDDL; end;

(*----------------------------------------------------------------------------*)
procedure TIBScriptValidating_R(Self: TIBScript; var T: Boolean);
begin T := Self.Validating; end;

(*----------------------------------------------------------------------------*)
procedure TIBScriptCurrentTokens_R(Self: TIBScript; var T: TStrings);
begin T := Self.CurrentTokens; end;

(*----------------------------------------------------------------------------*)
procedure TIBScriptStats_R(Self: TIBScript; var T: TIBScriptStats);
begin T := Self.Stats; end;

(*----------------------------------------------------------------------------*)
procedure TIBScriptParams_R(Self: TIBScript; var T: TIBXSQLDA);
begin T := Self.Params; end;

(*----------------------------------------------------------------------------*)
procedure TIBScriptPaused_W(Self: TIBScript; const T: Boolean);
begin Self.Paused := T; end;

(*----------------------------------------------------------------------------*)
procedure TIBScriptPaused_R(Self: TIBScript; var T: Boolean);
begin T := Self.Paused; end;

(*----------------------------------------------------------------------------*)
procedure TIBScriptStatsStartingMem_R(Self: TIBScriptStats; var T: int64);
begin T := Self.StartingMem; end;

(*----------------------------------------------------------------------------*)
procedure TIBScriptStatsDeltaMem_R(Self: TIBScriptStats; var T: int64);
begin T := Self.DeltaMem; end;

(*----------------------------------------------------------------------------*)
procedure TIBScriptStatsReadIdx_R(Self: TIBScriptStats; var T: int64);
begin T := Self.ReadIdx; end;

(*----------------------------------------------------------------------------*)
procedure TIBScriptStatsFetches_R(Self: TIBScriptStats; var T: int64);
begin T := Self.Fetches; end;

(*----------------------------------------------------------------------------*)
procedure TIBScriptStatsSeqReads_R(Self: TIBScriptStats; var T: int64);
begin T := Self.SeqReads; end;

(*----------------------------------------------------------------------------*)
procedure TIBScriptStatsWrites_R(Self: TIBScriptStats; var T: int64);
begin T := Self.Writes; end;

(*----------------------------------------------------------------------------*)
procedure TIBScriptStatsReads_R(Self: TIBScriptStats; var T: int64);
begin T := Self.Reads; end;

(*----------------------------------------------------------------------------*)
procedure TIBScriptStatsBuffers_R(Self: TIBScriptStats; var T: int64);
begin T := Self.Buffers; end;

(*----------------------------------------------------------------------------*)
procedure TIBScriptStatsDatabase_W(Self: TIBScriptStats; const T: TIBDatabase);
begin Self.Database := T; end;

(*----------------------------------------------------------------------------*)
procedure TIBScriptStatsDatabase_R(Self: TIBScriptStats; var T: TIBDatabase);
begin T := Self.Database; end;

(*----------------------------------------------------------------------------*)
procedure TIBSQLParserOnError_W(Self: TIBSQLParser; const T: TIBSQLParseError);
begin Self.OnError := T; end;

(*----------------------------------------------------------------------------*)
procedure TIBSQLParserOnError_R(Self: TIBSQLParser; var T: TIBSQLParseError);
begin T := Self.OnError; end;

(*----------------------------------------------------------------------------*)
procedure TIBSQLParserOnParse_W(Self: TIBSQLParser; const T: TIBSQLParseStmt);
begin Self.OnParse := T; end;

(*----------------------------------------------------------------------------*)
procedure TIBSQLParserOnParse_R(Self: TIBSQLParser; var T: TIBSQLParseStmt);
begin T := Self.OnParse; end;

(*----------------------------------------------------------------------------*)
procedure TIBSQLParserTerminator_W(Self: TIBSQLParser; const T: string);
begin Self.Terminator := T; end;

(*----------------------------------------------------------------------------*)
procedure TIBSQLParserTerminator_R(Self: TIBSQLParser; var T: string);
begin T := Self.Terminator; end;

(*----------------------------------------------------------------------------*)
procedure TIBSQLParserScript_W(Self: TIBSQLParser; const T: TStrings);
begin Self.Script := T; end;

(*----------------------------------------------------------------------------*)
procedure TIBSQLParserScript_R(Self: TIBSQLParser; var T: TStrings);
begin T := Self.Script; end;

(*----------------------------------------------------------------------------*)
procedure TIBSQLParserPaused_W(Self: TIBSQLParser; const T: Boolean);
begin Self.Paused := T; end;

(*----------------------------------------------------------------------------*)
procedure TIBSQLParserPaused_R(Self: TIBSQLParser; var T: Boolean);
begin T := Self.Paused; end;

(*----------------------------------------------------------------------------*)
procedure TIBSQLParserFinished_R(Self: TIBSQLParser; var T: Boolean);
begin T := Self.Finished; end;

(*----------------------------------------------------------------------------*)
procedure TIBSQLParserCurrentTokens_R(Self: TIBSQLParser; var T: TStrings);
begin T := Self.CurrentTokens; end;

(*----------------------------------------------------------------------------*)
procedure TIBSQLParserCurrentLine_R(Self: TIBSQLParser; var T: Integer);
begin T := Self.CurrentLine; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TIBScript(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TIBScript) do
  begin
    RegisterConstructor(@TIBScript.Create, 'Create');
    RegisterMethod(@TIBScript.ValidateScript, 'ValidateScript');
    RegisterMethod(@TIBScript.ExecuteScript, 'ExecuteScript');
    RegisterMethod(@TIBScript.ParamByName, 'ParamByName');
    RegisterPropertyHelper(@TIBScriptPaused_R,@TIBScriptPaused_W,'Paused');
    RegisterPropertyHelper(@TIBScriptParams_R,nil,'Params');
    RegisterPropertyHelper(@TIBScriptStats_R,nil,'Stats');
    RegisterPropertyHelper(@TIBScriptCurrentTokens_R,nil,'CurrentTokens');
    RegisterPropertyHelper(@TIBScriptValidating_R,nil,'Validating');
    RegisterPropertyHelper(@TIBScriptAutoDDL_R,@TIBScriptAutoDDL_W,'AutoDDL');
    RegisterPropertyHelper(@TIBScriptDataset_R,@TIBScriptDataset_W,'Dataset');
    RegisterPropertyHelper(@TIBScriptDatabase_R,@TIBScriptDatabase_W,'Database');
    RegisterPropertyHelper(@TIBScriptTransaction_R,@TIBScriptTransaction_W,'Transaction');
    RegisterPropertyHelper(@TIBScriptTerminator_R,@TIBScriptTerminator_W,'Terminator');
    RegisterPropertyHelper(@TIBScriptScript_R,@TIBScriptScript_W,'Script');
    RegisterPropertyHelper(@TIBScriptStatistics_R,@TIBScriptStatistics_W,'Statistics');
    RegisterPropertyHelper(@TIBScriptOnParse_R,@TIBScriptOnParse_W,'OnParse');
    RegisterPropertyHelper(@TIBScriptOnParseError_R,@TIBScriptOnParseError_W,'OnParseError');
    RegisterPropertyHelper(@TIBScriptOnExecuteError_R,@TIBScriptOnExecuteError_W,'OnExecuteError');
    RegisterPropertyHelper(@TIBScriptOnParamCheck_R,@TIBScriptOnParamCheck_W,'OnParamCheck');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TIBScriptStats(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TIBScriptStats) do
  begin
    RegisterConstructor(@TIBScriptStats.Create, 'Create');
    RegisterMethod(@TIBScriptStats.Start, 'Start');
    RegisterMethod(@TIBScriptStats.Clear, 'Clear');
    RegisterMethod(@TIBScriptStats.Stop, 'Stop');
    RegisterPropertyHelper(@TIBScriptStatsDatabase_R,@TIBScriptStatsDatabase_W,'Database');
    RegisterPropertyHelper(@TIBScriptStatsBuffers_R,nil,'Buffers');
    RegisterPropertyHelper(@TIBScriptStatsReads_R,nil,'Reads');
    RegisterPropertyHelper(@TIBScriptStatsWrites_R,nil,'Writes');
    RegisterPropertyHelper(@TIBScriptStatsSeqReads_R,nil,'SeqReads');
    RegisterPropertyHelper(@TIBScriptStatsFetches_R,nil,'Fetches');
    RegisterPropertyHelper(@TIBScriptStatsReadIdx_R,nil,'ReadIdx');
    RegisterPropertyHelper(@TIBScriptStatsDeltaMem_R,nil,'DeltaMem');
    RegisterPropertyHelper(@TIBScriptStatsStartingMem_R,nil,'StartingMem');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TIBSQLParser(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TIBSQLParser) do
  begin
    RegisterConstructor(@TIBSQLParser.Create, 'Create');
    RegisterMethod(@TIBSQLParser.Parse, 'Parse');
    RegisterPropertyHelper(@TIBSQLParserCurrentLine_R,nil,'CurrentLine');
    RegisterPropertyHelper(@TIBSQLParserCurrentTokens_R,nil,'CurrentTokens');
    RegisterPropertyHelper(@TIBSQLParserFinished_R,nil,'Finished');
    RegisterPropertyHelper(@TIBSQLParserPaused_R,@TIBSQLParserPaused_W,'Paused');
    RegisterPropertyHelper(@TIBSQLParserScript_R,@TIBSQLParserScript_W,'Script');
    RegisterPropertyHelper(@TIBSQLParserTerminator_R,@TIBSQLParserTerminator_W,'Terminator');
    RegisterPropertyHelper(@TIBSQLParserOnParse_R,@TIBSQLParserOnParse_W,'OnParse');
    RegisterPropertyHelper(@TIBSQLParserOnError_R,@TIBSQLParserOnError_W,'OnError');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_IBScript(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TIBScript) do
  RIRegister_TIBSQLParser(CL);
  RIRegister_TIBScriptStats(CL);
  RIRegister_TIBScript(CL);
end;

 
 
{ TPSImport_IBScript }
(*----------------------------------------------------------------------------*)
procedure TPSImport_IBScript.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_IBScript(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_IBScript.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_IBScript(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
