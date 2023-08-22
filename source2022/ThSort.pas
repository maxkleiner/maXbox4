unit ThSort;

//refactor to eliminate global var, dependency and pointers too
//new class which concerns about random array, loc's = 145

interface

uses
  Windows, SysUtils, Classes, Graphics, Controls, Forms,
  StdCtrls, ExtCtrls, SortThds, Buttons;

type
///<author>max kleiner</author>
///  <version>1.1</version>
///  <since>as a factory enhancer</since>
IForm = interface
    procedure StartBtnClick(Sender: TObject);
    procedure BubbleSortBoxPaint(Sender: TObject);
    procedure SelectionSortBoxPaint(Sender: TObject);
    procedure QuickSortBoxPaint(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure ThreadDone(Sender: TObject);
end;

  IThreadForm2 = interface
    procedure StartBtnClick(Sender: TObject);
    procedure BubbleSortBoxPaint(Sender: TObject);
    procedure SelectionSortBoxPaint(Sender: TObject);
    procedure QuickSortBoxPaint(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure BitBtn1slowmotionClick(Sender: TObject);
  end;

  TThreadSortForm = class(TForm)
    BubbleSortBox: TPaintBox;
    SelectionSortBox: TPaintBox;
    QuickSortBox: TPaintBox;
    Bevel1: TBevel;
    Bevel2: TBevel;
    Bevel3: TBevel;
    StartBtn: TButton;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    BitBtn1slowmotion: TBitBtn;

    procedure StartBtnClick(Sender: TObject);
    procedure BubbleSortBoxPaint(Sender: TObject);
    procedure SelectionSortBoxPaint(Sender: TObject);
    procedure QuickSortBoxPaint(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure BitBtn1slowmotionClick(Sender: TObject);
  private
    ThreadsRunning: Integer;
    randArray: TRandomArray;
    Fmouse: boolean;
    procedure Setmouse(const Value: boolean);
  strict private
    bolSlowmotion: Boolean;
  public
    slowmotionfirst: integer;
    slowmotionsecond: integer;
    procedure ThreadDone(Sender: TObject);
    property mouse: boolean read Fmouse write Setmouse;
  end;

var
  ThreadSortForm: TThreadSortForm;


implementation

  //uses SortThds.RefactorPatterns;

{$R *.dfm}
//type
  //PSortArray = ^TSortArray;
  //TSortArray =  array[0..114] of Integer;
{ TThreadSortForm }

procedure TThreadSortForm.FormCreate(Sender: TObject);
var
  vFormTest: Boolean;
begin
  vFormTest := True;
  slowmotionfirst:= 4000; //default;
  slowmotionsecond:= 5;  //for thread itself
  bolSlowmotion:= false;
  randArray:= TRandomArray.Create();
  randArray.RandomizeArrays(self, vFormTest);
end;

procedure TThreadSortForm.BitBtn1slowmotionClick(Sender: TObject);
//var mycreate: TConcreteCreator;
begin
  bolSlowmotion:= not bolSlowmotion;
  StartBtnClick(self);
  bolSlowmotion:= not bolSlowmotion;
  //mycreate:= TConcreteCreator.Create;
  //mycreate.SomeOperation
end;

procedure TThreadSortForm.StartBtnClick(Sender: TObject);
var
  I: Byte;
  vFormTest: Boolean;
begin
  vFormTest := True;
  randArray.RandomizeArrays(self, vFormTest);
  //test thread buffer
  if bolSlowmotion then
                sleep(slowmotionfirst);
  ThreadsRunning:= 3;
  //for I := 0 to 30- 1 do begin
  with TBubbleSort.Create(BubbleSortBox, randArray.BubbleSortArray) do begin
    if bolSlowmotion then bolTHslowmotion:= true;
    slowmotion:= slowmotionsecond;
    OnTerminate:= ThreadDone;
  end;
  with TSelectionSort.Create(SelectionSortBox, randArray.SelectionSortArray) do begin
    if bolSlowmotion then bolTHslowmotion:= true;
    slowmotion:= slowmotionsecond;
    OnTerminate:= ThreadDone;
  end;
  with TQuickSort.Create(QuickSortBox, randArray.QuickSortArray) do begin
    if bolSlowmotion then bolTHslowmotion:= true;
    slowmotion:= slowmotionsecond;
    OnTerminate:= ThreadDone;
  end;
  StartBtn.Enabled:= False;
end;


procedure TThreadSortForm.BubbleSortBoxPaint(Sender: TObject);
begin
  randArray.PaintArray(BubbleSortBox);
  //randA.PaintArray(selectionSortBox);
end;

procedure TThreadSortForm.SelectionSortBoxPaint(Sender: TObject);
begin
  randArray.PaintArray(SelectionSortBox);
end;

procedure TThreadSortForm.Setmouse(const Value: boolean);
begin
  Fmouse := Value;
end;

procedure TThreadSortForm.QuickSortBoxPaint(Sender: TObject);
begin
  randArray.PaintArray(QuickSortBox);
end;


procedure TThreadSortForm.FormDestroy(Sender: TObject);
begin
  randArray.Free;
end;

procedure TThreadSortForm.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #27 then close;
end;


procedure TThreadSortForm.ThreadDone(Sender: TObject);
begin
  Dec(ThreadsRunning);
  if ThreadsRunning = 0 then begin
    StartBtn.Enabled:= True;
    randArray.ArraysRandom:= False;
  end;
end;

end.
