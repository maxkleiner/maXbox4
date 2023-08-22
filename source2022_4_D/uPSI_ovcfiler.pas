unit uPSI_ovcfiler;
{
  another filer
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
  TPSImport_ovcfiler = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TOvcDataFiler(CL: TPSPascalCompiler);
procedure SIRegister_TOvcPropertyList(CL: TPSPascalCompiler);
procedure SIRegister_TOvcAbstractStore(CL: TPSPascalCompiler);
procedure SIRegister_ovcfiler(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_ovcfiler_Routines(S: TPSExec);
procedure RIRegister_TOvcDataFiler(CL: TPSRuntimeClassImporter);
procedure RIRegister_TOvcPropertyList(CL: TPSRuntimeClassImporter);
procedure RIRegister_TOvcAbstractStore(CL: TPSRuntimeClassImporter);
procedure RIRegister_ovcfiler(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   Graphics
  ,Controls
  ,Forms
  ,TypInfo
  ,OvcBase
  ,OvcMisc
  ,ovcfiler
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_ovcfiler]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TOvcDataFiler(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TObject', 'TOvcDataFiler') do
  with CL.AddClassN(CL.FindClass('TObject'),'TOvcDataFiler') do begin
    RegisterMethod('Procedure LoadObjectsProps( AForm : TWinControl; StoredList : TStrings)');
    RegisterMethod('Procedure LoadObjectsProps( AForm : TCustomForm; StoredList : TStrings)');
    RegisterMethod('Procedure LoadProperty( PropInfo : PExPropInfo)');
    RegisterMethod('Procedure LoadAllProperties( AObject : TObject)');
    RegisterMethod('Procedure StoreObjectsProps( AForm : TWinControl; StoredList : TStrings)');
    RegisterMethod('Procedure StoreObjectsProps( AForm : TCustomForm; StoredList : TStrings)');
    RegisterMethod('Procedure StoreProperty( PropInfo : PExPropInfo)');
    RegisterMethod('Procedure StoreAllProperties( AObject : TObject)');
    RegisterProperty('Prefix', 'string', iptrw);
    RegisterProperty('Section', 'string', iptrw);
    RegisterProperty('Storage', 'TOvcAbstractStore', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TOvcPropertyList(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TObject', 'TOvcPropertyList') do
  with CL.AddClassN(CL.FindClass('TObject'),'TOvcPropertyList') do begin
    RegisterMethod('Constructor Create( AObject : TObject; Filter : TTypeKinds; const Prefix : string)');
    RegisterMethod('Function Contains( P : PExPropInfo) : Boolean');
    RegisterMethod('Function Find( const AName : string) : PExPropInfo');
    RegisterMethod('Procedure Delete( Index : Integer)');
    RegisterMethod('Procedure Intersect( List : TOvcPropertyList)');
    RegisterProperty('Count', 'Integer', iptr);
    //RegisterProperty('Items', 'PExPropInfo Integer', iptr);
    //SetDefaultPropery('Items');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TOvcAbstractStore(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOvcComponent', 'TOvcAbstractStore') do
  with CL.AddClassN(CL.FindClass('TOvcComponent'),'TOvcAbstractStore') do begin
    RegisterMethod('Procedure Open');
    RegisterMethod('Procedure Close');
    RegisterMethod('Function ReadString( const Section, Item, DefaultValue : string) : string');
    RegisterMethod('Procedure WriteString( const Section, Item, Value : string)');
    RegisterMethod('Procedure EraseSection( const Section : string)');
    RegisterMethod('Function ReadBoolean( const Section, Item : string; DefaultValue : Boolean) : Boolean');
    RegisterMethod('Function ReadInteger( const Section, Item : string; DefaultValue : Integer) : Integer');
    RegisterMethod('Procedure WriteBoolean( const Section, Item : string; Value : Boolean)');
    RegisterMethod('Procedure WriteInteger( const Section, Item : string; Value : Integer)');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_ovcfiler(CL: TPSPascalCompiler);
begin
  SIRegister_TOvcAbstractStore(CL);
  //CL.AddTypeS('PExPropInfo', '^TExPropInfo // will not work');
//  CL.AddTypeS('TExPropInfo', 'record PI : TPropInfo; AObject : TObject; end');
  SIRegister_TOvcPropertyList(CL);
  SIRegister_TOvcDataFiler(CL);
 CL.AddDelphiFunction('Procedure UpdateStoredList( AForm : TWinControl; AStoredList : TStrings; FromForm : Boolean)');
 CL.AddDelphiFunction('Procedure UpdateStoredList1( AForm : TCustomForm; AStoredList : TStrings; FromForm : Boolean)');
 CL.AddDelphiFunction('Function CreateStoredItem( const CompName, PropName : string) : string');
 CL.AddDelphiFunction('Function ParseStoredItem( const Item : string; var CompName, PropName : string) : Boolean');
 //CL.AddDelphiFunction('Function GetPropType( PropInfo : PExPropInfo) : PTypeInfo');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TOvcDataFilerStorage_W(Self: TOvcDataFiler; const T: TOvcAbstractStore);
begin Self.Storage := T; end;

(*----------------------------------------------------------------------------*)
procedure TOvcDataFilerStorage_R(Self: TOvcDataFiler; var T: TOvcAbstractStore);
begin T := Self.Storage; end;

(*----------------------------------------------------------------------------*)
procedure TOvcDataFilerSection_W(Self: TOvcDataFiler; const T: string);
begin Self.Section := T; end;

(*----------------------------------------------------------------------------*)
procedure TOvcDataFilerSection_R(Self: TOvcDataFiler; var T: string);
begin T := Self.Section; end;

(*----------------------------------------------------------------------------*)
procedure TOvcDataFilerPrefix_W(Self: TOvcDataFiler; const T: string);
begin Self.Prefix := T; end;

(*----------------------------------------------------------------------------*)
procedure TOvcDataFilerPrefix_R(Self: TOvcDataFiler; var T: string);
begin T := Self.Prefix; end;

(*----------------------------------------------------------------------------*)
procedure TOvcPropertyListItems_R(Self: TOvcPropertyList; var T: PExPropInfo; const t1: Integer);
begin T := Self.Items[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TOvcPropertyListCount_R(Self: TOvcPropertyList; var T: Integer);
begin T := Self.Count; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_ovcfiler_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@UpdateStoredList, 'UpdateStoredList', cdRegister);
 S.RegisterDelphiFunction(@UpdateStoredList, 'UpdateStoredList1', cdRegister);
 S.RegisterDelphiFunction(@CreateStoredItem, 'CreateStoredItem', cdRegister);
 S.RegisterDelphiFunction(@ParseStoredItem, 'ParseStoredItem', cdRegister);
 S.RegisterDelphiFunction(@GetPropType, 'GetPropType', cdRegister);
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TOvcDataFiler(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TOvcDataFiler) do begin
    RegisterMethod(@TOvcDataFiler.LoadObjectsProps, 'LoadObjectsProps');
    RegisterMethod(@TOvcDataFiler.LoadObjectsProps, 'LoadObjectsProps');
    RegisterMethod(@TOvcDataFiler.LoadProperty, 'LoadProperty');
    RegisterMethod(@TOvcDataFiler.LoadAllProperties, 'LoadAllProperties');
    RegisterMethod(@TOvcDataFiler.StoreObjectsProps, 'StoreObjectsProps');
    RegisterMethod(@TOvcDataFiler.StoreObjectsProps, 'StoreObjectsProps');
    RegisterMethod(@TOvcDataFiler.StoreProperty, 'StoreProperty');
    RegisterMethod(@TOvcDataFiler.StoreAllProperties, 'StoreAllProperties');
    RegisterPropertyHelper(@TOvcDataFilerPrefix_R,@TOvcDataFilerPrefix_W,'Prefix');
    RegisterPropertyHelper(@TOvcDataFilerSection_R,@TOvcDataFilerSection_W,'Section');
    RegisterPropertyHelper(@TOvcDataFilerStorage_R,@TOvcDataFilerStorage_W,'Storage');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TOvcPropertyList(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TOvcPropertyList) do
  begin
    RegisterConstructor(@TOvcPropertyList.Create, 'Create');
    RegisterMethod(@TOvcPropertyList.Contains, 'Contains');
    RegisterMethod(@TOvcPropertyList.Find, 'Find');
    RegisterMethod(@TOvcPropertyList.Delete, 'Delete');
    RegisterMethod(@TOvcPropertyList.Intersect, 'Intersect');
    RegisterPropertyHelper(@TOvcPropertyListCount_R,nil,'Count');
    RegisterPropertyHelper(@TOvcPropertyListItems_R,nil,'Items');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TOvcAbstractStore(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TOvcAbstractStore) do begin
    RegisterMethod(@TOvcAbstractStore.Open, 'Open');
    RegisterMethod(@TOvcAbstractStore.Close, 'Close');
    //RegisterVirtualAbstractMethod(@TOvcAbstractStore, @!.ReadString, 'ReadString');
    //RegisterVirtualAbstractMethod(@TOvcAbstractStore, @!.WriteString, 'WriteString');
    RegisterVirtualMethod(@TOvcAbstractStore.EraseSection, 'EraseSection');
    RegisterMethod(@TOvcAbstractStore.ReadBoolean, 'ReadBoolean');
    RegisterMethod(@TOvcAbstractStore.ReadInteger, 'ReadInteger');
    RegisterMethod(@TOvcAbstractStore.WriteBoolean, 'WriteBoolean');
    RegisterMethod(@TOvcAbstractStore.WriteInteger, 'WriteInteger');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_ovcfiler(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TOvcAbstractStore(CL);
  RIRegister_TOvcPropertyList(CL);
  RIRegister_TOvcDataFiler(CL);
end;

 
 
{ TPSImport_ovcfiler }
(*----------------------------------------------------------------------------*)
procedure TPSImport_ovcfiler.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_ovcfiler(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_ovcfiler.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_ovcfiler(ri);
  RIRegister_ovcfiler_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
