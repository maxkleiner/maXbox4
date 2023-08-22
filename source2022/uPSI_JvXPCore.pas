unit uPSI_JvXPCore;
{
   set some styles function ReplaceComponentReference  matrix metrik
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
  TPSImport_JvXPCore = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TJvXPGradient(CL: TPSPascalCompiler);
procedure SIRegister_TJvXPCustomStyleControl(CL: TPSPascalCompiler);
procedure SIRegister_TJvXPStyleManager(CL: TPSPascalCompiler);
procedure SIRegister_TJvXPStyle(CL: TPSPascalCompiler);
procedure SIRegister_TJvXPUnlimitedControl(CL: TPSPascalCompiler);
procedure SIRegister_TJvXPCustomControl(CL: TPSPascalCompiler);
procedure SIRegister_TJvXPWinControl(CL: TPSPascalCompiler);
procedure SIRegister_JvXPCore(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TJvXPGradient(CL: TPSRuntimeClassImporter);
procedure RIRegister_TJvXPCustomStyleControl(CL: TPSRuntimeClassImporter);
procedure RIRegister_TJvXPStyleManager(CL: TPSRuntimeClassImporter);
procedure RIRegister_TJvXPStyle(CL: TPSRuntimeClassImporter);
procedure RIRegister_TJvXPUnlimitedControl(CL: TPSRuntimeClassImporter);
procedure RIRegister_TJvXPCustomControl(CL: TPSRuntimeClassImporter);
procedure RIRegister_TJvXPWinControl(CL: TPSRuntimeClassImporter);
procedure RIRegister_JvXPCore(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
  // JclUnitVersioning
  //,Windows
  //Controls
  Graphics
  ,Forms
  //,Messages
  ,JvComponentBase
  ,JvComponent
  ,JvXPCore
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_JvXPCore]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TJvXPGradient(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TPersistent', 'TJvXPGradient') do
  with CL.AddClassN(CL.FindClass('TPersistent'),'TJvXPGradient') do begin
    RegisterProperty('Bitmap', 'TBitmap', iptrw);
    RegisterMethod('Constructor Create( AOwner : TControl)');
      RegisterMethod('Procedure Free');
     RegisterMethod('Procedure RecreateBands');
    RegisterProperty('Dithered', 'Boolean', iptrw);
    RegisterProperty('Colors', 'TJvXPGradientColors', iptrw);
    RegisterProperty('Enabled', 'Boolean', iptrw);
    RegisterProperty('EndColor', 'TColor', iptrw);
    RegisterProperty('StartColor', 'TColor', iptrw);
    RegisterProperty('Style', 'TJvXPGradientStyle', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TJvXPCustomStyleControl(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TJvXPCustomControl', 'TJvXPCustomStyleControl') do
  with CL.AddClassN(CL.FindClass('TJvXPCustomControl'),'TJvXPCustomStyleControl') do begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
      RegisterMethod('Procedure Free');
   end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TJvXPStyleManager(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TJvXPCustomComponent', 'TJvXPStyleManager') do
  with CL.AddClassN(CL.FindClass('TJvXPCustomComponent'),'TJvXPStyleManager') do begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
   RegisterMethod('Procedure Free');
     RegisterMethod('Procedure RegisterControls( const AControls : array of TJvXPCustomControl)');
    RegisterMethod('Procedure UnregisterControls( const AControls : array of TJvXPCustomControl)');
    RegisterProperty('Theme', 'TJvXPTheme', iptrw);
    RegisterProperty('OnThemeChanged', 'TNotifyEvent', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TJvXPStyle(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TPersistent', 'TJvXPStyle') do
  with CL.AddClassN(CL.FindClass('TPersistent'),'TJvXPStyle') do begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
   RegisterMethod('Procedure Free');
     RegisterMethod('Function GetTheme : TJvXPTheme');
    RegisterProperty('Theme', 'TJvXPTheme', iptrw);
    RegisterProperty('UseStyleManager', 'Boolean', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TJvXPUnlimitedControl(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TJvXPCustomControl', 'TJvXPUnlimitedControl') do
  with CL.AddClassN(CL.FindClass('TJvXPCustomControl'),'TJvXPUnlimitedControl') do begin
   RegisterPublishedProperties;
   RegisterProperty('ALIGN', 'TALIGN', iptrw);
     RegisterProperty('ALIGNMENT', 'TAlignment', iptrw);
    RegisterProperty('BORDERSTYLE', 'TBorderStyle', iptrw);
    RegisterProperty('ShowButtons', 'Boolean', iptrw);
    RegisterProperty('BorderStyle', 'TBorderStyle', iptrw);
    RegisterProperty('ShowLines', 'Boolean', iptrw);
    RegisterProperty('ShowRoot', 'Boolean', iptrw);
    RegisterProperty('BORDERWIDTH', 'Integer', iptrw);
    RegisterProperty('COLOR', 'TColor', iptrw);
    RegisterProperty('FONT', 'TFont', iptrw);
    RegisterProperty('HIDESELECTION', 'Boolean', iptrw);
    RegisterProperty('MAXLENGTH', 'Integer', iptrw);
    RegisterProperty('PARENTCOLOR', 'Boolean', iptrw);
    RegisterProperty('PARENTFONT', 'Boolean', iptrw);
    RegisterProperty('READONLY', 'Boolean', iptrw);
    RegisterProperty('SCROLLBARS', 'TScrollStyle', iptrw);
    RegisterProperty('ONCHANGE', 'TNotifyEvent', iptrw);
    RegisterProperty('ONCLICK', 'TNotifyEvent', iptrw);
    RegisterProperty('ONDBLCLICK', 'TNotifyEvent', iptrw);
    RegisterProperty('ONENTER', 'TNotifyEvent', iptrw);
    RegisterProperty('ONEXIT', 'TNotifyEvent', iptrw);
    RegisterProperty('ONKEYDOWN', 'TKeyEvent', iptrw);
    RegisterProperty('ONKEYPRESS', 'TKeyPressEvent', iptrw);
    RegisterProperty('ONKEYUP', 'TKeyEvent', iptrw);
    RegisterProperty('ONMOUSEDOWN', 'TMouseEvent', iptrw);
    RegisterProperty('ONMOUSEMOVE', 'TMouseMoveEvent', iptrw);
    RegisterProperty('ONMOUSEUP', 'TMouseEvent', iptrw);
    RegisterProperty('CAPTION', 'String', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TJvXPCustomControl(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TJvCustomControl', 'TJvXPCustomControl') do
  with CL.AddClassN(CL.FindClass('TJvCustomControl'),'TJvXPCustomControl') do begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
   RegisterMethod('Procedure Free');
     RegisterProperty('DrawState', 'TJvXPDrawState', iptrw);
    RegisterProperty('IsLocked', 'Boolean', iptr);
    RegisterProperty('IsSibling', 'Boolean', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TJvXPWinControl(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TJvWinControl', 'TJvXPWinControl') do
  with CL.AddClassN(CL.FindClass('TJvWinControl'),'TJvXPWinControl') do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_JvXPCore(CL: TPSPascalCompiler);
begin
 CL.AddConstantN('dxColor_Btn_Enb_Border_WXP','LongWord').SetUInt( TColor ( $00733800 ));
 CL.AddConstantN('dxColor_Btn_Dis_Border_WXP','LongWord').SetUInt( TColor ( $00BDC7CE ));
 CL.AddConstantN('dxColor_Btn_Enb_Edges_WXP','LongWord').SetUInt( TColor ( $00AD9E7B ));
 CL.AddConstantN('dxColor_Btn_Dis_Edges_WXP','LongWord').SetUInt( TColor ( $00BDC7CE ));
 CL.AddConstantN('dxColor_Btn_Enb_BgFrom_WXP','LongWord').SetUInt( TColor ( $00FFFFFF ));
 CL.AddConstantN('dxColor_Btn_Enb_BgTo_WXP','LongWord').SetUInt( TColor ( $00E7EBEF ));
 CL.AddConstantN('dxColor_Btn_Enb_CkFrom_WXP','LongWord').SetUInt( TColor ( $00C6CFD6 ));
 CL.AddConstantN('dxColor_Btn_Enb_CkTo_WXP','LongWord').SetUInt( TColor ( $00EBF3F7 ));
 CL.AddConstantN('dxColor_Btn_Enb_FcFrom_WXP','LongWord').SetUInt( TColor ( $00FFE7CE ));
 CL.AddConstantN('dxColor_Btn_Enb_FcTo_WXP','LongWord').SetUInt( TColor ( $00EF846D ));
 CL.AddConstantN('dxColor_Btn_Enb_HlFrom_WXP','LongWord').SetUInt( TColor ( $00CEF3FF ));
 CL.AddConstantN('dxColor_Btn_Enb_HlTo_WXP','LongWord').SetUInt( TColor ( $000096E7 ));
 CL.AddConstantN('dxColor_Chk_Enb_Border_WXP','LongWord').SetUInt( TColor ( $00845118 ));
 CL.AddConstantN('dxColor_Chk_Enb_NmSymb_WXP','LongWord').SetUInt( TColor ( $0021A621 ));
 CL.AddConstantN('dxColor_Chk_Enb_GraSymb_WXP','LongWord').SetUInt( TColor ( $0071C671 ));
 CL.AddConstantN('dxColor_Msc_Dis_Caption_WXP','LongWord').SetUInt( TColor ( $0094A6A5 ));
 CL.AddConstantN('dxColor_DotNetFrame','LongWord').SetUInt( TColor ( $00F7FBFF ));
 CL.AddConstantN('dxColor_BorderLineOXP','LongWord').SetUInt( TColor ( $00663300 ));
 CL.AddConstantN('dxColor_BgOXP','LongWord').SetUInt( TColor ( $00D6BEB5 ));
 CL.AddConstantN('dxColor_BgCkOXP','LongWord').SetUInt( TColor ( $00CC9999 ));
  CL.AddClassN(CL.FindClass('TOBJECT'),'TJvXPCustomStyleControl');
  CL.AddTypeS('TJvXPBoundLine', '( blLeft, blTop, blRight, blBottom )');
  CL.AddTypeS('TJvXPBoundLines', 'set of TJvXPBoundLine)');
  CL.AddTypeS('TJvXPControlStyle1', '( csRedrawCaptionChanged, csRedrawBo'
   +'rderChanged, csRedrawEnabledChanged, csRedrawFocusedChanged, csRedrawMouse'
   +'Down, csRedrawMouseEnter, csRedrawMouseLeave, csRedrawMouseMove, csRedrawM'
   +'ouseUp, csRedrawParentColorChanged, csRedrawParentFontChanged, csRedrawPos'
   +'Changed, csRedrawResized )');
  CL.AddTypeS('TJvXPDrawState1', '( dsDefault, dsHighlight, dsClicked, dsFocused )');
  CL.AddTypeS('TJvXPDrawState', 'set of TJvXPDrawState1');
  CL.AddTypeS('TJvXPControlStyle', 'set of TJvXPControlStyle1');
  //CL.AddTypeS('TJvXPDrawState', 'set of ( dsDefault, dsHighlight, dsClicked, dsFocused )');
  CL.AddTypeS('TJvXPGlyphLayout', '( glBottom, glCenter, glTop )');
  CL.AddTypeS('TJvXPTheme', '( WindowsXP, OfficeXP )');
  CL.AddClassN(CL.FindClass('TOBJECT'),'TJvXPCustomComponent');
  SIRegister_TJvXPWinControl(CL);
  SIRegister_TJvXPCustomControl(CL);
  SIRegister_TJvXPUnlimitedControl(CL);
  SIRegister_TJvXPStyle(CL);
  SIRegister_TJvXPStyleManager(CL);
  SIRegister_TJvXPCustomStyleControl(CL);
  CL.AddTypeS('TJvXPGradientColors', 'Integer');
  CL.AddTypeS('TJvXPGradientStyle', '( gsLeft, gsTop, gsRight, gsBottom )');
  SIRegister_TJvXPGradient(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TJvXPGradientStyle_W(Self: TJvXPGradient; const T: TJvXPGradientStyle);
begin Self.Style := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvXPGradientStyle_R(Self: TJvXPGradient; var T: TJvXPGradientStyle);
begin T := Self.Style; end;

(*----------------------------------------------------------------------------*)
procedure TJvXPGradientStartColor_W(Self: TJvXPGradient; const T: TColor);
begin Self.StartColor := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvXPGradientStartColor_R(Self: TJvXPGradient; var T: TColor);
begin T := Self.StartColor; end;

(*----------------------------------------------------------------------------*)
procedure TJvXPGradientEndColor_W(Self: TJvXPGradient; const T: TColor);
begin Self.EndColor := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvXPGradientEndColor_R(Self: TJvXPGradient; var T: TColor);
begin T := Self.EndColor; end;

(*----------------------------------------------------------------------------*)
procedure TJvXPGradientEnabled_W(Self: TJvXPGradient; const T: Boolean);
begin Self.Enabled := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvXPGradientEnabled_R(Self: TJvXPGradient; var T: Boolean);
begin T := Self.Enabled; end;

(*----------------------------------------------------------------------------*)
procedure TJvXPGradientColors_W(Self: TJvXPGradient; const T: TJvXPGradientColors);
begin Self.Colors := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvXPGradientColors_R(Self: TJvXPGradient; var T: TJvXPGradientColors);
begin T := Self.Colors; end;

(*----------------------------------------------------------------------------*)
procedure TJvXPGradientDithered_W(Self: TJvXPGradient; const T: Boolean);
begin Self.Dithered := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvXPGradientDithered_R(Self: TJvXPGradient; var T: Boolean);
begin T := Self.Dithered; end;

(*----------------------------------------------------------------------------*)
procedure TJvXPGradientBitmap_W(Self: TJvXPGradient; const T: TBitmap);
Begin Self.Bitmap := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvXPGradientBitmap_R(Self: TJvXPGradient; var T: TBitmap);
Begin T := Self.Bitmap; end;

(*----------------------------------------------------------------------------*)
procedure TJvXPStyleManagerOnThemeChanged_W(Self: TJvXPStyleManager; const T: TNotifyEvent);
begin Self.OnThemeChanged := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvXPStyleManagerOnThemeChanged_R(Self: TJvXPStyleManager; var T: TNotifyEvent);
begin T := Self.OnThemeChanged; end;

(*----------------------------------------------------------------------------*)
procedure TJvXPStyleManagerTheme_W(Self: TJvXPStyleManager; const T: TJvXPTheme);
begin Self.Theme := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvXPStyleManagerTheme_R(Self: TJvXPStyleManager; var T: TJvXPTheme);
begin T := Self.Theme; end;

(*----------------------------------------------------------------------------*)
procedure TJvXPStyleUseStyleManager_W(Self: TJvXPStyle; const T: Boolean);
begin Self.UseStyleManager := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvXPStyleUseStyleManager_R(Self: TJvXPStyle; var T: Boolean);
begin T := Self.UseStyleManager; end;

(*----------------------------------------------------------------------------*)
procedure TJvXPStyleTheme_W(Self: TJvXPStyle; const T: TJvXPTheme);
begin Self.Theme := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvXPStyleTheme_R(Self: TJvXPStyle; var T: TJvXPTheme);
begin T := Self.Theme; end;

(*----------------------------------------------------------------------------*)
procedure TJvXPCustomControlIsSibling_W(Self: TJvXPCustomControl; const T: Boolean);
begin Self.IsSibling := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvXPCustomControlIsSibling_R(Self: TJvXPCustomControl; var T: Boolean);
begin T := Self.IsSibling; end;

(*----------------------------------------------------------------------------*)
procedure TJvXPCustomControlIsLocked_R(Self: TJvXPCustomControl; var T: Boolean);
begin T := Self.IsLocked; end;

(*----------------------------------------------------------------------------*)
procedure TJvXPCustomControlDrawState_W(Self: TJvXPCustomControl; const T: TJvXPDrawState);
begin Self.DrawState := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvXPCustomControlDrawState_R(Self: TJvXPCustomControl; var T: TJvXPDrawState);
begin T := Self.DrawState; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJvXPGradient(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJvXPGradient) do begin
    RegisterPropertyHelper(@TJvXPGradientBitmap_R,@TJvXPGradientBitmap_W,'Bitmap');
    RegisterConstructor(@TJvXPGradient.Create, 'Create');
   RegisterMethod(@TJvXPGradient.Destroy, 'Free');
     RegisterVirtualMethod(@TJvXPGradient.RecreateBands, 'RecreateBands');
    RegisterPropertyHelper(@TJvXPGradientDithered_R,@TJvXPGradientDithered_W,'Dithered');
    RegisterPropertyHelper(@TJvXPGradientColors_R,@TJvXPGradientColors_W,'Colors');
    RegisterPropertyHelper(@TJvXPGradientEnabled_R,@TJvXPGradientEnabled_W,'Enabled');
    RegisterPropertyHelper(@TJvXPGradientEndColor_R,@TJvXPGradientEndColor_W,'EndColor');
    RegisterPropertyHelper(@TJvXPGradientStartColor_R,@TJvXPGradientStartColor_W,'StartColor');
    RegisterPropertyHelper(@TJvXPGradientStyle_R,@TJvXPGradientStyle_W,'Style');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJvXPCustomStyleControl(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJvXPCustomStyleControl) do begin
    RegisterConstructor(@TJvXPCustomStyleControl.Create, 'Create');
   RegisterMethod(@TJvXPCustomStyleControl.Destroy, 'Free');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJvXPStyleManager(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJvXPStyleManager) do begin
    RegisterConstructor(@TJvXPStyleManager.Create, 'Create');
     RegisterMethod(@TJvXPStyleManager.Destroy, 'Free');
   RegisterMethod(@TJvXPStyleManager.RegisterControls, 'RegisterControls');
    RegisterMethod(@TJvXPStyleManager.UnregisterControls, 'UnregisterControls');
    RegisterPropertyHelper(@TJvXPStyleManagerTheme_R,@TJvXPStyleManagerTheme_W,'Theme');
    RegisterPropertyHelper(@TJvXPStyleManagerOnThemeChanged_R,@TJvXPStyleManagerOnThemeChanged_W,'OnThemeChanged');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJvXPStyle(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJvXPStyle) do begin
    RegisterConstructor(@TJvXPStyle.Create, 'Create');
   RegisterMethod(@TJvXPStyle.Destroy, 'Free');
     RegisterMethod(@TJvXPStyle.GetTheme, 'GetTheme');
    RegisterPropertyHelper(@TJvXPStyleTheme_R,@TJvXPStyleTheme_W,'Theme');
    RegisterPropertyHelper(@TJvXPStyleUseStyleManager_R,@TJvXPStyleUseStyleManager_W,'UseStyleManager');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJvXPUnlimitedControl(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJvXPUnlimitedControl) do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJvXPCustomControl(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJvXPCustomControl) do begin
    RegisterConstructor(@TJvXPCustomControl.Create, 'Create');
   RegisterMethod(@TJvXPCustomControl.Destroy, 'Free');
     RegisterPropertyHelper(@TJvXPCustomControlDrawState_R,@TJvXPCustomControlDrawState_W,'DrawState');
    RegisterPropertyHelper(@TJvXPCustomControlIsLocked_R,nil,'IsLocked');
    RegisterPropertyHelper(@TJvXPCustomControlIsSibling_R,@TJvXPCustomControlIsSibling_W,'IsSibling');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJvXPWinControl(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJvXPWinControl) do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_JvXPCore(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJvXPCustomStyleControl) do
  with CL.Add(TJvXPCustomComponent) do
  RIRegister_TJvXPWinControl(CL);
  RIRegister_TJvXPCustomControl(CL);
  RIRegister_TJvXPUnlimitedControl(CL);
  RIRegister_TJvXPStyle(CL);
  RIRegister_TJvXPStyleManager(CL);
  RIRegister_TJvXPCustomStyleControl(CL);
  RIRegister_TJvXPGradient(CL);
end;

 
 
{ TPSImport_JvXPCore }
(*----------------------------------------------------------------------------*)
procedure TPSImport_JvXPCore.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_JvXPCore(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_JvXPCore.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_JvXPCore(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
