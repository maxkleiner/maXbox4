unit SortThds;

interface

uses
  Controls, Forms, Classes, Graphics, ExtCtrls;

const  ARRSIZE = 171;

//for assert , loc's = 250
{$C+}

type
  //PThreadSortArray = ^TThreadSortArray;
  //TThreadSortArray = array[0..MaxInt div SizeOf(Integer) - 1] of Integer;
  TSortArray =  array[1..ARRSIZE] of Integer;


  TSortThread = class(TThread)
  strict private
    FBox: TPaintBox;
    //FSortArray: PThreadSortArray;
    FSortArray: TSortArray;
    FSize: Integer;
    FA, FB, FI, FJ: Integer;
    Fbolthslowmotion: boolean;
    procedure DoVisualSwap;
    procedure Setbolthslowmotion(const Value: boolean);
  protected
    procedure Execute; override;
    procedure VisualSwap(A, B, I, J: Integer);
    procedure Sort(var A: array of Integer); virtual; abstract;
  public
    slowmotion: integer;
    constructor Create(Box: TPaintBox; var SortArray: TSortArray);
    property  bolTHslowmotion: boolean read Fbolthslowmotion write Setbolthslowmotion;

  end;

TRandomSuper = class abstract (TObject)
public
    BubbleSortArray: TSortArray;
    SelectionSortArray: TSortArray;
    QuickSortArray: TSortArray;
private    
    procedure RandomizeArrays(myform: TForm; frmBool: Boolean);virtual;abstract;
public
end;

///<author>max kleiner</author>
///  <version>1.2</version>
///  <since>10.9.2009</since>
///  <alias>TAliasRandomArray</alias>
///  <stereotype>arrayclass</stereotype>
///
 TRandomArray = class(TRandomSuper)
 public
   //public
   procedure PaintArray(Box: TPaintBox);
   procedure RandomizeArrays(myform: TForm; frmBool: Boolean);override;

 var
   ArraysRandom: Boolean;
 end;


  TBubbleSort = class(TSortThread)
  protected
    procedure Sort(var A: array of Integer); override;
  end;

  TSelectionSort = class(TSortThread)
  protected
    procedure Sort(var A: array of Integer); override;
  end;

  TQuickSort = class(TSortThread)
  protected
    procedure Sort(var A: array of integer); override;
  end;

  {TSortArray = record
  end;}

//procedure PaintLine(Canvas: TCanvas; I, Len: Integer);
implementation

  uses  sysutils;

procedure PaintLine(Canvas: TCanvas; I, Len: Integer);
begin
  Canvas.PolyLine([Point(0, I * 2 + 1), Point(Len, I * 2 + 1)]);
end;

{ TSortThread }
constructor TSortThread.Create(Box: TPaintBox; var SortArray: TSortArray);
begin
  //why not at the beginning
  inherited Create(false);
  FBox:= Box;
  FSortArray:= SortArray;
  FSize:= High(SortArray) - Low(SortArray) + 1;
  FreeOnTerminate:= True;
  slowmotion:= 5;
end;

{ Since DoVisualSwap uses a VCL component (i.e., the TPaintBox) it should never
  be called directly by this thread.  DoVisualSwap should be called by passing
  it to the Synchronize method which causes DoVisualSwap to be executed by the
  main VCL thread, avoiding multi-thread conflicts. See VisualSwap for an
  example of calling Synchronize. }

procedure TSortThread.DoVisualSwap;
begin
  with FBox do begin
    Canvas.Pen.Color:= clBtnFace;
    //Canvas.Pen.Color:= clBlue;
    PaintLine(Canvas, FI, FA);
    PaintLine(Canvas, FJ, FB);
    Canvas.Pen.Color:= clRed;
    PaintLine(Canvas, FI, FB);
    PaintLine(Canvas, FJ, FA);
  end;
end;

{ VisusalSwap is a wrapper on DoVisualSwap making it easier to use.  The
  parameters are copied to instance variables so they are accessable
  by the main VCL thread when it executes DoVisualSwap }

