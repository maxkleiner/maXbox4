unit uPSI_CollPanl;
{
    another panel lenap
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
  TPSImport_CollPanl = class(TPSPlugin)
  public
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TCollapsePanel(CL: TPSPascalCompiler);
procedure SIRegister_THeaderPanel(CL: TPSPascalCompiler);
procedure SIRegister_CollPanl(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TCollapsePanel(CL: TPSRuntimeClassImporter);
procedure RIRegister_THeaderPanel(CL: TPSRuntimeClassImporter);
procedure RIRegister_CollPanl(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   Messages
  ,Controls
  ,StdCtrls
  ,ExtCtrls
  ,Graphics
  ,CollPanl
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_CollPanl]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TCollapsePanel(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TCustomPanel', 'TCollapsePanel') do
  with CL.AddClassN(CL.FindClass('TCustomPanel'),'TCollapsePanel') do begin
    RegisterProperty('Expanded', 'Boolean', iptr);
   RegisterMethod('Constructor Create( AOwner : TComponent)');
    RegisterMethod('Function GetHeaderCaption : string');
    RegisterMethod('Function GetHeaderHeight : Integer');
    RegisterMethod('Procedure SetHeaderCaption( const Value : string)');
    RegisterMethod('Procedure SetHeaderHeight( const Value : Integer)');
    RegisterProperty('ActiveHeaderColor', 'TColor', iptrw);
    RegisterProperty('HeaderCaption', 'string', iptrw);
    RegisterProperty('HeaderHeight', 'Integer', iptrw);
    RegisterProperty('InactiveHeaderColor', 'TColor', iptrw);
    RegisterProperty('Step', 'Integer', iptrw);
       RegisterPublishedProperties;
     RegisterProperty('ALIGNMENT', 'TALIGNMENT', iptrw);
     RegisterProperty('FONT', 'TFont', iptrw);
     RegisterProperty('Visible', 'Boolean', iptrw);
     RegisterProperty('Enabled', 'Boolean', iptrw);
   RegisterProperty('Color', 'TColor', iptrw);
   RegisterProperty('Caption', 'string', iptrw);
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
procedure SIRegister_THeaderPanel(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TComponent', 'THeaderPanel') do
  with CL.AddClassN(CL.FindClass('TComponent'),'THeaderPanel') do
  begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
    RegisterProperty('Caption', 'TCaption', iptrw);
    RegisterProperty('Height', 'Integer', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_CollPanl(CL: TPSPascalCompiler);
begin
  SIRegister_THeaderPanel(CL);
  SIRegister_TCollapsePanel(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TCollapsePanelStep_W(Self: TCollapsePanel; const T: Integer);
begin Self.Step := T; end;

(*----------------------------------------------------------------------------*)
procedure TCollapsePanelStep_R(Self: TCollapsePanel; var T: Integer);
begin T := Self.Step; end;

(*----------------------------------------------------------------------------*)
procedure TCollapsePanelInactiveHeaderColor_W(Self: TCollapsePanel; const T: TColor);
begin Self.InactiveHeaderColor := T; end;

(*----------------------------------------------------------------------------*)
procedure TCollapsePanelInactiveHeaderColor_R(Self: TCollapsePanel; var T: TColor);
begin T := Self.InactiveHeaderColor; end;

(*----------------------------------------------------------------------------*)
procedure TCollapsePanelHeaderHeight_W(Self: TCollapsePanel; const T: Integer);
begin Self.HeaderHeight := T; end;

(*----------------------------------------------------------------------------*)
procedure TCollapsePanelHeaderHeight_R(Self: TCollapsePanel; var T: Integer);
begin T := Self.HeaderHeight; end;

(*----------------------------------------------------------------------------*)
procedure TCollapsePanelHeaderCaption_W(Self: TCollapsePanel; const T: string);
begin Self.HeaderCaption := T; end;

(*----------------------------------------------------------------------------*)
procedure TCollapsePanelHeaderCaption_R(Self: TCollapsePanel; var T: string);
begin T := Self.HeaderCaption; end;

(*----------------------------------------------------------------------------*)
procedure TCollapsePanelActiveHeaderColor_W(Self: TCollapsePanel; const T: TColor);
begin Self.ActiveHeaderColor := T; end;

(*----------------------------------------------------------------------------*)
procedure TCollapsePanelActiveHeaderColor_R(Self: TCollapsePanel; var T: TColor);
begin T := Self.ActiveHeaderColor; end;

(*----------------------------------------------------------------------------*)
procedure TCollapsePanelExpanded_R(Self: TCollapsePanel; var T: Boolean);
begin T := Self.Expanded; end;

(*----------------------------------------------------------------------------*)
procedure THeaderPanelHeight_W(Self: THeaderPanel; const T: Integer);
begin Self.Height := T; end;

(*----------------------------------------------------------------------------*)
procedure THeaderPanelHeight_R(Self: THeaderPanel; var T: Integer);
begin T := Self.Height; end;

(*----------------------------------------------------------------------------*)
procedure THeaderPanelCaption_W(Self: THeaderPanel; const T: TCaption);
begin Self.Caption := T; end;

(*----------------------------------------------------------------------------*)
procedure THeaderPanelCaption_R(Self: THeaderPanel; var T: TCaption);
begin T := Self.Caption; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TCollapsePanel(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TCollapsePanel) do begin
     RegisterConstructor(@TCollapsePanel.Create, 'Create');
     RegisterPropertyHelper(@TCollapsePanelExpanded_R,nil,'Expanded');
    RegisterMethod(@TCollapsePanel.GetHeaderCaption, 'GetHeaderCaption');
    RegisterMethod(@TCollapsePanel.GetHeaderHeight, 'GetHeaderHeight');
    RegisterMethod(@TCollapsePanel.SetHeaderCaption, 'SetHeaderCaption');
    RegisterMethod(@TCollapsePanel.SetHeaderHeight, 'SetHeaderHeight');
    RegisterPropertyHelper(@TCollapsePanelActiveHeaderColor_R,@TCollapsePanelActiveHeaderColor_W,'ActiveHeaderColor');
    RegisterPropertyHelper(@TCollapsePanelHeaderCaption_R,@TCollapsePanelHeaderCaption_W,'HeaderCaption');
    RegisterPropertyHelper(@TCollapsePanelHeaderHeight_R,@TCollapsePanelHeaderHeight_W,'HeaderHeight');
    RegisterPropertyHelper(@TCollapsePanelInactiveHeaderColor_R,@TCollapsePanelInactiveHeaderColor_W,'InactiveHeaderColor');
    RegisterPropertyHelper(@TCollapsePanelStep_R,@TCollapsePanelStep_W,'Step');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_THeaderPanel(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(THeaderPanel) do
  begin
    RegisterConstructor(@THeaderPanel.Create, 'Create');
    RegisterPropertyHelper(@THeaderPanelCaption_R,@THeaderPanelCaption_W,'Caption');
    RegisterPropertyHelper(@THeaderPanelHeight_R,@THeaderPanelHeight_W,'Height');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_CollPanl(CL: TPSRuntimeClassImporter);
begin
  RIRegister_THeaderPanel(CL);
  RIRegister_TCollapsePanel(CL);
end;

 
 
{ TPSImport_CollPanl }
(*----------------------------------------------------------------------------*)
procedure TPSImport_CollPanl.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_CollPanl(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_CollPanl.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_CollPanl(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
