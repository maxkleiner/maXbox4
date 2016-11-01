unit MainUnit3DGraph;
{Demonstrates the functionality of the Graph3D-component.
Basically, you gotta create a set of TGraphline, which consist of arrays of
single. The points on these lines are assumed to be equally spaced between
StartPoint and StopPoint (see graph3D.pas).
These lines are then given to the Graph3D with AddLine(). Graph3D handles their
memory managment from here, so you should not free them yourself.

The procedure FillPlotSquare() initializes a Set of Graphlines (in the form
of a TList) and fills them with values.
adapt to maXbox script engine by mX4
#sign:Max: MAXBOX10: 15/10/2016 10:17:26 

  //TODO: check the free of the objectlist mem leak!
  
Use rgMouse to decide how the Plot reacts to mouse-dragging, Right-click into
plot to start/stop scrolling the lines. cbIncScroll influences how the scrolling
takes place. #locs:908
}
interface

{uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Spin, Grids, ExtCtrls, ComCtrls, Menus, Graph3D;
 }
 
//type
  var
  //TForm1 = class(TForm)
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
       procedure TForm1_btnCopyClick(Sender: TObject);
       procedure TForm1_FormDestroy(Sender: TObject);
       procedure TForm1_FormCreate(Sender: TObject);
       procedure TForm1_cmdClearClick(Sender: TObject);
       procedure TForm1_cmdDcolorClick(Sender: TObject);
       procedure TForm1_cmdCentreClick(Sender: TObject);
       procedure TForm1_cmdAxesColorClick(Sender: TObject);
       procedure TForm1_cmdReadClick(Sender: TObject);
       procedure TForm1_FormClose(Sender: TObject; var Action: TCloseAction);
       procedure TForm1_p0Click(Sender: TObject);
       procedure TForm1_p1Click(Sender: TObject);
       procedure TForm1_p2Click(Sender: TObject);
       procedure TForm1_p3Click(Sender: TObject);
       procedure TForm1_p4Click(Sender: TObject);
       procedure TForm1_p5Click(Sender: TObject);
       procedure TForm1_p6Click(Sender: TObject);
       procedure TForm1_p7Click(Sender: TObject);
       procedure TForm1_p8Click(Sender: TObject);
       procedure TForm1_p9Click(Sender: TObject);
       procedure TForm1_Button2Click(Sender: TObject);
       procedure TForm1_rgWaterlevelClick(Sender: TObject);
       procedure TForm1_cbAxesClick(Sender: TObject);
       procedure TForm1_cbIncScrollClick(Sender: TObject);
       procedure TForm1_Button3Click(Sender: TObject);
       procedure TForm1_rgMouseClick(Sender: TObject);
       procedure TForm1_cbUseColoursClick(Sender: TObject);
       procedure TForm1_cbHiddenLinesClick(Sender: TObject);
       procedure TForm1_PlotAfterDraw(Sender: TObject);
       procedure TForm1_PlotScroll(Sender: TObject);
       procedure TForm1_Stop1Click(Sender: TObject);
       procedure TForm1_PlotStopScrolling(Sender: TObject);
       procedure TForm1_FormShow(Sender: TObject);
       procedure TForm1_edPercentChange(Sender: TObject);
  //private
    var
    //Array2D : TIntegerList; //of TGraphLines
    Array2D : TObjectList; //of TGraphLines
    Zmax: single; // = 1.1; //*(Sqr(NoOfPointsInLine div 2)+Sqr(NoOfLines div 2));
    Plot: TGraph3D;
//end;               

var
  Form1: TForm;

implementation
//uses Unit2;

const NoOfLines = 88;
      NoOfPointsInLine = 88;
    //  Zmax = 1.1; //*(Sqr(NoOfPointsInLine div 2)+Sqr(NoOfLines div 2));

//{$R *.DFM}

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
  For j := 0 to NoOfLines-1 do begin
    a := TGraphLine.Create(NoOfPointsInLine);
    a.StartPoint := Point3D3(0,j,0);
    a.StopPoint  := Point3D3(NoOfPointsInLine,j,0);
    For i := 0 to NoOfPointsInLine-1 do begin
      //basic square-func:
      a[i] := Zmax - Sqr(i-(NoOfPointsInLine div 2)) - Sqr(j-(NoOfLines div 2));
      //basic square-func.
      //add cone in one quadrant:
      f := Sqr(i-ptX) + Sqr(j-ptY); //Sqr(distance from quad.-centre)
      If f <= g then a[i] := a[i] + 5*(g-f);
    end;
    Array2D.Add(a);
  end;
end;

