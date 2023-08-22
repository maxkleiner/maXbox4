unit uPSI_ActnMan;
{
  to customizedlg
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
  TPSImport_ActnMan = class(TPSPlugin)
  public
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TActionBarStyleList(CL: TPSPascalCompiler);
procedure SIRegister_TXToolDockForm(CL: TPSPascalCompiler);
procedure SIRegister_IActionBarDesigner(CL: TPSPascalCompiler);
procedure SIRegister_TCustomActionControl(CL: TPSPascalCompiler);
procedure SIRegister_TCustomActionBar(CL: TPSPascalCompiler);
procedure SIRegister_TCustomActionBarColorMap(CL: TPSPascalCompiler);
procedure SIRegister_TActionItemDragObject(CL: TPSPascalCompiler);
procedure SIRegister_TCategoryDragObject(CL: TPSPascalCompiler);
procedure SIRegister_TActionDragObject(CL: TPSPascalCompiler);
procedure SIRegister_TActionDragBaseClass(CL: TPSPascalCompiler);
procedure SIRegister_TActionClientItem(CL: TPSPascalCompiler);
procedure SIRegister_TActionClientLink(CL: TPSPascalCompiler);
procedure SIRegister_TActionClients(CL: TPSPascalCompiler);
procedure SIRegister_TActionBars(CL: TPSPascalCompiler);
procedure SIRegister_TActionBarItem(CL: TPSPascalCompiler);
procedure SIRegister_TActionClient(CL: TPSPascalCompiler);
procedure SIRegister_TActionClientsCollection(CL: TPSPascalCompiler);
procedure SIRegister_TActionListCollection(CL: TPSPascalCompiler);
procedure SIRegister_TActionListItem(CL: TPSPascalCompiler);
procedure SIRegister_TActionManager(CL: TPSPascalCompiler);
procedure SIRegister_TCustomActionManager(CL: TPSPascalCompiler);
procedure SIRegister_TActionBarStyle(CL: TPSPascalCompiler);
procedure SIRegister_ActnMan(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TActionBarStyleList(CL: TPSRuntimeClassImporter);
procedure RIRegister_ActnMan_Routines(S: TPSExec);
procedure RIRegister_TXToolDockForm(CL: TPSRuntimeClassImporter);
procedure RIRegister_TCustomActionControl(CL: TPSRuntimeClassImporter);
procedure RIRegister_TCustomActionBar(CL: TPSRuntimeClassImporter);
procedure RIRegister_TCustomActionBarColorMap(CL: TPSRuntimeClassImporter);
procedure RIRegister_TActionItemDragObject(CL: TPSRuntimeClassImporter);
procedure RIRegister_TCategoryDragObject(CL: TPSRuntimeClassImporter);
procedure RIRegister_TActionDragObject(CL: TPSRuntimeClassImporter);
procedure RIRegister_TActionDragBaseClass(CL: TPSRuntimeClassImporter);
procedure RIRegister_TActionClientItem(CL: TPSRuntimeClassImporter);
procedure RIRegister_TActionClientLink(CL: TPSRuntimeClassImporter);
procedure RIRegister_TActionClients(CL: TPSRuntimeClassImporter);
procedure RIRegister_TActionBars(CL: TPSRuntimeClassImporter);
procedure RIRegister_TActionBarItem(CL: TPSRuntimeClassImporter);
procedure RIRegister_TActionClient(CL: TPSRuntimeClassImporter);
procedure RIRegister_TActionClientsCollection(CL: TPSRuntimeClassImporter);
procedure RIRegister_TActionListCollection(CL: TPSRuntimeClassImporter);
procedure RIRegister_TActionListItem(CL: TPSRuntimeClassImporter);
procedure RIRegister_TActionManager(CL: TPSRuntimeClassImporter);
procedure RIRegister_TCustomActionManager(CL: TPSRuntimeClassImporter);
procedure RIRegister_TActionBarStyle(CL: TPSRuntimeClassImporter);
procedure RIRegister_ActnMan(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   Windows
  ,Messages
  ,Forms
  ,Menus
  ,ActnList
  ,Graphics
  ,ToolWin
  ,ImgList
  ,Controls
  ,Buttons
  ,OleAcc
  ,ActnMan
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_ActnMan]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TActionBarStyleList(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TStringList', 'TActionBarStyleList') do
  with CL.AddClassN(CL.FindClass('TStringList'),'TActionBarStyleList') do
  begin
    RegisterProperty('Style', 'TActionBarStyle Integer', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TXToolDockForm(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TToolDockForm', 'TXToolDockForm') do
  with CL.AddClassN(CL.FindClass('TToolDockForm'),'TXToolDockForm') do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_IActionBarDesigner(CL: TPSPascalCompiler);
begin
  //with RegInterfaceS(CL,'IUNKNOWN', 'IActionBarDesigner') do
  with CL.AddInterface(CL.FindInterface('IUNKNOWN'),IActionBarDesigner, 'IActionBarDesigner') do
  begin
    RegisterMethod('Function CreateAction( AnActionClass : TContainedActionClass) : TContainedAction', cdRegister);
    RegisterMethod('Procedure EditAction( Action : TContainedAction)', cdRegister);
    RegisterMethod('Procedure Modified( ActionBar : TCustomActionBar)', cdRegister);
    RegisterMethod('Procedure SetActiveMenu( Menu : TCustomActionBar)', cdRegister);
    RegisterMethod('Procedure SetItemSelection( const Items : array of TActionClient)', cdRegister);
    RegisterMethod('Procedure SetSelection( APersistent : TPersistent)', cdRegister);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TCustomActionControl(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TGraphicControl', 'TCustomActionControl') do
  with CL.AddClassN(CL.FindClass('TGraphicControl'),'TCustomActionControl') do
  begin
    RegisterMethod('Procedure CalcBounds');
    RegisterMethod('Procedure Keyed');
    RegisterProperty('ActionBar', 'TCustomActionBar', iptr);
    RegisterProperty('ActionClient', 'TActionClientItem', iptrw);
    RegisterProperty('DropPoint', 'Boolean', iptrw);
    RegisterProperty('GlyphLayout', 'TButtonLayout', iptrw);
    RegisterProperty('Margins', 'TRect', iptrw);
    RegisterProperty('Selected', 'Boolean', iptrw);
    RegisterProperty('Separator', 'Boolean', iptr);
    RegisterProperty('ShowCaption', 'Boolean', iptr);
    RegisterProperty('ShowShortCut', 'Boolean', iptr);
    RegisterProperty('SmallIcon', 'Boolean', iptrw);
    RegisterProperty('Spacing', 'Integer', iptrw);
    RegisterProperty('TextBounds', 'TRect', iptrw);
    RegisterProperty('Transparent', 'Boolean', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TCustomActionBar(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TToolWindow', 'TCustomActionBar') do
  with CL.AddClassN(CL.FindClass('TToolWindow'),'TCustomActionBar') do
  begin
    RegisterMethod('Function FindFirst : TActionClientItem');
    RegisterMethod('Function FindFirstVisibleItem : TActionClientItem');
    RegisterMethod('Function FindLastVisibleItem : TActionClientItem');
    RegisterMethod('Procedure RecreateControls');
    RegisterMethod('Function Style : TActionBarStyle');
    RegisterProperty('ActionManager', 'TCustomActionManager', iptrw);
    RegisterProperty('ActionClient', 'TActionClient', iptrw);
    RegisterProperty('AllowHiding', 'Boolean', iptrw);
    RegisterProperty('AutoSizing', 'Boolean', iptrw);
    RegisterProperty('Canvas', 'TCanvas', iptr);
    RegisterProperty('ColorMap', 'TCustomActionBarColorMap', iptrw);
    RegisterProperty('ContextBar', 'Boolean', iptrw);
    RegisterProperty('Designable', 'Boolean', iptrw);
    RegisterProperty('DesignMode', 'Boolean', iptrw);
    RegisterProperty('HorzMargin', 'Integer', iptrw);
    RegisterProperty('HorzSeparator', 'Boolean', iptrw);
    RegisterProperty('Orientation', 'TBarOrientation', iptrw);
    RegisterProperty('PersistentHotKeys', 'Boolean', iptrw);
    RegisterProperty('ActionControls', 'TCustomActionControl Integer', iptr);
    RegisterProperty('Spacing', 'Integer', iptrw);
    RegisterProperty('VertMargin', 'Integer', iptrw);
    RegisterProperty('VertSeparator', 'Boolean', iptrw);
    RegisterProperty('OnControlCreated', 'TControlCreatedEvent', iptrw);
    RegisterProperty('OnGetControlClass', 'TGetControlClassEvent', iptrw);
    RegisterProperty('OnPaint', 'TNotifyEvent', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TCustomActionBarColorMap(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TComponent', 'TCustomActionBarColorMap') do
  with CL.AddClassN(CL.FindClass('TComponent'),'TCustomActionBarColorMap') do
  begin
    RegisterMethod('Procedure UpdateColors');
    RegisterProperty('BtnFrameColor', 'TColor', iptrw);
    RegisterProperty('BtnSelectedColor', 'TColor', iptrw);
    RegisterProperty('BtnSelectedFont', 'TColor', iptrw);
    RegisterProperty('Color', 'TColor', iptrw);
    RegisterProperty('DesignFocus', 'TColor', iptrw);
    RegisterProperty('DisabledColor', 'TColor', iptrw);
    RegisterProperty('DisabledFontColor', 'TColor', iptrw);
    RegisterProperty('DisabledFontShadow', 'TColor', iptrw);
    RegisterProperty('FontColor', 'TColor', iptrw);
    RegisterProperty('FrameTopLeftInner', 'TColor', iptrw);
    RegisterProperty('FrameTopLeftOuter', 'TColor', iptrw);
    RegisterProperty('FrameBottomRightInner', 'TColor', iptrw);
    RegisterProperty('FrameBottomRightOuter', 'TColor', iptrw);
    RegisterProperty('HighlightColor', 'TColor', iptrw);
    RegisterProperty('HotColor', 'TColor', iptrw);
    RegisterProperty('HotFontColor', 'TColor', iptrw);
    RegisterProperty('MenuColor', 'TColor', iptrw);
    RegisterProperty('SelectedColor', 'TColor', iptrw);
    RegisterProperty('SelectedFontColor', 'TColor', iptrw);
    RegisterProperty('ShadowColor', 'TColor', iptrw);
    RegisterProperty('UnusedColor', 'TColor', iptrw);
    RegisterProperty('OnColorChange', 'TNotifyEvent', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TActionItemDragObject(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TActionDragBaseClass', 'TActionItemDragObject') do
  with CL.AddClassN(CL.FindClass('TActionDragBaseClass'),'TActionItemDragObject') do
  begin
    RegisterProperty('ClientItem', 'TActionClientItem', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TCategoryDragObject(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TActionDragObject', 'TCategoryDragObject') do
  with CL.AddClassN(CL.FindClass('TActionDragObject'),'TCategoryDragObject') do
  begin
    RegisterMethod('Constructor Create( ACategory : string)');
    RegisterProperty('Category', 'string', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TActionDragObject(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TActionDragBaseClass', 'TActionDragObject') do
  with CL.AddClassN(CL.FindClass('TActionDragBaseClass'),'TActionDragObject') do
  begin
    RegisterMethod('Constructor Create');
    RegisterMethod('Procedure AddAction( AnAction : TContainedAction)');
    RegisterMethod('Procedure AddActionClass( AnActionClass : TCustomActionClass)');
    RegisterProperty('ActionCount', 'Integer', iptr);
    RegisterProperty('Actions', 'TContainedAction Integer', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TActionDragBaseClass(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TDragObjectEx', 'TActionDragBaseClass') do
  with CL.AddClassN(CL.FindClass('TDragObjectEx'),'TActionDragBaseClass') do
  begin
    RegisterProperty('ActionManager', 'TCustomActionManager', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TActionClientItem(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TActionClient', 'TActionClientItem') do
  with CL.AddClassN(CL.FindClass('TActionClient'),'TActionClientItem') do
  begin
    RegisterMethod('Constructor Create( Collection : TCollection)');
    RegisterMethod('Procedure Assign( Source : TPersistent)');
    RegisterMethod('Function HasGlyph : Boolean');
    RegisterMethod('Procedure InitiateAction');
    RegisterMethod('Function Unused : Boolean');
    RegisterProperty('ActionClients', 'TActionClients', iptr);
    RegisterProperty('ActionLink', 'TActionClientLink', iptrw);
    RegisterProperty('CheckUnused', 'Boolean', iptrw);
    RegisterProperty('Control', 'TCustomActionControl', iptrw);
    RegisterProperty('ParentItem', 'TActionClient', iptr);
    RegisterProperty('Separator', 'Boolean', iptr);
    RegisterProperty('ShortCutText', 'string', iptr);
    RegisterProperty('Action', 'TContainedAction', iptrw);
    RegisterProperty('Caption', 'string', iptrw);
    RegisterProperty('HelpContext', 'THelpContext', iptrw);
    RegisterProperty('ImageIndex', 'TImageIndex', iptrw);
    RegisterProperty('MergeIndex', 'TMergeRange', iptrw);
    RegisterProperty('LastSession', 'Integer', iptrw);
    RegisterProperty('ShowCaption', 'Boolean', iptrw);
    RegisterProperty('ShowGlyph', 'Boolean', iptrw);
    RegisterProperty('ShowShortCut', 'Boolean', iptrw);
    RegisterProperty('ShortCut', 'TShortCut', iptrw);
    RegisterProperty('UsageCount', 'Integer', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TActionClientLink(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TActionLink', 'TActionClientLink') do
  with CL.AddClassN(CL.FindClass('TActionLink'),'TActionClientLink') do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TActionClients(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TActionClientsCollection', 'TActionClients') do
  with CL.AddClassN(CL.FindClass('TActionClientsCollection'),'TActionClients') do
  begin
    RegisterMethod('Constructor Create( AOwner : TPersistent; ItemClass : TCollectionItemClass)');
    RegisterMethod('Function Add : TActionClientItem');
    RegisterMethod('Procedure Assign( Source : TPersistent)');
    RegisterMethod('Function VisibleCount : Integer');
    RegisterProperty('ActionClients', 'TActionClientItem Integer', iptrw);
    SetDefaultPropery('ActionClients');
    RegisterProperty('ActionManager', 'TCustomActionManager', iptr);
    RegisterProperty('HideUnused', 'Boolean', iptrw);
    RegisterProperty('CaptionOptions', 'TCaptionOptions', iptrw);
    RegisterProperty('SmallIcons', 'Boolean', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TActionBars(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TActionClientsCollection', 'TActionBars') do
  with CL.AddClassN(CL.FindClass('TActionClientsCollection'),'TActionBars') do
  begin
    RegisterMethod('Constructor Create( AOwner : TPersistent; ItemClass : TCollectionItemClass)');
    RegisterMethod('Function Add : TActionBarItem');
    RegisterProperty('ActionBars', 'TActionBarItem Integer', iptr);
    SetDefaultPropery('ActionBars');
    RegisterProperty('HintShortCuts', 'Boolean', iptrw);
    RegisterProperty('SessionCount', 'Integer', iptrw);
    RegisterProperty('ShowHints', 'Boolean', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TActionBarItem(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TActionClient', 'TActionBarItem') do
  with CL.AddClassN(CL.FindClass('TActionClient'),'TActionBarItem') do
  begin
    RegisterMethod('Constructor Create( Collection : TCollection)');
    RegisterMethod('Procedure Refresh');
    RegisterProperty('AutoSize', 'Boolean', iptrw);
    RegisterProperty('GlyphLayout', 'TButtonLayout', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TActionClient(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TCollectionItem', 'TActionClient') do
  with CL.AddClassN(CL.FindClass('TCollectionItem'),'TActionClient') do
  begin
    RegisterMethod('Constructor Create( Collection : TCollection)');
    RegisterMethod('Procedure Assign( Source : TPersistent)');
    RegisterMethod('Function HasBackground : Boolean');
    RegisterMethod('Procedure Refresh');
    RegisterProperty('ActionBar', 'TCustomActionBar', iptrw);
    RegisterProperty('Accessible', 'IAccessible', iptrw);
    RegisterProperty('ChildActionBar', 'TCustomActionBar', iptrw);
    RegisterProperty('HasItems', 'Boolean', iptr);
    RegisterProperty('OwningCollection', 'TActionClientsCollection', iptr);
    RegisterProperty('ChangesAllowed', 'TChangesAllowedSet', iptrw);
    RegisterProperty('Color', 'TColor', iptrw);
    RegisterProperty('ContextItems', 'TActionClients', iptrw);
    RegisterProperty('Background', 'TPicture', iptrw);
    RegisterProperty('BackgroundLayout', 'TBackgroundLayout', iptrw);
    RegisterProperty('Items', 'TActionClients', iptrw);
    RegisterProperty('Tag', 'Integer', iptrw);
    RegisterProperty('Visible', 'Boolean', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TActionClientsCollection(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOwnedCollection', 'TActionClientsCollection') do
  with CL.AddClassN(CL.FindClass('TOwnedCollection'),'TActionClientsCollection') do
  begin
    RegisterMethod('Procedure AfterConstruction');
    RegisterMethod('Procedure IterateClients( Clients : TActionClientsCollection; ActionProc : TActionProc)');
    RegisterProperty('ActionManager', 'TCustomActionManager', iptr);
    RegisterProperty('AutoHotKeys', 'Boolean', iptrw);
    RegisterProperty('Customizable', 'Boolean', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TActionListCollection(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOwnedCollection', 'TActionListCollection') do
  with CL.AddClassN(CL.FindClass('TOwnedCollection'),'TActionListCollection') do
  begin
    RegisterProperty('ActionManager', 'TCustomActionManager', iptr);
    RegisterProperty('ListItems', 'TActionListItem Integer', iptrw);
    SetDefaultPropery('ListItems');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TActionListItem(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TCollectionItem', 'TActionListItem') do
  with CL.AddClassN(CL.FindClass('TCollectionItem'),'TActionListItem') do
  begin
    RegisterProperty('ActionList', 'TCustomActionList', iptrw);
    RegisterProperty('Caption', 'string', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TActionManager(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TCustomActionManager', 'TActionManager') do
  with CL.AddClassN(CL.FindClass('TCustomActionManager'),'TActionManager') do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TCustomActionManager(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TCustomActionList', 'TCustomActionManager') do
  with CL.AddClassN(CL.FindClass('TCustomActionList'),'TCustomActionManager') do
  begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
    RegisterMethod('Function AddAction( AnAction : TCustomAction; AClient : TActionClient; After : Boolean) : TActionClientItem');
    RegisterMethod('Function AddCategory( ACategory : string; AClient : TActionClient; After : Boolean) : TActionClientItem');
    RegisterMethod('Function AddSeparator( AnItem : TActionClientItem; After : Boolean) : TActionClientItem');
    RegisterMethod('Procedure DeleteActionItems( Actions : array of TCustomAction)');
    RegisterMethod('Procedure DeleteItem( Caption : string)');
    RegisterMethod('Function FindItemByCaption( ACaption : string) : TActionClientItem');
    RegisterMethod('Function FindItemByAction( Action : TCustomAction) : TActionClientItem');
    RegisterMethod('Procedure LoadFromFile( const Filename : string)');
    RegisterMethod('Procedure LoadFromStream( S : TStream)');
    RegisterMethod('Procedure ResetActionBar( Index : Integer)');
    RegisterMethod('Procedure ResetUsageData');
    RegisterMethod('Procedure SaveToFile( const Filename : string)');
    RegisterMethod('Procedure SaveToStream( S : TStream)');
    RegisterProperty('ActionBars', 'TActionBars', iptrw);
    RegisterProperty('DefaultActionBars', 'TActionBars', iptr);
    RegisterProperty('LinkedActionLists', 'TActionListCollection', iptrw);
    RegisterProperty('FileName', 'TFileName', iptrw);
    RegisterProperty('PrioritySchedule', 'TStringList', iptrw);
    RegisterProperty('Style', 'TActionBarStyle', iptrw);
    RegisterProperty('OnStyleChanged', 'TStyleChanged', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TActionBarStyle(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOBJECT', 'TActionBarStyle') do
  with CL.AddClassN(CL.FindClass('TOBJECT'),'TActionBarStyle') do
  begin
    RegisterMethod('Function GetControlClass( ActionBar : TCustomActionBar; AnItem : TActionClientItem) : TCustomActionControlClass');
    RegisterMethod('Function GetColorMapClass( ActionBar : TCustomActionBar) : TCustomColorMapClass');
    RegisterMethod('Function GetStyleName : string');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_ActnMan(CL: TPSPascalCompiler);
begin
 CL.AddConstantN('CM_ITEMSELECTED','LongWord').SetUInt( CM_BASE + $0402);
 CL.AddConstantN('CM_ITEMCLICKED','LongWord').SetUInt( CM_BASE + $0403);
 CL.AddConstantN('CM_ITEMKEYED','LongWord').SetUInt( CM_BASE + $0404);
 CL.AddConstantN('CM_SCROLLCLICKED','LongWord').SetUInt( CM_BASE + $0406);
 CL.AddConstantN('CM_RESETBAR','LongWord').SetUInt( CM_BASE + $0409);
 CL.AddConstantN('CM_ENTERMENULOOP','LongWord').SetUInt( CM_BASE + $0410);
 CL.AddConstantN('CM_ITEMDROPPOINT','LongWord').SetUInt( CM_BASE + $0411);
  CL.AddClassN(CL.FindClass('TOBJECT'),'TActionBars');
  CL.AddClassN(CL.FindClass('TOBJECT'),'TActionListCollection');
  CL.AddClassN(CL.FindClass('TOBJECT'),'TActionClientsCollection');
  CL.AddClassN(CL.FindClass('TOBJECT'),'TActionClientItem');
  //CL.AddTypeS('TActionClientItemClass', 'class of TActionClientItem');
  CL.AddClassN(CL.FindClass('TOBJECT'),'TCustomActionBar');
  CL.AddClassN(CL.FindClass('TOBJECT'),'TActionClient');
  CL.AddClassN(CL.FindClass('TOBJECT'),'TActionClients');
  //CL.AddTypeS('TActionClientsClass', 'class of TActionClients');
  //CL.AddTypeS('TActionBarsClass', 'class of TActionBars');
  CL.AddClassN(CL.FindClass('TOBJECT'),'TActionBarItem');
  //CL.AddTypeS('TActionBarItemClass', 'class of TActionBarItem');
  CL.AddClassN(CL.FindClass('TOBJECT'),'TCustomActionManager');
  //CL.AddTypeS('TGetBarsClassEvent', 'Procedure ( Sender : TCustomActionManager;'
  // +' BarsClass : TActionBarsClass)');
  {CL.AddTypeS('TGetBarItemClassEvent', 'Procedure ( Sender : TCustomActionManag'
   +'er; var BarItemClass : TActionBarItemClass)');
  CL.AddTypeS('TGetClientsClassEvent', 'Procedure ( Sender : TCustomActionManag'
   +'er; var ClientsClass : TActionClientsClass)');
  CL.AddTypeS('TGetClientItemClassEvent', 'Procedure ( Sender : TCustomActionMa'
   +'nager; var ClientItemClass : TActionClientItemClass)');}
  CL.AddTypeS('TStyleChanged', 'Procedure ( Sender : TCustomActionManager)');
  CL.AddTypeS('TActionProc', 'Procedure ( AClient : TActionClient)');
  CL.AddClassN(CL.FindClass('TOBJECT'),'TCustomActionControl');
  //CL.AddTypeS('TCustomActionControlClass', 'class of TCustomActionControl');
  CL.AddClassN(CL.FindClass('TOBJECT'),'TCustomActionBarColorMap');
  //CL.AddTypeS('TCustomColorMapClass', 'class of TCustomActionBarColorMap');
  SIRegister_TActionBarStyle(CL);
  SIRegister_TCustomActionManager(CL);
  SIRegister_TActionManager(CL);
  SIRegister_TActionListItem(CL);
  SIRegister_TActionListCollection(CL);
  SIRegister_TActionClientsCollection(CL);
  CL.AddTypeS('TBackgroundLayout', '( blNormal, blStretch, blTile, blLeftBanner, blRightBanner )');
  CL.AddTypeS('TChangesAllowed', '( caModify, caMove, caDelete )');
  CL.AddTypeS('TChangesAllowedSet', 'set of TChangesAllowed');
  SIRegister_TActionClient(CL);
  SIRegister_TActionBarItem(CL);
  SIRegister_TActionBars(CL);
  //CL.AddTypeS('TActionClientClass', 'class of TActionClient');
  CL.AddTypeS('TCaptionOptions', '( coNone, coSelective, coAll )');
  SIRegister_TActionClients(CL);
  CL.AddClassN(CL.FindClass('TOBJECT'),'TActionClientLink');
  //CL.AddTypeS('TActionClientLinkClass', 'class of TActionClientLink');
  SIRegister_TActionClientLink(CL);
  CL.AddTypeS('TMergeRange', 'Integer');
  SIRegister_TActionClientItem(CL);
  SIRegister_TActionDragBaseClass(CL);
  CL.AddClassN(CL.FindClass('TOBJECT'),'TCustomActionClass');
  SIRegister_TActionDragObject(CL);
  SIRegister_TCategoryDragObject(CL);
  SIRegister_TActionItemDragObject(CL);
  SIRegister_TCustomActionBarColorMap(CL);
  //CL.AddTypeS('TCustomActionBarClass', 'class of TCustomActionBar');
  CL.AddTypeS('TBarOrientation', '( boLeftToRight, boRightToLeft, boTopToBottom, boBottomToTop )');
  CL.AddTypeS('TControlCreatedEvent', 'Procedure ( Sender : TObject; var Control : TCustomActionControl)');
  //CL.AddTypeS('TGetControlClassEvent', 'Procedure ( Sender : TCustomActionBar; '
  // +'AnItem : TActionClient; var ControlClass : TCustomActionControlClass)');
  CL.AddTypeS('TBarEdge', '( beLeft, beRight, beEither )');
  SIRegister_TCustomActionBar(CL);
  CL.AddTypeS('TCMItemMsg', 'record Msg : Cardinal; Unused : Integer; Sender : TCustomActionControl; Result : Longint; end');
  SIRegister_TCustomActionControl(CL);
  SIRegister_IActionBarDesigner(CL);
  SIRegister_TXToolDockForm(CL);
 CL.AddDelphiFunction('Procedure NotifyDesigner( ActionBar : TCustomActionBar)');
 CL.AddConstantN('caAllChanges','LongInt').Value.ts32 := ord(caModify) or ord(caMove) or ord(caDelete);
 //CL.AddConstantN('cDefaultSchedule','string').SetString( '0=3' #13#10 '1=3' #13#10 '2=6' #13#10 '3=9' #13#10 + '4=12' #13#10 '5=12' #13#10 '6=17' #13#10 '7=17' #13#10 + '8=17' #13#10 '9=23' #13#10 '10=23' #13#10 '11=23' #13#10 + '12=23' #13#10 '13=23' #13#10 '14=31' #13#10 '15=31' #13#10 + '16=31' #13#10 '17=31' #13#10 '18=31' #13#10 '19=31' #13#10 + '20=31' #13#10 '21=31' #13#10 '22=31' #13#10 '23=31' #13#10 + '24=31' #13#10 '25=31' #13#10);
  SIRegister_TActionBarStyleList(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TActionBarStyleListStyle_R(Self: TActionBarStyleList; var T: TActionBarStyle; const t1: Integer);
begin T := Self.Style[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TCustomActionControlTransparent_W(Self: TCustomActionControl; const T: Boolean);
begin Self.Transparent := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomActionControlTransparent_R(Self: TCustomActionControl; var T: Boolean);
begin T := Self.Transparent; end;

(*----------------------------------------------------------------------------*)
procedure TCustomActionControlTextBounds_W(Self: TCustomActionControl; const T: TRect);
begin Self.TextBounds := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomActionControlTextBounds_R(Self: TCustomActionControl; var T: TRect);
begin T := Self.TextBounds; end;

(*----------------------------------------------------------------------------*)
procedure TCustomActionControlSpacing_W(Self: TCustomActionControl; const T: Integer);
begin Self.Spacing := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomActionControlSpacing_R(Self: TCustomActionControl; var T: Integer);
begin T := Self.Spacing; end;

(*----------------------------------------------------------------------------*)
procedure TCustomActionControlSmallIcon_W(Self: TCustomActionControl; const T: Boolean);
begin Self.SmallIcon := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomActionControlSmallIcon_R(Self: TCustomActionControl; var T: Boolean);
begin T := Self.SmallIcon; end;

(*----------------------------------------------------------------------------*)
procedure TCustomActionControlShowShortCut_R(Self: TCustomActionControl; var T: Boolean);
begin T := Self.ShowShortCut; end;

(*----------------------------------------------------------------------------*)
procedure TCustomActionControlShowCaption_R(Self: TCustomActionControl; var T: Boolean);
begin T := Self.ShowCaption; end;

(*----------------------------------------------------------------------------*)
procedure TCustomActionControlSeparator_R(Self: TCustomActionControl; var T: Boolean);
begin T := Self.Separator; end;

(*----------------------------------------------------------------------------*)
procedure TCustomActionControlSelected_W(Self: TCustomActionControl; const T: Boolean);
begin Self.Selected := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomActionControlSelected_R(Self: TCustomActionControl; var T: Boolean);
begin T := Self.Selected; end;

(*----------------------------------------------------------------------------*)
procedure TCustomActionControlMargins_W(Self: TCustomActionControl; const T: TRect);
begin Self.Margins := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomActionControlMargins_R(Self: TCustomActionControl; var T: TRect);
begin T := Self.Margins; end;

(*----------------------------------------------------------------------------*)
procedure TCustomActionControlGlyphLayout_W(Self: TCustomActionControl; const T: TButtonLayout);
begin Self.GlyphLayout := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomActionControlGlyphLayout_R(Self: TCustomActionControl; var T: TButtonLayout);
begin T := Self.GlyphLayout; end;

(*----------------------------------------------------------------------------*)
procedure TCustomActionControlDropPoint_W(Self: TCustomActionControl; const T: Boolean);
begin Self.DropPoint := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomActionControlDropPoint_R(Self: TCustomActionControl; var T: Boolean);
begin T := Self.DropPoint; end;

(*----------------------------------------------------------------------------*)
procedure TCustomActionControlActionClient_W(Self: TCustomActionControl; const T: TActionClientItem);
begin Self.ActionClient := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomActionControlActionClient_R(Self: TCustomActionControl; var T: TActionClientItem);
begin T := Self.ActionClient; end;

(*----------------------------------------------------------------------------*)
procedure TCustomActionControlActionBar_R(Self: TCustomActionControl; var T: TCustomActionBar);
begin T := Self.ActionBar; end;

(*----------------------------------------------------------------------------*)
procedure TCustomActionBarOnPaint_W(Self: TCustomActionBar; const T: TNotifyEvent);
begin Self.OnPaint := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomActionBarOnPaint_R(Self: TCustomActionBar; var T: TNotifyEvent);
begin T := Self.OnPaint; end;

(*----------------------------------------------------------------------------*)
procedure TCustomActionBarOnGetControlClass_W(Self: TCustomActionBar; const T: TGetControlClassEvent);
begin Self.OnGetControlClass := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomActionBarOnGetControlClass_R(Self: TCustomActionBar; var T: TGetControlClassEvent);
begin T := Self.OnGetControlClass; end;

(*----------------------------------------------------------------------------*)
procedure TCustomActionBarOnControlCreated_W(Self: TCustomActionBar; const T: TControlCreatedEvent);
begin Self.OnControlCreated := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomActionBarOnControlCreated_R(Self: TCustomActionBar; var T: TControlCreatedEvent);
begin T := Self.OnControlCreated; end;

(*----------------------------------------------------------------------------*)
procedure TCustomActionBarVertSeparator_W(Self: TCustomActionBar; const T: Boolean);
begin Self.VertSeparator := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomActionBarVertSeparator_R(Self: TCustomActionBar; var T: Boolean);
begin T := Self.VertSeparator; end;

(*----------------------------------------------------------------------------*)
procedure TCustomActionBarVertMargin_W(Self: TCustomActionBar; const T: Integer);
begin Self.VertMargin := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomActionBarVertMargin_R(Self: TCustomActionBar; var T: Integer);
begin T := Self.VertMargin; end;

(*----------------------------------------------------------------------------*)
procedure TCustomActionBarSpacing_W(Self: TCustomActionBar; const T: Integer);
begin Self.Spacing := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomActionBarSpacing_R(Self: TCustomActionBar; var T: Integer);
begin T := Self.Spacing; end;

(*----------------------------------------------------------------------------*)
procedure TCustomActionBarActionControls_R(Self: TCustomActionBar; var T: TCustomActionControl; const t1: Integer);
begin T := Self.ActionControls[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TCustomActionBarPersistentHotKeys_W(Self: TCustomActionBar; const T: Boolean);
begin Self.PersistentHotKeys := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomActionBarPersistentHotKeys_R(Self: TCustomActionBar; var T: Boolean);
begin T := Self.PersistentHotKeys; end;

(*----------------------------------------------------------------------------*)
procedure TCustomActionBarOrientation_W(Self: TCustomActionBar; const T: TBarOrientation);
begin Self.Orientation := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomActionBarOrientation_R(Self: TCustomActionBar; var T: TBarOrientation);
begin T := Self.Orientation; end;

(*----------------------------------------------------------------------------*)
procedure TCustomActionBarHorzSeparator_W(Self: TCustomActionBar; const T: Boolean);
begin Self.HorzSeparator := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomActionBarHorzSeparator_R(Self: TCustomActionBar; var T: Boolean);
begin T := Self.HorzSeparator; end;

(*----------------------------------------------------------------------------*)
procedure TCustomActionBarHorzMargin_W(Self: TCustomActionBar; const T: Integer);
begin Self.HorzMargin := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomActionBarHorzMargin_R(Self: TCustomActionBar; var T: Integer);
begin T := Self.HorzMargin; end;

(*----------------------------------------------------------------------------*)
procedure TCustomActionBarDesignMode_W(Self: TCustomActionBar; const T: Boolean);
begin Self.DesignMode := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomActionBarDesignMode_R(Self: TCustomActionBar; var T: Boolean);
begin T := Self.DesignMode; end;

(*----------------------------------------------------------------------------*)
procedure TCustomActionBarDesignable_W(Self: TCustomActionBar; const T: Boolean);
begin Self.Designable := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomActionBarDesignable_R(Self: TCustomActionBar; var T: Boolean);
begin T := Self.Designable; end;

(*----------------------------------------------------------------------------*)
procedure TCustomActionBarContextBar_W(Self: TCustomActionBar; const T: Boolean);
begin Self.ContextBar := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomActionBarContextBar_R(Self: TCustomActionBar; var T: Boolean);
begin T := Self.ContextBar; end;

(*----------------------------------------------------------------------------*)
procedure TCustomActionBarColorMap_W(Self: TCustomActionBar; const T: TCustomActionBarColorMap);
begin Self.ColorMap := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomActionBarColorMap_R(Self: TCustomActionBar; var T: TCustomActionBarColorMap);
begin T := Self.ColorMap; end;

(*----------------------------------------------------------------------------*)
procedure TCustomActionBarCanvas_R(Self: TCustomActionBar; var T: TCanvas);
begin T := Self.Canvas; end;

(*----------------------------------------------------------------------------*)
procedure TCustomActionBarAutoSizing_W(Self: TCustomActionBar; const T: Boolean);
begin Self.AutoSizing := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomActionBarAutoSizing_R(Self: TCustomActionBar; var T: Boolean);
begin T := Self.AutoSizing; end;

(*----------------------------------------------------------------------------*)
procedure TCustomActionBarAllowHiding_W(Self: TCustomActionBar; const T: Boolean);
begin Self.AllowHiding := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomActionBarAllowHiding_R(Self: TCustomActionBar; var T: Boolean);
begin T := Self.AllowHiding; end;

(*----------------------------------------------------------------------------*)
procedure TCustomActionBarActionClient_W(Self: TCustomActionBar; const T: TActionClient);
begin Self.ActionClient := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomActionBarActionClient_R(Self: TCustomActionBar; var T: TActionClient);
begin T := Self.ActionClient; end;

(*----------------------------------------------------------------------------*)
procedure TCustomActionBarActionManager_W(Self: TCustomActionBar; const T: TCustomActionManager);
begin Self.ActionManager := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomActionBarActionManager_R(Self: TCustomActionBar; var T: TCustomActionManager);
begin T := Self.ActionManager; end;

(*----------------------------------------------------------------------------*)
procedure TCustomActionBarColorMapOnColorChange_W(Self: TCustomActionBarColorMap; const T: TNotifyEvent);
begin Self.OnColorChange := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomActionBarColorMapOnColorChange_R(Self: TCustomActionBarColorMap; var T: TNotifyEvent);
begin T := Self.OnColorChange; end;

(*----------------------------------------------------------------------------*)
procedure TCustomActionBarColorMapUnusedColor_W(Self: TCustomActionBarColorMap; const T: TColor);
begin Self.UnusedColor := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomActionBarColorMapUnusedColor_R(Self: TCustomActionBarColorMap; var T: TColor);
begin T := Self.UnusedColor; end;

(*----------------------------------------------------------------------------*)
procedure TCustomActionBarColorMapShadowColor_W(Self: TCustomActionBarColorMap; const T: TColor);
begin Self.ShadowColor := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomActionBarColorMapShadowColor_R(Self: TCustomActionBarColorMap; var T: TColor);
begin T := Self.ShadowColor; end;

(*----------------------------------------------------------------------------*)
procedure TCustomActionBarColorMapSelectedFontColor_W(Self: TCustomActionBarColorMap; const T: TColor);
begin Self.SelectedFontColor := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomActionBarColorMapSelectedFontColor_R(Self: TCustomActionBarColorMap; var T: TColor);
begin T := Self.SelectedFontColor; end;

(*----------------------------------------------------------------------------*)
procedure TCustomActionBarColorMapSelectedColor_W(Self: TCustomActionBarColorMap; const T: TColor);
begin Self.SelectedColor := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomActionBarColorMapSelectedColor_R(Self: TCustomActionBarColorMap; var T: TColor);
begin T := Self.SelectedColor; end;

(*----------------------------------------------------------------------------*)
procedure TCustomActionBarColorMapMenuColor_W(Self: TCustomActionBarColorMap; const T: TColor);
begin Self.MenuColor := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomActionBarColorMapMenuColor_R(Self: TCustomActionBarColorMap; var T: TColor);
begin T := Self.MenuColor; end;

(*----------------------------------------------------------------------------*)
procedure TCustomActionBarColorMapHotFontColor_W(Self: TCustomActionBarColorMap; const T: TColor);
begin Self.HotFontColor := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomActionBarColorMapHotFontColor_R(Self: TCustomActionBarColorMap; var T: TColor);
begin T := Self.HotFontColor; end;

(*----------------------------------------------------------------------------*)
procedure TCustomActionBarColorMapHotColor_W(Self: TCustomActionBarColorMap; const T: TColor);
begin Self.HotColor := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomActionBarColorMapHotColor_R(Self: TCustomActionBarColorMap; var T: TColor);
begin T := Self.HotColor; end;

(*----------------------------------------------------------------------------*)
procedure TCustomActionBarColorMapHighlightColor_W(Self: TCustomActionBarColorMap; const T: TColor);
begin Self.HighlightColor := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomActionBarColorMapHighlightColor_R(Self: TCustomActionBarColorMap; var T: TColor);
begin T := Self.HighlightColor; end;

(*----------------------------------------------------------------------------*)
procedure TCustomActionBarColorMapFrameBottomRightOuter_W(Self: TCustomActionBarColorMap; const T: TColor);
begin Self.FrameBottomRightOuter := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomActionBarColorMapFrameBottomRightOuter_R(Self: TCustomActionBarColorMap; var T: TColor);
begin T := Self.FrameBottomRightOuter; end;

(*----------------------------------------------------------------------------*)
procedure TCustomActionBarColorMapFrameBottomRightInner_W(Self: TCustomActionBarColorMap; const T: TColor);
begin Self.FrameBottomRightInner := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomActionBarColorMapFrameBottomRightInner_R(Self: TCustomActionBarColorMap; var T: TColor);
begin T := Self.FrameBottomRightInner; end;

(*----------------------------------------------------------------------------*)
procedure TCustomActionBarColorMapFrameTopLeftOuter_W(Self: TCustomActionBarColorMap; const T: TColor);
begin Self.FrameTopLeftOuter := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomActionBarColorMapFrameTopLeftOuter_R(Self: TCustomActionBarColorMap; var T: TColor);
begin T := Self.FrameTopLeftOuter; end;

(*----------------------------------------------------------------------------*)
procedure TCustomActionBarColorMapFrameTopLeftInner_W(Self: TCustomActionBarColorMap; const T: TColor);
begin Self.FrameTopLeftInner := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomActionBarColorMapFrameTopLeftInner_R(Self: TCustomActionBarColorMap; var T: TColor);
begin T := Self.FrameTopLeftInner; end;

(*----------------------------------------------------------------------------*)
procedure TCustomActionBarColorMapFontColor_W(Self: TCustomActionBarColorMap; const T: TColor);
begin Self.FontColor := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomActionBarColorMapFontColor_R(Self: TCustomActionBarColorMap; var T: TColor);
begin T := Self.FontColor; end;

(*----------------------------------------------------------------------------*)
procedure TCustomActionBarColorMapDisabledFontShadow_W(Self: TCustomActionBarColorMap; const T: TColor);
begin Self.DisabledFontShadow := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomActionBarColorMapDisabledFontShadow_R(Self: TCustomActionBarColorMap; var T: TColor);
begin T := Self.DisabledFontShadow; end;

(*----------------------------------------------------------------------------*)
procedure TCustomActionBarColorMapDisabledFontColor_W(Self: TCustomActionBarColorMap; const T: TColor);
begin Self.DisabledFontColor := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomActionBarColorMapDisabledFontColor_R(Self: TCustomActionBarColorMap; var T: TColor);
begin T := Self.DisabledFontColor; end;

(*----------------------------------------------------------------------------*)
procedure TCustomActionBarColorMapDisabledColor_W(Self: TCustomActionBarColorMap; const T: TColor);
begin Self.DisabledColor := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomActionBarColorMapDisabledColor_R(Self: TCustomActionBarColorMap; var T: TColor);
begin T := Self.DisabledColor; end;

(*----------------------------------------------------------------------------*)
procedure TCustomActionBarColorMapDesignFocus_W(Self: TCustomActionBarColorMap; const T: TColor);
begin Self.DesignFocus := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomActionBarColorMapDesignFocus_R(Self: TCustomActionBarColorMap; var T: TColor);
begin T := Self.DesignFocus; end;

(*----------------------------------------------------------------------------*)
procedure TCustomActionBarColorMapColor_W(Self: TCustomActionBarColorMap; const T: TColor);
begin Self.Color := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomActionBarColorMapColor_R(Self: TCustomActionBarColorMap; var T: TColor);
begin T := Self.Color; end;

(*----------------------------------------------------------------------------*)
procedure TCustomActionBarColorMapBtnSelectedFont_W(Self: TCustomActionBarColorMap; const T: TColor);
begin Self.BtnSelectedFont := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomActionBarColorMapBtnSelectedFont_R(Self: TCustomActionBarColorMap; var T: TColor);
begin T := Self.BtnSelectedFont; end;

(*----------------------------------------------------------------------------*)
procedure TCustomActionBarColorMapBtnSelectedColor_W(Self: TCustomActionBarColorMap; const T: TColor);
begin Self.BtnSelectedColor := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomActionBarColorMapBtnSelectedColor_R(Self: TCustomActionBarColorMap; var T: TColor);
begin T := Self.BtnSelectedColor; end;

(*----------------------------------------------------------------------------*)
procedure TCustomActionBarColorMapBtnFrameColor_W(Self: TCustomActionBarColorMap; const T: TColor);
begin Self.BtnFrameColor := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomActionBarColorMapBtnFrameColor_R(Self: TCustomActionBarColorMap; var T: TColor);
begin T := Self.BtnFrameColor; end;

(*----------------------------------------------------------------------------*)
procedure TActionItemDragObjectClientItem_W(Self: TActionItemDragObject; const T: TActionClientItem);
begin Self.ClientItem := T; end;

(*----------------------------------------------------------------------------*)
procedure TActionItemDragObjectClientItem_R(Self: TActionItemDragObject; var T: TActionClientItem);
begin T := Self.ClientItem; end;

(*----------------------------------------------------------------------------*)
procedure TCategoryDragObjectCategory_R(Self: TCategoryDragObject; var T: string);
begin T := Self.Category; end;

(*----------------------------------------------------------------------------*)
procedure TActionDragObjectActions_R(Self: TActionDragObject; var T: TContainedAction; const t1: Integer);
begin T := Self.Actions[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TActionDragObjectActionCount_R(Self: TActionDragObject; var T: Integer);
begin T := Self.ActionCount; end;

(*----------------------------------------------------------------------------*)
procedure TActionDragBaseClassActionManager_W(Self: TActionDragBaseClass; const T: TCustomActionManager);
begin Self.ActionManager := T; end;

(*----------------------------------------------------------------------------*)
procedure TActionDragBaseClassActionManager_R(Self: TActionDragBaseClass; var T: TCustomActionManager);
begin T := Self.ActionManager; end;

(*----------------------------------------------------------------------------*)
procedure TActionClientItemUsageCount_W(Self: TActionClientItem; const T: Integer);
begin Self.UsageCount := T; end;

(*----------------------------------------------------------------------------*)
procedure TActionClientItemUsageCount_R(Self: TActionClientItem; var T: Integer);
begin T := Self.UsageCount; end;

(*----------------------------------------------------------------------------*)
procedure TActionClientItemShortCut_W(Self: TActionClientItem; const T: TShortCut);
begin Self.ShortCut := T; end;

(*----------------------------------------------------------------------------*)
procedure TActionClientItemShortCut_R(Self: TActionClientItem; var T: TShortCut);
begin T := Self.ShortCut; end;

(*----------------------------------------------------------------------------*)
procedure TActionClientItemShowShortCut_W(Self: TActionClientItem; const T: Boolean);
begin Self.ShowShortCut := T; end;

(*----------------------------------------------------------------------------*)
procedure TActionClientItemShowShortCut_R(Self: TActionClientItem; var T: Boolean);
begin T := Self.ShowShortCut; end;

(*----------------------------------------------------------------------------*)
procedure TActionClientItemShowGlyph_W(Self: TActionClientItem; const T: Boolean);
begin Self.ShowGlyph := T; end;

(*----------------------------------------------------------------------------*)
procedure TActionClientItemShowGlyph_R(Self: TActionClientItem; var T: Boolean);
begin T := Self.ShowGlyph; end;

(*----------------------------------------------------------------------------*)
procedure TActionClientItemShowCaption_W(Self: TActionClientItem; const T: Boolean);
begin Self.ShowCaption := T; end;

(*----------------------------------------------------------------------------*)
procedure TActionClientItemShowCaption_R(Self: TActionClientItem; var T: Boolean);
begin T := Self.ShowCaption; end;

(*----------------------------------------------------------------------------*)
procedure TActionClientItemLastSession_W(Self: TActionClientItem; const T: Integer);
begin Self.LastSession := T; end;

(*----------------------------------------------------------------------------*)
procedure TActionClientItemLastSession_R(Self: TActionClientItem; var T: Integer);
begin T := Self.LastSession; end;

(*----------------------------------------------------------------------------*)
procedure TActionClientItemMergeIndex_W(Self: TActionClientItem; const T: TMergeRange);
begin Self.MergeIndex := T; end;

(*----------------------------------------------------------------------------*)
procedure TActionClientItemMergeIndex_R(Self: TActionClientItem; var T: TMergeRange);
begin T := Self.MergeIndex; end;

(*----------------------------------------------------------------------------*)
procedure TActionClientItemImageIndex_W(Self: TActionClientItem; const T: TImageIndex);
begin Self.ImageIndex := T; end;

(*----------------------------------------------------------------------------*)
procedure TActionClientItemImageIndex_R(Self: TActionClientItem; var T: TImageIndex);
begin T := Self.ImageIndex; end;

(*----------------------------------------------------------------------------*)
procedure TActionClientItemHelpContext_W(Self: TActionClientItem; const T: THelpContext);
begin Self.HelpContext := T; end;

(*----------------------------------------------------------------------------*)
procedure TActionClientItemHelpContext_R(Self: TActionClientItem; var T: THelpContext);
begin T := Self.HelpContext; end;

(*----------------------------------------------------------------------------*)
procedure TActionClientItemCaption_W(Self: TActionClientItem; const T: string);
begin Self.Caption := T; end;

(*----------------------------------------------------------------------------*)
procedure TActionClientItemCaption_R(Self: TActionClientItem; var T: string);
begin T := Self.Caption; end;

(*----------------------------------------------------------------------------*)
procedure TActionClientItemAction_W(Self: TActionClientItem; const T: TContainedAction);
begin Self.Action := T; end;

(*----------------------------------------------------------------------------*)
procedure TActionClientItemAction_R(Self: TActionClientItem; var T: TContainedAction);
begin T := Self.Action; end;

(*----------------------------------------------------------------------------*)
procedure TActionClientItemShortCutText_R(Self: TActionClientItem; var T: string);
begin T := Self.ShortCutText; end;

(*----------------------------------------------------------------------------*)
procedure TActionClientItemSeparator_R(Self: TActionClientItem; var T: Boolean);
begin T := Self.Separator; end;

(*----------------------------------------------------------------------------*)
procedure TActionClientItemParentItem_R(Self: TActionClientItem; var T: TActionClient);
begin T := Self.ParentItem; end;

(*----------------------------------------------------------------------------*)
procedure TActionClientItemControl_W(Self: TActionClientItem; const T: TCustomActionControl);
begin Self.Control := T; end;

(*----------------------------------------------------------------------------*)
procedure TActionClientItemControl_R(Self: TActionClientItem; var T: TCustomActionControl);
begin T := Self.Control; end;

(*----------------------------------------------------------------------------*)
procedure TActionClientItemCheckUnused_W(Self: TActionClientItem; const T: Boolean);
begin Self.CheckUnused := T; end;

(*----------------------------------------------------------------------------*)
procedure TActionClientItemCheckUnused_R(Self: TActionClientItem; var T: Boolean);
begin T := Self.CheckUnused; end;

(*----------------------------------------------------------------------------*)
procedure TActionClientItemActionLink_W(Self: TActionClientItem; const T: TActionClientLink);
begin Self.ActionLink := T; end;

(*----------------------------------------------------------------------------*)
procedure TActionClientItemActionLink_R(Self: TActionClientItem; var T: TActionClientLink);
begin T := Self.ActionLink; end;

(*----------------------------------------------------------------------------*)
procedure TActionClientItemActionClients_R(Self: TActionClientItem; var T: TActionClients);
begin T := Self.ActionClients; end;

(*----------------------------------------------------------------------------*)
procedure TActionClientsSmallIcons_W(Self: TActionClients; const T: Boolean);
begin Self.SmallIcons := T; end;

(*----------------------------------------------------------------------------*)
procedure TActionClientsSmallIcons_R(Self: TActionClients; var T: Boolean);
begin T := Self.SmallIcons; end;

(*----------------------------------------------------------------------------*)
procedure TActionClientsCaptionOptions_W(Self: TActionClients; const T: TCaptionOptions);
begin Self.CaptionOptions := T; end;

(*----------------------------------------------------------------------------*)
procedure TActionClientsCaptionOptions_R(Self: TActionClients; var T: TCaptionOptions);
begin T := Self.CaptionOptions; end;

(*----------------------------------------------------------------------------*)
procedure TActionClientsHideUnused_W(Self: TActionClients; const T: Boolean);
begin Self.HideUnused := T; end;

(*----------------------------------------------------------------------------*)
procedure TActionClientsHideUnused_R(Self: TActionClients; var T: Boolean);
begin T := Self.HideUnused; end;

(*----------------------------------------------------------------------------*)
procedure TActionClientsActionManager_R(Self: TActionClients; var T: TCustomActionManager);
begin T := Self.ActionManager; end;

(*----------------------------------------------------------------------------*)
procedure TActionClientsActionClients_W(Self: TActionClients; const T: TActionClientItem; const t1: Integer);
begin Self.ActionClients[t1] := T; end;

(*----------------------------------------------------------------------------*)
procedure TActionClientsActionClients_R(Self: TActionClients; var T: TActionClientItem; const t1: Integer);
begin T := Self.ActionClients[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TActionBarsShowHints_W(Self: TActionBars; const T: Boolean);
begin Self.ShowHints := T; end;

(*----------------------------------------------------------------------------*)
procedure TActionBarsShowHints_R(Self: TActionBars; var T: Boolean);
begin T := Self.ShowHints; end;

(*----------------------------------------------------------------------------*)
procedure TActionBarsSessionCount_W(Self: TActionBars; const T: Integer);
begin Self.SessionCount := T; end;

(*----------------------------------------------------------------------------*)
procedure TActionBarsSessionCount_R(Self: TActionBars; var T: Integer);
begin T := Self.SessionCount; end;

(*----------------------------------------------------------------------------*)
procedure TActionBarsHintShortCuts_W(Self: TActionBars; const T: Boolean);
begin Self.HintShortCuts := T; end;

(*----------------------------------------------------------------------------*)
procedure TActionBarsHintShortCuts_R(Self: TActionBars; var T: Boolean);
begin T := Self.HintShortCuts; end;

(*----------------------------------------------------------------------------*)
procedure TActionBarsActionBars_R(Self: TActionBars; var T: TActionBarItem; const t1: Integer);
begin T := Self.ActionBars[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TActionBarItemGlyphLayout_W(Self: TActionBarItem; const T: TButtonLayout);
begin Self.GlyphLayout := T; end;

(*----------------------------------------------------------------------------*)
procedure TActionBarItemGlyphLayout_R(Self: TActionBarItem; var T: TButtonLayout);
begin T := Self.GlyphLayout; end;

(*----------------------------------------------------------------------------*)
procedure TActionBarItemAutoSize_W(Self: TActionBarItem; const T: Boolean);
begin Self.AutoSize := T; end;

(*----------------------------------------------------------------------------*)
procedure TActionBarItemAutoSize_R(Self: TActionBarItem; var T: Boolean);
begin T := Self.AutoSize; end;

(*----------------------------------------------------------------------------*)
procedure TActionClientVisible_W(Self: TActionClient; const T: Boolean);
begin Self.Visible := T; end;

(*----------------------------------------------------------------------------*)
procedure TActionClientVisible_R(Self: TActionClient; var T: Boolean);
begin T := Self.Visible; end;

(*----------------------------------------------------------------------------*)
procedure TActionClientTag_W(Self: TActionClient; const T: Integer);
begin Self.Tag := T; end;

(*----------------------------------------------------------------------------*)
procedure TActionClientTag_R(Self: TActionClient; var T: Integer);
begin T := Self.Tag; end;

(*----------------------------------------------------------------------------*)
procedure TActionClientItems_W(Self: TActionClient; const T: TActionClients);
begin Self.Items := T; end;

(*----------------------------------------------------------------------------*)
procedure TActionClientItems_R(Self: TActionClient; var T: TActionClients);
begin T := Self.Items; end;

(*----------------------------------------------------------------------------*)
procedure TActionClientBackgroundLayout_W(Self: TActionClient; const T: TBackgroundLayout);
begin Self.BackgroundLayout := T; end;

(*----------------------------------------------------------------------------*)
procedure TActionClientBackgroundLayout_R(Self: TActionClient; var T: TBackgroundLayout);
begin T := Self.BackgroundLayout; end;

(*----------------------------------------------------------------------------*)
procedure TActionClientBackground_W(Self: TActionClient; const T: TPicture);
begin Self.Background := T; end;

(*----------------------------------------------------------------------------*)
procedure TActionClientBackground_R(Self: TActionClient; var T: TPicture);
begin T := Self.Background; end;

(*----------------------------------------------------------------------------*)
procedure TActionClientContextItems_W(Self: TActionClient; const T: TActionClients);
begin Self.ContextItems := T; end;

(*----------------------------------------------------------------------------*)
procedure TActionClientContextItems_R(Self: TActionClient; var T: TActionClients);
begin T := Self.ContextItems; end;

(*----------------------------------------------------------------------------*)
procedure TActionClientColor_W(Self: TActionClient; const T: TColor);
begin Self.Color := T; end;

(*----------------------------------------------------------------------------*)
procedure TActionClientColor_R(Self: TActionClient; var T: TColor);
begin T := Self.Color; end;

(*----------------------------------------------------------------------------*)
procedure TActionClientChangesAllowed_W(Self: TActionClient; const T: TChangesAllowedSet);
begin Self.ChangesAllowed := T; end;

(*----------------------------------------------------------------------------*)
procedure TActionClientChangesAllowed_R(Self: TActionClient; var T: TChangesAllowedSet);
begin T := Self.ChangesAllowed; end;

(*----------------------------------------------------------------------------*)
procedure TActionClientOwningCollection_R(Self: TActionClient; var T: TActionClientsCollection);
begin T := Self.OwningCollection; end;

(*----------------------------------------------------------------------------*)
procedure TActionClientHasItems_R(Self: TActionClient; var T: Boolean);
begin T := Self.HasItems; end;

(*----------------------------------------------------------------------------*)
procedure TActionClientChildActionBar_W(Self: TActionClient; const T: TCustomActionBar);
begin Self.ChildActionBar := T; end;

(*----------------------------------------------------------------------------*)
procedure TActionClientChildActionBar_R(Self: TActionClient; var T: TCustomActionBar);
begin T := Self.ChildActionBar; end;

(*----------------------------------------------------------------------------*)
procedure TActionClientAccessible_W(Self: TActionClient; const T: IAccessible);
begin Self.Accessible := T; end;

(*----------------------------------------------------------------------------*)
procedure TActionClientAccessible_R(Self: TActionClient; var T: IAccessible);
begin T := Self.Accessible; end;

(*----------------------------------------------------------------------------*)
procedure TActionClientActionBar_W(Self: TActionClient; const T: TCustomActionBar);
begin Self.ActionBar := T; end;

(*----------------------------------------------------------------------------*)
procedure TActionClientActionBar_R(Self: TActionClient; var T: TCustomActionBar);
begin T := Self.ActionBar; end;

(*----------------------------------------------------------------------------*)
procedure TActionClientsCollectionCustomizable_W(Self: TActionClientsCollection; const T: Boolean);
begin Self.Customizable := T; end;

(*----------------------------------------------------------------------------*)
procedure TActionClientsCollectionCustomizable_R(Self: TActionClientsCollection; var T: Boolean);
begin T := Self.Customizable; end;

(*----------------------------------------------------------------------------*)
procedure TActionClientsCollectionAutoHotKeys_W(Self: TActionClientsCollection; const T: Boolean);
begin Self.AutoHotKeys := T; end;

(*----------------------------------------------------------------------------*)
procedure TActionClientsCollectionAutoHotKeys_R(Self: TActionClientsCollection; var T: Boolean);
begin T := Self.AutoHotKeys; end;

(*----------------------------------------------------------------------------*)
procedure TActionClientsCollectionActionManager_R(Self: TActionClientsCollection; var T: TCustomActionManager);
begin T := Self.ActionManager; end;

(*----------------------------------------------------------------------------*)
procedure TActionListCollectionListItems_W(Self: TActionListCollection; const T: TActionListItem; const t1: Integer);
begin Self.ListItems[t1] := T; end;

(*----------------------------------------------------------------------------*)
procedure TActionListCollectionListItems_R(Self: TActionListCollection; var T: TActionListItem; const t1: Integer);
begin T := Self.ListItems[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TActionListCollectionActionManager_R(Self: TActionListCollection; var T: TCustomActionManager);
begin T := Self.ActionManager; end;

(*----------------------------------------------------------------------------*)
procedure TActionListItemCaption_W(Self: TActionListItem; const T: string);
begin Self.Caption := T; end;

(*----------------------------------------------------------------------------*)
procedure TActionListItemCaption_R(Self: TActionListItem; var T: string);
begin T := Self.Caption; end;

(*----------------------------------------------------------------------------*)
procedure TActionListItemActionList_W(Self: TActionListItem; const T: TCustomActionList);
begin Self.ActionList := T; end;

(*----------------------------------------------------------------------------*)
procedure TActionListItemActionList_R(Self: TActionListItem; var T: TCustomActionList);
begin T := Self.ActionList; end;

(*----------------------------------------------------------------------------*)
procedure TCustomActionManagerOnStyleChanged_W(Self: TCustomActionManager; const T: TStyleChanged);
begin Self.OnStyleChanged := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomActionManagerOnStyleChanged_R(Self: TCustomActionManager; var T: TStyleChanged);
begin T := Self.OnStyleChanged; end;

(*----------------------------------------------------------------------------*)
procedure TCustomActionManagerStyle_W(Self: TCustomActionManager; const T: TActionBarStyle);
begin Self.Style := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomActionManagerStyle_R(Self: TCustomActionManager; var T: TActionBarStyle);
begin T := Self.Style; end;

(*----------------------------------------------------------------------------*)
procedure TCustomActionManagerPrioritySchedule_W(Self: TCustomActionManager; const T: TStringList);
begin Self.PrioritySchedule := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomActionManagerPrioritySchedule_R(Self: TCustomActionManager; var T: TStringList);
begin T := Self.PrioritySchedule; end;

(*----------------------------------------------------------------------------*)
procedure TCustomActionManagerFileName_W(Self: TCustomActionManager; const T: TFileName);
begin Self.FileName := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomActionManagerFileName_R(Self: TCustomActionManager; var T: TFileName);
begin T := Self.FileName; end;

(*----------------------------------------------------------------------------*)
procedure TCustomActionManagerLinkedActionLists_W(Self: TCustomActionManager; const T: TActionListCollection);
begin Self.LinkedActionLists := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomActionManagerLinkedActionLists_R(Self: TCustomActionManager; var T: TActionListCollection);
begin T := Self.LinkedActionLists; end;

(*----------------------------------------------------------------------------*)
procedure TCustomActionManagerDefaultActionBars_R(Self: TCustomActionManager; var T: TActionBars);
begin T := Self.DefaultActionBars; end;

(*----------------------------------------------------------------------------*)
procedure TCustomActionManagerActionBars_W(Self: TCustomActionManager; const T: TActionBars);
begin Self.ActionBars := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomActionManagerActionBars_R(Self: TCustomActionManager; var T: TActionBars);
begin T := Self.ActionBars; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TActionBarStyleList(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TActionBarStyleList) do
  begin
    RegisterPropertyHelper(@TActionBarStyleListStyle_R,nil,'Style');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_ActnMan_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@NotifyDesigner, 'NotifyDesigner', cdRegister);
  //RIRegister_TActionBarStyleList(CL);
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TXToolDockForm(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TXToolDockForm) do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TCustomActionControl(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TCustomActionControl) do
  begin
    RegisterVirtualMethod(@TCustomActionControl.CalcBounds, 'CalcBounds');
    RegisterVirtualMethod(@TCustomActionControl.Keyed, 'Keyed');
    RegisterPropertyHelper(@TCustomActionControlActionBar_R,nil,'ActionBar');
    RegisterPropertyHelper(@TCustomActionControlActionClient_R,@TCustomActionControlActionClient_W,'ActionClient');
    RegisterPropertyHelper(@TCustomActionControlDropPoint_R,@TCustomActionControlDropPoint_W,'DropPoint');
    RegisterPropertyHelper(@TCustomActionControlGlyphLayout_R,@TCustomActionControlGlyphLayout_W,'GlyphLayout');
    RegisterPropertyHelper(@TCustomActionControlMargins_R,@TCustomActionControlMargins_W,'Margins');
    RegisterPropertyHelper(@TCustomActionControlSelected_R,@TCustomActionControlSelected_W,'Selected');
    RegisterPropertyHelper(@TCustomActionControlSeparator_R,nil,'Separator');
    RegisterPropertyHelper(@TCustomActionControlShowCaption_R,nil,'ShowCaption');
    RegisterPropertyHelper(@TCustomActionControlShowShortCut_R,nil,'ShowShortCut');
    RegisterPropertyHelper(@TCustomActionControlSmallIcon_R,@TCustomActionControlSmallIcon_W,'SmallIcon');
    RegisterPropertyHelper(@TCustomActionControlSpacing_R,@TCustomActionControlSpacing_W,'Spacing');
    RegisterPropertyHelper(@TCustomActionControlTextBounds_R,@TCustomActionControlTextBounds_W,'TextBounds');
    RegisterPropertyHelper(@TCustomActionControlTransparent_R,@TCustomActionControlTransparent_W,'Transparent');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TCustomActionBar(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TCustomActionBar) do
  begin
    RegisterVirtualMethod(@TCustomActionBar.FindFirst, 'FindFirst');
    RegisterMethod(@TCustomActionBar.FindFirstVisibleItem, 'FindFirstVisibleItem');
    RegisterMethod(@TCustomActionBar.FindLastVisibleItem, 'FindLastVisibleItem');
    RegisterVirtualMethod(@TCustomActionBar.RecreateControls, 'RecreateControls');
    RegisterVirtualMethod(@TCustomActionBar.Style, 'Style');
    RegisterPropertyHelper(@TCustomActionBarActionManager_R,@TCustomActionBarActionManager_W,'ActionManager');
    RegisterPropertyHelper(@TCustomActionBarActionClient_R,@TCustomActionBarActionClient_W,'ActionClient');
    RegisterPropertyHelper(@TCustomActionBarAllowHiding_R,@TCustomActionBarAllowHiding_W,'AllowHiding');
    RegisterPropertyHelper(@TCustomActionBarAutoSizing_R,@TCustomActionBarAutoSizing_W,'AutoSizing');
    RegisterPropertyHelper(@TCustomActionBarCanvas_R,nil,'Canvas');
    RegisterPropertyHelper(@TCustomActionBarColorMap_R,@TCustomActionBarColorMap_W,'ColorMap');
    RegisterPropertyHelper(@TCustomActionBarContextBar_R,@TCustomActionBarContextBar_W,'ContextBar');
    RegisterPropertyHelper(@TCustomActionBarDesignable_R,@TCustomActionBarDesignable_W,'Designable');
    RegisterPropertyHelper(@TCustomActionBarDesignMode_R,@TCustomActionBarDesignMode_W,'DesignMode');
    RegisterPropertyHelper(@TCustomActionBarHorzMargin_R,@TCustomActionBarHorzMargin_W,'HorzMargin');
    RegisterPropertyHelper(@TCustomActionBarHorzSeparator_R,@TCustomActionBarHorzSeparator_W,'HorzSeparator');
    RegisterPropertyHelper(@TCustomActionBarOrientation_R,@TCustomActionBarOrientation_W,'Orientation');
    RegisterPropertyHelper(@TCustomActionBarPersistentHotKeys_R,@TCustomActionBarPersistentHotKeys_W,'PersistentHotKeys');
    RegisterPropertyHelper(@TCustomActionBarActionControls_R,nil,'ActionControls');
    RegisterPropertyHelper(@TCustomActionBarSpacing_R,@TCustomActionBarSpacing_W,'Spacing');
    RegisterPropertyHelper(@TCustomActionBarVertMargin_R,@TCustomActionBarVertMargin_W,'VertMargin');
    RegisterPropertyHelper(@TCustomActionBarVertSeparator_R,@TCustomActionBarVertSeparator_W,'VertSeparator');
    RegisterPropertyHelper(@TCustomActionBarOnControlCreated_R,@TCustomActionBarOnControlCreated_W,'OnControlCreated');
    RegisterPropertyHelper(@TCustomActionBarOnGetControlClass_R,@TCustomActionBarOnGetControlClass_W,'OnGetControlClass');
    RegisterPropertyHelper(@TCustomActionBarOnPaint_R,@TCustomActionBarOnPaint_W,'OnPaint');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TCustomActionBarColorMap(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TCustomActionBarColorMap) do
  begin
    RegisterVirtualMethod(@TCustomActionBarColorMap.UpdateColors, 'UpdateColors');
    RegisterPropertyHelper(@TCustomActionBarColorMapBtnFrameColor_R,@TCustomActionBarColorMapBtnFrameColor_W,'BtnFrameColor');
    RegisterPropertyHelper(@TCustomActionBarColorMapBtnSelectedColor_R,@TCustomActionBarColorMapBtnSelectedColor_W,'BtnSelectedColor');
    RegisterPropertyHelper(@TCustomActionBarColorMapBtnSelectedFont_R,@TCustomActionBarColorMapBtnSelectedFont_W,'BtnSelectedFont');
    RegisterPropertyHelper(@TCustomActionBarColorMapColor_R,@TCustomActionBarColorMapColor_W,'Color');
    RegisterPropertyHelper(@TCustomActionBarColorMapDesignFocus_R,@TCustomActionBarColorMapDesignFocus_W,'DesignFocus');
    RegisterPropertyHelper(@TCustomActionBarColorMapDisabledColor_R,@TCustomActionBarColorMapDisabledColor_W,'DisabledColor');
    RegisterPropertyHelper(@TCustomActionBarColorMapDisabledFontColor_R,@TCustomActionBarColorMapDisabledFontColor_W,'DisabledFontColor');
    RegisterPropertyHelper(@TCustomActionBarColorMapDisabledFontShadow_R,@TCustomActionBarColorMapDisabledFontShadow_W,'DisabledFontShadow');
    RegisterPropertyHelper(@TCustomActionBarColorMapFontColor_R,@TCustomActionBarColorMapFontColor_W,'FontColor');
    RegisterPropertyHelper(@TCustomActionBarColorMapFrameTopLeftInner_R,@TCustomActionBarColorMapFrameTopLeftInner_W,'FrameTopLeftInner');
    RegisterPropertyHelper(@TCustomActionBarColorMapFrameTopLeftOuter_R,@TCustomActionBarColorMapFrameTopLeftOuter_W,'FrameTopLeftOuter');
    RegisterPropertyHelper(@TCustomActionBarColorMapFrameBottomRightInner_R,@TCustomActionBarColorMapFrameBottomRightInner_W,'FrameBottomRightInner');
    RegisterPropertyHelper(@TCustomActionBarColorMapFrameBottomRightOuter_R,@TCustomActionBarColorMapFrameBottomRightOuter_W,'FrameBottomRightOuter');
    RegisterPropertyHelper(@TCustomActionBarColorMapHighlightColor_R,@TCustomActionBarColorMapHighlightColor_W,'HighlightColor');
    RegisterPropertyHelper(@TCustomActionBarColorMapHotColor_R,@TCustomActionBarColorMapHotColor_W,'HotColor');
    RegisterPropertyHelper(@TCustomActionBarColorMapHotFontColor_R,@TCustomActionBarColorMapHotFontColor_W,'HotFontColor');
    RegisterPropertyHelper(@TCustomActionBarColorMapMenuColor_R,@TCustomActionBarColorMapMenuColor_W,'MenuColor');
    RegisterPropertyHelper(@TCustomActionBarColorMapSelectedColor_R,@TCustomActionBarColorMapSelectedColor_W,'SelectedColor');
    RegisterPropertyHelper(@TCustomActionBarColorMapSelectedFontColor_R,@TCustomActionBarColorMapSelectedFontColor_W,'SelectedFontColor');
    RegisterPropertyHelper(@TCustomActionBarColorMapShadowColor_R,@TCustomActionBarColorMapShadowColor_W,'ShadowColor');
    RegisterPropertyHelper(@TCustomActionBarColorMapUnusedColor_R,@TCustomActionBarColorMapUnusedColor_W,'UnusedColor');
    RegisterPropertyHelper(@TCustomActionBarColorMapOnColorChange_R,@TCustomActionBarColorMapOnColorChange_W,'OnColorChange');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TActionItemDragObject(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TActionItemDragObject) do
  begin
    RegisterPropertyHelper(@TActionItemDragObjectClientItem_R,@TActionItemDragObjectClientItem_W,'ClientItem');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TCategoryDragObject(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TCategoryDragObject) do
  begin
    RegisterConstructor(@TCategoryDragObject.Create, 'Create');
    RegisterPropertyHelper(@TCategoryDragObjectCategory_R,nil,'Category');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TActionDragObject(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TActionDragObject) do
  begin
    RegisterConstructor(@TActionDragObject.Create, 'Create');
    RegisterMethod(@TActionDragObject.AddAction, 'AddAction');
    RegisterMethod(@TActionDragObject.AddActionClass, 'AddActionClass');
    RegisterPropertyHelper(@TActionDragObjectActionCount_R,nil,'ActionCount');
    RegisterPropertyHelper(@TActionDragObjectActions_R,nil,'Actions');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TActionDragBaseClass(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TActionDragBaseClass) do
  begin
    RegisterPropertyHelper(@TActionDragBaseClassActionManager_R,@TActionDragBaseClassActionManager_W,'ActionManager');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TActionClientItem(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TActionClientItem) do
  begin
    RegisterConstructor(@TActionClientItem.Create, 'Create');
    RegisterMethod(@TActionClientItem.Assign, 'Assign');
    RegisterMethod(@TActionClientItem.HasGlyph, 'HasGlyph');
    RegisterVirtualMethod(@TActionClientItem.InitiateAction, 'InitiateAction');
    RegisterMethod(@TActionClientItem.Unused, 'Unused');
    RegisterPropertyHelper(@TActionClientItemActionClients_R,nil,'ActionClients');
    RegisterPropertyHelper(@TActionClientItemActionLink_R,@TActionClientItemActionLink_W,'ActionLink');
    RegisterPropertyHelper(@TActionClientItemCheckUnused_R,@TActionClientItemCheckUnused_W,'CheckUnused');
    RegisterPropertyHelper(@TActionClientItemControl_R,@TActionClientItemControl_W,'Control');
    RegisterPropertyHelper(@TActionClientItemParentItem_R,nil,'ParentItem');
    RegisterPropertyHelper(@TActionClientItemSeparator_R,nil,'Separator');
    RegisterPropertyHelper(@TActionClientItemShortCutText_R,nil,'ShortCutText');
    RegisterPropertyHelper(@TActionClientItemAction_R,@TActionClientItemAction_W,'Action');
    RegisterPropertyHelper(@TActionClientItemCaption_R,@TActionClientItemCaption_W,'Caption');
    RegisterPropertyHelper(@TActionClientItemHelpContext_R,@TActionClientItemHelpContext_W,'HelpContext');
    RegisterPropertyHelper(@TActionClientItemImageIndex_R,@TActionClientItemImageIndex_W,'ImageIndex');
    RegisterPropertyHelper(@TActionClientItemMergeIndex_R,@TActionClientItemMergeIndex_W,'MergeIndex');
    RegisterPropertyHelper(@TActionClientItemLastSession_R,@TActionClientItemLastSession_W,'LastSession');
    RegisterPropertyHelper(@TActionClientItemShowCaption_R,@TActionClientItemShowCaption_W,'ShowCaption');
    RegisterPropertyHelper(@TActionClientItemShowGlyph_R,@TActionClientItemShowGlyph_W,'ShowGlyph');
    RegisterPropertyHelper(@TActionClientItemShowShortCut_R,@TActionClientItemShowShortCut_W,'ShowShortCut');
    RegisterPropertyHelper(@TActionClientItemShortCut_R,@TActionClientItemShortCut_W,'ShortCut');
    RegisterPropertyHelper(@TActionClientItemUsageCount_R,@TActionClientItemUsageCount_W,'UsageCount');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TActionClientLink(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TActionClientLink) do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TActionClients(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TActionClients) do
  begin
    RegisterConstructor(@TActionClients.Create, 'Create');
    RegisterMethod(@TActionClients.Add, 'Add');
    RegisterMethod(@TActionClients.Assign, 'Assign');
    RegisterMethod(@TActionClients.VisibleCount, 'VisibleCount');
    RegisterPropertyHelper(@TActionClientsActionClients_R,@TActionClientsActionClients_W,'ActionClients');
    RegisterPropertyHelper(@TActionClientsActionManager_R,nil,'ActionManager');
    RegisterPropertyHelper(@TActionClientsHideUnused_R,@TActionClientsHideUnused_W,'HideUnused');
    RegisterPropertyHelper(@TActionClientsCaptionOptions_R,@TActionClientsCaptionOptions_W,'CaptionOptions');
    RegisterPropertyHelper(@TActionClientsSmallIcons_R,@TActionClientsSmallIcons_W,'SmallIcons');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TActionBars(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TActionBars) do
  begin
    RegisterConstructor(@TActionBars.Create, 'Create');
    RegisterMethod(@TActionBars.Add, 'Add');
    RegisterPropertyHelper(@TActionBarsActionBars_R,nil,'ActionBars');
    RegisterPropertyHelper(@TActionBarsHintShortCuts_R,@TActionBarsHintShortCuts_W,'HintShortCuts');
    RegisterPropertyHelper(@TActionBarsSessionCount_R,@TActionBarsSessionCount_W,'SessionCount');
    RegisterPropertyHelper(@TActionBarsShowHints_R,@TActionBarsShowHints_W,'ShowHints');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TActionBarItem(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TActionBarItem) do
  begin
    RegisterConstructor(@TActionBarItem.Create, 'Create');
    RegisterMethod(@TActionBarItem.Refresh, 'Refresh');
    RegisterPropertyHelper(@TActionBarItemAutoSize_R,@TActionBarItemAutoSize_W,'AutoSize');
    RegisterPropertyHelper(@TActionBarItemGlyphLayout_R,@TActionBarItemGlyphLayout_W,'GlyphLayout');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TActionClient(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TActionClient) do
  begin
    RegisterConstructor(@TActionClient.Create, 'Create');
    RegisterMethod(@TActionClient.Assign, 'Assign');
    RegisterMethod(@TActionClient.HasBackground, 'HasBackground');
    RegisterVirtualMethod(@TActionClient.Refresh, 'Refresh');
    RegisterPropertyHelper(@TActionClientActionBar_R,@TActionClientActionBar_W,'ActionBar');
    RegisterPropertyHelper(@TActionClientAccessible_R,@TActionClientAccessible_W,'Accessible');
    RegisterPropertyHelper(@TActionClientChildActionBar_R,@TActionClientChildActionBar_W,'ChildActionBar');
    RegisterPropertyHelper(@TActionClientHasItems_R,nil,'HasItems');
    RegisterPropertyHelper(@TActionClientOwningCollection_R,nil,'OwningCollection');
    RegisterPropertyHelper(@TActionClientChangesAllowed_R,@TActionClientChangesAllowed_W,'ChangesAllowed');
    RegisterPropertyHelper(@TActionClientColor_R,@TActionClientColor_W,'Color');
    RegisterPropertyHelper(@TActionClientContextItems_R,@TActionClientContextItems_W,'ContextItems');
    RegisterPropertyHelper(@TActionClientBackground_R,@TActionClientBackground_W,'Background');
    RegisterPropertyHelper(@TActionClientBackgroundLayout_R,@TActionClientBackgroundLayout_W,'BackgroundLayout');
    RegisterPropertyHelper(@TActionClientItems_R,@TActionClientItems_W,'Items');
    RegisterPropertyHelper(@TActionClientTag_R,@TActionClientTag_W,'Tag');
    RegisterPropertyHelper(@TActionClientVisible_R,@TActionClientVisible_W,'Visible');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TActionClientsCollection(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TActionClientsCollection) do
  begin
    RegisterMethod(@TActionClientsCollection.AfterConstruction, 'AfterConstruction');
    RegisterMethod(@TActionClientsCollection.IterateClients, 'IterateClients');
    RegisterPropertyHelper(@TActionClientsCollectionActionManager_R,nil,'ActionManager');
    RegisterPropertyHelper(@TActionClientsCollectionAutoHotKeys_R,@TActionClientsCollectionAutoHotKeys_W,'AutoHotKeys');
    RegisterPropertyHelper(@TActionClientsCollectionCustomizable_R,@TActionClientsCollectionCustomizable_W,'Customizable');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TActionListCollection(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TActionListCollection) do
  begin
    RegisterPropertyHelper(@TActionListCollectionActionManager_R,nil,'ActionManager');
    RegisterPropertyHelper(@TActionListCollectionListItems_R,@TActionListCollectionListItems_W,'ListItems');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TActionListItem(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TActionListItem) do
  begin
    RegisterPropertyHelper(@TActionListItemActionList_R,@TActionListItemActionList_W,'ActionList');
    RegisterPropertyHelper(@TActionListItemCaption_R,@TActionListItemCaption_W,'Caption');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TActionManager(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TActionManager) do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TCustomActionManager(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TCustomActionManager) do
  begin
    RegisterConstructor(@TCustomActionManager.Create, 'Create');
    RegisterMethod(@TCustomActionManager.AddAction, 'AddAction');
    RegisterMethod(@TCustomActionManager.AddCategory, 'AddCategory');
    RegisterMethod(@TCustomActionManager.AddSeparator, 'AddSeparator');
    RegisterMethod(@TCustomActionManager.DeleteActionItems, 'DeleteActionItems');
    RegisterMethod(@TCustomActionManager.DeleteItem, 'DeleteItem');
    RegisterMethod(@TCustomActionManager.FindItemByCaption, 'FindItemByCaption');
    RegisterMethod(@TCustomActionManager.FindItemByAction, 'FindItemByAction');
    RegisterMethod(@TCustomActionManager.LoadFromFile, 'LoadFromFile');
    RegisterMethod(@TCustomActionManager.LoadFromStream, 'LoadFromStream');
    RegisterMethod(@TCustomActionManager.ResetActionBar, 'ResetActionBar');
    RegisterMethod(@TCustomActionManager.ResetUsageData, 'ResetUsageData');
    RegisterMethod(@TCustomActionManager.SaveToFile, 'SaveToFile');
    RegisterMethod(@TCustomActionManager.SaveToStream, 'SaveToStream');
    RegisterPropertyHelper(@TCustomActionManagerActionBars_R,@TCustomActionManagerActionBars_W,'ActionBars');
    RegisterPropertyHelper(@TCustomActionManagerDefaultActionBars_R,nil,'DefaultActionBars');
    RegisterPropertyHelper(@TCustomActionManagerLinkedActionLists_R,@TCustomActionManagerLinkedActionLists_W,'LinkedActionLists');
    RegisterPropertyHelper(@TCustomActionManagerFileName_R,@TCustomActionManagerFileName_W,'FileName');
    RegisterPropertyHelper(@TCustomActionManagerPrioritySchedule_R,@TCustomActionManagerPrioritySchedule_W,'PrioritySchedule');
    RegisterPropertyHelper(@TCustomActionManagerStyle_R,@TCustomActionManagerStyle_W,'Style');
    RegisterPropertyHelper(@TCustomActionManagerOnStyleChanged_R,@TCustomActionManagerOnStyleChanged_W,'OnStyleChanged');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TActionBarStyle(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TActionBarStyle) do
  begin
    //RegisterVirtualAbstractMethod(@TActionBarStyle, @!.GetControlClass, 'GetControlClass');
    //RegisterVirtualAbstractMethod(@TActionBarStyle, @!.GetColorMapClass, 'GetColorMapClass');
    //RegisterVirtualAbstractMethod(@TActionBarStyle, @!.GetStyleName, 'GetStyleName');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_ActnMan(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TActionBars) do
  with CL.Add(TActionListCollection) do
  with CL.Add(TActionClientsCollection) do
  with CL.Add(TActionClientItem) do
  with CL.Add(TCustomActionBar) do
  with CL.Add(TActionClient) do
  with CL.Add(TActionClients) do
  with CL.Add(TActionBarItem) do
  with CL.Add(TCustomActionManager) do
  with CL.Add(TCustomActionControl) do
  with CL.Add(TCustomActionBarColorMap) do
  RIRegister_TActionBarStyle(CL);
  RIRegister_TCustomActionManager(CL);
  RIRegister_TActionManager(CL);
  RIRegister_TActionListItem(CL);
  RIRegister_TActionListCollection(CL);
  RIRegister_TActionClientsCollection(CL);
  RIRegister_TActionClient(CL);
  RIRegister_TActionBarItem(CL);
  RIRegister_TActionBars(CL);
  RIRegister_TActionClients(CL);
  with CL.Add(TActionClientLink) do
  RIRegister_TActionClientLink(CL);
  RIRegister_TActionClientItem(CL);
  RIRegister_TActionDragBaseClass(CL);
  with CL.Add(TCustomActionClass) do
  RIRegister_TActionDragObject(CL);
  RIRegister_TCategoryDragObject(CL);
  RIRegister_TActionItemDragObject(CL);
  RIRegister_TCustomActionBarColorMap(CL);
  RIRegister_TCustomActionBar(CL);
  RIRegister_TCustomActionControl(CL);
  RIRegister_TXToolDockForm(CL);
end;

 
 
{ TPSImport_ActnMan }
(*----------------------------------------------------------------------------*)
procedure TPSImport_ActnMan.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_ActnMan(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_ActnMan.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_ActnMan(ri);
  RIRegister_ActnMan_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
