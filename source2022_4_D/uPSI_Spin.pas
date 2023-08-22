unit uPSI_Spin;
{
   for 3d lab!
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
  TPSImport_Spin = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TTimerSpeedButton(CL: TPSPascalCompiler);
procedure SIRegister_TSpinEdit(CL: TPSPascalCompiler);
procedure SIRegister_TSpinButton(CL: TPSPascalCompiler);
procedure SIRegister_Spin(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TTimerSpeedButton(CL: TPSRuntimeClassImporter);
procedure RIRegister_TSpinEdit(CL: TPSRuntimeClassImporter);
procedure RIRegister_TSpinButton(CL: TPSRuntimeClassImporter);
procedure RIRegister_Spin(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   Windows
  ,StdCtrls
  ,ExtCtrls
  ,Controls
  ,Messages
  ,Forms
  ,Graphics
  ,Menus
  ,Buttons
  ,Spin
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_Spin]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TTimerSpeedButton(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TSpeedButton', 'TTimerSpeedButton') do
  with CL.AddClassN(CL.FindClass('TSpeedButton'),'TTimerSpeedButton') do begin
     RegisterMethod('Procedure Free');
     RegisterProperty('TimeBtnState', 'TTimeBtnState', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TSpinEdit(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TCustomEdit', 'TSpinEdit') do
  with CL.AddClassN(CL.FindClass('TCustomEdit'),'TSpinEdit') do begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
       RegisterMethod('Procedure Free');
       RegisterProperty('Button', 'TSpinButton', iptr);
    RegisterProperty('EditorEnabled', 'Boolean', iptrw);
    RegisterProperty('Increment', 'LongInt', iptrw);
    RegisterProperty('MaxValue', 'LongInt', iptrw);
    RegisterProperty('MinValue', 'LongInt', iptrw);
    RegisterProperty('Value', 'LongInt', iptrw);
    RegisterpublishedProperties;
    RegisterProperty('ALIGNMENT', 'TALIGNMENT', iptrw);
    RegisterProperty('CAPTION', 'String', iptrw);
    RegisterProperty('CHECKED', 'BOOLEAN', iptrw);
    RegisterProperty('COLOR', 'TColor', iptrw);
    RegisterProperty('CANVAS', 'TCanvas', iptrw);
    RegisterProperty('FONT', 'TFont', iptrw);
    RegisterProperty('PARENTCOLOR', 'Boolean', iptrw);
    RegisterProperty('PARENTFONT', 'Boolean', iptrw);
     RegisterProperty('CTL3D', 'Boolean', iptrw);
    RegisterProperty('OnChange', 'TNotifyEvent', iptrw);
    RegisterProperty('ONCLICK', 'TNotifyEvent', iptrw);
    RegisterProperty('ONDBLCLICK', 'TNotifyEvent', iptrw);
    RegisterProperty('ONENTER', 'TNotifyEvent', iptrw);
    RegisterProperty('ONEXIT', 'TNotifyEvent', iptrw);
     end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TSpinButton(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TWinControl', 'TSpinButton') do
  with CL.AddClassN(CL.FindClass('TWinControl'),'TSpinButton') do
  begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
    RegisterMethod('Procedure SetBounds( ALeft, ATop, AWidth, AHeight : Integer)');
    RegisterProperty('DownGlyph', 'TBitmap', iptrw);
    RegisterProperty('DownNumGlyphs', 'TNumGlyphs', iptrw);
    RegisterProperty('FocusControl', 'TWinControl', iptrw);
    RegisterProperty('UpGlyph', 'TBitmap', iptrw);
    RegisterProperty('UpNumGlyphs', 'TNumGlyphs', iptrw);
    RegisterProperty('OnDownClick', 'TNotifyEvent', iptrw);
    RegisterProperty('OnUpClick', 'TNotifyEvent', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_Spin(CL: TPSPascalCompiler);
begin
 //CL.AddConstantN('InitRepeatPause','LongInt').SetInt( 400);
 //CL.AddConstantN('RepeatPause','LongInt').SetInt( 100);
  CL.AddClassN(CL.FindClass('TOBJECT'),'TTimerSpeedButton');
  SIRegister_TSpinButton(CL);
  SIRegister_TSpinEdit(CL);
  CL.AddTypeS('TTimeBtnStates', '(tbFocusRect, tbAllowTimer )');
  CL.AddTypeS('TTimeBtnState', 'set of TTimeBtnStates');
  SIRegister_TTimerSpeedButton(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TTimerSpeedButtonTimeBtnState_W(Self: TTimerSpeedButton; const T: TTimeBtnState);
begin Self.TimeBtnState := T; end;

(*----------------------------------------------------------------------------*)
procedure TTimerSpeedButtonTimeBtnState_R(Self: TTimerSpeedButton; var T: TTimeBtnState);
begin T := Self.TimeBtnState; end;

(*----------------------------------------------------------------------------*)
procedure TSpinEditValue_W(Self: TSpinEdit; const T: LongInt);
begin Self.Value := T; end;

(*----------------------------------------------------------------------------*)
procedure TSpinEditValue_R(Self: TSpinEdit; var T: LongInt);
begin T := Self.Value; end;

(*----------------------------------------------------------------------------*)
procedure TSpinEditMinValue_W(Self: TSpinEdit; const T: LongInt);
begin Self.MinValue := T; end;

(*----------------------------------------------------------------------------*)
procedure TSpinEditMinValue_R(Self: TSpinEdit; var T: LongInt);
begin T := Self.MinValue; end;

(*----------------------------------------------------------------------------*)
procedure TSpinEditMaxValue_W(Self: TSpinEdit; const T: LongInt);
begin Self.MaxValue := T; end;

(*----------------------------------------------------------------------------*)
procedure TSpinEditMaxValue_R(Self: TSpinEdit; var T: LongInt);
begin T := Self.MaxValue; end;

(*----------------------------------------------------------------------------*)
procedure TSpinEditIncrement_W(Self: TSpinEdit; const T: LongInt);
begin Self.Increment := T; end;

(*----------------------------------------------------------------------------*)
procedure TSpinEditIncrement_R(Self: TSpinEdit; var T: LongInt);
begin T := Self.Increment; end;

(*----------------------------------------------------------------------------*)
procedure TSpinEditEditorEnabled_W(Self: TSpinEdit; const T: Boolean);
begin Self.EditorEnabled := T; end;

(*----------------------------------------------------------------------------*)
procedure TSpinEditEditorEnabled_R(Self: TSpinEdit; var T: Boolean);
begin T := Self.EditorEnabled; end;

(*----------------------------------------------------------------------------*)
procedure TSpinEditButton_R(Self: TSpinEdit; var T: TSpinButton);
begin T := Self.Button; end;

(*----------------------------------------------------------------------------*)
procedure TSpinButtonOnUpClick_W(Self: TSpinButton; const T: TNotifyEvent);
begin Self.OnUpClick := T; end;

(*----------------------------------------------------------------------------*)
procedure TSpinButtonOnUpClick_R(Self: TSpinButton; var T: TNotifyEvent);
begin T := Self.OnUpClick; end;

(*----------------------------------------------------------------------------*)
procedure TSpinButtonOnDownClick_W(Self: TSpinButton; const T: TNotifyEvent);
begin Self.OnDownClick := T; end;

(*----------------------------------------------------------------------------*)
procedure TSpinButtonOnDownClick_R(Self: TSpinButton; var T: TNotifyEvent);
begin T := Self.OnDownClick; end;

(*----------------------------------------------------------------------------*)
procedure TSpinButtonUpNumGlyphs_W(Self: TSpinButton; const T: TNumGlyphs);
begin Self.UpNumGlyphs := T; end;

(*----------------------------------------------------------------------------*)
procedure TSpinButtonUpNumGlyphs_R(Self: TSpinButton; var T: TNumGlyphs);
begin T := Self.UpNumGlyphs; end;

(*----------------------------------------------------------------------------*)
procedure TSpinButtonUpGlyph_W(Self: TSpinButton; const T: TBitmap);
begin Self.UpGlyph := T; end;

(*----------------------------------------------------------------------------*)
procedure TSpinButtonUpGlyph_R(Self: TSpinButton; var T: TBitmap);
begin T := Self.UpGlyph; end;

(*----------------------------------------------------------------------------*)
procedure TSpinButtonFocusControl_W(Self: TSpinButton; const T: TWinControl);
begin Self.FocusControl := T; end;

(*----------------------------------------------------------------------------*)
procedure TSpinButtonFocusControl_R(Self: TSpinButton; var T: TWinControl);
begin T := Self.FocusControl; end;

(*----------------------------------------------------------------------------*)
procedure TSpinButtonDownNumGlyphs_W(Self: TSpinButton; const T: TNumGlyphs);
begin Self.DownNumGlyphs := T; end;

(*----------------------------------------------------------------------------*)
procedure TSpinButtonDownNumGlyphs_R(Self: TSpinButton; var T: TNumGlyphs);
begin T := Self.DownNumGlyphs; end;

(*----------------------------------------------------------------------------*)
procedure TSpinButtonDownGlyph_W(Self: TSpinButton; const T: TBitmap);
begin Self.DownGlyph := T; end;

(*----------------------------------------------------------------------------*)
procedure TSpinButtonDownGlyph_R(Self: TSpinButton; var T: TBitmap);
begin T := Self.DownGlyph; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TTimerSpeedButton(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TTimerSpeedButton) do begin
    RegisterPropertyHelper(@TTimerSpeedButtonTimeBtnState_R,@TTimerSpeedButtonTimeBtnState_W,'TimeBtnState');
        RegisterMethod(@TTimerSpeedButton.Destroy, 'Free');
   end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TSpinEdit(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TSpinEdit) do begin
    RegisterConstructor(@TSpinEdit.Create, 'Create');
        RegisterMethod(@TSpinEdit.Destroy, 'Free');
     RegisterPropertyHelper(@TSpinEditButton_R,nil,'Button');
    RegisterPropertyHelper(@TSpinEditEditorEnabled_R,@TSpinEditEditorEnabled_W,'EditorEnabled');
    RegisterPropertyHelper(@TSpinEditIncrement_R,@TSpinEditIncrement_W,'Increment');
    RegisterPropertyHelper(@TSpinEditMaxValue_R,@TSpinEditMaxValue_W,'MaxValue');
    RegisterPropertyHelper(@TSpinEditMinValue_R,@TSpinEditMinValue_W,'MinValue');
    RegisterPropertyHelper(@TSpinEditValue_R,@TSpinEditValue_W,'Value');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TSpinButton(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TSpinButton) do
  begin
    RegisterConstructor(@TSpinButton.Create, 'Create');
    RegisterMethod(@TSpinButton.SetBounds, 'SetBounds');
    RegisterPropertyHelper(@TSpinButtonDownGlyph_R,@TSpinButtonDownGlyph_W,'DownGlyph');
    RegisterPropertyHelper(@TSpinButtonDownNumGlyphs_R,@TSpinButtonDownNumGlyphs_W,'DownNumGlyphs');
    RegisterPropertyHelper(@TSpinButtonFocusControl_R,@TSpinButtonFocusControl_W,'FocusControl');
    RegisterPropertyHelper(@TSpinButtonUpGlyph_R,@TSpinButtonUpGlyph_W,'UpGlyph');
    RegisterPropertyHelper(@TSpinButtonUpNumGlyphs_R,@TSpinButtonUpNumGlyphs_W,'UpNumGlyphs');
    RegisterPropertyHelper(@TSpinButtonOnDownClick_R,@TSpinButtonOnDownClick_W,'OnDownClick');
    RegisterPropertyHelper(@TSpinButtonOnUpClick_R,@TSpinButtonOnUpClick_W,'OnUpClick');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_Spin(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TTimerSpeedButton) do
  RIRegister_TSpinButton(CL);
  RIRegister_TSpinEdit(CL);
  RIRegister_TTimerSpeedButton(CL);
end;

 
 
{ TPSImport_Spin }
(*----------------------------------------------------------------------------*)
procedure TPSImport_Spin.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_Spin(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_Spin.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_Spin(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
