unit uPSI_ShellCtrls;
{
  of demo/examples in borland + rootfolder  +items
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
  TPSImport_ShellCtrls = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TShellListView(CL: TPSPascalCompiler);
procedure SIRegister_TCustomShellListView(CL: TPSPascalCompiler);
procedure SIRegister_TShellComboBox(CL: TPSPascalCompiler);
procedure SIRegister_TCustomShellComboBox(CL: TPSPascalCompiler);
procedure SIRegister_TShellTreeView(CL: TPSPascalCompiler);
procedure SIRegister_TCustomShellTreeView(CL: TPSPascalCompiler);
procedure SIRegister_TShellChangeNotifier(CL: TPSPascalCompiler);
procedure SIRegister_TCustomShellChangeNotifier(CL: TPSPascalCompiler);
procedure SIRegister_TShellChangeThread(CL: TPSPascalCompiler);
procedure SIRegister_TShellFolder(CL: TPSPascalCompiler);
procedure SIRegister_IShellCommandVerb(CL: TPSPascalCompiler);
procedure SIRegister_ShellCtrls(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_ShellCtrls_Routines(S: TPSExec);
procedure RIRegister_TShellListView(CL: TPSRuntimeClassImporter);
procedure RIRegister_TCustomShellListView(CL: TPSRuntimeClassImporter);
procedure RIRegister_TShellComboBox(CL: TPSRuntimeClassImporter);
procedure RIRegister_TCustomShellComboBox(CL: TPSRuntimeClassImporter);
procedure RIRegister_TShellTreeView(CL: TPSRuntimeClassImporter);
procedure RIRegister_TCustomShellTreeView(CL: TPSRuntimeClassImporter);
procedure RIRegister_TShellChangeNotifier(CL: TPSRuntimeClassImporter);
procedure RIRegister_TCustomShellChangeNotifier(CL: TPSRuntimeClassImporter);
procedure RIRegister_TShellChangeThread(CL: TPSRuntimeClassImporter);
procedure RIRegister_TShellFolder(CL: TPSRuntimeClassImporter);
procedure RIRegister_ShellCtrls(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   Windows
  ,Messages
  ,Graphics
  ,Controls
  ,Forms
  ,Dialogs
  ,ComCtrls
  ,CommCtrl
  ,ShlObj
  ,ActiveX
  ,StdCtrls
  ,ImgList
  ,ShellCtrls
  ;


procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_ShellCtrls]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TShellListView(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TCustomShellListView', 'TShellListView') do
  with CL.AddClassN(CL.FindClass('TCustomShellListView'),'TShellListView') do begin
       RegisterPublishedProperties;
    RegisterProperty('ALIGNMENT', 'TAlignment', iptrw);
    RegisterProperty('BORDERSTYLE', 'TBorderStyle', iptrw);
    RegisterProperty('BORDERWIDTH', 'Integer', iptrw);
    RegisterProperty('COLOR', 'TColor', iptrw);
    RegisterProperty('FONT', 'TFont', iptrw);
    RegisterProperty('Root', 'string', iptrw);
    RegisterProperty('PopupMenu', 'TPopupMenu', iptrw);
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
    RegisterProperty('ONChange', 'TTVChangedEvent', iptrw);
    RegisterProperty('ONChanging', 'TTVChangingEvent', iptrw);
    RegisterProperty('OnCollapsed', 'TTVExpandedEvent', iptrw);
  RegisterProperty('OnCollapsing', 'TTVCollapsingEvent', iptrw);
  RegisterProperty('OnCompare', 'TTVCompareEvent', iptrw);
  RegisterProperty('OnAddition', 'TTVExpandedEvent', iptrw);
  RegisterProperty('OnCustomDraw', 'TTVCustomDrawEvent', iptrw);
  RegisterProperty('OnCustomDrawItem', 'TTVCustomDrawItemEvent', iptrw);
   RegisterProperty('Images', 'TCustomImageList', iptrw);
    RegisterProperty('Indent', 'Integer', iptrw);
    //RegisterProperty('Items', 'TTreeNodes Integer', iptrw);
    RegisterProperty('Items', 'TListItems', iptrw);
    RegisterProperty('ShowLines', 'boolean', iptrw);
    RegisterProperty('ShowRoot', 'boolean', iptrw);
    RegisterProperty('SortType', 'TSortType', iptrw);
    RegisterProperty('StateImages', 'TCustomImageList', iptrw);
    //RegisterProperty('Constraints', 'TCustomImageList', iptrw);
    RegisterProperty('MultiSelect', 'boolean', iptrw);
    RegisterProperty('AutoExpand', 'boolean', iptrw);
    RegisterProperty('HotTrack', 'boolean', iptrw);
    RegisterProperty('ShowHint', 'boolean', iptrw);
    RegisterProperty('ToolTips', 'boolean', iptrw);
    RegisterProperty('Visible', 'boolean', iptrw);
    RegisterProperty('ShowColumnHeaders', 'boolean', iptrw);
    RegisterProperty('ShowWorkAreas', 'boolean', iptrw);
    RegisterProperty('Canvas', 'TCanvas', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TCustomShellListView(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TCustomListView', 'TCustomShellListView') do
  with CL.AddClassN(CL.FindClass('TCustomListView'),'TCustomShellListView') do
  begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
      RegisterMethod('Procedure Free');
      RegisterMethod('Procedure Back');
    RegisterMethod('Procedure Refresh');
    RegisterMethod('Function SelectedFolder : TShellFolder');
    RegisterProperty('Folders', 'TShellFolder Integer', iptr);
    RegisterProperty('RootFolder', 'TShellFolder', iptr);
    RegisterProperty('AutoContextMenus', 'Boolean', iptrw);
    RegisterProperty('AutoRefresh', 'Boolean', iptrw);
    RegisterProperty('AutoNavigate', 'Boolean', iptrw);
    RegisterProperty('ObjectTypes', 'TShellObjectTypes', iptrw);
    RegisterProperty('Root', 'TRoot', iptrw);
    RegisterProperty('ShellTreeView', 'TCustomShellTreeView', iptrw);
    RegisterProperty('ShellComboBox', 'TCustomShellComboBox', iptrw);
    RegisterProperty('Sorted', 'Boolean', iptrw);
      RegisterProperty('Items', 'TListItems', iptrw);
      RegisterProperty('OnAddFolder', 'TAddFolderEvent', iptrw);
    RegisterProperty('OnEditing', 'TLVEditingEvent', iptrw);
    RegisterMethod('Procedure CommandCompleted( Verb : String; Succeeded : Boolean)');
    RegisterMethod('Procedure ExecuteCommand( Verb : String; var Handled : Boolean)');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TShellComboBox(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TCustomShellComboBox', 'TShellComboBox') do
  with CL.AddClassN(CL.FindClass('TCustomShellComboBox'),'TShellComboBox') do begin
       RegisterPublishedProperties;
    RegisterProperty('ALIGNMENT', 'TAlignment', iptrw);
    RegisterProperty('BORDERSTYLE', 'TBorderStyle', iptrw);
    RegisterProperty('BORDERWIDTH', 'Integer', iptrw);
    RegisterProperty('COLOR', 'TColor', iptrw);
    RegisterProperty('FONT', 'TFont', iptrw);
     RegisterProperty('Root', 'string', iptrw);
    RegisterProperty('PopupMenu', 'TPopupMenu', iptrw);
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
    RegisterProperty('ONChange', 'TTVChangedEvent', iptrw);
    RegisterProperty('ONChanging', 'TTVChangingEvent', iptrw);
    RegisterProperty('OnCollapsed', 'TTVExpandedEvent', iptrw);
  RegisterProperty('OnCollapsing', 'TTVCollapsingEvent', iptrw);
  RegisterProperty('OnCompare', 'TTVCompareEvent', iptrw);
  RegisterProperty('OnAddition', 'TTVExpandedEvent', iptrw);
  RegisterProperty('OnCustomDraw', 'TTVCustomDrawEvent', iptrw);
  RegisterProperty('OnCustomDrawItem', 'TTVCustomDrawItemEvent', iptrw);
  RegisterPublishedProperties;
   RegisterProperty('Images', 'TCustomImageList', iptrw);
    RegisterProperty('Indent', 'Integer', iptrw);
    //RegisterProperty('Items', 'TTreeNodes Integer', iptrw);
    //RegisterProperty('Items', 'TTreeNodes', iptrw);
    RegisterProperty('ShowLines', 'boolean', iptrw);
    RegisterProperty('ShowRoot', 'boolean', iptrw);
    RegisterProperty('SortType', 'TSortType', iptrw);
    RegisterProperty('StateImages', 'TCustomImageList', iptrw);
    //RegisterProperty('Constraints', 'TCustomImageList', iptrw);
    RegisterProperty('MultiSelect', 'boolean', iptrw);
    RegisterProperty('AutoExpand', 'boolean', iptrw);
    RegisterProperty('HotTrack', 'boolean', iptrw);
    RegisterProperty('ShowHint', 'boolean', iptrw);
    RegisterProperty('ToolTips', 'boolean', iptrw);
    RegisterProperty('Visible', 'boolean', iptrw);
    RegisterProperty('ShowColumnHeaders', 'boolean', iptrw);
    RegisterProperty('ShowWorkAreas', 'boolean', iptrw);
    RegisterProperty('Canvas', 'TCanvas', iptrw);

  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TCustomShellComboBox(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TCustomComboBoxEx', 'TCustomShellComboBox') do
  with CL.AddClassN(CL.FindClass('TCustomComboBoxEx'),'TCustomShellComboBox') do
  begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
      RegisterMethod('Procedure Free');
      RegisterProperty('Path', 'string', iptrw);
      RegisterProperty('Items', 'Tstrings', iptrw);
      RegisterProperty('Folders', 'TShellFolder Integer', iptr);
    RegisterProperty('Root', 'TRoot', iptrw);
    RegisterProperty('ObjectTypes', 'TShellObjectTypes', iptrw);
    RegisterProperty('ShellTreeView', 'TCustomShellTreeView', iptrw);
    RegisterProperty('ShellListView', 'TCustomShellListView', iptrw);
    RegisterProperty('UseShellImages', 'Boolean', iptrw);
    RegisterProperty('OnGetImageIndex', 'TGetImageIndexEvent', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TShellTreeView(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TCustomShellTreeView', 'TShellTreeView') do
  with CL.AddClassN(CL.FindClass('TCustomShellTreeView'),'TShellTreeView') do begin
       RegisterPublishedProperties;
    RegisterProperty('ALIGNMENT', 'TAlignment', iptrw);
    RegisterProperty('BORDERSTYLE', 'TBorderStyle', iptrw);
    RegisterProperty('BORDERWIDTH', 'Integer', iptrw);
    RegisterProperty('COLOR', 'TColor', iptrw);
    RegisterProperty('FONT', 'TFont', iptrw);
    RegisterProperty('Root', 'string', iptrw);
    RegisterProperty('PopupMenu', 'TPopupMenu', iptrw);
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
    RegisterProperty('ONChange', 'TTVChangedEvent', iptrw);
    RegisterProperty('ONChanging', 'TTVChangingEvent', iptrw);
    RegisterProperty('OnCollapsed', 'TTVExpandedEvent', iptrw);
  RegisterProperty('OnCollapsing', 'TTVCollapsingEvent', iptrw);
  RegisterProperty('OnCompare', 'TTVCompareEvent', iptrw);
  RegisterProperty('OnAddition', 'TTVExpandedEvent', iptrw);
  RegisterProperty('OnCustomDraw', 'TTVCustomDrawEvent', iptrw);
  RegisterProperty('OnCustomDrawItem', 'TTVCustomDrawItemEvent', iptrw);
   RegisterProperty('Images', 'TCustomImageList', iptrw);
    RegisterProperty('Indent', 'Integer', iptrw);
    //RegisterProperty('Items', 'TTreeNodes Integer', iptrw);
   // RegisterProperty('Items', 'TListItems', iptrw);
    RegisterProperty('Items', 'TTreeNodes', iptrw);

    //RegisterProperty('Columns', 'TListColumns', iptrw);
    RegisterProperty('ShowLines', 'boolean', iptrw);
    RegisterProperty('ShowRoot', 'boolean', iptrw);
    RegisterProperty('SortType', 'TSortType', iptrw);
    RegisterProperty('StateImages', 'TCustomImageList', iptrw);
    //RegisterProperty('Constraints', 'TCustomImageList', iptrw);
    RegisterProperty('MultiSelect', 'boolean', iptrw);
    RegisterProperty('AutoExpand', 'boolean', iptrw);
    RegisterProperty('HotTrack', 'boolean', iptrw);
    RegisterProperty('ShowHint', 'boolean', iptrw);
    RegisterProperty('ToolTips', 'boolean', iptrw);
    RegisterProperty('Visible', 'boolean', iptrw);
    RegisterProperty('ShowColumnHeaders', 'boolean', iptrw);
    RegisterProperty('ShowWorkAreas', 'boolean', iptrw);
    RegisterProperty('Canvas', 'TCanvas', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TCustomShellTreeView(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TCustomTreeView', 'TCustomShellTreeView') do
  with CL.AddClassN(CL.FindClass('TCustomTreeView'),'TCustomShellTreeView') do
  begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
    RegisterMethod('Procedure Refresh( Node : TTreeNode)');
    RegisterMethod('Function SelectedFolder : TShellFolder');
    RegisterProperty('AutoRefresh', 'boolean', iptrw);
    RegisterProperty('Folders', 'TShellFolder Integer', iptr);
    SetDefaultPropery('Folders');
    RegisterProperty('RootFolder', 'TShellFolder', iptr);
     RegisterProperty('Path', 'string', iptrw);
    RegisterProperty('AutoContextMenus', 'Boolean', iptrw);
    RegisterProperty('ObjectTypes', 'TShellObjectTypes', iptrw);
    RegisterProperty('Root', 'TRoot', iptrw);
    RegisterProperty('ShellComboBox', 'TCustomShellComboBox', iptrw);
    RegisterProperty('ShellListView', 'TCustomShellListView', iptrw);
    RegisterProperty('UseShellImages', 'Boolean', iptrw);
    RegisterProperty('OnAddFolder', 'TAddFolderEvent', iptrw);
    RegisterMethod('Procedure CommandCompleted( Verb : String; Succeeded : Boolean)');
    RegisterMethod('Procedure ExecuteCommand( Verb : String; var Handled : Boolean)');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TShellChangeNotifier(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TCustomShellChangeNotifier', 'TShellChangeNotifier') do
  with CL.AddClassN(CL.FindClass('TCustomShellChangeNotifier'),'TShellChangeNotifier') do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TCustomShellChangeNotifier(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TComponent', 'TCustomShellChangeNotifier') do
  with CL.AddClassN(CL.FindClass('TComponent'),'TCustomShellChangeNotifier') do
  begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
    RegisterProperty('NotifyFilters', 'TNotifyFilters', iptrw);
    RegisterProperty('Root', 'TRoot', iptrw);
    RegisterProperty('WatchSubTree', 'Boolean', iptrw);
    RegisterProperty('OnChange', 'TThreadMethod', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TShellChangeThread(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TThread', 'TShellChangeThread') do
  with CL.AddClassN(CL.FindClass('TThread'),'TShellChangeThread') do
  begin
    RegisterMethod('Constructor Create( ChangeEvent : TThreadMethod)');
    RegisterMethod('Procedure SetDirectoryOptions( Directory : String; WatchSubTree : Boolean; NotifyOptionFlags : DWORD)');
    RegisterProperty('ChangeEvent', 'TThreadMethod', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TShellFolder(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOBJECT', 'TShellFolder') do
  with CL.AddClassN(CL.FindClass('TOBJECT'),'TShellFolder') do
  begin
    RegisterMethod('Constructor Create( AParent : TShellFolder; ID : PItemIDList; SF : IShellFolder)');
      RegisterMethod('Procedure Free');
      RegisterMethod('Function Capabilities : TShellFolderCapabilities');
    RegisterMethod('Function DisplayName : string');
    RegisterMethod('Function ExecuteDefault : Integer');
    RegisterMethod('Function ImageIndex( LargeIcon : Boolean) : Integer');
    RegisterMethod('Function IsFolder : Boolean');
    RegisterMethod('Function ParentShellFolder : IShellFolder');
    RegisterMethod('Function PathName : string');
    RegisterMethod('Function Properties : TShellFolderProperties');
    RegisterMethod('Function Rename( const NewName : WideString) : boolean');
    RegisterMethod('Function SubFolders : Boolean');
    RegisterProperty('AbsoluteID', 'PItemIDLIst', iptr);
    RegisterProperty('Details', 'string integer', iptrw);
    RegisterProperty('Level', 'Integer', iptr);
    RegisterProperty('Parent', 'TShellFolder', iptr);
    RegisterProperty('RelativeID', 'PItemIDList', iptr);
    RegisterProperty('ShellFolder', 'IShellFolder', iptr);
    RegisterProperty('ShellFolder2', 'IShellFolder2', iptr);
    RegisterProperty('ShellDetails', 'IShellDetails', iptr);
    RegisterProperty('ViewHandle', 'THandle', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_IShellCommandVerb(CL: TPSPascalCompiler);
begin
  //with RegInterfaceS(CL,'IUNKNOWN', 'IShellCommandVerb') do
  with CL.AddInterface(CL.FindInterface('IUNKNOWN'),IShellCommandVerb, 'IShellCommandVerb') do
  begin
    RegisterMethod('Procedure ExecuteCommand( Verb : string; var Handled : boolean)', cdRegister);
    RegisterMethod('Procedure CommandCompleted( Verb : string; Succeeded : boolean)', cdRegister);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_ShellCtrls(CL: TPSPascalCompiler);
begin
  CL.AddTypeS('TRoot', 'string');
  CL.AddTypeS('TRootFolder', '( rfDesktop, rfMyComputer, rfNetwork, rfRecycleBi'
   +'n, rfAppData, rfCommonDesktopDirectory, rfCommonPrograms, rfCommonStartMen'
   +'u, rfCommonStartup, rfControlPanel, rfDesktopDirectory, rfFavorites, rfFon'
   +'ts, rfInternet, rfPersonal, rfPrinters, rfPrintHood, rfPrograms, rfRecent,'
   +' rfSendTo, rfStartMenu, rfStartup, rfTemplates )');
  CL.AddTypeS('TShellFolderCapability', '( fcCanCopy, fcCanDelete, fcCanLink, f'
   +'cCanMove, fcCanRename, fcDropTarget, fcHasPropSheet )');
  CL.AddTypeS('TShellFolderCapabilities', 'set of TShellFolderCapability');
  CL.AddTypeS('TShellFolderProperty', '( fpCut, fpIsLink, fpReadOnly, fpShared,'
   +' fpFileSystem, fpFileSystemAncestor, fpRemovable, fpValidate )');
  CL.AddTypeS('TShellFolderProperties', 'set of TShellFolderProperty');
  CL.AddTypeS('TShellObjectType', '( otFolders, otNonFolders, otHidden )');
  CL.AddTypeS('TShellObjectTypes', 'set of TShellObjectType');
  CL.AddClassN(CL.FindClass('TOBJECT'),'EInvalidPath');
  SIRegister_IShellCommandVerb(CL);
  SIRegister_TShellFolder(CL);
  CL.AddTypeS('TNotifyFilter', '( nfFileNameChange, nfDirNameChange, nfAttribut'
   +'eChange, nfSizeChange, nfWriteChange, nfSecurityChange )');
  CL.AddTypeS('TNotifyFilters', 'set of TNotifyFilter');
  SIRegister_TShellChangeThread(CL);
  SIRegister_TCustomShellChangeNotifier(CL);
  SIRegister_TShellChangeNotifier(CL);
  CL.AddClassN(CL.FindClass('TOBJECT'),'TCustomShellComboBox');
  CL.AddClassN(CL.FindClass('TOBJECT'),'TCustomShellListView');
  CL.AddTypeS('TAddFolderEvent', 'Procedure (Sender: TObject; AFolder : TShellFolder; var CanAdd : Boolean)');
  CL.AddTypeS('TGetImageIndexEvent', 'Procedure (Sender: TObject; Index: Integer; var ImageIndex: Integer)');
  SIRegister_TCustomShellTreeView(CL);
  SIRegister_TShellTreeView(CL);
  SIRegister_TCustomShellComboBox(CL);
  SIRegister_TShellComboBox(CL);
  SIRegister_TCustomShellListView(CL);
  SIRegister_TShellListView(CL);
 CL.AddDelphiFunction('Procedure InvokeContextMenu( Owner : TWinControl; AFolder : TShellFolder; X, Y : Integer)');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TCustomShellListViewOnEditing_W(Self: TCustomShellListView; const T: TLVEditingEvent);
begin Self.OnEditing := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomShellListViewOnEditing_R(Self: TCustomShellListView; var T: TLVEditingEvent);
begin T := Self.OnEditing; end;

(*----------------------------------------------------------------------------*)
procedure TCustomShellListViewOnAddFolder_W(Self: TCustomShellListView; const T: TAddFolderEvent);
begin Self.OnAddFolder := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomShellListViewOnAddFolder_R(Self: TCustomShellListView; var T: TAddFolderEvent);
begin T := Self.OnAddFolder; end;

(*----------------------------------------------------------------------------*)
procedure TCustomShellListViewSorted_W(Self: TCustomShellListView; const T: Boolean);
begin Self.Sorted := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomShellListViewSorted_R(Self: TCustomShellListView; var T: Boolean);
begin T := Self.Sorted; end;

(*----------------------------------------------------------------------------*)
procedure TCustomShellListViewShellComboBox_W(Self: TCustomShellListView; const T: TCustomShellComboBox);
begin Self.ShellComboBox := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomShellListViewShellComboBox_R(Self: TCustomShellListView; var T: TCustomShellComboBox);
begin T := Self.ShellComboBox; end;

(*----------------------------------------------------------------------------*)
procedure TCustomShellListViewShellTreeView_W(Self: TCustomShellListView; const T: TCustomShellTreeView);
begin Self.ShellTreeView := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomShellListViewShellTreeView_R(Self: TCustomShellListView; var T: TCustomShellTreeView);
begin T := Self.ShellTreeView; end;

(*----------------------------------------------------------------------------*)
procedure TCustomShellListViewRoot_W(Self: TCustomShellListView; const T: TRoot);
begin Self.Root := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomShellListViewRoot_R(Self: TCustomShellListView; var T: TRoot);
begin T := Self.Root; end;

(*----------------------------------------------------------------------------*)
procedure TCustomShellListViewObjectTypes_W(Self: TCustomShellListView; const T: TShellObjectTypes);
begin Self.ObjectTypes := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomShellListViewObjectTypes_R(Self: TCustomShellListView; var T: TShellObjectTypes);
begin T := Self.ObjectTypes; end;

(*----------------------------------------------------------------------------*)
procedure TCustomShellListViewAutoNavigate_W(Self: TCustomShellListView; const T: Boolean);
begin Self.AutoNavigate := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomShellListViewAutoNavigate_R(Self: TCustomShellListView; var T: Boolean);
begin T := Self.AutoNavigate; end;

(*----------------------------------------------------------------------------*)
procedure TCustomShellListViewAutoRefresh_W(Self: TCustomShellListView; const T: Boolean);
begin Self.AutoRefresh := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomShellListViewAutoRefresh_R(Self: TCustomShellListView; var T: Boolean);
begin T := Self.AutoRefresh; end;

(*----------------------------------------------------------------------------*)
procedure TCustomShellListViewAutoContextMenus_W(Self: TCustomShellListView; const T: Boolean);
begin Self.AutoContextMenus := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomShellListViewAutoContextMenus_R(Self: TCustomShellListView; var T: Boolean);
begin T := Self.AutoContextMenus; end;

(*----------------------------------------------------------------------------*)
procedure TCustomShellListViewRootFolder_R(Self: TCustomShellListView; var T: TShellFolder);
begin T := Self.RootFolder; end;

procedure TCustomShellTreeViewRootFolder_R(Self: TCustomShellListView; var T: TShellFolder);
begin T := Self.RootFolder; end;

(*----------------------------------------------------------------------------*)
procedure TCustomShellListViewFolders_R(Self: TCustomShellListView; var T: TShellFolder; const t1: Integer);
begin T := Self.Folders[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TCustomShellComboBoxOnGetImageIndex_W(Self: TCustomShellComboBox; const T: TGetImageIndexEvent);
begin Self.OnGetImageIndex := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomShellComboBoxOnGetImageIndex_R(Self: TCustomShellComboBox; var T: TGetImageIndexEvent);
begin T := Self.OnGetImageIndex; end;

(*----------------------------------------------------------------------------*)
procedure TCustomShellComboBoxUseShellImages_W(Self: TCustomShellComboBox; const T: Boolean);
begin Self.UseShellImages := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomShellComboBoxUseShellImages_R(Self: TCustomShellComboBox; var T: Boolean);
begin T := Self.UseShellImages; end;

(*----------------------------------------------------------------------------*)
procedure TCustomShellComboBoxShellListView_W(Self: TCustomShellComboBox; const T: TCustomShellListView);
begin Self.ShellListView := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomShellComboBoxShellListView_R(Self: TCustomShellComboBox; var T: TCustomShellListView);
begin T := Self.ShellListView; end;

(*----------------------------------------------------------------------------*)
procedure TCustomShellComboBoxShellTreeView_W(Self: TCustomShellComboBox; const T: TCustomShellTreeView);
begin Self.ShellTreeView := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomShellComboBoxShellTreeView_R(Self: TCustomShellComboBox; var T: TCustomShellTreeView);
begin T := Self.ShellTreeView; end;

(*----------------------------------------------------------------------------*)
procedure TCustomShellComboBoxObjectTypes_W(Self: TCustomShellComboBox; const T: TShellObjectTypes);
begin Self.ObjectTypes := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomShellComboBoxObjectTypes_R(Self: TCustomShellComboBox; var T: TShellObjectTypes);
begin T := Self.ObjectTypes; end;

(*----------------------------------------------------------------------------*)
procedure TCustomShellComboBoxRoot_W(Self: TCustomShellComboBox; const T: TRoot);
begin Self.Root := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomShellComboBoxRoot_R(Self: TCustomShellComboBox; var T: TRoot);
begin T := Self.Root; end;

(*----------------------------------------------------------------------------*)
procedure TCustomShellComboBoxFolders_R(Self: TCustomShellComboBox; var T: TShellFolder; const t1: Integer);
begin T := Self.Folders[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TCustomShellComboBoxPath_W(Self: TCustomShellComboBox; const T: string);
begin Self.Path := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomShellComboBoxPath_R(Self: TCustomShellComboBox; var T: string);
begin T := Self.Path; end;

procedure TCustomShellComboBoxItems_W(Self: TCustomShellComboBox; const T: Tstrings);
begin Self.Items := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomShellComboBoxItems_R(Self: TCustomShellComboBox; var T: Tstrings);
begin T := Self.Items; end;

procedure TCustomShellListViewItems_W(Self: TCustomShellListView; const T: TListItems);
begin Self.Items := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomShellListViewItems_R(Self: TCustomShellListView; var T: TListItems);
begin T := Self.Items; end;

(*----------------------------------------------------------------------------*)
procedure TCustomShellTreeViewOnAddFolder_W(Self: TCustomShellTreeView; const T: TAddFolderEvent);
begin Self.OnAddFolder := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomShellTreeViewOnAddFolder_R(Self: TCustomShellTreeView; var T: TAddFolderEvent);
begin T := Self.OnAddFolder; end;

(*----------------------------------------------------------------------------*)
procedure TCustomShellTreeViewUseShellImages_W(Self: TCustomShellTreeView; const T: Boolean);
begin Self.UseShellImages := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomShellTreeViewUseShellImages_R(Self: TCustomShellTreeView; var T: Boolean);
begin T := Self.UseShellImages; end;

(*----------------------------------------------------------------------------*)
procedure TCustomShellTreeViewShellListView_W(Self: TCustomShellTreeView; const T: TCustomShellListView);
begin Self.ShellListView := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomShellTreeViewShellListView_R(Self: TCustomShellTreeView; var T: TCustomShellListView);
begin T := Self.ShellListView; end;

(*----------------------------------------------------------------------------*)
procedure TCustomShellTreeViewShellComboBox_W(Self: TCustomShellTreeView; const T: TCustomShellComboBox);
begin Self.ShellComboBox := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomShellTreeViewShellComboBox_R(Self: TCustomShellTreeView; var T: TCustomShellComboBox);
begin T := Self.ShellComboBox; end;

(*----------------------------------------------------------------------------*)
procedure TCustomShellTreeViewRoot_W(Self: TCustomShellTreeView; const T: TRoot);
begin Self.Root := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomShellTreeViewRoot_R(Self: TCustomShellTreeView; var T: TRoot);
begin T := Self.Root; end;

(*----------------------------------------------------------------------------*)
procedure TCustomShellTreeViewObjectTypes_W(Self: TCustomShellTreeView; const T: TShellObjectTypes);
begin Self.ObjectTypes := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomShellTreeViewObjectTypes_R(Self: TCustomShellTreeView; var T: TShellObjectTypes);
begin T := Self.ObjectTypes; end;

(*----------------------------------------------------------------------------*)
procedure TCustomShellTreeViewAutoContextMenus_W(Self: TCustomShellTreeView; const T: Boolean);
begin Self.AutoContextMenus := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomShellTreeViewAutoContextMenus_R(Self: TCustomShellTreeView; var T: Boolean);
begin T := Self.AutoContextMenus; end;

(*----------------------------------------------------------------------------*)
procedure TCustomShellTreeViewPath_W(Self: TCustomShellTreeView; const T: string);
begin Self.Path := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomShellTreeViewPath_R(Self: TCustomShellTreeView; var T: string);
begin T := Self.Path; end;

//procedure TCustomShellTreeViewItems_W(Self: TCustomShellTreeView; const T: TListItems);

procedure TCustomShellTreeViewItems_W(Self: TCustomShellTreeView; const T: TTreeNodes);
begin Self.Items:= T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomShellTreeViewItems_R(Self: TCustomShellTreeView; var T: TTreeNodes);
begin T := Self.Items; end;

{procedure TCustomShellTreeViewCol_W(Self: TCustomShellTreeView; const T: string);
begin Self.col := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomShellTreeViewCol_R(Self: TCustomShellTreeView; var T: string);
begin T := Self.Path; end;
}

(*----------------------------------------------------------------------------*)
procedure TCustomShellTreeViewFolders_R(Self: TCustomShellTreeView; var T: TShellFolder; const t1: Integer);
begin T := Self.Folders[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TCustomShellTreeViewAutoRefresh_W(Self: TCustomShellTreeView; const T: boolean);
begin Self.AutoRefresh := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomShellTreeViewAutoRefresh_R(Self: TCustomShellTreeView; var T: boolean);
begin T := Self.AutoRefresh; end;

(*----------------------------------------------------------------------------*)
procedure TCustomShellChangeNotifierOnChange_W(Self: TCustomShellChangeNotifier; const T: TThreadMethod);
begin Self.OnChange := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomShellChangeNotifierOnChange_R(Self: TCustomShellChangeNotifier; var T: TThreadMethod);
begin T := Self.OnChange; end;

(*----------------------------------------------------------------------------*)
procedure TCustomShellChangeNotifierWatchSubTree_W(Self: TCustomShellChangeNotifier; const T: Boolean);
begin Self.WatchSubTree := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomShellChangeNotifierWatchSubTree_R(Self: TCustomShellChangeNotifier; var T: Boolean);
begin T := Self.WatchSubTree; end;

(*----------------------------------------------------------------------------*)
procedure TCustomShellChangeNotifierRoot_W(Self: TCustomShellChangeNotifier; const T: TRoot);
begin Self.Root := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomShellChangeNotifierRoot_R(Self: TCustomShellChangeNotifier; var T: TRoot);
begin T := Self.Root; end;

(*----------------------------------------------------------------------------*)
procedure TCustomShellChangeNotifierNotifyFilters_W(Self: TCustomShellChangeNotifier; const T: TNotifyFilters);
begin Self.NotifyFilters := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomShellChangeNotifierNotifyFilters_R(Self: TCustomShellChangeNotifier; var T: TNotifyFilters);
begin T := Self.NotifyFilters; end;

(*----------------------------------------------------------------------------*)
procedure TShellChangeThreadChangeEvent_W(Self: TShellChangeThread; const T: TThreadMethod);
begin Self.ChangeEvent := T; end;

(*----------------------------------------------------------------------------*)
procedure TShellChangeThreadChangeEvent_R(Self: TShellChangeThread; var T: TThreadMethod);
begin T := Self.ChangeEvent; end;

(*----------------------------------------------------------------------------*)
procedure TShellFolderViewHandle_W(Self: TShellFolder; const T: THandle);
begin Self.ViewHandle := T; end;

(*----------------------------------------------------------------------------*)
procedure TShellFolderViewHandle_R(Self: TShellFolder; var T: THandle);
begin T := Self.ViewHandle; end;

(*----------------------------------------------------------------------------*)
procedure TShellFolderShellDetails_R(Self: TShellFolder; var T: IShellDetails);
begin T := Self.ShellDetails; end;

(*----------------------------------------------------------------------------*)
procedure TShellFolderShellFolder2_R(Self: TShellFolder; var T: IShellFolder2);
begin T := Self.ShellFolder2; end;

(*----------------------------------------------------------------------------*)
procedure TShellFolderShellFolder_R(Self: TShellFolder; var T: IShellFolder);
begin T := Self.ShellFolder; end;

(*----------------------------------------------------------------------------*)
procedure TShellFolderRelativeID_R(Self: TShellFolder; var T: PItemIDList);
begin T := Self.RelativeID; end;

(*----------------------------------------------------------------------------*)
procedure TShellFolderParent_R(Self: TShellFolder; var T: TShellFolder);
begin T := Self.Parent; end;

(*----------------------------------------------------------------------------*)
procedure TShellFolderLevel_R(Self: TShellFolder; var T: Integer);
begin T := Self.Level; end;

(*----------------------------------------------------------------------------*)
procedure TShellFolderDetails_W(Self: TShellFolder; const T: string; const t1: integer);
begin Self.Details[t1] := T; end;

(*----------------------------------------------------------------------------*)
procedure TShellFolderDetails_R(Self: TShellFolder; var T: string; const t1: integer);
begin T := Self.Details[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TShellFolderAbsoluteID_R(Self: TShellFolder; var T: PItemIDLIst);
begin T := Self.AbsoluteID; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_ShellCtrls_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@InvokeContextMenu, 'InvokeContextMenu', cdRegister);
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TShellListView(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TShellListView) do  begin
   RegisterPropertyHelper(@TCustomShellListViewItems_R,@TCustomShellListViewItems_W,'Items');
   end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TCustomShellListView(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TCustomShellListView) do begin
    RegisterConstructor(@TCustomShellListView.Create, 'Create');
    RegisterMethod(@TCustomShellListView.Destroy, 'Free');
    RegisterMethod(@TCustomShellListView.Back, 'Back');
    RegisterMethod(@TCustomShellListView.Refresh, 'Refresh');
    RegisterMethod(@TCustomShellListView.SelectedFolder, 'SelectedFolder');
    RegisterPropertyHelper(@TCustomShellListViewFolders_R,nil,'Folders');
    RegisterPropertyHelper(@TCustomShellListViewItems_R,@TCustomShellListViewItems_W,'Items');
    RegisterPropertyHelper(@TCustomShellListViewRootFolder_R,nil,'RootFolder');
    RegisterPropertyHelper(@TCustomShellListViewAutoContextMenus_R,@TCustomShellListViewAutoContextMenus_W,'AutoContextMenus');
    RegisterPropertyHelper(@TCustomShellListViewAutoRefresh_R,@TCustomShellListViewAutoRefresh_W,'AutoRefresh');
    RegisterPropertyHelper(@TCustomShellListViewAutoNavigate_R,@TCustomShellListViewAutoNavigate_W,'AutoNavigate');
    RegisterPropertyHelper(@TCustomShellListViewObjectTypes_R,@TCustomShellListViewObjectTypes_W,'ObjectTypes');
    RegisterPropertyHelper(@TCustomShellListViewRoot_R,@TCustomShellListViewRoot_W,'Root');
    RegisterPropertyHelper(@TCustomShellListViewShellTreeView_R,@TCustomShellListViewShellTreeView_W,'ShellTreeView');
    RegisterPropertyHelper(@TCustomShellListViewShellComboBox_R,@TCustomShellListViewShellComboBox_W,'ShellComboBox');
    RegisterPropertyHelper(@TCustomShellListViewSorted_R,@TCustomShellListViewSorted_W,'Sorted');
    RegisterPropertyHelper(@TCustomShellListViewOnAddFolder_R,@TCustomShellListViewOnAddFolder_W,'OnAddFolder');
    RegisterPropertyHelper(@TCustomShellListViewOnEditing_R,@TCustomShellListViewOnEditing_W,'OnEditing');
    RegisterMethod(@TCustomShellListView.CommandCompleted, 'CommandCompleted');
    RegisterMethod(@TCustomShellListView.ExecuteCommand, 'ExecuteCommand');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TShellComboBox(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TShellComboBox) do begin
       RegisterPropertyHelper(@TCustomShellComboBoxItems_R,@TCustomShellComboBoxItems_W,'Items');
   end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TCustomShellComboBox(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TCustomShellComboBox) do begin
    RegisterConstructor(@TCustomShellComboBox.Create, 'Create');
      RegisterMethod(@TCustomShellComboBox.Destroy, 'Free');
      RegisterPropertyHelper(@TCustomShellComboBoxPath_R,@TCustomShellComboBoxPath_W,'Path');
      RegisterPropertyHelper(@TCustomShellComboBoxItems_R,@TCustomShellComboBoxItems_W,'Items');
      RegisterPropertyHelper(@TCustomShellComboBoxFolders_R,nil,'Folders');
    RegisterPropertyHelper(@TCustomShellComboBoxRoot_R,@TCustomShellComboBoxRoot_W,'Root');
    RegisterPropertyHelper(@TCustomShellComboBoxObjectTypes_R,@TCustomShellComboBoxObjectTypes_W,'ObjectTypes');
    RegisterPropertyHelper(@TCustomShellComboBoxShellTreeView_R,@TCustomShellComboBoxShellTreeView_W,'ShellTreeView');
    RegisterPropertyHelper(@TCustomShellComboBoxShellListView_R,@TCustomShellComboBoxShellListView_W,'ShellListView');
    RegisterPropertyHelper(@TCustomShellComboBoxUseShellImages_R,@TCustomShellComboBoxUseShellImages_W,'UseShellImages');
    RegisterPropertyHelper(@TCustomShellComboBoxOnGetImageIndex_R,@TCustomShellComboBoxOnGetImageIndex_W,'OnGetImageIndex');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TShellTreeView(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TShellTreeView) do begin
   RegisterPropertyHelper(@TCustomShellTreeViewItems_R,@TCustomShellTreeViewItems_W,'Items');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TCustomShellTreeView(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TCustomShellTreeView) do begin
    RegisterConstructor(@TCustomShellTreeView.Create, 'Create');
        RegisterMethod(@TCustomShellTreeView.Destroy, 'Free');
     RegisterMethod(@TCustomShellTreeView.Refresh, 'Refresh');
    RegisterMethod(@TCustomShellTreeView.SelectedFolder, 'SelectedFolder');
    RegisterPropertyHelper(@TCustomShellTreeViewAutoRefresh_R,@TCustomShellTreeViewAutoRefresh_W,'AutoRefresh');
    RegisterPropertyHelper(@TCustomShellTreeViewFolders_R,nil,'Folders');
    RegisterPropertyHelper(@TCustomShellTreeViewRootFolder_R,nil,'RootFolder');
    RegisterPropertyHelper(@TCustomShellTreeViewPath_R,@TCustomShellTreeViewPath_W,'Path');
    RegisterPropertyHelper(@TCustomShellTreeViewItems_R,@TCustomShellTreeViewItems_W,'Items');
    //RegisterPropertyHelper(@TCustomShellTreeViewCol_R,@TCustomShellTreeViewCol_W,'Columns');
    RegisterPropertyHelper(@TCustomShellTreeViewAutoContextMenus_R,@TCustomShellTreeViewAutoContextMenus_W,'AutoContextMenus');
    RegisterPropertyHelper(@TCustomShellTreeViewObjectTypes_R,@TCustomShellTreeViewObjectTypes_W,'ObjectTypes');
    RegisterPropertyHelper(@TCustomShellTreeViewRoot_R,@TCustomShellTreeViewRoot_W,'Root');
    RegisterPropertyHelper(@TCustomShellTreeViewShellComboBox_R,@TCustomShellTreeViewShellComboBox_W,'ShellComboBox');
    RegisterPropertyHelper(@TCustomShellTreeViewShellListView_R,@TCustomShellTreeViewShellListView_W,'ShellListView');
    RegisterPropertyHelper(@TCustomShellTreeViewUseShellImages_R,@TCustomShellTreeViewUseShellImages_W,'UseShellImages');
    RegisterPropertyHelper(@TCustomShellTreeViewOnAddFolder_R,@TCustomShellTreeViewOnAddFolder_W,'OnAddFolder');
    RegisterMethod(@TCustomShellTreeView.CommandCompleted, 'CommandCompleted');
    RegisterMethod(@TCustomShellTreeView.ExecuteCommand, 'ExecuteCommand');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TShellChangeNotifier(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TShellChangeNotifier) do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TCustomShellChangeNotifier(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TCustomShellChangeNotifier) do
  begin
    RegisterConstructor(@TCustomShellChangeNotifier.Create, 'Create');
    RegisterPropertyHelper(@TCustomShellChangeNotifierNotifyFilters_R,@TCustomShellChangeNotifierNotifyFilters_W,'NotifyFilters');
    RegisterPropertyHelper(@TCustomShellChangeNotifierRoot_R,@TCustomShellChangeNotifierRoot_W,'Root');
    RegisterPropertyHelper(@TCustomShellChangeNotifierWatchSubTree_R,@TCustomShellChangeNotifierWatchSubTree_W,'WatchSubTree');
    RegisterPropertyHelper(@TCustomShellChangeNotifierOnChange_R,@TCustomShellChangeNotifierOnChange_W,'OnChange');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TShellChangeThread(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TShellChangeThread) do
  begin
    RegisterVirtualConstructor(@TShellChangeThread.Create, 'Create');
    RegisterMethod(@TShellChangeThread.SetDirectoryOptions, 'SetDirectoryOptions');
    RegisterPropertyHelper(@TShellChangeThreadChangeEvent_R,@TShellChangeThreadChangeEvent_W,'ChangeEvent');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TShellFolder(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TShellFolder) do
  begin
    RegisterVirtualConstructor(@TShellFolder.Create, 'Create');
    RegisterMethod(@TShellFolder.Capabilities, 'Capabilities');
    RegisterMethod(@TShellFolder.DisplayName, 'DisplayName');
    RegisterMethod(@TShellFolder.ExecuteDefault, 'ExecuteDefault');
    RegisterMethod(@TShellFolder.ImageIndex, 'ImageIndex');
    RegisterMethod(@TShellFolder.IsFolder, 'IsFolder');
    RegisterMethod(@TShellFolder.ParentShellFolder, 'ParentShellFolder');
    RegisterMethod(@TShellFolder.PathName, 'PathName');
    RegisterMethod(@TShellFolder.Properties, 'Properties');
    RegisterMethod(@TShellFolder.Rename, 'Rename');
    RegisterMethod(@TShellFolder.SubFolders, 'SubFolders');
    RegisterPropertyHelper(@TShellFolderAbsoluteID_R,nil,'AbsoluteID');
    RegisterPropertyHelper(@TShellFolderDetails_R,@TShellFolderDetails_W,'Details');
    RegisterPropertyHelper(@TShellFolderLevel_R,nil,'Level');
    RegisterPropertyHelper(@TShellFolderParent_R,nil,'Parent');
    RegisterPropertyHelper(@TShellFolderRelativeID_R,nil,'RelativeID');
    RegisterPropertyHelper(@TShellFolderShellFolder_R,nil,'ShellFolder');
    RegisterPropertyHelper(@TShellFolderShellFolder2_R,nil,'ShellFolder2');
    RegisterPropertyHelper(@TShellFolderShellDetails_R,nil,'ShellDetails');
    RegisterPropertyHelper(@TShellFolderViewHandle_R,@TShellFolderViewHandle_W,'ViewHandle');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_ShellCtrls(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(EInvalidPath) do
  RIRegister_TShellFolder(CL);
  RIRegister_TShellChangeThread(CL);
  RIRegister_TCustomShellChangeNotifier(CL);
  RIRegister_TShellChangeNotifier(CL);
  with CL.Add(TCustomShellComboBox) do
  with CL.Add(TCustomShellListView) do
  RIRegister_TCustomShellTreeView(CL);
  RIRegister_TShellTreeView(CL);
  RIRegister_TCustomShellComboBox(CL);
  RIRegister_TShellComboBox(CL);
  RIRegister_TCustomShellListView(CL);
  RIRegister_TShellListView(CL);
end;

 
 
{ TPSImport_ShellCtrls }
(*----------------------------------------------------------------------------*)
procedure TPSImport_ShellCtrls.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_ShellCtrls(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_ShellCtrls.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_ShellCtrls_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
