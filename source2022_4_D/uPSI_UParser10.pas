unit uPSI_UParser10;
{
   for math ops    , set it pointer free to test first
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
  TPSImport_UParser10 = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TExParser(CL: TPSPascalCompiler);
procedure SIRegister_TCustomParser(CL: TPSPascalCompiler);
procedure SIRegister_UParser10(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TExParser(CL: TPSRuntimeClassImporter);
procedure RIRegister_TCustomParser(CL: TPSRuntimeClassImporter);
procedure RIRegister_UParser10(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   UParser10
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_UParser10]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TExParser(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TCustomParser', 'TExParser') do
  with CL.AddClassN(CL.FindClass('TCustomParser'),'TExParser') do
  begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
    RegisterMethod('Function RemoveBlanks( const s : string) : string');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TCustomParser(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TComponent', 'TCustomParser') do
  with CL.AddClassN(CL.FindClass('TComponent'),'TCustomParser') do begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
     RegisterMethod('Procedure Free');
    RegisterMethod('Procedure SetExpression( const AnExpression : string)');
    RegisterMethod('Function ParseExpression( const AnExpression : string) : boolean');
    RegisterMethod('Procedure FreeExpression');
    RegisterMethod('Function SetVariable( VarName : string; const Value : extended) : PParserFloat');
    RegisterMethod('Function GetVariable( const VarName : string) : extended');
    RegisterMethod('Procedure AddFunctionOneParam( const AFunctionName : string; const Func : TMathProcedure)');
    RegisterMethod('Procedure AddFunctionTwoParam( const AFunctionName : string; const Func : TMathProcedure)');
    RegisterMethod('Procedure ClearVariables');
    RegisterMethod('Procedure ClearVariable( const AVarName : string)');
    RegisterMethod('Function VariableExists( const AVarName : string) : boolean');
    RegisterMethod('Procedure ClearFunctions');
    RegisterMethod('Procedure ClearFunction( const AFunctionName : string)');
    RegisterProperty('ParserError', 'boolean', iptr);
    RegisterProperty('LinkedOperationList', 'POperation', iptr);
    RegisterProperty('Variable', 'extended string', iptrw);
    RegisterProperty('Value', 'extended', iptr);
    RegisterProperty('Expression', 'string', iptrw);
    RegisterProperty('PascalNumberformat', 'boolean', iptrw);
    RegisterProperty('OnParserError', 'TExParserExceptionEvent', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_UParser10(CL: TPSPascalCompiler);
begin
  CL.AddTypeS('ParserFloat', 'extended');
  //CL.AddTypeS('PParserFloat', '^ParserFloat // will not work');
 // CL.AddTypeS('TDFFToken', '( variab, constant, minus, sum, diff, prod, divis, mod'
  // +'ulo, IntDiv, IntDIVZ, integerpower, realpower, square, third, fourth, FuncOneVar, FuncTwoVar )');
  //CL.AddTypeS('POperation', '^TOperation // will not work');
  //CL.AddTypeS('TMathProcedure','procedure(AnOperation: TDFFOperation)');
  //CL.AddTypeS('TDFFOperation', 'record Arg1 : ParserFloat; Arg2 : ParserFloat; D'
   //+'est : ParserFloat; NextOperation : TDFFOperation; Operation : TMathProcedure'
   //+'; Token : TDFFToken; end');
  //CL.AddTypeS('TMathProcedure','procedure(AnOperation: TDFFOperation)');
  CL.AddClassN(CL.FindClass('TOBJECT'),'EMathParserError');
  CL.AddClassN(CL.FindClass('TOBJECT'),'ESyntaxError');
  CL.AddClassN(CL.FindClass('TOBJECT'),'EExpressionHasBlanks');
  CL.AddClassN(CL.FindClass('TOBJECT'),'EExpressionTooComplex');
  CL.AddClassN(CL.FindClass('TOBJECT'),'ETooManyNestings');
  CL.AddClassN(CL.FindClass('TOBJECT'),'EMissMatchingBracket');
  CL.AddClassN(CL.FindClass('TOBJECT'),'EBadName');
  CL.AddClassN(CL.FindClass('TOBJECT'),'EParserInternalError');
  CL.AddTypeS('TExParserExceptionEvent', 'Procedure ( Sender : TObject; E : Exception)');
  SIRegister_TCustomParser(CL);
  SIRegister_TExParser(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TCustomParserOnParserError_W(Self: TCustomParser; const T: TExParserExceptionEvent);
begin Self.OnParserError := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomParserOnParserError_R(Self: TCustomParser; var T: TExParserExceptionEvent);
begin T := Self.OnParserError; end;

(*----------------------------------------------------------------------------*)
procedure TCustomParserPascalNumberformat_W(Self: TCustomParser; const T: boolean);
begin Self.PascalNumberformat := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomParserPascalNumberformat_R(Self: TCustomParser; var T: boolean);
begin T := Self.PascalNumberformat; end;

(*----------------------------------------------------------------------------*)
procedure TCustomParserExpression_W(Self: TCustomParser; const T: string);
begin Self.Expression := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomParserExpression_R(Self: TCustomParser; var T: string);
begin T := Self.Expression; end;

(*----------------------------------------------------------------------------*)
procedure TCustomParserValue_R(Self: TCustomParser; var T: extended);
begin T := Self.Value; end;

(*----------------------------------------------------------------------------*)
procedure TCustomParserVariable_W(Self: TCustomParser; const T: extended; const t1: string);
begin Self.Variable[t1] := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomParserVariable_R(Self: TCustomParser; var T: extended; const t1: string);
begin T := Self.Variable[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TCustomParserLinkedOperationList_R(Self: TCustomParser; var T: POperation);
begin T := Self.LinkedOperationList; end;

(*----------------------------------------------------------------------------*)
procedure TCustomParserParserError_R(Self: TCustomParser; var T: boolean);
begin T := Self.ParserError; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TExParser(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TExParser) do
  begin
    RegisterConstructor(@TExParser.Create, 'Create');
    RegisterMethod(@TExParser.RemoveBlanks, 'RemoveBlanks');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TCustomParser(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TCustomParser) do begin
    RegisterConstructor(@TCustomParser.Create, 'Create');
    RegisterMethod(@TCustomParser.Destroy, 'Free');
    RegisterMethod(@TCustomParser.SetExpression, 'SetExpression');
    RegisterMethod(@TCustomParser.ParseExpression, 'ParseExpression');
    RegisterMethod(@TCustomParser.FreeExpression, 'FreeExpression');
    RegisterMethod(@TCustomParser.SetVariable, 'SetVariable');
    RegisterMethod(@TCustomParser.GetVariable, 'GetVariable');
    RegisterMethod(@TCustomParser.AddFunctionOneParam, 'AddFunctionOneParam');
    RegisterMethod(@TCustomParser.AddFunctionTwoParam, 'AddFunctionTwoParam');
    RegisterMethod(@TCustomParser.ClearVariables, 'ClearVariables');
    RegisterMethod(@TCustomParser.ClearVariable, 'ClearVariable');
    RegisterMethod(@TCustomParser.VariableExists, 'VariableExists');
    RegisterMethod(@TCustomParser.ClearFunctions, 'ClearFunctions');
    RegisterMethod(@TCustomParser.ClearFunction, 'ClearFunction');
    RegisterPropertyHelper(@TCustomParserParserError_R,nil,'ParserError');
    RegisterPropertyHelper(@TCustomParserLinkedOperationList_R,nil,'LinkedOperationList');
    RegisterPropertyHelper(@TCustomParserVariable_R,@TCustomParserVariable_W,'Variable');
    RegisterPropertyHelper(@TCustomParserValue_R,nil,'Value');
    RegisterPropertyHelper(@TCustomParserExpression_R,@TCustomParserExpression_W,'Expression');
    RegisterPropertyHelper(@TCustomParserPascalNumberformat_R,@TCustomParserPascalNumberformat_W,'PascalNumberformat');
    RegisterPropertyHelper(@TCustomParserOnParserError_R,@TCustomParserOnParserError_W,'OnParserError');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_UParser10(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(EMathParserError) do
  with CL.Add(ESyntaxError) do
  with CL.Add(EExpressionHasBlanks) do
  with CL.Add(EExpressionTooComplex) do
  with CL.Add(ETooManyNestings) do
  with CL.Add(EMissMatchingBracket) do
  with CL.Add(EBadName) do
  with CL.Add(EParserInternalError) do
  RIRegister_TCustomParser(CL);
  RIRegister_TExParser(CL);
end;

 
 
{ TPSImport_UParser10 }
(*----------------------------------------------------------------------------*)
procedure TPSImport_UParser10.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_UParser10(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_UParser10.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_UParser10(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