procedure TSortThread.VisualSwap(A, B, I, J: Integer);
begin
  //symbol rename
  FA:= A;
  FB:= B;
  FI:= I;
  FJ:= J;
  if bolTHslowmotion then
            //sysutils.sleep(5);
            sysutils.sleep(slowmotion);
  Synchronize(DoVisualSwap);
end;

{ The Execute method is called when the thread starts }
procedure TSortThread.Execute;
begin
   Sort(Slice(FSortArray, FSize));
end;

procedure TSortThread.Setbolthslowmotion(const Value: boolean);
begin
  Fbolthslowmotion := Value;
end;

{ TBubbleSort }
procedure TBubbleSort.Sort(var A: array of Integer);
var
  I, J, T: Integer;
begin
  for I := High(A) downto Low(A) do
    for J := Low(A) to High(A) - 1 do
      if A[J] > A[J + 1] then begin
        VisualSwap(A[J], A[J + 1], J, J + 1);
        T := A[J];
        A[J] := A[J + 1];
        A[J + 1] := T;
        if Terminated then Exit;
      end;
end;


procedure TSelectionSort.Sort(var A: array of Integer);
// syncedit
var
 indx, J, T: Integer;
begin
  for indx := Low(A) to High(A) - 1 do
    for J := High(A) downto indx + 1 do
      if A[indx] > A[J] then begin
        VisualSwap(A[indx], A[J], indx, J);
    //swapvars(A, J, indx);  extract method , inline variable joke
        T:= A[indx];
        A[indx] := A[J];
        A[J] := T;
        if Terminated then Exit;
      end;
end;


procedure TQuickSort.Sort(var A: array of integer);

  procedure QuickSort(var A: array of integer; iLo, iHi: Integer);
  var
    Lo, Hi, Mid, T: Integer;
  begin
    Lo := iLo;
    Hi := iHi;
    // inline variable
    Mid := A[(Lo + Hi) div 2];
    repeat
      while A[Lo] < Mid
                    do Inc(Lo);
      while A[Hi] > Mid
                    do Dec(Hi);
      if Lo <= Hi then begin
        VisualSwap(A[Lo], A[Hi], Lo, Hi);
        T := A[Lo];
        A[Lo] := A[Hi];
        A[Hi] := T;
        Inc(Lo);
        Dec(Hi);
      end;
    until Lo > Hi;
    if Hi > iLo then QuickSort(A, iLo, Hi);
    if Lo < iHi then QuickSort(A, Lo, iHi);
    if Terminated then Exit;
  end;

begin
  QuickSort(A, Low(A), High(A));
end;

//change parameters
// eventhandler for onPaint of TPaintbox
procedure TRandomArray.PaintArray(Box: TPaintBox);
var
  I: Integer;
  A: TSortArray;
begin
  if box.name = 'BubbleSortBox' then
    A:= BubbleSortArray;
  if box.name = 'SelectionSortBox' then
    A:= SelectionSortArray;
  if box.name = 'QuickSortBox' then
    A:= QuickSortArray;
  with Box do begin
    Canvas.Pen.Color:= clred;
    //A[I+1] is not the orig!! to show graphic outcasts
    for I:= Low(A) to High(A) do PaintLine(Canvas, I, A[I+1]);
  end;
end;

procedure TRandomArray.RandomizeArrays(myform: TForm; frmBool: Boolean);
var
  I: Integer;
begin
   //if b then dialogs.showmessage('this is')
   assert(high(BubbleSortArray) <= 171, 'array to big');
  //Check(high(BubbleSortArray) <= 170, 'array to big');
  if not ArraysRandom then begin
    Randomize;
    for I:= Low(BubbleSortArray) to High(BubbleSortArray) do
      //SelectionSortarray[i]:= random(165);
      BubbleSortArray[I]:= Random(165);
    SelectionSortArray:= BubbleSortArray;
    QuickSortArray:= BubbleSortArray;
    ArraysRandom:= True;
    //thsort.ThreadSortForm.Repaint;
    myForm.Repaint;
    //myform.Invalidate
  end;
end;

end.
