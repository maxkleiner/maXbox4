unit Main_mX4;

interface

//#headM.pas Max: MAXBOX10: 22/05/2016 14:28:02 C:\Program Files (x86)\maxbox3\Import\maxbox4\examples\696_kmemo_demo_Main.pas in.pas 

//{$include KControls.inc}

(*uses
  {$IFDEF FPC}
    LCLIntf, LResources, LCLProc,
  {$ELSE}
    Windows, Messages,              
  {$ENDIF}
    SysUtils, Variants, Classes, Graphics, Controls, Forms, Dialogs, KGrids,
    KMemo, KGraphics, KFunctions, ExtCtrls, Grids, StdCtrls, KEditCommon,
    KSplitter, KControls, KLabels, KDialogs;
  *)
//type

  { TMainForm }

  //TMainForm = class(TForm)
  var
    BUtest: TButton;
    BUPreview: TButton;
    BUPrint: TButton;
    PNMain: TPanel;
    Panel1: TPanel;
    Panel2: TPanel;
    BULoad: TButton;
    Splitter1: TSplitter;
    KPrintPreviewDialog1: TKPrintPreviewDialog;
    KPrintSetupDialog1: TKPrintSetupDialog;
    procedure TMainFormFormCreate(Sender: TObject);
    procedure TMainFormFormResize(Sender: TObject);
    procedure TMainFormKMemo1DropFiles(Sender: TObject; X, Y: Integer; Files: TStrings);
    procedure TMainFormBULoadClick(Sender: TObject);
    procedure TMainFormBUPreviewClick(Sender: TObject);
    procedure TMainFormBUPrintClick(Sender: TObject);
    procedure TMainFormBUTestClick(Sender: TObject);
  //private
    { Private declarations }
    var KMemo1: TKMemo;
    KMemo2: TKMemo;
    procedure TMainFormLoadFiles;
    procedure TMainFormTest1;
    procedure TMainFormTest2;
    procedure TMainFormTest3;
    procedure TMainFormTest4;
    procedure TMainFormTest5;
    procedure TMainFormTest6;
    procedure TMainFormTest7;
    procedure TMainFormTest8;
    procedure TMainFormTest9;
    procedure TMainFormTest10;
    procedure TMainFormTest11;
    procedure TMainFormTest12;
    procedure TMainFormTest13;
    procedure TMainFormTest14;
    procedure TMainFormTest15;
    procedure TMainFormTest16;
    procedure TMainFormTest17;
    procedure TMainFormTest18;
    procedure TMainFormTest19;
    procedure TMainFormTest20;
    procedure TMainFormTest21;
  //public
    { Public declarations }
  //end;

var
  MainForm: TForm; //TMainForm;

implementation

(*{$IFDEF FPC}
  {$R *.lfm}
{$ELSE}
  {$R *.dfm}
{$ENDIF}
  *)
  
procedure TMainFormFormCreate(Sender: TObject);
begin
  KMemo1 := TKMemo.Create(Self);
  KMemo1.ContentPadding.Top := 20;
  KMemo1.ContentPadding.Left := 20;
  KMemo1.ContentPadding.Right := 20;
  KMemo1.ContentPadding.Bottom := 20;
  KMemo1.Align := alClient;
  KMemo1.Options := KMemo1.Options + [eodropfiles1, eoShowFormatting, eoWantTab];
  KMemo1.OnDropFiles := @TmainFormKMemo1DropFiles;
  KMemo1.Parent := Panel1;
  KMemo1.PageSetup.Title := 'test_document';
  KMemo1.Clear;

  KMemo2 := TKMemo.Create(Self);
  KMemo2.ContentPadding.Top := 20;
  KMemo2.ContentPadding.Left := 20;
  KMemo2.ContentPadding.Right := 20;
  KMemo2.ContentPadding.Bottom := 20;
  KMemo2.Align := alClient;
  KMemo2.Options := KMemo2.Options + [eoShowFormatting, eoWantTab];
  KMemo2.Parent := Panel2;
  KMemo2.Clear;
end;

procedure TMainFormFormResize(Sender: TObject);
begin
  Panel1.Width := mainform.ClientWidth div 2;
end;

procedure TMainFormBUPreviewClick(Sender: TObject);
begin
  TMainFormTest20;
end;

procedure TMainFormBUPrintClick(Sender: TObject);
begin
  TMainFormTest21;
end;

