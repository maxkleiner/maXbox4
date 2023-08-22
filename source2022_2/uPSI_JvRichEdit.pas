unit uPSI_JvRichEdit;
{
  for text analysis
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
  TPSImport_JvRichEdit = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TJvRichEdit(CL: TPSPascalCompiler);
procedure SIRegister_JvRichEdit(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TJvRichEdit(CL: TPSRuntimeClassImporter);
procedure RIRegister_JvRichEdit(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   Messages
  ,Graphics
  ,Controls
  ,Forms
  ,ComCtrls
  ,JvTypes
  ,JVCLVer
  ,JvRichEdit
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_JvRichEdit]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TJvRichEdit(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TRichEdit', 'TJvRichEdit') do
  with CL.AddClassN(CL.FindClass('TRichEdit'),'TJvRichEdit') do begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
    RegisterProperty('AboutJVCL', 'TJVCLAboutInfo', iptrw);
    RegisterProperty('HintColor', 'TColor', iptrw);
    RegisterProperty('OnMouseEnter', 'TNotifyEvent', iptrw);
    RegisterProperty('OnMouseLeave', 'TNotifyEvent', iptrw);
    RegisterProperty('OnCtl3DChanged', 'TNotifyEvent', iptrw);
    RegisterProperty('OnParentColorChange', 'TNotifyEvent', iptrw);
    RegisterProperty('OnVerticalScroll', 'TNotifyEvent', iptrw);
    RegisterProperty('OnHorizontalScroll', 'TNotifyEvent', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_JvRichEdit(CL: TPSPascalCompiler);
begin
  SIRegister_TJvRichEdit(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TJvRichEditOnHorizontalScroll_W(Self: TJvRichEdit; const T: TNotifyEvent);
begin Self.OnHorizontalScroll := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvRichEditOnHorizontalScroll_R(Self: TJvRichEdit; var T: TNotifyEvent);
begin T := Self.OnHorizontalScroll; end;

(*----------------------------------------------------------------------------*)
procedure TJvRichEditOnVerticalScroll_W(Self: TJvRichEdit; const T: TNotifyEvent);
begin Self.OnVerticalScroll := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvRichEditOnVerticalScroll_R(Self: TJvRichEdit; var T: TNotifyEvent);
begin T := Self.OnVerticalScroll; end;

(*----------------------------------------------------------------------------*)
procedure TJvRichEditOnParentColorChange_W(Self: TJvRichEdit; const T: TNotifyEvent);
begin Self.OnParentColorChange := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvRichEditOnParentColorChange_R(Self: TJvRichEdit; var T: TNotifyEvent);
begin T := Self.OnParentColorChange; end;

(*----------------------------------------------------------------------------*)
procedure TJvRichEditOnCtl3DChanged_W(Self: TJvRichEdit; const T: TNotifyEvent);
begin Self.OnCtl3DChanged := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvRichEditOnCtl3DChanged_R(Self: TJvRichEdit; var T: TNotifyEvent);
begin T := Self.OnCtl3DChanged; end;

(*----------------------------------------------------------------------------*)
procedure TJvRichEditOnMouseLeave_W(Self: TJvRichEdit; const T: TNotifyEvent);
begin Self.OnMouseLeave := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvRichEditOnMouseLeave_R(Self: TJvRichEdit; var T: TNotifyEvent);
begin T := Self.OnMouseLeave; end;

(*----------------------------------------------------------------------------*)
procedure TJvRichEditOnMouseEnter_W(Self: TJvRichEdit; const T: TNotifyEvent);
begin Self.OnMouseEnter := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvRichEditOnMouseEnter_R(Self: TJvRichEdit; var T: TNotifyEvent);
begin T := Self.OnMouseEnter; end;

(*----------------------------------------------------------------------------*)
procedure TJvRichEditHintColor_W(Self: TJvRichEdit; const T: TColor);
begin Self.HintColor := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvRichEditHintColor_R(Self: TJvRichEdit; var T: TColor);
begin T := Self.HintColor; end;

(*----------------------------------------------------------------------------*)
procedure TJvRichEditAboutJVCL_W(Self: TJvRichEdit; const T: TJVCLAboutInfo);
begin Self.AboutJVCL := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvRichEditAboutJVCL_R(Self: TJvRichEdit; var T: TJVCLAboutInfo);
begin T := Self.AboutJVCL; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJvRichEdit(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJvRichEdit) do
  begin
    RegisterConstructor(@TJvRichEdit.Create, 'Create');
    RegisterPropertyHelper(@TJvRichEditAboutJVCL_R,@TJvRichEditAboutJVCL_W,'AboutJVCL');
    RegisterPropertyHelper(@TJvRichEditHintColor_R,@TJvRichEditHintColor_W,'HintColor');
    RegisterPropertyHelper(@TJvRichEditOnMouseEnter_R,@TJvRichEditOnMouseEnter_W,'OnMouseEnter');
    RegisterPropertyHelper(@TJvRichEditOnMouseLeave_R,@TJvRichEditOnMouseLeave_W,'OnMouseLeave');
    RegisterPropertyHelper(@TJvRichEditOnCtl3DChanged_R,@TJvRichEditOnCtl3DChanged_W,'OnCtl3DChanged');
    RegisterPropertyHelper(@TJvRichEditOnParentColorChange_R,@TJvRichEditOnParentColorChange_W,'OnParentColorChange');
    RegisterPropertyHelper(@TJvRichEditOnVerticalScroll_R,@TJvRichEditOnVerticalScroll_W,'OnVerticalScroll');
    RegisterPropertyHelper(@TJvRichEditOnHorizontalScroll_R,@TJvRichEditOnHorizontalScroll_W,'OnHorizontalScroll');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_JvRichEdit(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TJvRichEdit(CL);
end;

 
 
{ TPSImport_JvRichEdit }
(*----------------------------------------------------------------------------*)
procedure TPSImport_JvRichEdit.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_JvRichEdit(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_JvRichEdit.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_JvRichEdit(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
