unit ufrmOscilloscope4;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, uColorFunctions, jpeg;

type
  TfrmOscilloscope = class(TFrame)
    Image2: TImage;
    Image1: TImage;
    ImgScreen: TImage;
  private
    FScaleLight: integer;
    FScaleColor:Tcolor;
    FPenWidth :integer;
    FCh1Ofsett: integer;
    FCh2Ofsett: integer;
    FCh1On: Boolean;
    FCh2On: Boolean;
    FCh1Gnd: Boolean;
    FCh2Gnd: Boolean;
    FScreenColor: Tcolor;
    FScreenCenter :integer;
    FBeamC1Color:Tcolor;
    FBeamC2Color:Tcolor;
    FBeamLight: integer;
    FAfterBeamDraw: TNotifyEvent;

    procedure setScaleLight(const Value: integer);
    procedure DrawScale;
    procedure InitGraph;
    procedure DrawBeam;
    procedure setBeamLight(const Value: integer);
    procedure setCh1Ofsett(const Value: integer);
    procedure setCh2Ofsett(const Value: integer);
    procedure setCh1On(const Value: Boolean);
    procedure setCh2On(const Value: Boolean);
    procedure setCh1Gnd(const Value: Boolean);
    procedure setCh2Gnd(const Value: Boolean);
    procedure setScreanColor(const Value: Tcolor);
    procedure setBeamWidth(const Value: integer);
  public
    constructor Create(AOwner: TComponent); override;
    procedure Clear;

    property ScaleLight:integer read FScaleLight write setScaleLight;
    property BeamLight:integer read FBeamLight write setBeamLight;
    property Focus:integer read FPenWidth write setBeamWidth;

    property Ch1Ofsett:integer read FCh1Ofsett write setCh1Ofsett;
    property Ch2Ofsett:integer read FCh2Ofsett write setCh2Ofsett;

    property Ch1On:Boolean read FCh1On write setCh1On;
    property Ch2On:Boolean read FCh2On write setCh2On;

    property Ch1Gnd:Boolean read FCh1Gnd write setCh1Gnd;
    property Ch2Gnd:Boolean read FCh2Gnd write setCh2Gnd;

    procedure BeamData(const Ch1Points: array of TPoint;const Ch2Points: array of TPoint);
    property ScreenColor:Tcolor read FScreenColor write setScreanColor;

    property OnAfterBeamDraw:TNotifyEvent read FAfterBeamDraw write FAfterBeamDraw;
  end;

implementation

uses Math;

{$R *.dfm}

procedure divmod(const d:integer; const q:word;   var result, remainder:word);
begin
  result:=d div q;
  remainder:=d mod q;
end;


constructor TfrmOscilloscope.Create(AOwner: TComponent);
begin
  inherited;
  FScaleColor := $0A0A0A;
  FCh1On      := True;
  FCh2On      := True;
  FCh1Ofsett  := 0;
  FCh2Ofsett  := 0;

  FScreenColor := clBlack;
  FBeamC1Color := $00FF00;
  FBeamC2Color := $0000FF;

  DoubleBuffered:=true;
  //InitGraph;
end;

procedure TfrmOscilloscope.Clear;
begin
  imgScreen.Canvas.Draw(0,0,Image2.Picture.Bitmap);
end;

procedure TfrmOscilloscope.InitGraph;
var c:TColor;
begin
  FScreenCenter := round(imgScreen.Height/2);
  with Image2.Canvas do
  begin
    Brush.Color := FScreenColor;
    c:=pixels[0,0];
    FloodFill(70,70,FScreencolor,fsborder);
  end;  
  DrawScale;
  Clear;
end;

procedure TfrmOscilloscope.setScaleLight(const Value: integer);
begin
  FScaleLight := Value;
  FScaleColor := FadeColor($000B0F,Value );

  InitGraph;
  DrawBeam;
end;

procedure TfrmOscilloscope.setBeamLight(const Value: integer);
begin
  FBeamC1Color := FadeColor($00FF00,Value);
  FBeamC2Color := FadeColor($0000FF,Value);
  DrawBeam;
end;

procedure TfrmOscilloscope.setBeamWidth(const Value: integer);
begin
  FPenWidth := Value;
  DrawBeam;
end;

procedure TfrmOscilloscope.setScreanColor(const Value: Tcolor);
begin
  FScreenColor := Value;
  self.Color := Value;

  InitGraph;
  Clear;
end;

procedure TfrmOscilloscope.setCh1Ofsett(const Value: integer);
begin
  FCh1Ofsett := Value;
  DrawBeam;
end;

procedure TfrmOscilloscope.setCh2Ofsett(const Value: integer);
begin
  FCh2Ofsett := Value;
  DrawBeam;
end;

procedure TfrmOscilloscope.setCh1On(const Value: Boolean);
begin
  FCh1On := Value;
  If Fch1On then DrawBeam;
end;

