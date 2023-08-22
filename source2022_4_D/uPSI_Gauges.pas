unit uPSI_Gauges;
{
   samples
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
  TPSImport_Gauges = class(TPSPlugin)
  public
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TGauge(CL: TPSPascalCompiler);
procedure SIRegister_Gauges(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TGauge(CL: TPSRuntimeClassImporter);
procedure RIRegister_Gauges(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   Windows
  ,Messages
  ,Graphics
  ,Controls
  ,Forms
  ,StdCtrls
  ,Gauges
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_Gauges]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TGauge(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TGraphicControl', 'TGauge') do
  with CL.AddClassN(CL.FindClass('TGraphicControl'),'TGauge') do begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
    RegisterMethod('Procedure AddProgress( Value : Longint)');
    RegisterMethod('procedure SetBounds(ALeft, ATop, AWidth, AHeight: Integer);');
    RegisterProperty('PercentDone', 'Longint', iptr);
    RegisterProperty('BackColor', 'TColor', iptrw);
    RegisterProperty('BorderStyle', 'TBorderStyle', iptrw);
    RegisterProperty('ForeColor', 'TColor', iptrw);
    RegisterProperty('Kind', 'TGaugeKind', iptrw);
    RegisterProperty('MinValue', 'Longint', iptrw);
    RegisterProperty('MaxValue', 'Longint', iptrw);
    RegisterProperty('Progress', 'Longint', iptrw);
    RegisterProperty('ShowText', 'Boolean', iptrw);
     RegisterPublishedProperties;
     RegisterProperty('ALIGNMENT', 'TALIGNMENT', iptrw);
     RegisterProperty('FONT', 'TFont', iptrw);
     RegisterProperty('Visible', 'Boolean', iptrw);
     RegisterProperty('Enabled', 'Boolean', iptrw);
   RegisterProperty('Color', 'TColor', iptrw);
  // RegisterProperty('ForeColor', 'TColor', iptrw);
    RegisterProperty('PARENTCOLOR', 'Boolean', iptrw);
    RegisterProperty('PARENTFONT', 'Boolean', iptrw);
     RegisterProperty('CTL3D', 'Boolean', iptrw);
     RegisterProperty('CANVAS', 'TCanvas', iptrw);
     RegisterProperty('ItemHeight', 'Integer', iptrw);
    RegisterProperty('ONCLICK', 'TNotifyEvent', iptrw);
    RegisterProperty('ONDBLCLICK', 'TNotifyEvent', iptrw);
    RegisterProperty('ONENTER', 'TNotifyEvent', iptrw);
    RegisterProperty('ONEXIT', 'TNotifyEvent', iptrw);
  //  RegisterProperty('ONKEYDOWN', 'TKeyEvent', iptrw);
  //  RegisterProperty('ONKEYPRESS', 'TKeyPressEvent', iptrw);
  //  RegisterProperty('ONKEYUP', 'TKeyEvent', iptrw);
     RegisterProperty('ONMOUSEDOWN', 'TMouseEvent', iptrw);
    RegisterProperty('ONMOUSEMOVE', 'TMouseMoveEvent', iptrw);
    RegisterProperty('ONMOUSEUP', 'TMouseEvent', iptrw);
     RegisterProperty('ONKEYDOWN', 'TKeyEvent', iptrw);
    RegisterProperty('ONKEYPRESS', 'TKeyPressEvent', iptrw);
    RegisterProperty('ONKEYUP', 'TKeyEvent', iptrw);

  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_Gauges(CL: TPSPascalCompiler);
begin
  CL.AddTypeS('TGaugeKind', '(gkText, gkHorizontalBar, gkVerticalBar, gkPie, gkNeedle )');
  SIRegister_TGauge(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TGaugeShowText_W(Self: TGauge; const T: Boolean);
begin Self.ShowText := T; end;

(*----------------------------------------------------------------------------*)
procedure TGaugeShowText_R(Self: TGauge; var T: Boolean);
begin T := Self.ShowText; end;

(*----------------------------------------------------------------------------*)
procedure TGaugeProgress_W(Self: TGauge; const T: Longint);
begin Self.Progress := T; end;

(*----------------------------------------------------------------------------*)
procedure TGaugeProgress_R(Self: TGauge; var T: Longint);
begin T := Self.Progress; end;

(*----------------------------------------------------------------------------*)
procedure TGaugeMaxValue_W(Self: TGauge; const T: Longint);
begin Self.MaxValue := T; end;

(*----------------------------------------------------------------------------*)
procedure TGaugeMaxValue_R(Self: TGauge; var T: Longint);
begin T := Self.MaxValue; end;

(*----------------------------------------------------------------------------*)
procedure TGaugeMinValue_W(Self: TGauge; const T: Longint);
begin Self.MinValue := T; end;

(*----------------------------------------------------------------------------*)
procedure TGaugeMinValue_R(Self: TGauge; var T: Longint);
begin T := Self.MinValue; end;

(*----------------------------------------------------------------------------*)
procedure TGaugeKind_W(Self: TGauge; const T: TGaugeKind);
begin Self.Kind := T; end;

(*----------------------------------------------------------------------------*)
procedure TGaugeKind_R(Self: TGauge; var T: TGaugeKind);
begin T := Self.Kind; end;

(*----------------------------------------------------------------------------*)
procedure TGaugeForeColor_W(Self: TGauge; const T: TColor);
begin Self.ForeColor := T; end;

(*----------------------------------------------------------------------------*)
procedure TGaugeForeColor_R(Self: TGauge; var T: TColor);
begin T := Self.ForeColor; end;

(*----------------------------------------------------------------------------*)
procedure TGaugeBorderStyle_W(Self: TGauge; const T: TBorderStyle);
begin Self.BorderStyle := T; end;

(*----------------------------------------------------------------------------*)
procedure TGaugeBorderStyle_R(Self: TGauge; var T: TBorderStyle);
begin T := Self.BorderStyle; end;

(*----------------------------------------------------------------------------*)
procedure TGaugeBackColor_W(Self: TGauge; const T: TColor);
begin Self.BackColor := T; end;

(*----------------------------------------------------------------------------*)
procedure TGaugeBackColor_R(Self: TGauge; var T: TColor);
begin T := Self.BackColor; end;

(*----------------------------------------------------------------------------*)
procedure TGaugePercentDone_R(Self: TGauge; var T: Longint);
begin T := Self.PercentDone; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TGauge(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TGauge) do
  begin
    RegisterConstructor(@TGauge.Create, 'Create');
    RegisterMethod(@TGauge.AddProgress, 'AddProgress');
    RegisterMethod(@TGauge.SetBounds, 'SetBounds');
    RegisterPropertyHelper(@TGaugePercentDone_R,nil,'PercentDone');
    RegisterPropertyHelper(@TGaugeBackColor_R,@TGaugeBackColor_W,'BackColor');
    RegisterPropertyHelper(@TGaugeBorderStyle_R,@TGaugeBorderStyle_W,'BorderStyle');
    RegisterPropertyHelper(@TGaugeForeColor_R,@TGaugeForeColor_W,'ForeColor');
    RegisterPropertyHelper(@TGaugeKind_R,@TGaugeKind_W,'Kind');
    RegisterPropertyHelper(@TGaugeMinValue_R,@TGaugeMinValue_W,'MinValue');
    RegisterPropertyHelper(@TGaugeMaxValue_R,@TGaugeMaxValue_W,'MaxValue');
    RegisterPropertyHelper(@TGaugeProgress_R,@TGaugeProgress_W,'Progress');
    RegisterPropertyHelper(@TGaugeShowText_R,@TGaugeShowText_W,'ShowText');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_Gauges(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TGauge(CL);
end;

 
 
{ TPSImport_Gauges }
(*----------------------------------------------------------------------------*)
procedure TPSImport_Gauges.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_Gauges(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_Gauges.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_Gauges(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
