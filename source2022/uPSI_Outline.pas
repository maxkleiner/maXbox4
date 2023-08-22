unit uPSI_Outline;
{
procedure TControlParentR(Self: TControl; var T: TWinControl); begin T := Self.Parent; end;
procedure TControlParentW(Self: TControl; T: TWinControl); begin Self.Parent:= T; end;
      add lines 3.9.9.182  - update on drawitem
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
  TPSImport_Outline = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TOutline(CL: TPSPascalCompiler);
procedure SIRegister_TCustomOutline(CL: TPSPascalCompiler);
procedure SIRegister_TOutlineNode(CL: TPSPascalCompiler);
procedure SIRegister_Outline(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TOutline(CL: TPSRuntimeClassImporter);
procedure RIRegister_TCustomOutline(CL: TPSRuntimeClassImporter);
procedure RIRegister_TOutlineNode(CL: TPSRuntimeClassImporter);
procedure RIRegister_Outline(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   Windows
  ,Messages
  ,Forms
  ,Graphics
  ,Menus
  ,StdCtrls
  ,Grids
  ,Controls
  ,Outline
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_Outline]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TOutline(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TCustomOutline', 'TOutline') do
  with CL.AddClassN(CL.FindClass('TCustomOutline'),'TOutline') do begin
  //RegisterPublishedProperties;
      RegisterpublishedProperties;
    RegisterProperty('ALIGNMENT', 'TALIGNMENT', iptrw);
    RegisterProperty('CAPTION', 'String', iptrw);
    RegisterProperty('CHECKED', 'BOOLEAN', iptrw);
    RegisterProperty('COLOR', 'TColor', iptrw);
    //RegisterProperty('CANVAS', 'TCanvas', iptrw);
    RegisterProperty('FONT', 'TFont', iptrw);
    RegisterProperty('PARENTCOLOR', 'Boolean', iptrw);
    RegisterProperty('PARENTFONT', 'Boolean', iptrw);
     RegisterProperty('CTL3D', 'Boolean', iptrw);
     //RegisterProperty('FONT', 'TFont', iptrw);
     RegisterProperty('SORTED', 'Boolean', iptrw);
     RegisterProperty('Visible', 'Boolean', iptrw);
     RegisterProperty('TEXT', 'String', iptrw);
     RegisterProperty('Data', 'String', iptrw);
    RegisterProperty('Lines', 'TStrings', iptrw);
     RegisterProperty('OnDrawItem', 'TDrawItemEvent', iptrw);
 //  property OnDrawItem: TDrawItemEvent read FOnDrawItem write FOnDrawItem;
    // property Data: Pointer read FData write FData;
     RegisterProperty('BORDERSTYLE', 'TBorderStyle', iptrw);
    RegisterProperty('HIDESELECTION', 'Boolean', iptrw);
    RegisterProperty('MAXLENGTH', 'Integer', iptrw);
    RegisterProperty('Outlinestyle', 'TOutlinestyle', iptr);
    RegisterProperty('style', 'TOutlineType', iptr);

     RegisterProperty('PicturePlus', 'TBitmap', iptrw);
     RegisterProperty('PictureMinus', 'TBitmap', iptrw);
     RegisterProperty('PictureOpen', 'TBitmap', iptrw);
     RegisterProperty('PictureClosed', 'TBitmap', iptrw);
     RegisterProperty('PictureLeaf', 'TBitmap', iptrw);
     RegisterProperty('ItemHeight', 'Integer', iptrw);

    //FStyle: TOutlineType;
   end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TCustomOutline(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TCustomGrid', 'TCustomOutline') do
  with CL.AddClassN(CL.FindClass('TCustomGrid'),'TCustomOutline') do begin
  RegisterPublishedProperties;
    RegisterMethod('Constructor Create( AOwner : TComponent)');
      RegisterMethod('Procedure Free');
       RegisterMethod('procedure SetBounds(ALeft, ATop, AWidth, AHeight: Integer);');
      RegisterMethod('Function Add( Index : LongInt; const Text : string) : LongInt');
    RegisterMethod('Function AddChild( Index : LongInt; const Text : string) : LongInt');
    RegisterMethod('Function AddChildObject( Index : LongInt; const Text : string; const Data : Pointer) : LongInt');
    RegisterMethod('Function AddObject( Index : LongInt; const Text : string; const Data : Pointer) : LongInt');
    RegisterMethod('Function Insert( Index : LongInt; const Text : string) : LongInt');
    RegisterMethod('Function InsertObject( Index : LongInt; const Text : string; const Data : Pointer) : LongInt');
    RegisterMethod('Procedure Delete( Index : LongInt)');
    RegisterMethod('Procedure Update');
    RegisterMethod('Procedure Refresh');
    RegisterMethod('Function GetDataItem( Value : Pointer) : Longint');
    RegisterMethod('Function GetItem( X, Y : Integer) : LongInt');
    RegisterMethod('Function GetNodeDisplayWidth( Node : TOutlineNode) : Integer');
    RegisterMethod('Function GetTextItem( const Value : string) : Longint');
    RegisterMethod('Function GetVisibleNode( Index : LongInt) : TOutlineNode');
    RegisterMethod('Procedure FullExpand');
    RegisterMethod('Procedure FullCollapse');
    RegisterMethod('Procedure LoadFromFile( const FileName : string)');
    RegisterMethod('Procedure LoadFromStream( Stream : TStream)');
    RegisterMethod('Procedure SaveToFile( const FileName : string)');
    RegisterMethod('Procedure SaveToStream( Stream : TStream)');
    RegisterMethod('Procedure BeginUpdate');
    RegisterMethod('Procedure EndUpdate');
    RegisterMethod('Procedure SetUpdateState( Value : Boolean)');
    RegisterMethod('Procedure Clear');
    RegisterProperty('ItemCount', 'LongInt', iptr);
    RegisterProperty('Items', 'TOutlineNode LongInt', iptr);
    SetDefaultPropery('Items');
    RegisterProperty('SelectedItem', 'Longint', iptrw);
    RegisterProperty('Parent', 'TWinControl', iptRW);
    RegisterProperty('CANVAS', 'TCanvas', iptrw);
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
    RegisterProperty('ONExpand', 'EOutlineChange', iptrw);
    RegisterProperty('ONCollapse', 'EOutlineChange', iptrw);

    // property OnExpand: EOutlineChange read FOnExpand write FOnExpand;
    //property OnCollapse: EOutlineChange read FOnCollapse write FOnCollapse;


  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TOutlineNode(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TPersistent', 'TOutlineNode') do
  with CL.AddClassN(CL.FindClass('TPersistent'),'TOutlineNode') do begin
  RegisterPublishedProperties;
    RegisterMethod('Constructor Create( AOwner : TCustomOutline)');
    RegisterMethod('Procedure Free');
     RegisterMethod('Procedure ChangeLevelBy( Value : TChangeRange)');
    RegisterMethod('Procedure Collapse');
    RegisterMethod('Procedure Expand');
    RegisterMethod('Procedure FullExpand');
    RegisterMethod('Function GetDisplayWidth : Integer');
    RegisterMethod('Function getFirstChild : LongInt');
    RegisterMethod('Function GetLastChild : LongInt');
    RegisterMethod('Function GetNextChild( Value : LongInt) : LongInt');
    RegisterMethod('Function GetPrevChild( Value : LongInt) : LongInt');
    RegisterMethod('Procedure MoveTo( Destination : LongInt; AttachMode : TAttachMode)');
    RegisterProperty('Parent', 'TOutlineNode', iptr);
    RegisterProperty('Expanded', 'Boolean', iptrw);
    RegisterProperty('Text', 'string', iptrw);
    RegisterProperty('Data', 'string', iptrw);
    RegisterProperty('Index', 'LongInt', iptr);
    RegisterProperty('Level', 'Cardinal', iptrw);
    RegisterProperty('HasItems', 'Boolean', iptr);
    RegisterProperty('IsVisible', 'Boolean', iptr);
    RegisterProperty('TopItem', 'Longint', iptr);
    RegisterProperty('FullPath', 'string', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_Outline(CL: TPSPascalCompiler);
begin
  CL.AddClassN(CL.FindClass('TOBJECT'),'OutlineError');
  CL.AddClassN(CL.FindClass('TOBJECT'),'EOutlineError');
  CL.AddTypeS('TOutlineNodeCompare', '( ocLess, ocSame, ocGreater, ocInvalid )');
  CL.AddTypeS('TAttachMode', '( oaAdd, oaAddChild, oaInsert )');
  CL.AddClassN(CL.FindClass('TOBJECT'),'TCustomOutline');
  SIRegister_TOutlineNode(CL);
  CL.AddTypeS('TBitmapArrayRange', 'Integer');
  CL.AddTypeS('EOutlineChange', 'Procedure ( Sender : TObject; Index : LongInt)');
  CL.AddTypeS('TOutlineStyle', '( osText, osPlusMinusText, osPictureText, osPlu'
   +'sMinusPictureText, osTreeText, osTreePictureText )');
  CL.AddTypeS('TOutlineBitmap', '( obPlus, obMinus, obOpen, obClose, obLeaf )');
  CL.AddTypeS('TOutlineBitmaps', 'set of TOutlineBitmap');
  CL.AddTypeS('TOutlineType', '( otStandard, otOwnerDraw )');
  CL.AddTypeS('TOutlineOption', '( ooDrawTreeRoot, ooDrawFocusRect, ooStretchBitmaps )');
  CL.AddTypeS('TOutlineOptions', 'set of TOutlineOption');
  SIRegister_TCustomOutline(CL);
  SIRegister_TOutline(CL);
end;

(* === run-time registration functions === *)

procedure TControlParentR(Self: TControl; var T: TWinControl); begin T := Self.Parent; end;
procedure TControlParentW(Self: TControl; T: TWinControl); begin Self.Parent:= T; end;

procedure TControlCanvasR(Self: TCustomoutline; var T: TCanvas); begin T := Self.Canvas; end;
procedure TControlCanvasW(Self: TCustomoutline; T: TCanvas); begin {Self.Canvas:= T;} end;

(*----------------------------------------------------------------------------*)
procedure TCustomOutlineSelectedItem_W(Self: TCustomOutline; const T: Longint);
begin Self.SelectedItem := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomOutlineSelectedItem_R(Self: TCustomOutline; var T: Longint);
begin T := Self.SelectedItem; end;

(*----------------------------------------------------------------------------*)
procedure TCustomOutlineItems_R(Self: TCustomOutline; var T: TOutlineNode; const t1: LongInt);
begin T := Self.Items[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TCustomOutlineItemCount_R(Self: TCustomOutline; var T: LongInt);
begin T := Self.ItemCount; end;

(*----------------------------------------------------------------------------*)
procedure TOutlineNodeFullPath_R(Self: TOutlineNode; var T: string);
begin T := Self.FullPath; end;

(*----------------------------------------------------------------------------*)
procedure TOutlineNodeTopItem_R(Self: TOutlineNode; var T: Longint);
begin T := Self.TopItem; end;

(*----------------------------------------------------------------------------*)
procedure TOutlineNodeIsVisible_R(Self: TOutlineNode; var T: Boolean);
begin T := Self.IsVisible; end;

(*----------------------------------------------------------------------------*)
procedure TOutlineNodeHasItems_R(Self: TOutlineNode; var T: Boolean);
begin T := Self.HasItems; end;

(*----------------------------------------------------------------------------*)
procedure TOutlineNodeLevel_W(Self: TOutlineNode; const T: Cardinal);
begin Self.Level := T; end;

(*----------------------------------------------------------------------------*)
procedure TOutlineNodeLevel_R(Self: TOutlineNode; var T: Cardinal);
begin T := Self.Level; end;

(*----------------------------------------------------------------------------*)
procedure TOutlineNodeIndex_R(Self: TOutlineNode; var T: LongInt);
begin T := Self.Index; end;

(*----------------------------------------------------------------------------*)
procedure TOutlineNodeData_W(Self: TOutlineNode; const T: Pointer);
begin Self.Data := T; end;

(*----------------------------------------------------------------------------*)
procedure TOutlineNodeData_R(Self: TOutlineNode; var T: Pointer);
begin T := Self.Data; end;

(*----------------------------------------------------------------------------*)
procedure TOutlineNodeText_W(Self: TOutlineNode; const T: string);
begin Self.Text := T; end;

(*----------------------------------------------------------------------------*)
procedure TOutlineNodeText_R(Self: TOutlineNode; var T: string);
begin T := Self.Text; end;

(*----------------------------------------------------------------------------*)
procedure TOutlineNodeExpanded_W(Self: TOutlineNode; const T: Boolean);
begin Self.Expanded := T; end;

(*----------------------------------------------------------------------------*)
procedure TOutlineNodeExpanded_R(Self: TOutlineNode; var T: Boolean);
begin T := Self.Expanded; end;

(*----------------------------------------------------------------------------*)
procedure TOutlineNodeParent_R(Self: TOutlineNode; var T: TOutlineNode);
begin T := Self.Parent; end;


procedure TITEMONCLICK_W(Self: TOutline; const T: TNOTIFYEVENT);
begin Self.ONCLICK := T; end;
procedure TITEMONCLICK_R(Self: TOutline; var T: TNOTIFYEVENT);
begin T := Self.ONCLICK; end;

procedure TITEMONDBLCLICK_W(Self: TOutline; const T: TNOTIFYEVENT);
begin Self.ONDBLCLICK := T; end;
procedure TITEMONDBLCLICK_R(Self: TOutline; var T: TNOTIFYEVENT);
begin T := Self.ONDBLCLICK; end;
procedure TITEMONENTER_W(Self: TOutline; const T: TNOTIFYEVENT);
begin Self.ONENTER:= T; end;
procedure TITEMONENTER_R(Self: TOutline; var T: TNOTIFYEVENT);
begin T := Self.ONENTER; end;
procedure TITEMONEXIT_W(Self: TOutline; const T: TNOTIFYEVENT);
begin Self.ONEXIT:= T; end;
procedure TITEMONEXIT_R(Self: TOutline; var T: TNOTIFYEVENT);
begin T := Self.ONEXIT; end;


(*----------------------------------------------------------------------------*)
procedure RIRegister_TOutline(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TOutline) do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TCustomOutline(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TCustomOutline) do begin
    RegisterConstructor(@TCustomOutline.Create, 'Create');
     RegisterMethod(@TCustomOutline.Destroy, 'Free');
      RegisterMethod(@TCustomOutline.Add, 'Add');
      RegisterMethod(@TCustomOutline.SetBounds, 'SetBounds');
      RegisterMethod(@TCustomOutline.AddChild, 'AddChild');
    RegisterMethod(@TCustomOutline.AddChildObject, 'AddChildObject');
    RegisterMethod(@TCustomOutline.AddObject, 'AddObject');
    RegisterMethod(@TCustomOutline.Insert, 'Insert');
    RegisterMethod(@TCustomOutline.InsertObject, 'InsertObject');
    RegisterMethod(@TCustomOutline.Delete, 'Delete');
    RegisterMethod(@TCustomOutline.update, 'Update');
    RegisterMethod(@TCustomOutline.refresh, 'Refresh');
     RegisterMethod(@TCustomOutline.GetDataItem, 'GetDataItem');
    RegisterMethod(@TCustomOutline.GetItem, 'GetItem');
    RegisterMethod(@TCustomOutline.GetNodeDisplayWidth, 'GetNodeDisplayWidth');
    RegisterMethod(@TCustomOutline.GetTextItem, 'GetTextItem');
    RegisterMethod(@TCustomOutline.GetVisibleNode, 'GetVisibleNode');
    RegisterMethod(@TCustomOutline.FullExpand, 'FullExpand');
    RegisterMethod(@TCustomOutline.FullCollapse, 'FullCollapse');
    RegisterMethod(@TCustomOutline.LoadFromFile, 'LoadFromFile');
    RegisterMethod(@TCustomOutline.LoadFromStream, 'LoadFromStream');
    RegisterMethod(@TCustomOutline.SaveToFile, 'SaveToFile');
    RegisterMethod(@TCustomOutline.SaveToStream, 'SaveToStream');
    RegisterMethod(@TCustomOutline.BeginUpdate, 'BeginUpdate');
    RegisterMethod(@TCustomOutline.EndUpdate, 'EndUpdate');
    RegisterMethod(@TCustomOutline.SetUpdateState, 'SetUpdateState');
    RegisterMethod(@TCustomOutline.Clear, 'Clear');
    RegisterPropertyHelper(@TCustomOutlineItemCount_R,nil,'ItemCount');
    RegisterPropertyHelper(@TCustomOutlineItems_R,nil,'Items');
    RegisterPropertyHelper(@TCustomOutlineSelectedItem_R,@TCustomOutlineSelectedItem_W,'SelectedItem');
    RegisterPropertyHelper(@TControlParentR, @TControlParentW, 'PARENT');
    RegisterPropertyHelper(@TControlCanvasR, @TControlCanvasW, 'CANVAS');
 	  RegisterEventPropertyHelper(@TITEMONCLICK_R,@TITEMONCLICK_W,'ONCLICK');
 		RegisterEventPropertyHelper(@TITEMONDBLCLICK_R,@TITEMONDBLCLICK_W,'ONDBLCLICK');
 		RegisterEventPropertyHelper(@TITEMONENTER_R,@TITEMONENTER_W,'ONENTER');
 		RegisterEventPropertyHelper(@TITEMONEXIT_R,@TITEMONEXIT_W,'ONEXIT');

  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TOutlineNode(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TOutlineNode) do begin
    RegisterConstructor(@TOutlineNode.Create, 'Create');
     RegisterMethod(@TOutlineNode.Destroy, 'Free');
      RegisterMethod(@TOutlineNode.ChangeLevelBy, 'ChangeLevelBy');
    RegisterMethod(@TOutlineNode.Collapse, 'Collapse');
    RegisterMethod(@TOutlineNode.Expand, 'Expand');
    RegisterMethod(@TOutlineNode.FullExpand, 'FullExpand');
    RegisterMethod(@TOutlineNode.GetDisplayWidth, 'GetDisplayWidth');
    RegisterMethod(@TOutlineNode.getFirstChild, 'getFirstChild');
    RegisterMethod(@TOutlineNode.GetLastChild, 'GetLastChild');
    RegisterMethod(@TOutlineNode.GetNextChild, 'GetNextChild');
    RegisterMethod(@TOutlineNode.GetPrevChild, 'GetPrevChild');
    RegisterMethod(@TOutlineNode.MoveTo, 'MoveTo');
    RegisterPropertyHelper(@TOutlineNodeParent_R,nil,'Parent');
    RegisterPropertyHelper(@TOutlineNodeExpanded_R,@TOutlineNodeExpanded_W,'Expanded');
    RegisterPropertyHelper(@TOutlineNodeText_R,@TOutlineNodeText_W,'Text');
    RegisterPropertyHelper(@TOutlineNodeData_R,@TOutlineNodeData_W,'Data');
    RegisterPropertyHelper(@TOutlineNodeIndex_R,nil,'Index');
    RegisterPropertyHelper(@TOutlineNodeLevel_R,@TOutlineNodeLevel_W,'Level');
    RegisterPropertyHelper(@TOutlineNodeHasItems_R,nil,'HasItems');
    RegisterPropertyHelper(@TOutlineNodeIsVisible_R,nil,'IsVisible');
    RegisterPropertyHelper(@TOutlineNodeTopItem_R,nil,'TopItem');
    RegisterPropertyHelper(@TOutlineNodeFullPath_R,nil,'FullPath');

  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_Outline(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(OutlineError) do
  with CL.Add(EOutlineError) do
  with CL.Add(TCustomOutline) do
  RIRegister_TOutlineNode(CL);
  RIRegister_TCustomOutline(CL);
  RIRegister_TOutline(CL);
end;

 
 
{ TPSImport_Outline }
(*----------------------------------------------------------------------------*)
procedure TPSImport_Outline.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_Outline(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_Outline.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_Outline(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
