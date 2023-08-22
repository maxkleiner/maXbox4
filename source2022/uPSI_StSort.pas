unit uPSI_StSort;
{
  sort to teach
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
  TPSImport_StSort = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;


{ compile-time registration functions }
procedure SIRegister_TStSorter(CL: TPSPascalCompiler);
procedure SIRegister_StSort(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_StSort_Routines(S: TPSExec);
procedure RIRegister_TStSorter(CL: TPSRuntimeClassImporter);
procedure RIRegister_StSort(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   Windows
  ,STConst
  ,STBase
  ,StSort
  ;


procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_StSort]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TStSorter(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TObject', 'TStSorter') do
  with CL.AddClassN(CL.FindClass('TObject'),'TStSorter') do begin
    RegisterMethod('Constructor Create( MaxHeap : LongInt; RecLen : Cardinal)');
    RegisterMethod('Procedure Free');
    RegisterMethod('Procedure Put( const X)');
    RegisterMethod('Function Get( var X) : Boolean');
    RegisterMethod('Procedure Reset');
    RegisterProperty('Count', 'LongInt', iptr);
    RegisterProperty('Compare', 'TUntypedCompareFunc', iptrw);
    RegisterProperty('MergeName', 'TMergeNameFunc', iptrw);
    RegisterProperty('RecLen', 'Cardinal', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_StSort(CL: TPSPascalCompiler);
begin
 CL.AddConstantN('MinRecsPerRun','LongInt').SetInt( 4);
 CL.AddConstantN('MergeOrder','LongInt').SetInt( 5);
 CL.AddConstantN('MedianThreshold','LongInt').SetInt( 16);
  CL.AddTypeS('TMergeInfo', 'record SortStatus : Integer; MergeFiles : Integer;'
   +' MergeHandles : Integer; MergePhases : Integer; MaxDiskSpace : LongInt; HeapUsed : LongInt; end');
  SIRegister_TStSorter(CL);
 CL.AddDelphiFunction('Function OptimumHeapToUse( RecLen : Cardinal; NumRecs : LongInt) : LongInt');
 CL.AddDelphiFunction('Function MinimumHeapToUse( RecLen : Cardinal) : LongInt');
 CL.AddDelphiFunction('Function MergeInfo( MaxHeap : LongInt; RecLen : Cardinal; NumRecs : LongInt) : TMergeInfo');
 CL.AddDelphiFunction('Function DefaultMergeName( MergeNum : Integer) : string');
 CL.AddDelphiFunction('Procedure ArraySort( var A, RecLen, NumRecs : Cardinal; Compare : TUntypedCompareFunc)');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TStSorterRecLen_R(Self: TStSorter; var T: Cardinal);
begin T := Self.RecLen; end;

(*----------------------------------------------------------------------------*)
procedure TStSorterMergeName_W(Self: TStSorter; const T: TMergeNameFunc);
begin Self.MergeName := T; end;

(*----------------------------------------------------------------------------*)
procedure TStSorterMergeName_R(Self: TStSorter; var T: TMergeNameFunc);
begin T := Self.MergeName; end;

(*----------------------------------------------------------------------------*)
procedure TStSorterCompare_W(Self: TStSorter; const T: TUntypedCompareFunc);
begin Self.Compare := T; end;

(*----------------------------------------------------------------------------*)
procedure TStSorterCompare_R(Self: TStSorter; var T: TUntypedCompareFunc);
begin T := Self.Compare; end;

(*----------------------------------------------------------------------------*)
procedure TStSorterCount_R(Self: TStSorter; var T: LongInt);
begin T := Self.Count; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_StSort_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@OptimumHeapToUse, 'OptimumHeapToUse', cdRegister);
 S.RegisterDelphiFunction(@MinimumHeapToUse, 'MinimumHeapToUse', cdRegister);
 S.RegisterDelphiFunction(@MergeInfo, 'MergeInfo', cdRegister);
 S.RegisterDelphiFunction(@DefaultMergeName, 'DefaultMergeName', cdRegister);
 S.RegisterDelphiFunction(@ArraySort, 'ArraySort', cdRegister);
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TStSorter(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TStSorter) do begin
    RegisterConstructor(@TStSorter.Create, 'Create');
    RegisterMethod(@TStSorter.Put, 'Put');
    RegisterMethod(@TStSorter.Get, 'Get');
    RegisterMethod(@TStSorter.Reset, 'Reset');
    RegisterPropertyHelper(@TStSorterCount_R,nil,'Count');
    RegisterPropertyHelper(@TStSorterCompare_R,@TStSorterCompare_W,'Compare');
    RegisterPropertyHelper(@TStSorterMergeName_R,@TStSorterMergeName_W,'MergeName');
    RegisterPropertyHelper(@TStSorterRecLen_R,nil,'RecLen');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_StSort(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TStSorter(CL);
end;

 
 
{ TPSImport_StSort }
(*----------------------------------------------------------------------------*)
procedure TPSImport_StSort.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_StSort(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_StSort.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_StSort(ri);
  RIRegister_StSort_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
