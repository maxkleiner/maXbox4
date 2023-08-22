unit GraphWin;

interface

uses
  SysUtils, Windows, Messages, Classes, Graphics, Controls, Forms, Dialogs,
  Buttons, ExtCtrls, StdCtrls, ComCtrls, Menus;

type
  TDrawingTool = (dtLine, dtRectangle, dtEllipse, dtRoundRect);
  TGraphWinForm = class(TForm)
    Panel1: TPanel;
    LineButton: TSpeedButton;
    RectangleButton: TSpeedButton;
    EllipseButton: TSpeedButton;
    RoundRectButton: TSpeedButton;
    PenButton: TSpeedButton;
    BrushButton: TSpeedButton;
    PenBar: TPanel;
    BrushBar: TPanel;
    SolidPen: TSpeedButton;
    DashPen: TSpeedButton;
    DotPen: TSpeedButton;
    DashDotPen: TSpeedButton;
    DashDotDotPen: TSpeedButton;
    ClearPen: TSpeedButton;
    PenWidth: TUpDown;
    PenSize: TEdit;
    StatusBar1: TStatusBar;
    ScrollBox1: TScrollBox;
    Image: TImage;
    SolidBrush: TSpeedButton;
    ClearBrush: TSpeedButton;
    HorizontalBrush: TSpeedButton;
    VerticalBrush: TSpeedButton;
    FDiagonalBrush: TSpeedButton;
    BDiagonalBrush: TSpeedButton;
    CrossBrush: TSpeedButton;
    DiagCrossBrush: TSpeedButton;
    PenColor: TSpeedButton;
    BrushColor: TSpeedButton;
    ColorDialog1: TColorDialog;
    MainMenu1: TMainMenu;
    File1: TMenuItem;
    New1: TMenuItem;
    Open1: TMenuItem;
    Save1: TMenuItem;
    Saveas1: TMenuItem;
    N1: TMenuItem;
    Exit1: TMenuItem;
    Edit1: TMenuItem;
    Cut1: TMenuItem;
    Copy1: TMenuItem;
    Paste1: TMenuItem;
    OpenDialog1: TOpenDialog;
    SaveDialog1: TSaveDialog;
    procedure FormMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure LineButtonClick(Sender: TObject);
    procedure RectangleButtonClick(Sender: TObject);
    procedure EllipseButtonClick(Sender: TObject);
    procedure RoundRectButtonClick(Sender: TObject);
    procedure PenButtonClick(Sender: TObject);
    procedure BrushButtonClick(Sender: TObject);
    procedure SetPenStyle(Sender: TObject);
    procedure PenSizeChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure SetBrushStyle(Sender: TObject);
    procedure PenColorClick(Sender: TObject);
    procedure BrushColorClick(Sender: TObject);
    procedure Exit1Click(Sender: TObject);
    procedure Open1Click(Sender: TObject);
    procedure Save1Click(Sender: TObject);
    procedure Saveas1Click(Sender: TObject);
    procedure New1Click(Sender: TObject);
    procedure Copy1Click(Sender: TObject);
    procedure Cut1Click(Sender: TObject);
    procedure Paste1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    BrushStyle: TBrushStyle;
    PenStyle: TPenStyle;
    PenWide: Integer;
    Drawing: Boolean;
    Origin, MovePt: TPoint;
    DrawingTool: TDrawingTool;
    CurrentFile: string;
    procedure SaveStyles;
    procedure RestoreStyles;
    procedure DrawShape(TopLeft, BottomRight: TPoint; AMode: TPenMode);
  end;

var
  GraphWinForm: TGraphWinForm;

implementation

uses BMPDlg, Clipbrd;

{$R *.dfm}

procedure TGraphWinForm.FormMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  Drawing := True;
  Image.Canvas.MoveTo(X, Y);
  Origin := Point(X, Y);
  MovePt := Origin;
  StatusBar1.Panels[0].Text := Format('Origin: (%d, %d)', [X, Y]);
end;

procedure TGraphWinForm.FormMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if Drawing then
  begin
    DrawShape(Origin, Point(X, Y), pmCopy);
    Drawing := False;
  end;
end;

procedure TGraphWinForm.FormMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  if Drawing then
  begin
    DrawShape(Origin, MovePt, pmNotXor);
    MovePt := Point(X, Y);
    DrawShape(Origin, MovePt, pmNotXor);
  end;
  StatusBar1.Panels[1].Text := Format('Current: (%d, %d)', [X, Y]);
end;

procedure TGraphWinForm.LineButtonClick(Sender: TObject);
begin
  DrawingTool := dtLine;
end;

procedure TGraphWinForm.RectangleButtonClick(Sender: TObject);
begin
  DrawingTool := dtRectangle;
end;

procedure TGraphWinForm.EllipseButtonClick(Sender: TObject);
begin
  DrawingTool := dtEllipse;
end;

procedure TGraphWinForm.RoundRectButtonClick(Sender: TObject);
begin
  DrawingTool := dtRoundRect;
end;

procedure TGraphWinForm.DrawShape(TopLeft, BottomRight: TPoint; AMode: TPenMode);
begin
  with Image.Canvas do
  begin
    Pen.Mode := AMode;
    case DrawingTool of
      dtLine:
        begin
          Image.Canvas.MoveTo(TopLeft.X, TopLeft.Y);
          Image.Canvas.LineTo(BottomRight.X, BottomRight.Y);
        end;
      dtRectangle: Image.Canvas.Rectangle(TopLeft.X, TopLeft.Y, BottomRight.X,
        BottomRight.Y);
      dtEllipse: Image.Canvas.Ellipse(Topleft.X, TopLeft.Y, BottomRight.X,
        BottomRight.Y);
      dtRoundRect: Image.Canvas.RoundRect(TopLeft.X, TopLeft.Y, BottomRight.X,
        BottomRight.Y, (TopLeft.X - BottomRight.X) div 2,
        (TopLeft.Y - BottomRight.Y) div 2);
    end;
  end;
