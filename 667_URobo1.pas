unit URobo1_maXbox;
{TrackEater - The robot eats the track as it follows it, adapt by max}

interface

{uses  #sign:Max: MAXBOX10: 18/05/2016 10:39:06 
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls; #locs:134
  @ProcessMessagesOFF;
 }
 
Const
  Maxpoints=1000;   {maximum track length}

var
  //TForm1 = class(TForm)
    Robo: TShape;
       procedure Paintbox1MouseDown(Sender: TObject; Button: TMouseButton;
         Shift: TShiftState; X, Y: Integer);
       procedure Paintbox1MouseMove(Sender: TObject; Shift: TShiftState; X,
         Y: Integer);
       procedure Paintbox1MouseUp(Sender: TObject; Button: TMouseButton;
         Shift: TShiftState; X, Y: Integer);
       procedure FormActivate(Sender: TObject);
       procedure StartBtnClick(Sender: TObject);
    { Private declarations }
    //public  { Public declarations }
    var Drawing:boolean; {Flag set by mousedown, tested Mousemove, reset by Mouseup}
        saved:array of TPoint; {saved track points}
        count:integer; {Current nbr of points}

var
  Form1: TForm;

implementation

//{$R *.DFM}

procedure FormActivate(Sender: TObject);
{Initialization}
begin
  drawing:= false;
  setLength(saved,Maxpoints);
  count:=0;
  form1.doublebuffered:=true;  {to prevent flicker}
  writeln('form activated call')
end;

procedure Paintbox1MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
{User pushed mouse button}
begin
  Drawing:= true;  {Set flag}
  form1.canvas.moveto(x,y);   {move pen position to the point}
  form1.canvas.pen.width:= 10;  {make a fairly wide track}
  form1.canvas.pen.color:= clred;
  inc(count);
  saved[count]:= point(x,y);
end;

procedure Paintbox1MouseMove(Sender: TObject; Shift: TShiftState; X,Y: Integer);
{Called when mouse moves}
begin
  If drawing then Begin
    form1.canvas.lineto(x,y);  {draw a line segment}
    sleep(10);           {wait 10 ms}
    inc(count);          {save the new point}
    saved[count]:=point(x,y);
  end;
end;

procedure Paintbox1MouseUp(Sender: TObject; Button: TMouseButton;
                                   Shift: TShiftState; X, Y: Integer);
{Called when mouse button is released}
begin
  Drawing:=false;  {stop drawing}
  Robo.left:=saved[1].x-Robo.Width div 2;  {move robot to start point}
  Robo.top:=saved[1].y-Robo.Height div 2;
end;

procedure StartBtnClick(Sender: TObject);
{Robot master clicked the start button}
var i:integer;
begin {Move the robot around the path}
  for i:= 2 to count do Begin
    Robo.left:=saved[i].x-Robo.width div 2;
    Robo.top:=saved[i].y-Robo.height div 2;
    application.processmessages;
    sleep(10);
  end;
  count:=0;
end;

procedure loadRoboform;
begin
  Form1:= TForm.create(self)
  with form1 do begin
     SetBounds(69,73,698,550)
     Caption:= 'Click and drag to draw a path, click Start to make Robo eat it'
     Color := clBlack; //clBtnFace
     Font.Charset := DEFAULT_CHARSET
     Show;
     //OnActivate := @FormActivate
     FormActivate(self)
     OnMouseDown := @Paintbox1MouseDown
     OnMouseMove := @Paintbox1MouseMove
     OnMouseUp := @Paintbox1MouseUp
     PixelsPerInch := 96
     //TextHeight(16)
    end; 
    Robo:= TShape.create(self)                                          
     with robo do begin
       parent:= form1
       setbounds(608,128,48,48)
       Brush.Color := clYellow
       Shape:= stCircle 
       Brush.Style:= bsCross;
     end;
     with TBitBtn.create(self) do begin
       parent:= form1          
       setBounds(535,36,120,55)
       glyph.LoadFromRes(HINSTANCE,'TAFTERMINAL'); // CL_MPSTOP');
       font.size:= 11
       Caption := 'Start Robo'
       OnClick := @StartBtnClick
     end;
  end;

begin  //main
  
  ProcessMessagesOFF;
  loadRoboform;

End.


//http://www.delphiforfun.org/Programs/Robotracker.htm

{She is repeatedly rescued, but always by men or by chance – she never escape catastrophe thanks to her own ingenuity. Plus, there are more unnecessary lingering shots of Bullock in her underwear than you’d find of models in a Pirelli calendar.

Gravity is not designed as a comedy, but at times it is difficult not to laugh. The most notable of these is the utterly ludicrous deus ex machina scene in which Stone’s dead colleague, played by George Clooney, appears in a hallucination and conveniently tells her exactly which buttons to press to escape, reminds her that life is worth living, and then disappears.

Even 1990s Steven Spielberg would be embarrassed by the level of sentimentality, and Steven Price’s this-is-where-you-cry score certainly doesn’t help in this regard.

No film since 2001: A Space Odyssey has so fully communicated the absoluteness of space — its impossible vastness, its obliterating void. Yet Gravity is existential in a real sense; there will be communing with distant alien brains. A marvel of filmmaking reach, it is a testament to what can be achieved with modern technologies set the challenge of putting the audience at the absolute centre of the most extreme jeopardy imaginable — to be adrift in space. The nearest thing, and Bullock helps the analogy, is the high-concept purity and vice-like grip of Speed. The story is consumed by the immediacy of its dilemma. How will they survive? 

http://www.themoviespoiler.com/Spoilers/Gravity.html}