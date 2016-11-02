unit ageUnit1_maXbox_Version;

interface

{uses   #sign:Max: MAXBOX10: 18/05/2016 08:50:36 
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ExtCtrls;  #locs:516
  #sign:Max: MAXBOX10: 18/05/2016 08:50:36 
 }
 
//type
  //TForm1 = class(TForm)
  var yearedit: TEdit;
    Label1: TLabel;
    searchBtn: TBitBtn;
    msgLabel: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    PaintBox1: TPaintBox;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label8: TLabel;
    eraseBtn: TBitBtn;
    panstep: TPanel;
    solutionstot: integer;
       procedure searchBtnClick(Sender: TObject);
       procedure yeareditKeyPress(Sender: TObject; var Key: Char);
       procedure FormPaint(Sender: TObject);
       procedure PaintBox1Paint(Sender: TObject);
       procedure FormActivate(Sender: TObject);
       procedure FormKeyDown(Sender: TObject; var Key: Word;
         Shift: TShiftState);
       procedure eraseBtnClick(Sender: TObject);
     //private
    { Private declarations }
  //public
    { Public declarations }
  //end;

var
  Form1: TForm;

implementation

//{$R *.dfm}

type TSolution = record
                   birthyear : word;
                   age : byte;
                   birthdaypassed : boolean;
                  end;

const startyear = 1900;
      solutionsperdisplay = 10;
      maxsolution = 20;
      //columns = (10,85,190,290);
      ymarge = 10;
      fontheight = 24;
      fontname = 'arial';
      fontcolor = $000000;
      message1 = 'enter current year + <RETURN> or click SEARCH button';

var thisyear : word;
    solutions : array[1..maxsolution] of TSolution;
    solutionNr : byte;
    columns : array[0..3] of word; // = (10,85,190,290);

procedure clearpaintbox;
begin
 with PaintBox1 do
  with canvas do begin
    brush.Style := bsSolid;
    brush.color := $ffffff;
    fillrect(rect(5,5,width-3,height-3));
   end;
end;

function sumdigits(year : word) : byte;
var s : string;
    i : byte;
begin
 s := inttostr(year);
 result:= 0;
 for i:= 1 to length(s) do result:= result + ord(s[i]) - ord('0');
end;

procedure saveSolution(ag,by:word; bp:boolean);
//save solution in array
//ag:age; by:birth year; bp:birthday passed
begin
 inc(solutionNr);
 if solutionNr <= solutionsperdisplay then
  with solutions[solutionNr] do begin
    birthyear := by;
    age := ag;
    birthdaypassed := bp;
   end; 
  //solutionstot:= solutionNr; 
end;

procedure showSolutions;
//display solutions in paintbox1
var i,n : byte;
    s : string;
    x,y : word;
begin
 clearpaintbox;
 with PaintBox1.Canvas do begin
   brush.style := bsClear;
   font.Color := fontcolor;
   font.Name := fontname;
   font.Height := fontheight;
   for n := 1 to solutionNr do
    if n <= solutionsperdisplay then begin
      y := (n-1)*fontheight + ymarge;
      for i := 0 to 3 do begin
        x := columns[i];
        case i of
         0 : s := inttostr(n);
         1 : s := inttostr(solutions[n].birthyear);
         2 : s := inttostr(solutions[n].age);
         3 : if solutions[n].birthdaypassed then s := 'yes' else s := 'no';
        end;//case
        textout(x,y,s);
        panstep.caption:= inttostr(solutionNr)+' solutions';
       end;
     end;//for..if
     solutionstot:= solutionNr;
     //if solu
     //form1.invalidate;
     //formpaint(self)
  end;//width
end;

procedure searchBtnClick(Sender: TObject);
var digitsum : byte;
    birthyear : word;
begin
 solutionNr := 0;
 if yearEdit.Text = '' then begin
   msglabel.Caption := 'no year specified';
   exit;
  end;

 thisyear:= strtoint(yearEdit.text);
 if thisyear < startyear then begin
   msglabel.Caption := 'year may not be smaller than ' + inttostr(startyear);
   exit;
  end;

 for birthyear := startyear to thisyear do begin
   digitsum := sumdigits(birthyear);
   if digitsum = thisyear - birthyear then
     saveSolution(digitsum,birthyear,true);
   if digitsum = thisyear - birthyear - 1 then
     saveSolution(digitsum,birthyear,false);
  end; //for
 showSolutions;
 case solutionNr of
  0 : msglabel.Caption := 'no solution';
  1 : msglabel.Caption := '1 solution found';
  else msglabel.Caption := inttostr(solutionNr) + ' solutions found';
 end;//case 