//form-stuff:------------------------------------------------------------------}
procedure TForm1_FormCreate(Sender: TObject);
begin
  Zmax:= 1.1*(Sqr(NoOfPointsInLine div 2)+Sqr(NoOfLines div 2));
  Plot := TGraph3D.Create(Form1);
  Plot.Parent := Form1;
  Plot.Align := alClient;
  Plot.AfterDraw := @TForm1_PlotAfterDraw;
  Plot.onScroll  := @TForm1_PlotScroll;
  //plot.onclick
  Plot.OnStopScrolling := @TForm1_PlotStopScrolling;
  TForm1_cmdReadClick(Self); //read options of the Graph3D
  //create and fill Array2D:
  //Array2D := TIntegerList.Create;
  Array2D := TObjectList.Create;
  FillPlotSquare; //puts cute values into Array2D
  For it:= 0 to Array2D.Count-1 do
    Plot.AddLine(TGraphLine(Array2D[it]));
end;


procedure letBuildTestForm;
var RS : TResourceStream;
  image1, image2: TImage;
  chk1, chk2: TCheckbox;
begin
 Form1:= TForm.create(self)
 with form1 do begin
  setBounds(192,333,740,510)
  Caption:= 'Dice Simulation 2016'
  FormStyle:= fsstayonTop;
  Color:= clGreen; //clBtnFace
  Font.Charset:= DEFAULT_CHARSET; Font.Color:= clWindowText;
  Font.Height:= -11; Font.Name:= 'MS Sans Serif';
  Font.Style:= []
  OldCreateOrder:= False
  Position:= poScreenCenter
  //OnActivate:= @TForm1_FormActivate;
  PixelsPerInch:= 96
  //TextHeight(13)
  Show;
 end;
  Image1:= TImage.create(form1)
  with image1 do begin
    parent:= form1;
    transparent:= true;
    setBounds(580,228,249,113)
   Picture.Bitmap.LoadFromResourcename(HInstance,'JV_DICE5');    
  end;
  Image2:= TImage.create(form1)
  with image2 do begin
    parent:= form1;
    transparent:= true;
    //RS:= TResourceStream.Create(HInstance,'Splashscreen_Background', RT_RCDATA);   
    setBounds(580,50,249,113)
    Picture.Bitmap.LoadFromResourcename(HInstance,'JV_DICE6');
  end;
  
  with TGraph3D.create(self) do begin
  parent:= form1;
    //transparent:= true;
//RS:= TResourceStream.Create(HInstance,'Splashscreen_Background', RT_RCDATA);      
    setBounds(80,50,480,400)
    //Picture.Bitmap.LoadFromResourcename(HInstance,'JV_DICE6');
  end;  
  
  {DrawDiceBtn:= TBitBtn.create(form1);
   with DrawDiceBtn do begin
     parent:= form1;
     font.size:= 12; //font.style:= [fsbold]
     setBounds(80,15,220,36)
     Caption:= '&Draw pair random dice'
     glyph.LoadFromResourceName(getHINSTANCE,'LED_GREEN_ON'); 
     TabOrder:= 0
    // OnClick:= @TForm1_DrawDiceBtnClick;
    // onMouseDown:= @TForm1_MouseDownClick;
    // onMouseUp:= @TForm1_MouseUpClick;
   end;
   SimuDiceBtn:= TBitBtn.create(form1);
   with SimuDiceBtn do begin
     parent:= form1;
     font.size:= 12; //font.style:= [fsbold]
     setBounds(80,65,220,36)
     Caption:= '&Run same pair of dice'
     glyph.LoadFromResourceName(getHINSTANCE,'AQUA'); 
     TabOrder:= 1
     OnClick:= @TForm1_MouseClickSim
   end;
   end; }
   chk1:= TCheckbox.create(form1);
   with chk1 do begin
     parent:= form1;
     caption:= 'P(n)=6/36';
     font.color:= clRed;
     setBounds(8,65,70,22)
   end;  
   chk2:= TCheckbox.create(form1);
   with chk2 do begin
     parent:= form1;
     caption:= 'P(n)=1/36';
     font.color:= clRed;
     setBounds(8,115,70,22)
   end;  
end;


procedure TForm1_FormDestroy(Sender: TObject);
begin
  {for it:= 0 to Array2D.Count-1 do
    TGraphLine(Array2D[it]).Free;     }
    //NONSENSE, Plot3D takes care of this}
  Plot.Free;
  Array2D.Free;
  writeln('plot frame and object graph line list freeed')
end;

{Unit 2}

 var ScrollBox1: TScrollBox;
    Image1: TImage;
    frmcopy: TForm;
    
procedure TfrmCopy_FormShow(Sender: TObject);
begin
  Image1.Width := Image1.Picture.Bitmap.Width;
  Image1.Height := Image1.Picture.Bitmap.Height;
end;

