unit uPSI_KDialogs;
{
with kcontrols res

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
  TPSImport_KDialogs = class(TPSPlugin)
  public
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TKBrowseFolderDialog(CL: TPSPascalCompiler);
procedure SIRegister_TKPrintSetupDialog(CL: TPSPascalCompiler);
procedure SIRegister_TKPrintPreviewDialog(CL: TPSPascalCompiler);
procedure SIRegister_KDialogs(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TKBrowseFolderDialog(CL: TPSRuntimeClassImporter);
procedure RIRegister_TKPrintSetupDialog(CL: TPSRuntimeClassImporter);
procedure RIRegister_TKPrintPreviewDialog(CL: TPSRuntimeClassImporter);
procedure RIRegister_KDialogs(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   Controls
  ,Forms
  ,KFunctions
  ,KControls
  ,KPrintPreview
  ,KPrintSetup
  ,KDialogs
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_KDialogs]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TKBrowseFolderDialog(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TComponent', 'TKBrowseFolderDialog') do
  with CL.AddClassN(CL.FindClass('TComponent'),'TKBrowseFolderDialog') do
  begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
    RegisterMethod('Function Execute : Boolean');
    RegisterProperty('LabelText', 'string', iptrw);
    RegisterProperty('CustomRootFolder', 'TFolder', iptrw);
    RegisterProperty('Folder', 'TFolder', iptrw);
    RegisterProperty('Options', 'TKBrowseFolderOptions', iptrw);
    RegisterProperty('ParentWindow', 'TWinControl', iptrw);
    RegisterProperty('Position', 'TKBrowseFolderPosition', iptrw);
    RegisterProperty('RootFolder', 'TKRootFolder', iptrw);
    RegisterProperty('CustomLeft', 'Integer', iptrw);
    RegisterProperty('CustomTop', 'Integer', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TKPrintSetupDialog(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TComponent', 'TKPrintSetupDialog') do
  with CL.AddClassN(CL.FindClass('TComponent'),'TKPrintSetupDialog') do
  begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
    RegisterMethod('Function Execute : Boolean');
    RegisterProperty('Control', 'TKCustomControl', iptrw);
    RegisterProperty('PreviewDialog', 'TKPrintPreviewDialog', iptrw);
    RegisterProperty('SelAvail', 'Boolean', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TKPrintPreviewDialog(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TComponent', 'TKPrintPreviewDialog') do
  with CL.AddClassN(CL.FindClass('TComponent'),'TKPrintPreviewDialog') do
  begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
    RegisterMethod('Procedure Show');
    RegisterMethod('Function Execute : Boolean');
    RegisterProperty('PrintPreviewForm', 'TKPrintPreviewForm', iptr);
    RegisterProperty('Control', 'TKCustomControl', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_KDialogs(CL: TPSPascalCompiler);
begin
  CL.AddTypeS('TKRootFolder', '( brAdminTools, brAltStartUp, brAppData, brBitBu'
   +'cket, brCommonAdminTools, brCommonAltStartUp, brCommonAppData, brCommonDes'
   +'ktopDirectory, brCommonDocuments, brCommonFavorites, brCommonPrograms, brC'
   +'ommonStartMenu, brCommonStartUp, brCommonTemplates, brControls, brCookies,'
   +' brDesktop, brDesktopDirectory, brDrives, brFavorites, brFonts, brHistory,'
   +' brInternet, brInternetCache, brLocalAppData, brMyMusic, brMyPictures, brN'
   +'etHood, brNetWork, brPersonal, brPrinters, brPrintHood, brProfile, brProgr'
   +'amFiles, brProgramFilesCommon, brPrograms, brRecent, brSendTo, brStartMenu'
   +', brStartUp, brSystem, brTemplates, brWindows, brCustom )');
  CL.AddTypeS('TFolder', 'string');
  CL.AddTypeS('TKBrowseFolderOption', '( bfSetFolder, bfBrowseForComputer, bfBr'
   +'owseForPrinter, bfBrowseIncludeFiles, bfBrowseIncludeURLs, bfDontGoBelowDo'
   +'main, bfEditBox, bfNewDialogStyle, bfReturnFSAncestors, bfReturnOnlyFSDirs'
   +', bfShareAble, bfStatusText, bfUseNewUI, bfValidate )');
  CL.AddTypeS('TKBrowseFolderOptions', 'set of TKBrowseFolderOption');
  CL.AddTypeS('TKBrowseFolderPosition', '( poDefault1, poScreenCenter1, poCustom1)');
  SIRegister_TKPrintPreviewDialog(CL);
  SIRegister_TKPrintSetupDialog(CL);
  SIRegister_TKBrowseFolderDialog(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TKBrowseFolderDialogCustomTop_W(Self: TKBrowseFolderDialog; const T: Integer);
begin Self.CustomTop := T; end;

(*----------------------------------------------------------------------------*)
procedure TKBrowseFolderDialogCustomTop_R(Self: TKBrowseFolderDialog; var T: Integer);
begin T := Self.CustomTop; end;

(*----------------------------------------------------------------------------*)
procedure TKBrowseFolderDialogCustomLeft_W(Self: TKBrowseFolderDialog; const T: Integer);
begin Self.CustomLeft := T; end;

(*----------------------------------------------------------------------------*)
procedure TKBrowseFolderDialogCustomLeft_R(Self: TKBrowseFolderDialog; var T: Integer);
begin T := Self.CustomLeft; end;

(*----------------------------------------------------------------------------*)
procedure TKBrowseFolderDialogRootFolder_W(Self: TKBrowseFolderDialog; const T: TKRootFolder);
begin Self.RootFolder := T; end;

(*----------------------------------------------------------------------------*)
procedure TKBrowseFolderDialogRootFolder_R(Self: TKBrowseFolderDialog; var T: TKRootFolder);
begin T := Self.RootFolder; end;

(*----------------------------------------------------------------------------*)
procedure TKBrowseFolderDialogPosition_W(Self: TKBrowseFolderDialog; const T: TKBrowseFolderPosition);
begin Self.Position := T; end;

(*----------------------------------------------------------------------------*)
procedure TKBrowseFolderDialogPosition_R(Self: TKBrowseFolderDialog; var T: TKBrowseFolderPosition);
begin T := Self.Position; end;

(*----------------------------------------------------------------------------*)
procedure TKBrowseFolderDialogParentWindow_W(Self: TKBrowseFolderDialog; const T: TWinControl);
begin Self.ParentWindow := T; end;

(*----------------------------------------------------------------------------*)
procedure TKBrowseFolderDialogParentWindow_R(Self: TKBrowseFolderDialog; var T: TWinControl);
begin T := Self.ParentWindow; end;

(*----------------------------------------------------------------------------*)
procedure TKBrowseFolderDialogOptions_W(Self: TKBrowseFolderDialog; const T: TKBrowseFolderOptions);
begin Self.Options := T; end;

(*----------------------------------------------------------------------------*)
procedure TKBrowseFolderDialogOptions_R(Self: TKBrowseFolderDialog; var T: TKBrowseFolderOptions);
begin T := Self.Options; end;

(*----------------------------------------------------------------------------*)
procedure TKBrowseFolderDialogFolder_W(Self: TKBrowseFolderDialog; const T: TFolder);
begin Self.Folder := T; end;

(*----------------------------------------------------------------------------*)
procedure TKBrowseFolderDialogFolder_R(Self: TKBrowseFolderDialog; var T: TFolder);
begin T := Self.Folder; end;

(*----------------------------------------------------------------------------*)
procedure TKBrowseFolderDialogCustomRootFolder_W(Self: TKBrowseFolderDialog; const T: TFolder);
begin Self.CustomRootFolder := T; end;

(*----------------------------------------------------------------------------*)
procedure TKBrowseFolderDialogCustomRootFolder_R(Self: TKBrowseFolderDialog; var T: TFolder);
begin T := Self.CustomRootFolder; end;

(*----------------------------------------------------------------------------*)
procedure TKBrowseFolderDialogLabelText_W(Self: TKBrowseFolderDialog; const T: string);
begin Self.LabelText := T; end;

(*----------------------------------------------------------------------------*)
procedure TKBrowseFolderDialogLabelText_R(Self: TKBrowseFolderDialog; var T: string);
begin T := Self.LabelText; end;

(*----------------------------------------------------------------------------*)
procedure TKPrintSetupDialogSelAvail_W(Self: TKPrintSetupDialog; const T: Boolean);
begin Self.SelAvail := T; end;

(*----------------------------------------------------------------------------*)
procedure TKPrintSetupDialogSelAvail_R(Self: TKPrintSetupDialog; var T: Boolean);
begin T := Self.SelAvail; end;

(*----------------------------------------------------------------------------*)
procedure TKPrintSetupDialogPreviewDialog_W(Self: TKPrintSetupDialog; const T: TKPrintPreviewDialog);
begin Self.PreviewDialog := T; end;

(*----------------------------------------------------------------------------*)
procedure TKPrintSetupDialogPreviewDialog_R(Self: TKPrintSetupDialog; var T: TKPrintPreviewDialog);
begin T := Self.PreviewDialog; end;

(*----------------------------------------------------------------------------*)
procedure TKPrintSetupDialogControl_W(Self: TKPrintSetupDialog; const T: TKCustomControl);
begin Self.Control := T; end;

(*----------------------------------------------------------------------------*)
procedure TKPrintSetupDialogControl_R(Self: TKPrintSetupDialog; var T: TKCustomControl);
begin T := Self.Control; end;

(*----------------------------------------------------------------------------*)
procedure TKPrintPreviewDialogControl_W(Self: TKPrintPreviewDialog; const T: TKCustomControl);
begin Self.Control := T; end;

(*----------------------------------------------------------------------------*)
procedure TKPrintPreviewDialogControl_R(Self: TKPrintPreviewDialog; var T: TKCustomControl);
begin T := Self.Control; end;

(*----------------------------------------------------------------------------*)
procedure TKPrintPreviewDialogPrintPreviewForm_R(Self: TKPrintPreviewDialog; var T: TKPrintPreviewForm);
begin T := Self.PrintPreviewForm; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TKBrowseFolderDialog(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TKBrowseFolderDialog) do
  begin
    RegisterConstructor(@TKBrowseFolderDialog.Create, 'Create');
    RegisterMethod(@TKBrowseFolderDialog.Execute, 'Execute');
    RegisterPropertyHelper(@TKBrowseFolderDialogLabelText_R,@TKBrowseFolderDialogLabelText_W,'LabelText');
    RegisterPropertyHelper(@TKBrowseFolderDialogCustomRootFolder_R,@TKBrowseFolderDialogCustomRootFolder_W,'CustomRootFolder');
    RegisterPropertyHelper(@TKBrowseFolderDialogFolder_R,@TKBrowseFolderDialogFolder_W,'Folder');
    RegisterPropertyHelper(@TKBrowseFolderDialogOptions_R,@TKBrowseFolderDialogOptions_W,'Options');
    RegisterPropertyHelper(@TKBrowseFolderDialogParentWindow_R,@TKBrowseFolderDialogParentWindow_W,'ParentWindow');
    RegisterPropertyHelper(@TKBrowseFolderDialogPosition_R,@TKBrowseFolderDialogPosition_W,'Position');
    RegisterPropertyHelper(@TKBrowseFolderDialogRootFolder_R,@TKBrowseFolderDialogRootFolder_W,'RootFolder');
    RegisterPropertyHelper(@TKBrowseFolderDialogCustomLeft_R,@TKBrowseFolderDialogCustomLeft_W,'CustomLeft');
    RegisterPropertyHelper(@TKBrowseFolderDialogCustomTop_R,@TKBrowseFolderDialogCustomTop_W,'CustomTop');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TKPrintSetupDialog(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TKPrintSetupDialog) do
  begin
    RegisterConstructor(@TKPrintSetupDialog.Create, 'Create');
    RegisterMethod(@TKPrintSetupDialog.Execute, 'Execute');
    RegisterPropertyHelper(@TKPrintSetupDialogControl_R,@TKPrintSetupDialogControl_W,'Control');
    RegisterPropertyHelper(@TKPrintSetupDialogPreviewDialog_R,@TKPrintSetupDialogPreviewDialog_W,'PreviewDialog');
    RegisterPropertyHelper(@TKPrintSetupDialogSelAvail_R,@TKPrintSetupDialogSelAvail_W,'SelAvail');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TKPrintPreviewDialog(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TKPrintPreviewDialog) do
  begin
    RegisterConstructor(@TKPrintPreviewDialog.Create, 'Create');
    RegisterMethod(@TKPrintPreviewDialog.Show, 'Show');
    RegisterMethod(@TKPrintPreviewDialog.Execute, 'Execute');
    RegisterPropertyHelper(@TKPrintPreviewDialogPrintPreviewForm_R,nil,'PrintPreviewForm');
    RegisterPropertyHelper(@TKPrintPreviewDialogControl_R,@TKPrintPreviewDialogControl_W,'Control');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_KDialogs(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TKPrintPreviewDialog(CL);
  RIRegister_TKPrintSetupDialog(CL);
  RIRegister_TKBrowseFolderDialog(CL);
end;

 
 
{ TPSImport_KDialogs }
(*----------------------------------------------------------------------------*)
procedure TPSImport_KDialogs.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_KDialogs(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_KDialogs.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_KDialogs(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
