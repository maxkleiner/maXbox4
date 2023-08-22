unit uPSI_HarmFade;
{
     fade in and out

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
  TPSImport_HarmFade = class(TPSPlugin)
  public
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_THarmFade(CL: TPSPascalCompiler);
procedure SIRegister_HarmFade(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_HarmFade_Routines(S: TPSExec);
procedure RIRegister_THarmFade(CL: TPSRuntimeClassImporter);
procedure RIRegister_HarmFade(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   Windows
  ,Messages
  ,Graphics
  ,Controls
  ,Forms
  ,Dialogs
  ,HarmFade
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_HarmFade]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_THarmFade(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TGraphicControl', 'THarmFade') do
  with CL.AddClassN(CL.FindClass('TGraphicControl'),'THarmFade') do begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
      RegisterMethod('Procedure Free');
      RegisterMethod('Procedure Paint');
    RegisterMethod('Procedure Reset');
    RegisterMethod('Procedure Dissolve');
    RegisterMethod('Procedure FinishIt');
    RegisterMethod('Procedure Blend');
    RegisterMethod('Procedure UnBlend');
    RegisterMethod('Procedure UnDissolve');
    RegisterProperty('Finish', 'Boolean', iptrw);
    RegisterProperty('OnMouseEnter', 'TNotifyEvent', iptrw);
    RegisterProperty('OnMouseLeave', 'TNotifyEvent', iptrw);
    RegisterProperty('PicFrom', 'TPicture', iptrw);
    RegisterProperty('PicTo', 'TPicture', iptrw);
    RegisterProperty('ColorFrom', 'TColor', iptrw);
    RegisterProperty('ColorTo', 'TColor', iptrw);
    RegisterProperty('DisolvRate', 'integer', iptrw);
    RegisterProperty('BlendRate', 'integer', iptrw);
    RegisterProperty('StretchToFit', 'Boolean', iptrw);
    RegisterProperty('ProcessMsgs', 'Boolean', iptrw);
    RegisterProperty('OnBegin', 'TNotifyEvent', iptrw);
    RegisterProperty('OnEnd', 'TNotifyEvent', iptrw);
    RegisterProperty('OnReset', 'TNotifyEvent', iptrw);
    RegisterProperty('AutoReverse', 'Boolean', iptrw);
    RegisterProperty('SwapOnReverse', 'Boolean', iptrw);
    RegisterProperty('SwapDelay', 'integer', iptrw);
    registerpublishedproperties;
       RegisterProperty('OnClick', 'TNotifyEvent', iptrw);
    RegisterProperty('visible', 'boolean', iptrw);
    RegisterProperty('hint', 'string', iptrw);

  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_HarmFade(CL: TPSPascalCompiler);
begin
 CL.AddConstantN('MaxPixelCount2','LongInt').SetInt( 32768);
 CL.AddConstantN('Mask0101','LongWord').SetUInt( $00FF00FF);
 CL.AddConstantN('Mask1010','LongWord').SetUInt( $FF00FF00);
  CL.AddClassN(CL.FindClass('TOBJECT'),'EHarmFade');
  //CL.AddTypeS('PRGBArray', '^TRGBArray // will not work');
  SIRegister_THarmFade(CL);
 //CL.AddDelphiFunction('Procedure Register');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure THarmFadeSwapDelay_W(Self: THarmFade; const T: integer);
begin Self.SwapDelay := T; end;

(*----------------------------------------------------------------------------*)
procedure THarmFadeSwapDelay_R(Self: THarmFade; var T: integer);
begin T := Self.SwapDelay; end;

(*----------------------------------------------------------------------------*)
procedure THarmFadeSwapOnReverse_W(Self: THarmFade; const T: Boolean);
begin Self.SwapOnReverse := T; end;

(*----------------------------------------------------------------------------*)
procedure THarmFadeSwapOnReverse_R(Self: THarmFade; var T: Boolean);
begin T := Self.SwapOnReverse; end;

(*----------------------------------------------------------------------------*)
procedure THarmFadeAutoReverse_W(Self: THarmFade; const T: Boolean);
begin Self.AutoReverse := T; end;

(*----------------------------------------------------------------------------*)
procedure THarmFadeAutoReverse_R(Self: THarmFade; var T: Boolean);
begin T := Self.AutoReverse; end;

(*----------------------------------------------------------------------------*)
procedure THarmFadeOnReset_W(Self: THarmFade; const T: TNotifyEvent);
begin Self.OnReset := T; end;

(*----------------------------------------------------------------------------*)
procedure THarmFadeOnReset_R(Self: THarmFade; var T: TNotifyEvent);
begin T := Self.OnReset; end;

(*----------------------------------------------------------------------------*)
procedure THarmFadeOnEnd_W(Self: THarmFade; const T: TNotifyEvent);
begin Self.OnEnd := T; end;

(*----------------------------------------------------------------------------*)
procedure THarmFadeOnEnd_R(Self: THarmFade; var T: TNotifyEvent);
begin T := Self.OnEnd; end;

(*----------------------------------------------------------------------------*)
procedure THarmFadeOnBegin_W(Self: THarmFade; const T: TNotifyEvent);
begin Self.OnBegin := T; end;

(*----------------------------------------------------------------------------*)
procedure THarmFadeOnBegin_R(Self: THarmFade; var T: TNotifyEvent);
begin T := Self.OnBegin; end;

(*----------------------------------------------------------------------------*)
procedure THarmFadeProcessMsgs_W(Self: THarmFade; const T: Boolean);
begin Self.ProcessMsgs := T; end;

(*----------------------------------------------------------------------------*)
procedure THarmFadeProcessMsgs_R(Self: THarmFade; var T: Boolean);
begin T := Self.ProcessMsgs; end;

(*----------------------------------------------------------------------------*)
procedure THarmFadeStretchToFit_W(Self: THarmFade; const T: Boolean);
begin Self.StretchToFit := T; end;

(*----------------------------------------------------------------------------*)
procedure THarmFadeStretchToFit_R(Self: THarmFade; var T: Boolean);
begin T := Self.StretchToFit; end;

(*----------------------------------------------------------------------------*)
procedure THarmFadeBlendRate_W(Self: THarmFade; const T: integer);
begin Self.BlendRate := T; end;

(*----------------------------------------------------------------------------*)
procedure THarmFadeBlendRate_R(Self: THarmFade; var T: integer);
begin T := Self.BlendRate; end;

(*----------------------------------------------------------------------------*)
procedure THarmFadeDisolvRate_W(Self: THarmFade; const T: integer);
begin Self.DisolvRate := T; end;

(*----------------------------------------------------------------------------*)
procedure THarmFadeDisolvRate_R(Self: THarmFade; var T: integer);
begin T := Self.DisolvRate; end;

(*----------------------------------------------------------------------------*)
procedure THarmFadeColorTo_W(Self: THarmFade; const T: TColor);
begin Self.ColorTo := T; end;

(*----------------------------------------------------------------------------*)
procedure THarmFadeColorTo_R(Self: THarmFade; var T: TColor);
begin T := Self.ColorTo; end;

(*----------------------------------------------------------------------------*)
procedure THarmFadeColorFrom_W(Self: THarmFade; const T: TColor);
begin Self.ColorFrom := T; end;

(*----------------------------------------------------------------------------*)
procedure THarmFadeColorFrom_R(Self: THarmFade; var T: TColor);
begin T := Self.ColorFrom; end;

(*----------------------------------------------------------------------------*)
procedure THarmFadePicTo_W(Self: THarmFade; const T: TPicture);
begin Self.PicTo := T; end;

(*----------------------------------------------------------------------------*)
procedure THarmFadePicTo_R(Self: THarmFade; var T: TPicture);
begin T := Self.PicTo; end;

(*----------------------------------------------------------------------------*)
procedure THarmFadePicFrom_W(Self: THarmFade; const T: TPicture);
begin Self.PicFrom := T; end;

(*----------------------------------------------------------------------------*)
procedure THarmFadePicFrom_R(Self: THarmFade; var T: TPicture);
begin T := Self.PicFrom; end;

(*----------------------------------------------------------------------------*)
procedure THarmFadeOnMouseLeave_W(Self: THarmFade; const T: TNotifyEvent);
begin Self.OnMouseLeave := T; end;

(*----------------------------------------------------------------------------*)
procedure THarmFadeOnMouseLeave_R(Self: THarmFade; var T: TNotifyEvent);
begin T := Self.OnMouseLeave; end;

(*----------------------------------------------------------------------------*)
procedure THarmFadeOnMouseEnter_W(Self: THarmFade; const T: TNotifyEvent);
begin Self.OnMouseEnter := T; end;

(*----------------------------------------------------------------------------*)
procedure THarmFadeOnMouseEnter_R(Self: THarmFade; var T: TNotifyEvent);
begin T := Self.OnMouseEnter; end;

(*----------------------------------------------------------------------------*)
procedure THarmFadeFinish_W(Self: THarmFade; const T: Boolean);
begin Self.Finish := T; end;

(*----------------------------------------------------------------------------*)
procedure THarmFadeFinish_R(Self: THarmFade; var T: Boolean);
begin T := Self.Finish; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_HarmFade_Routines(S: TPSExec);
begin
 //S.RegisterDelphiFunction(@Register, 'Register', cdRegister);
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_THarmFade(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(THarmFade) do begin
    RegisterConstructor(@THarmFade.Create, 'Create');
      RegisterMethod(@THarmFade.Destroy, 'Free');
      RegisterMethod(@THarmFade.Paint, 'Paint');
    RegisterMethod(@THarmFade.Reset, 'Reset');
    RegisterMethod(@THarmFade.Dissolve, 'Dissolve');
    RegisterMethod(@THarmFade.FinishIt, 'FinishIt');
    RegisterMethod(@THarmFade.Blend, 'Blend');
    RegisterMethod(@THarmFade.UnBlend, 'UnBlend');
    RegisterMethod(@THarmFade.UnDissolve, 'UnDissolve');
    RegisterPropertyHelper(@THarmFadeFinish_R,@THarmFadeFinish_W,'Finish');
    RegisterPropertyHelper(@THarmFadeOnMouseEnter_R,@THarmFadeOnMouseEnter_W,'OnMouseEnter');
    RegisterPropertyHelper(@THarmFadeOnMouseLeave_R,@THarmFadeOnMouseLeave_W,'OnMouseLeave');
    RegisterPropertyHelper(@THarmFadePicFrom_R,@THarmFadePicFrom_W,'PicFrom');
    RegisterPropertyHelper(@THarmFadePicTo_R,@THarmFadePicTo_W,'PicTo');
    RegisterPropertyHelper(@THarmFadeColorFrom_R,@THarmFadeColorFrom_W,'ColorFrom');
    RegisterPropertyHelper(@THarmFadeColorTo_R,@THarmFadeColorTo_W,'ColorTo');
    RegisterPropertyHelper(@THarmFadeDisolvRate_R,@THarmFadeDisolvRate_W,'DisolvRate');
    RegisterPropertyHelper(@THarmFadeBlendRate_R,@THarmFadeBlendRate_W,'BlendRate');
    RegisterPropertyHelper(@THarmFadeStretchToFit_R,@THarmFadeStretchToFit_W,'StretchToFit');
    RegisterPropertyHelper(@THarmFadeProcessMsgs_R,@THarmFadeProcessMsgs_W,'ProcessMsgs');
    RegisterPropertyHelper(@THarmFadeOnBegin_R,@THarmFadeOnBegin_W,'OnBegin');
    RegisterPropertyHelper(@THarmFadeOnEnd_R,@THarmFadeOnEnd_W,'OnEnd');
    RegisterPropertyHelper(@THarmFadeOnReset_R,@THarmFadeOnReset_W,'OnReset');
    RegisterPropertyHelper(@THarmFadeAutoReverse_R,@THarmFadeAutoReverse_W,'AutoReverse');
    RegisterPropertyHelper(@THarmFadeSwapOnReverse_R,@THarmFadeSwapOnReverse_W,'SwapOnReverse');
    RegisterPropertyHelper(@THarmFadeSwapDelay_R,@THarmFadeSwapDelay_W,'SwapDelay');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_HarmFade(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(EHarmFade) do
  RIRegister_THarmFade(CL);
end;

 
 
{ TPSImport_HarmFade }
(*----------------------------------------------------------------------------*)
procedure TPSImport_HarmFade.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_HarmFade(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_HarmFade.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_HarmFade(ri);
  //RIRegister_HarmFade_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
