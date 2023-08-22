unit uPSI_ZCollections;
{
    led zep pep, did the izinterface in object as iinterface
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
  TPSImport_ZCollections = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TZStack(CL: TPSPascalCompiler);
procedure SIRegister_TZHashMap(CL: TPSPascalCompiler);
procedure SIRegister_TZUnmodifiableCollection(CL: TPSPascalCompiler);
procedure SIRegister_TZCollection(CL: TPSPascalCompiler);
procedure SIRegister_TZIterator(CL: TPSPascalCompiler);
procedure SIRegister_ZCollections(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TZStack(CL: TPSRuntimeClassImporter);
procedure RIRegister_TZHashMap(CL: TPSRuntimeClassImporter);
procedure RIRegister_TZUnmodifiableCollection(CL: TPSRuntimeClassImporter);
procedure RIRegister_TZCollection(CL: TPSRuntimeClassImporter);
procedure RIRegister_TZIterator(CL: TPSRuntimeClassImporter);
procedure RIRegister_ZCollections(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   ZClasses
  ,ZCollections
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_ZCollections]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TZStack(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TZAbstractObject', 'TZStack') do
  with CL.AddClassN(CL.FindClass('TZAbstractObject'),'TZStack') do begin
    RegisterMethod('Constructor Create');
    RegisterMethod('Function Clone : IZInterface');
    RegisterMethod('Function ToString : string');
    RegisterMethod('Function Peek : IZInterface');
    RegisterMethod('Function Pop : IZInterface');
    RegisterMethod('Procedure Push( Value : IZInterface)');
    RegisterMethod('Function GetCount : Integer');
    RegisterProperty('Count', 'Integer', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TZHashMap(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TZAbstractObject', 'TZHashMap') do
  with CL.AddClassN(CL.FindClass('TZAbstractObject'),'TZHashMap') do begin
    RegisterMethod('Constructor Create');
    RegisterMethod('Function Clone : IZInterface');
    RegisterMethod('Function Get( const Key : IZInterface) : IZInterface');
    RegisterMethod('Procedure Put( const Key : IZInterface; const Value : IZInterface)');
    RegisterMethod('Function GetKeys : IZCollection');
    RegisterMethod('Function GetValues : IZCollection');
    RegisterMethod('Function GetCount : Integer');
    RegisterMethod('Function Remove( Key : IZInterface) : Boolean');
    RegisterMethod('Procedure Clear');
    RegisterProperty('Count', 'Integer', iptr);
    RegisterProperty('Keys', 'IZCollection', iptr);
    RegisterProperty('Values', 'IZCollection', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TZUnmodifiableCollection(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TZAbstractObject', 'TZUnmodifiableCollection') do
  with CL.AddClassN(CL.FindClass('TZAbstractObject'),'TZUnmodifiableCollection') do
  begin
    RegisterMethod('Constructor Create( Collection : IZCollection)');
    RegisterMethod('Function Clone : IZInterface');
    RegisterMethod('Function ToString : string');
    RegisterMethod('Function Get( Index : Integer) : IZInterface');
    RegisterMethod('Procedure Put( Index : Integer; const Item : IZInterface)');
    RegisterMethod('Function IndexOf( const Item : IZInterface) : Integer');
    RegisterMethod('Function GetCount : Integer');
    RegisterMethod('Function GetIterator : IZIterator');
    RegisterMethod('Function First : IZInterface');
    RegisterMethod('Function Last : IZInterface');
    RegisterMethod('Function Add( const Item : IZInterface) : Integer');
    RegisterMethod('Procedure Insert( Index : Integer; const Item : IZInterface)');
    RegisterMethod('Function Remove( const Item : IZInterface) : Integer');
    RegisterMethod('Procedure Exchange( Index1, Index2 : Integer)');
    RegisterMethod('Procedure Delete( Index : Integer)');
    RegisterMethod('Procedure Clear');
    RegisterMethod('Function Contains( const Item : IZInterface) : Boolean');
    RegisterMethod('Function ContainsAll( const Col : IZCollection) : Boolean');
    RegisterMethod('Function AddAll( const Col : IZCollection) : Boolean');
    RegisterMethod('Function RemoveAll( const Col : IZCollection) : Boolean');
    RegisterProperty('Count', 'Integer', iptr);
    RegisterProperty('Items', 'IZInterface Integer', iptrw);
    SetDefaultPropery('Items');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TZCollection(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TZAbstractObject', 'TZCollection') do
  with CL.AddClassN(CL.FindClass('TZAbstractObject'),'TZCollection') do begin
    RegisterMethod('Constructor Create');
    RegisterMethod('Function Clone : IZInterface');
    RegisterMethod('Function ToString : string');
    RegisterMethod('Function Get( Index : Integer) : IZInterface');
    RegisterMethod('Procedure Put( Index : Integer; const Item : IZInterface)');
    RegisterMethod('Function IndexOf( const Item : IZInterface) : Integer');
    RegisterMethod('Function GetCount : Integer');
    RegisterMethod('Function GetIterator : IZIterator');
    RegisterMethod('Function First : IZInterface');
    RegisterMethod('Function Last : IZInterface');
    RegisterMethod('Function Add( const Item : IZInterface) : Integer');
    RegisterMethod('Procedure Insert( Index : Integer; const Item : IZInterface)');
    RegisterMethod('Function Remove( const Item : IZInterface) : Integer');
    RegisterMethod('Procedure Exchange( Index1, Index2 : Integer)');
    RegisterMethod('Procedure Delete( Index : Integer)');
    RegisterMethod('Procedure Clear');
    RegisterMethod('Function Contains( const Item : IZInterface) : Boolean');
    RegisterMethod('Function ContainsAll( const Col : IZCollection) : Boolean');
    RegisterMethod('Function AddAll( const Col : IZCollection) : Boolean');
    RegisterMethod('Function RemoveAll( const Col : IZCollection) : Boolean');
    RegisterProperty('Count', 'Integer', iptr);
    RegisterProperty('Items', 'IZInterface Integer', iptrw);
    SetDefaultPropery('Items');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TZIterator(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TZAbstractObject', 'TZIterator') do
  with CL.AddClassN(CL.FindClass('TZAbstractObject'),'TZIterator') do begin
    RegisterMethod('Constructor Create( const Col : IZCollection)');
    RegisterMethod('Function HasNext : Boolean');
    RegisterMethod('Function Next : IZInterface');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_ZCollections(CL: TPSPascalCompiler);
begin
  SIRegister_TZIterator(CL);
  //CL.AddTypeS('PZInterfaceList', '^TZInterfaceList // will not work');
  SIRegister_TZCollection(CL);
  SIRegister_TZUnmodifiableCollection(CL);
  SIRegister_TZHashMap(CL);
  SIRegister_TZStack(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TZStackCount_R(Self: TZStack; var T: Integer);
begin T := Self.Count; end;

(*----------------------------------------------------------------------------*)
procedure TZHashMapValues_R(Self: TZHashMap; var T: IZCollection);
begin T := Self.Values; end;

(*----------------------------------------------------------------------------*)
procedure TZHashMapKeys_R(Self: TZHashMap; var T: IZCollection);
begin T := Self.Keys; end;

(*----------------------------------------------------------------------------*)
procedure TZHashMapCount_R(Self: TZHashMap; var T: Integer);
begin T := Self.Count; end;

(*----------------------------------------------------------------------------*)
procedure TZUnmodifiableCollectionItems_W(Self: TZUnmodifiableCollection; const T: IZInterface; const t1: Integer);
begin Self.Items[t1] := T; end;

(*----------------------------------------------------------------------------*)
procedure TZUnmodifiableCollectionItems_R(Self: TZUnmodifiableCollection; var T: IZInterface; const t1: Integer);
begin T := Self.Items[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TZUnmodifiableCollectionCount_R(Self: TZUnmodifiableCollection; var T: Integer);
begin T := Self.Count; end;

(*----------------------------------------------------------------------------*)
procedure TZCollectionItems_W(Self: TZCollection; const T: IZInterface; const t1: Integer);
begin Self.Items[t1] := T; end;

(*----------------------------------------------------------------------------*)
procedure TZCollectionItems_R(Self: TZCollection; var T: IZInterface; const t1: Integer);
begin T := Self.Items[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TZCollectionCount_R(Self: TZCollection; var T: Integer);
begin T := Self.Count; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TZStack(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TZStack) do
  begin
    RegisterConstructor(@TZStack.Create, 'Create');
    RegisterMethod(@TZStack.Clone, 'Clone');
    RegisterMethod(@TZStack.ToString, 'ToString');
    RegisterMethod(@TZStack.Peek, 'Peek');
    RegisterMethod(@TZStack.Pop, 'Pop');
    RegisterMethod(@TZStack.Push, 'Push');
    RegisterMethod(@TZStack.GetCount, 'GetCount');
    RegisterPropertyHelper(@TZStackCount_R,nil,'Count');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TZHashMap(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TZHashMap) do
  begin
    RegisterConstructor(@TZHashMap.Create, 'Create');
    RegisterMethod(@TZHashMap.Clone, 'Clone');
    RegisterMethod(@TZHashMap.Get, 'Get');
    RegisterMethod(@TZHashMap.Put, 'Put');
    RegisterMethod(@TZHashMap.GetKeys, 'GetKeys');
    RegisterMethod(@TZHashMap.GetValues, 'GetValues');
    RegisterMethod(@TZHashMap.GetCount, 'GetCount');
    RegisterMethod(@TZHashMap.Remove, 'Remove');
    RegisterMethod(@TZHashMap.Clear, 'Clear');
    RegisterPropertyHelper(@TZHashMapCount_R,nil,'Count');
    RegisterPropertyHelper(@TZHashMapKeys_R,nil,'Keys');
    RegisterPropertyHelper(@TZHashMapValues_R,nil,'Values');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TZUnmodifiableCollection(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TZUnmodifiableCollection) do
  begin
    RegisterConstructor(@TZUnmodifiableCollection.Create, 'Create');
    RegisterMethod(@TZUnmodifiableCollection.Clone, 'Clone');
    RegisterMethod(@TZUnmodifiableCollection.ToString, 'ToString');
    RegisterMethod(@TZUnmodifiableCollection.Get, 'Get');
    RegisterMethod(@TZUnmodifiableCollection.Put, 'Put');
    RegisterMethod(@TZUnmodifiableCollection.IndexOf, 'IndexOf');
    RegisterMethod(@TZUnmodifiableCollection.GetCount, 'GetCount');
    RegisterMethod(@TZUnmodifiableCollection.GetIterator, 'GetIterator');
    RegisterMethod(@TZUnmodifiableCollection.First, 'First');
    RegisterMethod(@TZUnmodifiableCollection.Last, 'Last');
    RegisterMethod(@TZUnmodifiableCollection.Add, 'Add');
    RegisterMethod(@TZUnmodifiableCollection.Insert, 'Insert');
    RegisterMethod(@TZUnmodifiableCollection.Remove, 'Remove');
    RegisterMethod(@TZUnmodifiableCollection.Exchange, 'Exchange');
    RegisterMethod(@TZUnmodifiableCollection.Delete, 'Delete');
    RegisterMethod(@TZUnmodifiableCollection.Clear, 'Clear');
    RegisterMethod(@TZUnmodifiableCollection.Contains, 'Contains');
    RegisterMethod(@TZUnmodifiableCollection.ContainsAll, 'ContainsAll');
    RegisterMethod(@TZUnmodifiableCollection.AddAll, 'AddAll');
    RegisterMethod(@TZUnmodifiableCollection.RemoveAll, 'RemoveAll');
    RegisterPropertyHelper(@TZUnmodifiableCollectionCount_R,nil,'Count');
    RegisterPropertyHelper(@TZUnmodifiableCollectionItems_R,@TZUnmodifiableCollectionItems_W,'Items');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TZCollection(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TZCollection) do
  begin
    RegisterConstructor(@TZCollection.Create, 'Create');
    RegisterMethod(@TZCollection.Clone, 'Clone');
    RegisterMethod(@TZCollection.ToString, 'ToString');
    RegisterMethod(@TZCollection.Get, 'Get');
    RegisterMethod(@TZCollection.Put, 'Put');
    RegisterMethod(@TZCollection.IndexOf, 'IndexOf');
    RegisterMethod(@TZCollection.GetCount, 'GetCount');
    RegisterMethod(@TZCollection.GetIterator, 'GetIterator');
    RegisterMethod(@TZCollection.First, 'First');
    RegisterMethod(@TZCollection.Last, 'Last');
    RegisterMethod(@TZCollection.Add, 'Add');
    RegisterMethod(@TZCollection.Insert, 'Insert');
    RegisterMethod(@TZCollection.Remove, 'Remove');
    RegisterMethod(@TZCollection.Exchange, 'Exchange');
    RegisterMethod(@TZCollection.Delete, 'Delete');
    RegisterMethod(@TZCollection.Clear, 'Clear');
    RegisterMethod(@TZCollection.Contains, 'Contains');
    RegisterMethod(@TZCollection.ContainsAll, 'ContainsAll');
    RegisterMethod(@TZCollection.AddAll, 'AddAll');
    RegisterMethod(@TZCollection.RemoveAll, 'RemoveAll');
    RegisterPropertyHelper(@TZCollectionCount_R,nil,'Count');
    RegisterPropertyHelper(@TZCollectionItems_R,@TZCollectionItems_W,'Items');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TZIterator(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TZIterator) do
  begin
    RegisterConstructor(@TZIterator.Create, 'Create');
    RegisterMethod(@TZIterator.HasNext, 'HasNext');
    RegisterMethod(@TZIterator.Next, 'Next');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_ZCollections(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TZIterator(CL);
  RIRegister_TZCollection(CL);
  RIRegister_TZUnmodifiableCollection(CL);
  RIRegister_TZHashMap(CL);
  RIRegister_TZStack(CL);
end;

 
 
{ TPSImport_ZCollections }
(*----------------------------------------------------------------------------*)
procedure TPSImport_ZCollections.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_ZCollections(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_ZCollections.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_ZCollections(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