procedure TMainFormBULoadClick(Sender: TObject);
begin
  TMainFormLoadFiles;
end;

procedure TMainFormLoadFiles;
begin
//  KMemo1.LoadFromRTF('test.rtf');
//  KMemo1.LoadFromRTF('test1.rtf');
//  KMemo1.LoadFromRTF('test_no_img.rtf');
//  KMemo1.LoadFromRTF('test_simple.rtf');
  KMemo1.LoadFromRTF('kmemo_manual.rtf');
//  KMemo1.LoadFromRTF('simpletable.rtf');
//  KMemo1.LoadFromRTF('advancedtable.rtf');
//  KMemo1.Select(10, 510);
  KMemo1.SaveToRTF('test_save.rtf',false);

  KMemo2.LoadFromRTF('test_save.rtf');
  KMemo2.SaveToRTF('test_copy_save.rtf',false);
end;

procedure TMainFormKMemo1DropFiles(Sender: TObject; X, Y: Integer;  Files: TStrings);
begin
  KMemo1.LoadFromFile(Files[0]);
end;

procedure TMainFormBUTestClick(Sender: TObject);
begin
  TMainFormTest18;
end;

procedure TMainFormTest1;
begin
  KMemo1.Blocks.AddTextBlock('Hello world!',1);
end;

procedure TMainFormTest2;
begin
  KMemo1.Blocks.Clear;
  KMemo1.Blocks.AddTextBlock('Hello world!',2);
end;

procedure TMainFormTest3;
begin
  with KMemo1.Blocks do
  begin
    LockUpdate;
    try
      Clear;
      AddTextBlock('Hello world!',3);
    finally
      UnlockUpdate;
    end;
  end;
end;

procedure TMainFormTest4;
begin
  with KMemo1.Blocks do
  begin
    LockUpdate;
    try
      Clear;
      AddTextBlock('First paragraph text!',4);
      AddParagraph(-1);
      AddTextBlock('Second paragraph text!',5);
      AddParagraph(-1);
    finally
      UnlockUpdate;
    end;
  end;
end;

procedure TMainFormTest5;
var
  TB: TKMemoTextBlock;
begin
  TB := KMemo1.Blocks.AddTextBlock('Hello world!',5);
  TB.TextStyle.Font.Name := 'Arial';
  TB.TextStyle.Font.Color := clRed;
  TB.TextStyle.Font.Style := [fsBold];
end;

procedure TMainFormTest6;
var
  TB: TKMemoTextBlock;
  PA: TKMemoParagraph;
begin
  TB := KMemo1.Blocks.AddTextBlock('Hello world!',-1);
  PA := KMemo1.Blocks.AddParagraph(-1);
  PA.ParaStyle.HAlign := halCenter;
  PA.ParaStyle.BottomPadding := 20;
end;

procedure TMainFormTest7;
var
  TB: TKMemoTextBlock;
  PA: TKMemoParagraph;
begin
  TB := KMemo1.Blocks.AddTextBlock('Hello world!',-1);
  PA := KMemo1.Blocks.AddParagraph(-1);
  PA.Numbering := pnuArabic;
end;

procedure TMainFormTest8;
var
  TB: TKMemoTextBlock;
  PA: TKMemoParagraph;