end;

procedure searchRoutine(start: string);
var digitsum : byte;
    birthyear,n : word;
begin
 solutionNr := 0;
 thisyear:= strtoint(start);
 
  for it:= 1 to 150 do begin
    thisyear:= thisyear + 1;
    solutionnr:= 0;
    for birthyear := startyear to thisyear do begin
      digitsum := sumdigits(birthyear);
      if digitsum = thisyear - birthyear then
        saveSolution(digitsum,birthyear,true);
      if digitsum = thisyear - birthyear - 1 then
        saveSolution(digitsum,birthyear,false);
    end; //for
     //showSolutions;
     case solutionNr of
      0 : msglabel.Caption := 'no solution';
      1 : msglabel.Caption := '1 solution found';
      else begin 
        msglabel.Caption := inttostr(solutionNr) + ' solutions found';
        n:= 0;
        for n := 1 to solutionnr do begin
          writeln('sol: '+inttostr(n) +' of  '+inttostr(thisyear));
          PrintF('birth %d - age %d ',[solutions[n].birthyear,solutions[n].age]);
          //writeln(3: if solutions[n].birthdaypassed then s:= 'yes' else s:= 'no';
        end; 
       writeln('Solutions tot of '+inttostr(thisyear)+': '+inttostr(solutionnr));
       writeln(' ');   
      end;
     end;//case 
     if solutionnr > solutionstot then 
       solutionstot:= solutionnr;
  end; //for
  writeln('Solutions All Max: '+inttostr(solutionstot));
end;


procedure yeareditKeyPress(Sender: TObject; var Key: Char);
begin
 //if not (key in ['0','1'..'9',#08]) then key := #0;
   //regex   x43=C
   if not ExecRegExpr('^[\d\x08\x43]+$',key) then key:=#0;
end;

procedure FormPaint(Sender: TObject);
//paint frame around paintbox1
var x1,y1,x2,y2 : word;
    i : byte;
begin
 with paintbox1 do begin
   x1 := left-2+12;
   x2 := left+width+6;
   y1 := top-2+12;
   y2 := top+height+6;
  end;
 with form1.canvas do
  for i := 0 to 1 do begin
    pen.color := $000000;
    moveto(x2-i,y1+i);
    lineto(x1+i,y1+i);
    lineto(x1+i,y2-i);
    pen.color := $808080;
    lineto(x2-i,y2-i);
    lineto(x2-i,y1+i);
   end;
   //writeln('debug: form paint')
end;

procedure PaintBox1Paint(Sender: TObject);
begin
 clearpaintbox;
 showSolutions;
end;

procedure FormActivate(Sender: TObject);
begin
 form1.left := 100;
 form1.top := 100;
 msglabel.Caption := message1;
 columns[0]:=10; columns[1]:=85;
 columns[2]:=190; columns[3]:=290;
end;

procedure FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
//<return> starts search process
begin
 if key = VK_RETURN then begin
   key:= 0;
   searchBtnClick(self);
  end;
end;

procedure eraseBtnClick(Sender: TObject);
begin
 clearpaintbox;
 yearEdit.Text := '';
 msglabel.Caption := message1;
end;

procedure btnCloseClick(Sender: TObject);
begin
  //stat.SimpleText:= 'Closed Clicked';
  writeln('closed and freed');
  form1.Close;
end;


//*************************Form Create********************************//
procedure InitCreateForms;
var i: smallint;
    panImg, panR: TPanel;
      Image1: TImage;
  drG: TDrawGrid;
  frmsg: TStringGrid;
  stat: TStatusbar;
  //panstep: TPanel;
  Progress: TProgressBar;