end;

procedure TGraphWinForm.PenButtonClick(Sender: TObject);
begin
  PenBar.Visible := PenButton.Down;
end;

procedure TGraphWinForm.BrushButtonClick(Sender: TObject);
begin
  BrushBar.Visible := BrushButton.Down;
end;

procedure TGraphWinForm.SetPenStyle(Sender: TObject);
begin
  with Image.Canvas.Pen do
  begin
    if Sender = SolidPen then Style := psSolid
    else if Sender = DashPen then Style := psDash
    else if Sender = DotPen then Style := psDot
    else if Sender = DashDotPen then Style := psDashDot
    else if Sender = DashDotDotPen then Style := psDashDotDot
    else if Sender = ClearPen then Style := psClear;
  end;
end;

procedure TGraphWinForm.PenSizeChange(Sender: TObject);
begin
  Image.Canvas.Pen.Width := PenWidth.Position;
end;

procedure TGraphWinForm.FormCreate(Sender: TObject);
var
  Bitmap: TBitmap;
begin
  Bitmap := nil;
  try
    Bitmap := TBitmap.Create;
    Bitmap.Width := 800;
    Bitmap.Height := 600;
    Image.Picture.Graphic := Bitmap;
  finally
    Bitmap.Free;
  end;
end;

procedure TGraphWinForm.SetBrushStyle(Sender: TObject);
begin
  with Image.Canvas.Brush do
  begin
    if Sender = SolidBrush then Style := bsSolid
    else if Sender = ClearBrush then Style := bsClear
    else if Sender = HorizontalBrush then Style := bsHorizontal
    else if Sender = VerticalBrush then Style := bsVertical
    else if Sender = FDiagonalBrush then Style := bsFDiagonal
    else if Sender = BDiagonalBrush then Style := bsBDiagonal
    else if Sender = CrossBrush then Style := bsCross
    else if Sender = DiagCrossBrush then Style := bsDiagCross;
  end;
end;

procedure TGraphWinForm.PenColorClick(Sender: TObject);
begin
  ColorDialog1.Color := Image.Canvas.Pen.Color;
  if ColorDialog1.Execute then
    Image.Canvas.Pen.Color := ColorDialog1.Color;
end;

procedure TGraphWinForm.BrushColorClick(Sender: TObject);
begin
  ColorDialog1.Color := Image.Canvas.Brush.Color;
  if ColorDialog1.Execute then
    Image.Canvas.Brush.Color := ColorDialog1.Color;
end;

procedure TGraphWinForm.Exit1Click(Sender: TObject);
begin
  Close;
end;

procedure TGraphWinForm.Open1Click(Sender: TObject);
begin
  if OpenDialog1.Execute then
  begin
    CurrentFile := OpenDialog1.FileName;
    SaveStyles;
    Image.Picture.LoadFromFile(CurrentFile);
    RestoreStyles;
  end;
end;

procedure TGraphWinForm.Save1Click(Sender: TObject);
begin
  if CurrentFile <> EmptyStr then
    Image.Picture.SaveToFile(CurrentFile)
  else SaveAs1Click(Sender);
end;

procedure TGraphWinForm.Saveas1Click(Sender: TObject);
begin
  if SaveDialog1.Execute then
  begin
    CurrentFile := SaveDialog1.FileName;
    Save1Click(Sender);
  end;
end;

procedure TGraphWinForm.New1Click(Sender: TObject);
var
  Bitmap: TBitmap;
begin
  with NewBMPForm do
  begin
    ActiveControl := WidthEdit;
    WidthEdit.Text := IntToStr(Image.Picture.Graphic.Width);
    HeightEdit.Text := IntToStr(Image.Picture.Graphic.Height);
    if ShowModal <> idCancel then
    begin
      Bitmap := nil;
      try
        Bitmap := TBitmap.Create;
        Bitmap.Width := StrToInt(WidthEdit.Text);
        Bitmap.Height := StrToInt(HeightEdit.Text);
        SaveStyles;
        Image.Picture.Graphic := Bitmap;
        RestoreStyles;
        CurrentFile := EmptyStr;
      finally
        Bitmap.Free;
      end;
    end;
  end;
end;

procedure TGraphWinForm.Copy1Click(Sender: TObject);
begin
  Clipboard.Assign(Image.Picture);
end;

procedure TGraphWinForm.Cut1Click(Sender: TObject);
var
  ARect: TRect;
begin
  Copy1Click(Sender);
  with Image.Canvas do begin
    CopyMode := cmWhiteness;
    ARect := Rect(0, 0, Image.Width, Image.Height);
    CopyRect(ARect, Image.Canvas, ARect);
    CopyMode := cmSrcCopy;
  end;
end;

procedure TGraphWinForm.Paste1Click(Sender: TObject);
var
  Bitmap: TBitmap;
begin
  if Clipboard.HasFormat(CF_BITMAP) then
  begin
    Bitmap := TBitmap.Create;
    try
      Bitmap.Assign(Clipboard);
      Image.Canvas.Draw(0, 0, Bitmap);
    finally
      Bitmap.Free;
    end;
  end;
end;

procedure TGraphWinForm.SaveStyles;
begin
  with Image.Canvas do
  begin
    BrushStyle := Brush.Style;
    PenStyle := Pen.Style;
    PenWide := Pen.Width;
  end;
end;

procedure TGraphWinForm.RestoreStyles;
begin
  with Image.Canvas do
  begin
    Brush.Style := BrushStyle;
    Pen.Style := PenStyle;
    Pen.Width := PenWide;
  end;
end;

end.
