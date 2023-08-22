unit uPSI_VectorLists;
{
   prepare to opengl  with persistent objects  - bug in singlelist  -add constructors
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
  TPSImport_VectorLists = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TQuaternionList(CL: TPSPascalCompiler);
procedure SIRegister_TByteList(CL: TPSPascalCompiler);
procedure SIRegister_TSingleList(CL: TPSPascalCompiler);
procedure SIRegister_TXIntegerList(CL: TPSPascalCompiler);
procedure SIRegister_TTexPointList(CL: TPSPascalCompiler);
procedure SIRegister_TVectorList(CL: TPSPascalCompiler);
procedure SIRegister_TAffineVectorList(CL: TPSPascalCompiler);
procedure SIRegister_TBaseVectorList(CL: TPSPascalCompiler);
procedure SIRegister_TBaseList(CL: TPSPascalCompiler);
procedure SIRegister_VectorLists(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_VectorLists_Routines(S: TPSExec);
procedure RIRegister_TQuaternionList(CL: TPSRuntimeClassImporter);
procedure RIRegister_TByteList(CL: TPSRuntimeClassImporter);
procedure RIRegister_TSingleList(CL: TPSRuntimeClassImporter);
procedure RIRegister_TXIntegerList(CL: TPSRuntimeClassImporter);
procedure RIRegister_TTexPointList(CL: TPSRuntimeClassImporter);
procedure RIRegister_TVectorList(CL: TPSRuntimeClassImporter);
procedure RIRegister_TAffineVectorList(CL: TPSRuntimeClassImporter);
procedure RIRegister_TBaseVectorList(CL: TPSRuntimeClassImporter);
procedure RIRegister_TBaseList(CL: TPSRuntimeClassImporter);
procedure RIRegister_VectorLists(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   VectorTypes
  ,VectorGeometry
  ,PersistentClasses
  ,VectorLists
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_VectorLists]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TQuaternionList(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TBaseVectorList', 'TQuaternionList') do
  with CL.AddClassN(CL.FindClass('TBaseVectorList'),'TQuaternionList') do begin
    RegisterMethod('Constructor Create');
               RegisterMethod('Procedure Free');
    RegisterMethod('Procedure Assign( Src : TPersistent)');
    RegisterMethod('Function Add( const item : TQuaternion) : Integer;');
    RegisterMethod('Function Add1( const item : TAffineVector; w : Single) : Integer;');
    RegisterMethod('Function Add2( const x, y, z, w : Single) : Integer;');
    RegisterMethod('Procedure Push( const val : TQuaternion)');
    RegisterMethod('Function Pop : TQuaternion');
    RegisterMethod('Function IndexOf( const item : TQuaternion) : Integer');
    RegisterMethod('Function FindOrAdd( const item : TQuaternion) : Integer');
    RegisterMethod('Procedure Insert( Index : Integer; const item : TQuaternion)');
    RegisterProperty('Items', 'TQuaternion Integer', iptrw);
    SetDefaultPropery('Items');
    //RegisterProperty('List', 'PQuaternionArray', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TByteList(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TBaseList', 'TByteList') do
  with CL.AddClassN(CL.FindClass('TBaseList'),'TByteList') do begin
    RegisterMethod('Constructor Create');
     RegisterMethod('Procedure Assign( src : TPersistent)');
    RegisterMethod('Function Add( const item : Byte) : Integer');
    RegisterMethod('Procedure Insert( Index : Integer; const item : Byte)');
    RegisterProperty('Items', 'Byte Integer', iptrw);
    SetDefaultPropery('Items');
    //RegisterProperty('List', 'PByteArray', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TSingleList(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TBaseList', 'TSingleList') do
  with CL.AddClassN(CL.FindClass('TBaseList'),'TSingleList') do begin
    RegisterMethod('Constructor Create');
    RegisterMethod('Function Add( const item : Single) : Integer');
    RegisterMethod('Procedure Push( const val : Single)');
    RegisterMethod('Function Pop : Single');
    RegisterMethod('Procedure Insert( Index : Integer; const item : Single)');
    RegisterProperty('Items', 'Single Integer', iptrw);
    SetDefaultPropery('Items');
     RegisterMethod('Procedure Assign( src : TPersistent)');
    //RegisterProperty('List', 'PSingleArrayList', iptr);
    RegisterMethod('Procedure AddSerie( aBase, aDelta : Single; aCount : Integer)');
    RegisterMethod('Procedure Offset2( delta : Single);');
    RegisterMethod('Procedure Offset3( const delta : TSingleList);');
    RegisterMethod('Procedure Scale( factor : Single)');
    RegisterMethod('Procedure Sqr');
    RegisterMethod('Procedure Sqrt');
    RegisterMethod('Function Sum : Single');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TXIntegerList(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TBaseList', 'TIntegerList') do
  with CL.AddClassN(CL.FindClass('TBaseList'),'TXIntegerList') do begin
    RegisterMethod('Constructor Create');
               RegisterMethod('Procedure Free');
     RegisterMethod('Procedure Assign( src : TPersistent)');
    RegisterMethod('Function Add( const item : Integer) : Integer;');
    RegisterMethod('Function AddNC( const item : Integer) : Integer;');
    RegisterMethod('Procedure Add( const i1, i2 : Integer);');
    RegisterMethod('Procedure Add1( const i1, i2, i3 : Integer);');
    RegisterMethod('Procedure Add2( const list : TXIntegerList);');
    RegisterMethod('Procedure Push( const val : Integer)');
    RegisterMethod('Function Pop : Integer');
    RegisterMethod('Procedure Insert( index : Integer; const item : Integer)');
    RegisterMethod('Procedure Remove( const item : Integer)');
    RegisterMethod('Function IndexOf( item : Integer) : Integer');
    RegisterProperty('Items', 'Integer Integer', iptrw);
    SetDefaultPropery('Items');
    //RegisterProperty('List', 'PIntegerArray', iptr);
    RegisterMethod('Procedure AddSerie( aBase, aDelta, aCount : Integer)');
    RegisterMethod('Procedure AddIntegers( const first : PInteger; n : Integer);');
    RegisterMethod('Procedure AddIntegers1( const aList : TXIntegerList);');
    RegisterMethod('Procedure AddIntegers2( const anArray : array of Integer);');
    RegisterMethod('Function MinInteger : Integer');
    RegisterMethod('Function MaxInteger : Integer');
    RegisterMethod('Procedure Sort');
    RegisterMethod('Procedure SortAndRemoveDuplicates');
    RegisterMethod('Function BinarySearch( const value : Integer) : Integer;');
    RegisterMethod('Function BinarySearch1( const value : Integer; returnBestFit : Boolean; var found : Boolean) : Integer;');
    RegisterMethod('Function AddSorted( const value : Integer; const ignoreDuplicates : Boolean) : Integer');
    RegisterMethod('Procedure RemoveSorted( const value : Integer)');
    RegisterMethod('Procedure Offset( delta : Integer);');
    RegisterMethod('Procedure Offset1( delta : Integer; const base, nb : Integer);');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TTexPointList(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TBaseList', 'TTexPointList') do
  with CL.AddClassN(CL.FindClass('TBaseList'),'TTexPointList') do begin
    RegisterMethod('Constructor Create');
               RegisterMethod('Procedure Free');
     RegisterMethod('Procedure Assign( Src : TPersistent)');
    RegisterMethod('Function Add( const item : TTexPoint) : Integer;');
    RegisterMethod('Function Add1( const item : TVector2f) : Integer;');
    RegisterMethod('Function Add2( const texS, texT : Single) : Integer;');
    RegisterMethod('Function Add3( const texS, texT : Integer) : Integer;');
    RegisterMethod('Function AddNC( const texS, texT : Integer) : Integer;');
    RegisterMethod('Function Add( const texST : PIntegerArray) : Integer;');
    RegisterMethod('Function AddNC( const texST : PIntegerArray) : Integer;');
    RegisterMethod('Procedure Push( const val : TTexPoint)');
    RegisterMethod('Function Pop : TTexPoint');
    RegisterMethod('Procedure Insert( Index : Integer; const item : TTexPoint)');
    RegisterProperty('Items', 'TTexPoint Integer', iptrw);
    SetDefaultPropery('Items');
    //RegisterProperty('List', 'PTexPointArray', iptr);
    RegisterMethod('Procedure Translate( const delta : TTexPoint)');
    RegisterMethod('Procedure ScaleAndTranslate( const scale, delta : TTexPoint);');
    RegisterMethod('Procedure ScaleAndTranslate1( const scale, delta : TTexPoint; base, nb : Integer);');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TVectorList(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TBaseVectorList', 'TVectorList') do
  with CL.AddClassN(CL.FindClass('TBaseVectorList'),'TVectorList') do begin
    RegisterMethod('Constructor Create');
     RegisterMethod('Procedure Free');
     RegisterMethod('Procedure Assign( Src : TPersistent)');
    RegisterMethod('Function Add( const item : TVector) : Integer;');
    RegisterMethod('Function Add1( const item : TAffineVector; w : Single) : Integer;');
    RegisterMethod('Function Add2( const x, y, z, w : Single) : Integer;');
    RegisterMethod('Procedure Add3( const i1, i2, i3 : TAffineVector; w : Single);');
    RegisterMethod('Function AddVector( const item : TAffineVector) : Integer;');
    RegisterMethod('Function AddPoint( const item : TAffineVector) : Integer;');
    RegisterMethod('Function AddPoint1( const x, y : Single; const z : Single) : Integer;');
    RegisterMethod('Procedure Push( const val : TVector)');
    RegisterMethod('Function Pop : TVector');
    RegisterMethod('Function IndexOf( const item : TVector) : Integer');
    RegisterMethod('Function FindOrAdd( const item : TVector) : Integer');
    RegisterMethod('Function FindOrAddPoint( const item : TAffineVector) : Integer');
    RegisterMethod('Procedure Insert( Index : Integer; const item : TVector)');
    RegisterProperty('Items', 'TVector Integer', iptrw);
    SetDefaultPropery('Items');
    //RegisterProperty('List', 'PVectorArray', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TAffineVectorList(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TBaseVectorList', 'TAffineVectorList') do
  with CL.AddClassN(CL.FindClass('TBaseVectorList'),'TAffineVectorList') do begin
    RegisterMethod('Constructor Create');
               RegisterMethod('Procedure Free');
     RegisterMethod('Procedure Assign( Src : TPersistent)');
    RegisterMethod('Function Add( const item : TAffineVector) : Integer;');
    RegisterMethod('Function Add1( const item : TVector) : Integer;');
    RegisterMethod('Procedure Add2( const i1, i2 : TAffineVector);');
    RegisterMethod('Procedure Add3( const i1, i2, i3 : TAffineVector);');
    RegisterMethod('Function Add4( const item : TVector2f) : Integer;');
    RegisterMethod('Function Add5( const item : TTexPoint) : Integer;');
    RegisterMethod('Function Add6( const x, y : Single) : Integer;');
    RegisterMethod('Function Add7( const x, y, z : Single) : Integer;');
    RegisterMethod('Function Add8( const x, y, z : Integer) : Integer;');
    RegisterMethod('Function AddNC( const x, y, z : Integer) : Integer;');
    RegisterMethod('Function Add( const xy : PIntegerArray; const z : Integer) : Integer;');
    RegisterMethod('Function AddNC( const xy : PIntegerArray; const z : Integer) : Integer;');
    RegisterMethod('Procedure Add( const list : TAffineVectorList);');
    RegisterMethod('Procedure Push( const val : TAffineVector)');
    RegisterMethod('Function Pop : TAffineVector');
    RegisterMethod('Procedure Insert( Index : Integer; const item : TAffineVector)');
    RegisterMethod('Function IndexOf( const item : TAffineVector) : Integer');
    RegisterMethod('Function FindOrAdd( const item : TAffineVector) : Integer');
    RegisterProperty('Items', 'TAffineVector Integer', iptrw);
    SetDefaultPropery('Items');
    //RegisterProperty('List', 'PAffineVectorArray', iptr);
    RegisterMethod('Procedure Translate1( const delta : TAffineVector; base, nb : Integer);');
    RegisterMethod('Procedure TranslateItem( index : Integer; const delta : TAffineVector)');
    RegisterMethod('Procedure TranslateItems( index : Integer; const delta : TAffineVector; nb : Integer)');
    RegisterMethod('Procedure CombineItem( index : Integer; const vector : TAffineVector; const f : Single)');
    RegisterMethod('Procedure TransformAsPoints( const matrix : TMatrix)');
    RegisterMethod('Procedure TransformAsVectors( const matrix : TMatrix);');
    RegisterMethod('Procedure TransformAsVectors1( const matrix : TAffineMatrix);');
    RegisterMethod('Procedure Scale( factor : Single);');
    RegisterMethod('Procedure Scale1( const factors : TAffineVector);');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TBaseVectorList(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TBaseList', 'TBaseVectorList') do
  with CL.AddClassN(CL.FindClass('TBaseList'),'TBaseVectorList') do begin
    RegisterMethod('Procedure WriteToFiler( writer : TVirtualWriter)');
    RegisterMethod('Procedure ReadFromFiler( reader : TVirtualReader)');
    RegisterMethod('Procedure GetExtents( var min, max : TAffineVector)');
    RegisterMethod('Function Sum : TAffineVector');
    RegisterMethod('Procedure Normalize');
    RegisterMethod('Function MaxSpacing( list2 : TBaseVectorList) : Single');
    RegisterMethod('Procedure Translate( const delta : TAffineVector);');
    RegisterMethod('Procedure Translate1( const delta : TBaseVectorList);');
    RegisterMethod('Procedure TranslateInv( const delta : TBaseVectorList);');
    RegisterMethod('Procedure Lerp( const list1, list2 : TBaseVectorList; lerpFactor : Single)');
    RegisterMethod('Procedure AngleLerp( const list1, list2 : TBaseVectorList; lerpFactor : Single)');
    RegisterMethod('Procedure AngleCombine( const list1 : TBaseVectorList; intensity : Single)');
    RegisterMethod('Procedure Combine( const list2 : TBaseVectorList; factor : Single)');
    //RegisterProperty('ItemAddress', 'PFloatArray Integer', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TBaseList(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TPersistentObject', 'TBaseList') do
  with CL.AddClassN(CL.FindClass('TPersistentObject'),'TBaseList') do begin
    RegisterMethod('Constructor Create');
       RegisterMethod('Procedure Free');
     RegisterMethod('Procedure Assign( Src : TPersistent)');
    RegisterMethod('Procedure WriteToFiler( writer : TVirtualWriter)');
    RegisterMethod('Procedure ReadFromFiler( reader : TVirtualReader)');
    RegisterMethod('Procedure AddNulls( nbVals : Cardinal)');
    RegisterMethod('Procedure InsertNulls( index : Integer; nbVals : Cardinal)');
    RegisterMethod('Procedure AdjustCapacityToAtLeast( const size : Integer)');
    RegisterMethod('Function DataSize : Integer');
    RegisterMethod('Procedure UseMemory( rangeStart : Pointer; rangeCapacity : Integer)');
    RegisterMethod('Procedure Flush');
    RegisterMethod('Procedure Clear');
    RegisterMethod('Procedure Delete( index : Integer)');
    RegisterMethod('Procedure DeleteItems( index : Integer; nbVals : Cardinal)');
    RegisterMethod('Procedure Exchange( index1, index2 : Integer)');
    RegisterMethod('Procedure Move( curIndex, newIndex : Integer)');
    RegisterMethod('Procedure Reverse');
    RegisterProperty('Count', 'Integer', iptrw);
    RegisterProperty('Capacity', 'Integer', iptrw);
    RegisterProperty('GrowthDelta', 'Integer', iptrw);
    RegisterProperty('SetCountResetsMemory', 'Boolean', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_VectorLists(CL: TPSPascalCompiler);
begin
  CL.AddTypeS('TBaseListOption', '( bloExternalMemory, bloSetCountResetsMemory)');
  CL.AddTypeS('TBaseListOptions', 'set of TBaseListOption');
  CL.AddTypeS('TTexPoint', 'record s: single; t: single; end');
  SIRegister_TBaseList(CL);
  SIRegister_TBaseVectorList(CL);
  SIRegister_TAffineVectorList(CL);
  SIRegister_TVectorList(CL);
  SIRegister_TTexPointList(CL);
  SIRegister_TXIntegerList(CL);
  //CL.AddTypeS('PSingleArrayList', '^TSingleArrayList // will not work');
  SIRegister_TSingleList(CL);
  SIRegister_TByteList(CL);
  SIRegister_TQuaternionList(CL);
 CL.AddDelphiFunction('Procedure QuickSortLists( startIndex, endIndex : Integer; refList : TSingleList; objList : TList);');
 CL.AddDelphiFunction('Procedure QuickSortLists1( startIndex, endIndex : Integer; refList : TSingleList; objList : TBaseList);');
 CL.AddDelphiFunction('Procedure FastQuickSortLists( startIndex, endIndex : Integer; refList : TSingleList; objList : TPersistentObjectList)');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
Procedure QuickSortLists1_P( startIndex, endIndex : Integer; refList : TSingleList; objList : TBaseList);
Begin VectorLists.QuickSortLists(startIndex, endIndex, refList, objList); END;

(*----------------------------------------------------------------------------*)
Procedure QuickSortLists_P( startIndex, endIndex : Integer; refList : TSingleList; objList : TList);
Begin VectorLists.QuickSortLists(startIndex, endIndex, refList, objList); END;

(*----------------------------------------------------------------------------*)
procedure TQuaternionListList_R(Self: TQuaternionList; var T: PQuaternionArray);
begin T := Self.List; end;

(*----------------------------------------------------------------------------*)
procedure TQuaternionListItems_W(Self: TQuaternionList; const T: TQuaternion; const t1: Integer);
begin Self.Items[t1] := T; end;

(*----------------------------------------------------------------------------*)
procedure TQuaternionListItems_R(Self: TQuaternionList; var T: TQuaternion; const t1: Integer);
begin T := Self.Items[t1]; end;

(*----------------------------------------------------------------------------*)
Function TQuaternionListAdd2_P(Self: TQuaternionList;  const x, y, z, w : Single) : Integer;
Begin Result := Self.Add(x, y, z, w); END;

(*----------------------------------------------------------------------------*)
Function TQuaternionListAdd1_P(Self: TQuaternionList;  const item : TAffineVector; w : Single) : Integer;
Begin Result := Self.Add(item, w); END;

(*----------------------------------------------------------------------------*)
Function TQuaternionListAdd_P(Self: TQuaternionList;  const item : TQuaternion) : Integer;
Begin Result := Self.Add(item); END;

(*----------------------------------------------------------------------------*)
procedure TByteListList_R(Self: TByteList; var T: PByteArray);
begin //T := Self.List;
end;

(*----------------------------------------------------------------------------*)
procedure TByteListItems_W(Self: TByteList; const T: Byte; const t1: Integer);
begin Self.Items[t1] := T; end;

(*----------------------------------------------------------------------------*)
procedure TByteListItems_R(Self: TByteList; var T: Byte; const t1: Integer);
begin T := Self.Items[t1]; end;

(*----------------------------------------------------------------------------*)
Procedure TSingleListOffset3_P(Self: TSingleList;  const delta : TSingleList);
Begin Self.Offset(delta); END;

(*----------------------------------------------------------------------------*)
Procedure TSingleListOffset2_P(Self: TSingleList;  delta : Single);
Begin Self.Offset(delta); END;

(*----------------------------------------------------------------------------*)
procedure TSingleListList_R(Self: TSingleList; var T: PSingleArrayList);
begin T := Self.List; end;

(*----------------------------------------------------------------------------*)
procedure TSingleListItems_W(Self: TSingleList; const T: Single; const t1: Integer);
begin Self.Items[t1] := T; end;

(*----------------------------------------------------------------------------*)
procedure TSingleListItems_R(Self: TSingleList; var T: Single; const t1: Integer);
begin T := Self.Items[t1]; end;

(*----------------------------------------------------------------------------*)
Procedure TIntegerListOffset1_P(Self: TXIntegerList;  delta : Integer; const base, nb : Integer);
Begin Self.Offset(delta, base, nb); END;

(*----------------------------------------------------------------------------*)
Procedure TIntegerListOffset_P(Self: TXIntegerList;  delta : Integer);
Begin Self.Offset(delta); END;

(*----------------------------------------------------------------------------*)
Function TIntegerListBinarySearch1_P(Self: TXIntegerList;  const value : Integer; returnBestFit : Boolean; var found : Boolean) : Integer;
Begin Result := Self.BinarySearch(value, returnBestFit, found); END;

(*----------------------------------------------------------------------------*)
Function TIntegerListBinarySearch_P(Self: TXIntegerList;  const value : Integer) : Integer;
Begin Result := Self.BinarySearch(value); END;

(*----------------------------------------------------------------------------*)
Procedure TIntegerListAddIntegers2_P(Self: TXIntegerList;  const anArray : array of Integer);
Begin Self.AddIntegers(anArray); END;

(*----------------------------------------------------------------------------*)
Procedure TIntegerListAddIntegers1_P(Self: TXIntegerList;  const aList : TXIntegerList);
Begin Self.AddIntegers(aList); END;

(*----------------------------------------------------------------------------*)
Procedure TIntegerListAddIntegers_P(Self: TXIntegerList;  const first : PInteger; n : Integer);
Begin Self.AddIntegers(first, n); END;

(*----------------------------------------------------------------------------*)
procedure TIntegerListList_R(Self: TXIntegerList; var T: PIntegerArray);
begin T := Self.List; end;

(*----------------------------------------------------------------------------*)
procedure TIntegerListItems_W(Self: TXIntegerList; const T: Integer; const t1: Integer);
begin Self.Items[t1] := T; end;

(*----------------------------------------------------------------------------*)
procedure TIntegerListItems_R(Self: TXIntegerList; var T: Integer; const t1: Integer);
begin T := Self.Items[t1]; end;

(*----------------------------------------------------------------------------*)
Procedure TIntegerListAdd2_P(Self: TXIntegerList;  const list : TXIntegerList);
Begin Self.Add(list); END;

(*----------------------------------------------------------------------------*)
Procedure TIntegerListAdd1_P(Self: TXIntegerList;  const i1, i2, i3 : Integer);
Begin Self.Add(i1, i2, i3); END;

(*----------------------------------------------------------------------------*)
Procedure TIntegerListAdd_P(Self: TXIntegerList;  const i1, i2 : Integer);
Begin Self.Add(i1, i2); END;

(*----------------------------------------------------------------------------*)
Function TIntegerListAddNC_P(Self: TXIntegerList;  const item : Integer) : Integer;
Begin Result := Self.AddNC(item); END;

(*----------------------------------------------------------------------------*)
Function TIntegerListAdd(Self: TXIntegerList;  const item : Integer) : Integer;
Begin Result := Self.Add(item); END;

(*----------------------------------------------------------------------------*)
Procedure TTexPointListScaleAndTranslate1_P(Self: TTexPointList;  const scale, delta : TTexPoint; base, nb : Integer);
Begin Self.ScaleAndTranslate(scale, delta, base, nb); END;

(*----------------------------------------------------------------------------*)
Procedure TTexPointListScaleAndTranslate_P(Self: TTexPointList;  const scale, delta : TTexPoint);
Begin Self.ScaleAndTranslate(scale, delta); END;

(*----------------------------------------------------------------------------*)
procedure TTexPointListList_R(Self: TTexPointList; var T: PTexPointArray);
begin T := Self.List; end;

(*----------------------------------------------------------------------------*)
procedure TTexPointListItems_W(Self: TTexPointList; const T: TTexPoint; const t1: Integer);
begin Self.Items[t1] := T; end;

(*----------------------------------------------------------------------------*)
procedure TTexPointListItems_R(Self: TTexPointList; var T: TTexPoint; const t1: Integer);
begin T := Self.Items[t1]; end;

(*----------------------------------------------------------------------------*)
Function TTexPointListAddNC_P(Self: TTexPointList;  const texST : PIntegerArray) : Integer;
Begin Result := Self.AddNC(texST); END;

(*----------------------------------------------------------------------------*)
Function TTexPointListAdd_P(Self: TTexPointList;  const texST : PIntegerArray) : Integer;
Begin Result := Self.Add(texST); END;

(*----------------------------------------------------------------------------*)
Function TTexPointListAddNC(Self: TTexPointList;  const texS, texT : Integer) : Integer;
Begin Result := Self.AddNC(texS, texT); END;

(*----------------------------------------------------------------------------*)
Function TTexPointListAdd3_P(Self: TTexPointList;  const texS, texT : Integer) : Integer;
Begin Result := Self.Add(texS, texT); END;

(*----------------------------------------------------------------------------*)
Function TTexPointListAdd2_P(Self: TTexPointList;  const texS, texT : Single) : Integer;
Begin Result := Self.Add(texS, texT); END;

(*----------------------------------------------------------------------------*)
Function TTexPointListAdd1_P(Self: TTexPointList;  const item : TVector2f) : Integer;
Begin Result := Self.Add(item); END;

(*----------------------------------------------------------------------------*)
Function TTexPointListAdd(Self: TTexPointList;  const item : TTexPoint) : Integer;
Begin Result := Self.Add(item); END;

(*----------------------------------------------------------------------------*)
procedure TVectorListList_R(Self: TVectorList; var T: PVectorArray);
begin T := Self.List; end;

(*----------------------------------------------------------------------------*)
procedure TVectorListItems_W(Self: TVectorList; const T: TVector; const t1: Integer);
begin Self.Items[t1] := T; end;

(*----------------------------------------------------------------------------*)
procedure TVectorListItems_R(Self: TVectorList; var T: TVector; const t1: Integer);
begin T := Self.Items[t1]; end;

(*----------------------------------------------------------------------------*)
Function TVectorListAddPoint1_P(Self: TVectorList;  const x, y : Single; const z : Single) : Integer;
Begin Result := Self.AddPoint(x, y, z); END;

(*----------------------------------------------------------------------------*)
Function TVectorListAddPoint_P(Self: TVectorList;  const item : TAffineVector) : Integer;
Begin Result := Self.AddPoint(item); END;

(*----------------------------------------------------------------------------*)
Function TVectorListAddVector_P(Self: TVectorList;  const item : TAffineVector) : Integer;
Begin Result := Self.AddVector(item); END;

(*----------------------------------------------------------------------------*)
Procedure TVectorListAdd3_P(Self: TVectorList;  const i1, i2, i3 : TAffineVector; w : Single);
Begin Self.Add(i1, i2, i3, w); END;

(*----------------------------------------------------------------------------*)
Function TVectorListAdd2_P(Self: TVectorList;  const x, y, z, w : Single) : Integer;
Begin Result := Self.Add(x, y, z, w); END;

(*----------------------------------------------------------------------------*)
Function TVectorListAdd1_P(Self: TVectorList;  const item : TAffineVector; w : Single) : Integer;
Begin Result := Self.Add(item, w); END;

(*----------------------------------------------------------------------------*)
Function TVectorListAdd_P(Self: TVectorList;  const item : TVector) : Integer;
Begin Result := Self.Add(item); END;

(*----------------------------------------------------------------------------*)
Procedure TAffineVectorListScale1_P(Self: TAffineVectorList;  const factors : TAffineVector);
Begin Self.Scale(factors); END;

(*----------------------------------------------------------------------------*)
Procedure TAffineVectorListScale_P(Self: TAffineVectorList;  factor : Single);
Begin Self.Scale(factor); END;

(*----------------------------------------------------------------------------*)
Procedure TAffineVectorListTransformAsVectors1_P(Self: TAffineVectorList;  const matrix : TAffineMatrix);
Begin Self.TransformAsVectors(matrix); END;

(*----------------------------------------------------------------------------*)
Procedure TAffineVectorListTransformAsVectors_P(Self: TAffineVectorList;  const matrix : TMatrix);
Begin Self.TransformAsVectors(matrix); END;

(*----------------------------------------------------------------------------*)
Procedure TAffineVectorListTranslate1_P(Self: TAffineVectorList;  const delta : TAffineVector; base, nb : Integer);
Begin Self.Translate(delta, base, nb); END;

(*----------------------------------------------------------------------------*)
Procedure TAffineVectorListTranslate_P(Self: TAffineVectorList;  const delta : TAffineVector);
Begin Self.Translate(delta); END;

(*----------------------------------------------------------------------------*)
procedure TAffineVectorListList_R(Self: TAffineVectorList; var T: PAffineVectorArray);
begin T := Self.List; end;

(*----------------------------------------------------------------------------*)
procedure TAffineVectorListItems_W(Self: TAffineVectorList; const T: TAffineVector; const t1: Integer);
begin Self.Items[t1] := T; end;

(*----------------------------------------------------------------------------*)
procedure TAffineVectorListItems_R(Self: TAffineVectorList; var T: TAffineVector; const t1: Integer);
begin T := Self.Items[t1]; end;

(*----------------------------------------------------------------------------*)
Procedure TAffineVectorListAdd_P(Self: TAffineVectorList;  const list : TAffineVectorList);
Begin Self.Add(list); END;

(*----------------------------------------------------------------------------*)
Function TAffineVectorListAddNC_P(Self: TAffineVectorList;  const xy : PIntegerArray; const z : Integer) : Integer;
Begin Result := Self.AddNC(xy, z); END;

(*----------------------------------------------------------------------------*)
Function TAffineVectorListAdd(Self: TAffineVectorList;  const xy : PIntegerArray; const z : Integer) : Integer;
Begin Result := Self.Add(xy, z); END;

(*----------------------------------------------------------------------------*)
Function TAffineVectorListAddNC(Self: TAffineVectorList;  const x, y, z : Integer) : Integer;
Begin Result := Self.AddNC(x, y, z); END;

(*----------------------------------------------------------------------------*)
Function TAffineVectorListAdd8_P(Self: TAffineVectorList;  const x, y, z : Integer) : Integer;
Begin Result := Self.Add(x, y, z); END;

(*----------------------------------------------------------------------------*)
Function TAffineVectorListAdd7_P(Self: TAffineVectorList;  const x, y, z : Single) : Integer;
Begin Result := Self.Add(x, y, z); END;

(*----------------------------------------------------------------------------*)
Function TAffineVectorListAdd6_P(Self: TAffineVectorList;  const x, y : Single) : Integer;
Begin Result := Self.Add(x, y); END;

(*----------------------------------------------------------------------------*)
Function TAffineVectorListAdd5_P(Self: TAffineVectorList;  const item : TTexPoint) : Integer;
Begin Result := Self.Add(item); END;

(*----------------------------------------------------------------------------*)
Function TAffineVectorListAdd4_P(Self: TAffineVectorList;  const item : TVector2f) : Integer;
Begin Result := Self.Add(item); END;

(*----------------------------------------------------------------------------*)
Procedure TAffineVectorListAdd3_P(Self: TAffineVectorList;  const i1, i2, i3 : TAffineVector);
Begin Self.Add(i1, i2, i3); END;

(*----------------------------------------------------------------------------*)
Procedure TAffineVectorListAdd2_P(Self: TAffineVectorList;  const i1, i2 : TAffineVector);
Begin Self.Add(i1, i2); END;

(*----------------------------------------------------------------------------*)
Function TAffineVectorListAdd1_P(Self: TAffineVectorList;  const item : TVector) : Integer;
Begin Result := Self.Add(item); END;

(*----------------------------------------------------------------------------*)
Function TAffineVectorListAddP(Self: TAffineVectorList;  const item : TAffineVector) : Integer;
Begin Result := Self.Add(item); END;

(*----------------------------------------------------------------------------*)
procedure TBaseVectorListItemAddress_R(Self: TBaseVectorList; var T: PFloatArray; const t1: Integer);
begin T := Self.ItemAddress[t1]; end;

(*----------------------------------------------------------------------------*)
Procedure TBaseVectorListTranslateInv_P(Self: TBaseVectorList;  const delta : TBaseVectorList);
Begin Self.TranslateInv(delta); END;

(*----------------------------------------------------------------------------*)
Procedure TBaseVectorListTranslate1_P(Self: TBaseVectorList;  const delta : TBaseVectorList);
Begin Self.Translate(delta); END;

(*----------------------------------------------------------------------------*)
Procedure TBaseVectorListTranslate_P(Self: TBaseVectorList;  const delta : TAffineVector);
Begin Self.Translate(delta); END;

(*----------------------------------------------------------------------------*)
procedure TBaseListSetCountResetsMemory_W(Self: TBaseList; const T: Boolean);
begin Self.SetCountResetsMemory := T; end;

(*----------------------------------------------------------------------------*)
procedure TBaseListSetCountResetsMemory_R(Self: TBaseList; var T: Boolean);
begin T := Self.SetCountResetsMemory; end;

(*----------------------------------------------------------------------------*)
procedure TBaseListGrowthDelta_W(Self: TBaseList; const T: Integer);
begin Self.GrowthDelta := T; end;

(*----------------------------------------------------------------------------*)
procedure TBaseListGrowthDelta_R(Self: TBaseList; var T: Integer);
begin T := Self.GrowthDelta; end;

(*----------------------------------------------------------------------------*)
procedure TBaseListCapacity_W(Self: TBaseList; const T: Integer);
begin Self.Capacity := T; end;

(*----------------------------------------------------------------------------*)
procedure TBaseListCapacity_R(Self: TBaseList; var T: Integer);
begin T := Self.Capacity; end;

(*----------------------------------------------------------------------------*)
procedure TBaseListCount_W(Self: TBaseList; const T: Integer);
begin Self.Count := T; end;

(*----------------------------------------------------------------------------*)
procedure TBaseListCount_R(Self: TBaseList; var T: Integer);
begin T := Self.Count; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_VectorLists_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@QuickSortLists, 'QuickSortLists', cdRegister);
 S.RegisterDelphiFunction(@QuickSortLists1_P, 'QuickSortLists1', cdRegister);
 S.RegisterDelphiFunction(@FastQuickSortLists, 'FastQuickSortLists', cdRegister);
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TQuaternionList(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TQuaternionList) do begin
    RegisterConstructor(@TQuaternionList.Create, 'Create');
       RegisterMethod(@TQuaternionList.Destroy, 'Free');
       RegisterMethod(@TQuaternionList.Assign, 'Assign');
    RegisterMethod(@TQuaternionListAdd_P, 'Add');
    RegisterMethod(@TQuaternionListAdd1_P, 'Add1');
    RegisterMethod(@TQuaternionListAdd2_P, 'Add2');
    RegisterMethod(@TQuaternionList.Push, 'Push');
    RegisterMethod(@TQuaternionList.Pop, 'Pop');
    RegisterMethod(@TQuaternionList.IndexOf, 'IndexOf');
    RegisterMethod(@TQuaternionList.FindOrAdd, 'FindOrAdd');
    RegisterMethod(@TQuaternionList.Insert, 'Insert');
    RegisterPropertyHelper(@TQuaternionListItems_R,@TQuaternionListItems_W,'Items');
    RegisterPropertyHelper(@TQuaternionListList_R,nil,'List');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TByteList(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TByteList) do begin
  RegisterConstructor(@TByteList.Create, 'Create');
    RegisterMethod(@TByteList.Add, 'Add');
    RegisterMethod(@TByteList.Assign, 'Assign');
    RegisterMethod(@TByteList.Insert, 'Insert');
    RegisterPropertyHelper(@TByteListItems_R,@TByteListItems_W,'Items');
    RegisterPropertyHelper(@TByteListList_R,nil,'List');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TSingleList(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TSingleList) do begin
    RegisterConstructor(@TSingleList.Create, 'Create');
    RegisterMethod(@TSingleList.Add, 'Add');
    RegisterMethod(@TSingleList.Push, 'Push');
    RegisterMethod(@TSingleList.Pop, 'Pop');
    RegisterMethod(@TSingleList.Assign, 'Assign');
    RegisterMethod(@TSingleList.Insert, 'Insert');
    RegisterPropertyHelper(@TSingleListItems_R,@TSingleListItems_W,'Items');
    RegisterPropertyHelper(@TSingleListList_R,nil,'List');
    RegisterMethod(@TSingleList.AddSerie, 'AddSerie');
    RegisterMethod(@TSingleListOffset2_P, 'Offset2');
    RegisterMethod(@TSingleListOffset3_P, 'Offset3');
    RegisterMethod(@TSingleList.Scale, 'Scale');
    RegisterMethod(@TSingleList.Sqr, 'Sqr');
    RegisterMethod(@TSingleList.Sqrt, 'Sqrt');
    RegisterMethod(@TSingleList.Sum, 'Sum');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TXIntegerList(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TXIntegerList) do begin
    RegisterConstructor(@TXIntegerList.Create, 'Create');
         RegisterMethod(@TXIntegerList.Destroy, 'Free');
      RegisterMethod(@TXIntegerList.Assign, 'Assign');
    RegisterMethod(@TIntegerListAdd_P, 'Add');
    RegisterMethod(@TIntegerListAddNC_P, 'AddNC');
    RegisterMethod(@TIntegerListAdd_P, 'Add');
    RegisterMethod(@TIntegerListAdd1_P, 'Add1');
    RegisterMethod(@TIntegerListAdd2_P, 'Add2');
    RegisterMethod(@TXIntegerList.Push, 'Push');
    RegisterMethod(@TXIntegerList.Pop, 'Pop');
    RegisterMethod(@TXIntegerList.Insert, 'Insert');
    RegisterMethod(@TXIntegerList.Remove, 'Remove');
    RegisterMethod(@TXIntegerList.IndexOf, 'IndexOf');
    RegisterPropertyHelper(@TIntegerListItems_R,@TIntegerListItems_W,'Items');
    RegisterPropertyHelper(@TIntegerListList_R,nil,'List');
    RegisterMethod(@TXIntegerList.AddSerie, 'AddSerie');
    RegisterMethod(@TIntegerListAddIntegers_P, 'AddIntegers');
    RegisterMethod(@TIntegerListAddIntegers1_P, 'AddIntegers1');
    RegisterMethod(@TIntegerListAddIntegers2_P, 'AddIntegers2');
    RegisterMethod(@TXIntegerList.MinInteger, 'MinInteger');
    RegisterMethod(@TXIntegerList.MaxInteger, 'MaxInteger');
    RegisterMethod(@TXIntegerList.Sort, 'Sort');
    RegisterMethod(@TXIntegerList.SortAndRemoveDuplicates, 'SortAndRemoveDuplicates');
    RegisterMethod(@TIntegerListBinarySearch_P, 'BinarySearch');
    RegisterMethod(@TIntegerListBinarySearch1_P, 'BinarySearch1');
    RegisterMethod(@TXIntegerList.AddSorted, 'AddSorted');
    RegisterMethod(@TXIntegerList.RemoveSorted, 'RemoveSorted');
    RegisterMethod(@TIntegerListOffset_P, 'Offset');
    RegisterMethod(@TIntegerListOffset1_P, 'Offset1');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TTexPointList(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TTexPointList) do begin
    RegisterConstructor(@TTexPointList.Create, 'Create');
         RegisterMethod(@TTexPointList.Destroy, 'Free');
      RegisterMethod(@TTexPointList.Assign, 'Assign');
    RegisterMethod(@TTexPointListAdd_P, 'Add');
    RegisterMethod(@TTexPointListAdd1_P, 'Add1');
    RegisterMethod(@TTexPointListAdd2_P, 'Add2');
    RegisterMethod(@TTexPointListAdd3_P, 'Add3');
    RegisterMethod(@TTexPointListAddNC_P, 'AddNC');
    RegisterMethod(@TTexPointListAdd_P, 'Add');
    RegisterMethod(@TTexPointListAddNC_P, 'AddNC');
    RegisterMethod(@TTexPointList.Push, 'Push');
    RegisterMethod(@TTexPointList.Pop, 'Pop');
    RegisterMethod(@TTexPointList.Insert, 'Insert');
    RegisterPropertyHelper(@TTexPointListItems_R,@TTexPointListItems_W,'Items');
    RegisterPropertyHelper(@TTexPointListList_R,nil,'List');
    RegisterMethod(@TTexPointList.Translate, 'Translate');
    RegisterMethod(@TTexPointListScaleAndTranslate_P, 'ScaleAndTranslate');
    RegisterMethod(@TTexPointListScaleAndTranslate1_P, 'ScaleAndTranslate1');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TVectorList(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TVectorList) do begin
    RegisterConstructor(@TVectorList.Create, 'Create');
         RegisterMethod(@TVectorList.Destroy, 'Free');
      RegisterMethod(@TVectorList.Assign, 'Assign');
    RegisterMethod(@TVectorListAdd_P, 'Add');
    RegisterMethod(@TVectorListAdd1_P, 'Add1');
    RegisterMethod(@TVectorListAdd2_P, 'Add2');
    RegisterMethod(@TVectorListAdd3_P, 'Add3');
    RegisterMethod(@TVectorListAddVector_P, 'AddVector');
    RegisterMethod(@TVectorListAddPoint_P, 'AddPoint');
    RegisterMethod(@TVectorListAddPoint1_P, 'AddPoint1');
    RegisterMethod(@TVectorList.Push, 'Push');
    RegisterMethod(@TVectorList.Pop, 'Pop');
    RegisterMethod(@TVectorList.IndexOf, 'IndexOf');
    RegisterMethod(@TVectorList.FindOrAdd, 'FindOrAdd');
    RegisterMethod(@TVectorList.FindOrAddPoint, 'FindOrAddPoint');
    RegisterMethod(@TVectorList.Insert, 'Insert');
    RegisterPropertyHelper(@TVectorListItems_R,@TVectorListItems_W,'Items');
    RegisterPropertyHelper(@TVectorListList_R,nil,'List');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TAffineVectorList(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TAffineVectorList) do begin
    RegisterConstructor(@TAffineVectorList.Create, 'Create');
         RegisterMethod(@TAffineVectorList.Destroy, 'Free');
      RegisterMethod(@TAffineVectorList.Assign, 'Assign');
    RegisterMethod(@TAffineVectorListAdd_P, 'Add');
    RegisterMethod(@TAffineVectorListAdd1_P, 'Add1');
    RegisterMethod(@TAffineVectorListAdd2_P, 'Add2');
    RegisterMethod(@TAffineVectorListAdd3_P, 'Add3');
    RegisterMethod(@TAffineVectorListAdd4_P, 'Add4');
    RegisterMethod(@TAffineVectorListAdd5_P, 'Add5');
    RegisterMethod(@TAffineVectorListAdd6_P, 'Add6');
    RegisterMethod(@TAffineVectorListAdd7_P, 'Add7');
    RegisterMethod(@TAffineVectorListAdd8_P, 'Add8');
    RegisterMethod(@TAffineVectorListAddNC_P, 'AddNC');
    RegisterMethod(@TAffineVectorListAdd_P, 'Add');
    RegisterMethod(@TAffineVectorListAddNC_P, 'AddNC');
    RegisterMethod(@TAffineVectorListAdd_P, 'Add');
    RegisterMethod(@TAffineVectorList.Push, 'Push');
    RegisterMethod(@TAffineVectorList.Pop, 'Pop');
    RegisterMethod(@TAffineVectorList.Insert, 'Insert');
    RegisterMethod(@TAffineVectorList.IndexOf, 'IndexOf');
    RegisterMethod(@TAffineVectorList.FindOrAdd, 'FindOrAdd');
    RegisterPropertyHelper(@TAffineVectorListItems_R,@TAffineVectorListItems_W,'Items');
    RegisterPropertyHelper(@TAffineVectorListList_R,nil,'List');
    RegisterMethod(@TAffineVectorListTranslate1_P, 'Translate1');
    RegisterMethod(@TAffineVectorList.TranslateItem, 'TranslateItem');
    RegisterMethod(@TAffineVectorList.TranslateItems, 'TranslateItems');
    RegisterMethod(@TAffineVectorList.CombineItem, 'CombineItem');
    RegisterMethod(@TAffineVectorList.TransformAsPoints, 'TransformAsPoints');
    RegisterMethod(@TAffineVectorListTransformAsVectors_P, 'TransformAsVectors');
    RegisterMethod(@TAffineVectorListTransformAsVectors1_P, 'TransformAsVectors1');
    RegisterMethod(@TAffineVectorListScale_P, 'Scale');
    RegisterMethod(@TAffineVectorListScale1_P, 'Scale1');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TBaseVectorList(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TBaseVectorList) do begin
    RegisterMethod(@TBaseVectorList.WriteToFiler, 'WriteToFiler');
    RegisterMethod(@TBaseVectorList.ReadFromFiler, 'ReadFromFiler');
    RegisterVirtualMethod(@TBaseVectorList.GetExtents, 'GetExtents');
    RegisterVirtualMethod(@TBaseVectorList.Sum, 'Sum');
    RegisterVirtualMethod(@TBaseVectorList.Normalize, 'Normalize');
    RegisterVirtualMethod(@TBaseVectorList.MaxSpacing, 'MaxSpacing');
    RegisterVirtualMethod(@TBaseVectorListTranslate_P, 'Translate');
    RegisterVirtualMethod(@TBaseVectorListTranslate1_P, 'Translate1');
    RegisterVirtualMethod(@TBaseVectorListTranslateInv_P, 'TranslateInv');
    //RegisterVirtualAbstractMethod(@TBaseVectorList, @!.Lerp, 'Lerp');
    RegisterMethod(@TBaseVectorList.AngleLerp, 'AngleLerp');
    RegisterMethod(@TBaseVectorList.AngleCombine, 'AngleCombine');
    RegisterVirtualMethod(@TBaseVectorList.Combine, 'Combine');
    RegisterPropertyHelper(@TBaseVectorListItemAddress_R,nil,'ItemAddress');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TBaseList(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TBaseList) do begin
    RegisterConstructor(@TBaseList.Create, 'Create');
         RegisterMethod(@TBaseList.Destroy, 'Free');
      RegisterMethod(@TBaseList.Assign, 'Assign');
    RegisterMethod(@TBaseList.WriteToFiler, 'WriteToFiler');
    RegisterMethod(@TBaseList.ReadFromFiler, 'ReadFromFiler');
    RegisterMethod(@TBaseList.AddNulls, 'AddNulls');
    RegisterMethod(@TBaseList.InsertNulls, 'InsertNulls');
    RegisterMethod(@TBaseList.AdjustCapacityToAtLeast, 'AdjustCapacityToAtLeast');
    RegisterMethod(@TBaseList.DataSize, 'DataSize');
    RegisterMethod(@TBaseList.UseMemory, 'UseMemory');
    RegisterMethod(@TBaseList.Flush, 'Flush');
    RegisterMethod(@TBaseList.Clear, 'Clear');
    RegisterMethod(@TBaseList.Delete, 'Delete');
    RegisterMethod(@TBaseList.DeleteItems, 'DeleteItems');
    RegisterMethod(@TBaseList.Exchange, 'Exchange');
    RegisterMethod(@TBaseList.Move, 'Move');
    RegisterMethod(@TBaseList.Reverse, 'Reverse');
    RegisterPropertyHelper(@TBaseListCount_R,@TBaseListCount_W,'Count');
    RegisterPropertyHelper(@TBaseListCapacity_R,@TBaseListCapacity_W,'Capacity');
    RegisterPropertyHelper(@TBaseListGrowthDelta_R,@TBaseListGrowthDelta_W,'GrowthDelta');
    RegisterPropertyHelper(@TBaseListSetCountResetsMemory_R,@TBaseListSetCountResetsMemory_W,'SetCountResetsMemory');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_VectorLists(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TBaseList(CL);
  RIRegister_TBaseVectorList(CL);
  RIRegister_TAffineVectorList(CL);
  RIRegister_TVectorList(CL);
  RIRegister_TTexPointList(CL);
  RIRegister_TXIntegerList(CL);
  RIRegister_TSingleList(CL);
  RIRegister_TByteList(CL);
  RIRegister_TQuaternionList(CL);
end;

 
 
{ TPSImport_VectorLists }
(*----------------------------------------------------------------------------*)
procedure TPSImport_VectorLists.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_VectorLists(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_VectorLists.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_VectorLists(ri);
  RIRegister_VectorLists_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
