unit uPSI_ColorGrd;
{
   from samples
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
  TPSImport_ColorGrd = class(TPSPlugin)
  public
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TColorGrid(CL: TPSPascalCompiler);
procedure SIRegister_ColorGrd(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TColorGrid(CL: TPSRuntimeClassImporter);
procedure RIRegister_ColorGrd(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
  // WinUtils
  Windows
  ,Messages
  ,Graphics
  ,Forms
  ,Controls
  ,ExtCtrls
  ,ColorGrd
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_ColorGrd]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TColorGrid(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TCustomControl', 'TColorGrid') do
  with CL.AddClassN(CL.FindClass('TCustomControl'),'TColorGrid') do begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
      RegisterMethod('Procedure Free');
       RegisterMethod('procedure SetBounds(ALeft, ATop, AWidth, AHeight: Integer);');
       RegisterMethod('Function ColorToIndex( AColor : TColor) : Integer');
    RegisterProperty('ForegroundColor', 'TColor', iptr);
    RegisterProperty('BackgroundColor', 'TColor', iptr);
    RegisterProperty('ClickEnablesColor', 'Boolean', iptrw);
    RegisterProperty('GridOrdering', 'TGridOrdering', iptrw);
    RegisterProperty('ForegroundIndex', 'Integer', iptrw);
    RegisterProperty('BackgroundIndex', 'Integer', iptrw);
    RegisterProperty('ForegroundEnabled', 'Boolean', iptrw);
    RegisterProperty('BackgroundEnabled', 'Boolean', iptrw);
    RegisterProperty('Selection', 'Integer', iptrw);
    RegisterProperty('OnChange', 'TNotifyEvent', iptrw);
    RegisterPublishedProperties;
   RegisterProperty('FONT', 'TFont', iptrw);
    RegisterProperty('PARENTCOLOR', 'Boolean', iptrw);
    RegisterProperty('PARENTFONT', 'Boolean', iptrw);
       RegisterProperty('Visible', 'Boolean', iptrw);
     RegisterProperty('Enabled', 'Boolean', iptrw);
     RegisterProperty('CTL3D', 'Boolean', iptrw);
     RegisterProperty('TabStop', 'Boolean', iptrw);
     RegisterProperty('CANVAS', 'TCanvas', iptrw);
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
procedure SIRegister_ColorGrd(CL: TPSPascalCompiler);
begin
 CL.AddConstantN('NumPaletteEntries','LongInt').SetInt( 20);
  CL.AddTypeS('TGridOrdering', '( go16x1, go8x2, go4x4, go2x8, go1x16 )');
  SIRegister_TColorGrid(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TColorGridOnChange_W(Self: TColorGrid; const T: TNotifyEvent);
begin Self.OnChange := T; end;

(*----------------------------------------------------------------------------*)
procedure TColorGridOnChange_R(Self: TColorGrid; var T: TNotifyEvent);
begin T := Self.OnChange; end;

(*----------------------------------------------------------------------------*)
procedure TColorGridSelection_W(Self: TColorGrid; const T: Integer);
begin Self.Selection := T; end;

(*----------------------------------------------------------------------------*)
procedure TColorGridSelection_R(Self: TColorGrid; var T: Integer);
begin T := Self.Selection; end;

(*----------------------------------------------------------------------------*)
procedure TColorGridBackgroundEnabled_W(Self: TColorGrid; const T: Boolean);
begin Self.BackgroundEnabled := T; end;

(*----------------------------------------------------------------------------*)
procedure TColorGridBackgroundEnabled_R(Self: TColorGrid; var T: Boolean);
begin T := Self.BackgroundEnabled; end;

(*----------------------------------------------------------------------------*)
procedure TColorGridForegroundEnabled_W(Self: TColorGrid; const T: Boolean);
begin Self.ForegroundEnabled := T; end;

(*----------------------------------------------------------------------------*)
procedure TColorGridForegroundEnabled_R(Self: TColorGrid; var T: Boolean);
begin T := Self.ForegroundEnabled; end;

(*----------------------------------------------------------------------------*)
procedure TColorGridBackgroundIndex_W(Self: TColorGrid; const T: Integer);
begin Self.BackgroundIndex := T; end;

(*----------------------------------------------------------------------------*)
procedure TColorGridBackgroundIndex_R(Self: TColorGrid; var T: Integer);
begin T := Self.BackgroundIndex; end;

(*----------------------------------------------------------------------------*)
procedure TColorGridForegroundIndex_W(Self: TColorGrid; const T: Integer);
begin Self.ForegroundIndex := T; end;

(*----------------------------------------------------------------------------*)
procedure TColorGridForegroundIndex_R(Self: TColorGrid; var T: Integer);
begin T := Self.ForegroundIndex; end;

(*----------------------------------------------------------------------------*)
procedure TColorGridGridOrdering_W(Self: TColorGrid; const T: TGridOrdering);
begin Self.GridOrdering := T; end;

(*----------------------------------------------------------------------------*)
procedure TColorGridGridOrdering_R(Self: TColorGrid; var T: TGridOrdering);
begin T := Self.GridOrdering; end;

(*----------------------------------------------------------------------------*)
procedure TColorGridClickEnablesColor_W(Self: TColorGrid; const T: Boolean);
begin Self.ClickEnablesColor := T; end;

(*----------------------------------------------------------------------------*)
procedure TColorGridClickEnablesColor_R(Self: TColorGrid; var T: Boolean);
begin T := Self.ClickEnablesColor; end;

(*----------------------------------------------------------------------------*)
procedure TColorGridBackgroundColor_R(Self: TColorGrid; var T: TColor);
begin T := Self.BackgroundColor; end;

(*----------------------------------------------------------------------------*)
procedure TColorGridForegroundColor_R(Self: TColorGrid; var T: TColor);
begin T := Self.ForegroundColor; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TColorGrid(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TColorGrid) do begin
    RegisterConstructor(@TColorGrid.Create, 'Create');
      RegisterMethod(@TColorGrid.Destroy, 'Free');
       RegisterMethod(@TColorGrid.SetBounds, 'SetBounds');
       RegisterMethod(@TColorGrid.ColorToIndex, 'ColorToIndex');
    RegisterPropertyHelper(@TColorGridForegroundColor_R,nil,'ForegroundColor');
    RegisterPropertyHelper(@TColorGridBackgroundColor_R,nil,'BackgroundColor');
    RegisterPropertyHelper(@TColorGridClickEnablesColor_R,@TColorGridClickEnablesColor_W,'ClickEnablesColor');
    RegisterPropertyHelper(@TColorGridGridOrdering_R,@TColorGridGridOrdering_W,'GridOrdering');
    RegisterPropertyHelper(@TColorGridForegroundIndex_R,@TColorGridForegroundIndex_W,'ForegroundIndex');
    RegisterPropertyHelper(@TColorGridBackgroundIndex_R,@TColorGridBackgroundIndex_W,'BackgroundIndex');
    RegisterPropertyHelper(@TColorGridForegroundEnabled_R,@TColorGridForegroundEnabled_W,'ForegroundEnabled');
    RegisterPropertyHelper(@TColorGridBackgroundEnabled_R,@TColorGridBackgroundEnabled_W,'BackgroundEnabled');
    RegisterPropertyHelper(@TColorGridSelection_R,@TColorGridSelection_W,'Selection');
    RegisterPropertyHelper(@TColorGridOnChange_R,@TColorGridOnChange_W,'OnChange');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_ColorGrd(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TColorGrid(CL);
end;

 
 
{ TPSImport_ColorGrd }
(*----------------------------------------------------------------------------*)
procedure TPSImport_ColorGrd.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_ColorGrd(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_ColorGrd.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_ColorGrd(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
