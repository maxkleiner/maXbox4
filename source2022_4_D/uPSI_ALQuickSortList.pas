unit uPSI_ALQuickSortList;
{
   al qs
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
  TPSImport_ALQuickSortList = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;


{ compile-time registration functions }
procedure SIRegister_TALInt64AVLList(CL: TPSPascalCompiler);
procedure SIRegister_TALAVLInt64ListBinaryTreeNode(CL: TPSPascalCompiler);
procedure SIRegister_TALBaseAVLList(CL: TPSPascalCompiler);
procedure SIRegister_TALDoubleList(CL: TPSPascalCompiler);
procedure SIRegister_TALInt64List(CL: TPSPascalCompiler);
procedure SIRegister_TALCardinalList(CL: TPSPascalCompiler);
procedure SIRegister_TALIntegerList(CL: TPSPascalCompiler);
procedure SIRegister_TALBaseQuickSortList(CL: TPSPascalCompiler);
procedure SIRegister_ALQuickSortList(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TALInt64AVLList(CL: TPSRuntimeClassImporter);
procedure RIRegister_TALAVLInt64ListBinaryTreeNode(CL: TPSRuntimeClassImporter);
procedure RIRegister_TALBaseAVLList(CL: TPSRuntimeClassImporter);
procedure RIRegister_TALDoubleList(CL: TPSRuntimeClassImporter);
procedure RIRegister_TALInt64List(CL: TPSRuntimeClassImporter);
procedure RIRegister_TALCardinalList(CL: TPSRuntimeClassImporter);
procedure RIRegister_TALIntegerList(CL: TPSRuntimeClassImporter);
procedure RIRegister_TALBaseQuickSortList(CL: TPSRuntimeClassImporter);
procedure RIRegister_ALQuickSortList(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   ALAVLBinaryTree
  ,ALQuickSortList
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_ALQuickSortList]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TALInt64AVLList(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TALBaseAVLList', 'TALInt64AVLList') do
  with CL.AddClassN(CL.FindClass('TALBaseAVLList'),'TALInt64AVLList') do begin
    RegisterMethod('Constructor Create');
    RegisterMethod('Procedure Clear');
    RegisterMethod('Procedure Delete( Index : Integer)');
    RegisterMethod('Function IndexOf( Item : Int64) : Integer');
    RegisterMethod('Function IndexOfObject( AObject : TObject) : Integer');
    RegisterMethod('Function Add( const Item : Int64) : Integer');
    RegisterMethod('Function AddObject( const Item : Int64; AObject : TObject) : Integer');
    RegisterMethod('Function Find( item : Int64; var Index : Integer) : Boolean');
    RegisterProperty('Items', 'Int64 Integer', iptr);
    SetDefaultPropery('Items');
    RegisterProperty('Objects', 'TObject Integer', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TALAVLInt64ListBinaryTreeNode(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TALInt64KeyAVLBinaryTreeNode', 'TALAVLInt64ListBinaryTreeNode') do
  with CL.AddClassN(CL.FindClass('TALInt64KeyAVLBinaryTreeNode'),'TALAVLInt64ListBinaryTreeNode') do
  begin
    RegisterProperty('Obj', 'Tobject', iptrw);
    RegisterProperty('Idx', 'integer', iptrw);
    RegisterMethod('Constructor Create');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TALBaseAVLList(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TObject', 'TALBaseAVLList') do
  with CL.AddClassN(CL.FindClass('TObject'),'TALBaseAVLList') do begin
    RegisterMethod('Constructor Create');
    RegisterMethod('Procedure Clear');
    RegisterMethod('Procedure Delete( Index : Integer)');
    RegisterMethod('Procedure Error2( const Msg : string; Data : NativeInt);');
    RegisterMethod('Procedure Error3( Msg : PResStringRec; Data : NativeInt);');
    RegisterMethod('Function Expand : TALBaseAVLList');
    RegisterProperty('Capacity', 'Integer', iptrw);
    RegisterProperty('Count', 'Integer', iptrw);
    RegisterProperty('Duplicates', 'TDuplicates', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TALDoubleList(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TALBaseQuickSortList', 'TALDoubleList') do
  with CL.AddClassN(CL.FindClass('TALBaseQuickSortList'),'TALDoubleList') do
  begin
    RegisterMethod('Function IndexOf( Item : Double) : Integer');
    RegisterMethod('Function IndexOfObject( AObject : TObject) : Integer');
    RegisterMethod('Function Add( const Item : Double) : Integer');
    RegisterMethod('Function AddObject( const Item : Double; AObject : TObject) : Integer');
    RegisterMethod('Function Find( item : Double; var Index : Integer) : Boolean');
    RegisterMethod('Procedure Insert( Index : Integer; const item : Double)');
    RegisterMethod('Procedure InsertObject( Index : Integer; const item : Double; AObject : TObject)');
    RegisterProperty('Items', 'Double Integer', iptrw);
    SetDefaultPropery('Items');
    RegisterProperty('Objects', 'TObject Integer', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TALInt64List(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TALBaseQuickSortList', 'TALInt64List') do
  with CL.AddClassN(CL.FindClass('TALBaseQuickSortList'),'TALInt64List') do
  begin
    RegisterMethod('Function IndexOf( Item : Int64) : Integer');
    RegisterMethod('Function IndexOfObject( AObject : TObject) : Integer');
    RegisterMethod('Function Add( const Item : Int64) : Integer');
    RegisterMethod('Function AddObject( const Item : Int64; AObject : TObject) : Integer');
    RegisterMethod('Function Find( item : Int64; var Index : Integer) : Boolean');
    RegisterMethod('Procedure Insert( Index : Integer; const item : Int64)');
    RegisterMethod('Procedure InsertObject( Index : Integer; const item : Int64; AObject : TObject)');
    RegisterProperty('Items', 'Int64 Integer', iptrw);
    SetDefaultPropery('Items');
    RegisterProperty('Objects', 'TObject Integer', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TALCardinalList(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TALBaseQuickSortList', 'TALCardinalList') do
  with CL.AddClassN(CL.FindClass('TALBaseQuickSortList'),'TALCardinalList') do
  begin
    RegisterMethod('Function IndexOf( Item : Cardinal) : Integer');
    RegisterMethod('Function IndexOfObject( AObject : TObject) : Integer');
    RegisterMethod('Function Add( const Item : Cardinal) : Integer');
    RegisterMethod('Function AddObject( const Item : Cardinal; AObject : TObject) : Integer');
    RegisterMethod('Function Find( item : Cardinal; var Index : Integer) : Boolean');
    RegisterMethod('Procedure Insert( Index : Integer; const item : Cardinal)');
    RegisterMethod('Procedure InsertObject( Index : Integer; const item : Cardinal; AObject : TObject)');
    RegisterProperty('Items', 'Cardinal Integer', iptrw);
    SetDefaultPropery('Items');
    RegisterProperty('Objects', 'TObject Integer', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TALIntegerList(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TALBaseQuickSortList', 'TALIntegerList') do
  with CL.AddClassN(CL.FindClass('TALBaseQuickSortList'),'TALIntegerList') do
  begin
    RegisterMethod('Function IndexOf( Item : Integer) : Integer');
    RegisterMethod('Function IndexOfObject( AObject : TObject) : Integer');
    RegisterMethod('Function Add( const Item : integer) : Integer');
    RegisterMethod('Function AddObject( const Item : integer; AObject : TObject) : Integer');
    RegisterMethod('Function Find( item : Integer; var Index : Integer) : Boolean');
    RegisterMethod('Procedure Insert( Index : Integer; const item : integer)');
    RegisterMethod('Procedure InsertObject( Index : Integer; const item : integer; AObject : TObject)');
    RegisterProperty('Items', 'Integer Integer', iptrw);
    SetDefaultPropery('Items');
    RegisterProperty('Objects', 'TObject Integer', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TALBaseQuickSortList(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TObject', 'TALBaseQuickSortList') do
  with CL.AddClassN(CL.FindClass('TObject'),'TALBaseQuickSortList') do
  begin
    RegisterMethod('Constructor Create');
    RegisterMethod('Procedure Clear');
    RegisterMethod('Procedure Delete( Index : Integer)');
    RegisterMethod('Procedure Error( const Msg : string; Data : NativeInt);');
    RegisterMethod('Procedure Error1( Msg : PResStringRec; Data : NativeInt);');
    RegisterMethod('Procedure Exchange( Index1, Index2 : Integer)');
    RegisterMethod('Function Expand : TALBaseQuickSortList');
    RegisterMethod('Procedure CustomSort( Compare : TALQuickSortListCompare)');
    RegisterMethod('Procedure Sort');
    RegisterProperty('Sorted', 'Boolean', iptrw);
    RegisterProperty('Capacity', 'Integer', iptrw);
    RegisterProperty('Count', 'Integer', iptrw);
    RegisterProperty('Duplicates', 'TDuplicates', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_ALQuickSortList(CL: TPSPascalCompiler);
begin
  CL.AddTypeS('NativeInt', 'Integer');
  CL.AddTypeS('NativeUInt', 'Cardinal');
  CL.AddTypeS('TALQuickSortPointerList', 'array of ___Pointer');
  SIRegister_TALBaseQuickSortList(CL);
  //CL.AddTypeS('PALIntegerListItem', '^TALIntegerListItem // will not work');
  CL.AddTypeS('TALIntegerListItem', 'record FInteger : integer; FObject : TObject; end');
  SIRegister_TALIntegerList(CL);
  //CL.AddTypeS('PALCardinalListItem', '^TALCardinalListItem // will not work');
  CL.AddTypeS('TALCardinalListItem', 'record FCardinal : Cardinal; FObject : TObject; end');
  SIRegister_TALCardinalList(CL);
  //CL.AddTypeS('PALInt64ListItem', '^TALInt64ListItem // will not work');
  CL.AddTypeS('TALInt64ListItem', 'record FInt64 : Int64; FObject : TObject; end');
  SIRegister_TALInt64List(CL);
  //CL.AddTypeS('PALDoubleListItem', '^TALDoubleListItem // will not work');
  CL.AddTypeS('TALDoubleListItem', 'record FDouble : Double; FObject : TObject; end');
  SIRegister_TALDoubleList(CL);
  SIRegister_TALBaseAVLList(CL);
  SIRegister_TALAVLInt64ListBinaryTreeNode(CL);
  SIRegister_TALInt64AVLList(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TALInt64AVLListObjects_W(Self: TALInt64AVLList; const T: TObject; const t1: Integer);
begin Self.Objects[t1] := T; end;

(*----------------------------------------------------------------------------*)
procedure TALInt64AVLListObjects_R(Self: TALInt64AVLList; var T: TObject; const t1: Integer);
begin T := Self.Objects[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TALInt64AVLListItems_R(Self: TALInt64AVLList; var T: Int64; const t1: Integer);
begin T := Self.Items[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TALAVLInt64ListBinaryTreeNodeIdx_W(Self: TALAVLInt64ListBinaryTreeNode; const T: integer);
Begin Self.Idx := T; end;

(*----------------------------------------------------------------------------*)
procedure TALAVLInt64ListBinaryTreeNodeIdx_R(Self: TALAVLInt64ListBinaryTreeNode; var T: integer);
Begin T := Self.Idx; end;

(*----------------------------------------------------------------------------*)
procedure TALAVLInt64ListBinaryTreeNodeObj_W(Self: TALAVLInt64ListBinaryTreeNode; const T: Tobject);
Begin Self.Obj := T; end;

(*----------------------------------------------------------------------------*)
procedure TALAVLInt64ListBinaryTreeNodeObj_R(Self: TALAVLInt64ListBinaryTreeNode; var T: Tobject);
Begin T := Self.Obj; end;

(*----------------------------------------------------------------------------*)
procedure TALBaseAVLListDuplicates_W(Self: TALBaseAVLList; const T: TDuplicates);
begin Self.Duplicates := T; end;

(*----------------------------------------------------------------------------*)
procedure TALBaseAVLListDuplicates_R(Self: TALBaseAVLList; var T: TDuplicates);
begin T := Self.Duplicates; end;

(*----------------------------------------------------------------------------*)
procedure TALBaseAVLListCount_W(Self: TALBaseAVLList; const T: Integer);
begin Self.Count := T; end;

(*----------------------------------------------------------------------------*)
procedure TALBaseAVLListCount_R(Self: TALBaseAVLList; var T: Integer);
begin T := Self.Count; end;

(*----------------------------------------------------------------------------*)
procedure TALBaseAVLListCapacity_W(Self: TALBaseAVLList; const T: Integer);
begin Self.Capacity := T; end;

(*----------------------------------------------------------------------------*)
procedure TALBaseAVLListCapacity_R(Self: TALBaseAVLList; var T: Integer);
begin T := Self.Capacity; end;

(*----------------------------------------------------------------------------*)
Procedure TALBaseAVLListError3_P(Self: TALBaseAVLList;  Msg : PResStringRec; Data : NativeInt);
Begin Self.Error(Msg, Data); END;

(*----------------------------------------------------------------------------*)
Procedure TALBaseAVLListError2_P(Self: TALBaseAVLList;  const Msg : string; Data : NativeInt);
Begin Self.Error(Msg, Data); END;

(*----------------------------------------------------------------------------*)
procedure TALDoubleListObjects_W(Self: TALDoubleList; const T: TObject; const t1: Integer);
begin Self.Objects[t1] := T; end;

(*----------------------------------------------------------------------------*)
procedure TALDoubleListObjects_R(Self: TALDoubleList; var T: TObject; const t1: Integer);
begin T := Self.Objects[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TALDoubleListItems_W(Self: TALDoubleList; const T: Double; const t1: Integer);
begin Self.Items[t1] := T; end;

(*----------------------------------------------------------------------------*)
procedure TALDoubleListItems_R(Self: TALDoubleList; var T: Double; const t1: Integer);
begin T := Self.Items[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TALInt64ListObjects_W(Self: TALInt64List; const T: TObject; const t1: Integer);
begin Self.Objects[t1] := T; end;

(*----------------------------------------------------------------------------*)
procedure TALInt64ListObjects_R(Self: TALInt64List; var T: TObject; const t1: Integer);
begin T := Self.Objects[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TALInt64ListItems_W(Self: TALInt64List; const T: Int64; const t1: Integer);
begin Self.Items[t1] := T; end;

(*----------------------------------------------------------------------------*)
procedure TALInt64ListItems_R(Self: TALInt64List; var T: Int64; const t1: Integer);
begin T := Self.Items[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TALCardinalListObjects_W(Self: TALCardinalList; const T: TObject; const t1: Integer);
begin Self.Objects[t1] := T; end;

(*----------------------------------------------------------------------------*)
procedure TALCardinalListObjects_R(Self: TALCardinalList; var T: TObject; const t1: Integer);
begin T := Self.Objects[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TALCardinalListItems_W(Self: TALCardinalList; const T: Cardinal; const t1: Integer);
begin Self.Items[t1] := T; end;

(*----------------------------------------------------------------------------*)
procedure TALCardinalListItems_R(Self: TALCardinalList; var T: Cardinal; const t1: Integer);
begin T := Self.Items[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TALIntegerListObjects_W(Self: TALIntegerList; const T: TObject; const t1: Integer);
begin Self.Objects[t1] := T; end;

(*----------------------------------------------------------------------------*)
procedure TALIntegerListObjects_R(Self: TALIntegerList; var T: TObject; const t1: Integer);
begin T := Self.Objects[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TALIntegerListItems_W(Self: TALIntegerList; const T: Integer; const t1: Integer);
begin Self.Items[t1] := T; end;

(*----------------------------------------------------------------------------*)
procedure TALIntegerListItems_R(Self: TALIntegerList; var T: Integer; const t1: Integer);
begin T := Self.Items[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TALBaseQuickSortListDuplicates_W(Self: TALBaseQuickSortList; const T: TDuplicates);
begin Self.Duplicates := T; end;

(*----------------------------------------------------------------------------*)
procedure TALBaseQuickSortListDuplicates_R(Self: TALBaseQuickSortList; var T: TDuplicates);
begin T := Self.Duplicates; end;

(*----------------------------------------------------------------------------*)
procedure TALBaseQuickSortListCount_W(Self: TALBaseQuickSortList; const T: Integer);
begin Self.Count := T; end;

(*----------------------------------------------------------------------------*)
procedure TALBaseQuickSortListCount_R(Self: TALBaseQuickSortList; var T: Integer);
begin T := Self.Count; end;

(*----------------------------------------------------------------------------*)
procedure TALBaseQuickSortListCapacity_W(Self: TALBaseQuickSortList; const T: Integer);
begin Self.Capacity := T; end;

(*----------------------------------------------------------------------------*)
procedure TALBaseQuickSortListCapacity_R(Self: TALBaseQuickSortList; var T: Integer);
begin T := Self.Capacity; end;

(*----------------------------------------------------------------------------*)
procedure TALBaseQuickSortListSorted_W(Self: TALBaseQuickSortList; const T: Boolean);
begin Self.Sorted := T; end;

(*----------------------------------------------------------------------------*)
procedure TALBaseQuickSortListSorted_R(Self: TALBaseQuickSortList; var T: Boolean);
begin T := Self.Sorted; end;

(*----------------------------------------------------------------------------*)
Procedure TALBaseQuickSortListError1_P(Self: TALBaseQuickSortList;  Msg : PResStringRec; Data : NativeInt);
Begin Self.Error(Msg, Data); END;

(*----------------------------------------------------------------------------*)
Procedure TALBaseQuickSortListError_P(Self: TALBaseQuickSortList;  const Msg : string; Data : NativeInt);
Begin Self.Error(Msg, Data); END;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TALInt64AVLList(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TALInt64AVLList) do
  begin
    RegisterConstructor(@TALInt64AVLList.Create, 'Create');
    RegisterMethod(@TALInt64AVLList.Clear, 'Clear');
    RegisterMethod(@TALInt64AVLList.Delete, 'Delete');
    RegisterMethod(@TALInt64AVLList.IndexOf, 'IndexOf');
    RegisterMethod(@TALInt64AVLList.IndexOfObject, 'IndexOfObject');
    RegisterMethod(@TALInt64AVLList.Add, 'Add');
    RegisterMethod(@TALInt64AVLList.AddObject, 'AddObject');
    RegisterMethod(@TALInt64AVLList.Find, 'Find');
    RegisterPropertyHelper(@TALInt64AVLListItems_R,nil,'Items');
    RegisterPropertyHelper(@TALInt64AVLListObjects_R,@TALInt64AVLListObjects_W,'Objects');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TALAVLInt64ListBinaryTreeNode(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TALAVLInt64ListBinaryTreeNode) do
  begin
    RegisterPropertyHelper(@TALAVLInt64ListBinaryTreeNodeObj_R,@TALAVLInt64ListBinaryTreeNodeObj_W,'Obj');
    RegisterPropertyHelper(@TALAVLInt64ListBinaryTreeNodeIdx_R,@TALAVLInt64ListBinaryTreeNodeIdx_W,'Idx');
    RegisterConstructor(@TALAVLInt64ListBinaryTreeNode.Create, 'Create');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TALBaseAVLList(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TALBaseAVLList) do
  begin
    RegisterVirtualConstructor(@TALBaseAVLList.Create, 'Create');
    RegisterVirtualMethod(@TALBaseAVLList.Clear, 'Clear');
    RegisterMethod(@TALBaseAVLList.Delete, 'Delete');
    RegisterVirtualMethod(@TALBaseAVLListError2_P, 'Error2');
    RegisterMethod(@TALBaseAVLListError3_P, 'Error3');
    RegisterMethod(@TALBaseAVLList.Expand, 'Expand');
    RegisterPropertyHelper(@TALBaseAVLListCapacity_R,@TALBaseAVLListCapacity_W,'Capacity');
    RegisterPropertyHelper(@TALBaseAVLListCount_R,@TALBaseAVLListCount_W,'Count');
    RegisterPropertyHelper(@TALBaseAVLListDuplicates_R,@TALBaseAVLListDuplicates_W,'Duplicates');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TALDoubleList(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TALDoubleList) do
  begin
    RegisterMethod(@TALDoubleList.IndexOf, 'IndexOf');
    RegisterMethod(@TALDoubleList.IndexOfObject, 'IndexOfObject');
    RegisterMethod(@TALDoubleList.Add, 'Add');
    RegisterMethod(@TALDoubleList.AddObject, 'AddObject');
    RegisterMethod(@TALDoubleList.Find, 'Find');
    RegisterMethod(@TALDoubleList.Insert, 'Insert');
    RegisterMethod(@TALDoubleList.InsertObject, 'InsertObject');
    RegisterPropertyHelper(@TALDoubleListItems_R,@TALDoubleListItems_W,'Items');
    RegisterPropertyHelper(@TALDoubleListObjects_R,@TALDoubleListObjects_W,'Objects');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TALInt64List(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TALInt64List) do
  begin
    RegisterMethod(@TALInt64List.IndexOf, 'IndexOf');
    RegisterMethod(@TALInt64List.IndexOfObject, 'IndexOfObject');
    RegisterMethod(@TALInt64List.Add, 'Add');
    RegisterMethod(@TALInt64List.AddObject, 'AddObject');
    RegisterMethod(@TALInt64List.Find, 'Find');
    RegisterMethod(@TALInt64List.Insert, 'Insert');
    RegisterMethod(@TALInt64List.InsertObject, 'InsertObject');
    RegisterPropertyHelper(@TALInt64ListItems_R,@TALInt64ListItems_W,'Items');
    RegisterPropertyHelper(@TALInt64ListObjects_R,@TALInt64ListObjects_W,'Objects');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TALCardinalList(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TALCardinalList) do
  begin
    RegisterMethod(@TALCardinalList.IndexOf, 'IndexOf');
    RegisterMethod(@TALCardinalList.IndexOfObject, 'IndexOfObject');
    RegisterMethod(@TALCardinalList.Add, 'Add');
    RegisterMethod(@TALCardinalList.AddObject, 'AddObject');
    RegisterMethod(@TALCardinalList.Find, 'Find');
    RegisterMethod(@TALCardinalList.Insert, 'Insert');
    RegisterMethod(@TALCardinalList.InsertObject, 'InsertObject');
    RegisterPropertyHelper(@TALCardinalListItems_R,@TALCardinalListItems_W,'Items');
    RegisterPropertyHelper(@TALCardinalListObjects_R,@TALCardinalListObjects_W,'Objects');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TALIntegerList(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TALIntegerList) do
  begin
    RegisterMethod(@TALIntegerList.IndexOf, 'IndexOf');
    RegisterMethod(@TALIntegerList.IndexOfObject, 'IndexOfObject');
    RegisterMethod(@TALIntegerList.Add, 'Add');
    RegisterMethod(@TALIntegerList.AddObject, 'AddObject');
    RegisterMethod(@TALIntegerList.Find, 'Find');
    RegisterMethod(@TALIntegerList.Insert, 'Insert');
    RegisterMethod(@TALIntegerList.InsertObject, 'InsertObject');
    RegisterPropertyHelper(@TALIntegerListItems_R,@TALIntegerListItems_W,'Items');
    RegisterPropertyHelper(@TALIntegerListObjects_R,@TALIntegerListObjects_W,'Objects');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TALBaseQuickSortList(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TALBaseQuickSortList) do
  begin
    RegisterConstructor(@TALBaseQuickSortList.Create, 'Create');
    RegisterVirtualMethod(@TALBaseQuickSortList.Clear, 'Clear');
    RegisterMethod(@TALBaseQuickSortList.Delete, 'Delete');
    RegisterVirtualMethod(@TALBaseQuickSortListError_P, 'Error');
    RegisterMethod(@TALBaseQuickSortListError1_P, 'Error1');
    RegisterMethod(@TALBaseQuickSortList.Exchange, 'Exchange');
    RegisterMethod(@TALBaseQuickSortList.Expand, 'Expand');
    RegisterVirtualMethod(@TALBaseQuickSortList.CustomSort, 'CustomSort');
    RegisterVirtualMethod(@TALBaseQuickSortList.Sort, 'Sort');
    RegisterPropertyHelper(@TALBaseQuickSortListSorted_R,@TALBaseQuickSortListSorted_W,'Sorted');
    RegisterPropertyHelper(@TALBaseQuickSortListCapacity_R,@TALBaseQuickSortListCapacity_W,'Capacity');
    RegisterPropertyHelper(@TALBaseQuickSortListCount_R,@TALBaseQuickSortListCount_W,'Count');
    RegisterPropertyHelper(@TALBaseQuickSortListDuplicates_R,@TALBaseQuickSortListDuplicates_W,'Duplicates');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_ALQuickSortList(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TALBaseQuickSortList(CL);
  RIRegister_TALIntegerList(CL);
  RIRegister_TALCardinalList(CL);
  RIRegister_TALInt64List(CL);
  RIRegister_TALDoubleList(CL);
  RIRegister_TALBaseAVLList(CL);
  RIRegister_TALAVLInt64ListBinaryTreeNode(CL);
  RIRegister_TALInt64AVLList(CL);
end;

 
 
{ TPSImport_ALQuickSortList }
(*----------------------------------------------------------------------------*)
procedure TPSImport_ALQuickSortList.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_ALQuickSortList(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_ALQuickSortList.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_ALQuickSortList(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
