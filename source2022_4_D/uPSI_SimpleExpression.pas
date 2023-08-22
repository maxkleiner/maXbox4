unit uPSI_SimpleExpression;
{
   with eval check
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
  TPSImport_SimpleExpression = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TSimpleExpression(CL: TPSPascalCompiler);
procedure SIRegister_SimpleExpression(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TSimpleExpression(CL: TPSRuntimeClassImporter);
procedure RIRegister_SimpleExpression(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   SimpleExpression
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_SimpleExpression]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TSimpleExpression(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOBJECT', 'TSimpleExpression') do
  with CL.AddClassN(CL.FindClass('TOBJECT'),'TSimpleExpression') do begin
    RegisterMethod('Function Eval : Boolean');
    RegisterProperty('Expression', 'String', iptrw);
    RegisterProperty('Lazy', 'Boolean', iptrw);
    RegisterProperty('OnEvalIdentifier', 'TSimpleExpressionOnEvalIdentifier', iptrw);
    RegisterProperty('OnExpandConstant', 'TSimpleExpressionOnExpandConstant', iptrw);
    RegisterProperty('ParametersAllowed', 'Boolean', iptrw);
    RegisterProperty('SilentOrAllowed', 'Boolean', iptrw);
    RegisterProperty('SingleIdentifierMode', 'Boolean', iptrw);
    RegisterProperty('Tag', 'LongInt', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_SimpleExpression(CL: TPSPascalCompiler);
begin
  CL.AddClassN(CL.FindClass('TOBJECT'),'TSimpleExpression');
  //CL.AddTypeS('TSimpleExpressionOnEvalIdentifier', 'Function ( Sender : TSimple'
   //+'Expression; const Name : String; const Parameters : array of byte) : Boolean');
  CL.AddTypeS('TSimpleExpressionOnExpandConstant', 'Function ( Sender : TSimple'
   +'Expression; const Constant : String) : String');
  SIRegister_TSimpleExpression(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TSimpleExpressionTag_W(Self: TSimpleExpression; const T: LongInt);
begin Self.Tag := T; end;

(*----------------------------------------------------------------------------*)
procedure TSimpleExpressionTag_R(Self: TSimpleExpression; var T: LongInt);
begin T := Self.Tag; end;

(*----------------------------------------------------------------------------*)
procedure TSimpleExpressionSingleIdentifierMode_W(Self: TSimpleExpression; const T: Boolean);
begin Self.SingleIdentifierMode := T; end;

(*----------------------------------------------------------------------------*)
procedure TSimpleExpressionSingleIdentifierMode_R(Self: TSimpleExpression; var T: Boolean);
begin T := Self.SingleIdentifierMode; end;

(*----------------------------------------------------------------------------*)
procedure TSimpleExpressionSilentOrAllowed_W(Self: TSimpleExpression; const T: Boolean);
begin Self.SilentOrAllowed := T; end;

(*----------------------------------------------------------------------------*)
procedure TSimpleExpressionSilentOrAllowed_R(Self: TSimpleExpression; var T: Boolean);
begin T := Self.SilentOrAllowed; end;

(*----------------------------------------------------------------------------*)
procedure TSimpleExpressionParametersAllowed_W(Self: TSimpleExpression; const T: Boolean);
begin Self.ParametersAllowed := T; end;

(*----------------------------------------------------------------------------*)
procedure TSimpleExpressionParametersAllowed_R(Self: TSimpleExpression; var T: Boolean);
begin T := Self.ParametersAllowed; end;

(*----------------------------------------------------------------------------*)
procedure TSimpleExpressionOnExpandConstant_W(Self: TSimpleExpression; const T: TSimpleExpressionOnExpandConstant);
begin Self.OnExpandConstant := T; end;

(*----------------------------------------------------------------------------*)
procedure TSimpleExpressionOnExpandConstant_R(Self: TSimpleExpression; var T: TSimpleExpressionOnExpandConstant);
begin T := Self.OnExpandConstant; end;

(*----------------------------------------------------------------------------*)
procedure TSimpleExpressionOnEvalIdentifier_W(Self: TSimpleExpression; const T: TSimpleExpressionOnEvalIdentifier);
begin Self.OnEvalIdentifier := T; end;

(*----------------------------------------------------------------------------*)
procedure TSimpleExpressionOnEvalIdentifier_R(Self: TSimpleExpression; var T: TSimpleExpressionOnEvalIdentifier);
begin T := Self.OnEvalIdentifier; end;

(*----------------------------------------------------------------------------*)
procedure TSimpleExpressionLazy_W(Self: TSimpleExpression; const T: Boolean);
begin Self.Lazy := T; end;

(*----------------------------------------------------------------------------*)
procedure TSimpleExpressionLazy_R(Self: TSimpleExpression; var T: Boolean);
begin T := Self.Lazy; end;

(*----------------------------------------------------------------------------*)
procedure TSimpleExpressionExpression_W(Self: TSimpleExpression; const T: String);
begin Self.Expression := T; end;

(*----------------------------------------------------------------------------*)
procedure TSimpleExpressionExpression_R(Self: TSimpleExpression; var T: String);
begin T := Self.Expression; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TSimpleExpression(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TSimpleExpression) do
  begin
    RegisterMethod(@TSimpleExpression.Eval, 'Eval');
    RegisterPropertyHelper(@TSimpleExpressionExpression_R,@TSimpleExpressionExpression_W,'Expression');
    RegisterPropertyHelper(@TSimpleExpressionLazy_R,@TSimpleExpressionLazy_W,'Lazy');
    RegisterPropertyHelper(@TSimpleExpressionOnEvalIdentifier_R,@TSimpleExpressionOnEvalIdentifier_W,'OnEvalIdentifier');
    RegisterPropertyHelper(@TSimpleExpressionOnExpandConstant_R,@TSimpleExpressionOnExpandConstant_W,'OnExpandConstant');
    RegisterPropertyHelper(@TSimpleExpressionParametersAllowed_R,@TSimpleExpressionParametersAllowed_W,'ParametersAllowed');
    RegisterPropertyHelper(@TSimpleExpressionSilentOrAllowed_R,@TSimpleExpressionSilentOrAllowed_W,'SilentOrAllowed');
    RegisterPropertyHelper(@TSimpleExpressionSingleIdentifierMode_R,@TSimpleExpressionSingleIdentifierMode_W,'SingleIdentifierMode');
    RegisterPropertyHelper(@TSimpleExpressionTag_R,@TSimpleExpressionTag_W,'Tag');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_SimpleExpression(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TSimpleExpression) do
  RIRegister_TSimpleExpression(CL);
end;

 
 
{ TPSImport_SimpleExpression }
(*----------------------------------------------------------------------------*)
procedure TPSImport_SimpleExpression.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_SimpleExpression(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_SimpleExpression.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_SimpleExpression(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
