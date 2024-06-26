unit uPSI_ZSqlProcessor;
{
This file has been generated by UnitParser v0.7, written by M. Knight
and updated by NP. v/d Spek and George Birbilis. 
Source Code from Carlo Kok has been used to implement various sections of
UnitParser. Components of ROPS are used in the construction of UnitParser,
code implementing the class wrapper is taken from Carlo Kok's conv utility

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
  TPSImport_ZSqlProcessor = class(TPSPlugin)
  public
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TZSQLProcessor(CL: TPSPascalCompiler);
procedure SIRegister_ZSqlProcessor(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TZSQLProcessor(CL: TPSRuntimeClassImporter);
procedure RIRegister_ZSqlProcessor(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   ZCompatibility
  ,DB
  //,ZDbcIntfs
  //,ZConnection
  //,ZScriptParser
  //,ZSqlStrings
  ,Types
  ,ZSqlProcessor
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_ZSqlProcessor]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TZSQLProcessor(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TComponent', 'TZSQLProcessor') do
  with CL.AddClassN(CL.FindClass('TComponent'),'TZSQLProcessor') do
  begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
    RegisterMethod('Procedure LoadFromStream( Stream : TStream)');
    RegisterMethod('Procedure LoadFromFile( const FileName : string)');
    RegisterMethod('Procedure Execute');
    RegisterMethod('Procedure Parse');
    RegisterMethod('Procedure Clear');
    RegisterMethod('Function ParamByName( const Value : string) : TParam');
    RegisterProperty('StatementCount', 'Integer', iptr);
    RegisterProperty('Statements', 'string Integer', iptr);
    RegisterProperty('ParamCheck', 'Boolean', iptrw);
    RegisterProperty('ParamChar', 'Char', iptrw);
    RegisterProperty('Params', 'TParams', iptrw);
    RegisterProperty('Script', 'TStrings', iptrw);
    RegisterProperty('Connection', 'TZConnection', iptrw);
    RegisterProperty('DelimiterType', 'TZDelimiterType', iptrw);
    RegisterProperty('Delimiter', 'string', iptrw);
    RegisterProperty('CleanupStatements', 'Boolean', iptrw);
    RegisterProperty('OnError', 'TZProcessorErrorEvent', iptrw);
    RegisterProperty('AfterExecute', 'TZProcessorNotifyEvent', iptrw);
    RegisterProperty('BeforeExecute', 'TZProcessorNotifyEvent', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_ZSqlProcessor(CL: TPSPascalCompiler);
begin
  CL.AddClassN(CL.FindClass('TOBJECT'),'TZSQLProcessor');
  CL.AddTypeS('TZErrorHandleAction', '( eaFail, eaAbort, eaSkip, eaRetry )');
  CL.AddTypeS('TZProcessorNotifyEvent', 'Procedure ( Processor : TZSQLProcessor'
   +'; StatementIndex : Integer)');
  CL.AddTypeS('TZProcessorErrorEvent', 'Procedure ( Processor : TZSQLProcessor;'
   +' StatementIndex : Integer; E : Exception; var ErrorHandleAction : TZErrorH'
   +'andleAction)');
  SIRegister_TZSQLProcessor(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TZSQLProcessorBeforeExecute_W(Self: TZSQLProcessor; const T: TZProcessorNotifyEvent);
begin Self.BeforeExecute := T; end;

(*----------------------------------------------------------------------------*)
procedure TZSQLProcessorBeforeExecute_R(Self: TZSQLProcessor; var T: TZProcessorNotifyEvent);
begin T := Self.BeforeExecute; end;

(*----------------------------------------------------------------------------*)
procedure TZSQLProcessorAfterExecute_W(Self: TZSQLProcessor; const T: TZProcessorNotifyEvent);
begin Self.AfterExecute := T; end;

(*----------------------------------------------------------------------------*)
procedure TZSQLProcessorAfterExecute_R(Self: TZSQLProcessor; var T: TZProcessorNotifyEvent);
begin T := Self.AfterExecute; end;

(*----------------------------------------------------------------------------*)
procedure TZSQLProcessorOnError_W(Self: TZSQLProcessor; const T: TZProcessorErrorEvent);
begin Self.OnError := T; end;

(*----------------------------------------------------------------------------*)
procedure TZSQLProcessorOnError_R(Self: TZSQLProcessor; var T: TZProcessorErrorEvent);
begin T := Self.OnError; end;

(*----------------------------------------------------------------------------*)
procedure TZSQLProcessorCleanupStatements_W(Self: TZSQLProcessor; const T: Boolean);
begin Self.CleanupStatements := T; end;

(*----------------------------------------------------------------------------*)
procedure TZSQLProcessorCleanupStatements_R(Self: TZSQLProcessor; var T: Boolean);
begin T := Self.CleanupStatements; end;

(*----------------------------------------------------------------------------*)
procedure TZSQLProcessorDelimiter_W(Self: TZSQLProcessor; const T: string);
begin Self.Delimiter := T; end;

(*----------------------------------------------------------------------------*)
procedure TZSQLProcessorDelimiter_R(Self: TZSQLProcessor; var T: string);
begin T := Self.Delimiter; end;

(*----------------------------------------------------------------------------*)
procedure TZSQLProcessorDelimiterType_W(Self: TZSQLProcessor; const T: TZDelimiterType);
begin Self.DelimiterType := T; end;

(*----------------------------------------------------------------------------*)
procedure TZSQLProcessorDelimiterType_R(Self: TZSQLProcessor; var T: TZDelimiterType);
begin T := Self.DelimiterType; end;

(*----------------------------------------------------------------------------*)
procedure TZSQLProcessorConnection_W(Self: TZSQLProcessor; const T: TZConnection);
begin Self.Connection := T; end;

(*----------------------------------------------------------------------------*)
procedure TZSQLProcessorConnection_R(Self: TZSQLProcessor; var T: TZConnection);
begin T := Self.Connection; end;

(*----------------------------------------------------------------------------*)
procedure TZSQLProcessorScript_W(Self: TZSQLProcessor; const T: TStrings);
begin Self.Script := T; end;

(*----------------------------------------------------------------------------*)
procedure TZSQLProcessorScript_R(Self: TZSQLProcessor; var T: TStrings);
begin T := Self.Script; end;

(*----------------------------------------------------------------------------*)
procedure TZSQLProcessorParams_W(Self: TZSQLProcessor; const T: TParams);
begin Self.Params := T; end;

(*----------------------------------------------------------------------------*)
procedure TZSQLProcessorParams_R(Self: TZSQLProcessor; var T: TParams);
begin T := Self.Params; end;

(*----------------------------------------------------------------------------*)
procedure TZSQLProcessorParamChar_W(Self: TZSQLProcessor; const T: Char);
begin Self.ParamChar := T; end;

(*----------------------------------------------------------------------------*)
procedure TZSQLProcessorParamChar_R(Self: TZSQLProcessor; var T: Char);
begin T := Self.ParamChar; end;

(*----------------------------------------------------------------------------*)
procedure TZSQLProcessorParamCheck_W(Self: TZSQLProcessor; const T: Boolean);
begin Self.ParamCheck := T; end;

(*----------------------------------------------------------------------------*)
procedure TZSQLProcessorParamCheck_R(Self: TZSQLProcessor; var T: Boolean);
begin T := Self.ParamCheck; end;

(*----------------------------------------------------------------------------*)
procedure TZSQLProcessorStatements_R(Self: TZSQLProcessor; var T: string; const t1: Integer);
begin T := Self.Statements[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TZSQLProcessorStatementCount_R(Self: TZSQLProcessor; var T: Integer);
begin T := Self.StatementCount; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TZSQLProcessor(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TZSQLProcessor) do
  begin
    RegisterConstructor(@TZSQLProcessor.Create, 'Create');
    RegisterMethod(@TZSQLProcessor.LoadFromStream, 'LoadFromStream');
    RegisterMethod(@TZSQLProcessor.LoadFromFile, 'LoadFromFile');
    RegisterMethod(@TZSQLProcessor.Execute, 'Execute');
    RegisterMethod(@TZSQLProcessor.Parse, 'Parse');
    RegisterMethod(@TZSQLProcessor.Clear, 'Clear');
    RegisterMethod(@TZSQLProcessor.ParamByName, 'ParamByName');
    RegisterPropertyHelper(@TZSQLProcessorStatementCount_R,nil,'StatementCount');
    RegisterPropertyHelper(@TZSQLProcessorStatements_R,nil,'Statements');
    RegisterPropertyHelper(@TZSQLProcessorParamCheck_R,@TZSQLProcessorParamCheck_W,'ParamCheck');
    RegisterPropertyHelper(@TZSQLProcessorParamChar_R,@TZSQLProcessorParamChar_W,'ParamChar');
    RegisterPropertyHelper(@TZSQLProcessorParams_R,@TZSQLProcessorParams_W,'Params');
    RegisterPropertyHelper(@TZSQLProcessorScript_R,@TZSQLProcessorScript_W,'Script');
    RegisterPropertyHelper(@TZSQLProcessorConnection_R,@TZSQLProcessorConnection_W,'Connection');
    RegisterPropertyHelper(@TZSQLProcessorDelimiterType_R,@TZSQLProcessorDelimiterType_W,'DelimiterType');
    RegisterPropertyHelper(@TZSQLProcessorDelimiter_R,@TZSQLProcessorDelimiter_W,'Delimiter');
    RegisterPropertyHelper(@TZSQLProcessorCleanupStatements_R,@TZSQLProcessorCleanupStatements_W,'CleanupStatements');
    RegisterPropertyHelper(@TZSQLProcessorOnError_R,@TZSQLProcessorOnError_W,'OnError');
    RegisterPropertyHelper(@TZSQLProcessorAfterExecute_R,@TZSQLProcessorAfterExecute_W,'AfterExecute');
    RegisterPropertyHelper(@TZSQLProcessorBeforeExecute_R,@TZSQLProcessorBeforeExecute_W,'BeforeExecute');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_ZSqlProcessor(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TZSQLProcessor) do
  RIRegister_TZSQLProcessor(CL);
end;

 
 
{ TPSImport_ZSqlProcessor }
(*----------------------------------------------------------------------------*)
procedure TPSImport_ZSqlProcessor.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_ZSqlProcessor(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_ZSqlProcessor.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_ZSqlProcessor(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
