unit uPSI_XCollection;
{
   XXCollect  add constructor 4.7.6.10 VIII
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
  TPSImport_XCollection = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TXCollection(CL: TPSPascalCompiler);
procedure SIRegister_TXCollectionItem(CL: TPSPascalCompiler);
procedure SIRegister_EFilerException(CL: TPSPascalCompiler);
procedure SIRegister_XCollection(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_XCollection_Routines(S: TPSExec);
procedure RIRegister_TXCollection(CL: TPSRuntimeClassImporter);
procedure RIRegister_TXCollectionItem(CL: TPSRuntimeClassImporter);
procedure RIRegister_EFilerException(CL: TPSRuntimeClassImporter);
procedure RIRegister_XCollection(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   XCollection
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_XCollection]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TXCollection(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TPersistent', 'TXCollection') do
  with CL.AddClassN(CL.FindClass('TPersistent'),'TXCollection') do begin
    RegisterMethod('Constructor Create( aOwner : TPersistent)');
            RegisterMethod('Procedure Free');
     RegisterMethod('Procedure Loaded');
    RegisterProperty('Owner', 'TPersistent', iptrw);
    RegisterMethod('Function ItemsClass : TXCollectionItemClass');
    RegisterProperty('Items', 'TXCollectionItem Integer', iptr);
    SetDefaultPropery('Items');
    RegisterProperty('Count', 'Integer', iptr);
    RegisterMethod('Function Add( anItem : TXCollectionItem) : Integer');
    RegisterMethod('Function GetOrCreate( anItem : TXCollectionItemClass) : TXCollectionItem');
    RegisterMethod('Procedure Delete( index : Integer)');
    RegisterMethod('Procedure Remove( anItem : TXCollectionItem)');
    RegisterMethod('Procedure Clear');
     RegisterMethod('procedure Assign(Source: TPersistent);');
    RegisterMethod('Function IndexOf( anItem : TXCollectionItem) : Integer');
    RegisterMethod('Function IndexOfClass( aClass : TXCollectionItemClass) : Integer');
    RegisterMethod('Function GetByClass( aClass : TXCollectionItemClass) : TXCollectionItem');
    RegisterMethod('Function IndexOfName( const aName : String) : Integer');
    RegisterMethod('Function CanAdd( aClass : TXCollectionItemClass) : Boolean');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TXCollectionItem(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TPersistent', 'TXCollectionItem') do
  with CL.AddClassN(CL.FindClass('TPersistent'),'TXCollectionItem') do begin
    RegisterMethod('Constructor Create( aOwner : TXCollection)');
            RegisterMethod('Procedure Free');
      RegisterProperty('Owner', 'TXCollection', iptr);
    RegisterMethod('function GetNamePath : String;');// override;
    RegisterMethod('Procedure MoveUp');
    RegisterMethod('Procedure MoveDown');
    RegisterMethod('procedure Assign(Source: TPersistent);');
    RegisterMethod('Function Index : Integer');
    RegisterMethod('Function FriendlyName : String');
    RegisterMethod('Function FriendlyDescription : String');
    RegisterMethod('Function ItemCategory : String');
    RegisterMethod('Function UniqueItem : Boolean');
    RegisterMethod('Function CanAddTo( collection : TXCollection) : Boolean');
    RegisterProperty('Name', 'String', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_EFilerException(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'Exception', 'EFilerException') do
  with CL.AddClassN(CL.FindClass('Exception'),'EFilerException') do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_XCollection(CL: TPSPascalCompiler);
begin
  CL.AddClassN(CL.FindClass('TOBJECT'),'TXCollection');
  SIRegister_EFilerException(CL);
  SIRegister_TXCollectionItem(CL);
  //CL.AddTypeS('TXCollectionItemClass', 'class of TXCollectionItem');
  SIRegister_TXCollection(CL);
 CL.AddDelphiFunction('Procedure RegisterXCollectionDestroyEvent( notifyEvent : TNotifyEvent)');
 CL.AddDelphiFunction('Procedure DeRegisterXCollectionDestroyEvent( notifyEvent : TNotifyEvent)');
 //CL.AddDelphiFunction('Procedure RegisterXCollectionItemClass( aClass : TXCollectionItemClass)');
 //CL.AddDelphiFunction('Procedure UnregisterXCollectionItemClass( aClass : TXCollectionItemClass)');
 //CL.AddDelphiFunction('Function FindXCollectionItemClass( const className : String) : TXCollectionItemClass');
 //CL.AddDelphiFunction('Function GetXCollectionItemClassesList( baseClass : TXCollectionItemClass) : TList');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TXCollectionCount_R(Self: TXCollection; var T: Integer);
begin T := Self.Count; end;

(*----------------------------------------------------------------------------*)
procedure TXCollectionItems_R(Self: TXCollection; var T: TXCollectionItem; const t1: Integer);
begin T := Self.Items[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TXCollectionOwner_W(Self: TXCollection; const T: TPersistent);
begin Self.Owner := T; end;

(*----------------------------------------------------------------------------*)
procedure TXCollectionOwner_R(Self: TXCollection; var T: TPersistent);
begin T := Self.Owner; end;

(*----------------------------------------------------------------------------*)
procedure TXCollectionItemName_W(Self: TXCollectionItem; const T: String);
begin Self.Name := T; end;

(*----------------------------------------------------------------------------*)
procedure TXCollectionItemName_R(Self: TXCollectionItem; var T: String);
begin T := Self.Name; end;

(*----------------------------------------------------------------------------*)
procedure TXCollectionItemOwner_R(Self: TXCollectionItem; var T: TXCollection);
begin T := Self.Owner; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_XCollection_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@RegisterXCollectionDestroyEvent, 'RegisterXCollectionDestroyEvent', cdRegister);
 S.RegisterDelphiFunction(@DeRegisterXCollectionDestroyEvent, 'DeRegisterXCollectionDestroyEvent', cdRegister);
 //S.RegisterDelphiFunction(@RegisterXCollectionItemClass, 'RegisterXCollectionItemClass', cdRegister);
 //S.RegisterDelphiFunction(@UnregisterXCollectionItemClass, 'UnregisterXCollectionItemClass', cdRegister);
 //S.RegisterDelphiFunction(@FindXCollectionItemClass, 'FindXCollectionItemClass', cdRegister);
 //S.RegisterDelphiFunction(@GetXCollectionItemClassesList, 'GetXCollectionItemClassesList', cdRegister);
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TXCollection(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TXCollection) do begin
    //RegisterVirtualConstructor(@TXCollection.Create, 'Create');
     RegisterConstructor(@TXCollection.Create, 'Create');
      RegisterMethod(@TXCollection.Destroy, 'Free');
      RegisterMethod(@TXCollection.Loaded, 'Loaded');
    RegisterPropertyHelper(@TXCollectionOwner_R,@TXCollectionOwner_W,'Owner');
    RegisterVirtualMethod(@TXCollection.ItemsClass, 'ItemsClass');
    RegisterPropertyHelper(@TXCollectionItems_R,nil,'Items');
    RegisterPropertyHelper(@TXCollectionCount_R,nil,'Count');
    RegisterMethod(@TXCollection.Add, 'Add');
    RegisterMethod(@TXCollection.Assign, 'Assign');
    RegisterMethod(@TXCollection.GetOrCreate, 'GetOrCreate');
    RegisterMethod(@TXCollection.Delete, 'Delete');
    RegisterMethod(@TXCollection.Remove, 'Remove');
    RegisterMethod(@TXCollection.Clear, 'Clear');
    RegisterMethod(@TXCollection.IndexOf, 'IndexOf');
    RegisterMethod(@TXCollection.IndexOfClass, 'IndexOfClass');
    RegisterMethod(@TXCollection.GetByClass, 'GetByClass');
    RegisterMethod(@TXCollection.IndexOfName, 'IndexOfName');
    RegisterVirtualMethod(@TXCollection.CanAdd, 'CanAdd');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TXCollectionItem(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TXCollectionItem) do begin
    RegisterConstructor(@TXCollectionItem.Create, 'Create');
      RegisterMethod(@TXCollectionItem.Destroy, 'Free');
      RegisterPropertyHelper(@TXCollectionItemOwner_R,nil,'Owner');
    RegisterMethod(@TXCollectionItem.MoveUp, 'MoveUp');
    RegisterMethod(@TXCollectionItem.MoveDown, 'MoveDown');
    RegisterMethod(@TXCollectionItem.Index, 'Index');
    RegisterMethod(@TXCollection.Assign, 'Assign');
    RegisterMethod(@TXCollection.GetNamePath, 'GetNamePath');
    //RegisterVirtualAbstractMethod(@TXCollectionItem, @!.FriendlyName, 'FriendlyName');
    RegisterVirtualMethod(@TXCollectionItem.FriendlyDescription, 'FriendlyDescription');
    RegisterVirtualMethod(@TXCollectionItem.ItemCategory, 'ItemCategory');
    RegisterVirtualMethod(@TXCollectionItem.UniqueItem, 'UniqueItem');
    RegisterVirtualMethod(@TXCollectionItem.CanAddTo, 'CanAddTo');
    RegisterPropertyHelper(@TXCollectionItemName_R,@TXCollectionItemName_W,'Name');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_EFilerException(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(EFilerException) do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_XCollection(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TXCollection) do
  RIRegister_EFilerException(CL);
  RIRegister_TXCollectionItem(CL);
  RIRegister_TXCollection(CL);
end;

 
 
{ TPSImport_XCollection }
(*----------------------------------------------------------------------------*)
procedure TPSImport_XCollection.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_XCollection(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_XCollection.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_XCollection(ri);
  RIRegister_XCollection_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