begin
  KMemo1.Blocks.LockUpdate;
  try
    KMemo1.Blocks.Clear;
    KMemo1.Blocks.AddTextBlock('This is test text 1. This is test text 1. This is test text 1. This is test text 1. This is test text 1. This is test text 1.',-1);
    PA := KMemo1.Blocks.AddParagraph(-1);
    PA.Numbering := pnuLetterHi;
    PA.NumberingListLevel.FirstIndent := -20;
    PA.NumberingListLevel.LeftIndent := 20;
    TB := KMemo1.Blocks.AddTextBlock('This is a test text 2.',-1);
    PA := KMemo1.Blocks.AddParagraph(-1);
    PA.Numbering := pnuLetterHi;
    TB := KMemo1.Blocks.AddTextBlock('This is a level 2 test text 1.',-1);
    PA := KMemo1.Blocks.AddParagraph(-1);
    PA.Numbering := pnuRomanLo;
    PA.NumberingListLevel.FirstIndent := -20;
    PA.NumberingListLevel.LeftIndent := 60;
    TB := KMemo1.Blocks.AddTextBlock('This is a level 2 test text 2.',-1);
    PA := KMemo1.Blocks.AddParagraph(-1);
    PA.Numbering := pnuRomanLo;
    TB := KMemo1.Blocks.AddTextBlock('This is a level 1 test text 1.',-1);
    PA := KMemo1.Blocks.AddParagraph(-1);
    PA.Numbering := pnuArabic;
    PA.NumberingListLevel.FirstIndent := -20;
    PA.NumberingListLevel.LeftIndent := 40;
    TB := KMemo1.Blocks.AddTextBlock('This is a level 1 test text 2.',-1);
    PA := KMemo1.Blocks.AddParagraph(-1);
    PA.Numbering := pnuArabic;
    TB := KMemo1.Blocks.AddTextBlock('This is a level 2 test text 3.',-1);
    PA := KMemo1.Blocks.AddParagraph(-1);
    PA.Numbering := pnuRomanLo;
    TB := KMemo1.Blocks.AddTextBlock('This is a test text 3.',-1);
    PA := KMemo1.Blocks.AddParagraph(-1);
    PA.Numbering := pnuLetterHi;
    PA.ParaStyle.NumberStartAt := 1;
    TB := KMemo1.Blocks.AddTextBlock('This is a bullet text.',-1);
    PA := KMemo1.Blocks.AddParagraph(-1);
    PA.Numbering := pnuBullets;
  finally
    KMemo1.Blocks.UnlockUpdate;
  end;
end;

procedure TMainFormTest9;
begin
  KMemo1.Blocks.AddImageBlock('penguins.jpg',-1);
end;

procedure TMainFormTest10;
var
  IB: TKMemoImageBlock;
begin
  IB := KMemo1.Blocks.AddImageBlock('penguins.jpg',-1);
  IB.Position := mbpRelative;
  IB.LeftOffset := 50;
end;

procedure TMainFormTest11;
var
  CO: TKMemoContainer;
begin
  CO := KMemo1.Blocks.AddContainer(-1);
  CO.Position := mbpRelative;
  CO.LeftOffset := 50;
  CO.TopOffset := 20;
  CO.FixedWidth := True;
  CO.RequiredWidth := 300;
  CO.BlockStyle.Brush.Color := clLime;
  CO.Blocks.AddTextBlock('Text in a container!',-1);
  CO.Blocks.AddImageBlock('penguins.jpg',-1);
end;

procedure TMainFormTest12;
var
  TBL: TKMemoTable;
begin
  TBL := KMemo1.Blocks.AddTable(-1);
  TBL.ColCount := 2;
  TBL.RowCount := 2;
  TBL.Cells[0, 0].Blocks.AddTextBlock('Table text 1',-1);
  TBL.Cells[0, 1].Blocks.AddTextBlock('Table text 2',-1);
  TBL.Cells[1, 0].Blocks.AddTextBlock('Table text 3',-1);
  TBL.Cells[1, 1].Blocks.AddTextBlock('Table text 4',-1);
  TBL.CellStyle.BorderWidth := 1;
  TBL.ApplyDefaultCellStyle;
end;


  //dummy in progress
  procedure AddTextField2(CO: TKMemoContainer; Text1: Boolean);
  begin
  end;
  
  procedure AddTextField(CO: TKMemoContainer; Text1: Boolean);
  var
    TB: TKMemoTextBlock;
    PA: TKMemoParagraph;
  begin
    CO.Blocks.LockUpdate;
    try
      if Text1 then begin
        TB := CO.Blocks.AddTextBlock('This is test text 1',-1);
        TB.TextStyle.Font.Color := clRed;
        PA := CO.Blocks.AddParagraph(-1);
        PA.ParaStyle.Brush.Color := clInfoBk;
        PA.ParaStyle.BorderRadius := 5;
        TB := CO.Blocks.AddTextBlock('This is test text 2',-1);
        TB.TextStyle.Brush.Color := clYellow;
        TB.TextStyle.Font.Style := [fsBold];
        CO.Blocks.AddImageBlock('../../resource_src/kmessagebox_stop.png',-1);
        CO.Blocks.AddParagraph(-1);
        CO.Blocks.AddTextBlock('This is test text 3',-1);
        CO.Blocks.AddParagraph(-1);
        CO.Blocks.AddTextBlock('This is test text 4',-1);
        CO.Blocks.AddParagraph(-1);
        CO.Blocks.AddHyperlink('www.google.com', 'www.google.com',-1);
        CO.Blocks.AddParagraph(-1);
      end else
      begin
        TB := CO.Blocks.AddTextBlock('This is other text 1',-1);
        CO.Blocks.AddParagraph(-1);
      end;
    finally
      CO.Blocks.UnlockUpdate;
    end;
