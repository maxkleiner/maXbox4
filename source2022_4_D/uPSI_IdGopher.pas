unit uPSI_IdGopher;
{
This file has been generated by UnitParser v0.7, written by M. Knight
and updated by NP. v/d Spek and George Birbilis. 
Source Code from Carlo Kok has been used to implement various sections of
UnitParser. Components of ROPS are used in the construction of UnitParser,
code implementing the class wrapper is taken from Carlo Kok's conv utility

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
  TPSImport_IdGopher = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TIdGopher(CL: TPSPascalCompiler);
procedure SIRegister_TIdGopherMenu(CL: TPSPascalCompiler);
procedure SIRegister_TIdGopherMenuItem(CL: TPSPascalCompiler);
procedure SIRegister_IdGopher(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TIdGopher(CL: TPSRuntimeClassImporter);
procedure RIRegister_TIdGopherMenu(CL: TPSRuntimeClassImporter);
procedure RIRegister_TIdGopherMenuItem(CL: TPSRuntimeClassImporter);
procedure RIRegister_IdGopher(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   IdAssignedNumbers
  ,IdEMailAddress
  ,IdHeaderList
  ,IdTCPClient
  ,IdGopher
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_IdGopher]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TIdGopher(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TIdTCPClient', 'TIdGopher') do
  with CL.AddClassN(CL.FindClass('TIdTCPClient'),'TIdGopher') do
  begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
    RegisterMethod('Function GetMenu( ASelector : String; IsGopherPlus : Boolean; AView : String) : TIdGopherMenu');
    RegisterMethod('Function Search( ASelector, AQuery : String) : TIdGopherMenu');
    RegisterMethod('Procedure GetFile( ASelector : String; ADestStream : TStream; IsGopherPlus : Boolean; AView : String)');
    RegisterMethod('Procedure GetTextFile( ASelector : String; ADestStream : TStream; IsGopherPlus : Boolean; AView : String)');
    RegisterMethod('Function GetExtendedMenu( ASelector : String; AView : String) : TIdGopherMenu');
    RegisterProperty('OnMenuItem', 'TIdGopherMenuEvent', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TIdGopherMenu(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TCollection', 'TIdGopherMenu') do
  with CL.AddClassN(CL.FindClass('TCollection'),'TIdGopherMenu') do
  begin
    RegisterMethod('Constructor Create');
    RegisterMethod('Function Add : TIdGopherMenuItem');
    RegisterProperty('Items', 'TIdGopherMenuItem Integer', iptrw);
    SetDefaultPropery('Items');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TIdGopherMenuItem(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TCollectionItem', 'TIdGopherMenuItem') do
  with CL.AddClassN(CL.FindClass('TCollectionItem'),'TIdGopherMenuItem') do
  begin
    RegisterMethod('Constructor Create( ACollection : TCollection)');
    RegisterMethod('Procedure DoneSettingInfoBlock');
    RegisterProperty('Title', 'String', iptrw);
    RegisterProperty('ItemType', 'Char', iptrw);
    RegisterProperty('Selector', 'String', iptrw);
    RegisterProperty('Server', 'String', iptrw);
    RegisterProperty('Port', 'Integer', iptrw);
    RegisterProperty('GopherPlusItem', 'Boolean', iptrw);
    RegisterProperty('GopherBlock', 'TIdHeaderList', iptr);
    RegisterProperty('URL', 'String', iptr);
    RegisterProperty('Views', 'TStringList', iptr);
    RegisterProperty('AAbstract', 'TStringList', iptr);
    RegisterProperty('LastModified', 'String', iptr);
    RegisterProperty('AdminEMail', 'TIdEMailAddressItem', iptr);
    RegisterProperty('Organization', 'String', iptr);
    RegisterProperty('Location', 'String', iptr);
    RegisterProperty('Geog', 'String', iptr);
    RegisterProperty('Ask', 'TIdHeaderList', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_IdGopher(CL: TPSPascalCompiler);
begin
  SIRegister_TIdGopherMenuItem(CL);
  SIRegister_TIdGopherMenu(CL);
  CL.AddTypeS('TIdGopherMenuEvent', 'Procedure ( Sender : TObject; MenuItem : T'
   +'IdGopherMenuItem)');
  SIRegister_TIdGopher(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TIdGopherOnMenuItem_W(Self: TIdGopher; const T: TIdGopherMenuEvent);
begin Self.OnMenuItem := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdGopherOnMenuItem_R(Self: TIdGopher; var T: TIdGopherMenuEvent);
begin T := Self.OnMenuItem; end;

(*----------------------------------------------------------------------------*)
procedure TIdGopherMenuItems_W(Self: TIdGopherMenu; const T: TIdGopherMenuItem; const t1: Integer);
begin Self.Items[t1] := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdGopherMenuItems_R(Self: TIdGopherMenu; var T: TIdGopherMenuItem; const t1: Integer);
begin T := Self.Items[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TIdGopherMenuItemAsk_R(Self: TIdGopherMenuItem; var T: TIdHeaderList);
begin T := Self.Ask; end;

(*----------------------------------------------------------------------------*)
procedure TIdGopherMenuItemGeog_R(Self: TIdGopherMenuItem; var T: String);
begin T := Self.Geog; end;

(*----------------------------------------------------------------------------*)
procedure TIdGopherMenuItemLocation_R(Self: TIdGopherMenuItem; var T: String);
begin T := Self.Location; end;

(*----------------------------------------------------------------------------*)
procedure TIdGopherMenuItemOrganization_R(Self: TIdGopherMenuItem; var T: String);
begin T := Self.Organization; end;

(*----------------------------------------------------------------------------*)
procedure TIdGopherMenuItemAdminEMail_R(Self: TIdGopherMenuItem; var T: TIdEMailAddressItem);
begin T := Self.AdminEMail; end;

(*----------------------------------------------------------------------------*)
procedure TIdGopherMenuItemLastModified_R(Self: TIdGopherMenuItem; var T: String);
begin T := Self.LastModified; end;

(*----------------------------------------------------------------------------*)
procedure TIdGopherMenuItemAAbstract_R(Self: TIdGopherMenuItem; var T: TStringList);
begin T := Self.AAbstract; end;

(*----------------------------------------------------------------------------*)
procedure TIdGopherMenuItemViews_R(Self: TIdGopherMenuItem; var T: TStringList);
begin T := Self.Views; end;

(*----------------------------------------------------------------------------*)
procedure TIdGopherMenuItemURL_R(Self: TIdGopherMenuItem; var T: String);
begin T := Self.URL; end;

(*----------------------------------------------------------------------------*)
procedure TIdGopherMenuItemGopherBlock_R(Self: TIdGopherMenuItem; var T: TIdHeaderList);
begin T := Self.GopherBlock; end;

(*----------------------------------------------------------------------------*)
procedure TIdGopherMenuItemGopherPlusItem_W(Self: TIdGopherMenuItem; const T: Boolean);
begin Self.GopherPlusItem := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdGopherMenuItemGopherPlusItem_R(Self: TIdGopherMenuItem; var T: Boolean);
begin T := Self.GopherPlusItem; end;

(*----------------------------------------------------------------------------*)
procedure TIdGopherMenuItemPort_W(Self: TIdGopherMenuItem; const T: Integer);
begin Self.Port := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdGopherMenuItemPort_R(Self: TIdGopherMenuItem; var T: Integer);
begin T := Self.Port; end;

(*----------------------------------------------------------------------------*)
procedure TIdGopherMenuItemServer_W(Self: TIdGopherMenuItem; const T: String);
begin Self.Server := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdGopherMenuItemServer_R(Self: TIdGopherMenuItem; var T: String);
begin T := Self.Server; end;

(*----------------------------------------------------------------------------*)
procedure TIdGopherMenuItemSelector_W(Self: TIdGopherMenuItem; const T: String);
begin Self.Selector := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdGopherMenuItemSelector_R(Self: TIdGopherMenuItem; var T: String);
begin T := Self.Selector; end;

(*----------------------------------------------------------------------------*)
procedure TIdGopherMenuItemItemType_W(Self: TIdGopherMenuItem; const T: Char);
begin Self.ItemType := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdGopherMenuItemItemType_R(Self: TIdGopherMenuItem; var T: Char);
begin T := Self.ItemType; end;

(*----------------------------------------------------------------------------*)
procedure TIdGopherMenuItemTitle_W(Self: TIdGopherMenuItem; const T: String);
begin Self.Title := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdGopherMenuItemTitle_R(Self: TIdGopherMenuItem; var T: String);
begin T := Self.Title; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TIdGopher(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TIdGopher) do
  begin
    RegisterConstructor(@TIdGopher.Create, 'Create');
    RegisterMethod(@TIdGopher.GetMenu, 'GetMenu');
    RegisterMethod(@TIdGopher.Search, 'Search');
    RegisterMethod(@TIdGopher.GetFile, 'GetFile');
    RegisterMethod(@TIdGopher.GetTextFile, 'GetTextFile');
    RegisterMethod(@TIdGopher.GetExtendedMenu, 'GetExtendedMenu');
    RegisterPropertyHelper(@TIdGopherOnMenuItem_R,@TIdGopherOnMenuItem_W,'OnMenuItem');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TIdGopherMenu(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TIdGopherMenu) do
  begin
    RegisterConstructor(@TIdGopherMenu.Create, 'Create');
    RegisterMethod(@TIdGopherMenu.Add, 'Add');
    RegisterPropertyHelper(@TIdGopherMenuItems_R,@TIdGopherMenuItems_W,'Items');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TIdGopherMenuItem(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TIdGopherMenuItem) do
  begin
    RegisterConstructor(@TIdGopherMenuItem.Create, 'Create');
    RegisterVirtualMethod(@TIdGopherMenuItem.DoneSettingInfoBlock, 'DoneSettingInfoBlock');
    RegisterPropertyHelper(@TIdGopherMenuItemTitle_R,@TIdGopherMenuItemTitle_W,'Title');
    RegisterPropertyHelper(@TIdGopherMenuItemItemType_R,@TIdGopherMenuItemItemType_W,'ItemType');
    RegisterPropertyHelper(@TIdGopherMenuItemSelector_R,@TIdGopherMenuItemSelector_W,'Selector');
    RegisterPropertyHelper(@TIdGopherMenuItemServer_R,@TIdGopherMenuItemServer_W,'Server');
    RegisterPropertyHelper(@TIdGopherMenuItemPort_R,@TIdGopherMenuItemPort_W,'Port');
    RegisterPropertyHelper(@TIdGopherMenuItemGopherPlusItem_R,@TIdGopherMenuItemGopherPlusItem_W,'GopherPlusItem');
    RegisterPropertyHelper(@TIdGopherMenuItemGopherBlock_R,nil,'GopherBlock');
    RegisterPropertyHelper(@TIdGopherMenuItemURL_R,nil,'URL');
    RegisterPropertyHelper(@TIdGopherMenuItemViews_R,nil,'Views');
    RegisterPropertyHelper(@TIdGopherMenuItemAAbstract_R,nil,'AAbstract');
    RegisterPropertyHelper(@TIdGopherMenuItemLastModified_R,nil,'LastModified');
    RegisterPropertyHelper(@TIdGopherMenuItemAdminEMail_R,nil,'AdminEMail');
    RegisterPropertyHelper(@TIdGopherMenuItemOrganization_R,nil,'Organization');
    RegisterPropertyHelper(@TIdGopherMenuItemLocation_R,nil,'Location');
    RegisterPropertyHelper(@TIdGopherMenuItemGeog_R,nil,'Geog');
    RegisterPropertyHelper(@TIdGopherMenuItemAsk_R,nil,'Ask');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_IdGopher(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TIdGopherMenuItem(CL);
  RIRegister_TIdGopherMenu(CL);
  RIRegister_TIdGopher(CL);
end;

 
 
{ TPSImport_IdGopher }
(*----------------------------------------------------------------------------*)
procedure TPSImport_IdGopher.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_IdGopher(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_IdGopher.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_IdGopher(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
