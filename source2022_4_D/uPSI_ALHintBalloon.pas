unit uPSI_ALHintBalloon;
{
   bigbitboxhint
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
  TPSImport_ALHintBalloon = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TALHintBalloonControl(CL: TPSPascalCompiler);
procedure SIRegister_TALHintBalloon(CL: TPSPascalCompiler);
procedure SIRegister_ALHintBalloon(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_ALHintBalloon_Routines(S: TPSExec);
procedure RIRegister_TALHintBalloonControl(CL: TPSRuntimeClassImporter);
procedure RIRegister_TALHintBalloon(CL: TPSRuntimeClassImporter);
procedure RIRegister_ALHintBalloon(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   Forms
  ,Controls
  ,ExtCtrls
  ,Messages
  ,ALHintBalloon
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_ALHintBalloon]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TALHintBalloonControl(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TComponent', 'TALHintBalloonControl') do
  with CL.AddClassN(CL.FindClass('TComponent'),'TALHintBalloonControl') do
  begin
    RegisterMethod('Procedure ShowTextHintBalloon( blnMsgType : TALHintBalloonMsgType; blnTitle, blnText : String; blnBestWidth, blnLeft, blnTop : integer; blnSourceControl : Tcontrol; blnArrowPosition : TALHintBalloonArrowPosition)');
    RegisterMethod('Procedure ShowPictureHintBalloon( blnImageFilename : String; blnLeft, blnTop : integer; blnSourceControl : TControl; blnArrowPosition : TALHintBalloonArrowPosition)');
    RegisterMethod('Procedure ShowCustomHintBalloon( blnCreateContentProcess : TALHintBalloonCreateContentProcess; BlncustomProperty : String; blnLeft, blnTop : integer; blnSourceControl : TControl; blnArrowPosition : TALHintBalloonArrowPosition)');
    RegisterMethod('Function CloseHintBalloons : integer');
    RegisterMethod('Constructor Create( AOwner : TComponent)');
    RegisterProperty('Duration', 'integer', iptrw);
    RegisterProperty('AnimationType', 'TALHintBalloonAnimationType', iptrw);
    RegisterProperty('AnimationSpeed', 'cardinal', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TALHintBalloon(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TCustomForm', 'TALHintBalloon') do
  with CL.AddClassN(CL.FindClass('TCustomForm'),'TALHintBalloon') do begin
    RegisterMethod('Constructor CreateNew( AOwner : TComponent; Dummy : integer)');
    RegisterMethod('Procedure OnFormClick( Sender : TObject)');
    RegisterMethod('Procedure ShowHintBalloon( blnCreateContentProcess : TALHintBalloonCreateContentProcess; blnLeft, blnTop : integer; blnSourceControl : TControl; blnDuration : integer; blnArrowPosition : TALHintBalloonArrowPosition;'
    +' blnAnimationType : TALHintBalloonAnimationType; blnAnimationSpeed : cardinal)');
    RegisterMethod('Function TranslateAnimation( Value : TALHintBalloonAnimationType) : cardinal');
    RegisterProperty('MainPanel', 'Tpanel', iptrw);
    RegisterProperty('CustomProperty', 'String', iptrw);
    RegisterProperty('BorderWidth', 'Integer', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_ALHintBalloon(CL: TPSPascalCompiler);
begin
  CL.AddClassN(CL.FindClass('TOBJECT'),'TALHintBalloon');
  CL.AddTypeS('TALHintBalloonMsgType', '( bmtInfo, bmtError, bmtWarning, bmtNone )');
  CL.AddTypeS('TALHintBalloonArrowPosition', '( bapTopLeft, bapTopRight, bapBottomLeft, bapBottomRight )');
  CL.AddTypeS('TALHintBalloonAnimationType', '( batNone, batBlend, batCenter, b'
   +'atSlideLeftToRight, batSlideRightToLeft, batSlideTopToBottom, batSlideBott'
   +'omToTop, batWipeLeftToRight, batWipeRightToLeft, batWipeTopToBottom, batWipeBottomToTop )');
  SIRegister_TALHintBalloon(CL);
  SIRegister_TALHintBalloonControl(CL);
 //CL.AddDelphiFunction('Procedure Register');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TALHintBalloonControlAnimationSpeed_W(Self: TALHintBalloonControl; const T: cardinal);
begin Self.AnimationSpeed := T; end;

(*----------------------------------------------------------------------------*)
procedure TALHintBalloonControlAnimationSpeed_R(Self: TALHintBalloonControl; var T: cardinal);
begin T := Self.AnimationSpeed; end;

(*----------------------------------------------------------------------------*)
procedure TALHintBalloonControlAnimationType_W(Self: TALHintBalloonControl; const T: TALHintBalloonAnimationType);
begin Self.AnimationType := T; end;

(*----------------------------------------------------------------------------*)
procedure TALHintBalloonControlAnimationType_R(Self: TALHintBalloonControl; var T: TALHintBalloonAnimationType);
begin T := Self.AnimationType; end;

(*----------------------------------------------------------------------------*)
procedure TALHintBalloonControlDuration_W(Self: TALHintBalloonControl; const T: integer);
begin Self.Duration := T; end;

(*----------------------------------------------------------------------------*)
procedure TALHintBalloonControlDuration_R(Self: TALHintBalloonControl; var T: integer);
begin T := Self.Duration; end;

(*----------------------------------------------------------------------------*)
procedure TALHintBalloonBorderWidth_W(Self: TALHintBalloon; const T: Integer);
begin Self.BorderWidth := T; end;

(*----------------------------------------------------------------------------*)
procedure TALHintBalloonBorderWidth_R(Self: TALHintBalloon; var T: Integer);
begin T := Self.BorderWidth; end;

(*----------------------------------------------------------------------------*)
procedure TALHintBalloonCustomProperty_W(Self: TALHintBalloon; const T: String);
begin Self.CustomProperty := T; end;

(*----------------------------------------------------------------------------*)
procedure TALHintBalloonCustomProperty_R(Self: TALHintBalloon; var T: String);
begin T := Self.CustomProperty; end;

(*----------------------------------------------------------------------------*)
procedure TALHintBalloonMainPanel_W(Self: TALHintBalloon; const T: Tpanel);
begin Self.MainPanel := T; end;

(*----------------------------------------------------------------------------*)
procedure TALHintBalloonMainPanel_R(Self: TALHintBalloon; var T: Tpanel);
begin T := Self.MainPanel; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_ALHintBalloon_Routines(S: TPSExec);
begin
 //S.RegisterDelphiFunction(@Register, 'Register', cdRegister);
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TALHintBalloonControl(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TALHintBalloonControl) do
  begin
    RegisterMethod(@TALHintBalloonControl.ShowTextHintBalloon, 'ShowTextHintBalloon');
    RegisterMethod(@TALHintBalloonControl.ShowPictureHintBalloon, 'ShowPictureHintBalloon');
    RegisterMethod(@TALHintBalloonControl.ShowCustomHintBalloon, 'ShowCustomHintBalloon');
    RegisterMethod(@TALHintBalloonControl.CloseHintBalloons, 'CloseHintBalloons');
    RegisterConstructor(@TALHintBalloonControl.Create, 'Create');
    RegisterPropertyHelper(@TALHintBalloonControlDuration_R,@TALHintBalloonControlDuration_W,'Duration');
    RegisterPropertyHelper(@TALHintBalloonControlAnimationType_R,@TALHintBalloonControlAnimationType_W,'AnimationType');
    RegisterPropertyHelper(@TALHintBalloonControlAnimationSpeed_R,@TALHintBalloonControlAnimationSpeed_W,'AnimationSpeed');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TALHintBalloon(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TALHintBalloon) do
  begin
    RegisterConstructor(@TALHintBalloon.CreateNew, 'CreateNew');
    RegisterVirtualMethod(@TALHintBalloon.OnFormClick, 'OnFormClick');
    RegisterMethod(@TALHintBalloon.ShowHintBalloon, 'ShowHintBalloon');
    RegisterMethod(@TALHintBalloon.TranslateAnimation, 'TranslateAnimation');
    RegisterPropertyHelper(@TALHintBalloonMainPanel_R,@TALHintBalloonMainPanel_W,'MainPanel');
    RegisterPropertyHelper(@TALHintBalloonCustomProperty_R,@TALHintBalloonCustomProperty_W,'CustomProperty');
    RegisterPropertyHelper(@TALHintBalloonBorderWidth_R,@TALHintBalloonBorderWidth_W,'BorderWidth');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_ALHintBalloon(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TALHintBalloon) do
  RIRegister_TALHintBalloon(CL);
  RIRegister_TALHintBalloonControl(CL);
end;

 
 
{ TPSImport_ALHintBalloon }
(*----------------------------------------------------------------------------*)
procedure TPSImport_ALHintBalloon.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_ALHintBalloon(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_ALHintBalloon.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_ALHintBalloon(ri);
  RIRegister_ALHintBalloon_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