procedure TfrmOscilloscope.setCh2On(const Value: Boolean);
begin
  FCh2On := Value;
  if FCh2On then DrawBeam;
end;

procedure TfrmOscilloscope.setCh1Gnd(const Value: Boolean);
begin
  FCh1Gnd := Value;
  DrawBeam;
end;

procedure TfrmOscilloscope.setCh2Gnd(const Value: Boolean);
begin
  FCh2Gnd := Value;
  DrawBeam;
end;



procedure TfrmOscilloscope.DrawBeam;
begin
  Clear;

  //Channel 1
  if Ch1On then
  begin
    imgScreen.Canvas.Pen.Color:= FBeamC1Color;
    imgScreen.Canvas.Pen.Width:= FPenWidth;

    if Ch1Gnd then
    begin
      imgScreen.Canvas.MoveTo(0,FScreenCenter+Ch1Ofsett);
      imgScreen.Canvas.LineTo(imgScreen.Width,FScreenCenter+Ch1Ofsett);
    end;
  end;

  //Channel 2
  if Ch2On then
  begin
    imgScreen.Canvas.Pen.Color:= FBeamC2Color;
    imgScreen.Canvas.Pen.Width:= FPenWidth;
    if Ch2Gnd then
    begin
      imgScreen.Canvas.MoveTo(0,FScreenCenter+Ch2Ofsett);
      imgScreen.Canvas.LineTo(imgScreen.Width,FScreenCenter+Ch2Ofsett);
    end;
  end;

end;

procedure TfrmOscilloscope.DrawScale;
var
  loop:integer;
  h:integer;
  a,b:Word;
  HCenter,VCenter :integer;
  w:double;
begin

  h := image2.height div 8;
  w := Image2.Width/100;

  with Image2 do
  begin
    HCenter := FScreenCenter;
    VCenter := round(Image2.Width/2);

    Canvas.Pen.Width := 1;
    Canvas.Pen.Color := FScaleColor;

    //Horizontal line --------------------------------
    for loop:= 1 to 8 do
    begin
      Canvas.MoveTo(0,Loop*h);
      Canvas.LineTo(Width,Loop*h);
    end;

    for loop:= 1 to height div 4 do
    begin
      DivMod(loop,5,a,b);

      if b = 0 then
      begin
        Canvas.MoveTo(VCenter-4, Loop*4);
        Canvas.LineTo(VCenter+5, Loop*4);
      end
      else
      begin
        Canvas.MoveTo(VCenter-2, Loop*4);
        Canvas.LineTo(VCenter+3, Loop*4);
      end;
    end;

    //Vertical line -----------------------------
    for loop:= 1 to 9 do
    begin
      Canvas.MoveTo(round(Loop*w*10),0);
      Canvas.LineTo(round(Loop*w*10),height);
    end;

    for loop:= 1 to (width div 5) do
    begin
      DivMod(loop,5,a,b);
      if b = 0 then
      begin
        Canvas.MoveTo(round(Loop*w), HCenter-4);
        Canvas.LineTo(round(Loop*w), HCenter+5);
      end
      else
      begin
        Canvas.MoveTo(round(Loop*w),HCenter-2);
        Canvas.LineTo(round(Loop*w),HCenter+3);
      end
    end;

    //----------------------------------------------------------
    if FScreenColor = clBlack then
      Canvas.Font.Color := clgray
    else
      Canvas.Font.Color := clSilver;

    Canvas.Font.Name   := 'Small Fonts';
    Canvas.Font.Size   := 8;
    Canvas.Brush.Style := bsClear;
    Canvas.TextOut( 20,image2.Height-25,'(c) www.DelphiForFun.org');

  end; //with Image2

end;


procedure TfrmOscilloscope.BeamData(const Ch1Points, Ch2Points: array of TPoint);
begin
  Clear;

  //Channel 1
  if Ch1On then
  begin
    if FCh1Gnd then
    begin
      imgScreen.Canvas.Pen.Color := FBeamC1Color;
      imgScreen.Canvas.MoveTo(0,FScreenCenter+Ch1Ofsett);
      imgScreen.Canvas.LineTo(imgScreen.Width,FScreenCenter+Ch1Ofsett);
    end
    else
    begin
      imgScreen.Canvas.Pen.Color := FBeamC1Color;
      imgScreen.Canvas.Polyline(Ch1Points);
    end;
  end;

  //Channel 2
  if Ch2On then
  begin
    if FCh2Gnd then
    begin
      imgScreen.Canvas.Pen.Color := FBeamC2Color;
      imgScreen.Canvas.MoveTo(0,FScreenCenter+Ch2Ofsett);
      imgScreen.Canvas.LineTo(imgScreen.Width ,FScreenCenter+Ch2Ofsett);
    end
    else
    begin
      imgScreen.Canvas.Pen.Color := FBeamC2Color;
      imgScreen.Canvas.Polyline(Ch2Points);
    end;
  end;

  if assigned(FAfterBeamDraw) then
    FAfterBeamDraw(self);
end;



end.
