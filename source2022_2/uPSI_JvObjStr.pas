unit uPSI_JvObjStr;
{
  collection like
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
  TPSImport_JvObjStr = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TJvSortCollection(CL: TPSPascalCompiler);
procedure SIRegister_TJvHugeList(CL: TPSPascalCompiler);
procedure SIRegister_TJvObjectStrings(CL: TPSPascalCompiler);
procedure SIRegister_JvObjStr(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TJvSortCollection(CL: TPSRuntimeClassImporter);
procedure RIRegister_TJvHugeList(CL: TPSRuntimeClassImporter);
procedure RIRegister_TJvObjectStrings(CL: TPSRuntimeClassImporter);
procedure RIRegister_JvObjStr(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   RTLConsts
  ,JvObjStr
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_JvObjStr]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TJvSortCollection(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TCollection', 'TJvSortCollection') do
  with CL.AddClassN(CL.FindClass('TCollection'),'TJvSortCollection') do
  begin
    RegisterMethod('Procedure Sort( Compare : TItemSortCompare)');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TJvHugeList(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TObject', 'TJvHugeList') do
  with CL.AddClassN(CL.FindClass('TObject'),'TJvHugeList') do begin
    RegisterMethod('Function Add( Item : ___Pointer) : Longint');
    RegisterMethod('Procedure Clear');
    RegisterMethod('Procedure Delete( Index : Longint)');
    RegisterMethod('Procedure Exchange( Index1, Index2 : Longint)');
    RegisterMethod('Function Expand : TJvHugeList');
    RegisterMethod('Function First : ___Pointer');
    RegisterMethod('Function IndexOf( Item : ___Pointer) : Longint');
    RegisterMethod('Procedure Insert( Index : Longint; Item : ___Pointer)');
    RegisterMethod('Function Last : ___Pointer');
    RegisterMethod('Procedure Move( CurIndex, NewIndex : Longint)');
    RegisterMethod('Function Remove( Item : ___Pointer) : Longint');
    RegisterMethod('Procedure Pack');
    RegisterProperty('Capacity', 'Longint', iptrw);
    RegisterProperty('Count', 'Longint', iptrw);
    RegisterProperty('Items', '___Pointer Longint', iptrw);
    //SetDefaultPropery('Items');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TJvObjectStrings(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TStringList', 'TJvObjectStrings') do
  with CL.AddClassN(CL.FindClass('TStringList'),'TJvObjectStrings') do begin
    RegisterMethod('Procedure Clear');
    RegisterMethod('Procedure Delete( Index : Integer)');
    RegisterMethod('Procedure Move( CurIndex, NewIndex : Integer)');
    RegisterMethod('Procedure Remove( Index : Integer)');
    RegisterMethod('Procedure ParseStrings( const Values : string)');
    RegisterMethod('Procedure SortList( Compare : TObjectSortCompare)');
    RegisterProperty('OnDestroyObject', 'TDestroyEvent', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_JvObjStr(CL: TPSPascalCompiler);
begin
  CL.AddTypeS('TDestroyEvent', 'Procedure ( Sender, AObject : TObject)');
  CL.AddTypeS('TObjectSortCompare', 'Function ( const S1, S2 : string; Item1, I'
   +'tem2 : TObject) : Integer');
  SIRegister_TJvObjectStrings(CL);
 CL.AddConstantN('MaxHugeListSize','Longint').SetInt(MaxListSize);
  CL.AddClassN(CL.FindClass('TOBJECT'),'TJvHugeList');
  SIRegister_TJvHugeList(CL);
  CL.AddTypeS('TItemSortCompare', 'Function ( Item1, Item2 : TCollectionItem) :'
   +' Integer');
  SIRegister_TJvSortCollection(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TJvHugeListItems_W(Self: TJvHugeList; const T: Pointer; const t1: Longint);
begin Self.Items[t1] := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvHugeListItems_R(Self: TJvHugeList; var T: Pointer; const t1: Longint);
begin T := Self.Items[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TJvHugeListCount_W(Self: TJvHugeList; const T: Longint);
begin Self.Count := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvHugeListCount_R(Self: TJvHugeList; var T: Longint);
begin T := Self.Count; end;

(*----------------------------------------------------------------------------*)
procedure TJvHugeListCapacity_W(Self: TJvHugeList; const T: Longint);
begin Self.Capacity := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvHugeListCapacity_R(Self: TJvHugeList; var T: Longint);
begin T := Self.Capacity; end;

(*----------------------------------------------------------------------------*)
procedure TJvObjectStringsOnDestroyObject_W(Self: TJvObjectStrings; const T: TDestroyEvent);
begin Self.OnDestroyObject := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvObjectStringsOnDestroyObject_R(Self: TJvObjectStrings; var T: TDestroyEvent);
begin T := Self.OnDestroyObject; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJvSortCollection(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJvSortCollection) do
  begin
    RegisterMethod(@TJvSortCollection.Sort, 'Sort');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJvHugeList(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJvHugeList) do begin
    RegisterMethod(@TJvHugeList.Add, 'Add');
    RegisterMethod(@TJvHugeList.Clear, 'Clear');
    RegisterMethod(@TJvHugeList.Delete, 'Delete');
    RegisterMethod(@TJvHugeList.Exchange, 'Exchange');
    RegisterMethod(@TJvHugeList.Expand, 'Expand');
    RegisterMethod(@TJvHugeList.First, 'First');
    RegisterMethod(@TJvHugeList.IndexOf, 'IndexOf');
    RegisterMethod(@TJvHugeList.Insert, 'Insert');
    RegisterMethod(@TJvHugeList.Last, 'Last');
    RegisterMethod(@TJvHugeList.Move, 'Move');
    RegisterMethod(@TJvHugeList.Remove, 'Remove');
    RegisterMethod(@TJvHugeList.Pack, 'Pack');
    RegisterPropertyHelper(@TJvHugeListCapacity_R,@TJvHugeListCapacity_W,'Capacity');
    RegisterPropertyHelper(@TJvHugeListCount_R,@TJvHugeListCount_W,'Count');
    RegisterPropertyHelper(@TJvHugeListItems_R,@TJvHugeListItems_W,'Items');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJvObjectStrings(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJvObjectStrings) do begin
    RegisterMethod(@TJvObjectStrings.Clear, 'Clear');
    RegisterMethod(@TJvObjectStrings.Delete, 'Delete');
    RegisterMethod(@TJvObjectStrings.Move, 'Move');
    RegisterMethod(@TJvObjectStrings.Remove, 'Remove');
    RegisterMethod(@TJvObjectStrings.ParseStrings, 'ParseStrings');
    RegisterMethod(@TJvObjectStrings.SortList, 'SortList');
    RegisterPropertyHelper(@TJvObjectStringsOnDestroyObject_R,@TJvObjectStringsOnDestroyObject_W,'OnDestroyObject');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_JvObjStr(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TJvObjectStrings(CL);
  with CL.Add(TJvHugeList) do
  RIRegister_TJvHugeList(CL);
  RIRegister_TJvSortCollection(CL);
end;

 
 
{ TPSImport_JvObjStr }
(*----------------------------------------------------------------------------*)
procedure TPSImport_JvObjStr.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_JvObjStr(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_JvObjStr.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_JvObjStr(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
