unit uPSI_DoubleList4;
{
double trouble
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
  TPSImport_DoubleList4 = class(TPSPlugin)
  public
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TDoubleList(CL: TPSPascalCompiler);
procedure SIRegister_DoubleList4(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_DoubleList4_Routines(S: TPSExec);
procedure RIRegister_TDoubleList(CL: TPSRuntimeClassImporter);
procedure RIRegister_DoubleList4(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   RTLConsts
  ,DoubleList4
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_DoubleList4]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TDoubleList(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TObject', 'TDoubleList') do
  with CL.AddClassN(CL.FindClass('TObject'),'TDoubleList') do
  begin
    RegisterMethod('Constructor Create');
    RegisterMethod('Function Add( Item : Double) : Integer');
    RegisterMethod('Procedure Clear');
    RegisterMethod('Procedure Free;');
    RegisterMethod('Procedure SaveToStream( const S : TStream)');
    RegisterMethod('Procedure LoadFromStream( const S : TStream; const KeepCurrentSortType : Boolean)');
    RegisterMethod('Procedure SaveToFile( FileName : string)');
    RegisterMethod('Procedure LoadFromFile( FileName : string; const KeepCurrentSortType : Boolean)');
    RegisterMethod('Procedure Delete( Index : Integer)');
    RegisterMethod('Function ErrMsg( const Msg : string; Data : Integer) : string');
    RegisterMethod('Procedure Exchange( Index1, Index2 : Integer)');
    RegisterMethod('Function Expand : TDoubleList');
    RegisterMethod('Function First : Double');
    RegisterMethod('Function IndexOf( Value : Double) : Integer');
    RegisterMethod('Procedure Insert( Index : Integer; Item : Double)');
    RegisterMethod('Function Last : Double');
    RegisterMethod('Procedure Move( CurIndex, NewIndex : Integer)');
    RegisterMethod('Function Remove( Item : Double) : Integer');
    RegisterMethod('Procedure Pack( NilValue : Double)');
    RegisterMethod('Procedure Sort( Compare : TDoubleListSortCompare)');
    RegisterMethod('Procedure SortUp');
    RegisterMethod('Procedure SortDown');
    RegisterMethod('Procedure ShowList( StringList : TStrings; Descriptor : TDoubleDescriptor; ClearIt : Boolean)');
    RegisterMethod('Function Minimum : Double');
    RegisterMethod('Function Maximum : Double');
    RegisterMethod('Function Range : Double');
    RegisterMethod('Function Sum : Extended');
    RegisterMethod('Function SumSqr : Extended');
    RegisterMethod('Function Average : Extended');
    RegisterMethod('Procedure CopyFrom( List : TDoubleList; const KeepCurrentSortType : Boolean)');
    RegisterMethod('Procedure CopyTo( List : TDoubleList; const KeepDestSortType : Boolean)');
    RegisterMethod('Procedure Push( Value : Double)');
    RegisterMethod('Function LifoPop( DefValue : Double) : Double');
    RegisterMethod('Function FifoPop( DefValue : Double) : Double');
    RegisterProperty('List', 'PDoublePtrList', iptr);
    RegisterProperty('Capacity', 'Integer', iptrw);
    RegisterProperty('Count', 'Integer', iptrw);
    RegisterProperty('Items', 'Double Integer', iptrw);
    SetDefaultPropery('Items');
    RegisterProperty('SortType', 'TDoubleSortOption', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_DoubleList4(CL: TPSPascalCompiler);
begin
 CL.AddConstantN('SDoubleListVoidError','String').SetString( 'Invalid method call (empty list)!');
 CL.AddConstantN('SDoubleListSortError','String').SetString( 'Invalid method call (sorted list)!');
  //CL.AddTypeS('PDoublePtrList', '^TDoublePtrList // will not work');

  // TDoublePtrList
   //= array[0..MaxDoubleListSize - 1] of Double;
  //  CL.AddTypeS('TDoublePtrList', 'array[0..2147417850] of Single');
    CL.AddTypeS('TDoublePtrList', 'array of Single');

   { TDoubleListSortCompare
   = function (Item1, Item2: Double): Integer;
    TDoubleDescriptor
   = function (Index:Integer;Item : Double) : string;  }

     CL.AddTypeS('TDoubleListSortCompare', 'function (Item1, Item2: Double): Integer;');

  //TSingleDescriptor
   //=// function (Index:Integer;Item : Single) : string;
    CL.AddTypeS('TDoubleDescriptor', 'function (Index:Integer;Item : Double) : string;');

    CL.AddTypeS('TDoubleSortOption', '( DoubleSortNone, DoubleSortUpWithDup, Doub'
   +'leSortUpNoDup, DoubleSortDownWithDup, DoubleSortDownNoDup )');
  SIRegister_TDoubleList(CL);
 CL.AddDelphiFunction('Function DefDescDouble( Index : Integer; Item : Double) : string');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TDoubleListSortType_W(Self: TDoubleList; const T: TDoubleSortOption);
begin Self.SortType := T; end;

(*----------------------------------------------------------------------------*)
procedure TDoubleListSortType_R(Self: TDoubleList; var T: TDoubleSortOption);
begin T := Self.SortType; end;

(*----------------------------------------------------------------------------*)
procedure TDoubleListItems_W(Self: TDoubleList; const T: Double; const t1: Integer);
begin Self.Items[t1] := T; end;

(*----------------------------------------------------------------------------*)
procedure TDoubleListItems_R(Self: TDoubleList; var T: Double; const t1: Integer);
begin T := Self.Items[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TDoubleListCount_W(Self: TDoubleList; const T: Integer);
begin Self.Count := T; end;

(*----------------------------------------------------------------------------*)
procedure TDoubleListCount_R(Self: TDoubleList; var T: Integer);
begin T := Self.Count; end;

(*----------------------------------------------------------------------------*)
procedure TDoubleListCapacity_W(Self: TDoubleList; const T: Integer);
begin Self.Capacity := T; end;

(*----------------------------------------------------------------------------*)
procedure TDoubleListCapacity_R(Self: TDoubleList; var T: Integer);
begin T := Self.Capacity; end;

(*----------------------------------------------------------------------------*)
procedure TDoubleListList_R(Self: TDoubleList; var T: PDoublePtrList);
begin T := Self.List; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_DoubleList4_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@DefDescDouble, 'DefDescDouble', cdRegister);
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TDoubleList(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TDoubleList) do
  begin
    RegisterConstructor(@TDoubleList.Create, 'Create');
    RegisterMethod(@TDoubleList.Destroy, 'Free');
    RegisterMethod(@TDoubleList.Add, 'Add');
    RegisterMethod(@TDoubleList.Clear, 'Clear');
    RegisterMethod(@TDoubleList.SaveToStream, 'SaveToStream');
    RegisterMethod(@TDoubleList.LoadFromStream, 'LoadFromStream');
    RegisterMethod(@TDoubleList.SaveToFile, 'SaveToFile');
    RegisterMethod(@TDoubleList.LoadFromFile, 'LoadFromFile');
    RegisterMethod(@TDoubleList.Delete, 'Delete');
    RegisterMethod(@TDoubleList.ErrMsg, 'ErrMsg');
    RegisterMethod(@TDoubleList.Exchange, 'Exchange');
    RegisterMethod(@TDoubleList.Expand, 'Expand');
    RegisterMethod(@TDoubleList.First, 'First');
    RegisterMethod(@TDoubleList.IndexOf, 'IndexOf');
    RegisterMethod(@TDoubleList.Insert, 'Insert');
    RegisterMethod(@TDoubleList.Last, 'Last');
    RegisterMethod(@TDoubleList.Move, 'Move');
    RegisterMethod(@TDoubleList.Remove, 'Remove');
    RegisterMethod(@TDoubleList.Pack, 'Pack');
    RegisterMethod(@TDoubleList.Sort, 'Sort');
    RegisterMethod(@TDoubleList.SortUp, 'SortUp');
    RegisterMethod(@TDoubleList.SortDown, 'SortDown');
    RegisterMethod(@TDoubleList.ShowList, 'ShowList');
    RegisterMethod(@TDoubleList.Minimum, 'Minimum');
    RegisterMethod(@TDoubleList.Maximum, 'Maximum');
    RegisterMethod(@TDoubleList.Range, 'Range');
    RegisterMethod(@TDoubleList.Sum, 'Sum');
    RegisterMethod(@TDoubleList.SumSqr, 'SumSqr');
    RegisterMethod(@TDoubleList.Average, 'Average');
    RegisterMethod(@TDoubleList.CopyFrom, 'CopyFrom');
    RegisterMethod(@TDoubleList.CopyTo, 'CopyTo');
    RegisterMethod(@TDoubleList.Push, 'Push');
    RegisterMethod(@TDoubleList.LifoPop, 'LifoPop');
    RegisterMethod(@TDoubleList.FifoPop, 'FifoPop');
    RegisterPropertyHelper(@TDoubleListList_R,nil,'List');
    RegisterPropertyHelper(@TDoubleListCapacity_R,@TDoubleListCapacity_W,'Capacity');
    RegisterPropertyHelper(@TDoubleListCount_R,@TDoubleListCount_W,'Count');
    RegisterPropertyHelper(@TDoubleListItems_R,@TDoubleListItems_W,'Items');
    RegisterPropertyHelper(@TDoubleListSortType_R,@TDoubleListSortType_W,'SortType');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_DoubleList4(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TDoubleList(CL);
end;

 
 
{ TPSImport_DoubleList4 }
(*----------------------------------------------------------------------------*)
procedure TPSImport_DoubleList4.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_DoubleList4(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_DoubleList4.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_DoubleList4(ri);
  RIRegister_DoubleList4_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