end;

procedure TMainFormTest13;

  {procedure AddTextField(CO: TKMemoContainer; Text1: Boolean);
  var
    TB: TKMemoTextBlock;
    PA: TKMemoParagraph;
  begin
    CO.Blocks.LockUpdate;
    try
      if Text1 then
      begin
        TB := CO.Blocks.AddTextBlock('This is test text 1');
        TB.TextStyle.Font.Color := clRed;
        PA := CO.Blocks.AddParagraph;
        PA.ParaStyle.Brush.Color := clInfoBk;
        PA.ParaStyle.BorderRadius := 5;
        TB := CO.Blocks.AddTextBlock('This is test text 2');
        TB.TextStyle.Brush.Color := clYellow;
        TB.TextStyle.Font.Style := [fsBold];
        CO.Blocks.AddImageBlock('../../resource_src/kmessagebox_stop.png');
        CO.Blocks.AddParagraph;
        CO.Blocks.AddTextBlock('This is test text 3');
        CO.Blocks.AddParagraph;
        CO.Blocks.AddTextBlock('This is test text 4');
        CO.Blocks.AddParagraph;
        CO.Blocks.AddHyperlink('www.google.com', 'www.google.com');
        CO.Blocks.AddParagraph;
      end else
      begin
        TB := CO.Blocks.AddTextBlock('This is other text 1');
        CO.Blocks.AddParagraph;
      end;
    finally
      CO.Blocks.UnlockUpdate;
    end;
  end;   }

var
  TBL: TKMemoTable;
begin
  KMemo1.Blocks.LockUpdate;
  try
    TBL := KMemo1.Blocks.AddTable(-1);
    TBL.BlockStyle.TopPadding := 20;
    TBL.BlockStyle.BottomPadding := 30;
    TBL.CellStyle.BorderWidth := 2;
    TBL.CellStyle.ContentPadding.AssignFromValues(5,5,5,5);
    TBL.CellStyle.Brush.Color := clWhite;
    TBL.ColCount := 3;
    TBL.RowCount := 3;
    TBL.Rows[0].RequiredHeight := 200;
    TBL.Rows[1].Cells[1].ColSpan := 2;
    TBL.Rows[1].Cells[0].RowSpan := 2;
    AddTextField(TBL.Rows[0].Cells[0], True);
    AddTextField(TBL.Rows[0].Cells[1], True);
    AddTextField(TBL.Rows[0].Cells[2], True);
    AddTextField(TBL.Rows[1].Cells[0], True);
    AddTextField(TBL.Rows[1].Cells[1], False);
    AddTextField(TBL.Rows[1].Cells[2], False);
    AddTextField(TBL.Rows[2].Cells[0], True);
    AddTextField(TBL.Rows[2].Cells[1], True);
    AddTextField(TBL.Rows[2].Cells[2], True);
  //    TBL.FixedWidth := True;
  //    TBL.RequiredWidth := 600;
    TBL.ApplyDefaultCellStyle;
  finally
    KMemo1.Blocks.UnLockUpdate;
  end;
end;

procedure TMainFormTest14;
begin
  KMemo1.Blocks.AddHyperlink('www.google.com', 'www.google.com',-1);
end;

procedure TMainFormTest15;
begin
  KMemo1.Colors.BkGnd := clYellow;
  KMemo1.BackgroundImage.LoadFromFile('../../resource_src/clouds.jpg');
end;

procedure TMainFormTest16;
begin
  KMemo1.TextStyle.Font.Name := 'Arial';
  KMemo1.TextStyle.Font.Size := 20;
  KMemo1.ParaStyle.HAlign := halCenter;
end;

procedure TMainFormTest17;
begin
  KMemo1.LoadFromRTF('kmemo_manual.rtf');
  KMemo1.SaveToRTF('kmemo_manual_copy.rtf',false);
end;

procedure TMainFormTest18;
begin
  KMemo1.ExecuteCommand(ecSelectAllk,1);
  KMemo1.ExecuteCommand(ecCopyk,1);
end;

procedure TMainFormTest19;
var
  TextStyle: TKMemoTextStyle;
  ParaStyle: TKMemoParaStyle;
