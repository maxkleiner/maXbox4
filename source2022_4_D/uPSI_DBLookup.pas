unit uPSI_dblookup;
{
   this lookup
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
  TPSImport_dblookup = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TComboButton(CL: TPSPascalCompiler);
procedure SIRegister_TPopupGrid(CL: TPSPascalCompiler);
procedure SIRegister_TDBLookupList(CL: TPSPascalCompiler);
procedure SIRegister_TDBLookupCombo(CL: TPSPascalCompiler);
procedure SIRegister_dblookup(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TComboButton(CL: TPSRuntimeClassImporter);
procedure RIRegister_TPopupGrid(CL: TPSRuntimeClassImporter);
procedure RIRegister_TDBLookupList(CL: TPSRuntimeClassImporter);
procedure RIRegister_TDBLookupCombo(CL: TPSRuntimeClassImporter);
procedure RIRegister_dblookup(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   Windows
  ,StdCtrls
  ,DB
  ,Controls
  ,Messages
  ,Forms
  ,Graphics
  ,Menus
  ,Buttons
  ,DBGrids
  ,DBTables
  ,Grids
  ,Dbctrls
  ,dblookup
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_dblookup]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TComboButton(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TSpeedButton', 'TComboButton') do
  with CL.AddClassN(CL.FindClass('TSpeedButton'),'TComboButton') do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TPopupGrid(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TDBLookupList', 'TPopupGrid') do
  with CL.AddClassN(CL.FindClass('TDBLookupList'),'TPopupGrid') do
  begin  RegisterMethod('Constructor Create( AOwner : TComponent)');
    RegisterPublishedProperties;


  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TDBLookupList(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TCustomDBGrid', 'TDBLookupList') do
  with CL.AddClassN(CL.FindClass('TCustomDBGrid'),'TDBLookupList') do
  begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
           RegisterMethod('Procedure Free');
      RegisterProperty('Value', 'string', iptrw);
    RegisterProperty('DisplayValue', 'string', iptrw);
    RegisterProperty('DataField', 'string', iptrw);
    RegisterProperty('DataSource', 'TDataSource', iptrw);
    RegisterProperty('LookupSource', 'TDataSource', iptrw);
    RegisterProperty('LookupDisplay', 'string', iptrw);
    RegisterProperty('LookupField', 'string', iptrw);
    RegisterProperty('Options', 'TDBLookupListOptions', iptrw);
    RegisterProperty('OnClick', 'TNotifyEvent', iptrw);
    RegisterProperty('ReadOnly', 'Boolean', iptrw);
    RegisterPublishedProperties;

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

  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TDBLookupCombo(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TCustomEdit', 'TDBLookupCombo') do
  with CL.AddClassN(CL.FindClass('TCustomEdit'),'TDBLookupCombo') do begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
     RegisterMethod('Procedure Free');
      RegisterMethod('Procedure DropDown');
    RegisterMethod('Procedure CloseUp');
    RegisterProperty('Value', 'string', iptrw);
    RegisterProperty('DisplayValue', 'string', iptrw);
    RegisterProperty('DataField', 'string', iptrw);
    RegisterProperty('DataSource', 'TDataSource', iptrw);
    RegisterProperty('LookupSource', 'TDataSource', iptrw);
    RegisterProperty('LookupDisplay', 'string', iptrw);
    RegisterProperty('LookupField', 'string', iptrw);
    RegisterProperty('Options', 'TDBLookupListOptions', iptrw);
    RegisterProperty('Style', 'TDBLookupComboStyle', iptrw);
    RegisterProperty('DropDownCount', 'Integer', iptrw);
    RegisterProperty('DropDownWidth', 'Integer', iptrw);
    RegisterProperty('ReadOnly', 'Boolean', iptrw);
    RegisterProperty('OnDropDown', 'TNotifyEvent', iptrw);
      RegisterPublishedProperties;

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

  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_dblookup(CL: TPSPascalCompiler);
begin
  CL.AddClassN(CL.FindClass('TOBJECT'),'TPopupGrid');
  CL.AddTypeS('TDBLookupComboStyle', '( csDropDown, csDropDownList )');
  CL.AddTypeS('TDBLookupListOption', '( loColLines, loRowLines, loTitles )');
  CL.AddTypeS('TDBLookupListOptions', 'set of TDBLookupListOption');
  SIRegister_TDBLookupCombo(CL);
  SIRegister_TDBLookupList(CL);
  SIRegister_TPopupGrid(CL);
  SIRegister_TComboButton(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TDBLookupListReadOnly_W(Self: TDBLookupList; const T: Boolean);
begin Self.ReadOnly := T; end;

(*----------------------------------------------------------------------------*)
procedure TDBLookupListReadOnly_R(Self: TDBLookupList; var T: Boolean);
begin T := Self.ReadOnly; end;

(*----------------------------------------------------------------------------*)
procedure TDBLookupListOnClick_W(Self: TDBLookupList; const T: TNotifyEvent);
begin Self.OnClick := T; end;

(*----------------------------------------------------------------------------*)
procedure TDBLookupListOnClick_R(Self: TDBLookupList; var T: TNotifyEvent);
begin T := Self.OnClick; end;

(*----------------------------------------------------------------------------*)
procedure TDBLookupListOptions_W(Self: TDBLookupList; const T: TDBLookupListOptions);
begin Self.Options := T; end;

(*----------------------------------------------------------------------------*)
procedure TDBLookupListOptions_R(Self: TDBLookupList; var T: TDBLookupListOptions);
begin T := Self.Options; end;

(*----------------------------------------------------------------------------*)
procedure TDBLookupListLookupField_W(Self: TDBLookupList; const T: string);
begin Self.LookupField := T; end;

(*----------------------------------------------------------------------------*)
procedure TDBLookupListLookupField_R(Self: TDBLookupList; var T: string);
begin T := Self.LookupField; end;

(*----------------------------------------------------------------------------*)
procedure TDBLookupListLookupDisplay_W(Self: TDBLookupList; const T: string);
begin Self.LookupDisplay := T; end;

(*----------------------------------------------------------------------------*)
procedure TDBLookupListLookupDisplay_R(Self: TDBLookupList; var T: string);
begin T := Self.LookupDisplay; end;

(*----------------------------------------------------------------------------*)
procedure TDBLookupListLookupSource_W(Self: TDBLookupList; const T: TDataSource);
begin Self.LookupSource := T; end;

(*----------------------------------------------------------------------------*)
procedure TDBLookupListLookupSource_R(Self: TDBLookupList; var T: TDataSource);
begin T := Self.LookupSource; end;

(*----------------------------------------------------------------------------*)
procedure TDBLookupListDataSource_W(Self: TDBLookupList; const T: TDataSource);
begin Self.DataSource := T; end;

(*----------------------------------------------------------------------------*)
procedure TDBLookupListDataSource_R(Self: TDBLookupList; var T: TDataSource);
begin T := Self.DataSource; end;

(*----------------------------------------------------------------------------*)
procedure TDBLookupListDataField_W(Self: TDBLookupList; const T: string);
begin Self.DataField := T; end;

(*----------------------------------------------------------------------------*)
procedure TDBLookupListDataField_R(Self: TDBLookupList; var T: string);
begin T := Self.DataField; end;

(*----------------------------------------------------------------------------*)
procedure TDBLookupListDisplayValue_W(Self: TDBLookupList; const T: string);
begin Self.DisplayValue := T; end;

(*----------------------------------------------------------------------------*)
procedure TDBLookupListDisplayValue_R(Self: TDBLookupList; var T: string);
begin T := Self.DisplayValue; end;

(*----------------------------------------------------------------------------*)
procedure TDBLookupListValue_W(Self: TDBLookupList; const T: string);
begin Self.Value := T; end;

(*----------------------------------------------------------------------------*)
procedure TDBLookupListValue_R(Self: TDBLookupList; var T: string);
begin T := Self.Value; end;

(*----------------------------------------------------------------------------*)
procedure TDBLookupComboOnDropDown_W(Self: TDBLookupCombo; const T: TNotifyEvent);
begin Self.OnDropDown := T; end;

(*----------------------------------------------------------------------------*)
procedure TDBLookupComboOnDropDown_R(Self: TDBLookupCombo; var T: TNotifyEvent);
begin T := Self.OnDropDown; end;

(*----------------------------------------------------------------------------*)
procedure TDBLookupComboReadOnly_W(Self: TDBLookupCombo; const T: Boolean);
begin Self.ReadOnly := T; end;

(*----------------------------------------------------------------------------*)
procedure TDBLookupComboReadOnly_R(Self: TDBLookupCombo; var T: Boolean);
begin T := Self.ReadOnly; end;

(*----------------------------------------------------------------------------*)
procedure TDBLookupComboDropDownWidth_W(Self: TDBLookupCombo; const T: Integer);
begin Self.DropDownWidth := T; end;

(*----------------------------------------------------------------------------*)
procedure TDBLookupComboDropDownWidth_R(Self: TDBLookupCombo; var T: Integer);
begin T := Self.DropDownWidth; end;

(*----------------------------------------------------------------------------*)
procedure TDBLookupComboDropDownCount_W(Self: TDBLookupCombo; const T: Integer);
begin Self.DropDownCount := T; end;

(*----------------------------------------------------------------------------*)
procedure TDBLookupComboDropDownCount_R(Self: TDBLookupCombo; var T: Integer);
begin T := Self.DropDownCount; end;

(*----------------------------------------------------------------------------*)
procedure TDBLookupComboStyle_W(Self: TDBLookupCombo; const T: TDBLookupComboStyle);
begin Self.Style := T; end;

(*----------------------------------------------------------------------------*)
procedure TDBLookupComboStyle_R(Self: TDBLookupCombo; var T: TDBLookupComboStyle);
begin T := Self.Style; end;

(*----------------------------------------------------------------------------*)
procedure TDBLookupComboOptions_W(Self: TDBLookupCombo; const T: TDBLookupListOptions);
begin Self.Options := T; end;

(*----------------------------------------------------------------------------*)
procedure TDBLookupComboOptions_R(Self: TDBLookupCombo; var T: TDBLookupListOptions);
begin T := Self.Options; end;

(*----------------------------------------------------------------------------*)
procedure TDBLookupComboLookupField_W(Self: TDBLookupCombo; const T: string);
begin Self.LookupField := T; end;

(*----------------------------------------------------------------------------*)
procedure TDBLookupComboLookupField_R(Self: TDBLookupCombo; var T: string);
begin T := Self.LookupField; end;

(*----------------------------------------------------------------------------*)
procedure TDBLookupComboLookupDisplay_W(Self: TDBLookupCombo; const T: string);
begin Self.LookupDisplay := T; end;

(*----------------------------------------------------------------------------*)
procedure TDBLookupComboLookupDisplay_R(Self: TDBLookupCombo; var T: string);
begin T := Self.LookupDisplay; end;

(*----------------------------------------------------------------------------*)
procedure TDBLookupComboLookupSource_W(Self: TDBLookupCombo; const T: TDataSource);
begin Self.LookupSource := T; end;

(*----------------------------------------------------------------------------*)
procedure TDBLookupComboLookupSource_R(Self: TDBLookupCombo; var T: TDataSource);
begin T := Self.LookupSource; end;

(*----------------------------------------------------------------------------*)
procedure TDBLookupComboDataSource_W(Self: TDBLookupCombo; const T: TDataSource);
begin Self.DataSource := T; end;

(*----------------------------------------------------------------------------*)
procedure TDBLookupComboDataSource_R(Self: TDBLookupCombo; var T: TDataSource);
begin T := Self.DataSource; end;

(*----------------------------------------------------------------------------*)
procedure TDBLookupComboDataField_W(Self: TDBLookupCombo; const T: string);
begin Self.DataField := T; end;

(*----------------------------------------------------------------------------*)
procedure TDBLookupComboDataField_R(Self: TDBLookupCombo; var T: string);
begin T := Self.DataField; end;

(*----------------------------------------------------------------------------*)
procedure TDBLookupComboDisplayValue_W(Self: TDBLookupCombo; const T: string);
begin Self.DisplayValue := T; end;

(*----------------------------------------------------------------------------*)
procedure TDBLookupComboDisplayValue_R(Self: TDBLookupCombo; var T: string);
begin T := Self.DisplayValue; end;

(*----------------------------------------------------------------------------*)
procedure TDBLookupComboValue_W(Self: TDBLookupCombo; const T: string);
begin Self.Value := T; end;

(*----------------------------------------------------------------------------*)
procedure TDBLookupComboValue_R(Self: TDBLookupCombo; var T: string);
begin T := Self.Value; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TComboButton(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TComboButton) do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TPopupGrid(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TPopupGrid) do
  begin
    RegisterConstructor(@TPopupGrid.Create, 'Create');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TDBLookupList(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TDBLookupList) do begin
    RegisterConstructor(@TDBLookupList.Create, 'Create');
               RegisterMethod(@TDBLookupList.Destroy, 'Free');
      RegisterPropertyHelper(@TDBLookupListValue_R,@TDBLookupListValue_W,'Value');
    RegisterPropertyHelper(@TDBLookupListDisplayValue_R,@TDBLookupListDisplayValue_W,'DisplayValue');
    RegisterPropertyHelper(@TDBLookupListDataField_R,@TDBLookupListDataField_W,'DataField');
    RegisterPropertyHelper(@TDBLookupListDataSource_R,@TDBLookupListDataSource_W,'DataSource');
    RegisterPropertyHelper(@TDBLookupListLookupSource_R,@TDBLookupListLookupSource_W,'LookupSource');
    RegisterPropertyHelper(@TDBLookupListLookupDisplay_R,@TDBLookupListLookupDisplay_W,'LookupDisplay');
    RegisterPropertyHelper(@TDBLookupListLookupField_R,@TDBLookupListLookupField_W,'LookupField');
    RegisterPropertyHelper(@TDBLookupListOptions_R,@TDBLookupListOptions_W,'Options');
    RegisterPropertyHelper(@TDBLookupListOnClick_R,@TDBLookupListOnClick_W,'OnClick');
    RegisterPropertyHelper(@TDBLookupListReadOnly_R,@TDBLookupListReadOnly_W,'ReadOnly');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TDBLookupCombo(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TDBLookupCombo) do begin
    RegisterConstructor(@TDBLookupCombo.Create, 'Create');
              RegisterMethod(@TDBLookupCombo.Destroy, 'Free');
      RegisterVirtualMethod(@TDBLookupCombo.DropDown, 'DropDown');
    RegisterVirtualMethod(@TDBLookupCombo.CloseUp, 'CloseUp');
    RegisterPropertyHelper(@TDBLookupComboValue_R,@TDBLookupComboValue_W,'Value');
    RegisterPropertyHelper(@TDBLookupComboDisplayValue_R,@TDBLookupComboDisplayValue_W,'DisplayValue');
    RegisterPropertyHelper(@TDBLookupComboDataField_R,@TDBLookupComboDataField_W,'DataField');
    RegisterPropertyHelper(@TDBLookupComboDataSource_R,@TDBLookupComboDataSource_W,'DataSource');
    RegisterPropertyHelper(@TDBLookupComboLookupSource_R,@TDBLookupComboLookupSource_W,'LookupSource');
    RegisterPropertyHelper(@TDBLookupComboLookupDisplay_R,@TDBLookupComboLookupDisplay_W,'LookupDisplay');
    RegisterPropertyHelper(@TDBLookupComboLookupField_R,@TDBLookupComboLookupField_W,'LookupField');
    RegisterPropertyHelper(@TDBLookupComboOptions_R,@TDBLookupComboOptions_W,'Options');
    RegisterPropertyHelper(@TDBLookupComboStyle_R,@TDBLookupComboStyle_W,'Style');
    RegisterPropertyHelper(@TDBLookupComboDropDownCount_R,@TDBLookupComboDropDownCount_W,'DropDownCount');
    RegisterPropertyHelper(@TDBLookupComboDropDownWidth_R,@TDBLookupComboDropDownWidth_W,'DropDownWidth');
    RegisterPropertyHelper(@TDBLookupComboReadOnly_R,@TDBLookupComboReadOnly_W,'ReadOnly');
    RegisterPropertyHelper(@TDBLookupComboOnDropDown_R,@TDBLookupComboOnDropDown_W,'OnDropDown');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_dblookup(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TPopupGrid) do
  RIRegister_TDBLookupCombo(CL);
  RIRegister_TDBLookupList(CL);
  RIRegister_TPopupGrid(CL);
  RIRegister_TComboButton(CL);
end;

 
 
{ TPSImport_dblookup }
(*----------------------------------------------------------------------------*)
procedure TPSImport_dblookup.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_dblookup(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_dblookup.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_dblookup(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
