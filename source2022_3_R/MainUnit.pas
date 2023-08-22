unit MainUnit;
{Demonstrates the functionality of the Graph3D-component.
Basically, you gotta create a set of TGraphline, which consist of arrays of
single. The points on these lines are assumed to be equally spaced between
StartPoint and StopPoint (see graph3D.pas).
These lines are then given to the Graph3D with AddLine(). Graph3D handles their
memory managment from here, so you should not free them yourself.

The procedure FillPlotSquare() initializes the Set of Graphlines (in the form
of a TList) and fills them with values.

Use rgMouse to decide how the Plot reacts to mouse-dragging, Right-click into
plot to start/stop scrolling the lines. cbIncScroll influences how the scrolling
takes place. Just play around a bit.
}
interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Spin, Grids, ExtCtrls, ComCtrls, Menus, Graph3D;

type
  TForm1 = class(TForm)
    Panel1: TPanel;
    btnCopy: TButton;
    cmdClear: TButton;
    GroupBox1: TGroupBox;
    ColorDialog1: TColorDialog;
    cmdDcolor: TPanel;
    cmdCentre: TButton;
    Mess: TMemo;
    cbAxes: TCheckBox;
    cmdAxesColor: TPanel;
    cbIncScroll: TCheckBox;
    cmdRead: TButton;
    p0: TPanel;
    p1: TPanel;  
    p2: TPanel;
    p3: TPanel;
    p4: TPanel;
    p5: TPanel;
    p6: TPanel;
    p7: TPanel;
    p8: TPanel;
    p9: TPanel;
    Button2: TButton;
    rgWaterlevel: TRadioGroup;
    edWater: TSpinEdit;
    Button3: TButton;
    cbUseColours: TCheckBox;
    cbHiddenLines: TCheckBox;

    cbInWhite: TCheckBox;
    PopupMenu1: TPopupMenu;
    Stop1: TMenuItem;
    rgMouse: TRadioGroup;
    edPercent: TSpinEdit;
    Label1: TLabel;
    procedure btnCopyClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure cmdClearClick(Sender: TObject);
    procedure cmdDcolorClick(Sender: TObject);
    procedure cmdCentreClick(Sender: TObject);
    procedure cmdAxesColorClick(Sender: TObject);
    procedure cmdReadClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure p0Click(Sender: TObject);
    procedure p1Click(Sender: TObject);
    procedure p2Click(Sender: TObject);
    procedure p3Click(Sender: TObject);
    procedure p4Click(Sender: TObject);
    procedure p5Click(Sender: TObject);
    procedure p6Click(Sender: TObject);
    procedure p7Click(Sender: TObject);
    procedure p8Click(Sender: TObject);
    procedure p9Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure rgWaterlevelClick(Sender: TObject);
    procedure cbAxesClick(Sender: TObject);
    procedure cbIncScrollClick(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure rgMouseClick(Sender: TObject);
    procedure cbUseColoursClick(Sender: TObject);
    procedure cbHiddenLinesClick(Sender: TObject);
    procedure PlotAfterDraw(Sender: TObject);
    procedure PlotScroll(Sender: TObject);
    procedure Stop1Click(Sender: TObject);
    procedure PlotStopScrolling(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure edPercentChange(Sender: TObject);
  private
    Array2D : TList; //of TGraphLines
    Plot: TGraph3D;
end;

var
  Form1: TForm1;

implementation
uses Unit2;

const NoOfLines = 88;
      NoOfPointsInLine = 88;
      Zmax = 1.1*(Sqr(NoOfPointsInLine div 2)+Sqr(NoOfLines div 2));

{$R *.DFM}

{------------------------------------------------------------------------------}
procedure FillPlotSquare;
var i,j : LongInt;
    a   : TGraphLine;
    f,g : Single;
    ptX, ptY : Single;
begin
  ptX := NoOfPointsInLine*0.25;
  ptY := NoOfLines*0.75;
  g := Sqr((NoOfPointsInLine / 4)) + Sqr((NoOfLines / 4)); //Sqr(radius of circle)
  For j := 0 to NoOfLines-1 do
  begin
    a := TGraphLine.Create(NoOfPointsInLine);
    a.StartPoint := Point3D(0,j,0);
    a.StopPoint  := Point3D(NoOfPointsInLine,j,0);
    For i := 0 to NoOfPointsInLine-1 do begin
      //basic square-func:
      a[i] := Zmax - Sqr(i-(NoOfPointsInLine div 2)) - Sqr(j-(NoOfLines div 2));//basic square-func.
      //add cone in one quadrant:
      f := Sqr(i-ptX) + Sqr(j-ptY); //Sqr(distance from quad.-centre)
      If f <= g then a[i] := a[i] + 5*(g-f);
    end;
    Form1.Array2D.Add(a);
  end;
end;

//form-stuff:------------------------------------------------------------------}
procedure TForm1.FormCreate(Sender: TObject);
var j : LongInt;
begin
  Plot := TGraph3D.Create(Form1);
  Plot.Parent := Form1;
  Plot.Align := alClient;
  Plot.AfterDraw := PlotAfterDraw;
  Plot.onScroll  := PlotScroll;
  Plot.OnStopScrolling := PlotStopScrolling;
  cmdReadClick(Self); //read options of the Graph3D
  //create and fill Array2D:
  Array2D := TList.Create;
  FillPlotSquare; //puts cute values into Array2D
  For j := 0 to Array2D.Count-1 do
    Plot.AddLine(TGraphLine(Array2D[j]));
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
{  for i := 0 to Array2D.Count-1 do
    TGraphLine(Array2D[i]).Free; NONSENSE, Plot3D takes care of this}
  Plot.Free;
  Array2D.Free;
end;

procedure TForm1.btnCopyClick(Sender: TObject);
begin
  with frmCopy do begin
    Image1.Picture.Bitmap.Assign(Plot.AsBitmap(cbInWhite.Checked));
    ShowModal;
  end;
end;

procedure TForm1.cmdClearClick(Sender: TObject);
begin
  Plot.ClearPicture;
end;

procedure TForm1.cmdDcolorClick(Sender: TObject);
begin
  If not ColorDialog1.Execute then Exit;
  cmdDcolor.Color := ColorDialog1.Color;
  Plot.DataColor := cmdDcolor.Color;
  Plot.Invalidate;
end;

procedure TForm1.cmdAxesColorClick(Sender: TObject);
begin
  If not ColorDialog1.Execute then Exit;
  cmdAxescolor.Color := ColorDialog1.Color;
  Plot.AxesColor := cmdAxescolor.Color;
  Plot.Invalidate;
end;

procedure TForm1.cmdReadClick(Sender: TObject);
begin
  cmdDcolor.Color    := Plot.DataColor;
  cmdAxesColor.Color := Plot.AxesColor;
  cbAxes.Checked     := Plot.DrawAxes;
  cbHiddenLines.Checked := Plot.drawHiddenLines;
  cbUseColours.Checked := Plot.UseColors;
  cbIncScroll.Checked := Plot.IncrementalScroll;
  rgWaterLevel.ItemIndex := Ord(Plot.WaterLevelType);
  edWater.Value          := Round(Plot.Waterlevel);
  edpercent.Value        := Plot.ViewPercentage;
end;

procedure TForm1.cmdCentreClick(Sender: TObject);
begin
  Plot.CenterPlot;
  Plot.Invalidate;
end;

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Plot.StopScrolling;
end;

procedure TForm1.p0Click(Sender: TObject);
begin
  If not ColorDialog1.Execute then Exit;
  p0.Color := ColorDialog1.Color;
  Plot.SetIsodose(0,5,p0.Color);
end;

procedure TForm1.p1Click(Sender: TObject);
begin
  If not ColorDialog1.Execute then Exit;
  p1.Color := ColorDialog1.Color;
  Plot.SetIsodose(0,15,p1.Color);
end;

procedure TForm1.p2Click(Sender: TObject);
begin
  If not ColorDialog1.Execute then Exit;
  p2.Color := ColorDialog1.Color;
  Plot.SetIsodose(0,25,p2.Color);
end;

procedure TForm1.p3Click(Sender: TObject);
begin
  If not ColorDialog1.Execute then Exit;
  p3.Color := ColorDialog1.Color;
  Plot.SetIsodose(0,35,p3.Color);
end;

procedure TForm1.p4Click(Sender: TObject);
begin
  If not ColorDialog1.Execute then Exit;
  p4.Color := ColorDialog1.Color;
  Plot.SetIsodose(0,45,p4.Color);
end;

procedure TForm1.p5Click(Sender: TObject);
begin
  If not ColorDialog1.Execute then Exit;
  p5.Color := ColorDialog1.Color;
  Plot.SetIsodose(0,55,p5.Color);
end;

procedure TForm1.p6Click(Sender: TObject);
begin
  If not ColorDialog1.Execute then Exit;
  p6.Color := ColorDialog1.Color;
  Plot.SetIsodose(0,65,p6.Color);
end;

procedure TForm1.p7Click(Sender: TObject);
begin
  If not ColorDialog1.Execute then Exit;
  p7.Color := ColorDialog1.Color;
  Plot.SetIsodose(0,75,p7.Color);
end;

procedure TForm1.p8Click(Sender: TObject);
begin
  If not ColorDialog1.Execute then Exit;
  p8.Color := ColorDialog1.Color;
  Plot.SetIsodose(0,85,p8.Color);
end;

procedure TForm1.p9Click(Sender: TObject);
begin
  If not ColorDialog1.Execute then Exit;
  p9.Color := ColorDialog1.Color;
  Plot.SetIsodose(0,95,p9.Color);
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  Plot.SetIsodose(0,5,p0.Color);
  Plot.SetIsodose(1,15,p1.Color);
  Plot.SetIsodose(2,25,p2.Color);
  Plot.SetIsodose(3,35,p3.Color);
  Plot.SetIsodose(4,45,p4.Color);
  Plot.SetIsodose(5,55,p5.Color);
  Plot.SetIsodose(6,65,p6.Color);
  Plot.SetIsodose(7,75,p7.Color);
  Plot.SetIsodose(8,85,p8.Color);
  Plot.SetIsodose(9,95,p9.Color);
  Plot.Invalidate;
end;

procedure TForm1.rgWaterlevelClick(Sender: TObject);
begin
  case rgWaterlevel.ItemIndex of
    0 : Plot.SetWaterlevel(wlNone,edWater.Value);
    1 : Plot.SetWaterlevel(wlAbove,edWater.Value);
    2 : Plot.SetWaterlevel(wlBelow,edWater.Value);
  end;
  case rgWaterlevel.ItemIndex of
    1 : Plot.SetIsodose(9,edWater.Value,clNone);
    2 : Plot.SetIsodose(9,edWater.Value,clNone);
  end;
end;

procedure TForm1.cbAxesClick(Sender: TObject);
begin
  Plot.DrawAxes := cbAxes.Checked;
end;

procedure TForm1.cbIncScrollClick(Sender: TObject);
begin
  Plot.IncrementalScroll := cbIncScroll.Checked;
end;

procedure TForm1.Button3Click(Sender: TObject);
var border : Single;
    i      : Byte;
begin
  case rgWaterlevel.ItemIndex of
     0 : Exit;
     1 : Border := edwater.Value+0.5;
     2 : Border := edwater.Value-0.5;
  end;
  For i := 0 to 9 do
    Plot.SetIsodose(i,Border,clWhite);
  Plot.SetIsodose(9,Border,clBlack);
end;

procedure TForm1.rgMouseClick(Sender: TObject);
begin
  case rgMouse.ItemIndex of
    0 : Plot.MouseControl := mcNone;
    1 : Plot.MouseControl := mcRotate;
    2 : Plot.MouseControl := mcMove;
    3 : Plot.MouseControl := mcZoom;
  end;
end;

procedure TForm1.cbUseColoursClick(Sender: TObject);
begin
  Plot.UseColors := cbUseColours.Checked;
end;

procedure TForm1.cbHiddenLinesClick(Sender: TObject);
begin
  plot.DrawHiddenLines := cbHiddenLines.Checked;
end;

procedure TForm1.PlotAfterDraw(Sender: TObject);
begin
  If mess.lines.Count > 100 then mess.Clear;
  Mess.Lines.Add(IntToStr(Mess.Lines.Count)+': AfterDraw');
end;

procedure TForm1.PlotScroll(Sender: TObject);
begin
  If mess.lines.Count > 100 then mess.Clear;
  Mess.Lines.Add(IntToStr(Mess.Lines.Count)+': Scrolled line '+IntToStr(Plot.ScrollIndex));
end;

procedure TForm1.Stop1Click(Sender: TObject);
begin
  If Plot.IsScrolling
    then plot.stopscrolling
    else plot.ScrollLines;
end;

procedure TForm1.PlotStopScrolling(Sender: TObject);
begin
  If mess.lines.Count > 100 then mess.Clear;
  Mess.Lines.Add(IntToStr(Mess.Lines.Count)+': AfterScroll');
end;

procedure TForm1.FormShow(Sender: TObject);
begin
  cmdReadClick(Self);
end;

procedure TForm1.edPercentChange(Sender: TObject);
begin
  Plot.ViewPercentage := edPercent.value;
  Plot.Invalidate;
end;

end.
