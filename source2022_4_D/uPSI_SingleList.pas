unit uPSI_SingleList;
{
a real vector list on gist    ---> TSinglelistclass

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
  TPSImport_SingleList = class(TPSPlugin)
  public
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;

 
{ compile-time registration functions }
procedure SIRegister_TSingleListClass(CL: TPSPascalCompiler);
procedure SIRegister_SingleListClass(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_SingleList_Routines(S: TPSExec);
procedure RIRegister_TSingleListClass(CL: TPSRuntimeClassImporter);
procedure RIRegister_SingleListClass(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   RTLConsts
  ,SingleList
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_SingleList]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TSingleListClass(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TObject', 'TSingleList') do
  with CL.AddClassN(CL.FindClass('TObject'),'TSingleListClass') do
  begin
    RegisterMethod('Constructor Create');
    RegisterMethod('Procedure Free;');
    RegisterMethod('Function Add( Item : Single) : Integer');
    RegisterMethod('Procedure Clear');
    RegisterMethod('Procedure SaveToStream( const S : TStream)');
    RegisterMethod('Procedure LoadFromStream( const S : TStream; const KeepCurrentSortType : Boolean)');
    RegisterMethod('Procedure SaveToFile( FileName : string)');
    RegisterMethod('Procedure LoadFromFile( FileName : string; const KeepCurrentSortType : Boolean)');
    RegisterMethod('Procedure Delete( Index : Integer)');
    RegisterMethod('Function ErrMsg( const Msg : string; Data : Integer) : string');
    RegisterMethod('Procedure Exchange( Index1, Index2 : Integer)');
    RegisterMethod('Function Expand : TSingleListClass');
    RegisterMethod('Function First : Single');
    RegisterMethod('Function IndexOf( Value : Single) : Integer');
    RegisterMethod('Procedure Insert( Index : Integer; Item : Single)');
    RegisterMethod('Function Last : Single');
    RegisterMethod('Procedure Move( CurIndex, NewIndex : Integer)');
    RegisterMethod('Function Remove( Item : Single) : Integer');
    RegisterMethod('Procedure Pack( NilValue : Single)');
    RegisterMethod('Procedure Sort( Compare : TSingleListSortCompare)');
    RegisterMethod('Procedure SortUp');
    RegisterMethod('Procedure SortDown');
    RegisterMethod('Procedure ShowList( StringList : TStrings; Descriptor : TSingleDescriptor; ClearIt : Boolean)');
    RegisterMethod('Function Minimum : Single');
    RegisterMethod('Function Maximum : Single');
    RegisterMethod('Function Range : Single');
    RegisterMethod('Function Sum : Extended');
    RegisterMethod('Function SumSqr : Extended');
    RegisterMethod('Function Average : Extended');
    RegisterMethod('Procedure CopyFrom( List : TSingleListClass; const KeepCurrentSortType : Boolean)');
    RegisterMethod('Procedure CopyTo( List : TSingleListClass; const KeepDestSortType : Boolean)');
    RegisterMethod('Procedure Push( Value : Single)');
    RegisterMethod('Function LifoPop( DefValue : Single) : Single');
    RegisterMethod('Function FifoPop( DefValue : Single) : Single');
    RegisterProperty('List', 'PSinglePtrList', iptr);
    RegisterProperty('Capacity', 'Integer', iptrw);
    RegisterProperty('Count', 'Integer', iptrw);
    RegisterProperty('Items', 'Single Integer', iptrw);
    SetDefaultPropery('Items');
    RegisterProperty('SortType', 'TSingleSortOption', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_SingleListClass(CL: TPSPascalCompiler);
begin
 CL.AddConstantN('SSingleListVoidError','String').SetString( 'Invalid method call (empty list)!');
 CL.AddConstantN('SSingleListSortError','String').SetString( 'Invalid method call (sorted list)!');
  //CL.AddTypeS('PSinglePtrList', '^TSinglePtrList // will not work');

   //CL.AddTypeS('TSinglePtrList', 'array[0..2147417850- 1] of Single');

  //TSinglePtrList
   //=/ array[0..MaxSingleListSize - 1] of Single;
   //TSingleListSortCompare
   //= function (Item1, Item2: Single): Integer;

    CL.AddTypeS('TSingleListSortCompare', 'function (Item1, Item2: Single): Integer;');

  //TSingleDescriptor
   //=// function (Index:Integer;Item : Single) : string;
    CL.AddTypeS('TSingleDescriptor', 'function (Index:Integer;Item : Single) : string;');


  CL.AddTypeS('TSingleSortOption', '( SingleSortNone, SingleSortUpWithDup, SingleSortUpNoDup, SingleSortDownWithDup, SingleSortDownNoDup )');
  SIRegister_TSingleListClass(CL);
 CL.AddDelphiFunction('Function DefDesc( Index : Integer; Item : Single) : string');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TSingleListSortType_W(Self: TSingleListClass; const T: TSingleSortOption);
begin Self.SortType := T; end;

(*----------------------------------------------------------------------------*)
procedure TSingleListSortType_R(Self: TSingleListClass; var T: TSingleSortOption);
begin T := Self.SortType; end;

(*----------------------------------------------------------------------------*)
procedure TSingleListItems_W(Self: TSingleListClass; const T: Single; const t1: Integer);
begin Self.Items[t1] := T; end;

(*----------------------------------------------------------------------------*)
procedure TSingleListItems_R(Self: TSingleListClass; var T: Single; const t1: Integer);
begin T := Self.Items[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TSingleListCount_W(Self: TSingleListClass; const T: Integer);
begin Self.Count := T; end;

(*----------------------------------------------------------------------------*)
procedure TSingleListCount_R(Self: TSingleListClass; var T: Integer);
begin T := Self.Count; end;

(*----------------------------------------------------------------------------*)
procedure TSingleListCapacity_W(Self: TSingleListClass; const T: Integer);
begin Self.Capacity := T; end;

(*----------------------------------------------------------------------------*)
procedure TSingleListCapacity_R(Self: TSingleListClass; var T: Integer);
begin T := Self.Capacity; end;

(*----------------------------------------------------------------------------*)
procedure TSingleListList_R(Self: TSingleListClass; var T: PSinglePtrList);
begin T := Self.List; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_SingleList_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@DefDesc, 'DefDesc', cdRegister);
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TSingleListClass(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TSingleListClass) do
  begin
    RegisterConstructor(@TSingleListClass.Create, 'Create');
    RegisterMethod(@TSingleListClass.Destroy, 'Free');
    RegisterMethod(@TSingleListClass.Add, 'Add');
    RegisterMethod(@TSingleListClass.Clear, 'Clear');
    RegisterMethod(@TSingleListClass.SaveToStream, 'SaveToStream');
    RegisterMethod(@TSingleListClass.LoadFromStream, 'LoadFromStream');
    RegisterMethod(@TSingleListClass.SaveToFile, 'SaveToFile');
    RegisterMethod(@TSingleListClass.LoadFromFile, 'LoadFromFile');
    RegisterMethod(@TSingleListClass.Delete, 'Delete');
    RegisterMethod(@TSingleListClass.ErrMsg, 'ErrMsg');
    RegisterMethod(@TSingleListClass.Exchange, 'Exchange');
    RegisterMethod(@TSingleListClass.Expand, 'Expand');
    RegisterMethod(@TSingleListClass.First, 'First');
    RegisterMethod(@TSingleListClass.IndexOf, 'IndexOf');
    RegisterMethod(@TSingleListClass.Insert, 'Insert');
    RegisterMethod(@TSingleListClass.Last, 'Last');
    RegisterMethod(@TSingleListClass.Move, 'Move');
    RegisterMethod(@TSingleListClass.Remove, 'Remove');
    RegisterMethod(@TSingleListClass.Pack, 'Pack');
    RegisterMethod(@TSingleListClass.Sort, 'Sort');
    RegisterMethod(@TSingleListClass.SortUp, 'SortUp');
    RegisterMethod(@TSingleListClass.SortDown, 'SortDown');
    RegisterMethod(@TSingleListClass.ShowList, 'ShowList');
    RegisterMethod(@TSingleListClass.Minimum, 'Minimum');
    RegisterMethod(@TSingleListClass.Maximum, 'Maximum');
    RegisterMethod(@TSingleListClass.Range, 'Range');
    RegisterMethod(@TSingleListClass.Sum, 'Sum');
    RegisterMethod(@TSingleListClass.SumSqr, 'SumSqr');
    RegisterMethod(@TSingleListClass.Average, 'Average');
    RegisterMethod(@TSingleListClass.CopyFrom, 'CopyFrom');
    RegisterMethod(@TSingleListClass.CopyTo, 'CopyTo');
    RegisterMethod(@TSingleListClass.Push, 'Push');
    RegisterMethod(@TSingleListClass.LifoPop, 'LifoPop');
    RegisterMethod(@TSingleListClass.FifoPop, 'FifoPop');
    RegisterPropertyHelper(@TSingleListList_R,nil,'List');
    RegisterPropertyHelper(@TSingleListCapacity_R,@TSingleListCapacity_W,'Capacity');
    RegisterPropertyHelper(@TSingleListCount_R,@TSingleListCount_W,'Count');
    RegisterPropertyHelper(@TSingleListItems_R,@TSingleListItems_W,'Items');
    RegisterPropertyHelper(@TSingleListSortType_R,@TSingleListSortType_W,'SortType');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_SingleListClass(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TSingleListClass(CL);
end;

 

{ TPSImport_SingleList }
(*----------------------------------------------------------------------------*)
procedure TPSImport_SingleList.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_SingleListClass(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_SingleList.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_SingleListClass(ri);
  RIRegister_SingleList_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