procedure build_Frmcopy;
begin    
 frmCopy:= TForm.create(self)
 Image1:= TImage.create(self)
 with frmcopy do begin
  setbounds(200, 108, 696,593)
  Caption:= 'frmCopy'
  Font.Charset:= DEFAULT_CHARSET
  Font.Color:= clWindowText
  Font.Height:= -11
  Font.Name:= 'MS Sans Serif'
  Font.Style:= []
  Position:= poScreenCenter
  OnShow:= @TfrmCopy_FormShow
  PixelsPerInch:= 96
  //TextHeight:= 13
  end;
  ScrollBox1:= TScrollBox.create(self)
  with scrollbox1 do begin
    parent:= frmCopy;
    setBounds(0,0,688,566)
    Align:= alClient
    TabOrder:= 0
  end;  
    Image1:= TImage.create(self)
    with image1 do begin
      parent:= scrollbox1
      setbounds(0,0,429,341)
    end;
  //end
end;


procedure TForm1_btnCopyClick(Sender: TObject);
begin
  //Image1:= TImage.create(self)
  build_Frmcopy;
  with frmCopy do begin
    Image1.Picture.Bitmap.Assign(Plot.AsBitmap(cbInWhite.Checked));
    ShowModal;
  end;
  frmCopy.Free;
end;
    
 
procedure TForm1_cmdClearClick(Sender: TObject);
begin
  Plot.ClearPicture;
end;

procedure TForm1_cmdDcolorClick(Sender: TObject);
begin
  If not ColorDialog1.Execute then Exit;
  cmddcolor.ParentBackground:= false;
  cmdDcolor.Color := ColorDialog1.Color;
  Plot.DataColor := cmdDcolor.Color;
  Plot.Invalidate;
end;

procedure TForm1_cmdAxesColorClick(Sender: TObject);
begin
  If not ColorDialog1.Execute then Exit;
  cmdAxescolor.Color := ColorDialog1.Color;
  Plot.AxesColor := cmdAxescolor.Color;
  Plot.Invalidate;
end;

procedure TForm1_cmdReadClick(Sender: TObject);
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

procedure TForm1_cmdCentreClick(Sender: TObject);
begin
  Plot.CenterPlot;
  Plot.Invalidate;
end;

procedure TForm1_FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Plot.StopScrolling;
  writeln('form plot close...')
  //TForm1_FormDestroy(self);
  //action:= cafree;
  Plot.Free;
  form1.Free;
end;

procedure TForm1_p0Click(Sender: TObject);
begin
  If not ColorDialog1.Execute then Exit;
  p0.Color := ColorDialog1.Color;
  Plot.SetIsodose(0,5,p0.Color);
end;

procedure TForm1_p1Click(Sender: TObject);
begin
  If not ColorDialog1.Execute then Exit;
  p1.Color := ColorDialog1.Color;
  Plot.SetIsodose(0,15,p1.Color);
end;

procedure TForm1_p2Click(Sender: TObject);
begin
  If not ColorDialog1.Execute then Exit;
  p2.Color := ColorDialog1.Color;
  Plot.SetIsodose(0,25,p2.Color);
end;

procedure TForm1_p3Click(Sender: TObject);
begin
  If not ColorDialog1.Execute then Exit;
  p3.Color := ColorDialog1.Color;
  writeln('debug color isodose: '+itoa(p3.color))
  Plot.SetIsodose(0,35,p3.Color);
end;

procedure TForm1_p4Click(Sender: TObject);
begin
  If not ColorDialog1.Execute then Exit;
  p4.Color := ColorDialog1.Color;
  Plot.SetIsodose(0,45,p4.Color);
end;

procedure TForm1_p5Click(Sender: TObject);
begin
  If not ColorDialog1.Execute then Exit;
  p5.Color := ColorDialog1.Color;
  Plot.SetIsodose(0,55,p5.Color);
end;

procedure TForm1_p6Click(Sender: TObject);
begin
  If not ColorDialog1.Execute then Exit;
  p6.Color := ColorDialog1.Color;
  Plot.SetIsodose(0,65,p6.Color);
end;

procedure TForm1_p7Click(Sender: TObject);
begin
  If not ColorDialog1.Execute then Exit;
  p7.Color := ColorDialog1.Color;
  Plot.SetIsodose(0,75,p7.Color);
end;

procedure TForm1_p8Click(Sender: TObject);
begin
  If not ColorDialog1.Execute then Exit;
  p8.Color := ColorDialog1.Color;
  Plot.SetIsodose(0,85,p8.Color);
end;

procedure TForm1_p9Click(Sender: TObject);
begin
  If not ColorDialog1.Execute then Exit;
  p9.Color := ColorDialog1.Color;
  Plot.SetIsodose(0,95,p9.Color);
end;

procedure TForm1_Button2Click(Sender: TObject);
begin
   plot.ParentBackground:= false;
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

procedure TForm1_rgWaterlevelClick(Sender: TObject);
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

procedure TForm1_cbAxesClick(Sender: TObject);
begin
  Plot.DrawAxes := cbAxes.Checked;
end;

