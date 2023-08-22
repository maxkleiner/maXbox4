unit uPSI_JvAnimate;
{
   to alternate to aVI_Throbber
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
  TPSImport_JvAnimate = class(TPSPlugin)
  public
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TJvAnimate(CL: TPSPascalCompiler);
procedure SIRegister_JvAnimate(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TJvAnimate(CL: TPSRuntimeClassImporter);
procedure RIRegister_JvAnimate(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   Windows
  ,Messages
  ,Graphics
  ,Controls
  ,Forms
  ,ComCtrls
  ,JVCLVer
  ,JvAnimate
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_JvAnimate]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TJvAnimate(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TAnimate', 'TJvAnimate') do
  with CL.AddClassN(CL.FindClass('TAnimate'),'TJvAnimate') do begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
     RegisterMethod('Procedure Free');
     RegisterProperty('AboutJVCL', 'TJVCLAboutInfo', iptrw);
    RegisterProperty('HintColor', 'TColor', iptrw);
    RegisterProperty('OnMouseEnter', 'TNotifyEvent', iptrw);
    RegisterProperty('OnMouseLeave', 'TNotifyEvent', iptrw);
    RegisterProperty('OnParentColorChange', 'TNotifyEvent', iptrw);
     RegisterProperty('ResHandle', 'THandle', iptrw);
     RegisterPublishedProperties;
    RegisterProperty('ResId', 'Integer', iptrw);
    RegisterProperty('ResName', 'string', iptrw);
    RegisterProperty('Active', 'Boolean', iptrw);
    RegisterProperty('Center', 'Boolean', iptrw);
    RegisterProperty('CommonAVI', 'TCommonAVI', iptrw);
    RegisterProperty('FileName', 'string', iptrw);
    RegisterProperty('Repetitions', 'Integer', iptrw);
    RegisterProperty('StartFrame', 'Smallint', iptrw);
    RegisterProperty('StopFrame', 'Smallint', iptrw);
    RegisterProperty('Timers', 'Boolean', iptrw);
    RegisterProperty('Transparent', 'Boolean', iptrw);
    RegisterProperty('OnOpen', 'TNotifyEvent', iptrw);
    RegisterProperty('OnClose', 'TNotifyEvent', iptrw);
    RegisterProperty('OnStart', 'TNotifyEvent', iptrw);
    RegisterProperty('OnStop', 'TNotifyEvent', iptrw);
    RegisterProperty('OnClick', 'TNotifyEvent', iptrw);
    RegisterProperty('OnDblClick', 'TNotifyEvent', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_JvAnimate(CL: TPSPascalCompiler);
begin
  SIRegister_TJvAnimate(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TJvAnimateOnParentColorChange_W(Self: TJvAnimate; const T: TNotifyEvent);
begin Self.OnParentColorChange := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvAnimateOnParentColorChange_R(Self: TJvAnimate; var T: TNotifyEvent);
begin T := Self.OnParentColorChange; end;

(*----------------------------------------------------------------------------*)
procedure TJvAnimateOnMouseLeave_W(Self: TJvAnimate; const T: TNotifyEvent);
begin Self.OnMouseLeave := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvAnimateOnMouseLeave_R(Self: TJvAnimate; var T: TNotifyEvent);
begin T := Self.OnMouseLeave; end;

(*----------------------------------------------------------------------------*)
procedure TJvAnimateOnMouseEnter_W(Self: TJvAnimate; const T: TNotifyEvent);
begin Self.OnMouseEnter := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvAnimateOnMouseEnter_R(Self: TJvAnimate; var T: TNotifyEvent);
begin T := Self.OnMouseEnter; end;

(*----------------------------------------------------------------------------*)
procedure TJvAnimateHintColor_W(Self: TJvAnimate; const T: TColor);
begin Self.HintColor := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvAnimateHintColor_R(Self: TJvAnimate; var T: TColor);
begin T := Self.HintColor; end;

(*----------------------------------------------------------------------------*)
procedure TJvAnimateAboutJVCL_W(Self: TJvAnimate; const T: TJVCLAboutInfo);
begin Self.AboutJVCL := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvAnimateAboutJVCL_R(Self: TJvAnimate; var T: TJVCLAboutInfo);
begin T := Self.AboutJVCL; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJvAnimate(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJvAnimate) do begin
    RegisterConstructor(@TJvAnimate.Create, 'Create');
    RegisterMethod(@TJvAnimate.Destroy, 'Free');
     RegisterPropertyHelper(@TJvAnimateAboutJVCL_R,@TJvAnimateAboutJVCL_W,'AboutJVCL');
    RegisterPropertyHelper(@TJvAnimateHintColor_R,@TJvAnimateHintColor_W,'HintColor');
    RegisterPropertyHelper(@TJvAnimateOnMouseEnter_R,@TJvAnimateOnMouseEnter_W,'OnMouseEnter');
    RegisterPropertyHelper(@TJvAnimateOnMouseLeave_R,@TJvAnimateOnMouseLeave_W,'OnMouseLeave');
    RegisterPropertyHelper(@TJvAnimateOnParentColorChange_R,@TJvAnimateOnParentColorChange_W,'OnParentColorChange');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_JvAnimate(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TJvAnimate(CL);
end;

 
 
{ TPSImport_JvAnimate }
(*----------------------------------------------------------------------------*)
procedure TPSImport_JvAnimate.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_JvAnimate(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_JvAnimate.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_JvAnimate(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
