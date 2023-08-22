unit uPSI_JvDualList;
{
  dual list for compare2  in coop with a form
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
  TPSImport_JvDualList = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TJvDualListDialog(CL: TPSPascalCompiler);
procedure SIRegister_JvDualList(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TJvDualListDialog(CL: TPSRuntimeClassImporter);
procedure RIRegister_JvDualList(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
  // JclUnitVersioning
  Windows
  ,Controls
  ,StdCtrls
  ,JvComponentBase
  ,Forms
  ,JvDualList
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_JvDualList]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TJvDualListDialog(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TJvComponent', 'TJvDualListDialog') do
  with CL.AddClassN(CL.FindClass('TJvComponent'),'TJvDualListDialog') do begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
    RegisterMethod('Procedure Free');
    RegisterMethod('Function Execute : Boolean');
    RegisterProperty('Sorted', 'Boolean', iptrw);
    RegisterProperty('Title', 'string', iptrw);
    RegisterProperty('Label1Caption', 'TCaption', iptrw);
    RegisterProperty('Label2Caption', 'TCaption', iptrw);
    RegisterProperty('OkBtnCaption', 'TCaption', iptrw);
    RegisterProperty('CancelBtnCaption', 'TCaption', iptrw);
    RegisterProperty('HelpBtnCaption', 'TCaption', iptrw);
    RegisterProperty('HelpContext', 'THelpContext', iptrw);
    RegisterProperty('List1', 'TStrings', iptrw);
    RegisterProperty('List2', 'TStrings', iptrw);
    RegisterProperty('CenterOnControl', 'TControl', iptrw);
    RegisterProperty('Width', 'Integer', iptrw);
    RegisterProperty('Height', 'Integer', iptrw);
    RegisterProperty('ShowHelp', 'Boolean', iptrw);
    RegisterProperty('ScrollBars', 'TScrollStyle', iptrw);
    RegisterProperty('Resizable', 'Boolean', iptrw);
    RegisterProperty('Listboxheight', 'integer', iptrw);
    RegisterProperty('listboxScrollwidth', 'integer', iptrw);
    RegisterProperty('OnCustomize', 'TJvDualListCustomizeEvent', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_JvDualList(CL: TPSPascalCompiler);
begin
  CL.AddTypeS('TJvDualListCustomizeEvent', 'Procedure ( Sender : TObject; Form: TCustomForm)');
  SIRegister_TJvDualListDialog(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TJvDualListDialogOnCustomize_W(Self: TJvDualListDialog; const T: TJvDualListCustomizeEvent);
begin Self.OnCustomize := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvDualListDialogOnCustomize_R(Self: TJvDualListDialog; var T: TJvDualListCustomizeEvent);
begin T := Self.OnCustomize; end;

(*----------------------------------------------------------------------------*)
procedure TJvDualListDialogResizable_W(Self: TJvDualListDialog; const T: Boolean);
begin Self.Resizable := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvDualListDialogResizable_R(Self: TJvDualListDialog; var T: Boolean);
begin T := Self.Resizable; end;

(*----------------------------------------------------------------------------*)
procedure TJvDualListDialogScrollBars_W(Self: TJvDualListDialog; const T: TScrollStyle);
begin Self.ScrollBars := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvDualListDialogScrollBars_R(Self: TJvDualListDialog; var T: TScrollStyle);
begin T := Self.ScrollBars; end;

(*----------------------------------------------------------------------------*)
procedure TJvDualListDialogShowHelp_W(Self: TJvDualListDialog; const T: Boolean);
begin Self.ShowHelp := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvDualListDialogShowHelp_R(Self: TJvDualListDialog; var T: Boolean);
begin T := Self.ShowHelp; end;

(*----------------------------------------------------------------------------*)
procedure TJvDualListDialogHeight_W(Self: TJvDualListDialog; const T: Integer);
begin Self.Height := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvDualListDialogHeight_R(Self: TJvDualListDialog; var T: Integer);
begin T := Self.Height; end;

(*----------------------------------------------------------------------------*)
procedure TJvDualListDialogWidth_W(Self: TJvDualListDialog; const T: Integer);
begin Self.Width := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvDualListDialogWidth_R(Self: TJvDualListDialog; var T: Integer);
begin T := Self.Width; end;

(*----------------------------------------------------------------------------*)
procedure TJvDualListDialogCenterOnControl_W(Self: TJvDualListDialog; const T: TControl);
begin Self.CenterOnControl := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvDualListDialogCenterOnControl_R(Self: TJvDualListDialog; var T: TControl);
begin T := Self.CenterOnControl; end;

(*----------------------------------------------------------------------------*)
procedure TJvDualListDialogList2_W(Self: TJvDualListDialog; const T: TStrings);
begin Self.List2 := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvDualListDialogList2_R(Self: TJvDualListDialog; var T: TStrings);
begin T := Self.List2; end;

(*----------------------------------------------------------------------------*)
procedure TJvDualListDialogList1_W(Self: TJvDualListDialog; const T: TStrings);
begin Self.List1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvDualListDialogList1_R(Self: TJvDualListDialog; var T: TStrings);
begin T := Self.List1; end;

(*----------------------------------------------------------------------------*)
procedure TJvDualListDialogHelpContext_W(Self: TJvDualListDialog; const T: THelpContext);
begin Self.HelpContext := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvDualListDialogHelpContext_R(Self: TJvDualListDialog; var T: THelpContext);
begin T := Self.HelpContext; end;

(*----------------------------------------------------------------------------*)
procedure TJvDualListDialogHelpBtnCaption_W(Self: TJvDualListDialog; const T: TCaption);
begin Self.HelpBtnCaption := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvDualListDialogHelpBtnCaption_R(Self: TJvDualListDialog; var T: TCaption);
begin T := Self.HelpBtnCaption; end;

(*----------------------------------------------------------------------------*)
procedure TJvDualListDialogCancelBtnCaption_W(Self: TJvDualListDialog; const T: TCaption);
begin Self.CancelBtnCaption := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvDualListDialogCancelBtnCaption_R(Self: TJvDualListDialog; var T: TCaption);
begin T := Self.CancelBtnCaption; end;

(*----------------------------------------------------------------------------*)
procedure TJvDualListDialogOkBtnCaption_W(Self: TJvDualListDialog; const T: TCaption);
begin Self.OkBtnCaption := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvDualListDialogOkBtnCaption_R(Self: TJvDualListDialog; var T: TCaption);
begin T := Self.OkBtnCaption; end;

(*----------------------------------------------------------------------------*)
procedure TJvDualListDialogLabel2Caption_W(Self: TJvDualListDialog; const T: TCaption);
begin Self.Label2Caption := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvDualListDialogLabel2Caption_R(Self: TJvDualListDialog; var T: TCaption);
begin T := Self.Label2Caption; end;

(*----------------------------------------------------------------------------*)
procedure TJvDualListDialogLabel1Caption_W(Self: TJvDualListDialog; const T: TCaption);
begin Self.Label1Caption := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvDualListDialogLabel1Caption_R(Self: TJvDualListDialog; var T: TCaption);
begin T := Self.Label1Caption; end;

(*----------------------------------------------------------------------------*)
procedure TJvDualListDialogTitle_W(Self: TJvDualListDialog; const T: string);
begin Self.Title := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvDualListDialogTitle_R(Self: TJvDualListDialog; var T: string);
begin T := Self.Title; end;

(*----------------------------------------------------------------------------*)
procedure TJvDualListDialogSorted_W(Self: TJvDualListDialog; const T: Boolean);
begin Self.Sorted := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvDualListDialogSorted_R(Self: TJvDualListDialog; var T: Boolean);
begin T := Self.Sorted; end;

(*----------------------------------------------------------------------------*)
procedure TJvDualListDialoglistboxheight_W(Self: TJvDualListDialog; const T: integer);
begin Self.listboxheight:= T; end;

(*----------------------------------------------------------------------------*)
procedure TJvDualListDialoglistboxheight_R(Self: TJvDualListDialog; var T: integer);
begin T:= Self.listboxheight; end;

(*----------------------------------------------------------------------------*)
procedure TJvDualListDialoglistboxscrollwidth_W(Self: TJvDualListDialog; const T: integer);
begin Self.listboxscrollwidth:= T; end;

(*----------------------------------------------------------------------------*)
procedure TJvDualListDialoglistboxscrollwidth_R(Self: TJvDualListDialog; var T: integer);
begin T:= Self.listboxscrollwidth; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJvDualListDialog(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJvDualListDialog) do begin
    RegisterConstructor(@TJvDualListDialog.Create, 'Create');
    RegisterMethod(@TJvDualListDialog.Destroy, 'Free');
    RegisterMethod(@TJvDualListDialog.Execute, 'Execute');
    RegisterPropertyHelper(@TJvDualListDialogSorted_R,@TJvDualListDialogSorted_W,'Sorted');
    RegisterPropertyHelper(@TJvDualListDialogTitle_R,@TJvDualListDialogTitle_W,'Title');
    RegisterPropertyHelper(@TJvDualListDialogLabel1Caption_R,@TJvDualListDialogLabel1Caption_W,'Label1Caption');
    RegisterPropertyHelper(@TJvDualListDialogLabel2Caption_R,@TJvDualListDialogLabel2Caption_W,'Label2Caption');
    RegisterPropertyHelper(@TJvDualListDialogOkBtnCaption_R,@TJvDualListDialogOkBtnCaption_W,'OkBtnCaption');
    RegisterPropertyHelper(@TJvDualListDialogCancelBtnCaption_R,@TJvDualListDialogCancelBtnCaption_W,'CancelBtnCaption');
    RegisterPropertyHelper(@TJvDualListDialogHelpBtnCaption_R,@TJvDualListDialogHelpBtnCaption_W,'HelpBtnCaption');
    RegisterPropertyHelper(@TJvDualListDialogHelpContext_R,@TJvDualListDialogHelpContext_W,'HelpContext');
    RegisterPropertyHelper(@TJvDualListDialogList1_R,@TJvDualListDialogList1_W,'List1');
    RegisterPropertyHelper(@TJvDualListDialogList2_R,@TJvDualListDialogList2_W,'List2');
    RegisterPropertyHelper(@TJvDualListDialogCenterOnControl_R,@TJvDualListDialogCenterOnControl_W,'CenterOnControl');
    RegisterPropertyHelper(@TJvDualListDialogWidth_R,@TJvDualListDialogWidth_W,'Width');
    RegisterPropertyHelper(@TJvDualListDialogHeight_R,@TJvDualListDialogHeight_W,'Height');
    RegisterPropertyHelper(@TJvDualListDialogShowHelp_R,@TJvDualListDialogShowHelp_W,'ShowHelp');
    RegisterPropertyHelper(@TJvDualListDialogScrollBars_R,@TJvDualListDialogScrollBars_W,'ScrollBars');
    RegisterPropertyHelper(@TJvDualListDialogResizable_R,@TJvDualListDialogResizable_W,'Resizable');
    RegisterPropertyHelper(@TJvDualListDialoglistboxheight_R,@TJvDualListDialogListboxheight_W,'Listboxheight');
    RegisterPropertyHelper(@TJvDualListDialoglistboxscrollwidth_R,@TJvDualListDialogListboxscrollwidth_W,'Listboxscrollwidth');
    RegisterPropertyHelper(@TJvDualListDialogOnCustomize_R,@TJvDualListDialogOnCustomize_W,'OnCustomize');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_JvDualList(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TJvDualListDialog(CL);
end;

 
 
{ TPSImport_JvDualList }
(*----------------------------------------------------------------------------*)
procedure TPSImport_JvDualList.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_JvDualList(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_JvDualList.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_JvDualList(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