procedure TForm1_cbIncScrollClick(Sender: TObject);
begin
  Plot.IncrementalScroll := cbIncScroll.Checked;
end;

procedure TForm1_Button3Click(Sender: TObject);
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

procedure TForm1_rgMouseClick(Sender: TObject);
begin
  case rgMouse.ItemIndex of
    0 : Plot.MouseControl := mcNone;
    1 : Plot.MouseControl := mcRotate;
    2 : Plot.MouseControl := mcMove;
    3 : Plot.MouseControl := mcZoom;
  end;
end;

procedure TForm1_cbUseColoursClick(Sender: TObject);
begin
  Plot.UseColors := cbUseColours.Checked;
end;

procedure TForm1_cbHiddenLinesClick(Sender: TObject);
begin
  plot.DrawHiddenLines := cbHiddenLines.Checked;
end;

procedure TForm1_PlotAfterDraw(Sender: TObject);
begin
  If mess.lines.Count > 100 then mess.Clear;
  Mess.Lines.Add(IntToStr(Mess.Lines.Count)+': AfterDraw');
end;

procedure TForm1_PlotScroll(Sender: TObject);
begin
  If mess.lines.Count > 100 then mess.Clear;
  Mess.Lines.Add(IntToStr(Mess.Lines.Count)+': Scrolled line '+IntToStr(Plot.ScrollIndex));
end;

procedure TForm1_Stop1Click(Sender: TObject);
begin
  If Plot.IsScrolling
    then plot.stopscrolling
    else plot.ScrollLines;
end;

procedure TForm1_PlotStopScrolling(Sender: TObject);
begin
  If mess.lines.Count > 100 then mess.Clear;
  Mess.Lines.Add(IntToStr(Mess.Lines.Count)+': AfterScroll');
end;

procedure TForm1_FormShow(Sender: TObject);
begin
  TForm1_cmdReadClick(Self);
end;

procedure TForm1_edPercentChange(Sender: TObject);
begin
  Plot.ViewPercentage := edPercent.value;
  Plot.Invalidate;
end;

procedure Tform1_btnsaveclick(Sender: TObject);
  //Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  //if( ssRight in Shift ) then begin
  //  Image1.Picture.Bitmap.Assign(Plot.AsBitmap(cbInWhite.Checked));

    with TImage.create(self) do begin
      setbounds(0,0,429,341)
      Picture.Bitmap.Assign(Plot.AsBitmap(cbInWhite.Checked));
    //form1.canvas.Assign(Plot.AsBitmap(cbInWhite.Checked));
      SaveCanvas2(Canvas, Exepath+'3d_processingimage.png');
     Free;
   end;
  opendoc(Exepath+'3d_processingimage.png');
  
end;  


Procedure PanelFactory(a,b,c,d: byte; title: shortstring; acolor: TColor;
                        tord: byte;  var apan: TPanel; anevent: TNotifyEvent);
begin
  apan:= TPanel.create(self)
  with apan do begin
    parent:= groupbox1;
    if length(title) < 4 then
      ParentBackground:= false;
    SetBounds(a,b,c,d)
    Caption:= title;
    color:= acolor
    taborder:= tord;
    OnClick:= anevent as TNotifyEvent;
  end;
