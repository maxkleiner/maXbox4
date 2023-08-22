unit uPSI_GR32_Containers;
{
   pointers   add free
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
  TPSImport_GR32_Containers = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TLinkedList(CL: TPSPascalCompiler);
//procedure SIRegister_TClassList(CL: TPSPascalCompiler);
procedure SIRegister_TRectList(CL: TPSPascalCompiler);
procedure SIRegister_TPointerMapIterator(CL: TPSPascalCompiler);
procedure SIRegister_TPointerMap(CL: TPSPascalCompiler);
procedure SIRegister_GR32_Containers(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_GR32_Containers_Routines(S: TPSExec);
procedure RIRegister_TLinkedList(CL: TPSRuntimeClassImporter);
//procedure RIRegister_TClassList(CL: TPSRuntimeClassImporter);
procedure RIRegister_TRectList(CL: TPSRuntimeClassImporter);
procedure RIRegister_TPointerMapIterator(CL: TPSRuntimeClassImporter);
procedure RIRegister_TPointerMap(CL: TPSRuntimeClassImporter);
procedure RIRegister_GR32_Containers(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   Types
  ,Windows
  ,RTLConsts
  ,GR32
  ,GR32_LowLevel
  ,TypInfo
  ,GR32_Containers
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_GR32_Containers]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TLinkedList(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOBJECT', 'TLinkedList') do
  with CL.AddClassN(CL.FindClass('TOBJECT'),'TLinkedList') do
  begin
    RegisterMethod('Function Add : PLinkedNode');
    RegisterMethod('Procedure Remove( Node : PLinkedNode)');
    RegisterMethod('Function IndexOf( Node : PLinkedNode) : Integer');
    RegisterMethod('Function GetNode( Index : Integer) : PLinkedNode');
    RegisterMethod('Procedure Exchange( Node1, Node2 : PLinkedNode)');
    RegisterMethod('Procedure InsertBefore( Node, NewNode : PLinkedNode)');
    RegisterMethod('Procedure InsertAfter( Node, NewNode : PLinkedNode)');
    RegisterMethod('Procedure Clear');
    RegisterMethod('Procedure IterateList( CallBack : TIteratorProc)');
    RegisterProperty('Head', 'TLinkedNode', iptrw);
    RegisterProperty('Tail', 'TLinkedNode', iptrw);
    RegisterProperty('Count', 'Integer', iptrw);
    RegisterProperty('OnFreeData', 'TFreeDataEvent', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
(*procedure SIRegister_TClassList(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TList', 'TClassList') do
  with CL.AddClassN(CL.FindClass('TList'),'TClassList2') do
  begin
    RegisterMethod('Function Add( AClass : TClass) : Integer');
    RegisterMethod('Function Extract( Item : TClass) : TClass');
    RegisterMethod('Function Remove( AClass : TClass) : Integer');
    RegisterMethod('Function IndexOf( AClass : TClass) : Integer');
    RegisterMethod('Function First : TClass');
    RegisterMethod('Function Last : TClass');
    RegisterMethod('Function Find( AClassName : string) : TClass');
    RegisterMethod('Procedure GetClassNames( Strings : TStrings)');
    RegisterMethod('Procedure Insert( Index : Integer; AClass : TClass)');
    RegisterProperty('Items', 'TClass Integer', iptrw);
    SetDefaultPropery('Items');
  end;
end;*)

(*----------------------------------------------------------------------------*)
procedure SIRegister_TRectList(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOBJECT', 'TRectList') do
  with CL.AddClassN(CL.FindClass('TOBJECT'),'TRectList') do begin
    RegisterMethod('Function Add( const Rect : TRect) : Integer');
    RegisterMethod('Procedure Clear');
      RegisterMethod('Procedure Free');
     RegisterMethod('Procedure Delete( Index : Integer)');
    RegisterMethod('Procedure Exchange( Index1, Index2 : Integer)');
    RegisterMethod('Function IndexOf( const Rect : TRect) : Integer');
    RegisterMethod('Procedure Insert( Index : Integer; const Rect : TRect)');
    RegisterMethod('Procedure Move( CurIndex, NewIndex : Integer)');
    RegisterMethod('Function Remove( const Rect : TRect) : Integer');
    RegisterMethod('Procedure Pack');
    RegisterProperty('Capacity', 'Integer', iptrw);
    RegisterProperty('Count', 'Integer', iptrw);
    RegisterProperty('Items', 'TRect Integer', iptr);
    SetDefaultPropery('Items');
    RegisterProperty('List', 'TPolyRects', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TPointerMapIterator(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOBJECT', 'TPointerMapIterator') do
  with CL.AddClassN(CL.FindClass('TOBJECT'),'TPointerMapIterator') do
  begin
    RegisterMethod('Constructor Create( SrcPointerMap : TPointerMap)');
    RegisterMethod('Function Next : Boolean');
    RegisterProperty('Item', 'PItem', iptr);
    RegisterProperty('Data', 'PData', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TPointerMap(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOBJECT', 'TPointerMap') do
  with CL.AddClassN(CL.FindClass('TOBJECT'),'TPointerMap') do begin
    RegisterMethod('Function Add( NewItem : PItem) : PPData;');
    RegisterMethod('Function Add1( NewItem : PItem; out IsNew : Boolean) : PPData;');
    RegisterMethod('Function Add2( NewItem : PItem; NewData : PData) : PPData;');
    RegisterMethod('Function Add3( NewItem : PItem; NewData : PData; out IsNew : Boolean) : PPData;');
    RegisterMethod('Function Remove( Item : PItem) : PData');
    RegisterMethod('Procedure Clear');
      RegisterMethod('Procedure Free');
     RegisterMethod('Function Contains( Item : PItem) : Boolean');
    RegisterMethod('Function Find( Item : PItem; out Data : PPData) : Boolean');
    RegisterProperty('Data', 'PData PItem', iptrw);
    SetDefaultPropery('Data');
    RegisterProperty('Count', 'Integer', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_GR32_Containers(CL: TPSPascalCompiler);
begin
 CL.AddConstantN('BUCKET_MASK','LongWord').SetUInt( $FF);
 CL.AddConstantN('BUCKET_COUNT','LongInt').SetInt( BUCKET_MASK + 1);
  //CL.AddTypeS('PPItem', '^PItem // will not work');
  CL.AddTypeS('PItem', 'TObject');
  //CL.AddTypeS('PPData', '^PData // will not work');
  CL.AddTypeS('PData', 'TObject');
  CL.AddTypeS('TTypeKind', '(tkUnknown, tkInteger, tkChar, tkEnumeration, tkFloat,'
    +'tkString, tkSet, tkClass, tkMethod, tkWChar, tkLString, tkWString,'
    +'tkVariant, tkArray, tkRecord, tkInterface, tkInt64, tkDynArray);');
   {TTypeKind = (tkUnknown, tkInteger, tkChar, tkEnumeration, tkFloat,
    tkString, tkSet, tkClass, tkMethod, tkWChar, tkLString, tkWString,
    tkVariant, tkArray, tkRecord, tkInterface, tkInt64, tkDynArray);}
  CL.AddTypeS('TTypeKinds', 'set of TTypeKind;');
  //TTypeKinds = set of TTypeKind;
  CL.AddTypeS('TOrdType', '(otSByte, otUByte, otSWord, otUWord, otSLong, otULong);');
   //  TOrdType = (otSByte, otUByte, otSWord, otUWord, otSLong, otULong);
   //CL.AddTypeS('PPointerBucketItem', '^TPointerBucketItem // will not work');
  CL.AddTypeS('TPointerBucketItem', 'record Item : PItem; Data : PData; end');
  CL.AddTypeS('TPointerBucketItemArray', 'array of TPointerBucketItem');
  CL.AddTypeS('TPointerBucket', 'record Count : Integer; Items : TPointerBucketItemArray; end');
  SIRegister_TPointerMap(CL);
  SIRegister_TPointerMapIterator(CL);
  //CL.AddTypeS('PPolyRects', '^TPolyRects // will not work');
  SIRegister_TRectList(CL);
  //SIRegister_TClassList(CL);
  //CL.AddTypeS('PLinkedNode', '^TLinkedNode // will not work');
  CL.AddTypeS('TLinkedNode', 'record Prev : TObject; Next : TObject; Data : TObject; end');
  CL.AddTypeS('TFreeDataEvent', 'Procedure ( Data : TObject)');
  SIRegister_TLinkedList(CL);
 CL.AddDelphiFunction('Procedure SmartAssign( Src, Dst : TPersistent; TypeKinds : TTypeKinds)');
 CL.AddDelphiFunction('Procedure Advance( var Node : TLinkedNode; Steps : Integer)');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TLinkedListOnFreeData_W(Self: TLinkedList; const T: TFreeDataEvent);
begin Self.OnFreeData := T; end;

(*----------------------------------------------------------------------------*)
procedure TLinkedListOnFreeData_R(Self: TLinkedList; var T: TFreeDataEvent);
begin T := Self.OnFreeData; end;

(*----------------------------------------------------------------------------*)
procedure TLinkedListCount_W(Self: TLinkedList; const T: Integer);
begin Self.Count := T; end;

(*----------------------------------------------------------------------------*)
procedure TLinkedListCount_R(Self: TLinkedList; var T: Integer);
begin T := Self.Count; end;

(*----------------------------------------------------------------------------*)
procedure TLinkedListTail_W(Self: TLinkedList; const T: PLinkedNode);
begin Self.Tail := T; end;

(*----------------------------------------------------------------------------*)
procedure TLinkedListTail_R(Self: TLinkedList; var T: PLinkedNode);
begin T := Self.Tail; end;

(*----------------------------------------------------------------------------*)
procedure TLinkedListHead_W(Self: TLinkedList; const T: PLinkedNode);
begin Self.Head := T; end;

(*----------------------------------------------------------------------------*)
procedure TLinkedListHead_R(Self: TLinkedList; var T: PLinkedNode);
begin T := Self.Head; end;

(*----------------------------------------------------------------------------*)
procedure TClassListItems_W(Self: TClassList; const T: TClass; const t1: Integer);
begin Self.Items[t1] := T; end;

(*----------------------------------------------------------------------------*)
procedure TClassListItems_R(Self: TClassList; var T: TClass; const t1: Integer);
begin T := Self.Items[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TRectListList_R(Self: TRectList; var T: PPolyRects);
begin T := Self.List; end;

(*----------------------------------------------------------------------------*)
procedure TRectListItems_R(Self: TRectList; var T: PRect; const t1: Integer);
begin T := Self.Items[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TRectListCount_W(Self: TRectList; const T: Integer);
begin Self.Count := T; end;

(*----------------------------------------------------------------------------*)
procedure TRectListCount_R(Self: TRectList; var T: Integer);
begin T := Self.Count; end;

(*----------------------------------------------------------------------------*)
procedure TRectListCapacity_W(Self: TRectList; const T: Integer);
begin Self.Capacity := T; end;

(*----------------------------------------------------------------------------*)
procedure TRectListCapacity_R(Self: TRectList; var T: Integer);
begin T := Self.Capacity; end;

(*----------------------------------------------------------------------------*)
procedure TPointerMapIteratorData_R(Self: TPointerMapIterator; var T: PData);
begin T := Self.Data; end;

(*----------------------------------------------------------------------------*)
procedure TPointerMapIteratorItem_R(Self: TPointerMapIterator; var T: PItem);
begin T := Self.Item; end;

(*----------------------------------------------------------------------------*)
procedure TPointerMapCount_R(Self: TPointerMap; var T: Integer);
begin T := Self.Count; end;

(*----------------------------------------------------------------------------*)
procedure TPointerMapData_W(Self: TPointerMap; const T: PData; const t1: PItem);
begin Self.Data[t1] := T; end;

(*----------------------------------------------------------------------------*)
procedure TPointerMapData_R(Self: TPointerMap; var T: PData; const t1: PItem);
begin T := Self.Data[t1]; end;

(*----------------------------------------------------------------------------*)
Function TPointerMapAdd3_P(Self: TPointerMap;  NewItem : PItem; NewData : PData; out IsNew : Boolean) : PPData;
Begin Result := Self.Add(NewItem, NewData, IsNew); END;

(*----------------------------------------------------------------------------*)
Function TPointerMapAdd2_P(Self: TPointerMap;  NewItem : PItem; NewData : PData) : PPData;
Begin Result := Self.Add(NewItem, NewData); END;

(*----------------------------------------------------------------------------*)
Function TPointerMapAdd1_P(Self: TPointerMap;  NewItem : PItem; out IsNew : Boolean) : PPData;
Begin Result := Self.Add(NewItem, IsNew); END;

(*----------------------------------------------------------------------------*)
Function TPointerMapAdd_P(Self: TPointerMap;  NewItem : PItem) : PPData;
Begin Result := Self.Add(NewItem); END;

(*----------------------------------------------------------------------------*)
procedure RIRegister_GR32_Containers_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@SmartAssign, 'SmartAssign', cdRegister);
 S.RegisterDelphiFunction(@Advance, 'Advance', cdRegister);
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TLinkedList(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TLinkedList) do
  begin
    RegisterMethod(@TLinkedList.Add, 'Add');
    RegisterMethod(@TLinkedList.Remove, 'Remove');
    RegisterMethod(@TLinkedList.IndexOf, 'IndexOf');
    RegisterMethod(@TLinkedList.GetNode, 'GetNode');
    RegisterMethod(@TLinkedList.Exchange, 'Exchange');
    RegisterMethod(@TLinkedList.InsertBefore, 'InsertBefore');
    RegisterMethod(@TLinkedList.InsertAfter, 'InsertAfter');
    RegisterMethod(@TLinkedList.Clear, 'Clear');
    RegisterMethod(@TLinkedList.IterateList, 'IterateList');
    RegisterPropertyHelper(@TLinkedListHead_R,@TLinkedListHead_W,'Head');
    RegisterPropertyHelper(@TLinkedListTail_R,@TLinkedListTail_W,'Tail');
    RegisterPropertyHelper(@TLinkedListCount_R,@TLinkedListCount_W,'Count');
    RegisterPropertyHelper(@TLinkedListOnFreeData_R,@TLinkedListOnFreeData_W,'OnFreeData');
  end;
end;

(*----------------------------------------------------------------------------*)
(*procedure RIRegister_TClassList(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TClassList) do
  begin
    RegisterMethod(@TClassList.Add, 'Add');
    RegisterMethod(@TClassList.Extract, 'Extract');
    RegisterMethod(@TClassList.Remove, 'Remove');
    RegisterMethod(@TClassList.IndexOf, 'IndexOf');
    RegisterMethod(@TClassList.First, 'First');
    RegisterMethod(@TClassList.Last, 'Last');
    RegisterMethod(@TClassList.Find, 'Find');
    RegisterMethod(@TClassList.GetClassNames, 'GetClassNames');
    RegisterMethod(@TClassList.Insert, 'Insert');
    RegisterPropertyHelper(@TClassListItems_R,@TClassListItems_W,'Items');
  end;
end;*)

(*----------------------------------------------------------------------------*)
procedure RIRegister_TRectList(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TRectList) do begin
    RegisterMethod(@TRectList.Add, 'Add');
    RegisterVirtualMethod(@TRectList.Clear, 'Clear');
      RegisterMethod(@TRectList.Destroy, 'Free');
     RegisterMethod(@TRectList.Delete, 'Delete');
    RegisterMethod(@TRectList.Exchange, 'Exchange');
    RegisterMethod(@TRectList.IndexOf, 'IndexOf');
    RegisterMethod(@TRectList.Insert, 'Insert');
    RegisterMethod(@TRectList.Move, 'Move');
    RegisterMethod(@TRectList.Remove, 'Remove');
    RegisterMethod(@TRectList.Pack, 'Pack');
    RegisterPropertyHelper(@TRectListCapacity_R,@TRectListCapacity_W,'Capacity');
    RegisterPropertyHelper(@TRectListCount_R,@TRectListCount_W,'Count');
    RegisterPropertyHelper(@TRectListItems_R,nil,'Items');
    RegisterPropertyHelper(@TRectListList_R,nil,'List');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TPointerMapIterator(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TPointerMapIterator) do
  begin
    RegisterConstructor(@TPointerMapIterator.Create, 'Create');
    RegisterMethod(@TPointerMapIterator.Next, 'Next');
    RegisterPropertyHelper(@TPointerMapIteratorItem_R,nil,'Item');
    RegisterPropertyHelper(@TPointerMapIteratorData_R,nil,'Data');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TPointerMap(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TPointerMap) do begin
    RegisterMethod(@TPointerMap.Destroy, 'Free');
     RegisterMethod(@TPointerMapAdd_P, 'Add');
    RegisterMethod(@TPointerMapAdd1_P, 'Add1');
    RegisterMethod(@TPointerMapAdd2_P, 'Add2');
    RegisterMethod(@TPointerMapAdd3_P, 'Add3');
    RegisterMethod(@TPointerMap.Remove, 'Remove');
    RegisterMethod(@TPointerMap.Clear, 'Clear');
    RegisterMethod(@TPointerMap.Contains, 'Contains');
    RegisterMethod(@TPointerMap.Find, 'Find');
    RegisterPropertyHelper(@TPointerMapData_R,@TPointerMapData_W,'Data');
    RegisterPropertyHelper(@TPointerMapCount_R,nil,'Count');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_GR32_Containers(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TPointerMap(CL);
  RIRegister_TPointerMapIterator(CL);
  RIRegister_TRectList(CL);
  //RIRegister_TClassList(CL);
  RIRegister_TLinkedList(CL);
end;

 
 
{ TPSImport_GR32_Containers }
(*----------------------------------------------------------------------------*)
procedure TPSImport_GR32_Containers.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_GR32_Containers(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_GR32_Containers.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_GR32_Containers(ri);
  RIRegister_GR32_Containers_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
