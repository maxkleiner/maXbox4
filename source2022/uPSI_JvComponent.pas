unit uPSI_JvComponent;
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
  TPSImport_JvComponent = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TJvMultiselectCheckListBox(CL: TPSPascalCompiler);
procedure SIRegister_TJvCustomMemo(CL: TPSPascalCompiler);
procedure SIRegister_TJvForm(CL: TPSPascalCompiler);
procedure SIRegister_TJvWinControl(CL: TPSPascalCompiler);
procedure SIRegister_TJvCustomControl(CL: TPSPascalCompiler);
procedure SIRegister_TJvCustomPanel(CL: TPSPascalCompiler);
procedure SIRegister_TJvGraphicControl(CL: TPSPascalCompiler);
procedure SIRegister_TJvComponent(CL: TPSPascalCompiler);
procedure SIRegister_JvComponent(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TJvMultiselectCheckListBox(CL: TPSRuntimeClassImporter);
procedure RIRegister_TJvCustomMemo(CL: TPSRuntimeClassImporter);
procedure RIRegister_TJvForm(CL: TPSRuntimeClassImporter);
procedure RIRegister_TJvWinControl(CL: TPSRuntimeClassImporter);
procedure RIRegister_TJvCustomControl(CL: TPSRuntimeClassImporter);
procedure RIRegister_TJvCustomPanel(CL: TPSRuntimeClassImporter);
procedure RIRegister_TJvGraphicControl(CL: TPSRuntimeClassImporter);
procedure RIRegister_TJvComponent(CL: TPSRuntimeClassImporter);
procedure RIRegister_JvComponent(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   Windows
  ,Graphics
  ,StdCtrls
  ,Controls
  ,ExtCtrls
  ,Forms
  ,CheckLst
  ,JVCLVer
  ,JvComponent
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_JvComponent]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TJvMultiselectCheckListBox(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TCheckListBox', 'TJvMultiselectCheckListBox') do
  with CL.AddClassN(CL.FindClass('TCheckListBox'),'TJvMultiselectCheckListBox') do
  begin
    RegisterProperty('AboutJVCL', 'TJVCLAboutInfo', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TJvCustomMemo(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TCustomMemo', 'TJvCustomMemo') do
  with CL.AddClassN(CL.FindClass('TCustomMemo'),'TJvCustomMemo') do
  begin
    RegisterProperty('AboutJVCL', 'TJVCLAboutInfo', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TJvForm(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TForm', 'TJvForm') do
  with CL.AddClassN(CL.FindClass('TForm'),'TJvForm') do
  begin
    RegisterProperty('AboutJVCL', 'TJVCLAboutInfo', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TJvWinControl(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TWinControl', 'TJvWinControl') do
  with CL.AddClassN(CL.FindClass('TWinControl'),'TJvWinControl') do
  begin
    RegisterProperty('AboutJVCL', 'TJVCLAboutInfo', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TJvCustomControl(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TCustomControl', 'TJvCustomControl') do
  with CL.AddClassN(CL.FindClass('TCustomControl'),'TJvCustomControl') do
  begin
    RegisterProperty('AboutJVCL', 'TJVCLAboutInfo', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TJvCustomPanel(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TCustomPanel', 'TJvCustomPanel') do
  with CL.AddClassN(CL.FindClass('TCustomPanel'),'TJvCustomPanel') do
  begin
    RegisterProperty('AboutJVCL', 'TJVCLAboutInfo', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TJvGraphicControl(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TGraphicControl', 'TJvGraphicControl') do
  with CL.AddClassN(CL.FindClass('TGraphicControl'),'TJvGraphicControl') do
  begin
    RegisterProperty('AboutJVCL', 'TJVCLAboutInfo', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TJvComponent(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TComponent', 'TJvComponent') do
  with CL.AddClassN(CL.FindClass('TComponent'),'TJvComponent') do
  begin
    RegisterProperty('AboutJVCL', 'TJVCLAboutInfo', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_JvComponent(CL: TPSPascalCompiler);
begin
  CL.AddTypeS('TJvClipBoardCommand', '( caCopy, caCut, caPaste, caUndo )');
  CL.AddTypeS('TJvClipBoardCommands', 'set of TJvClipBoardCommand');
  SIRegister_TJvComponent(CL);
  SIRegister_TJvGraphicControl(CL);
  SIRegister_TJvCustomPanel(CL);
  SIRegister_TJvCustomControl(CL);
  SIRegister_TJvWinControl(CL);
  SIRegister_TJvForm(CL);
  SIRegister_TJvCustomMemo(CL);
  SIRegister_TJvMultiselectCheckListBox(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TJvMultiselectCheckListBoxAboutJVCL_W(Self: TJvMultiselectCheckListBox; const T: TJVCLAboutInfo);
begin Self.AboutJVCL := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvMultiselectCheckListBoxAboutJVCL_R(Self: TJvMultiselectCheckListBox; var T: TJVCLAboutInfo);
begin T := Self.AboutJVCL; end;

(*----------------------------------------------------------------------------*)
procedure TJvCustomMemoAboutJVCL_W(Self: TJvCustomMemo; const T: TJVCLAboutInfo);
begin Self.AboutJVCL := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvCustomMemoAboutJVCL_R(Self: TJvCustomMemo; var T: TJVCLAboutInfo);
begin T := Self.AboutJVCL; end;

(*----------------------------------------------------------------------------*)
procedure TJvFormAboutJVCL_W(Self: TJvForm; const T: TJVCLAboutInfo);
begin Self.AboutJVCL := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvFormAboutJVCL_R(Self: TJvForm; var T: TJVCLAboutInfo);
begin T := Self.AboutJVCL; end;

(*----------------------------------------------------------------------------*)
procedure TJvWinControlAboutJVCL_W(Self: TJvWinControl; const T: TJVCLAboutInfo);
begin Self.AboutJVCL := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvWinControlAboutJVCL_R(Self: TJvWinControl; var T: TJVCLAboutInfo);
begin T := Self.AboutJVCL; end;

(*----------------------------------------------------------------------------*)
procedure TJvCustomControlAboutJVCL_W(Self: TJvCustomControl; const T: TJVCLAboutInfo);
begin Self.AboutJVCL := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvCustomControlAboutJVCL_R(Self: TJvCustomControl; var T: TJVCLAboutInfo);
begin T := Self.AboutJVCL; end;

(*----------------------------------------------------------------------------*)
procedure TJvCustomPanelAboutJVCL_W(Self: TJvCustomPanel; const T: TJVCLAboutInfo);
begin Self.AboutJVCL := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvCustomPanelAboutJVCL_R(Self: TJvCustomPanel; var T: TJVCLAboutInfo);
begin T := Self.AboutJVCL; end;

(*----------------------------------------------------------------------------*)
procedure TJvGraphicControlAboutJVCL_W(Self: TJvGraphicControl; const T: TJVCLAboutInfo);
begin Self.AboutJVCL := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvGraphicControlAboutJVCL_R(Self: TJvGraphicControl; var T: TJVCLAboutInfo);
begin T := Self.AboutJVCL; end;

(*----------------------------------------------------------------------------*)
procedure TJvComponentAboutJVCL_W(Self: TJvComponent; const T: TJVCLAboutInfo);
begin Self.AboutJVCL := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvComponentAboutJVCL_R(Self: TJvComponent; var T: TJVCLAboutInfo);
begin T := Self.AboutJVCL; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJvMultiselectCheckListBox(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJvMultiselectCheckListBox) do
  begin
    RegisterPropertyHelper(@TJvMultiselectCheckListBoxAboutJVCL_R,@TJvMultiselectCheckListBoxAboutJVCL_W,'AboutJVCL');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJvCustomMemo(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJvCustomMemo) do
  begin
    RegisterPropertyHelper(@TJvCustomMemoAboutJVCL_R,@TJvCustomMemoAboutJVCL_W,'AboutJVCL');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJvForm(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJvForm) do
  begin
    RegisterPropertyHelper(@TJvFormAboutJVCL_R,@TJvFormAboutJVCL_W,'AboutJVCL');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJvWinControl(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJvWinControl) do
  begin
    RegisterPropertyHelper(@TJvWinControlAboutJVCL_R,@TJvWinControlAboutJVCL_W,'AboutJVCL');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJvCustomControl(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJvCustomControl) do
  begin
    RegisterPropertyHelper(@TJvCustomControlAboutJVCL_R,@TJvCustomControlAboutJVCL_W,'AboutJVCL');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJvCustomPanel(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJvCustomPanel) do
  begin
    RegisterPropertyHelper(@TJvCustomPanelAboutJVCL_R,@TJvCustomPanelAboutJVCL_W,'AboutJVCL');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJvGraphicControl(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJvGraphicControl) do
  begin
    RegisterPropertyHelper(@TJvGraphicControlAboutJVCL_R,@TJvGraphicControlAboutJVCL_W,'AboutJVCL');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJvComponent(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJvComponent) do
  begin
    RegisterPropertyHelper(@TJvComponentAboutJVCL_R,@TJvComponentAboutJVCL_W,'AboutJVCL');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_JvComponent(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TJvComponent(CL);
  RIRegister_TJvGraphicControl(CL);
  RIRegister_TJvCustomPanel(CL);
  RIRegister_TJvCustomControl(CL);
  RIRegister_TJvWinControl(CL);
  RIRegister_TJvForm(CL);
  RIRegister_TJvCustomMemo(CL);
  RIRegister_TJvMultiselectCheckListBox(CL);
end;

 
 
{ TPSImport_JvComponent }
(*----------------------------------------------------------------------------*)
procedure TPSImport_JvComponent.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_JvComponent(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_JvComponent.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_JvComponent(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
