unit uPSI_ActnList;
{
  VCL
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
  TPSImport_ActnList = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TActionLink(CL: TPSPascalCompiler);
procedure SIRegister_TAction(CL: TPSPascalCompiler);
procedure SIRegister_TCustomAction(CL: TPSPascalCompiler);
procedure SIRegister_TShortCutList(CL: TPSPascalCompiler);
procedure SIRegister_TActionList(CL: TPSPascalCompiler);
procedure SIRegister_TCustomActionList(CL: TPSPascalCompiler);
procedure SIRegister_TActionListEnumerator(CL: TPSPascalCompiler);
procedure SIRegister_TContainedAction(CL: TPSPascalCompiler);
procedure SIRegister_ActnList(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_ActnList_Routines(S: TPSExec);
procedure RIRegister_TActionLink(CL: TPSRuntimeClassImporter);
procedure RIRegister_TAction(CL: TPSRuntimeClassImporter);
procedure RIRegister_TCustomAction(CL: TPSRuntimeClassImporter);
procedure RIRegister_TShortCutList(CL: TPSRuntimeClassImporter);
procedure RIRegister_TActionList(CL: TPSRuntimeClassImporter);
procedure RIRegister_TCustomActionList(CL: TPSRuntimeClassImporter);
procedure RIRegister_TActionListEnumerator(CL: TPSRuntimeClassImporter);
procedure RIRegister_TContainedAction(CL: TPSRuntimeClassImporter);
procedure RIRegister_ActnList(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   Messages
  ,ImgList
  ,Contnrs
  ,ActnList
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_ActnList]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TActionLink(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TBasicActionLink', 'TActionLink') do
  with CL.AddClassN(CL.FindClass('TBasicActionLink'),'TActionLink') do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TAction(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TCustomAction', 'TAction') do
  with CL.AddClassN(CL.FindClass('TCustomAction'),'TAction') do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TCustomAction(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TContainedAction', 'TCustomAction') do
  with CL.AddClassN(CL.FindClass('TContainedAction'),'TCustomAction') do begin
    RegisterMethod('Function DoHint( var HintStr : string) : Boolean');
    RegisterProperty('AutoCheck', 'Boolean', iptrw);
    RegisterProperty('Caption', 'string', iptrw);
    RegisterProperty('Checked', 'Boolean', iptrw);
    RegisterProperty('DisableIfNoHandler', 'Boolean', iptrw);
    RegisterProperty('Enabled', 'Boolean', iptrw);
    RegisterProperty('GroupIndex', 'Integer', iptrw);
    RegisterProperty('HelpContext', 'THelpContext', iptrw);
    RegisterProperty('HelpKeyword', 'string', iptrw);
    RegisterProperty('HelpType', 'THelpType', iptrw);
    RegisterProperty('Hint', 'string', iptrw);
    RegisterProperty('ImageIndex', 'TImageIndex', iptrw);
    RegisterProperty('ShortCut', 'TShortCut', iptrw);
    RegisterProperty('SecondaryShortCuts', 'TShortCutList', iptrw);
    RegisterProperty('Visible', 'Boolean', iptrw);
    RegisterProperty('OnHint', 'THintEvent', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TShortCutList(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TStringList', 'TShortCutList') do
  with CL.AddClassN(CL.FindClass('TStringList'),'TShortCutList') do begin
    RegisterMethod('Function IndexOfShortCut( const Shortcut : TShortCut) : Integer');
    RegisterProperty('ShortCuts', 'TShortCut Integer', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TActionList(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TCustomActionList', 'TActionList') do
  with CL.AddClassN(CL.FindClass('TCustomActionList'),'TActionList') do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TCustomActionList(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TComponent', 'TCustomActionList') do
  with CL.AddClassN(CL.FindClass('TComponent'),'TCustomActionList') do begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
    RegisterMethod('Function ExecuteAction( Action : TBasicAction) : Boolean');
    RegisterMethod('Function GetEnumerator : TActionListEnumerator');
    RegisterMethod('Function IsShortCut( var Message : TWMKey) : Boolean');
    RegisterMethod('Function UpdateAction( Action : TBasicAction) : Boolean');
    RegisterProperty('Actions', 'TContainedAction Integer', iptrw);
    SetDefaultPropery('Actions');
    RegisterProperty('ActionCount', 'Integer', iptr);
    RegisterProperty('Images', 'TCustomImageList', iptrw);
    RegisterProperty('State', 'TActionListState', iptrw);
    RegisterProperty('OnStateChange', 'TNotifyEvent', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TActionListEnumerator(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOBJECT', 'TActionListEnumerator') do
  with CL.AddClassN(CL.FindClass('TOBJECT'),'TActionListEnumerator') do begin
    RegisterMethod('Constructor Create( AActionList : TCustomActionList)');
    RegisterMethod('Function GetCurrent : TContainedAction');
    RegisterMethod('Function MoveNext : Boolean');
    RegisterProperty('Current', 'TContainedAction', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TContainedAction(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TBasicAction', 'TContainedAction') do
  with CL.AddClassN(CL.FindClass('TBasicAction'),'TContainedAction') do
  begin
    RegisterMethod('Function Execute : Boolean');
    RegisterProperty('ActionList', 'TCustomActionList', iptrw);
    RegisterProperty('Index', 'Integer', iptrw);
    RegisterProperty('Category', 'string', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_ActnList(CL: TPSPascalCompiler);
begin
  CL.AddClassN(CL.FindClass('TOBJECT'),'TCustomActionList');
  SIRegister_TContainedAction(CL);
  //CL.AddTypeS('TContainedActionClass', 'class of TContainedAction');
  SIRegister_TActionListEnumerator(CL);
  //CL.AddTypeS('TActionEvent', 'Procedure ( Action : TBasicAction; var Handled :'
  // +' Boolean)');
  CL.AddTypeS('TActionListState', '( asNormal, asSuspended, asSuspendedEnabled)');
  SIRegister_TCustomActionList(CL);
  SIRegister_TActionList(CL);
  SIRegister_TShortCutList(CL);
  CL.AddTypeS('THintEvent', 'Procedure ( var HintStr : string; var CanShow : Boolean)');
  SIRegister_TCustomAction(CL);
  SIRegister_TAction(CL);
  SIRegister_TActionLink(CL);
  //CL.AddTypeS('TActionLinkClass', 'class of TActionLink');
  //CL.AddTypeS('TEnumActionProc', 'Procedure ( const Category : string; ActionCl'
  // +'ass : TBasicActionClass; Info : Pointer)');
 //CL.AddDelphiFunction('Procedure RegisterActions( const CategoryName : string; const AClasses : array of TBasicActionClass; Resource : TComponentClass)');
 //CL.AddDelphiFunction('Procedure UnRegisterActions( const AClasses : array of TBasicActionClass)');
 //CL.AddDelphiFunction('Procedure EnumRegisteredActions( Proc : TEnumActionProc; Info : Pointer)');
 //CL.AddDelphiFunction('Function CreateAction( AOwner : TComponent; ActionClass : TBasicActionClass) : TBasicAction');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TCustomActionOnHint_W(Self: TCustomAction; const T: THintEvent);
begin Self.OnHint := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomActionOnHint_R(Self: TCustomAction; var T: THintEvent);
begin T := Self.OnHint; end;

(*----------------------------------------------------------------------------*)
procedure TCustomActionVisible_W(Self: TCustomAction; const T: Boolean);
begin Self.Visible := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomActionVisible_R(Self: TCustomAction; var T: Boolean);
begin T := Self.Visible; end;

(*----------------------------------------------------------------------------*)
procedure TCustomActionSecondaryShortCuts_W(Self: TCustomAction; const T: TShortCutList);
begin Self.SecondaryShortCuts := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomActionSecondaryShortCuts_R(Self: TCustomAction; var T: TShortCutList);
begin T := Self.SecondaryShortCuts; end;

(*----------------------------------------------------------------------------*)
procedure TCustomActionShortCut_W(Self: TCustomAction; const T: TShortCut);
begin Self.ShortCut := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomActionShortCut_R(Self: TCustomAction; var T: TShortCut);
begin T := Self.ShortCut; end;

(*----------------------------------------------------------------------------*)
procedure TCustomActionImageIndex_W(Self: TCustomAction; const T: TImageIndex);
begin Self.ImageIndex := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomActionImageIndex_R(Self: TCustomAction; var T: TImageIndex);
begin T := Self.ImageIndex; end;

(*----------------------------------------------------------------------------*)
procedure TCustomActionHint_W(Self: TCustomAction; const T: string);
begin Self.Hint := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomActionHint_R(Self: TCustomAction; var T: string);
begin T := Self.Hint; end;

(*----------------------------------------------------------------------------*)
procedure TCustomActionHelpType_W(Self: TCustomAction; const T: THelpType);
begin Self.HelpType := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomActionHelpType_R(Self: TCustomAction; var T: THelpType);
begin T := Self.HelpType; end;

(*----------------------------------------------------------------------------*)
procedure TCustomActionHelpKeyword_W(Self: TCustomAction; const T: string);
begin Self.HelpKeyword := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomActionHelpKeyword_R(Self: TCustomAction; var T: string);
begin T := Self.HelpKeyword; end;

(*----------------------------------------------------------------------------*)
procedure TCustomActionHelpContext_W(Self: TCustomAction; const T: THelpContext);
begin Self.HelpContext := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomActionHelpContext_R(Self: TCustomAction; var T: THelpContext);
begin T := Self.HelpContext; end;

(*----------------------------------------------------------------------------*)
procedure TCustomActionGroupIndex_W(Self: TCustomAction; const T: Integer);
begin Self.GroupIndex := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomActionGroupIndex_R(Self: TCustomAction; var T: Integer);
begin T := Self.GroupIndex; end;

(*----------------------------------------------------------------------------*)
procedure TCustomActionEnabled_W(Self: TCustomAction; const T: Boolean);
begin Self.Enabled := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomActionEnabled_R(Self: TCustomAction; var T: Boolean);
begin T := Self.Enabled; end;

(*----------------------------------------------------------------------------*)
procedure TCustomActionDisableIfNoHandler_W(Self: TCustomAction; const T: Boolean);
begin Self.DisableIfNoHandler := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomActionDisableIfNoHandler_R(Self: TCustomAction; var T: Boolean);
begin T := Self.DisableIfNoHandler; end;

(*----------------------------------------------------------------------------*)
procedure TCustomActionChecked_W(Self: TCustomAction; const T: Boolean);
begin Self.Checked := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomActionChecked_R(Self: TCustomAction; var T: Boolean);
begin T := Self.Checked; end;

(*----------------------------------------------------------------------------*)
procedure TCustomActionCaption_W(Self: TCustomAction; const T: string);
begin Self.Caption := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomActionCaption_R(Self: TCustomAction; var T: string);
begin T := Self.Caption; end;

(*----------------------------------------------------------------------------*)
procedure TCustomActionAutoCheck_W(Self: TCustomAction; const T: Boolean);
begin Self.AutoCheck := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomActionAutoCheck_R(Self: TCustomAction; var T: Boolean);
begin T := Self.AutoCheck; end;

(*----------------------------------------------------------------------------*)
procedure TShortCutListShortCuts_R(Self: TShortCutList; var T: TShortCut; const t1: Integer);
begin T := Self.ShortCuts[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TCustomActionListOnStateChange_W(Self: TCustomActionList; const T: TNotifyEvent);
begin Self.OnStateChange := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomActionListOnStateChange_R(Self: TCustomActionList; var T: TNotifyEvent);
begin T := Self.OnStateChange; end;

(*----------------------------------------------------------------------------*)
procedure TCustomActionListState_W(Self: TCustomActionList; const T: TActionListState);
begin Self.State := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomActionListState_R(Self: TCustomActionList; var T: TActionListState);
begin T := Self.State; end;

(*----------------------------------------------------------------------------*)
procedure TCustomActionListImages_W(Self: TCustomActionList; const T: TCustomImageList);
begin Self.Images := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomActionListImages_R(Self: TCustomActionList; var T: TCustomImageList);
begin T := Self.Images; end;

(*----------------------------------------------------------------------------*)
procedure TCustomActionListActionCount_R(Self: TCustomActionList; var T: Integer);
begin T := Self.ActionCount; end;

(*----------------------------------------------------------------------------*)
procedure TCustomActionListActions_W(Self: TCustomActionList; const T: TContainedAction; const t1: Integer);
begin Self.Actions[t1] := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomActionListActions_R(Self: TCustomActionList; var T: TContainedAction; const t1: Integer);
begin T := Self.Actions[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TActionListEnumeratorCurrent_R(Self: TActionListEnumerator; var T: TContainedAction);
begin T := Self.Current; end;

(*----------------------------------------------------------------------------*)
procedure TContainedActionCategory_W(Self: TContainedAction; const T: string);
begin Self.Category := T; end;

(*----------------------------------------------------------------------------*)
procedure TContainedActionCategory_R(Self: TContainedAction; var T: string);
begin T := Self.Category; end;

(*----------------------------------------------------------------------------*)
procedure TContainedActionIndex_W(Self: TContainedAction; const T: Integer);
begin Self.Index := T; end;

(*----------------------------------------------------------------------------*)
procedure TContainedActionIndex_R(Self: TContainedAction; var T: Integer);
begin T := Self.Index; end;

(*----------------------------------------------------------------------------*)
procedure TContainedActionActionList_W(Self: TContainedAction; const T: TCustomActionList);
begin Self.ActionList := T; end;

(*----------------------------------------------------------------------------*)
procedure TContainedActionActionList_R(Self: TContainedAction; var T: TCustomActionList);
begin T := Self.ActionList; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_ActnList_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@RegisterActions, 'RegisterActions', cdRegister);
 S.RegisterDelphiFunction(@UnRegisterActions, 'UnRegisterActions', cdRegister);
 S.RegisterDelphiFunction(@EnumRegisteredActions, 'EnumRegisteredActions', cdRegister);
 S.RegisterDelphiFunction(@CreateAction, 'CreateAction', cdRegister);
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TActionLink(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TActionLink) do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TAction(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TAction) do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TCustomAction(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TCustomAction) do
  begin
    RegisterVirtualMethod(@TCustomAction.DoHint, 'DoHint');
    RegisterPropertyHelper(@TCustomActionAutoCheck_R,@TCustomActionAutoCheck_W,'AutoCheck');
    RegisterPropertyHelper(@TCustomActionCaption_R,@TCustomActionCaption_W,'Caption');
    RegisterPropertyHelper(@TCustomActionChecked_R,@TCustomActionChecked_W,'Checked');
    RegisterPropertyHelper(@TCustomActionDisableIfNoHandler_R,@TCustomActionDisableIfNoHandler_W,'DisableIfNoHandler');
    RegisterPropertyHelper(@TCustomActionEnabled_R,@TCustomActionEnabled_W,'Enabled');
    RegisterPropertyHelper(@TCustomActionGroupIndex_R,@TCustomActionGroupIndex_W,'GroupIndex');
    RegisterPropertyHelper(@TCustomActionHelpContext_R,@TCustomActionHelpContext_W,'HelpContext');
    RegisterPropertyHelper(@TCustomActionHelpKeyword_R,@TCustomActionHelpKeyword_W,'HelpKeyword');
    RegisterPropertyHelper(@TCustomActionHelpType_R,@TCustomActionHelpType_W,'HelpType');
    RegisterPropertyHelper(@TCustomActionHint_R,@TCustomActionHint_W,'Hint');
    RegisterPropertyHelper(@TCustomActionImageIndex_R,@TCustomActionImageIndex_W,'ImageIndex');
    RegisterPropertyHelper(@TCustomActionShortCut_R,@TCustomActionShortCut_W,'ShortCut');
    RegisterPropertyHelper(@TCustomActionSecondaryShortCuts_R,@TCustomActionSecondaryShortCuts_W,'SecondaryShortCuts');
    RegisterPropertyHelper(@TCustomActionVisible_R,@TCustomActionVisible_W,'Visible');
    RegisterPropertyHelper(@TCustomActionOnHint_R,@TCustomActionOnHint_W,'OnHint');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TShortCutList(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TShortCutList) do
  begin
    RegisterMethod(@TShortCutList.IndexOfShortCut, 'IndexOfShortCut');
    RegisterPropertyHelper(@TShortCutListShortCuts_R,nil,'ShortCuts');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TActionList(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TActionList) do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TCustomActionList(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TCustomActionList) do begin
    RegisterConstructor(@TCustomActionList.Create, 'Create');
    RegisterMethod(@TCustomActionList.ExecuteAction, 'ExecuteAction');
    RegisterMethod(@TCustomActionList.GetEnumerator, 'GetEnumerator');
    RegisterMethod(@TCustomActionList.IsShortCut, 'IsShortCut');
    RegisterMethod(@TCustomActionList.UpdateAction, 'UpdateAction');
    RegisterPropertyHelper(@TCustomActionListActions_R,@TCustomActionListActions_W,'Actions');
    RegisterPropertyHelper(@TCustomActionListActionCount_R,nil,'ActionCount');
    RegisterPropertyHelper(@TCustomActionListImages_R,@TCustomActionListImages_W,'Images');
    RegisterPropertyHelper(@TCustomActionListState_R,@TCustomActionListState_W,'State');
    RegisterPropertyHelper(@TCustomActionListOnStateChange_R,@TCustomActionListOnStateChange_W,'OnStateChange');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TActionListEnumerator(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TActionListEnumerator) do begin
    RegisterConstructor(@TActionListEnumerator.Create, 'Create');
    RegisterMethod(@TActionListEnumerator.GetCurrent, 'GetCurrent');
    RegisterMethod(@TActionListEnumerator.MoveNext, 'MoveNext');
    RegisterPropertyHelper(@TActionListEnumeratorCurrent_R,nil,'Current');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TContainedAction(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TContainedAction) do begin
    RegisterMethod(@TContainedAction.Execute, 'Execute');
    RegisterPropertyHelper(@TContainedActionActionList_R,@TContainedActionActionList_W,'ActionList');
    RegisterPropertyHelper(@TContainedActionIndex_R,@TContainedActionIndex_W,'Index');
    RegisterPropertyHelper(@TContainedActionCategory_R,@TContainedActionCategory_W,'Category');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_ActnList(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TCustomActionList) do
  RIRegister_TContainedAction(CL);
  RIRegister_TActionListEnumerator(CL);
  RIRegister_TCustomActionList(CL);
  RIRegister_TActionList(CL);
  RIRegister_TShortCutList(CL);
  RIRegister_TCustomAction(CL);
  RIRegister_TAction(CL);
  RIRegister_TActionLink(CL);
end;

 
 
{ TPSImport_ActnList }
(*----------------------------------------------------------------------------*)
procedure TPSImport_ActnList.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_ActnList(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_ActnList.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_ActnList(ri);
  RIRegister_ActnList_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
