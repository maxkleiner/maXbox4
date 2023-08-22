unit ChessPrg;

///adapit for mX4 by max also a frm template

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls,  ExtCtrls, ChessBrd, Spin;

type
  TChessForm1 = class(TForm)
    ButtonBack: TButton;
    ButtonForward: TButton;
    Buttonnew: TButton;
    ListBox1: TListBox;
    Label1: TLabel;
    RadioGroup1: TRadioGroup;
    RadioGroup2: TRadioGroup;
    CheckBoxWhiteOnTop: TCheckBox;
    ComboBox1: TComboBox;
    Label2: TLabel;
    CheckBoxCoords: TCheckBox;
    Label3: TLabel;
    CheckBoxLines: TCheckBox;
    ButtonStop: TButton;
    ButtonMove: TButton;
    ImageCm36: TImage;
    ImageFr40: TImage;
    Label4: TLabel;
    ComboBox2: TComboBox;
    SpinEdit1: TSpinEdit;
    ChessBrd1: TChessBrd;
    procedure UpdateListBox;
    procedure ButtonBackClick(Sender: TObject);
    procedure ChessBrd1LegalMove(Sender: TObject; oldSq, newSq: Square);
    procedure ButtonForwardClick(Sender: TObject);
    procedure ButtonnewClick(Sender: TObject);
    procedure RadioGroup2Click(Sender: TObject);
    procedure RadioGroup1Click(Sender: TObject);
    procedure CheckBoxWhiteOnTopClick(Sender: TObject);
    procedure ChessBrd1Draw(Sender: TObject);
    procedure ChessBrd1Mate(Sender: TObject; oldSq, newSq: Square);
    procedure CheckBoxCoordsClick(Sender: TObject);
    procedure SpinEdit1Change(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure CheckBoxLinesClick(Sender: TObject);
    procedure ListBox1Click(Sender: TObject);
    procedure ButtonMoveClick(Sender: TObject);
    procedure ButtonStopClick(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
    procedure ChessBrd1CalculateMove(Sender: TObject; var oldsq,
      newsq: Square);
    procedure ChessBrd1CalculationFailed(Sender: TObject; oldSq,
      newSq: Square);
    procedure ComboBox2Change(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  chessForm1: TChessForm1;

implementation

{$R *.DFM}


procedure TChessForm1.ButtonBackClick(Sender: TObject);
begin
     Chessbrd1.MoveBackward;
     UpdateListBox;
end;

procedure TChessForm1.UpdateListBox;
var
    list: TStringList;
begin
    list:=TStringList.Create;
    Chessbrd1.GetMoveList(list);
    ListBox1.Items:=list;
    list.Free;
end;

procedure TChessForm1.ChessBrd1LegalMove(Sender: TObject; oldSq, newSq: Square);
begin
     UpdateListBox;
end;

procedure TChessForm1.ButtonForwardClick(Sender: TObject);
begin
    Chessbrd1.MoveForward;
    UpdateListBox;
end;

procedure TChessForm1.ButtonNewClick(Sender: TObject);
begin
    Chessbrd1.NewGame;
    UpdateListBox;
end;

procedure TChessForm1.RadioGroup2Click(Sender: TObject);
begin
    Chessbrd1.ComputerPlaysWhite:=Boolean(RadioGroup2.ItemIndex)
end;

procedure TChessForm1.RadioGroup1Click(Sender: TObject);
begin
    Chessbrd1.ComputerPlaysBlack:=Boolean(RadioGroup1.ItemIndex)
end;

procedure TChessForm1.CheckBoxWhiteOnTopClick(Sender: TObject);
var
    v: Integer;
begin
    Chessbrd1.WhiteOnTop:=CheckBoxWhiteOnTop.Checked;
    v:=RadioGroup1.Top;
    RadioGroup1.Top:=RadioGroup2.Top;
    RadioGroup2.Top:=v;

end;

procedure TChessForm1.ChessBrd1Draw(Sender: TObject);
begin
     MessageDlg('Draw',mtInformation,[mbOk],0);
     Chessbrd1.NewGame;
end;

procedure TChessForm1.ChessBrd1Mate(Sender: TObject; oldSq, newSq: Square);
begin
     MessageDlg('Mate',mtInformation,[mbOk],0);
     Chessbrd1.NewGame;
end;

procedure TChessForm1.CheckBoxCoordsClick(Sender: TObject);
var
    cset: CoordSet;
begin
    if (CheckBoxCoords.Checked) then
    begin
        Include (cset,North);
        Include (cset,East);
        Include (cset,West);
        Include (cset,South);
    end
    else
    begin
        Exclude (cset,North);
        Exclude (cset,East);
        Exclude (cset,West);
        Exclude (cset,South);
    end;
    Chessbrd1.DisplayCoords:=cset;
end;

procedure TChessForm1.SpinEdit1Change(Sender: TObject);
begin
   Chessbrd1.SearchDepth:=SpinEdit1.value;
end;

procedure TChessForm1.Timer1Timer(Sender: TObject);
begin
    Label1.Caption:=IntToStr(integer(Chessbrd1.Thinking));
end;

procedure TChessForm1.CheckBoxLinesClick(Sender: TObject);
begin
    Chessbrd1.BoardLines:=CheckBoxLines.Checked;
end;

procedure TChessForm1.ListBox1Click(Sender: TObject);
begin
    Chessbrd1.GotoMove(1+(ListBox1.ItemIndex+1) shr 1,((ListBox1.ItemIndex+1) mod 2)=0);
end;


procedure TChessForm1.ButtonMoveClick(Sender: TObject);
begin
    Chessbrd1.Think;
end;

procedure TChessForm1.ButtonStopClick(Sender: TObject);
begin
    Chessbrd1.CancelThinking;
end;

procedure TChessForm1.ComboBox1Change(Sender: TObject);
begin    case ComboBox1.ItemIndex of
        0: Chessbrd1.CustomPieceSet:=nil;
        1: Chessbrd1.CustomPieceSet:=ImageFr40.Picture.Bitmap;
        2: Chessbrd1.CustomPieceSet:=ImageCm36.Picture.Bitmap;
    end;
end;

procedure TChessForm1.ChessBrd1CalculateMove(Sender: TObject; var oldsq,
  newsq: Square);
begin
    while (Chessbrd1.moveIsLegal(oldsq,newsq)=FALSE) do
    begin
        oldSq:=Square(random(65));
        newSq:=Square(random(65));
    end;
end;

procedure TChessForm1.ChessBrd1CalculationFailed(Sender: TObject; oldSq,
  newSq: Square);
begin
//
end;

procedure TChessForm1.ComboBox2Change(Sender: TObject);
begin
    Chessbrd1.CustomEngine:=(comboBox2.ItemIndex=1);
end;

procedure TChessForm1.FormDestroy(Sender: TObject);
begin
  close;
  Chessbrd1.Destroy;
  showmessage('mX4 debug out - chess form & engine destroy');
end;

end.