begin
  KMemo1.ExecuteCommand(ecSelectAllk,1);
  ParaStyle := TKMemoParaStyle.Create;
  TextStyle := TKMemoTextStyle.Create;
  try
    TextStyle.Font.Style := [fsBold];
    ParaStyle.FirstIndent := 20;
    KMemo1.SelectionParaStyle := ParaStyle;
    KMemo1.SelectionTextStyle := TextStyle;
  finally
    ParaStyle.Free;
    TextStyle.Free;
  end;
end;

procedure TMainFormTest20;
begin
  KPrintPreviewDialog1.Control := KMemo1;
  KPrintPreviewDialog1.Execute;
end;

procedure TMainFormTest21;
begin
  KPrintSetupDialog1.Control := KMemo1;
  KPrintSetupDialog1.Execute;
end;

const  EM_GETEVENTMASK = WM_USER + 59; 
       EM_SETEVENTMASK = WM_USER + 69; 
       ENM_LINK = $04000000; 
       EM_AUTOURLDETECT = WM_USER + 91; 
  
 


procedure TForm1_InitRichEditURLDetection(RE: TRichEdit);
var
  mask: Word;
begin
  mask := SendMessage(RE.Handle, EM_GETEVENTMASK, 0, 0);
  SendMessage(RE.Handle, EM_SETEVENTMASK, 0, mask or ENM_LINK);
  SendMessage(RE.Handle, EM_AUTOURLDETECT, 1, 0);
  //SendMessage(RE.Handle, EM_AUTOURLDETECT, Integer(True), 0);
  SendMessage(RE.Handle, EM_AUTOURLDETECT, 1, 0);

end;

procedure TForm1_InitRichEditURLDetectionK(RE: TKMemo);
var
  mask: Word;
begin
  mask := SendMessage(RE.Handle, EM_GETEVENTMASK, 0, 0);
  SendMessage(RE.Handle, EM_SETEVENTMASK, 0, mask or ENM_LINK);
  SendMessage(RE.Handle, EM_AUTOURLDETECT, 1, 0);
  //SendMessage(RE.Handle, EM_AUTOURLDETECT, Integer(True), 0);
  SendMessage(RE.Handle, EM_AUTOURLDETECT, 1, 0);
end;

procedure TForm1_FormCreate(Sender: TObject);
var
  s: string;
  RichEdit1, RichEdit2: TRichEdit;
begin
  TForm1_InitRichEditURLDetection(RichEdit1);
  s:='Great Delphi tutorials and articles at ' +
     'http://www.delphi.about.com.' + #13#10 +
     'About Delphi Programming site!' + #13#10 +
     'Send an email to your Guide: mailto:delphi@aboutguide.com';
  RichEdit1.Text := s;

  s:= 'http://www.delphi.about.com. ' +
      ' This Rich Edit does not recognize URLs!';
  RichEdit2.Text := s
end;

function IcsCalcTickDiff(const StartTick, EndTick : LongWord): LongWord;
begin
    if EndTick >= StartTick then
        Result := EndTick - StartTick
    else
        Result := High(LongWord) - StartTick + EndTick;
end;



var afrm: TForm;
   kmemo: TKMemo;
   abt: boolean;

begin
  writeln(itoa(WM_USER))
  afrm:= getForm(850,780) 
  afrm.borderstyle:= bssizeable; //bsdialog;
   kmemo:= TKMemo.create(afrm); // do begin
   //TForm1_InitRichEditURLDetectionK(kmemo);
  
     with kmemo do begin
     parent:= afrm;
     Options:= Options+ [eodropfiles1, eoShowFormatting, eoWantTab];
     //TForm1_InitRichEditURLDetectionK(kmemo);
  
     align:= alClient;
     height:= height-50;
     LoadFromRTF(Exepath+'\examples\kmemo_manual.rtf');
     Blocks.AddHyperlink('  softwareschule','www.softwareschule.ch',1);
     showMessageBig('KMemo in Action Box')
     //free
    end;
    afrm.Release;
    //WriteLn(itoa(Boolean( it )) ) 
    abt:= true;
    writeln(itoa(booltoint(abt)));
    writeln(itoa(booltoint(true)));
    writeln(itoa(booleantoInteger(true)));

End.


{Summary:
X 	BOOL in Delphi 	BOOL in C 	Boolean in Delphi
original Type 	      LongBool 	int 	compiler magic
size in bytes 	          4 	4 	1
false = ? 	             0 	0 	0
true = ? 	             -1 ($FFFFFFFF) 	1 	1}
