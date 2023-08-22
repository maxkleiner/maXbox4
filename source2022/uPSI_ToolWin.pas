unit uPSI_ToolWin;
{

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
  TPSImport_ToolWin = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TToolDockForm(CL: TPSPascalCompiler);
procedure SIRegister_TToolDockObject(CL: TPSPascalCompiler);
procedure SIRegister_TToolWindow(CL: TPSPascalCompiler);
procedure SIRegister_ToolWin(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TToolDockForm(CL: TPSRuntimeClassImporter);
procedure RIRegister_TToolDockObject(CL: TPSRuntimeClassImporter);
procedure RIRegister_TToolWindow(CL: TPSRuntimeClassImporter);
procedure RIRegister_ToolWin(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   //WinUtils
  Windows
  ,Messages
  ,Controls
  ,Forms
  ,ToolWin
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_ToolWin]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TToolDockForm(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TCustomDockForm', 'TToolDockForm') do
  with CL.AddClassN(CL.FindClass('TCustomDockForm'),'TToolDockForm') do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TToolDockObject(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TDragDockObject', 'TToolDockObject') do
  with CL.AddClassN(CL.FindClass('TDragDockObject'),'TToolDockObject') do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TToolWindow(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TWinControl', 'TToolWindow') do
  with CL.AddClassN(CL.FindClass('TWinControl'),'TToolWindow') do begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
    RegisterProperty('EdgeBorders', 'TEdgeBorders', iptrw);
    RegisterProperty('EdgeInner', 'TEdgeStyle', iptrw);
    RegisterProperty('EdgeOuter', 'TEdgeStyle', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_ToolWin(CL: TPSPascalCompiler);
begin
  CL.AddTypeS('TEdgeBorder', '( ebLeft, ebTop, ebRight, ebBottom )');
  CL.AddTypeS('TEdgeBorders', 'set of TEdgeBorder');
  CL.AddTypeS('TEdgeStyle', '( esNone, esRaised, esLowered )');
  SIRegister_TToolWindow(CL);
  SIRegister_TToolDockObject(CL);
  CL.AddTypeS('TSizingOrientation', '( soNone, soHorizontal, soVertical )');
  SIRegister_TToolDockForm(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TToolWindowEdgeOuter_W(Self: TToolWindow; const T: TEdgeStyle);
begin Self.EdgeOuter := T; end;

(*----------------------------------------------------------------------------*)
procedure TToolWindowEdgeOuter_R(Self: TToolWindow; var T: TEdgeStyle);
begin T := Self.EdgeOuter; end;

(*----------------------------------------------------------------------------*)
procedure TToolWindowEdgeInner_W(Self: TToolWindow; const T: TEdgeStyle);
begin Self.EdgeInner := T; end;

(*----------------------------------------------------------------------------*)
procedure TToolWindowEdgeInner_R(Self: TToolWindow; var T: TEdgeStyle);
begin T := Self.EdgeInner; end;

(*----------------------------------------------------------------------------*)
procedure TToolWindowEdgeBorders_W(Self: TToolWindow; const T: TEdgeBorders);
begin Self.EdgeBorders := T; end;

(*----------------------------------------------------------------------------*)
procedure TToolWindowEdgeBorders_R(Self: TToolWindow; var T: TEdgeBorders);
begin T := Self.EdgeBorders; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TToolDockForm(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TToolDockForm) do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TToolDockObject(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TToolDockObject) do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TToolWindow(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TToolWindow) do
  begin
    RegisterConstructor(@TToolWindow.Create, 'Create');
    RegisterPropertyHelper(@TToolWindowEdgeBorders_R,@TToolWindowEdgeBorders_W,'EdgeBorders');
    RegisterPropertyHelper(@TToolWindowEdgeInner_R,@TToolWindowEdgeInner_W,'EdgeInner');
    RegisterPropertyHelper(@TToolWindowEdgeOuter_R,@TToolWindowEdgeOuter_W,'EdgeOuter');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_ToolWin(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TToolWindow(CL);
  RIRegister_TToolDockObject(CL);
  RIRegister_TToolDockForm(CL);
end;

 
 
{ TPSImport_ToolWin }
(*----------------------------------------------------------------------------*)
procedure TPSImport_ToolWin.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_ToolWin(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_ToolWin.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_ToolWin(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