end;

    
procedure main3DGraphForm;
begin
 Form1:= TForm.create(self)
 with form1 do begin
  setBounds(306,115,780,543)
  Caption:= 'maXbox TGraph3D 2016 V2'
  Font.Charset:= DEFAULT_CHARSET
  Font.Color:= clWindowText
  Font.Height:= -11
  Font.Name:= 'MS Sans Serif'
  Font.Style:= []
  Position:= poScreenCenter
  OnClose:= @TForm1_FormClose
  OnCreate:= @TForm1_FormCreate
  OnDestroy:= @TForm1_FormDestroy
  OnShow:= @TForm1_FormShow
  PixelsPerInch:= 96
  //TextHeight:= 13
  //Show;
  end;
  
  //TForm1_FormCreate(Self);
  Panel1:= TPanel.create(form1)
  with panel1 do begin
    parent:= form1
    setBounds(0,0,650,37)
    Align:= alTop
    TabOrder:= 0
  end; 
    btnCopy:= TButton.create(form1)
    with btncopy do begin  
      parent:= panel1
      setBounds(476,8,75,25)
      Caption:= 'copy plot'
      TabOrder:= 0
      OnClick:= @Tform1_btnCopyClick
    end;
    cmdClear:= TButton.create(form1)
    with cmdclear do begin  
      parent:= panel1
      setbounds(8,8,75,25)
      Caption:= 'Clear plot'
      TabOrder:= 1
      OnClick:= @tform1_cmdClearClick
    end;
    cmdCentre:= TButton.create(form1)
    with cmdCentre do begin  
      parent:= panel1
      setbounds(88,8,81,25)
      Caption:= 'Centre'
      TabOrder:= 2
      OnClick:= @tform1_cmdCentreClick
    end;
    cbInWhite:= TCheckBox.create(form1)
    with cbInWhite do begin  
      parent:= panel1
      setbounds(556,12,77,17)
      Caption:= 'cbInWhite'
      TabOrder:= 3
    end;
    with TButton.create(form1) do begin
      parent:= panel1
      setBounds(650,8,75,25)
      Caption:= 'save plot'
      TabOrder:= 0
      OnClick:= @Tform1_btnsaveClick
    end;
   
    rgMouse:= TRadioGroup.create(form1)
    with rgmouse do begin
      parent:= panel1
      setbounds(180,0,289,33)
      Caption:= 'rgMouse'
      Columns:= 4
      Items.add('none'); Items.add('rotate');
      Items.add('pan'); Items.add('zoom');
      ItemIndex:= 1
      TabOrder:= 4
      OnClick:= @tform1_rgMouseClick
      //tform1_rgMouseClick(self);
    end;
  //end  panel1
  GroupBox1:= TGroupBox.create(form1)
  with groupbox1 do begin
    parent:= form1
    setbounds(0,37,153,479)
    Align:= alLeft
    Caption:= 'Options'
    TabOrder:= 1
  end; 
  
 // writeln('dome') 
    Label1:= TLabel.create(form1)
    with label1 do begin
      parent:= groupbox1
      setbounds(104,240,34,13)
      Caption:= 'View-%'
    end;
    Mess:= TMemo.create(self)
    with mess do begin
      parent:= groupbox1
      setbounds(2,284,149,189)
      Lines.add('Mess')
      ScrollBars:= ssVertical
      TabOrder:= 1
    end;
    cbAxes:= TCheckBox.create(form1)
    with cbaxes do begin
      parent:= groupbox1
      setbounds(4,248,61,17)
      Caption:= 'cbAxes'
      State:= cbChecked
      TabOrder:= 2
      OnClick:= @tform1_cbAxesClick
    end;
    cmdAxesColor:= TPanel.create(form1)
    with cmdaxescolor do begin
      parent:= groupbox1
      setbounds(4,44,75,25)
      Caption:= 'cmdAxesColor'
      Color:= clRed
      TabOrder:= 3
      OnClick:= @tform1_cmdAxesColorClick
    end;
    cbIncScroll:= TCheckBox.create(form1)
    with cbincscroll do begin
      parent:= groupbox1
      setbounds(4,264,77,17)
      Caption:= 'cbIncScroll'
      State:= cbChecked
      TabOrder:= 4
      OnClick:= @tform1_cbIncScrollClick
    end;
    cmdRead:= TButton.create(self)
    with cmdread do begin
      parent:= groupbox1
      setbounds(108,12,41,21)
      Caption:= 'Read'
      TabOrder:= 5
      OnClick:= @tform1_cmdReadClick
    end;
    
    PanelFactory(4,16,75,25,'cmdDcolor',clred,0,cmddcolor, 
                            @tform1_cmdDcolorClick);
     //cmddcolor.color:= clred;
  //  TForm1_FormCreate(Self);
   //Procedure PanelFactory(a,b,c,d: byte; title: shortstring; acolor: TColor;
     //                   tord: byte;  var apan: TPanel; anevent: TNotifyEvent);
   //ParentBackground:= false;
    
    PanelFactory(4,72,25,25,'p0',clred,6,p0,  @tform1_p0Click);
    PanelFactory(28,72,25,25,'p1',clyellow,7,p1,  @tform1_p1Click);
   PanelFactory(52,72,25,25,'p2',clMaroon,8,p2,  @tform1_p2Click);
   PanelFactory(4,96,25,25,'p3',clYellow,9,p3,  @tform1_p3Click);
   PanelFactory(28,96,25,25,'p4',clMaroon,10,p4,  @tform1_p4Click);
   PanelFactory(52,96,25,25,'p5',clyellow,11,p5,  @tform1_p5Click);
   PanelFactory(4,120,25,25,'p6',clmaroon,12,p6,  @tform1_p6Click);
   PanelFactory(28,120,25,25,'p7',clYellow,13,p7,  @tform1_p7Click);
   PanelFactory(52,120,25,25,'p8',clYellow,14,p8,  @tform1_p8Click);
   PanelFactory(76,120,25,25,'p9',10485760,15,p9,  @tform1_p9Click);

    Button2:= TButton.create(form1);
    with button2 do begin
      parent:= groupbox1
      setbounds(80,72,69,25)
      Caption:= 'set colors'
      TabOrder:= 16
      OnClick:= @tform1_Button2Click
    end;
    rgWaterlevel:= TRadioGroup.create(form1)
    with rgWaterlevel do begin
      parent:= groupbox1
      setbounds(4,152,77,61)
      Caption:= 'rgWaterlevel'
      ItemIndex:= 0
      Items.add('none')
      items.add('above')
      items.add('below')
      TabOrder:= 17
      OnClick:= @tform1_rgWaterlevelClick
    end;
    edWater:= TSpinEdit.create(form1)
    with edwater do begin
      parent:= groupbox1
      setbounds(84,180,41,22)
      MaxValue:= 100
      MinValue:= 0
      TabOrder:= 18
      Value:= 95
    end;
    Button3:= TButton.create(form1)
    with button3 do begin
      parent:= groupbox1
      setbounds(84,156,61,25)
      Caption:= 'opt. colors'
      TabOrder:= 19
      OnClick:= @tform1_Button3Click
    end;
    cbUseColours:= TCheckBox.create(form1)
    with cbusecolours do begin
      parent:= groupbox1
      setbounds(4,216,97,17)
      Caption:= 'cbUseColours'
      State:= cbChecked
      TabOrder:= 20
      OnClick:= @tform1_cbUseColoursClick
    end;
    cbHiddenLines:= TCheckBox.create(form1)
    with cbhiddenlines do begin
      parent:= groupbox1
      setbounds(4,232,97,17)
      Caption:= 'cbHiddenLines'
      State:= cbChecked
      TabOrder:= 21
      OnClick:= @tform1_cbHiddenLinesClick
    end;
    edPercent:= TSpinEdit.create(form1)
    with edpercent do begin
      parent:= groupbox1
      setbounds(104,256,41,22)
      MaxValue:= 100
      MinValue:= 0
      TabOrder:= 22
      Value:= 95
      OnChange:= @tform1_edPercentChange
    end;
  //end groupbox1
  
    TForm1_FormCreate(Self);
    form1.show
 
  ColorDialog1:= TColorDialog.create(form1);
    with colordialog1 do begin
    //parent:= form1
    Ctl3D:= True
    //Left:= 112
    //Top:= 141
  end;
   Stop1:= TMenuItem.create(form1)
    with stop1 do begin
      Caption:= 'Start/Stop'
      OnClick:= @tform1_Stop1Click
     end;
  popupMenu1:= TPopupMenu.create(form1)
  with popupmenu1 do begin
    Items.Add(stop1);
    //Top:= 184
  end;  
    //form1.popupmenu:= popupmenu1;  
   groupbox1.popupmenu:= popupmenu1;  
   {selected1:= TMenuItem.Create(popupmenu1)
    with selected1 do begin
      popupmenu1.Items.Add(selected1);
      Caption:= 'Selected / RSelected';
      OnClick:= @TDBFrm_Selected1Click;
    end;
    N1:= TMenuItem.Create(popupmenu1)
    with N1 do begin
      popupmenu1.Items.Add(N1);
      Caption:= '-';
    end;}
   //end
 end;