begin
 // seq --> panel-image-drawgrid-bitmap
  //panimg1.DoubleBuffered:= true;
  
  PaintBox1:= TPaintBox.create(form1);

 form1:= TForm.Create(self);
 with form1 do begin
   //FormStyle := fsStayOnTop;
  Left:= 1178
  Top:= 126
  BorderIcons:= [biSystemMenu, biMinimize]
  BorderStyle:= bsSingle
  ClientHeight:= 500
  ClientWidth:= 427
  Color:= clBtnFace
  Font.Charset:= ANSI_CHARSET
  Font.Color:= clWindowText
  Font.Height:= -13
  Font.Name:= 'Arial'
  Font.Style:= []
  KeyPreview:= True
  OldCreateOrder:= False
  //OnActivate = FormActivate
  OnKeyDown:= @FormKeyDown;
  OnPaint:= @FormPaint;
  //onClose:= @CloseClick;
  PixelsPerInch:= 96
  //TextHeight = 16
  Position:= poScreenCenter;
   caption:='Age Puzzle PascalPicturePuzzle of BITMAX';
   //color:= clblue;
   width:= 650;
   height:= 540;
   Show;
   //onClose:= @CloseClick;
 end;
 
  msgLabel:= TLabel.Create(form1)
   with msgLabel do begin
    parent:= form1;
    setBounds(8,464,401,24)
    //BevelOuter:= bvLowered
    //DoubleBuffered:= true;
    autosize:= false;
   end;  


 panImg:= TPanel.Create(form1)
   with panImg do begin
    parent:= form1;
    setBounds(8,8,451,451)
    BevelOuter:= bvLowered
    //DoubleBuffered:= true;
   end;  

 //PaintBox1:= TPaintBox.create(form1);
 with PaintBox1 do begin
   parent:= panImg;
   setbounds(10,126, 400,321);
   //show;
    OnPaint:= @PaintBox1Paint;
 end;
 
  yearedit:= TEdit.create(form1);
  with yearedit do begin
    parent:= form1
    setbounds(344,52, 70, 27);
    Font.Charset:= ANSI_CHARSET
    Font.Color:= clBlack
    Font.Height:= -16
    Font.Name:= 'Arial'
    Font.Style:= [fsBold]
    MaxLength:= 4
    ParentFont:= False
    TabOrder:= 0
    OnKeyPress:= @yeareditKeyPress
  end;
  
   with TLabel.create(self) do begin
      parent:= form1
      font.color:= clnavy;
      font.height:= 18;
      setbounds(22,25,250,40)
    Caption:= 'Someones age is equal to the sum'+CRLF+
               'of the digits of his/her birthday.'+CRLF+    
               'Find out what this age is.';
  end;
  
   with TLabel.create(self) do begin
      parent:= form1
      setbounds(345,30,64,16)
    Caption:= 'Current year';
  end;
 
   with TLabel.create(self) do begin
      parent:= form1
      setbounds(107,110,54,16)
    Caption:= 'birth year';
  end;
  
   with TLabel.create(self) do begin
      parent:= form1
      setbounds(209,110,21,16)
    Caption:= 'age';
  end;
   with TLabel.create(self) do begin
      parent:= form1
      setbounds(308,110,100,16)
    Caption:= 'birthday (passed)';
  end;
  
   with TLabel.create(self) do begin
      parent:= form1
      setbounds(28,110,45,16)
    Caption:= 'solution';
  end;
 
 drG:= TDrawGrid.Create(form1);
   with drG do begin
      parent:= panImg;
      Left:= 0; Top:= 0;
      Width:= 455; Height:= 455;
      Cursor:= crHandPoint;
      ColCount:= 4;
      DefaultColWidth:= 111;
      DefaultRowHeight:= 111
      FixedCols:= 0;
      RowCount:= 4;
      FixedRows:= 0;
      Options:= [goFixedVertLine,goFixedHorzLine,goVertLine,goHorzLine];
      ScrollBars:= ssNone;
      Visible:= False;
      //OnClick:= @drGClick;
      //OnDrawCell:= @drGDrawCell;
    end;
    PanR:= TPanel.create(form1);
    with PanR do begin
      parent:= form1;
      setBounds(472,9,155,450);
      BevelOuter:= bvLowered
      TabOrder:= 1
    end;
    with TBitBtn.Create(form1) do begin
      Parent:= form1;        
      SetBounds(488,30,121,30)        //30
      Caption:= 'Search Solution'
      Hint:= 'Search your own bitmap picture!';
      ShowHint:= true;
      glyph.LoadFromResourceName(getHINSTANCE,'CL_MPEJECT'); 
      OnClick:= @searchBtnClick;
      //OnClick:= @BtnPictureLoad;
    end;
    with TBitBtn.Create(form1) do begin
      Parent:= form1;        
      SetBounds(488,68,121,30)       //68
      glyph.LoadFromResourceName(getHINSTANCE,'CL_MPSTEP'); 
      Caption:= 'New Game'
      //Enabled:= False
      //TabOrder = 7
      OnClick:= @eraseBtnClick
    end;
    with TBitBtn.Create(form1) do begin
      Parent:= form1;        
      SetBounds(488,420,121,30)
      glyph.LoadFromResourceName(getHINSTANCE,'CL_MPSTOP'); 
      Caption:= 'Close'
      OnClick:= @btnCloseClick
    end;
    panstep:= TPanel.Create(form1); 
    with panstep do begin
      Parent:= form1;        
      SetBounds(488,120,121,25)
      BevelOuter:= bvLowered
      Caption:= '0 %'
      Color:= clyellow;//$30809000;
      //Color:= 8404992
    end;
   frmsg:= TStringGrid.Create(form1);
   with frmsg do begin
    //SetBounds(512,320,79,79)  
     parent:= form1;
     Left:= 512; Top:= 320;
     Width:= 79; Height:= 79;
     ColCount:= 4
     DefaultColWidth:= 18
     DefaultRowHeight:= 18
     FixedCols:= 0
     RowCount:= 4
     FixedRows:= 0
     color:= clyellow;
     //editormode
     //font
     //GridLineWidth
     //options
     //borderstyle
     //ondblclick
     //anchors
     //selection
   end;
  with TJvAnalogClock.Create(form1) do begin 
    parent:= PanR;
    bevelwidth:= 0;
    colormin:= clblue;
    //timeoffSet:= -60;
    align:= alclient;
    ColorHr:= clblack;
    //WidthHandHr:= 1;
    ColorHandHr:= clRed;
    ColorHandMin:= clRed;
    setBounds(28,5,100,100);
    //centercol:= clyellow; //cldarkblue32; //clwebgold; 
    //centersize:= 8;
  end; 
  
  FormActivate(self)
