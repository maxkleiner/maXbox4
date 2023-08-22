unit uPSI_ThSort;
{
  pilot pattern
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
  TPSImport_ThSort = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TThreadSortForm(CL: TPSPascalCompiler);
procedure SIRegister_ThSort(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TThreadSortForm(CL: TPSRuntimeClassImporter);
procedure RIRegister_ThSort(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   Windows
  ,Graphics
  ,Controls
  ,Forms
  ,StdCtrls
  ,ExtCtrls
  ,SortThds
  ,Buttons
  ,ThSort
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_ThSort]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TThreadSortForm(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TForm', 'TThreadSortForm') do
  with CL.AddClassN(CL.FindClass('TForm'),'TThreadSortForm') do begin
    RegisterProperty('BubbleSortBox', 'TPaintBox', iptrw);
    RegisterProperty('SelectionSortBox', 'TPaintBox', iptrw);
    RegisterProperty('QuickSortBox', 'TPaintBox', iptrw);
    RegisterProperty('Bevel1', 'TBevel', iptrw);
    RegisterProperty('Bevel2', 'TBevel', iptrw);
    RegisterProperty('Bevel3', 'TBevel', iptrw);
    RegisterProperty('StartBtn', 'TButton', iptrw);
    RegisterProperty('Label1', 'TLabel', iptrw);
    RegisterProperty('Label2', 'TLabel', iptrw);
    RegisterProperty('Label3', 'TLabel', iptrw);
    RegisterProperty('BitBtn1slowmotion', 'TBitBtn', iptrw);
    RegisterMethod('Procedure StartBtnClick( Sender : TObject)');
    RegisterMethod('Procedure BubbleSortBoxPaint( Sender : TObject)');
    RegisterMethod('Procedure SelectionSortBoxPaint( Sender : TObject)');
    RegisterMethod('Procedure QuickSortBoxPaint( Sender : TObject)');
    RegisterMethod('Procedure FormCreate( Sender : TObject)');
    RegisterMethod('Procedure FormDestroy( Sender : TObject)');
    RegisterMethod('Procedure FormKeyPress( Sender : TObject; var Key : Char)');
    RegisterMethod('Procedure BitBtn1slowmotionClick( Sender : TObject)');
    RegisterMethod('Procedure ThreadDone( Sender : TObject)');
    RegisterProperty('mouse', 'boolean', iptrw);
    RegisterProperty('slowmotionfirst', 'integer', iptrw);
    RegisterProperty('slowmotion', 'integer', iptrw);

  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_ThSort(CL: TPSPascalCompiler);
begin
  SIRegister_TThreadSortForm(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TThreadSortFormmouse_W(Self: TThreadSortForm; const T: boolean);
begin Self.mouse := T; end;

(*----------------------------------------------------------------------------*)
procedure TThreadSortFormmouse_R(Self: TThreadSortForm; var T: boolean);
begin T := Self.mouse; end;


(*----------------------------------------------------------------------------*)
procedure TThreadSortFormBitBtn1slowmotion_W(Self: TThreadSortForm; const T: TBitBtn);
Begin Self.BitBtn1slowmotion := T; end;

(*----------------------------------------------------------------------------*)
procedure TThreadSortFormBitBtn1slowmotion_R(Self: TThreadSortForm; var T: TBitBtn);
Begin T := Self.BitBtn1slowmotion; end;

(*----------------------------------------------------------------------------*)
procedure TThreadSortFormLabel3_W(Self: TThreadSortForm; const T: TLabel);
Begin Self.Label3 := T; end;

(*----------------------------------------------------------------------------*)
procedure TThreadSortFormLabel3_R(Self: TThreadSortForm; var T: TLabel);
Begin T := Self.Label3; end;

(*----------------------------------------------------------------------------*)
procedure TThreadSortFormLabel2_W(Self: TThreadSortForm; const T: TLabel);
Begin Self.Label2 := T; end;

(*----------------------------------------------------------------------------*)
procedure TThreadSortFormLabel2_R(Self: TThreadSortForm; var T: TLabel);
Begin T := Self.Label2; end;

(*----------------------------------------------------------------------------*)
procedure TThreadSortFormLabel1_W(Self: TThreadSortForm; const T: TLabel);
Begin Self.Label1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TThreadSortFormLabel1_R(Self: TThreadSortForm; var T: TLabel);
Begin T := Self.Label1; end;

(*----------------------------------------------------------------------------*)
procedure TThreadSortFormStartBtn_W(Self: TThreadSortForm; const T: TButton);
Begin Self.StartBtn := T; end;

(*----------------------------------------------------------------------------*)
procedure TThreadSortFormStartBtn_R(Self: TThreadSortForm; var T: TButton);
Begin T := Self.StartBtn; end;

(*----------------------------------------------------------------------------*)
procedure TThreadSortFormBevel3_W(Self: TThreadSortForm; const T: TBevel);
Begin Self.Bevel3 := T; end;

(*----------------------------------------------------------------------------*)
procedure TThreadSortFormBevel3_R(Self: TThreadSortForm; var T: TBevel);
Begin T := Self.Bevel3; end;

(*----------------------------------------------------------------------------*)
procedure TThreadSortFormBevel2_W(Self: TThreadSortForm; const T: TBevel);
Begin Self.Bevel2 := T; end;

(*----------------------------------------------------------------------------*)
procedure TThreadSortFormBevel2_R(Self: TThreadSortForm; var T: TBevel);
Begin T := Self.Bevel2; end;

(*----------------------------------------------------------------------------*)
procedure TThreadSortFormBevel1_W(Self: TThreadSortForm; const T: TBevel);
Begin Self.Bevel1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TThreadSortFormBevel1_R(Self: TThreadSortForm; var T: TBevel);
Begin T := Self.Bevel1; end;

(*----------------------------------------------------------------------------*)
procedure TThreadSortFormQuickSortBox_W(Self: TThreadSortForm; const T: TPaintBox);
Begin Self.QuickSortBox := T; end;

(*----------------------------------------------------------------------------*)
procedure TThreadSortFormQuickSortBox_R(Self: TThreadSortForm; var T: TPaintBox);
Begin T := Self.QuickSortBox; end;

(*----------------------------------------------------------------------------*)
procedure TThreadSortFormSelectionSortBox_W(Self: TThreadSortForm; const T: TPaintBox);
Begin Self.SelectionSortBox := T; end;

(*----------------------------------------------------------------------------*)
procedure TThreadSortFormSelectionSortBox_R(Self: TThreadSortForm; var T: TPaintBox);
Begin T := Self.SelectionSortBox; end;

(*----------------------------------------------------------------------------*)
procedure TThreadSortFormBubbleSortBox_W(Self: TThreadSortForm; const T: TPaintBox);
Begin Self.BubbleSortBox := T; end;

(*----------------------------------------------------------------------------*)
procedure TThreadSortFormBubbleSortBox_R(Self: TThreadSortForm; var T: TPaintBox);
Begin T := Self.BubbleSortBox; end;


procedure TThreadSlowmotion_W(Self: TThreadSortForm; const T: integer);
begin Self.slowmotionfirst:= T; end;

(*----------------------------------------------------------------------------*)
procedure TThreadSlowmotion_R(Self: TThreadSortForm; var T: integer);
begin T:= Self.slowmotionfirst; end;

procedure TThreadSlowmotion2_W(Self: TThreadSortForm; const T: integer);
begin Self.slowmotionsecond:= T; end;

(*----------------------------------------------------------------------------*)
procedure TThreadSlowmotion2_R(Self: TThreadSortForm; var T: integer);
begin T:= Self.slowmotionsecond; end;


(*----------------------------------------------------------------------------*)
procedure RIRegister_TThreadSortForm(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TThreadSortForm) do begin
    RegisterPropertyHelper(@TThreadSortFormBubbleSortBox_R,@TThreadSortFormBubbleSortBox_W,'BubbleSortBox');
    RegisterPropertyHelper(@TThreadSortFormSelectionSortBox_R,@TThreadSortFormSelectionSortBox_W,'SelectionSortBox');
    RegisterPropertyHelper(@TThreadSortFormQuickSortBox_R,@TThreadSortFormQuickSortBox_W,'QuickSortBox');
    RegisterPropertyHelper(@TThreadSortFormBevel1_R,@TThreadSortFormBevel1_W,'Bevel1');
    RegisterPropertyHelper(@TThreadSortFormBevel2_R,@TThreadSortFormBevel2_W,'Bevel2');
    RegisterPropertyHelper(@TThreadSortFormBevel3_R,@TThreadSortFormBevel3_W,'Bevel3');
    RegisterPropertyHelper(@TThreadSortFormStartBtn_R,@TThreadSortFormStartBtn_W,'StartBtn');
    RegisterPropertyHelper(@TThreadSortFormLabel1_R,@TThreadSortFormLabel1_W,'Label1');
    RegisterPropertyHelper(@TThreadSortFormLabel2_R,@TThreadSortFormLabel2_W,'Label2');
    RegisterPropertyHelper(@TThreadSortFormLabel3_R,@TThreadSortFormLabel3_W,'Label3');
    RegisterPropertyHelper(@TThreadSortFormBitBtn1slowmotion_R,@TThreadSortFormBitBtn1slowmotion_W,'BitBtn1slowmotion');
    RegisterMethod(@TThreadSortForm.StartBtnClick, 'StartBtnClick');
    RegisterMethod(@TThreadSortForm.BubbleSortBoxPaint, 'BubbleSortBoxPaint');
    RegisterMethod(@TThreadSortForm.SelectionSortBoxPaint, 'SelectionSortBoxPaint');
    RegisterMethod(@TThreadSortForm.QuickSortBoxPaint, 'QuickSortBoxPaint');
    RegisterMethod(@TThreadSortForm.FormCreate, 'FormCreate');
    RegisterMethod(@TThreadSortForm.FormDestroy, 'FormDestroy');
    RegisterMethod(@TThreadSortForm.FormKeyPress, 'FormKeyPress');
    RegisterMethod(@TThreadSortForm.BitBtn1slowmotionClick, 'BitBtn1slowmotionClick');
    RegisterMethod(@TThreadSortForm.ThreadDone, 'ThreadDone');
    RegisterPropertyHelper(@TThreadSortFormmouse_R,@TThreadSortFormmouse_W,'mouse');
    RegisterPropertyHelper(@TThreadSlowmotion_R,@TThreadSlowmotion_W,'slowmotionfirst');
    RegisterPropertyHelper(@TThreadSlowmotion2_R,@TThreadSlowmotion2_W,'slowmotion');

  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_ThSort(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TThreadSortForm(CL);
end;


 
{ TPSImport_ThSort }
(*----------------------------------------------------------------------------*)
procedure TPSImport_ThSort.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_ThSort(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_ThSort.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_ThSort(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