procedure TestGraphline;
{example: }
      var Line : TGraphLine;
          i : LongInt;
      begin
        Line:= TGraphLine.Create(10);
        //init values:
        For i := 0 to 9 do
          Line[i] := Sqr(i-5);
        //set direction of this line: (here in X-dir at Y=12.1)
        Line.StartPoint := Point3D3(0, 12.1, 0); //Z anyway gets ignored
        Line.StopPoint := Point3D3(100, 12.1, 0);
        //now display all values as 3D-points:
        For i := 0 to Line.NoOfValues-1 do
            //ShowMessage('x,y '+FormatFloat('0.0',Line.X[i])+' '+
              //               FormatFloat('0.0', Line.Y[i]));
        
          writeln('x,y,z: '+FormatFloat('0.0',Line.X[i])+
                           ', '+FormatFloat('0.0', Line.Y[i])+
                            ', '+FormatFloat('0.0', Line.x[i]));
    line.Free;
   end;
  //end;   

   procedure preparechessBoard;
   var kt: byte;
      line: string;
   begin
     line:= 'ABCDEFGH';
     for it:= 8 downto 1 do 
       for kt:= 1 to 8 do begin
          write(line[kt]+itoa(it))
          if kt=8 then writeln('')
       end;    
     end; 

   procedure preparechessBoard2;
   var kt: byte;
      line: string;
   begin
     line:= 'ABCDEFGH'+CRLF;
     for it:= 8 downto 1 do 
       for kt:= 1 to 9 do 
          write(line[kt]+itoa(it))
     end; 


begin  //main

  //letBuildForm;
  TestGraphline;
  
  main3DGraphForm;
  
  tform1_rgMouseClick(self);

  //TForm1_FormCreate(Self);
  //preparechessBoard;
   //preparechessBoard2;

End.

