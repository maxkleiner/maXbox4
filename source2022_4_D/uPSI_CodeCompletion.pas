unit uPSI_CodeCompletion;
{
   correct free and completion proposal
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
  TPSImport_CodeCompletion = class(TPSPlugin)
  public
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TCodeCompletion(CL: TPSPascalCompiler);
procedure SIRegister_CodeCompletion(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TCodeCompletion(CL: TPSRuntimeClassImporter);
procedure RIRegister_CodeCompletion(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   Windows
  ,Forms
  ,Controls
  ,Graphics
  ,StrUtils
  ,CppParser
  ,ExtCtrls
  ,U_IntList
  ,Dialogs
  ,CodeCompletion
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_CodeCompletion]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TCodeCompletion(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TComponent', 'TCodeCompletion') do
  with CL.AddClassN(CL.FindClass('TComponent'),'TCodeCompletion') do begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
    RegisterMethod('Procedure Free');
    RegisterMethod('Procedure Search( Sender : TWinControl; Phrase, Filename : string)');
    RegisterMethod('Procedure Hide');
    RegisterMethod('Function SelectedStatement : PStatement');
    RegisterMethod('Function SelectedIsFunction : boolean');
    RegisterMethod('Procedure ShowArgsHint( FuncName : string; Rect : TRect)');
    RegisterMethod('Procedure ShowMsgHint( Rect : TRect; HintText : string)');
    RegisterProperty('Parser', 'TCppParser', iptrw);
    RegisterProperty('Position', 'TPoint', iptrw);
    RegisterProperty('Color', 'TColor', iptrw);
    RegisterProperty('Width', 'integer', iptrw);
    RegisterProperty('Height', 'integer', iptrw);
    RegisterProperty('Enabled', 'boolean', iptrw);
    RegisterProperty('HintTimeout', 'cardinal', iptrw);
    RegisterProperty('MinWidth', 'integer', iptrw);
    RegisterProperty('MinHeight', 'integer', iptrw);
    RegisterProperty('MaxWidth', 'integer', iptrw);
    RegisterProperty('MaxHeight', 'integer', iptrw);
    RegisterProperty('OnCompletion', 'TCompletionEvent', iptrw);
    RegisterProperty('OnKeyPress', 'TKeyPressEvent', iptrw);
    RegisterProperty('OnResize', 'TNotifyEvent', iptrw);
    RegisterProperty('OnlyGlobals', 'boolean', iptrw);
    RegisterProperty('CurrentClass', 'integer', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_CodeCompletion(CL: TPSPascalCompiler);
begin
  CL.AddTypeS('TCompletionEvent', 'Procedure ( Sender : TObject; const AStateme'
   +'nt : TStatement; const AIndex : Integer)');
  SIRegister_TCodeCompletion(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TCodeCompletionCurrentClass_W(Self: TCodeCompletion; const T: integer);
begin Self.CurrentClass := T; end;

(*----------------------------------------------------------------------------*)
procedure TCodeCompletionCurrentClass_R(Self: TCodeCompletion; var T: integer);
begin T := Self.CurrentClass; end;

(*----------------------------------------------------------------------------*)
procedure TCodeCompletionOnlyGlobals_W(Self: TCodeCompletion; const T: boolean);
begin Self.OnlyGlobals := T; end;

(*----------------------------------------------------------------------------*)
procedure TCodeCompletionOnlyGlobals_R(Self: TCodeCompletion; var T: boolean);
begin T := Self.OnlyGlobals; end;

(*----------------------------------------------------------------------------*)
procedure TCodeCompletionOnResize_W(Self: TCodeCompletion; const T: TNotifyEvent);
begin Self.OnResize := T; end;

(*----------------------------------------------------------------------------*)
procedure TCodeCompletionOnResize_R(Self: TCodeCompletion; var T: TNotifyEvent);
begin T := Self.OnResize; end;

(*----------------------------------------------------------------------------*)
procedure TCodeCompletionOnKeyPress_W(Self: TCodeCompletion; const T: TKeyPressEvent);
begin Self.OnKeyPress := T; end;

(*----------------------------------------------------------------------------*)
procedure TCodeCompletionOnKeyPress_R(Self: TCodeCompletion; var T: TKeyPressEvent);
begin T := Self.OnKeyPress; end;

(*----------------------------------------------------------------------------*)
procedure TCodeCompletionOnCompletion_W(Self: TCodeCompletion; const T: TCompletionEvent);
begin Self.OnCompletion := T; end;

(*----------------------------------------------------------------------------*)
procedure TCodeCompletionOnCompletion_R(Self: TCodeCompletion; var T: TCompletionEvent);
begin T := Self.OnCompletion; end;

(*----------------------------------------------------------------------------*)
procedure TCodeCompletionMaxHeight_W(Self: TCodeCompletion; const T: integer);
begin Self.MaxHeight := T; end;

(*----------------------------------------------------------------------------*)
procedure TCodeCompletionMaxHeight_R(Self: TCodeCompletion; var T: integer);
begin T := Self.MaxHeight; end;

(*----------------------------------------------------------------------------*)
procedure TCodeCompletionMaxWidth_W(Self: TCodeCompletion; const T: integer);
begin Self.MaxWidth := T; end;

(*----------------------------------------------------------------------------*)
procedure TCodeCompletionMaxWidth_R(Self: TCodeCompletion; var T: integer);
begin T := Self.MaxWidth; end;

(*----------------------------------------------------------------------------*)
procedure TCodeCompletionMinHeight_W(Self: TCodeCompletion; const T: integer);
begin Self.MinHeight := T; end;

(*----------------------------------------------------------------------------*)
procedure TCodeCompletionMinHeight_R(Self: TCodeCompletion; var T: integer);
begin T := Self.MinHeight; end;

(*----------------------------------------------------------------------------*)
procedure TCodeCompletionMinWidth_W(Self: TCodeCompletion; const T: integer);
begin Self.MinWidth := T; end;

(*----------------------------------------------------------------------------*)
procedure TCodeCompletionMinWidth_R(Self: TCodeCompletion; var T: integer);
begin T := Self.MinWidth; end;

(*----------------------------------------------------------------------------*)
procedure TCodeCompletionHintTimeout_W(Self: TCodeCompletion; const T: cardinal);
begin Self.HintTimeout := T; end;

(*----------------------------------------------------------------------------*)
procedure TCodeCompletionHintTimeout_R(Self: TCodeCompletion; var T: cardinal);
begin T := Self.HintTimeout; end;

(*----------------------------------------------------------------------------*)
procedure TCodeCompletionEnabled_W(Self: TCodeCompletion; const T: boolean);
begin Self.Enabled := T; end;

(*----------------------------------------------------------------------------*)
procedure TCodeCompletionEnabled_R(Self: TCodeCompletion; var T: boolean);
begin T := Self.Enabled; end;

(*----------------------------------------------------------------------------*)
procedure TCodeCompletionHeight_W(Self: TCodeCompletion; const T: integer);
begin Self.Height := T; end;

(*----------------------------------------------------------------------------*)
procedure TCodeCompletionHeight_R(Self: TCodeCompletion; var T: integer);
begin T := Self.Height; end;

(*----------------------------------------------------------------------------*)
procedure TCodeCompletionWidth_W(Self: TCodeCompletion; const T: integer);
begin Self.Width := T; end;

(*----------------------------------------------------------------------------*)
procedure TCodeCompletionWidth_R(Self: TCodeCompletion; var T: integer);
begin T := Self.Width; end;

(*----------------------------------------------------------------------------*)
procedure TCodeCompletionColor_W(Self: TCodeCompletion; const T: TColor);
begin Self.Color := T; end;

(*----------------------------------------------------------------------------*)
procedure TCodeCompletionColor_R(Self: TCodeCompletion; var T: TColor);
begin T := Self.Color; end;

(*----------------------------------------------------------------------------*)
procedure TCodeCompletionPosition_W(Self: TCodeCompletion; const T: TPoint);
begin Self.Position := T; end;

(*----------------------------------------------------------------------------*)
procedure TCodeCompletionPosition_R(Self: TCodeCompletion; var T: TPoint);
begin T := Self.Position; end;

(*----------------------------------------------------------------------------*)
procedure TCodeCompletionParser_W(Self: TCodeCompletion; const T: TCppParser);
begin Self.Parser := T; end;

(*----------------------------------------------------------------------------*)
procedure TCodeCompletionParser_R(Self: TCodeCompletion; var T: TCppParser);
begin T := Self.Parser; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TCodeCompletion(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TCodeCompletion) do begin
    RegisterConstructor(@TCodeCompletion.Create, 'Create');
   RegisterMethod(@TCodeCompletion.Destroy, 'Free');
      RegisterMethod(@TCodeCompletion.Search, 'Search');
    RegisterMethod(@TCodeCompletion.Hide, 'Hide');
    RegisterMethod(@TCodeCompletion.SelectedStatement, 'SelectedStatement');
    RegisterMethod(@TCodeCompletion.SelectedIsFunction, 'SelectedIsFunction');
    RegisterMethod(@TCodeCompletion.ShowArgsHint, 'ShowArgsHint');
    RegisterMethod(@TCodeCompletion.ShowMsgHint, 'ShowMsgHint');
    RegisterPropertyHelper(@TCodeCompletionParser_R,@TCodeCompletionParser_W,'Parser');
    RegisterPropertyHelper(@TCodeCompletionPosition_R,@TCodeCompletionPosition_W,'Position');
    RegisterPropertyHelper(@TCodeCompletionColor_R,@TCodeCompletionColor_W,'Color');
    RegisterPropertyHelper(@TCodeCompletionWidth_R,@TCodeCompletionWidth_W,'Width');
    RegisterPropertyHelper(@TCodeCompletionHeight_R,@TCodeCompletionHeight_W,'Height');
    RegisterPropertyHelper(@TCodeCompletionEnabled_R,@TCodeCompletionEnabled_W,'Enabled');
    RegisterPropertyHelper(@TCodeCompletionHintTimeout_R,@TCodeCompletionHintTimeout_W,'HintTimeout');
    RegisterPropertyHelper(@TCodeCompletionMinWidth_R,@TCodeCompletionMinWidth_W,'MinWidth');
    RegisterPropertyHelper(@TCodeCompletionMinHeight_R,@TCodeCompletionMinHeight_W,'MinHeight');
    RegisterPropertyHelper(@TCodeCompletionMaxWidth_R,@TCodeCompletionMaxWidth_W,'MaxWidth');
    RegisterPropertyHelper(@TCodeCompletionMaxHeight_R,@TCodeCompletionMaxHeight_W,'MaxHeight');
    RegisterPropertyHelper(@TCodeCompletionOnCompletion_R,@TCodeCompletionOnCompletion_W,'OnCompletion');
    RegisterPropertyHelper(@TCodeCompletionOnKeyPress_R,@TCodeCompletionOnKeyPress_W,'OnKeyPress');
    RegisterPropertyHelper(@TCodeCompletionOnResize_R,@TCodeCompletionOnResize_W,'OnResize');
    RegisterPropertyHelper(@TCodeCompletionOnlyGlobals_R,@TCodeCompletionOnlyGlobals_W,'OnlyGlobals');
    RegisterPropertyHelper(@TCodeCompletionCurrentClass_R,@TCodeCompletionCurrentClass_W,'CurrentClass');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_CodeCompletion(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TCodeCompletion(CL);
end;

 
 
{ TPSImport_CodeCompletion }
(*----------------------------------------------------------------------------*)
procedure TPSImport_CodeCompletion.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_CodeCompletion(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_CodeCompletion.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_CodeCompletion(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
