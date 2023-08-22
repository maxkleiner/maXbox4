unit tetris1;

// to maXbox 
 {$J+}


interface

uses
  SysUtils, Classes, Graphics, Dialogs, ComCtrls, Types, ExtCtrls,
  Buttons, Controls, Forms, StdCtrls;

const
  GlassWidth=10;
  GlassHeight=23;

var
  GlassWorkSheet:    array [1..GlassHeight,1..GlassWidth] of Byte;
  OldGlassWorkSheet: array [1..GlassHeight,1..GlassWidth] of Byte;

type
  TFigureWorksheet=array [1..4,1..4] of Byte;

const
  Triada: TFigureWorksheet=
    ((0,1,0,0),
     (1,1,1,0),
     (0,0,0,0),
     (0,0,0,0));
  LCorner: TFigureWorksheet=
    ((1,1,1,0),
     (1,0,0,0),
     (0,0,0,0),
     (0,0,0,0));
  RCorner: TFigureWorksheet=
    ((1,1,1,0),
     (0,0,1,0),
     (0,0,0,0),
     (0,0,0,0));
  LZigzag: TFigureWorksheet=
    ((1,1,0,0),
     (0,1,1,0),
     (0,0,0,0),
     (0,0,0,0));
  RZigzag: TFigureWorksheet=
    ((0,1,1,0),
     (1,1,0,0),
     (0,0,0,0),
     (0,0,0,0));
  Stick: TFigureWorksheet=
    ((1,1,1,1),
     (0,0,0,0),
     (0,0,0,0),
     (0,0,0,0));
  Box: TFigureWorksheet=
    ((1,1,0,0),
     (1,1,0,0),
     (0,0,0,0),
     (0,0,0,0));

const
  FigureWorkSheet: TFigureWorksheet=
    ((0,0,0,0),
     (0,0,0,0),
     (0,0,0,0),
     (0,0,0,0));

const
  BarWidth= 14;
  BarHeight=14;

  NextBarWidth= 9;
  NextBarHeight=9;

const
  TopOfs=    6;
  LeftOfs=   5;
  FieldWidth=4;

const
  MaxFigureNumber=7;
  MaxCornerNumber=4;
  MaxFigureSize=  4;
  MaxFigureColor= 7;

type
  TMoveDirect=  (mdDown,mdLeft,mdRight);
  TFigureCorner=(fc00,fc90,fc180,fc270);

