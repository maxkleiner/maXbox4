unit uPSI_StExpr;
{
  ANOTHER Expression
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
  TPSImport_StExpr = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TStExpressionEdit(CL: TPSPascalCompiler);
procedure SIRegister_TStExpression(CL: TPSPascalCompiler);
procedure SIRegister_StExpr(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_StExpr_Routines(S: TPSExec);
procedure RIRegister_TStExpressionEdit(CL: TPSRuntimeClassImporter);
procedure RIRegister_TStExpression(CL: TPSRuntimeClassImporter);
procedure RIRegister_StExpr(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   Windows
  ,Controls
  ,Messages
  ,StdCtrls
  ,Math
  ,StBase
  ,StConst
  ,StMath
  ,StExpr
  ;


procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_StExpr]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TStExpressionEdit(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TStBaseEdit', 'TStExpressionEdit') do
  with CL.AddClassN(CL.FindClass('TStBaseEdit'),'TStExpressionEdit') do begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
       RegisterMethod('Procedure Free');
       RegisterMethod('Function Evaluate : TStFloat');
    RegisterProperty('Expr', 'TStExpression', iptr);
    RegisterProperty('AutoEval', 'Boolean', iptrw);
    RegisterProperty('OnAddIdentifier', 'TNotifyEvent', iptrw);
    RegisterProperty('OnError', 'TStExprErrorEvent', iptrw);
    RegisterProperty('OnGetIdentValue', 'TStGetIdentValueEvent', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TStExpression(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TStComponent', 'TStExpression') do
  with CL.AddClassN(CL.FindClass('TStComponent'),'TStExpression') do begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
       RegisterMethod('Procedure Free');
       RegisterMethod('Function AnalyzeExpression : TStFloat');
    RegisterMethod('Procedure AddConstant( const Name : AnsiString; Value : TStFloat)');
    RegisterMethod('Procedure AddFunction0Param( const Name : AnsiString; FunctionAddr : TStFunction0Param)');
    RegisterMethod('Procedure AddFunction1Param( const Name : AnsiString; FunctionAddr : TStFunction1Param)');
    RegisterMethod('Procedure AddFunction2Param( const Name : AnsiString; FunctionAddr : TStFunction2Param)');
    RegisterMethod('Procedure AddFunction3Param( const Name : AnsiString; FunctionAddr : TStFunction3Param)');
    RegisterMethod('Procedure AddInternalFunctions');
    RegisterMethod('Procedure AddMethod0Param( const Name : AnsiString; MethodAddr : TStMethod0Param)');
    RegisterMethod('Procedure AddMethod1Param( const Name : AnsiString; MethodAddr : TStMethod1Param)');
    RegisterMethod('Procedure AddMethod2Param( const Name : AnsiString; MethodAddr : TStMethod2Param)');
    RegisterMethod('Procedure AddMethod3Param( const Name : AnsiString; MethodAddr : TStMethod3Param)');
    RegisterMethod('Procedure AddVariable( const Name : AnsiString; VariableAddr : PStFloat)');
    RegisterMethod('Procedure ClearIdentifiers');
    RegisterMethod('Procedure GetIdentList( S : TStrings)');
    RegisterMethod('Procedure RemoveIdentifier( const Name : AnsiString)');
    RegisterProperty('AsInteger', 'Integer', iptr);
    RegisterProperty('AsFloat', 'TStFloat', iptr);
    RegisterProperty('AsString', 'AnsiString', iptr);
    RegisterProperty('ErrorPosition', 'Integer', iptr);
    RegisterProperty('Expression', 'AnsiString', iptrw);
    RegisterProperty('LastError', 'Integer', iptr);
    RegisterProperty('AllowEqual', 'Boolean', iptrw);
    RegisterProperty('OnAddIdentifier', 'TNotifyEvent', iptrw);
    RegisterProperty('OnGetIdentValue', 'TStGetIdentValueEvent', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_StExpr(CL: TPSPascalCompiler);
begin
  //CL.AddTypeS('PStFloat', '^TStFloat // will not work');
  CL.AddTypeS('TStMethod0Param', 'Function  : TStFloat');
  CL.AddTypeS('TStMethod1Param', 'Function ( Value1 : TStFloat) : TStFloat');
  CL.AddTypeS('TStMethod2Param', 'Function ( Value1, Value2 : TStFloat) : TStFloat');
  CL.AddTypeS('TStMethod3Param', 'Function ( Value1, Value2, Value3 : TStFloat) : TStFloat');
  CL.AddTypeS('TStGetIdentValueEvent', 'Procedure ( Sender : TObject; const Ide'
   +'ntifier : AnsiString; var Value : TStFloat)');
  CL.AddTypeS('TStToken', '( ssStart, ssInIdent, ssInNum, ssInSign, ssInExp, ss'
   +'Eol, ssNum, ssIdent, ssLPar, ssRPar, ssComma, ssPlus, ssMinus, ssTimes, ssDiv, ssEqual, ssPower )');
  SIRegister_TStExpression(CL);
  CL.AddTypeS('TStExprErrorEvent', 'Procedure ( Sender : TObject; ErrorNumber :'
   +' LongInt; const ErrorStr : AnsiString)');
  SIRegister_TStExpressionEdit(CL);
 CL.AddDelphiFunction('Function AnalyzeExpr( const Expr : AnsiString) : Double');
 CL.AddDelphiFunction('Procedure TpVal( const S : AnsiString; var V : Extended; var Code : Integer)');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TStExpressionEditOnGetIdentValue_W(Self: TStExpressionEdit; const T: TStGetIdentValueEvent);
begin Self.OnGetIdentValue := T; end;

(*----------------------------------------------------------------------------*)
procedure TStExpressionEditOnGetIdentValue_R(Self: TStExpressionEdit; var T: TStGetIdentValueEvent);
begin T := Self.OnGetIdentValue; end;

(*----------------------------------------------------------------------------*)
procedure TStExpressionEditOnError_W(Self: TStExpressionEdit; const T: TStExprErrorEvent);
begin Self.OnError := T; end;

(*----------------------------------------------------------------------------*)
procedure TStExpressionEditOnError_R(Self: TStExpressionEdit; var T: TStExprErrorEvent);
begin T := Self.OnError; end;

(*----------------------------------------------------------------------------*)
procedure TStExpressionEditOnAddIdentifier_W(Self: TStExpressionEdit; const T: TNotifyEvent);
begin Self.OnAddIdentifier := T; end;

(*----------------------------------------------------------------------------*)
procedure TStExpressionEditOnAddIdentifier_R(Self: TStExpressionEdit; var T: TNotifyEvent);
begin T := Self.OnAddIdentifier; end;

(*----------------------------------------------------------------------------*)
procedure TStExpressionEditAutoEval_W(Self: TStExpressionEdit; const T: Boolean);
begin Self.AutoEval := T; end;

(*----------------------------------------------------------------------------*)
procedure TStExpressionEditAutoEval_R(Self: TStExpressionEdit; var T: Boolean);
begin T := Self.AutoEval; end;

(*----------------------------------------------------------------------------*)
procedure TStExpressionEditExpr_R(Self: TStExpressionEdit; var T: TStExpression);
begin T := Self.Expr; end;

(*----------------------------------------------------------------------------*)
procedure TStExpressionOnGetIdentValue_W(Self: TStExpression; const T: TStGetIdentValueEvent);
begin Self.OnGetIdentValue := T; end;

(*----------------------------------------------------------------------------*)
procedure TStExpressionOnGetIdentValue_R(Self: TStExpression; var T: TStGetIdentValueEvent);
begin T := Self.OnGetIdentValue; end;

(*----------------------------------------------------------------------------*)
procedure TStExpressionOnAddIdentifier_W(Self: TStExpression; const T: TNotifyEvent);
begin Self.OnAddIdentifier := T; end;

(*----------------------------------------------------------------------------*)
procedure TStExpressionOnAddIdentifier_R(Self: TStExpression; var T: TNotifyEvent);
begin T := Self.OnAddIdentifier; end;

(*----------------------------------------------------------------------------*)
procedure TStExpressionAllowEqual_W(Self: TStExpression; const T: Boolean);
begin Self.AllowEqual := T; end;

(*----------------------------------------------------------------------------*)
procedure TStExpressionAllowEqual_R(Self: TStExpression; var T: Boolean);
begin T := Self.AllowEqual; end;

(*----------------------------------------------------------------------------*)
procedure TStExpressionLastError_R(Self: TStExpression; var T: Integer);
begin T := Self.LastError; end;

(*----------------------------------------------------------------------------*)
procedure TStExpressionExpression_W(Self: TStExpression; const T: AnsiString);
begin Self.Expression := T; end;

(*----------------------------------------------------------------------------*)
procedure TStExpressionExpression_R(Self: TStExpression; var T: AnsiString);
begin T := Self.Expression; end;

(*----------------------------------------------------------------------------*)
procedure TStExpressionErrorPosition_R(Self: TStExpression; var T: Integer);
begin T := Self.ErrorPosition; end;

(*----------------------------------------------------------------------------*)
procedure TStExpressionAsString_R(Self: TStExpression; var T: AnsiString);
begin T := Self.AsString; end;

(*----------------------------------------------------------------------------*)
procedure TStExpressionAsFloat_R(Self: TStExpression; var T: TStFloat);
begin T := Self.AsFloat; end;

(*----------------------------------------------------------------------------*)
procedure TStExpressionAsInteger_R(Self: TStExpression; var T: Integer);
begin T := Self.AsInteger; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_StExpr_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@AnalyzeExpr, 'AnalyzeExpr', cdRegister);
 S.RegisterDelphiFunction(@TpVal, 'TpVal', cdRegister);
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TStExpressionEdit(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TStExpressionEdit) do begin
    RegisterConstructor(@TStExpressionEdit.Create, 'Create');
       RegisterMethod(@TStExpressionEdit.Destroy, 'Free');
      RegisterMethod(@TStExpressionEdit.Evaluate, 'Evaluate');
    RegisterPropertyHelper(@TStExpressionEditExpr_R,nil,'Expr');
    RegisterPropertyHelper(@TStExpressionEditAutoEval_R,@TStExpressionEditAutoEval_W,'AutoEval');
    RegisterPropertyHelper(@TStExpressionEditOnAddIdentifier_R,@TStExpressionEditOnAddIdentifier_W,'OnAddIdentifier');
    RegisterPropertyHelper(@TStExpressionEditOnError_R,@TStExpressionEditOnError_W,'OnError');
    RegisterPropertyHelper(@TStExpressionEditOnGetIdentValue_R,@TStExpressionEditOnGetIdentValue_W,'OnGetIdentValue');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TStExpression(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TStExpression) do begin
    RegisterConstructor(@TStExpression.Create, 'Create');
    RegisterMethod(@TStExpression.Destroy, 'Free');
    RegisterMethod(@TStExpression.AnalyzeExpression, 'AnalyzeExpression');
    RegisterMethod(@TStExpression.AddConstant, 'AddConstant');
    RegisterMethod(@TStExpression.AddFunction0Param, 'AddFunction0Param');
    RegisterMethod(@TStExpression.AddFunction1Param, 'AddFunction1Param');
    RegisterMethod(@TStExpression.AddFunction2Param, 'AddFunction2Param');
    RegisterMethod(@TStExpression.AddFunction3Param, 'AddFunction3Param');
    RegisterMethod(@TStExpression.AddInternalFunctions, 'AddInternalFunctions');
    RegisterMethod(@TStExpression.AddMethod0Param, 'AddMethod0Param');
    RegisterMethod(@TStExpression.AddMethod1Param, 'AddMethod1Param');
    RegisterMethod(@TStExpression.AddMethod2Param, 'AddMethod2Param');
    RegisterMethod(@TStExpression.AddMethod3Param, 'AddMethod3Param');
    RegisterMethod(@TStExpression.AddVariable, 'AddVariable');
    RegisterMethod(@TStExpression.ClearIdentifiers, 'ClearIdentifiers');
    RegisterMethod(@TStExpression.GetIdentList, 'GetIdentList');
    RegisterMethod(@TStExpression.RemoveIdentifier, 'RemoveIdentifier');
    RegisterPropertyHelper(@TStExpressionAsInteger_R,nil,'AsInteger');
    RegisterPropertyHelper(@TStExpressionAsFloat_R,nil,'AsFloat');
    RegisterPropertyHelper(@TStExpressionAsString_R,nil,'AsString');
    RegisterPropertyHelper(@TStExpressionErrorPosition_R,nil,'ErrorPosition');
    RegisterPropertyHelper(@TStExpressionExpression_R,@TStExpressionExpression_W,'Expression');
    RegisterPropertyHelper(@TStExpressionLastError_R,nil,'LastError');
    RegisterPropertyHelper(@TStExpressionAllowEqual_R,@TStExpressionAllowEqual_W,'AllowEqual');
    RegisterPropertyHelper(@TStExpressionOnAddIdentifier_R,@TStExpressionOnAddIdentifier_W,'OnAddIdentifier');
    RegisterPropertyHelper(@TStExpressionOnGetIdentValue_R,@TStExpressionOnGetIdentValue_W,'OnGetIdentValue');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_StExpr(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TStExpression(CL);
  RIRegister_TStExpressionEdit(CL);
end;

 
 
{ TPSImport_StExpr }
(*----------------------------------------------------------------------------*)
procedure TPSImport_StExpr.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_StExpr(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_StExpr.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_StExpr(ri);
  RIRegister_StExpr_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
