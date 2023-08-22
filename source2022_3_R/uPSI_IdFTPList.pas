unit uPSI_IdFTPList;
{
add to mX4 as 740_uFTPServermX2.pas

to ftp server  to list


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
  TPSImport_IdFTPList = class(TPSPlugin)
  public
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TIdFTPListItems(CL: TPSPascalCompiler);
procedure SIRegister_TIdFTPListItem(CL: TPSPascalCompiler);
procedure SIRegister_IdFTPList(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TIdFTPListItems(CL: TPSRuntimeClassImporter);
procedure RIRegister_TIdFTPListItem(CL: TPSRuntimeClassImporter);
procedure RIRegister_IdFTPList(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   IdException
  ,IdGlobal
  ,IdFTPList
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_IdFTPList]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TIdFTPListItems(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TCollection', 'TIdFTPListItems') do
  with CL.AddClassN(CL.FindClass('TCollection'),'TIdFTPListItems') do begin
    RegisterMethod('Function Add : TIdFTPListItem');
    //RegisterMethod('Assign(Source: TPersistent); ');
    RegisterMethod('Function CheckListFormat( Data : string; const ADetails : Boolean) : TIdFTPListFormat');
    RegisterMethod('Constructor Create');
    RegisterMethod('Function IndexOf( AItem : TIdFTPListItem) : Integer');
    RegisterMethod('Procedure LoadList( AData : TStrings)');
    RegisterMethod('Procedure Parse( ListFormat : TIdFTPListFormat; AItem : TIdFTPListItem)');
    RegisterMethod('Procedure ParseUnknown( AItem : TIdFTPListItem)');
    RegisterMethod('Procedure ParseCustom( AItem : TIdFTPListItem)');
    RegisterProperty('DirectoryName', 'string', iptrw);
    RegisterProperty('Items', 'TIdFTPListItem Integer', iptrw);
    SetDefaultPropery('Items');
    RegisterProperty('ListFormat', 'TIdFTPListFormat', iptrw);
    RegisterProperty('OnGetCustomListFormat', 'TIdOnGetCustomListFormat', iptrw);
    RegisterProperty('OnParseCustomListFormat', 'TIdOnParseCustomListFormat', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TIdFTPListItem(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TCollectionItem', 'TIdFTPListItem') do
  with CL.AddClassN(CL.FindClass('TCollectionItem'),'TIdFTPListItem') do begin
    RegisterMethod('Procedure Assign( Source : TPersistent)');
    RegisterMethod('Constructor Create( AOwner : TCollection)');
    RegisterMethod('Function Text : string');
    RegisterProperty('Data', 'string', iptrw);
    RegisterProperty('OwnerPermissions', 'string', iptrw);
    RegisterProperty('GroupPermissions', 'string', iptrw);
    RegisterProperty('UserPermissions', 'string', iptrw);
    RegisterProperty('ItemCount', 'Integer', iptrw);
    RegisterProperty('OwnerName', 'string', iptrw);
    RegisterProperty('GroupName', 'string', iptrw);
    RegisterProperty('Size', 'Int64', iptrw);
    RegisterProperty('ModifiedDate', 'TDateTime', iptrw);
    RegisterProperty('FileName', 'string', iptrw);
    RegisterProperty('ItemType', 'TIdDirItemType', iptrw);
    RegisterProperty('LinkedItemName', 'string', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_IdFTPList(CL: TPSPascalCompiler);
begin
  CL.AddClassN(CL.FindClass('TOBJECT'),'EIdInvalidFTPListingFormat');
  CL.AddTypeS('TIdFTPListFormat', '( flfNone, flfDos, flfUnix, flfVax, flfNoDet'
   +'ails, flfUnknown, flfCustom )');
  CL.AddTypeS('TIdDirItemType', '( ditDirectory, ditFile, ditSymbolicLink )');
  CL.AddClassN(CL.FindClass('TOBJECT'),'TIdFTPListItems');
  SIRegister_TIdFTPListItem(CL);
  CL.AddTypeS('TIdOnGetCustomListFormat', 'Procedure ( AItem : TIdFTPListItem; '
   +'var VText : string)');
  CL.AddTypeS('TIdOnParseCustomListFormat', 'Procedure ( AItem : TIdFTPListItem)');
  SIRegister_TIdFTPListItems(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TIdFTPListItemsOnParseCustomListFormat_W(Self: TIdFTPListItems; const T: TIdOnParseCustomListFormat);
begin Self.OnParseCustomListFormat := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdFTPListItemsOnParseCustomListFormat_R(Self: TIdFTPListItems; var T: TIdOnParseCustomListFormat);
begin T := Self.OnParseCustomListFormat; end;

(*----------------------------------------------------------------------------*)
procedure TIdFTPListItemsOnGetCustomListFormat_W(Self: TIdFTPListItems; const T: TIdOnGetCustomListFormat);
begin Self.OnGetCustomListFormat := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdFTPListItemsOnGetCustomListFormat_R(Self: TIdFTPListItems; var T: TIdOnGetCustomListFormat);
begin T := Self.OnGetCustomListFormat; end;

(*----------------------------------------------------------------------------*)
procedure TIdFTPListItemsListFormat_W(Self: TIdFTPListItems; const T: TIdFTPListFormat);
begin Self.ListFormat := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdFTPListItemsListFormat_R(Self: TIdFTPListItems; var T: TIdFTPListFormat);
begin T := Self.ListFormat; end;

(*----------------------------------------------------------------------------*)
procedure TIdFTPListItemsItems_W(Self: TIdFTPListItems; const T: TIdFTPListItem; const t1: Integer);
begin Self.Items[t1] := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdFTPListItemsItems_R(Self: TIdFTPListItems; var T: TIdFTPListItem; const t1: Integer);
begin T := Self.Items[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TIdFTPListItemsDirectoryName_W(Self: TIdFTPListItems; const T: string);
begin Self.DirectoryName := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdFTPListItemsDirectoryName_R(Self: TIdFTPListItems; var T: string);
begin T := Self.DirectoryName; end;

(*----------------------------------------------------------------------------*)
procedure TIdFTPListItemLinkedItemName_W(Self: TIdFTPListItem; const T: string);
begin Self.LinkedItemName := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdFTPListItemLinkedItemName_R(Self: TIdFTPListItem; var T: string);
begin T := Self.LinkedItemName; end;

(*----------------------------------------------------------------------------*)
procedure TIdFTPListItemItemType_W(Self: TIdFTPListItem; const T: TIdDirItemType);
begin Self.ItemType := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdFTPListItemItemType_R(Self: TIdFTPListItem; var T: TIdDirItemType);
begin T := Self.ItemType; end;

(*----------------------------------------------------------------------------*)
procedure TIdFTPListItemFileName_W(Self: TIdFTPListItem; const T: string);
begin Self.FileName := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdFTPListItemFileName_R(Self: TIdFTPListItem; var T: string);
begin T := Self.FileName; end;

(*----------------------------------------------------------------------------*)
procedure TIdFTPListItemModifiedDate_W(Self: TIdFTPListItem; const T: TDateTime);
begin Self.ModifiedDate := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdFTPListItemModifiedDate_R(Self: TIdFTPListItem; var T: TDateTime);
begin T := Self.ModifiedDate; end;

(*----------------------------------------------------------------------------*)
procedure TIdFTPListItemSize_W(Self: TIdFTPListItem; const T: Int64);
begin Self.Size := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdFTPListItemSize_R(Self: TIdFTPListItem; var T: Int64);
begin T := Self.Size; end;

(*----------------------------------------------------------------------------*)
procedure TIdFTPListItemGroupName_W(Self: TIdFTPListItem; const T: string);
begin Self.GroupName := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdFTPListItemGroupName_R(Self: TIdFTPListItem; var T: string);
begin T := Self.GroupName; end;

(*----------------------------------------------------------------------------*)
procedure TIdFTPListItemOwnerName_W(Self: TIdFTPListItem; const T: string);
begin Self.OwnerName := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdFTPListItemOwnerName_R(Self: TIdFTPListItem; var T: string);
begin T := Self.OwnerName; end;

(*----------------------------------------------------------------------------*)
procedure TIdFTPListItemItemCount_W(Self: TIdFTPListItem; const T: Integer);
begin Self.ItemCount := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdFTPListItemItemCount_R(Self: TIdFTPListItem; var T: Integer);
begin T := Self.ItemCount; end;

(*----------------------------------------------------------------------------*)
procedure TIdFTPListItemUserPermissions_W(Self: TIdFTPListItem; const T: string);
begin Self.UserPermissions := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdFTPListItemUserPermissions_R(Self: TIdFTPListItem; var T: string);
begin T := Self.UserPermissions; end;

(*----------------------------------------------------------------------------*)
procedure TIdFTPListItemGroupPermissions_W(Self: TIdFTPListItem; const T: string);
begin Self.GroupPermissions := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdFTPListItemGroupPermissions_R(Self: TIdFTPListItem; var T: string);
begin T := Self.GroupPermissions; end;

(*----------------------------------------------------------------------------*)
procedure TIdFTPListItemOwnerPermissions_W(Self: TIdFTPListItem; const T: string);
begin Self.OwnerPermissions := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdFTPListItemOwnerPermissions_R(Self: TIdFTPListItem; var T: string);
begin T := Self.OwnerPermissions; end;

(*----------------------------------------------------------------------------*)
procedure TIdFTPListItemData_W(Self: TIdFTPListItem; const T: string);
begin Self.Data := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdFTPListItemData_R(Self: TIdFTPListItem; var T: string);
begin T := Self.Data; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TIdFTPListItems(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TIdFTPListItems) do
  begin
    RegisterMethod(@TIdFTPListItems.Add, 'Add');
    RegisterVirtualMethod(@TIdFTPListItems.CheckListFormat, 'CheckListFormat');
    RegisterConstructor(@TIdFTPListItems.Create, 'Create');
    RegisterMethod(@TIdFTPListItems.IndexOf, 'IndexOf');
    RegisterMethod(@TIdFTPListItems.LoadList, 'LoadList');
    RegisterMethod(@TIdFTPListItems.Parse, 'Parse');
    RegisterMethod(@TIdFTPListItems.ParseUnknown, 'ParseUnknown');
    RegisterVirtualMethod(@TIdFTPListItems.ParseCustom, 'ParseCustom');
    RegisterPropertyHelper(@TIdFTPListItemsDirectoryName_R,@TIdFTPListItemsDirectoryName_W,'DirectoryName');
    RegisterPropertyHelper(@TIdFTPListItemsItems_R,@TIdFTPListItemsItems_W,'Items');
    RegisterPropertyHelper(@TIdFTPListItemsListFormat_R,@TIdFTPListItemsListFormat_W,'ListFormat');
    RegisterPropertyHelper(@TIdFTPListItemsOnGetCustomListFormat_R,@TIdFTPListItemsOnGetCustomListFormat_W,'OnGetCustomListFormat');
    RegisterPropertyHelper(@TIdFTPListItemsOnParseCustomListFormat_R,@TIdFTPListItemsOnParseCustomListFormat_W,'OnParseCustomListFormat');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TIdFTPListItem(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TIdFTPListItem) do begin
    RegisterMethod(@TIdFTPListItem.Assign, 'Assign');
    RegisterConstructor(@TIdFTPListItem.Create, 'Create');
    RegisterMethod(@TIdFTPListItem.Text, 'Text');
    RegisterPropertyHelper(@TIdFTPListItemData_R,@TIdFTPListItemData_W,'Data');
    RegisterPropertyHelper(@TIdFTPListItemOwnerPermissions_R,@TIdFTPListItemOwnerPermissions_W,'OwnerPermissions');
    RegisterPropertyHelper(@TIdFTPListItemGroupPermissions_R,@TIdFTPListItemGroupPermissions_W,'GroupPermissions');
    RegisterPropertyHelper(@TIdFTPListItemUserPermissions_R,@TIdFTPListItemUserPermissions_W,'UserPermissions');
    RegisterPropertyHelper(@TIdFTPListItemItemCount_R,@TIdFTPListItemItemCount_W,'ItemCount');
    RegisterPropertyHelper(@TIdFTPListItemOwnerName_R,@TIdFTPListItemOwnerName_W,'OwnerName');
    RegisterPropertyHelper(@TIdFTPListItemGroupName_R,@TIdFTPListItemGroupName_W,'GroupName');
    RegisterPropertyHelper(@TIdFTPListItemSize_R,@TIdFTPListItemSize_W,'Size');
    RegisterPropertyHelper(@TIdFTPListItemModifiedDate_R,@TIdFTPListItemModifiedDate_W,'ModifiedDate');
    RegisterPropertyHelper(@TIdFTPListItemFileName_R,@TIdFTPListItemFileName_W,'FileName');
    RegisterPropertyHelper(@TIdFTPListItemItemType_R,@TIdFTPListItemItemType_W,'ItemType');
    RegisterPropertyHelper(@TIdFTPListItemLinkedItemName_R,@TIdFTPListItemLinkedItemName_W,'LinkedItemName');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_IdFTPList(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(EIdInvalidFTPListingFormat) do
  with CL.Add(TIdFTPListItems) do
  RIRegister_TIdFTPListItem(CL);
  RIRegister_TIdFTPListItems(CL);
end;

 
 
{ TPSImport_IdFTPList }
(*----------------------------------------------------------------------------*)
procedure TPSImport_IdFTPList.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_IdFTPList(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_IdFTPList.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_IdFTPList(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