type
  TTetro1 = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Timer1: TTimer;
    Bevel3: TBevel;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    SpeedButton3: TSpeedButton;
    SpeedButton4: TSpeedButton;
    SpeedButton5: TSpeedButton;
    SpeedButton6: TSpeedButton;
    SpeedButton7: TSpeedButton;
    SpeedButton8: TSpeedButton;
    Bevel1: TBevel;
    Bevel2: TBevel;
    SpeedButton9: TSpeedButton;
    Bevel4: TBevel;
    Image1: TImage;
    procedure FormPaint(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure SpeedButton8Click(Sender: TObject);
    procedure SpeedButton5Click(Sender: TObject);
    procedure SpeedButton6Click(Sender: TObject);
    procedure SpeedButton7Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton3Click(Sender: TObject);
    procedure SpeedButton4Click(Sender: TObject);
    procedure SpeedButton9Click(Sender: TObject);
  private
  public
    Level:        Byte;
    Score:        Longint;
    ReentTimer:   Boolean;
    ReentKeys:    Boolean;

    FigureActive: Boolean;
    FigureType:   Byte;
    FigureX:      Byte;
    FigureY:      Byte;
    FigureCorner: TFigureCorner;
    FigureMove:   TMoveDirect;

    FirstColor:   Byte;
    SecondColor:  Byte;
    FirstFigure:  Byte;
    SecondFigure: Byte;

    NextTopOfs:   Integer;
    NextLeftOfs:  Integer;

    RedrawSheet:  Boolean;
    //pfigurework: FigureWorksheet;

    function  FigureXSize: Byte;
    function  FigureYSize: Byte;
    procedure GenerateNewFigure;
    procedure ClearFigureIntoGlass;
    function  PutFigureIntoGlass(MoveDirect: TMoveDirect): Boolean;
    procedure RotateFigure;
    procedure ScanFillLines;
    procedure SetFigureColor;
  end;

var
  Tetro1: TTetro1;

implementation

uses tetris2, windows;

{$R *.dfm}

procedure TTetro1.FormPaint(Sender: TObject);
var
  X1,Y1,X2,Y2: Integer;
  NewRect:     TRect;
  I,J:         Byte;
  CurSheet:    TFigureWorksheet;
  NextColor:   TColor;
begin
  if RedrawSheet then FillChar(OldGlassWorkSheet,SizeOf(OldGlassWorkSheet),#255);
  for I := 1 to GlassHeight do
    for J := 1 to GlassWidth do begin
      if GlassWorkSheet[I,J]=OldGlassWorkSheet[I,J] then Continue;
      X1 := LeftOfs+(J-1)*BarWidth;
      X2 := X1+BarWidth;
      Y1 := TopOfs+(I-1)*BarHeight;
      Y2 := Y1+BarHeight;
      case GlassWorkSheet[I,J] of
        0: Canvas.Brush.Color := clNavy;
        1: Canvas.Brush.Color := clSilver;
        2: Canvas.Brush.Color := clOlive;
        3: Canvas.Brush.Color := clGray;
        4: Canvas.Brush.Color := clBlue;
        5: Canvas.Brush.Color := clPurple;
        6: Canvas.Brush.Color := clAqua;
        7: Canvas.Brush.Color := clTeal;
        8: Canvas.Brush.Color := clWhite;
      end;
      if GlassWorkSheet[I,J]>0 then begin
        NewRect := Rect(X1+1,Y1+1,X2-1,Y2-1);
        Canvas.FillRect(NewRect);
        Canvas.Pen.Color := clGray;
        Canvas.MoveTo(X1,Y1);
        Canvas.LineTo(X1,Y2-1);
        Canvas.LineTo(X2-1,Y2-1);
        Canvas.Pen.Color := clWhite;
        Canvas.LineTo(X2-1,Y1);
        Canvas.LineTo(X1,Y1);
      end
      else begin
        NewRect := Rect(X1,Y1,X2,Y2);
        Canvas.FillRect(NewRect);
      end;
    end;
  case FirstFigure of
    0: Move(Triada,CurSheet,SizeOf(CurSheet));
    1: Move(LCorner,CurSheet,SizeOf(CurSheet));
    2: Move(RCorner,CurSheet,SizeOf(CurSheet));
    3: Move(LZigzag,CurSheet,SizeOf(CurSheet));
    4: Move(RZigzag,CurSheet,SizeOf(CurSheet));
    5: Move(Stick,CurSheet,SizeOf(CurSheet));
    6: Move(Box,CurSheet,SizeOf(CurSheet));
  end;
  case FirstColor of
    0: NextColor := clNavy;
    1: NextColor := clSilver;
    2: NextColor := clOlive;
    3: NextColor := clGray;
    4: NextColor := clBlue;
    5: NextColor := clPurple;
    6: NextColor := clAqua;
    7: NextColor := clTeal;
    8: NextColor := clWhite;
  end;
  for I := 1 to MaxFigureSize-2 do
    for J := 1 to MaxFigureSize do begin
      X1 := NextLeftOfs+(J-1)*NextBarWidth;
      X2 := X1+NextBarWidth;
      Y1 := NextTopOfs+(I-1)*NextBarHeight;
      Y2 := Y1+NextBarHeight;
      if CurSheet[I,J]>0 then begin
        NewRect := Rect(X1+1,Y1+1,X2-1,Y2-1);
        Canvas.Brush.Color := NextColor;
        Canvas.FillRect(NewRect);
        Canvas.Pen.Color := clGray;
        Canvas.MoveTo(X1,Y1);
        Canvas.LineTo(X1,Y2-1);
        Canvas.LineTo(X2-1,Y2-1);
        Canvas.Pen.Color := clWhite;
        Canvas.LineTo(X2-1,Y1);
        Canvas.LineTo(X1,Y1);
      end
      else begin
        Canvas.Brush.Color := clSilver;
        NewRect := Rect(X1,Y1,X2,Y2);
        Canvas.FillRect(NewRect);
      end;
    end;
  Move(GlassWorkSheet,OldGlassWorkSheet,SizeOf(OldGlassWorkSheet));
end;

function TTetro1.FigureXSize: Byte;
var
  I,J,K: Byte;
begin
  K := 0;
  for J := 1 to MaxFigureSize do
    for I := 1 to MaxFigureSize do
      if FigureWorkSheet[J,I]>0 then
        if K<I then K := I;
  FigureXSize := K;
end;

function TTetro1.FigureYSize: Byte;
var
  I,J,K: Byte;
begin
  K := 0;
  for J := 1 to MaxFigureSize do
    for I := 1 to MaxFigureSize do
      if FigureWorkSheet[J,I]>0 then
        if K<J then K := J;
  FigureYSize := K;
end;

procedure TTetro1.GenerateNewFigure;
begin
  Timer1.Enabled := False;
  SecondFigure := FirstFigure;
  SecondColor := FirstColor;
  FigureType := SecondFigure;
  FigureX := 5;
  FigureY := 0;
  FigureCorner := fc270;
  //{$J+}
  FillChar(FigureWorkSheet,SizeOf(FigureWorkSheet),0);
  case FigureType of
    0: Move(Triada,FigureWorkSheet,SizeOf(FigureWorkSheet));
    1: Move(LCorner,FigureWorkSheet,SizeOf(FigureWorkSheet));
    2: Move(RCorner,FigureWorkSheet,SizeOf(FigureWorkSheet));
    3: Move(LZigzag,FigureWorkSheet,SizeOf(FigureWorkSheet));
    4: Move(RZigzag,FigureWorkSheet,SizeOf(FigureWorkSheet));
    5: Move(Stick,FigureWorkSheet,SizeOf(FigureWorkSheet));
    6: Move(Box,FigureWorkSheet,SizeOf(FigureWorkSheet));
  end;
  SetFigureColor;
  FigureMove := mdDown;
  FirstFigure := Random(MaxFigureNumber);
  FirstColor := Random(MaxFigureColor)+1;
  Timer1.Enabled := True;
end;

procedure TTetro1.ClearFigureIntoGlass;
var
  I,J: Byte;
begin
  for J := 1 to FigureYSize do
    for I := 1 to FigureXSize do
      if FigureWorkSheet[J,I]>0 then
        GlassWorkSheet[FigureY+J,FigureX+I] := 0;
end;

function TTetro1.PutFigureIntoGlass(MoveDirect: TMoveDirect): Boolean;
var
  I,J: Byte;
begin
  PutFigureIntoGlass := True;
  if (FigureY+FigureYSize>GlassHeight) and (MoveDirect=mdDown) then begin
    Dec(FigureY);
    PutFigureIntoGlass := False;
    Exit;
  end
  else
    while (FigureX+FigureXSize>GlassWidth) and (MoveDirect=mdDown) do
       Dec(FigureX);
    for J := 1 to FigureYSize do begin
      for I := 1 to FigureXSize do begin
        if (FigureWorkSheet[J,I]>0) and
          (GlassWorkSheet[FigureY+J,FigureX+I]>0) then begin
          PutFigureIntoGlass := False;
          case MoveDirect of
            mdDown:  Dec(FigureY);
            mdRight: Dec(FigureX);
            mdLeft:  Inc(FigureX);
          end;
          Exit;
        end;
      end;
    end;
  for J := 1 to FigureYSize do
    for I := 1 to FigureXSize do
      if FigureWorkSheet[J,I]>0 then
        GlassWorkSheet[FigureY+J,FigureX+I] := FigureWorkSheet[J,I];
  RedrawSheet := False;
  FormPaint(Self);
  RedrawSheet := True;
end;

procedure TTetro1.ScanFillLines;
var
  I,J,K,L: byte;
begin
  ClearFigureIntoGlass;
  for I := 1 to GlassHeight do begin
    K := 0;
    for J := 1 to GlassWidth do
      if GlassWorkSheet[I,J]>0 then Inc(K);
    if K=GlassWidth then begin   // if line is full
      for L := I downto 1 do
        for J := 1 to GlassWidth do
          if L>1 then GlassWorkSheet[L,J] := GlassWorkSheet[L-1,J];
    end;
  end;
  PutFigureIntoGlass(FigureMove);
end;

procedure TTetro1.Timer1Timer(Sender: TObject);
var
  I,J: Byte;
begin
  if ReentTimer then Exit
    else ReentTimer := True;
  if StrToInt(Label3.Caption)<>Level then Label3.Caption := IntToStr(Level);
  if StrToInt(Label4.Caption)<>Score then Label4.Caption := IntToStr(Score);
  if not FigureActive then begin
    GenerateNewFigure;
    image1.visible:=false;
    if not PutFigureIntoGlass(FigureMove) then begin
      MessageDlg('Limax is full... next game...sweetheart!',mtInformation,[mbOk],0);
      FillChar(OldGlassWorkSheet,SizeOf(OldGlassWorkSheet),#255);
      Timer1.Enabled := False;
      SpeedButton1.Enabled := False;
      SpeedButton2.Enabled := False;
      SpeedButton3.Enabled := False;
      SpeedButton4.Enabled := False;
      SpeedButton5.Enabled := True;
      SpeedButton6.Enabled := False;
      SpeedButton7.Enabled := False;
      ClearFigureIntoGlass;
      FigureActive := False;
      Level := 1;
      Score := 0;
      for I := 1 to GlassHeight do
        for J := 1 to GlassWidth do GlassWorkSheet[I,J] := 0;
      RedrawSheet := False;
      FormPaint(Self);
      RedrawSheet := True;
    end;
    FigureActive := true;
  end
  else begin
    ClearFigureIntoGlass;
    Inc(FigureY);
    if not PutFigureIntoGlass(FigureMove) then begin
      image1.visible:=true;  //linux gag
      case FigureType of
        0: Score := Score+10;
        1: Score := Score+30;
        2: Score := Score+30;
        3: Score := Score+25;
        4: Score := Score+25;
        5: Score := Score+15;
        6: Score := Score+20;
      end;
      if Score>300 then Level := 2;
      if Score>700 then Level := 3;
      if Score>1300 then Level := 4;
      if Score>2000 then Level := 5;
      if Score>3000 then Level := 6;
      if Score>5000 then Level := 7;
      Timer1.Interval := Round((7.1-Level)*100);
      FigureActive := false; //if true then timertest
    end;
  end;
  ScanFillLines;
  ReentTimer := False;
end;

procedure TTetro1.FormCreate(Sender: TObject);
begin
  FillChar(OldGlassWorkSheet,SizeOf(OldGlassWorkSheet),#255);
  RedrawSheet := True;
  with Bevel3 do begin
    Top := TopOfs-FieldWidth;
    Left := LeftOfs-FieldWidth;
    Width := GlassWidth*BarWidth+FieldWidth*2;
    Height := GlassHeight*BarHeight+FieldWidth*2;
  end;
  ClientWidth := Bevel3.Width+FieldWidth*3+SpeedButton5.Width;
  ClientHeight := Bevel3.Height+FieldWidth*2;
  SpeedButton1.Left := Bevel3.Width+FieldWidth*4-2;
  SpeedButton2.Left := SpeedButton1.Left+SpeedButton1.Width+1;
  SpeedButton3.Left := SpeedButton2.Left+SpeedButton2.Width+1;
  SpeedButton4.Left := SpeedButton2.Left;
  SpeedButton5.Left := Bevel3.Width+FieldWidth*2;
  SpeedButton6.Left := SpeedButton5.Left;
  SpeedButton7.Left := SpeedButton5.Left;
  SpeedButton8.Left := SpeedButton5.Left;
  SpeedButton9.Left := SpeedButton5.Left;
  Label1.Left := Bevel3.Width+FieldWidth*2;
  Label2.Left := Label1.Left;
  Bevel1.Left := Label1.Left;
  Bevel1.Width := SpeedButton5.Width;
  Bevel2.Left := Label1.Left;
  Bevel2.Width := SpeedButton5.Width;
  Label3.Left := Bevel1.Left+FieldWidth;
  Label4.Left := Bevel1.Left+FieldWidth;
  Bevel4.Top := SpeedButton9.Top+SpeedButton9.Height+4;
  Bevel4.Left := SpeedButton9.Left+SpeedButton9.Width div 4-4;
  Bevel4.Height := NextBarHeight*(MaxFigureSize-1)+4;
  Bevel4.Width :=NextBarWidth*MaxFigureSize+8;
  NextTopOfs := SpeedButton9.Top+SpeedButton9.Height+8;
  NextLeftOfs := SpeedButton9.Left+SpeedButton9.Width div 4;
  Level := 1;
  Timer1.Interval := Round((6.5-Level)*100);
  Score := 0;
  ReentTimer := False;
  ReentKeys := False;
  FigureActive := False;
  Label3.Caption := '1';
  Label4.Caption := '0';
  Randomize;
  FirstFigure := Random(MaxFigureNumber);
  FirstColor := Random(MaxFigureColor)+1;
  tetro1.BorderStyle:= bsDialog;
end;

procedure TTetro1.RotateFigure;
var
  OldFigureCornet: TFigureCorner;
  CurSheet:        TFigureWorksheet;
  OldFigureCorner: TFigureCorner;
procedure RotateFigureWorksheet;
var
  VertFlag:  Byte;
  HorizFlag: Byte;
  K,I,J:     Byte;
begin
  FillChar(FigureWorkSheet,SizeOf(FigureWorkSheet),0);
  case FigureType of
    0: Move(Triada,FigureWorkSheet,SizeOf(FigureWorkSheet));
    1: Move(LCorner,FigureWorkSheet,SizeOf(FigureWorkSheet));
    2: Move(RCorner,FigureWorkSheet,SizeOf(FigureWorkSheet));
    3: Move(LZigzag,FigureWorkSheet,SizeOf(FigureWorkSheet));
    4: Move(RZigzag,FigureWorkSheet,SizeOf(FigureWorkSheet));
    5: Move(Stick,FigureWorkSheet,SizeOf(FigureWorkSheet));
    6: Move(Box,FigureWorkSheet,SizeOf(FigureWorkSheet));
  end;
  FillChar(CurSheet,SizeOf(CurSheet),0);
  for K := 0 to Byte(FigureCorner) do begin
    for I := 1 to MaxFigureSize do
      for J := 1 to MaxFigureSize do
        CurSheet[J,I] := FigureWorkSheet[MaxFigureSize-I+1,J];
    Move(CurSheet,FigureWorkSheet,SizeOf(FigureWorkSheet));
  end;
  SetFigureColor;
  HorizFlag := 0;
  while HorizFlag=0 do begin
    for I := 1 to MaxFigureSize do
      if FigureWorkSheet[1,I]>0 then HorizFlag := 1;
    if HorizFlag=0 then begin
      for J := 1 to MaxFigureSize-1 do
        for I := 1 to MaxFigureSize do
          FigureWorkSheet[J,I] := FigureWorkSheet[J+1,I];
      for J := 1 to MaxFigureSize do
        FigureWorkSheet[MaxFigureSize,J] := 0;
    end;
  end;
  VertFlag := 0;
  while VertFlag=0 do begin
    for J := 1 to MaxFigureSize do
      if FigureWorkSheet[J,1]>0 then VertFlag := 1;
    if VertFlag=0 then begin
      for J := 1 to MaxFigureSize do
        for I := 1 to MaxFigureSize-1 do
          FigureWorkSheet[J,I] := FigureWorkSheet[J,I+1];
      for J := 1 to MaxFigureSize do
        FigureWorkSheet[J,MaxFigureSize] := 0;
    end;
  end;
end;
begin
  ClearFigureIntoGlass;
  OldFigureCorner := FigureCorner;
  if FigureCorner>fc00 then Dec(FigureCorner)
    else FigureCorner := fc270;
  RotateFigureWorksheet;
  if not PutFigureIntoGlass(mdDown) then begin
    FigureCorner := OldFigureCorner;
    RotateFigureWorksheet;
    PutFigureIntoGlass(mdDown);
  end;
end;

procedure TTetro1.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if ReentKeys then Exit
    else ReentKeys := True;
  if not FigureActive then begin
    ReentKeys := False;
    Exit;
  end;
  case Key of
    VK_Up:    RotateFigure;
    VK_Down,
    VK_Space: begin    //VK_SPACE in win
                repeat
                  ClearFigureIntoGlass;
                  Inc(FigureY);
                until not PutFigureIntoGlass(mdDown);
                Inc(Score,5);
              end;
    VK_Left:  if FigureX>0 then begin
                ClearFigureIntoGlass;
                Dec(FigureX);
                PutFigureIntoGlass(mdLeft);
              end;
    VK_Right: if FigureX+FigureXSize<GlassWidth then begin
                ClearFigureIntoGlass;
                Inc(FigureX);
                PutFigureIntoGlass(mdRight);
              end;
  end;
  ReentKeys := False;
end;

procedure TTetro1.SetFigureColor;
var
  I,J: Byte;
begin
  for I := 1 to MaxFigureSize do
    for J := 1 to MaxFigureSize do
      if FigureWorkSheet[I,J]>0 then FigureWorkSheet[I,J] := SecondColor;
end;

procedure TTetro1.SpeedButton8Click(Sender: TObject);
begin
  if MessageDlg('vous voulez quitter?',mtConfirmation,[mbYes,mbNo],0)=mrYes then
    tetro1.Free;   //Application.Terminate;
end;

procedure TTetro1.SpeedButton5Click(Sender: TObject);
begin
  Timer1.Enabled := True;
  SpeedButton5.Enabled := False;
  SpeedButton1.Enabled := True;
  SpeedButton2.Enabled := True;
  SpeedButton3.Enabled := True;
  SpeedButton4.Enabled := True;
  SpeedButton6.Enabled := True;
  SpeedButton7.Enabled := True;
end;

procedure TTetro1.SpeedButton6Click(Sender: TObject);
begin
  if Timer1.Enabled then begin
    Timer1.Enabled := False;
    SpeedButton1.Enabled := False;
    SpeedButton2.Enabled := False;
    SpeedButton3.Enabled := False;
    SpeedButton4.Enabled := False;
    SpeedButton7.Enabled := False;
  end
  else begin
    Timer1.Enabled := True;
    SpeedButton1.Enabled := True;
    SpeedButton2.Enabled := True;
    SpeedButton3.Enabled := True;
    SpeedButton4.Enabled := True;
    SpeedButton7.Enabled := True;
  end;
end;

procedure TTetro1.SpeedButton7Click(Sender: TObject);
var
  I,J: Byte;
begin
  Timer1.Enabled := False;
  ClearFigureIntoGlass;
  FigureActive := False;
  Level := 1;
  Score := 0;
  for I := 1 to GlassHeight do
    for J := 1 to GlassWidth do GlassWorkSheet[I,J] := 0;
  RedrawSheet := False;
  FormPaint(Self);
  RedrawSheet := True;
  Timer1.Enabled := True;
end;

procedure TTetro1.SpeedButton2Click(Sender: TObject);
begin
  Timer1.Enabled := False;
  RotateFigure;
  Timer1.Enabled := True;
end;

procedure TTetro1.SpeedButton1Click(Sender: TObject);
begin
  Timer1.Enabled := False;
  if FigureX>0 then begin
    ClearFigureIntoGlass;
    Dec(FigureX);
    PutFigureIntoGlass(mdLeft);
  end;
  Timer1.Enabled := True;
end;

procedure TTetro1.SpeedButton3Click(Sender: TObject);
begin
  Timer1.Enabled := False;
  if FigureX+FigureXSize<GlassWidth then begin
    ClearFigureIntoGlass;
    Inc(FigureX);
    PutFigureIntoGlass(mdRight);
  end;
  Timer1.Enabled := True;
end;

procedure TTetro1.SpeedButton4Click(Sender: TObject);
begin
  Timer1.Enabled := False;
  repeat
    ClearFigureIntoGlass;
    Inc(FigureY);
  until not PutFigureIntoGlass(mdDown);
  Inc(Score,5);
  Timer1.Enabled := True;
end;

procedure TTetro1.SpeedButton9Click(Sender: TObject);
var
  OldState: Boolean;
begin
  OldState := Timer1.Enabled;
  Timer1.Enabled := False;
  Tetro2:= TTetro2.create(self);
  try
    Tetro2.ShowModal;
  finally
    tetro2.Free;
  end;
  Timer1.Enabled := OldState;
end;

end.