{//Possible values for TGraph3D.WaterLevel
  TWaterlevel = (wlNone, wlAbove, wlBelow);

//Basic class for one line of a 2D-array of values.
//Defined in this way to allow both dimensions to be set at runtime.
TGraphLine = Class(TObject)
   Private
     fNoOfValues : LongInt;
     fValues     : PSingleArray; //assumption: equally spaced
     procedure SetVal(Index: Integer; V:Single);
     function GetVal(Index: Integer) : Single;
     function GetX(Index: Integer) : Single;
     function GetY(Index: Integer) : Single;
   Public
     //Each line can start and stop anywhere on the XY-plane.
     //The X/Y-values are interpolated linearly between StartPoint and StopPoint.
     //Z-coord gets ignored here.
     StartPoint : T3DPoint;
     //Each line can start and stop anywhere on the XY-plane.
     //The X/Y-values are interpolated linearly between StartPoint and StopPoint.
     //V-coord gets ignored here.
     StopPoint : T3DPoint;
     //Read-only property to see how many values are are in this line.
     //Gets set in Create
     property NoOfValues : LongInt read fNoOfValues;
     //Reads/writes the Z values of the points in the line.
     //See also: X,Y
     {example:
      var Line : TGraphLine;
          i : LongInt;
      begin
        Line := TGraphLine.Create(10);
        //init values:
        For i := 0 to 9 do
          Line[i] := Sqr(i-5);
        //set direction of this line: (here in X-dir at Y=12.1)
        Line.StartPoint := Point3D(0, 12.1, 0); //Z anyway gets ignored
        Line.StopPoint := Point3D(100, 12.1, 0);
        //now display all values as 3D-points:
        For i := 0 to Line.NoOfValues-1 do
          ShowMessage('x,y,z: '+FormatFloat('0.0',Line.X[i])+
                           ', '+FormatFloat('0.0', Line.Y[i]+
                                ForamtFloat('0.0', Line[i]));
      end;
     }
   (*  property Vals[Index: Integer]: Single read GetVal write SetVal; default;
     //Reads/writes the X-values of the points in the line
     //See also: Y, Vals (which contains an example of how to use these properties)
     property X[Index: Integer]: Single read GetX;
     //Reads/writes the Y-values of the points in the line
     //See also: X, Vals (which contains an example of how to use these properties)
     property Y[Index: Integer]: Single read GetY;
     //Standard constructor for a TGraphLine.
     //Once and for all sets the NoOfValues
     constructor Create(Nvals : LongInt);
     //Frees the line and all points in it
     destructor Destroy; override;
end;

type
{A component for displaying arrays of values as a net.
     *)
 //   LoadDFMFile2Strings('C:\Program Files (x86)\maxbox3\Import\grph3d01\MainUnit.dfm', dfmlist,wastext);
    
     
  (*
  object Form1: TForm1
  Left = 306
  Top = 115
  Width = 658
  Height = 543
  Caption = 'Form1'
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Position = poScreenCenter
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 650
    Height = 37
    Align = alTop
    TabOrder = 0
    object btnCopy: TButton
      Left = 476
      Top = 8
      Width = 75
      Height = 25
      Caption = 'copy plot'
      TabOrder = 0
      OnClick = btnCopyClick
    end
    object cmdClear: TButton
      Left = 8
      Top = 8
      Width = 75
      Height = 25
      Caption = 'Clear plot'
      TabOrder = 1
      OnClick = cmdClearClick
    end
    object cmdCentre: TButton
      Left = 88
      Top = 8
      Width = 81
      Height = 25
      Caption = 'Centre'
      TabOrder = 2
      OnClick = cmdCentreClick
    end
    object cbInWhite: TCheckBox
      Left = 556
      Top = 12
      Width = 77
      Height = 17
      Caption = 'cbInWhite'
      TabOrder = 3
    end
    object rgMouse: TRadioGroup
      Left = 180
      Top = 0
      Width = 289
      Height = 33
      Caption = 'rgMouse'
      Columns = 4
      ItemIndex = 0
      Items.Strings = (
        'none'
        'rotate'
        'pan'
        'zoom')
      TabOrder = 4
      OnClick = rgMouseClick
    end
  end
  object GroupBox1: TGroupBox
    Left = 0
    Top = 37
    Width = 153
    Height = 479
    Align = alLeft
    Caption = 'Options'
    TabOrder = 1
    object Label1: TLabel
      Left = 104
      Top = 240
      Width = 34
      Height = 13
      Caption = 'View-%'
    end
    object cmdDcolor: TPanel
      Left = 4
      Top = 16
      Width = 65
      Height = 25
      Caption = 'cmdDcolor'
      Color = clBlue
      TabOrder = 0
      OnClick = cmdDcolorClick
    end
    object Mess: TMemo
      Left = 2
      Top = 284
      Width = 149
      Height = 189
      Lines.Strings = (
        'Mess')
      ScrollBars = ssVertical
      TabOrder = 1
    end
    object cbAxes: TCheckBox
      Left = 4
      Top = 248
      Width = 61
      Height = 17
      Caption = 'cbAxes'
      State = cbChecked
      TabOrder = 2
      OnClick = cbAxesClick
    end
    object cmdAxesColor: TPanel
      Left = 4
      Top = 44
      Width = 65
      Height = 25
      Caption = 'cmdAxesColor'
      Color = clRed
      TabOrder = 3
      OnClick = cmdAxesColorClick
    end
    object cbIncScroll: TCheckBox
      Left = 4
      Top = 264
      Width = 77
      Height = 17
      Caption = 'cbIncScroll'
      State = cbChecked
      TabOrder = 4
      OnClick = cbIncScrollClick
    end
    object cmdRead: TButton
      Left = 108
      Top = 12
      Width = 41
      Height = 21
      Caption = 'Read'
      TabOrder = 5
      OnClick = cmdReadClick
    end
    object p0: TPanel
      Left = 4
      Top = 72
      Width = 25
      Height = 25
      Caption = 'p0'
      Color = clRed
      TabOrder = 6
      OnClick = p0Click
    end
    object p1: TPanel
      Left = 28
      Top = 72
      Width = 25
      Height = 25
      Caption = 'p1'
      Color = clYellow
      TabOrder = 7
      OnClick = p1Click
    end
    object p2: TPanel
      Left = 52
      Top = 72
      Width = 25
      Height = 25
      Caption = 'p2'
      Color = clMaroon
      TabOrder = 8
      OnClick = p2Click
    end
    object p3: TPanel
      Left = 4
      Top = 96
      Width = 25
      Height = 25
      Caption = 'p3'
      Color = clYellow
      TabOrder = 9
      OnClick = p3Click
    end
    object p4: TPanel
      Left = 28
      Top = 96
      Width = 25
      Height = 25
      Caption = 'p4'
      Color = clMaroon
      TabOrder = 10
      OnClick = p4Click
    end
    object p5: TPanel
      Left = 52
      Top = 96
      Width = 25
      Height = 25
      Caption = 'p5'
      Color = clYellow
      TabOrder = 11
      OnClick = p5Click
    end
    object p6: TPanel
      Left = 4
      Top = 120
      Width = 25
      Height = 25
      Caption = 'p6'
      Color = clMaroon
      TabOrder = 12
      OnClick = p6Click
    end
    object p7: TPanel
      Left = 28
      Top = 120
      Width = 25
      Height = 25
      Caption = 'p7'
      Color = clYellow
      TabOrder = 13
      OnClick = p7Click
    end
    object p8: TPanel
      Left = 52
      Top = 120
      Width = 25
      Height = 25
      Caption = 'p8'
      Color = clMaroon
      TabOrder = 14
      OnClick = p8Click
    end
    object p9: TPanel
      Left = 76
      Top = 120
      Width = 25
      Height = 25
      Caption = 'p9'
      Color = 10485760
      TabOrder = 15
      OnClick = p9Click
    end
    object Button2: TButton
      Left = 76
      Top = 72
      Width = 69
      Height = 25
      Caption = 'set colors'
      TabOrder = 16
      OnClick = Button2Click
    end
    object rgWaterlevel: TRadioGroup
      Left = 4
      Top = 152
      Width = 77
      Height = 61
      Caption = 'rgWaterlevel'
      ItemIndex = 0
      Items.Strings = (
        'none'
        'above'
        'below')
      TabOrder = 17
      OnClick = rgWaterlevelClick
    end
    object edWater: TSpinEdit
      Left = 84
      Top = 180
      Width = 41
      Height = 22
      MaxValue = 100
      MinValue = 0
      TabOrder = 18
      Value = 95
    end
    object Button3: TButton
      Left = 84
      Top = 156
      Width = 61
      Height = 25
      Caption = 'opt. colors'
      TabOrder = 19
      OnClick = Button3Click
    end
    object cbUseColours: TCheckBox
      Left = 4
      Top = 216
      Width = 97
      Height = 17
      Caption = 'cbUseColours'
      State = cbChecked
      TabOrder = 20
      OnClick = cbUseColoursClick
    end
    object cbHiddenLines: TCheckBox
      Left = 4
      Top = 232
      Width = 97
      Height = 17
      Caption = 'cbHiddenLines'
      State = cbChecked
      TabOrder = 21
      OnClick = cbHiddenLinesClick
    end
    object edPercent: TSpinEdit
      Left = 104
      Top = 256
      Width = 41
      Height = 22
      MaxValue = 100
      MinValue = 0
      TabOrder = 22
      Value = 95
      OnChange = edPercentChange
    end
  end
  object ColorDialog1: TColorDialog
    Ctl3D = True
    Left = 112
    Top = 141
  end
  object PopupMenu1: TPopupMenu
    Left = 324
    Top = 184
    object Stop1: TMenuItem
      Caption = 'Start/Stop'
      OnClick = Stop1Click
    end
  end
end
*)   
