unit uPSI_ovcvlb;
{
    another list box fox
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
  TPSImport_ovcvlb = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TOvcVirtualListBox(CL: TPSPascalCompiler);
procedure SIRegister_TOvcCustomVirtualListBox(CL: TPSPascalCompiler);
procedure SIRegister_ovcvlb(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TOvcVirtualListBox(CL: TPSRuntimeClassImporter);
procedure RIRegister_TOvcCustomVirtualListBox(CL: TPSRuntimeClassImporter);
procedure RIRegister_ovcvlb(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   Windows
  ,Controls
  ,Forms
  ,Graphics
  ,StdCtrls
  ,Menus
  ,Messages
  ,Types
  ,OvcBase
  ,OvcData
  ,OvcCmd
  ,OvcConst
  ,OvcMisc
  ,OvcExcpt
  ,OvcColor
  ,ovcvlb
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_ovcvlb]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
Function BoolToStr(value : boolean) : string;
Begin If value then Result := 'TRUE' else Result := 'FALSE' End;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TOvcVirtualListBox(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOvcCustomVirtualListBox', 'TOvcVirtualListBox') do
  with CL.AddClassN(CL.FindClass('TOvcCustomVirtualListBox'),'TOvcVirtualListBox') do
  begin
       REgisterPublishedProperties;
     RegisterProperty('COLOR', 'TColor', iptrw);
    RegisterProperty('FONT', 'TFont', iptrw);
    RegisterProperty('Visible', 'boolean', iptrw);
    RegisterProperty('ALIGNMENT', 'TAlignment', iptrw);
     RegisterProperty('ParentColor', 'TColor', iptrw);
    RegisterProperty('BevelWidth','TBevelWidth',iptrw);
    RegisterProperty('Parent','TWinControl',iptrw);
    // property Parent: TWinControl read FParent write SetParent;
     //RegisterProperty('Options', 'TAfComOptions', iptrw);
    //  RegisterProperty('TermColorMode', 'TAfTRMColorMode', iptrw);
    RegisterProperty('ONCLICK', 'TNotifyEvent', iptrw);
    RegisterProperty('ONDBLCLICK', 'TNotifyEvent', iptrw);
    RegisterProperty('ONENTER', 'TNotifyEvent', iptrw);
    RegisterProperty('ONEXIT', 'TNotifyEvent', iptrw);
    RegisterProperty('ONKEYDOWN', 'TKeyEvent', iptrw);
    RegisterProperty('ONKEYPRESS', 'TKeyPressEvent', iptrw);
     RegisterProperty('HIDESELECTION', 'Boolean', iptrw);
    RegisterProperty('MAXLENGTH', 'Integer', iptrw);
    RegisterProperty('PARENTCOLOR', 'Boolean', iptrw);
    RegisterProperty('PARENTFONT', 'Boolean', iptrw);
    RegisterProperty('READONLY', 'Boolean', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TOvcCustomVirtualListBox(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOvcCustomControlEx', 'TOvcCustomVirtualListBox') do
  with CL.AddClassN(CL.FindClass('TOvcCustomControlEx'),'TOvcCustomVirtualListBox') do begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
    RegisterMethod('Procedure BeginUpdate');
    RegisterMethod('Procedure CenterCurrentLine');
    RegisterMethod('Procedure CenterLine( Index : Integer)');
    RegisterMethod('Procedure DeselectAll');
    RegisterMethod('Procedure DrawItem( Index : LongInt)');
    RegisterMethod('Procedure EndUpdate');
    RegisterMethod('Procedure InsertItemsAt( Items : LongInt; Index : LongInt)');
    RegisterMethod('Procedure DeleteItemsAt( Items : LongInt; Index : LongInt)');
    RegisterMethod('Procedure InvalidateItem( Index : LongInt)');
    RegisterMethod('Function ItemAtPos( Pos : TPoint; Existing : Boolean) : LongInt');
    RegisterMethod('Procedure Scroll( HDelta, VDelta : Integer)');
    RegisterMethod('Procedure SelectAll');
    RegisterMethod('Procedure SetTabStops( const Tabs : array of Integer)');
    RegisterProperty('ItemIndex', 'LongInt', iptrw);
    RegisterProperty('FillColor', 'TColor', iptrw);
    RegisterProperty('SmoothScroll', 'Boolean', iptrw);
    RegisterProperty('TopIndex', 'LongInt', iptrw);
       REgisterPublishedProperties;
     RegisterProperty('COLOR', 'TColor', iptrw);
    RegisterProperty('FONT', 'TFont', iptrw);
    RegisterProperty('Visible', 'boolean', iptrw);
    RegisterProperty('ALIGNMENT', 'TAlignment', iptrw);
     RegisterProperty('ParentColor', 'TColor', iptrw);
    RegisterProperty('BevelWidth','TBevelWidth',iptrw);
    RegisterProperty('Parent','TWinControl',iptrw);
    // property Parent: TWinControl read FParent write SetParent;
     //RegisterProperty('Options', 'TAfComOptions', iptrw);
    //  RegisterProperty('TermColorMode', 'TAfTRMColorMode', iptrw);
    RegisterProperty('ONCLICK', 'TNotifyEvent', iptrw);
    RegisterProperty('ONDBLCLICK', 'TNotifyEvent', iptrw);
    RegisterProperty('ONENTER', 'TNotifyEvent', iptrw);
    RegisterProperty('ONEXIT', 'TNotifyEvent', iptrw);
    RegisterProperty('ONKEYDOWN', 'TKeyEvent', iptrw);
    RegisterProperty('ONKEYPRESS', 'TKeyPressEvent', iptrw);
     RegisterProperty('HIDESELECTION', 'Boolean', iptrw);
    RegisterProperty('MAXLENGTH', 'Integer', iptrw);
    RegisterProperty('PARENTCOLOR', 'Boolean', iptrw);
    RegisterProperty('PARENTFONT', 'Boolean', iptrw);
    RegisterProperty('READONLY', 'Boolean', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_ovcvlb(CL: TPSPascalCompiler);
begin
 CL.AddConstantN('vlbMaxTabStops','LongInt').SetInt( 128);
 //CL.AddConstantN('vlDefAutoRowHeight','Boolean')BoolToStr( True);
 //CL.AddConstantN('vlDefAlign','').SetString( alNone);
 //CL.AddConstantN('vlDefBorderStyle','').SetString( bsSingle);
 //CL.AddConstantN('vlDefColor','').SetString( clWindow);
 CL.AddConstantN('vlDefColumns','LongInt').SetInt( 255);
 CL.AddConstantN('vlDefCtl3D','Boolean').SetInt( 255);
 //CL.AddConstantN('vlDefHeaderBack','').SetString( clBtnFace);
 //CL.AddConstantN('vlDefHeaderText','').SetString( clBtnText);
 CL.AddConstantN('vlDefHeight','LongInt').SetInt( 150);
 CL.AddConstantN('vlDefIntegralHeight','Boolean').SetInt( 150);
 CL.AddConstantN('vlDefItemIndex','LongInt').SetInt( - 1);
 CL.AddConstantN('vlDefMultiSelect','Boolean').SetInt( - 1);
 //CL.AddConstantN('vlDefNumItems','').SetString( MaxLongInt);
 {CL.AddConstantN('vlDefOwnerDraw','Boolean').SetString( MaxLongInt);
 CL.AddConstantN('vlDefParentColor','Boolean').SetString( MaxLongInt);
 CL.AddConstantN('vlDefParentCtl3D','Boolean').SetString( MaxLongInt);
 CL.AddConstantN('vlDefParentFont','Boolean').SetString( MaxLongInt);
 CL.AddConstantN('vlDefProtectBack','').SetString( clRed);
 CL.AddConstantN('vlDefProtectText','').SetString( clWhite);}
 CL.AddConstantN('vlDefRowHeight','LongInt').SetInt( 17);
 //CL.AddConstantN('vlDefScrollBars','').SetString( ssVertical);
 //CL.AddConstantN('vlDefSelectBack','').SetString( clHighlight);
 //CL.AddConstantN('vlDefSelectText','').SetString( clHighlightText);
 //CL.AddConstantN('vlDefShowHeader','Boolean').SetString( clHighlightText);
 CL.AddConstantN('vlDefTopIndex','LongInt').SetInt( 0);
 CL.AddConstantN('vlDefTabStop','Boolean').SetInt( 0);
 CL.AddConstantN('vlDefUseTabStops','Boolean').SetInt( 0);
 CL.AddConstantN('vlDefWidth','LongInt').SetInt( 100);
  CL.AddTypeS('TCharToItemEvent', 'Procedure (Sender: TObject; Ch: Char; var Index : LongInt)');
  CL.AddTypeS('TovDrawItemEvent', 'Procedure ( Sender : TObject; Index : LongInt;'
   +' Rect : TRect; const S : string)');
  CL.AddTypeS('TGetItemEvent', 'Procedure ( Sender : TObject; Index : LongInt; '
   +'var ItemString : string)');
  CL.AddTypeS('TGetItemColorEvent', 'Procedure ( Sender : TObject; Index : Long'
   +'Int; var FG, BG : TColor)');
  CL.AddTypeS('TGetItemStatusEvent', 'Procedure ( Sender : TObject; Index : Lon'
   +'gInt; var Protect : Boolean)');
  CL.AddTypeS('THeaderClickEvent','Procedure (Sender: TObject; Point: TPoint)');
  CL.AddTypeS('TIsSelectedEvent', 'Procedure ( Sender : TObject; Index : LongIn'
   +'t; var Selected : Boolean)');
  CL.AddTypeS('TSelectEvent', 'Procedure ( Sender : TObject; Index : LongInt; S'
   +'elected : Boolean)');
  CL.AddTypeS('TTopIndexChanged', 'Procedure (Sender:TObject;NewTopIndex:LongInt)');
  SIRegister_TOvcCustomVirtualListBox(CL);
  SIRegister_TOvcVirtualListBox(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TOvcCustomVirtualListBoxTopIndex_W(Self: TOvcCustomVirtualListBox; const T: LongInt);
begin Self.TopIndex := T; end;

(*----------------------------------------------------------------------------*)
procedure TOvcCustomVirtualListBoxTopIndex_R(Self: TOvcCustomVirtualListBox; var T: LongInt);
begin T := Self.TopIndex; end;

(*----------------------------------------------------------------------------*)
procedure TOvcCustomVirtualListBoxSmoothScroll_W(Self: TOvcCustomVirtualListBox; const T: Boolean);
begin Self.SmoothScroll := T; end;

(*----------------------------------------------------------------------------*)
procedure TOvcCustomVirtualListBoxSmoothScroll_R(Self: TOvcCustomVirtualListBox; var T: Boolean);
begin T := Self.SmoothScroll; end;

(*----------------------------------------------------------------------------*)
procedure TOvcCustomVirtualListBoxFillColor_W(Self: TOvcCustomVirtualListBox; const T: TColor);
begin Self.FillColor := T; end;

(*----------------------------------------------------------------------------*)
procedure TOvcCustomVirtualListBoxFillColor_R(Self: TOvcCustomVirtualListBox; var T: TColor);
begin T := Self.FillColor; end;

(*----------------------------------------------------------------------------*)
procedure TOvcCustomVirtualListBoxItemIndex_W(Self: TOvcCustomVirtualListBox; const T: LongInt);
begin Self.ItemIndex := T; end;

(*----------------------------------------------------------------------------*)
procedure TOvcCustomVirtualListBoxItemIndex_R(Self: TOvcCustomVirtualListBox; var T: LongInt);
begin T := Self.ItemIndex; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TOvcVirtualListBox(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TOvcVirtualListBox) do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TOvcCustomVirtualListBox(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TOvcCustomVirtualListBox) do begin
    RegisterConstructor(@TOvcCustomVirtualListBox.Create, 'Create');
    RegisterVirtualMethod(@TOvcCustomVirtualListBox.BeginUpdate, 'BeginUpdate');
    RegisterMethod(@TOvcCustomVirtualListBox.CenterCurrentLine, 'CenterCurrentLine');
    RegisterMethod(@TOvcCustomVirtualListBox.CenterLine, 'CenterLine');
    RegisterMethod(@TOvcCustomVirtualListBox.DeselectAll, 'DeselectAll');
    RegisterMethod(@TOvcCustomVirtualListBox.DrawItem, 'DrawItem');
    RegisterVirtualMethod(@TOvcCustomVirtualListBox.EndUpdate, 'EndUpdate');
    RegisterMethod(@TOvcCustomVirtualListBox.InsertItemsAt, 'InsertItemsAt');
    RegisterMethod(@TOvcCustomVirtualListBox.DeleteItemsAt, 'DeleteItemsAt');
    RegisterMethod(@TOvcCustomVirtualListBox.InvalidateItem, 'InvalidateItem');
    RegisterMethod(@TOvcCustomVirtualListBox.ItemAtPos, 'ItemAtPos');
    RegisterMethod(@TOvcCustomVirtualListBox.Scroll, 'Scroll');
    RegisterMethod(@TOvcCustomVirtualListBox.SelectAll, 'SelectAll');
    RegisterMethod(@TOvcCustomVirtualListBox.SetTabStops, 'SetTabStops');
    RegisterPropertyHelper(@TOvcCustomVirtualListBoxItemIndex_R,@TOvcCustomVirtualListBoxItemIndex_W,'ItemIndex');
    RegisterPropertyHelper(@TOvcCustomVirtualListBoxFillColor_R,@TOvcCustomVirtualListBoxFillColor_W,'FillColor');
    RegisterPropertyHelper(@TOvcCustomVirtualListBoxSmoothScroll_R,@TOvcCustomVirtualListBoxSmoothScroll_W,'SmoothScroll');
    RegisterPropertyHelper(@TOvcCustomVirtualListBoxTopIndex_R,@TOvcCustomVirtualListBoxTopIndex_W,'TopIndex');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_ovcvlb(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TOvcCustomVirtualListBox(CL);
  RIRegister_TOvcVirtualListBox(CL);
end;

 
 
{ TPSImport_ovcvlb }
(*----------------------------------------------------------------------------*)
procedure TPSImport_ovcvlb.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_ovcvlb(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_ovcvlb.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_ovcvlb(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