end;   


begin  //main

 initcreateforms;
 yearedit.text:= '2015';
 searchBtnClick(self)
 searchRoutine('1925')

End.

{Ref:
  Blaise Pascal Magazine 44
 }

{object Form1: TForm1
  Left = 1178
  Top = 126
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'age puzzle'
  ClientHeight = 500
  ClientWidth = 427
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Arial'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  OnActivate = FormActivate
  OnKeyDown = FormKeyDown
  OnPaint = FormPaint
  PixelsPerInch = 96
  TextHeight = 16
  object Label1: TLabel
    Left = 336
    Top = 8
    Width = 69
    Height = 16
    Caption = 'current year'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
  end
  object msgLabel: TLabel
    Left = 8
    Top = 464
    Width = 401
    Height = 24
    AutoSize = False
  end
  object Label5: TLabel
    Left = 8
    Top = 8
    Width = 200
    Height = 16
    Caption = 'someones age is equal to the sum'
  end
  object Label6: TLabel
    Left = 8
    Top = 24
    Width = 177
    Height = 16
    Caption = 'of the digits of his/her birthday.'
  end
  object Label7: TLabel
    Left = 8
    Top = 40
    Width = 141
    Height = 16
    Caption = 'find out what this age is.'
  end
  object PaintBox1: TPaintBox
    Left = 10
    Top = 128
    Width = 400
    Height = 321
    OnPaint = PaintBox1Paint
  end
  object Label2: TLabel
    Left = 200
    Top = 104
    Width = 21
    Height = 16
    Caption = 'age'
  end
  object Label3: TLabel
    Left = 100
    Top = 104
    Width = 54
    Height = 16
    Caption = 'birth year'
  end
  object Label4: TLabel
    Left = 300
    Top = 104
    Width = 100
    Height = 16
    Caption = 'birthday (passed)'
  end
  object Label8: TLabel
    Left = 20
    Top = 104
    Width = 45
    Height = 16
    Caption = 'solution'
  end
  object yearedit: TEdit
    Left = 336
    Top = 32
    Width = 65
    Height = 27
    Font.Charset = ANSI_CHARSET
    Font.Color = clBlack
    Font.Height = -16
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    MaxLength = 4
    ParentFont = False
    TabOrder = 0
    OnKeyPress = yeareditKeyPress
  end
  object searchBtn: TBitBtn
    Left = 328
    Top = 64
    Width = 75
    Height = 25
    Caption = 'search'
    Font.Charset = ANSI_CHARSET
    Font.Color = clGreen
    Font.Height = -19
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 1
    OnClick = searchBtnClick
  end
  object eraseBtn: TBitBtn
    Left = 248
    Top = 64
    Width = 60
    Height = 25
    Caption = 'erase'
    Font.Charset = ANSI_CHARSET
    Font.Color = clRed
    Font.Height = -19
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 2
    OnClick = eraseBtnClick
  end
end  }




