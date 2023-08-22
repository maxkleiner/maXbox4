unit uPSI_JvSwitch;
{
  control switch
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
  TPSImport_JvSwitch = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TJvSwitch(CL: TPSPascalCompiler);
procedure SIRegister_JvSwitch(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TJvSwitch(CL: TPSRuntimeClassImporter);
procedure RIRegister_JvSwitch(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   Windows
  ,WinTypes
  ,WinProcs
  ,Messages
  ,Graphics
  ,Controls
  ,Forms
  ,Menus
  ,JvSwitch
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_JvSwitch]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TJvSwitch(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TCustomControl', 'TJvSwitch') do
  with CL.AddClassN(CL.FindClass('TCustomControl'),'TJvSwitch') do begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
    RegisterMethod('Procedure ToggleSwitch');
    RegisterProperty('BorderStyle', 'TBorderStyle', iptrw);
    RegisterProperty('GlyphOff', 'TBitmap', iptrw);
    RegisterProperty('GlyphOn', 'TBitmap', iptrw);
    RegisterProperty('ShowFocus', 'Boolean', iptrw);
    RegisterProperty('ToggleKey', 'TShortCut', iptrw);
    RegisterProperty('StateOn', 'Boolean', iptrw);
    RegisterProperty('TextPosition', 'TTextPos', iptrw);
    RegisterProperty('OnOn', 'TNotifyEvent', iptrw);
    RegisterProperty('OnOff', 'TNotifyEvent', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_JvSwitch(CL: TPSPascalCompiler);
begin
  CL.AddTypeS('TTextPos', '( tpNone, tpLeft, tpRight, tpAbove, tpBelow )');
  CL.AddTypeS('TSwitchBitmaps', 'set of Boolean');
  SIRegister_TJvSwitch(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TJvSwitchOnOff_W(Self: TJvSwitch; const T: TNotifyEvent);
begin Self.OnOff := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvSwitchOnOff_R(Self: TJvSwitch; var T: TNotifyEvent);
begin T := Self.OnOff; end;

(*----------------------------------------------------------------------------*)
procedure TJvSwitchOnOn_W(Self: TJvSwitch; const T: TNotifyEvent);
begin Self.OnOn := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvSwitchOnOn_R(Self: TJvSwitch; var T: TNotifyEvent);
begin T := Self.OnOn; end;

(*----------------------------------------------------------------------------*)
procedure TJvSwitchTextPosition_W(Self: TJvSwitch; const T: TTextPos);
begin Self.TextPosition := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvSwitchTextPosition_R(Self: TJvSwitch; var T: TTextPos);
begin T := Self.TextPosition; end;

(*----------------------------------------------------------------------------*)
procedure TJvSwitchStateOn_W(Self: TJvSwitch; const T: Boolean);
begin Self.StateOn := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvSwitchStateOn_R(Self: TJvSwitch; var T: Boolean);
begin T := Self.StateOn; end;

(*----------------------------------------------------------------------------*)
procedure TJvSwitchToggleKey_W(Self: TJvSwitch; const T: TShortCut);
begin Self.ToggleKey := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvSwitchToggleKey_R(Self: TJvSwitch; var T: TShortCut);
begin T := Self.ToggleKey; end;

(*----------------------------------------------------------------------------*)
procedure TJvSwitchShowFocus_W(Self: TJvSwitch; const T: Boolean);
begin Self.ShowFocus := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvSwitchShowFocus_R(Self: TJvSwitch; var T: Boolean);
begin T := Self.ShowFocus; end;

(*----------------------------------------------------------------------------*)
procedure TJvSwitchGlyphOn_W(Self: TJvSwitch; const T: TBitmap);
begin Self.GlyphOn := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvSwitchGlyphOn_R(Self: TJvSwitch; var T: TBitmap);
begin T := Self.GlyphOn; end;

(*----------------------------------------------------------------------------*)
procedure TJvSwitchGlyphOff_W(Self: TJvSwitch; const T: TBitmap);
begin Self.GlyphOff := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvSwitchGlyphOff_R(Self: TJvSwitch; var T: TBitmap);
begin T := Self.GlyphOff; end;

(*----------------------------------------------------------------------------*)
procedure TJvSwitchBorderStyle_W(Self: TJvSwitch; const T: TBorderStyle);
begin Self.BorderStyle := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvSwitchBorderStyle_R(Self: TJvSwitch; var T: TBorderStyle);
begin T := Self.BorderStyle; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJvSwitch(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJvSwitch) do begin
    RegisterConstructor(@TJvSwitch.Create, 'Create');
    RegisterMethod(@TJvSwitch.ToggleSwitch, 'ToggleSwitch');
    RegisterPropertyHelper(@TJvSwitchBorderStyle_R,@TJvSwitchBorderStyle_W,'BorderStyle');
    RegisterPropertyHelper(@TJvSwitchGlyphOff_R,@TJvSwitchGlyphOff_W,'GlyphOff');
    RegisterPropertyHelper(@TJvSwitchGlyphOn_R,@TJvSwitchGlyphOn_W,'GlyphOn');
    RegisterPropertyHelper(@TJvSwitchShowFocus_R,@TJvSwitchShowFocus_W,'ShowFocus');
    RegisterPropertyHelper(@TJvSwitchToggleKey_R,@TJvSwitchToggleKey_W,'ToggleKey');
    RegisterPropertyHelper(@TJvSwitchStateOn_R,@TJvSwitchStateOn_W,'StateOn');
    RegisterPropertyHelper(@TJvSwitchTextPosition_R,@TJvSwitchTextPosition_W,'TextPosition');
    RegisterPropertyHelper(@TJvSwitchOnOn_R,@TJvSwitchOnOn_W,'OnOn');
    RegisterPropertyHelper(@TJvSwitchOnOff_R,@TJvSwitchOnOff_W,'OnOff');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_JvSwitch(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TJvSwitch(CL);
end;

 
 
{ TPSImport_JvSwitch }
(*----------------------------------------------------------------------------*)
procedure TPSImport_JvSwitch.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_JvSwitch(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_JvSwitch.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_JvSwitch(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
