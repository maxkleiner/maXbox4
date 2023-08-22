unit uPSI_SortThds;
{
 test framework for threads
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
  TPSImport_SortThds = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TQuickSort(CL: TPSPascalCompiler);
procedure SIRegister_TSelectionSort(CL: TPSPascalCompiler);
procedure SIRegister_TBubbleSort(CL: TPSPascalCompiler);
procedure SIRegister_TRandomArray(CL: TPSPascalCompiler);
procedure SIRegister_TRandomSuper(CL: TPSPascalCompiler);
procedure SIRegister_TSortThread(CL: TPSPascalCompiler);
procedure SIRegister_SortThds(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TQuickSort(CL: TPSRuntimeClassImporter);
procedure RIRegister_TSelectionSort(CL: TPSRuntimeClassImporter);
procedure RIRegister_TBubbleSort(CL: TPSRuntimeClassImporter);
procedure RIRegister_TRandomArray(CL: TPSRuntimeClassImporter);
procedure RIRegister_TRandomSuper(CL: TPSRuntimeClassImporter);
procedure RIRegister_TSortThread(CL: TPSRuntimeClassImporter);
procedure RIRegister_SortThds(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   Controls
  ,Forms
  ,Graphics
  ,ExtCtrls
  ,SortThds
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_SortThds]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TQuickSort(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TSortThread', 'TQuickSort') do
  with CL.AddClassN(CL.FindClass('TSortThread'),'TQuickSort') do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TSelectionSort(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TSortThread', 'TSelectionSort') do
  with CL.AddClassN(CL.FindClass('TSortThread'),'TSelectionSort') do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TBubbleSort(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TSortThread', 'TBubbleSort') do
  with CL.AddClassN(CL.FindClass('TSortThread'),'TBubbleSort') do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TRandomArray(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TRandomSuper', 'TRandomArray') do
  with CL.AddClassN(CL.FindClass('TRandomSuper'),'TRandomArray') do begin
    RegisterProperty('ArraysRandom', 'Boolean', iptrw);
    RegisterMethod('Procedure PaintArray( Box : TPaintBox)');
    RegisterMethod('Procedure RandomizeArrays( myform : TForm; frmBool : Boolean)');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TRandomSuper(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TObject', 'TRandomSuper') do
  with CL.AddClassN(CL.FindClass('TObject'),'TRandomSuper') do begin
    RegisterProperty('BubbleSortArray', 'TSortArray', iptrw);
    RegisterProperty('SelectionSortArray', 'TSortArray', iptrw);
    RegisterProperty('QuickSortArray', 'TSortArray', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TSortThread(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TThread', 'TSortThread') do
  with CL.AddClassN(CL.FindClass('TThread'),'TSortThread') do begin
    //Publish
    RegisterMethod('Constructor Create(Box : TPaintBox; var SortArray : TSortArray)');
    RegisterProperty('bolTHslowmotion', 'boolean', iptrw);
    RegisterProperty('slowmotion', 'integer', iptrw);
    RegisterProperty('onTerminate', 'TNotifyEvent', iptrw);
    RegisterProperty('Suspended', 'Boolean', iptrw);
    RegisterProperty('ThreadID', 'Cardinal', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_SortThds(CL: TPSPascalCompiler);
begin
  CL.AddConstantN('ARRSIZE','LongInt').SetInt( 171);
   CL.AddTypeS('TSortArray', 'array[1..ARRSIZE] of Integer;');

 //  TSortArray =  array[1..ARRSIZE] of Integer;

  SIRegister_TSortThread(CL);
  SIRegister_TRandomSuper(CL);
  SIRegister_TRandomArray(CL);
  SIRegister_TBubbleSort(CL);
  SIRegister_TSelectionSort(CL);
  SIRegister_TQuickSort(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TRandomArrayArraysRandom_W(Self: TRandomArray; const T: Boolean);
Begin Self.ArraysRandom := T; end;

(*----------------------------------------------------------------------------*)
procedure TRandomArrayArraysRandom_R(Self: TRandomArray; var T: Boolean);
Begin T := Self.ArraysRandom; end;

(*----------------------------------------------------------------------------*)
procedure TRandomSuperQuickSortArray_W(Self: TRandomSuper; const T: TSortArray);
Begin Self.QuickSortArray := T; end;

(*----------------------------------------------------------------------------*)
procedure TRandomSuperQuickSortArray_R(Self: TRandomSuper; var T: TSortArray);
Begin T := Self.QuickSortArray; end;

(*----------------------------------------------------------------------------*)
procedure TRandomSuperSelectionSortArray_W(Self: TRandomSuper; const T: TSortArray);
Begin Self.SelectionSortArray := T; end;

(*----------------------------------------------------------------------------*)
procedure TRandomSuperSelectionSortArray_R(Self: TRandomSuper; var T: TSortArray);
Begin T := Self.SelectionSortArray; end;

(*----------------------------------------------------------------------------*)
procedure TRandomSuperBubbleSortArray_W(Self: TRandomSuper; const T: TSortArray);
Begin Self.BubbleSortArray := T; end;

(*----------------------------------------------------------------------------*)
procedure TRandomSuperBubbleSortArray_R(Self: TRandomSuper; var T: TSortArray);
Begin T := Self.BubbleSortArray; end;

(*----------------------------------------------------------------------------*)
procedure TSortThreadbolTHslowmotion_W(Self: TSortThread; const T: boolean);
begin Self.bolTHslowmotion := T; end;

(*----------------------------------------------------------------------------*)
procedure TSortThreadbolTHslowmotion_R(Self: TSortThread; var T: boolean);
begin T := Self.bolTHslowmotion; end;


procedure TSortThreadSlowmotion_W(Self: TSortThread; const T: integer);
begin Self.slowmotion:= T; end;

(*----------------------------------------------------------------------------*)
procedure TSortThreadSlowmotion_R(Self: TSortThread; var T: integer);
begin T:= Self.slowmotion; end;


(*----------------------------------------------------------------------------*)
procedure RIRegister_TQuickSort(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TQuickSort) do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TSelectionSort(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TSelectionSort) do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TBubbleSort(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TBubbleSort) do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TRandomArray(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TRandomArray) do
  begin
    RegisterPropertyHelper(@TRandomArrayArraysRandom_R,@TRandomArrayArraysRandom_W,'ArraysRandom');
    RegisterMethod(@TRandomArray.PaintArray, 'PaintArray');
    RegisterMethod(@TRandomArray.RandomizeArrays, 'RandomizeArrays');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TRandomSuper(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TRandomSuper) do
  begin
    RegisterPropertyHelper(@TRandomSuperBubbleSortArray_R,@TRandomSuperBubbleSortArray_W,'BubbleSortArray');
    RegisterPropertyHelper(@TRandomSuperSelectionSortArray_R,@TRandomSuperSelectionSortArray_W,'SelectionSortArray');
    RegisterPropertyHelper(@TRandomSuperQuickSortArray_R,@TRandomSuperQuickSortArray_W,'QuickSortArray');
  end;
end;


(*----------------------------------------------------------------------------*)
procedure TThreadOnTerminate_W(Self: TThread; const T: TNotifyEvent);
begin Self.OnTerminate := T; end;

(*----------------------------------------------------------------------------*)
procedure TThreadOnTerminate_R(Self: TThread; var T: TNotifyEvent);
begin T := Self.OnTerminate; end;

(*----------------------------------------------------------------------------*)
procedure TThreadThreadID_R(Self: TThread; var T: Cardinal);
begin T := Self.ThreadID; end;

(*----------------------------------------------------------------------------*)
procedure TThreadThreadID_R1(Self: TThread; var T: THandle);
begin T := Self.ThreadID; end;

(*----------------------------------------------------------------------------*)
procedure TThreadSuspended_W(Self: TThread; const T: Boolean);
begin Self.Suspended := T; end;

(*----------------------------------------------------------------------------*)
procedure TThreadSuspended_R(Self: TThread; var T: Boolean);
begin T := Self.Suspended; end;



(*----------------------------------------------------------------------------*)
procedure RIRegister_TSortThread(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TSortThread) do begin
    RegisterConstructor(@TSortThread.Create, 'Create');
    RegisterPropertyHelper(@TSortThreadbolTHslowmotion_R,@TSortThreadbolTHslowmotion_W,'bolTHslowmotion');
    RegisterPropertyHelper(@TSortThreadSlowmotion_R,@TSortThreadSlowmotion_W,'slowmotion');
    RegisterPropertyHelper(@TThreadSuspended_R,@TThreadSuspended_W,'Suspended');
    RegisterPropertyHelper(@TThreadThreadID_R,nil,'ThreadID');
    RegisterPropertyHelper(@TThreadThreadID_R1,nil,'ThreadID1');
    RegisterPropertyHelper(@TThreadOnTerminate_R,@TThreadOnTerminate_W,'OnTerminate');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_SortThds(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TSortThread(CL);
  RIRegister_TRandomSuper(CL);
  RIRegister_TRandomArray(CL);
  RIRegister_TBubbleSort(CL);
  RIRegister_TSelectionSort(CL);
  RIRegister_TQuickSort(CL);
end;

 
 
{ TPSImport_SortThds }
(*----------------------------------------------------------------------------*)
procedure TPSImport_SortThds.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_SortThds(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_SortThds.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_SortThds(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
