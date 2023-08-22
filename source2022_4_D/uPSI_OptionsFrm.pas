unit uPSI_OptionsFrm;
{
    ftl formtemplatelibrary
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
  TPSImport_OptionsFrm = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TfrmOptions(CL: TPSPascalCompiler);
procedure SIRegister_OptionsFrm(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TfrmOptions(CL: TPSRuntimeClassImporter);
procedure RIRegister_OptionsFrm(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   Windows
  ,Messages
  ,Graphics
  ,Controls
  ,Forms
  ,Dialogs
  ,StdCtrls
  ,JvCombobox
  ,JvColorCombo
  ,ComCtrls
  ,ActnList
  ,ExtCtrls
  ,JvBaseDlg
  ,JvBrowseFolder
  ,PersistForm
  ,PersistSettings
  ,Menus
  ,JvComponent
  ,OptionsFrm
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_OptionsFrm]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TfrmOptions(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TfrmPersistable', 'TfrmOptions') do
  with CL.AddClassN(CL.FindClass('TfrmPersistable'),'TfrmOptions') do begin
    RegisterProperty('btnOK', 'TButton', iptrw);
    RegisterProperty('btnCancel', 'TButton', iptrw);
    RegisterProperty('pcOptions', 'TPageControl', iptrw);
    RegisterProperty('tabGeneral', 'TTabSheet', iptrw);
    RegisterProperty('tabPaths', 'TTabSheet', iptrw);
    RegisterProperty('lvPaths', 'TListView', iptrw);
    RegisterProperty('edLibPath', 'TEdit', iptrw);
    RegisterProperty('btnPathBrowse', 'TButton', iptrw);
    RegisterProperty('btnReplace', 'TButton', iptrw);
    RegisterProperty('btnAdd', 'TButton', iptrw);
    RegisterProperty('btnDelete', 'TButton', iptrw);
    RegisterProperty('alOptions', 'TActionList', iptrw);
    RegisterProperty('Label9', 'TLabel', iptrw);
    RegisterProperty('JvBrowseFolder1', 'TJvBrowseForFolderDialog', iptrw);
    RegisterProperty('acReplace', 'TAction', iptrw);
    RegisterProperty('acAdd', 'TAction', iptrw);
    RegisterProperty('acDelete', 'TAction', iptrw);
    RegisterProperty('acBrowse', 'TAction', iptrw);
    RegisterProperty('popPaths', 'TPopupMenu', iptrw);
    RegisterProperty('acDelInvalidPaths', 'TAction', iptrw);
    RegisterProperty('acGetD5Path', 'TAction', iptrw);
    RegisterProperty('acGetD6Path', 'TAction', iptrw);
    RegisterProperty('acGetD7Path', 'TAction', iptrw);
    RegisterProperty('acGetBCB5Path', 'TAction', iptrw);
    RegisterProperty('acGetBCB6Path', 'TAction', iptrw);
    RegisterProperty('Add1', 'TMenuItem', iptrw);
    RegisterProperty('Replace1', 'TMenuItem', iptrw);
    RegisterProperty('Delete1', 'TMenuItem', iptrw);
    RegisterProperty('N1', 'TMenuItem', iptrw);
    RegisterProperty('InsertLibraryPath1', 'TMenuItem', iptrw);
    RegisterProperty('CBuilder51', 'TMenuItem', iptrw);
    RegisterProperty('CBuilder61', 'TMenuItem', iptrw);
    RegisterProperty('N2', 'TMenuItem', iptrw);
    RegisterProperty('Delphi51', 'TMenuItem', iptrw);
    RegisterProperty('Delphi61', 'TMenuItem', iptrw);
    RegisterProperty('Delphi71', 'TMenuItem', iptrw);
    RegisterProperty('DeleteInvalidPaths1', 'TMenuItem', iptrw);
    RegisterProperty('gbConnectors', 'TGroupBox', iptrw);
    RegisterProperty('Label3', 'TLabel', iptrw);
    RegisterProperty('Label4', 'TLabel', iptrw);
    RegisterProperty('Label5', 'TLabel', iptrw);
    RegisterProperty('Label6', 'TLabel', iptrw);
    RegisterProperty('Label7', 'TLabel', iptrw);
    RegisterProperty('Label8', 'TLabel', iptrw);
    RegisterProperty('cbIntfColor', 'TJvColorComboBox', iptrw);
    RegisterProperty('cbIntfSelColor', 'TJvColorComboBox', iptrw);
    RegisterProperty('cbImplColor', 'TJvColorComboBox', iptrw);
    RegisterProperty('cbImplSelColor', 'TJvColorComboBox', iptrw);
    RegisterProperty('acSystemPath', 'TAction', iptrw);
    RegisterProperty('N3', 'TMenuItem', iptrw);
    RegisterProperty('SystemPath1', 'TMenuItem', iptrw);
    RegisterProperty('acSelectAll', 'TAction', iptrw);
    RegisterProperty('acInvertSelect', 'TAction', iptrw);
    RegisterProperty('acUnselectAll', 'TAction', iptrw);
    RegisterProperty('Select1', 'TMenuItem', iptrw);
    RegisterProperty('SelectAll1', 'TMenuItem', iptrw);
    RegisterProperty('UnselectAll1', 'TMenuItem', iptrw);
    RegisterProperty('InvertSelection1', 'TMenuItem', iptrw);
    RegisterProperty('N4', 'TMenuItem', iptrw);
    RegisterProperty('gbShapes', 'TGroupBox', iptrw);
    RegisterProperty('edShapeWidth', 'TEdit', iptrw);
    RegisterProperty('edShapeHeight', 'TEdit', iptrw);
    RegisterProperty('Label1', 'TLabel', iptrw);
    RegisterProperty('Label2', 'TLabel', iptrw);
    RegisterMethod('Constructor Create(AOwner: TComponent)');
    //RegisterMethod('Procedure FormCreate( Sender : TObject)');
    RegisterMethod('Procedure acBrowseExecute( Sender : TObject)');
    RegisterMethod('Procedure acAddExecute( Sender : TObject)');
    RegisterMethod('Procedure acReplaceExecute( Sender : TObject)');
    RegisterMethod('Procedure acDeleteExecute( Sender : TObject)');
    RegisterMethod('Procedure alOptionsUpdate( Action : TBasicAction; var Handled : Boolean)');
    RegisterMethod('Procedure acGetD5PathExecute( Sender : TObject)');
    RegisterMethod('Procedure acGetD6PathExecute( Sender : TObject)');
    RegisterMethod('Procedure acGetD7PathExecute( Sender : TObject)');
    RegisterMethod('Procedure acGetBCB5PathExecute( Sender : TObject)');
    RegisterMethod('Procedure acGetBCB6PathExecute( Sender : TObject)');
    RegisterMethod('Procedure acDelInvalidPathsExecute( Sender : TObject)');
    RegisterMethod('Procedure lvPathsSelectItem( Sender : TObject; Item : TListItem; Selected : Boolean)');
    RegisterMethod('Procedure lvPathsEnter( Sender : TObject)');
    RegisterMethod('Procedure tabPathsShow( Sender : TObject)');
    RegisterMethod('Procedure FormCreate( Sender : TObject)');
    RegisterMethod('Procedure acSystemPathExecute( Sender : TObject)');
    RegisterMethod('Procedure acSelectAllExecute( Sender : TObject)');
    RegisterMethod('Procedure acInvertSelectExecute( Sender : TObject)');
    RegisterMethod('Procedure acUnselectAllExecute( Sender : TObject)');
    RegisterMethod('Function Execute : boolean');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_OptionsFrm(CL: TPSPascalCompiler);
begin
  SIRegister_TfrmOptions(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TfrmOptionsLabel2_W(Self: TfrmOptions; const T: TLabel);
Begin Self.Label2 := T; end;

(*----------------------------------------------------------------------------*)
procedure TfrmOptionsLabel2_R(Self: TfrmOptions; var T: TLabel);
Begin T := Self.Label2; end;

(*----------------------------------------------------------------------------*)
procedure TfrmOptionsLabel1_W(Self: TfrmOptions; const T: TLabel);
Begin Self.Label1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TfrmOptionsLabel1_R(Self: TfrmOptions; var T: TLabel);
Begin T := Self.Label1; end;

(*----------------------------------------------------------------------------*)
procedure TfrmOptionsedShapeHeight_W(Self: TfrmOptions; const T: TEdit);
Begin Self.edShapeHeight := T; end;

(*----------------------------------------------------------------------------*)
procedure TfrmOptionsedShapeHeight_R(Self: TfrmOptions; var T: TEdit);
Begin T := Self.edShapeHeight; end;

(*----------------------------------------------------------------------------*)
procedure TfrmOptionsedShapeWidth_W(Self: TfrmOptions; const T: TEdit);
Begin Self.edShapeWidth := T; end;

(*----------------------------------------------------------------------------*)
procedure TfrmOptionsedShapeWidth_R(Self: TfrmOptions; var T: TEdit);
Begin T := Self.edShapeWidth; end;

(*----------------------------------------------------------------------------*)
procedure TfrmOptionsgbShapes_W(Self: TfrmOptions; const T: TGroupBox);
Begin Self.gbShapes := T; end;

(*----------------------------------------------------------------------------*)
procedure TfrmOptionsgbShapes_R(Self: TfrmOptions; var T: TGroupBox);
Begin T := Self.gbShapes; end;

(*----------------------------------------------------------------------------*)
procedure TfrmOptionsN4_W(Self: TfrmOptions; const T: TMenuItem);
Begin Self.N4 := T; end;

(*----------------------------------------------------------------------------*)
procedure TfrmOptionsN4_R(Self: TfrmOptions; var T: TMenuItem);
Begin T := Self.N4; end;

(*----------------------------------------------------------------------------*)
procedure TfrmOptionsInvertSelection1_W(Self: TfrmOptions; const T: TMenuItem);
Begin Self.InvertSelection1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TfrmOptionsInvertSelection1_R(Self: TfrmOptions; var T: TMenuItem);
Begin T := Self.InvertSelection1; end;

(*----------------------------------------------------------------------------*)
procedure TfrmOptionsUnselectAll1_W(Self: TfrmOptions; const T: TMenuItem);
Begin Self.UnselectAll1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TfrmOptionsUnselectAll1_R(Self: TfrmOptions; var T: TMenuItem);
Begin T := Self.UnselectAll1; end;

(*----------------------------------------------------------------------------*)
procedure TfrmOptionsSelectAll1_W(Self: TfrmOptions; const T: TMenuItem);
Begin Self.SelectAll1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TfrmOptionsSelectAll1_R(Self: TfrmOptions; var T: TMenuItem);
Begin T := Self.SelectAll1; end;

(*----------------------------------------------------------------------------*)
procedure TfrmOptionsSelect1_W(Self: TfrmOptions; const T: TMenuItem);
Begin Self.Select1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TfrmOptionsSelect1_R(Self: TfrmOptions; var T: TMenuItem);
Begin T := Self.Select1; end;

(*----------------------------------------------------------------------------*)
procedure TfrmOptionsacUnselectAll_W(Self: TfrmOptions; const T: TAction);
Begin Self.acUnselectAll := T; end;

(*----------------------------------------------------------------------------*)
procedure TfrmOptionsacUnselectAll_R(Self: TfrmOptions; var T: TAction);
Begin T := Self.acUnselectAll; end;

(*----------------------------------------------------------------------------*)
procedure TfrmOptionsacInvertSelect_W(Self: TfrmOptions; const T: TAction);
Begin Self.acInvertSelect := T; end;

(*----------------------------------------------------------------------------*)
procedure TfrmOptionsacInvertSelect_R(Self: TfrmOptions; var T: TAction);
Begin T := Self.acInvertSelect; end;

(*----------------------------------------------------------------------------*)
procedure TfrmOptionsacSelectAll_W(Self: TfrmOptions; const T: TAction);
Begin Self.acSelectAll := T; end;

(*----------------------------------------------------------------------------*)
procedure TfrmOptionsacSelectAll_R(Self: TfrmOptions; var T: TAction);
Begin T := Self.acSelectAll; end;

(*----------------------------------------------------------------------------*)
procedure TfrmOptionsSystemPath1_W(Self: TfrmOptions; const T: TMenuItem);
Begin Self.SystemPath1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TfrmOptionsSystemPath1_R(Self: TfrmOptions; var T: TMenuItem);
Begin T := Self.SystemPath1; end;

(*----------------------------------------------------------------------------*)
procedure TfrmOptionsN3_W(Self: TfrmOptions; const T: TMenuItem);
Begin Self.N3 := T; end;

(*----------------------------------------------------------------------------*)
procedure TfrmOptionsN3_R(Self: TfrmOptions; var T: TMenuItem);
Begin T := Self.N3; end;

(*----------------------------------------------------------------------------*)
procedure TfrmOptionsacSystemPath_W(Self: TfrmOptions; const T: TAction);
Begin Self.acSystemPath := T; end;

(*----------------------------------------------------------------------------*)
procedure TfrmOptionsacSystemPath_R(Self: TfrmOptions; var T: TAction);
Begin T := Self.acSystemPath; end;

(*----------------------------------------------------------------------------*)
procedure TfrmOptionscbImplSelColor_W(Self: TfrmOptions; const T: TJvColorComboBox);
Begin Self.cbImplSelColor := T; end;

(*----------------------------------------------------------------------------*)
procedure TfrmOptionscbImplSelColor_R(Self: TfrmOptions; var T: TJvColorComboBox);
Begin T := Self.cbImplSelColor; end;

(*----------------------------------------------------------------------------*)
procedure TfrmOptionscbImplColor_W(Self: TfrmOptions; const T: TJvColorComboBox);
Begin Self.cbImplColor := T; end;

(*----------------------------------------------------------------------------*)
procedure TfrmOptionscbImplColor_R(Self: TfrmOptions; var T: TJvColorComboBox);
Begin T := Self.cbImplColor; end;

(*----------------------------------------------------------------------------*)
procedure TfrmOptionscbIntfSelColor_W(Self: TfrmOptions; const T: TJvColorComboBox);
Begin Self.cbIntfSelColor := T; end;

(*----------------------------------------------------------------------------*)
procedure TfrmOptionscbIntfSelColor_R(Self: TfrmOptions; var T: TJvColorComboBox);
Begin T := Self.cbIntfSelColor; end;

(*----------------------------------------------------------------------------*)
procedure TfrmOptionscbIntfColor_W(Self: TfrmOptions; const T: TJvColorComboBox);
Begin Self.cbIntfColor := T; end;

(*----------------------------------------------------------------------------*)
procedure TfrmOptionscbIntfColor_R(Self: TfrmOptions; var T: TJvColorComboBox);
Begin T := Self.cbIntfColor; end;

(*----------------------------------------------------------------------------*)
procedure TfrmOptionsLabel8_W(Self: TfrmOptions; const T: TLabel);
Begin Self.Label8 := T; end;

(*----------------------------------------------------------------------------*)
procedure TfrmOptionsLabel8_R(Self: TfrmOptions; var T: TLabel);
Begin T := Self.Label8; end;

(*----------------------------------------------------------------------------*)
procedure TfrmOptionsLabel7_W(Self: TfrmOptions; const T: TLabel);
Begin Self.Label7 := T; end;

(*----------------------------------------------------------------------------*)
procedure TfrmOptionsLabel7_R(Self: TfrmOptions; var T: TLabel);
Begin T := Self.Label7; end;

(*----------------------------------------------------------------------------*)
procedure TfrmOptionsLabel6_W(Self: TfrmOptions; const T: TLabel);
Begin Self.Label6 := T; end;

(*----------------------------------------------------------------------------*)
procedure TfrmOptionsLabel6_R(Self: TfrmOptions; var T: TLabel);
Begin T := Self.Label6; end;

(*----------------------------------------------------------------------------*)
procedure TfrmOptionsLabel5_W(Self: TfrmOptions; const T: TLabel);
Begin Self.Label5 := T; end;

(*----------------------------------------------------------------------------*)
procedure TfrmOptionsLabel5_R(Self: TfrmOptions; var T: TLabel);
Begin T := Self.Label5; end;

(*----------------------------------------------------------------------------*)
procedure TfrmOptionsLabel4_W(Self: TfrmOptions; const T: TLabel);
Begin Self.Label4 := T; end;

(*----------------------------------------------------------------------------*)
procedure TfrmOptionsLabel4_R(Self: TfrmOptions; var T: TLabel);
Begin T := Self.Label4; end;

(*----------------------------------------------------------------------------*)
procedure TfrmOptionsLabel3_W(Self: TfrmOptions; const T: TLabel);
Begin Self.Label3 := T; end;

(*----------------------------------------------------------------------------*)
procedure TfrmOptionsLabel3_R(Self: TfrmOptions; var T: TLabel);
Begin T := Self.Label3; end;

(*----------------------------------------------------------------------------*)
procedure TfrmOptionsgbConnectors_W(Self: TfrmOptions; const T: TGroupBox);
Begin Self.gbConnectors := T; end;

(*----------------------------------------------------------------------------*)
procedure TfrmOptionsgbConnectors_R(Self: TfrmOptions; var T: TGroupBox);
Begin T := Self.gbConnectors; end;

(*----------------------------------------------------------------------------*)
procedure TfrmOptionsDeleteInvalidPaths1_W(Self: TfrmOptions; const T: TMenuItem);
Begin Self.DeleteInvalidPaths1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TfrmOptionsDeleteInvalidPaths1_R(Self: TfrmOptions; var T: TMenuItem);
Begin T := Self.DeleteInvalidPaths1; end;

(*----------------------------------------------------------------------------*)
procedure TfrmOptionsDelphi71_W(Self: TfrmOptions; const T: TMenuItem);
Begin Self.Delphi71 := T; end;

(*----------------------------------------------------------------------------*)
procedure TfrmOptionsDelphi71_R(Self: TfrmOptions; var T: TMenuItem);
Begin T := Self.Delphi71; end;

(*----------------------------------------------------------------------------*)
procedure TfrmOptionsDelphi61_W(Self: TfrmOptions; const T: TMenuItem);
Begin Self.Delphi61 := T; end;

(*----------------------------------------------------------------------------*)
procedure TfrmOptionsDelphi61_R(Self: TfrmOptions; var T: TMenuItem);
Begin T := Self.Delphi61; end;

(*----------------------------------------------------------------------------*)
procedure TfrmOptionsDelphi51_W(Self: TfrmOptions; const T: TMenuItem);
Begin Self.Delphi51 := T; end;

(*----------------------------------------------------------------------------*)
procedure TfrmOptionsDelphi51_R(Self: TfrmOptions; var T: TMenuItem);
Begin T := Self.Delphi51; end;

(*----------------------------------------------------------------------------*)
procedure TfrmOptionsN2_W(Self: TfrmOptions; const T: TMenuItem);
Begin Self.N2 := T; end;

(*----------------------------------------------------------------------------*)
procedure TfrmOptionsN2_R(Self: TfrmOptions; var T: TMenuItem);
Begin T := Self.N2; end;

(*----------------------------------------------------------------------------*)
procedure TfrmOptionsCBuilder61_W(Self: TfrmOptions; const T: TMenuItem);
Begin Self.CBuilder61 := T; end;

(*----------------------------------------------------------------------------*)
procedure TfrmOptionsCBuilder61_R(Self: TfrmOptions; var T: TMenuItem);
Begin T := Self.CBuilder61; end;

(*----------------------------------------------------------------------------*)
procedure TfrmOptionsCBuilder51_W(Self: TfrmOptions; const T: TMenuItem);
Begin Self.CBuilder51 := T; end;

(*----------------------------------------------------------------------------*)
procedure TfrmOptionsCBuilder51_R(Self: TfrmOptions; var T: TMenuItem);
Begin T := Self.CBuilder51; end;

(*----------------------------------------------------------------------------*)
procedure TfrmOptionsInsertLibraryPath1_W(Self: TfrmOptions; const T: TMenuItem);
Begin Self.InsertLibraryPath1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TfrmOptionsInsertLibraryPath1_R(Self: TfrmOptions; var T: TMenuItem);
Begin T := Self.InsertLibraryPath1; end;

(*----------------------------------------------------------------------------*)
procedure TfrmOptionsN1_W(Self: TfrmOptions; const T: TMenuItem);
Begin Self.N1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TfrmOptionsN1_R(Self: TfrmOptions; var T: TMenuItem);
Begin T := Self.N1; end;

(*----------------------------------------------------------------------------*)
procedure TfrmOptionsDelete1_W(Self: TfrmOptions; const T: TMenuItem);
Begin Self.Delete1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TfrmOptionsDelete1_R(Self: TfrmOptions; var T: TMenuItem);
Begin T := Self.Delete1; end;

(*----------------------------------------------------------------------------*)
procedure TfrmOptionsReplace1_W(Self: TfrmOptions; const T: TMenuItem);
Begin Self.Replace1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TfrmOptionsReplace1_R(Self: TfrmOptions; var T: TMenuItem);
Begin T := Self.Replace1; end;

(*----------------------------------------------------------------------------*)
procedure TfrmOptionsAdd1_W(Self: TfrmOptions; const T: TMenuItem);
Begin Self.Add1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TfrmOptionsAdd1_R(Self: TfrmOptions; var T: TMenuItem);
Begin T := Self.Add1; end;

(*----------------------------------------------------------------------------*)
procedure TfrmOptionsacGetBCB6Path_W(Self: TfrmOptions; const T: TAction);
Begin Self.acGetBCB6Path := T; end;

(*----------------------------------------------------------------------------*)
procedure TfrmOptionsacGetBCB6Path_R(Self: TfrmOptions; var T: TAction);
Begin T := Self.acGetBCB6Path; end;

(*----------------------------------------------------------------------------*)
procedure TfrmOptionsacGetBCB5Path_W(Self: TfrmOptions; const T: TAction);
Begin Self.acGetBCB5Path := T; end;

(*----------------------------------------------------------------------------*)
procedure TfrmOptionsacGetBCB5Path_R(Self: TfrmOptions; var T: TAction);
Begin T := Self.acGetBCB5Path; end;

(*----------------------------------------------------------------------------*)
procedure TfrmOptionsacGetD7Path_W(Self: TfrmOptions; const T: TAction);
Begin Self.acGetD7Path := T; end;

(*----------------------------------------------------------------------------*)
procedure TfrmOptionsacGetD7Path_R(Self: TfrmOptions; var T: TAction);
Begin T := Self.acGetD7Path; end;

(*----------------------------------------------------------------------------*)
procedure TfrmOptionsacGetD6Path_W(Self: TfrmOptions; const T: TAction);
Begin Self.acGetD6Path := T; end;

(*----------------------------------------------------------------------------*)
procedure TfrmOptionsacGetD6Path_R(Self: TfrmOptions; var T: TAction);
Begin T := Self.acGetD6Path; end;

(*----------------------------------------------------------------------------*)
procedure TfrmOptionsacGetD5Path_W(Self: TfrmOptions; const T: TAction);
Begin Self.acGetD5Path := T; end;

(*----------------------------------------------------------------------------*)
procedure TfrmOptionsacGetD5Path_R(Self: TfrmOptions; var T: TAction);
Begin T := Self.acGetD5Path; end;

(*----------------------------------------------------------------------------*)
procedure TfrmOptionsacDelInvalidPaths_W(Self: TfrmOptions; const T: TAction);
Begin Self.acDelInvalidPaths := T; end;

(*----------------------------------------------------------------------------*)
procedure TfrmOptionsacDelInvalidPaths_R(Self: TfrmOptions; var T: TAction);
Begin T := Self.acDelInvalidPaths; end;

(*----------------------------------------------------------------------------*)
procedure TfrmOptionspopPaths_W(Self: TfrmOptions; const T: TPopupMenu);
Begin Self.popPaths := T; end;

(*----------------------------------------------------------------------------*)
procedure TfrmOptionspopPaths_R(Self: TfrmOptions; var T: TPopupMenu);
Begin T := Self.popPaths; end;

(*----------------------------------------------------------------------------*)
procedure TfrmOptionsacBrowse_W(Self: TfrmOptions; const T: TAction);
Begin Self.acBrowse := T; end;

(*----------------------------------------------------------------------------*)
procedure TfrmOptionsacBrowse_R(Self: TfrmOptions; var T: TAction);
Begin T := Self.acBrowse; end;

(*----------------------------------------------------------------------------*)
procedure TfrmOptionsacDelete_W(Self: TfrmOptions; const T: TAction);
Begin Self.acDelete := T; end;

(*----------------------------------------------------------------------------*)
procedure TfrmOptionsacDelete_R(Self: TfrmOptions; var T: TAction);
Begin T := Self.acDelete; end;

(*----------------------------------------------------------------------------*)
procedure TfrmOptionsacAdd_W(Self: TfrmOptions; const T: TAction);
Begin Self.acAdd := T; end;

(*----------------------------------------------------------------------------*)
procedure TfrmOptionsacAdd_R(Self: TfrmOptions; var T: TAction);
Begin T := Self.acAdd; end;

(*----------------------------------------------------------------------------*)
procedure TfrmOptionsacReplace_W(Self: TfrmOptions; const T: TAction);
Begin Self.acReplace := T; end;

(*----------------------------------------------------------------------------*)
procedure TfrmOptionsacReplace_R(Self: TfrmOptions; var T: TAction);
Begin T := Self.acReplace; end;

(*----------------------------------------------------------------------------*)
procedure TfrmOptionsJvBrowseFolder1_W(Self: TfrmOptions; const T: TJvBrowseForFolderDialog);
Begin Self.JvBrowseFolder1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TfrmOptionsJvBrowseFolder1_R(Self: TfrmOptions; var T: TJvBrowseForFolderDialog);
Begin T := Self.JvBrowseFolder1; end;

(*----------------------------------------------------------------------------*)
procedure TfrmOptionsLabel9_W(Self: TfrmOptions; const T: TLabel);
Begin Self.Label9 := T; end;

(*----------------------------------------------------------------------------*)
procedure TfrmOptionsLabel9_R(Self: TfrmOptions; var T: TLabel);
Begin T := Self.Label9; end;

(*----------------------------------------------------------------------------*)
procedure TfrmOptionsalOptions_W(Self: TfrmOptions; const T: TActionList);
Begin Self.alOptions := T; end;

(*----------------------------------------------------------------------------*)
procedure TfrmOptionsalOptions_R(Self: TfrmOptions; var T: TActionList);
Begin T := Self.alOptions; end;

(*----------------------------------------------------------------------------*)
procedure TfrmOptionsbtnDelete_W(Self: TfrmOptions; const T: TButton);
Begin Self.btnDelete := T; end;

(*----------------------------------------------------------------------------*)
procedure TfrmOptionsbtnDelete_R(Self: TfrmOptions; var T: TButton);
Begin T := Self.btnDelete; end;

(*----------------------------------------------------------------------------*)
procedure TfrmOptionsbtnAdd_W(Self: TfrmOptions; const T: TButton);
Begin Self.btnAdd := T; end;

(*----------------------------------------------------------------------------*)
procedure TfrmOptionsbtnAdd_R(Self: TfrmOptions; var T: TButton);
Begin T := Self.btnAdd; end;

(*----------------------------------------------------------------------------*)
procedure TfrmOptionsbtnReplace_W(Self: TfrmOptions; const T: TButton);
Begin Self.btnReplace := T; end;

(*----------------------------------------------------------------------------*)
procedure TfrmOptionsbtnReplace_R(Self: TfrmOptions; var T: TButton);
Begin T := Self.btnReplace; end;

(*----------------------------------------------------------------------------*)
procedure TfrmOptionsbtnPathBrowse_W(Self: TfrmOptions; const T: TButton);
Begin Self.btnPathBrowse := T; end;

(*----------------------------------------------------------------------------*)
procedure TfrmOptionsbtnPathBrowse_R(Self: TfrmOptions; var T: TButton);
Begin T := Self.btnPathBrowse; end;

(*----------------------------------------------------------------------------*)
procedure TfrmOptionsedLibPath_W(Self: TfrmOptions; const T: TEdit);
Begin Self.edLibPath := T; end;

(*----------------------------------------------------------------------------*)
procedure TfrmOptionsedLibPath_R(Self: TfrmOptions; var T: TEdit);
Begin T := Self.edLibPath; end;

(*----------------------------------------------------------------------------*)
procedure TfrmOptionslvPaths_W(Self: TfrmOptions; const T: TListView);
Begin Self.lvPaths := T; end;

(*----------------------------------------------------------------------------*)
procedure TfrmOptionslvPaths_R(Self: TfrmOptions; var T: TListView);
Begin T := Self.lvPaths; end;

(*----------------------------------------------------------------------------*)
procedure TfrmOptionstabPaths_W(Self: TfrmOptions; const T: TTabSheet);
Begin Self.tabPaths := T; end;

(*----------------------------------------------------------------------------*)
procedure TfrmOptionstabPaths_R(Self: TfrmOptions; var T: TTabSheet);
Begin T := Self.tabPaths; end;

(*----------------------------------------------------------------------------*)
procedure TfrmOptionstabGeneral_W(Self: TfrmOptions; const T: TTabSheet);
Begin Self.tabGeneral := T; end;

(*----------------------------------------------------------------------------*)
procedure TfrmOptionstabGeneral_R(Self: TfrmOptions; var T: TTabSheet);
Begin T := Self.tabGeneral; end;

(*----------------------------------------------------------------------------*)
procedure TfrmOptionspcOptions_W(Self: TfrmOptions; const T: TPageControl);
Begin Self.pcOptions := T; end;

(*----------------------------------------------------------------------------*)
procedure TfrmOptionspcOptions_R(Self: TfrmOptions; var T: TPageControl);
Begin T := Self.pcOptions; end;

(*----------------------------------------------------------------------------*)
procedure TfrmOptionsbtnCancel_W(Self: TfrmOptions; const T: TButton);
Begin Self.btnCancel := T; end;

(*----------------------------------------------------------------------------*)
procedure TfrmOptionsbtnCancel_R(Self: TfrmOptions; var T: TButton);
Begin T := Self.btnCancel; end;

(*----------------------------------------------------------------------------*)
procedure TfrmOptionsbtnOK_W(Self: TfrmOptions; const T: TButton);
Begin Self.btnOK := T; end;

(*----------------------------------------------------------------------------*)
procedure TfrmOptionsbtnOK_R(Self: TfrmOptions; var T: TButton);
Begin T := Self.btnOK; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TfrmOptions(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TfrmOptions) do begin
    RegisterPropertyHelper(@TfrmOptionsbtnOK_R,@TfrmOptionsbtnOK_W,'btnOK');
    RegisterPropertyHelper(@TfrmOptionsbtnCancel_R,@TfrmOptionsbtnCancel_W,'btnCancel');
    RegisterPropertyHelper(@TfrmOptionspcOptions_R,@TfrmOptionspcOptions_W,'pcOptions');
    RegisterPropertyHelper(@TfrmOptionstabGeneral_R,@TfrmOptionstabGeneral_W,'tabGeneral');
    RegisterPropertyHelper(@TfrmOptionstabPaths_R,@TfrmOptionstabPaths_W,'tabPaths');
    RegisterPropertyHelper(@TfrmOptionslvPaths_R,@TfrmOptionslvPaths_W,'lvPaths');
    RegisterPropertyHelper(@TfrmOptionsedLibPath_R,@TfrmOptionsedLibPath_W,'edLibPath');
    RegisterPropertyHelper(@TfrmOptionsbtnPathBrowse_R,@TfrmOptionsbtnPathBrowse_W,'btnPathBrowse');
    RegisterPropertyHelper(@TfrmOptionsbtnReplace_R,@TfrmOptionsbtnReplace_W,'btnReplace');
    RegisterPropertyHelper(@TfrmOptionsbtnAdd_R,@TfrmOptionsbtnAdd_W,'btnAdd');
    RegisterPropertyHelper(@TfrmOptionsbtnDelete_R,@TfrmOptionsbtnDelete_W,'btnDelete');
    RegisterPropertyHelper(@TfrmOptionsalOptions_R,@TfrmOptionsalOptions_W,'alOptions');
    RegisterPropertyHelper(@TfrmOptionsLabel9_R,@TfrmOptionsLabel9_W,'Label9');
    RegisterPropertyHelper(@TfrmOptionsJvBrowseFolder1_R,@TfrmOptionsJvBrowseFolder1_W,'JvBrowseFolder1');
    RegisterPropertyHelper(@TfrmOptionsacReplace_R,@TfrmOptionsacReplace_W,'acReplace');
    RegisterPropertyHelper(@TfrmOptionsacAdd_R,@TfrmOptionsacAdd_W,'acAdd');
    RegisterPropertyHelper(@TfrmOptionsacDelete_R,@TfrmOptionsacDelete_W,'acDelete');
    RegisterPropertyHelper(@TfrmOptionsacBrowse_R,@TfrmOptionsacBrowse_W,'acBrowse');
    RegisterPropertyHelper(@TfrmOptionspopPaths_R,@TfrmOptionspopPaths_W,'popPaths');
    RegisterPropertyHelper(@TfrmOptionsacDelInvalidPaths_R,@TfrmOptionsacDelInvalidPaths_W,'acDelInvalidPaths');
    RegisterPropertyHelper(@TfrmOptionsacGetD5Path_R,@TfrmOptionsacGetD5Path_W,'acGetD5Path');
    RegisterPropertyHelper(@TfrmOptionsacGetD6Path_R,@TfrmOptionsacGetD6Path_W,'acGetD6Path');
    RegisterPropertyHelper(@TfrmOptionsacGetD7Path_R,@TfrmOptionsacGetD7Path_W,'acGetD7Path');
    RegisterPropertyHelper(@TfrmOptionsacGetBCB5Path_R,@TfrmOptionsacGetBCB5Path_W,'acGetBCB5Path');
    RegisterPropertyHelper(@TfrmOptionsacGetBCB6Path_R,@TfrmOptionsacGetBCB6Path_W,'acGetBCB6Path');
    RegisterPropertyHelper(@TfrmOptionsAdd1_R,@TfrmOptionsAdd1_W,'Add1');
    RegisterPropertyHelper(@TfrmOptionsReplace1_R,@TfrmOptionsReplace1_W,'Replace1');
    RegisterPropertyHelper(@TfrmOptionsDelete1_R,@TfrmOptionsDelete1_W,'Delete1');
    RegisterPropertyHelper(@TfrmOptionsN1_R,@TfrmOptionsN1_W,'N1');
    RegisterPropertyHelper(@TfrmOptionsInsertLibraryPath1_R,@TfrmOptionsInsertLibraryPath1_W,'InsertLibraryPath1');
    RegisterPropertyHelper(@TfrmOptionsCBuilder51_R,@TfrmOptionsCBuilder51_W,'CBuilder51');
    RegisterPropertyHelper(@TfrmOptionsCBuilder61_R,@TfrmOptionsCBuilder61_W,'CBuilder61');
    RegisterPropertyHelper(@TfrmOptionsN2_R,@TfrmOptionsN2_W,'N2');
    RegisterPropertyHelper(@TfrmOptionsDelphi51_R,@TfrmOptionsDelphi51_W,'Delphi51');
    RegisterPropertyHelper(@TfrmOptionsDelphi61_R,@TfrmOptionsDelphi61_W,'Delphi61');
    RegisterPropertyHelper(@TfrmOptionsDelphi71_R,@TfrmOptionsDelphi71_W,'Delphi71');
    RegisterPropertyHelper(@TfrmOptionsDeleteInvalidPaths1_R,@TfrmOptionsDeleteInvalidPaths1_W,'DeleteInvalidPaths1');
    RegisterPropertyHelper(@TfrmOptionsgbConnectors_R,@TfrmOptionsgbConnectors_W,'gbConnectors');
    RegisterPropertyHelper(@TfrmOptionsLabel3_R,@TfrmOptionsLabel3_W,'Label3');
    RegisterPropertyHelper(@TfrmOptionsLabel4_R,@TfrmOptionsLabel4_W,'Label4');
    RegisterPropertyHelper(@TfrmOptionsLabel5_R,@TfrmOptionsLabel5_W,'Label5');
    RegisterPropertyHelper(@TfrmOptionsLabel6_R,@TfrmOptionsLabel6_W,'Label6');
    RegisterPropertyHelper(@TfrmOptionsLabel7_R,@TfrmOptionsLabel7_W,'Label7');
    RegisterPropertyHelper(@TfrmOptionsLabel8_R,@TfrmOptionsLabel8_W,'Label8');
    RegisterPropertyHelper(@TfrmOptionscbIntfColor_R,@TfrmOptionscbIntfColor_W,'cbIntfColor');
    RegisterPropertyHelper(@TfrmOptionscbIntfSelColor_R,@TfrmOptionscbIntfSelColor_W,'cbIntfSelColor');
    RegisterPropertyHelper(@TfrmOptionscbImplColor_R,@TfrmOptionscbImplColor_W,'cbImplColor');
    RegisterPropertyHelper(@TfrmOptionscbImplSelColor_R,@TfrmOptionscbImplSelColor_W,'cbImplSelColor');
    RegisterPropertyHelper(@TfrmOptionsacSystemPath_R,@TfrmOptionsacSystemPath_W,'acSystemPath');
    RegisterPropertyHelper(@TfrmOptionsN3_R,@TfrmOptionsN3_W,'N3');
    RegisterPropertyHelper(@TfrmOptionsSystemPath1_R,@TfrmOptionsSystemPath1_W,'SystemPath1');
    RegisterPropertyHelper(@TfrmOptionsacSelectAll_R,@TfrmOptionsacSelectAll_W,'acSelectAll');
    RegisterPropertyHelper(@TfrmOptionsacInvertSelect_R,@TfrmOptionsacInvertSelect_W,'acInvertSelect');
    RegisterPropertyHelper(@TfrmOptionsacUnselectAll_R,@TfrmOptionsacUnselectAll_W,'acUnselectAll');
    RegisterPropertyHelper(@TfrmOptionsSelect1_R,@TfrmOptionsSelect1_W,'Select1');
    RegisterPropertyHelper(@TfrmOptionsSelectAll1_R,@TfrmOptionsSelectAll1_W,'SelectAll1');
    RegisterPropertyHelper(@TfrmOptionsUnselectAll1_R,@TfrmOptionsUnselectAll1_W,'UnselectAll1');
    RegisterPropertyHelper(@TfrmOptionsInvertSelection1_R,@TfrmOptionsInvertSelection1_W,'InvertSelection1');
    RegisterPropertyHelper(@TfrmOptionsN4_R,@TfrmOptionsN4_W,'N4');
    RegisterPropertyHelper(@TfrmOptionsgbShapes_R,@TfrmOptionsgbShapes_W,'gbShapes');
    RegisterPropertyHelper(@TfrmOptionsedShapeWidth_R,@TfrmOptionsedShapeWidth_W,'edShapeWidth');
    RegisterPropertyHelper(@TfrmOptionsedShapeHeight_R,@TfrmOptionsedShapeHeight_W,'edShapeHeight');
    RegisterPropertyHelper(@TfrmOptionsLabel1_R,@TfrmOptionsLabel1_W,'Label1');
    RegisterPropertyHelper(@TfrmOptionsLabel2_R,@TfrmOptionsLabel2_W,'Label2');
    RegisterMethod(@TfrmOptions.acBrowseExecute, 'acBrowseExecute');
    RegisterMethod(@TfrmOptions.acAddExecute, 'acAddExecute');
    RegisterMethod(@TfrmOptions.acReplaceExecute, 'acReplaceExecute');
    RegisterMethod(@TfrmOptions.acDeleteExecute, 'acDeleteExecute');
    RegisterMethod(@TfrmOptions.alOptionsUpdate, 'alOptionsUpdate');
    RegisterMethod(@TfrmOptions.acGetD5PathExecute, 'acGetD5PathExecute');
    RegisterMethod(@TfrmOptions.acGetD6PathExecute, 'acGetD6PathExecute');
    RegisterMethod(@TfrmOptions.acGetD7PathExecute, 'acGetD7PathExecute');
    RegisterMethod(@TfrmOptions.acGetBCB5PathExecute, 'acGetBCB5PathExecute');
    RegisterMethod(@TfrmOptions.acGetBCB6PathExecute, 'acGetBCB6PathExecute');
    RegisterMethod(@TfrmOptions.acDelInvalidPathsExecute, 'acDelInvalidPathsExecute');
    RegisterMethod(@TfrmOptions.lvPathsSelectItem, 'lvPathsSelectItem');
    RegisterMethod(@TfrmOptions.lvPathsEnter, 'lvPathsEnter');
    RegisterMethod(@TfrmOptions.tabPathsShow, 'tabPathsShow');
    RegisterMethod(@TfrmOptions.FormCreate, 'FormCreate');
    RegisterMethod(@TfrmOptions.acSystemPathExecute, 'acSystemPathExecute');
    RegisterMethod(@TfrmOptions.acSelectAllExecute, 'acSelectAllExecute');
    RegisterMethod(@TfrmOptions.acInvertSelectExecute, 'acInvertSelectExecute');
    RegisterMethod(@TfrmOptions.acUnselectAllExecute, 'acUnselectAllExecute');
    RegisterMethod(@TfrmOptions.Execute, 'Execute');
    RegisterMethod(@TfrmOptions.Create, 'Create');

  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_OptionsFrm(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TfrmOptions(CL);
end;

 
 
{ TPSImport_OptionsFrm }
(*----------------------------------------------------------------------------*)
procedure TPSImport_OptionsFrm.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_OptionsFrm(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_OptionsFrm.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_OptionsFrm(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
